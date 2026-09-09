
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = { -1, -1, -1 }
local g_GemItemID = { -1, -1, -1 }

local g_ProductID = -1

local g_NeedItemPos = -1
local g_NeedItemID = -1
local g_NeedItemID2 = -1

local g_NeedMoney = 0

local g_NotifyBind = 1

local g_GemMelting_GemItemCtrList = {}

local ObjCaredID = -1


function GemMelting_PreLoad()

	this:RegisterEvent("UPDATE_GEMMELTING");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")		--交子普及 Vega
end

function GemMelting_OnLoad()

	g_GemMelting_GemItemCtrList[1] = GemMelting_GemItem1
	g_GemMelting_GemItemCtrList[2] = GemMelting_GemItem2
	g_GemMelting_GemItemCtrList[3] = GemMelting_GemItem3

end

function GemMelting_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 112237) then

		local xx = Get_XParam_INT(0);
		ObjCaredID = DataPool : GetNPCIDByServerID(xx);
		if ObjCaredID == -1 then
			PushDebugMessage("server传过来的数据有问题。");
			return
		end
		BeginCareObject_GemMelting()

		GemMelting_Clear()
		this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return
		end
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemMelting_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		local NumArg0 = tonumber(arg0)
		if g_GemItemPos[1] == NumArg0 then
			Resume_Equip_GemMelting(1)
		elseif g_GemItemPos[2] == NumArg0 then
			Resume_Equip_GemMelting(2)
		elseif g_GemItemPos[3] == NumArg0 then
			Resume_Equip_GemMelting(3)
		elseif g_NeedItemPos == NumArg0 then
			Resume_Equip_GemMelting(4)
		end

	elseif( event == "UPDATE_GEMMELTING") then

		if arg0 == nil or arg1 == nil then
			return
		end
		GemMelting_Update(tonumber(arg0),tonumber(arg1));

	elseif( event == "UNIT_MONEY") then

		GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	elseif( event == "MONEYJZ_CHANGE") then

		GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )   --交子普及 Vega

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		local NumArg0 = tonumber(arg0)
		if NumArg0 == 61 then
			Resume_Equip_GemMelting(1)
		elseif NumArg0 == 62 then
			Resume_Equip_GemMelting(2)
		elseif NumArg0 == 63 then
			Resume_Equip_GemMelting(3)
		elseif NumArg0 == 64 then
			Resume_Equip_GemMelting(4)
		end

	end

end

--=========================================================
--重置界面
--=========================================================
function GemMelting_Clear()

	for i = 1, 3 do
		if(g_GemItemPos[i] ~= -1) then
			LifeAbility : Lock_Packet_Item(g_GemItemPos[i],0);
		end
	end

	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end

	for i = 1, 3 do
		g_GemMelting_GemItemCtrList[i]:SetActionItem(-1)
	end

	GemMelting_State:SetText("")
	GemMelting_ProductItem:SetActionItem(-1)

	GemMelting_NeedItem:SetToolTip("")
	GemMelting_NeedItem:SetActionItem(-1)
		
	GemMelting_NeedMoney:SetProperty("MoneyNumber", "")
	GemMelting_CurrentMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")) )
	GemMelting_CurrentJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")) )   --交子普及 Vega

	for i = 1, 3 do
		g_GemItemPos[i] = -1
	end

	for i = 1, 3 do
		g_GemItemID[i] = -1
	end

	g_ProductID = -1;

	g_NeedItemPos = -1;
	g_NeedItemID = -1;
	g_NeedItemID2 = -1;

	g_NeedMoney = 0;

	g_NotifyBind = 1

	GemMelting_ProductItem:Hide();
	GemMelting_Accept:Disable();

end

--=========================================================
--更新界面
--=========================================================
function GemMelting_Update( pos_ui, pos_packet )

	-- pos_ui
	-- 1 = 玩家向第1个宝石格子拖放宝石....
	-- 2 = 玩家向第2个宝石格子拖放宝石....
	-- 3 = 玩家向第3个宝石格子拖放宝石....
	-- 4 = 玩家向需求物品的格子拖放需求物品....
	-- 0 = 玩家在背包中右键点击宝石....需要自动寻找空格将该宝石放到界面上....

	if pos_ui == 0 or pos_ui == 1 or pos_ui == 2 or pos_ui == 3 then
		GemMelting_UpdateGemItem( pos_ui, pos_packet )
	elseif pos_ui == 4 then
		GemMelting_UpdateNeedItem( pos_ui, pos_packet )
	end

end

--=========================================================
--更新宝石格子
--=========================================================
function GemMelting_UpdateGemItem( pos_ui, pos_packet )

	--是否加锁....
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end

	--必须是宝石....
	local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
	if Item_Class ~= 5 then
		PushDebugMessage("#{JKBS_081021_006}")
		return
	end

	--必须是同类型宝石....
	local bErrorType = 0
	local CurGemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
	for i = 1, 3 do
		if g_GemItemPos[i] ~= -1 and CurGemItemID ~= PlayerPackage:GetItemTableIndex( g_GemItemPos[i] ) then
			bErrorType = 1
		end
	end

	if bErrorType == 1 then
		PushDebugMessage("#{JKBS_081022_002}")
		return
	end


	--获取熔炼的信息....
	local CurProductID = -1
	local CurNeedItemID = -1
	local CurNeedMoney = 0
	local CurNeedItemID2 = -1
	CurProductID, CurNeedItemID, CurNeedMoney, CurNeedItemID2 = GemMelting:GetGemMeltingInfo( CurGemItemID )
	if -1 == CurProductID then
		PushDebugMessage("#{JKBS_081021_007}")
		return
	end


	--计算目标格子....
	local TargetPos = -1
	if pos_ui == 0 then
		for i = 3, 1, -1 do
			if g_GemItemPos[i] == -1 then
				TargetPos = i
			end
		end	
	else
		TargetPos = pos_ui
	end

	if -1 == TargetPos then
		--PushDebugMessage("！！！已经放满了你还放！！！")
		return
	end


	--更新目标宝石格的Action....
	local theAction = EnumAction(pos_packet, "packageitem");
	if theAction:GetID() == 0 then
		return
	end

	if g_GemItemPos[TargetPos] ~= -1 then
		LifeAbility : Lock_Packet_Item(g_GemItemPos[TargetPos],0)
	end

	g_GemItemPos[TargetPos] = pos_packet
	LifeAbility : Lock_Packet_Item(g_GemItemPos[TargetPos],1);
	g_GemMelting_GemItemCtrList[TargetPos]:SetActionItem(theAction:GetID());


	--检测是否已经放满了3个宝石....
	local bAllSet = 1
	for i = 1, 3 do
		if g_GemItemPos[i] == -1 then
			bAllSet = 0
		end
	end


	--如果放满了宝石则需要显示产物....
	if bAllSet == 1 and g_ProductID ~= CurProductID then

		g_ProductID = CurProductID

		--设置产物Action....
		GemMelting_State : SetText("熔炼后的产物：")
		GemMelting_ProductItem:Show()
		local ProductAction = GemMelting:UpdateProductAction( g_ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemMelting_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemMelting_ProductItem:SetActionItem(-1);
		end

	end


	--如果放满了宝石则需要设置所需物品....
	if bAllSet == 1 then
		g_NeedItemID = CurNeedItemID
		g_NeedItemID2 = CurNeedItemID2
		local needItem = "#{BSRL_90512_11}#{_ITEM"..g_NeedItemID.."}"
		if(g_NeedItemID2 ~=-1 ) then
			needItem = needItem.."或者#{_ITEM"..g_NeedItemID2.."}"
		end
		GemMelting_NeedItem:SetToolTip(needItem)
		--GemMelting_NeedItem:SetToolTip("#{BSRL_90512_11}#{_ITEM"..g_NeedItemID.."}")
	end


	--如果放满了宝石则需要显示所需钱数....
	if bAllSet == 1 then
		g_NeedMoney = CurNeedMoney
		GemMelting_NeedMoney : SetProperty("MoneyNumber", tostring(g_NeedMoney))
	end


end


--=========================================================
--更新熔炼符格子
--=========================================================
function GemMelting_UpdateNeedItem( pos_ui, pos_packet )

	--是否加锁....
	if PlayerPackage:IsLock(pos_packet) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end


	--检测是否已经放满了3个宝石....
	local bAllSet = 1
	for i = 1, 3 do
		if g_GemItemPos[i] == -1 then
			bAllSet = 0
		end
	end
	if bAllSet ~= 1 then
		PushDebugMessage("#{JKBS_081022_001}")
		return
	end


	--是否是需要的物品....
	if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID and PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID2 then
		local needItem = "#{JKBS_081021_010}#{_ITEM"..g_NeedItemID.."}"
		if(g_NeedItemID2 ~=-1 ) then
			needItem = needItem.."或者#{_ITEM"..g_NeedItemID2.."}"
		end
		PushDebugMessage(needItem)
		--PushDebugMessage("#{JKBS_081021_010}#{_ITEM"..g_NeedItemID.."}")
		return
	end


	--更新需求物品格的Action....
	local theAction = EnumAction(pos_packet, "packageitem");
	if theAction:GetID() == 0 then
		return
	end

	if g_NeedItemPos ~= -1 then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0)
	end

	g_NeedItemPos = pos_packet;
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 1 )
	GemMelting_NeedItem:SetActionItem(theAction:GetID())


	--启用熔炼按钮....
	GemMelting_Accept:Enable()
	g_NotifyBind = 1


end

--=========================================================
--清除ActionButton
--=========================================================
function Resume_Equip_GemMelting( nIndex )

	--如果是移除宝石格子里的宝石....
	if nIndex == 1 or nIndex == 2 or nIndex == 3 then

		--清除该宝石....
		LifeAbility:Lock_Packet_Item( g_GemItemPos[nIndex], 0 )
		g_GemMelting_GemItemCtrList[nIndex]:SetActionItem(-1)
		g_GemItemPos[nIndex] = -1

		--如果所有宝石都被拿掉了....则直接清理界面....
		local bAllRemove = 1
		for i = 1, 3 do
			if g_GemItemPos[i] ~= -1 then
				bAllRemove = 0
			end
		end
		if bAllRemove == 1 then
			GemMelting_Clear()
			return
		end

		--否则....
		--由于宝石数已经不够了....

		--取消显示产物....
		GemMelting_State: SetText("")
		GemMelting_ProductItem:SetActionItem(-1)
		GemMelting_ProductItem:Hide()
		g_ProductID = -1

		--取消显示需求物品....
		g_NeedItemID = -1
		GemMelting_NeedMoney:SetProperty("MoneyNumber", "")

		--取消显示所需钱数....
		g_NeedMoney = 0
		GemMelting_NeedMoney : SetProperty("MoneyNumber", "")

	end


	--清除需求物品....
	LifeAbility:Lock_Packet_Item( g_NeedItemPos, 0 )
	GemMelting_NeedItem:SetActionItem(-1)
	g_NeedItemPos = -1;


	--禁用熔炼按钮....
	GemMelting_Accept:Disable()


end

--=========================================================
--确定
--=========================================================
function GemMelting_Buttons_Clicked()

	--钱是否够....
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --交子普及 Vega
	if selfMoney < g_NeedMoney then
		PushDebugMessage( "#{JKBS_081021_011}" )
		return
	end

	--是否过了安全时间....
	if( tonumber(DataPool:GetLeftProtectTime()) >0 ) then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end


	--检测绑定状态....
	local bHaveBind = 0
	for i = 1, 3 do
		if GetItemBindStatus( g_GemItemPos[i] ) == 1 then
			bHaveBind = 1
		end
	end
	if GetItemBindStatus( g_NeedItemPos ) == 1 then
		bHaveBind = 1
	end


	--如果有绑定的则需要提示....
	if bHaveBind == 1 and g_NotifyBind == 1 then
		ShowSystemInfo("JKBS_081022_003")
		g_NotifyBind = 0
		return
	end


	--熔炼....
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name("OnGemMelting")
		Set_XSCRIPT_ScriptID(800118)
		Set_XSCRIPT_Parameter(0,g_GemItemPos[1])
		Set_XSCRIPT_Parameter(1,g_GemItemPos[2])
		Set_XSCRIPT_Parameter(2,g_GemItemPos[3])
		Set_XSCRIPT_Parameter(3,g_NeedItemPos)
		Set_XSCRIPT_ParamCount(4)
	Send_XSCRIPT()

	--GemMelting_Close()


end

--=========================================================
--关闭
--=========================================================
function GemMelting_Close()
	this:Hide();
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--=========================================================
--界面隐藏
--=========================================================
function GemMelting_OnHide()
	StopCareObject_GemMelting()
	GemMelting_Clear();
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_GemMelting()
	this:CareObject(ObjCaredID, 1, "GemMelting");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_GemMelting()
	this:CareObject(ObjCaredID, 0, "GemMelting");
end