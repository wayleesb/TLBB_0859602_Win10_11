
local MAX_OBJ_DISTANCE = 3.0;

local g_GemItemPos = -1;
local g_GemItemID = -1;
local g_NeedItemPos = -1;
local g_NeedItemID = -1;
local g_NeedMoney = 0;
local g_RightGem = 0;
local EB_BINDED = 1;				-- 已经绑定

local g_LastGemItemID = -1;
local g_LastNeedItemID = -1;

local ObjCaredIDID = -1;


function GemCarve_PreLoad()

	this:RegisterEvent("UPDATE_GEMCARVE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("MONEYJZ_CHANGE")		--交子普及 Vega
end

function GemCarve_OnLoad()
end

function GemCarve_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 112236) then

			local xx = Get_XParam_INT(0);
			ObjCaredID = DataPool : GetNPCIDByServerID(xx);
			if ObjCaredID == -1 then
					PushDebugMessage("server传过来的数据有问题。");
					return;
			end
			ObjCaredIDID = xx
			BeginCareObject_GemCarve()
			GemCarve_Clear()
			this:Show();

	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then

		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			GemCarve_Close()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if ( g_GemItemPos == tonumber(arg0) ) then
			Resume_Equip_GemCarve(1)
		end

		if ( g_NeedItemPos == tonumber(arg0) ) then
			Resume_Equip_GemCarve(2)
		end

	elseif( event == "UPDATE_GEMCARVE") then

		if arg0 == nil or arg1 == nil then
			return
		end

		GemCarve_Update(tonumber(arg0),tonumber(arg1));

	elseif( event == "UNIT_MONEY" or event =="MONEYJZ_CHANGE") then

		GemCarve_UserMoneyChanged();

	elseif ( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then

		if tonumber(arg0) == 41 then
			Resume_Equip_GemCarve(1)
		elseif tonumber(arg0) == 42 then
			Resume_Equip_GemCarve(2)
		end

	end

end

--=========================================================
--重置界面
--=========================================================
function GemCarve_Clear()

	if(g_GemItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
	end
	if(g_NeedItemPos ~= -1) then
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
	end

	GemCarve_GemItem : SetActionItem(-1);
	GemCarve_NeedItem : SetActionItem(-1);
	GemCarve_ProductItem:SetActionItem(-1);

	GemCarve_NeedItem : SetToolTip("")
	GemCarve_Money : SetProperty("MoneyNumber", "")
	GemCarve_State: SetText("")
	
	g_GemItemPos = -1;
	g_GemItemID = -1;
	g_NeedItemPos = -1;
	g_NeedItemID = -1;
	g_NeedMoney = 0;
	g_RightGem = 0;
	g_LastGemItemID = -1;
    g_LastNeedItemID = -1;

	GemCarve_ProductItem:Hide();
	GemCarve_Accept:Disable();

end

--=========================================================
--更新界面
--=========================================================
function GemCarve_Update( pos_ui, pos_packet )

	local theAction = EnumAction(pos_packet, "packageitem");

	if pos_ui == 1 then

		if theAction:GetID() == 0 then
			return
		end

		--必须是宝石....
		local Item_Class = PlayerPackage : GetItemSubTableIndex(pos_packet,0)
		if Item_Class ~= 5 then
			PushDebugMessage("只有宝石才可被雕琢")
			return
		end

		--记录刷新前....玩家放到所需物品栏中的所需物品的信息....
		local lastNeedItemPos = g_NeedItemPos
		local lastNeedItemID = g_NeedItemID

		--重置界面....
		GemCarve_Clear();

		--更换ActionButton....
		if g_GemItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_GemItemPos,0);
		end
		g_GemItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_GemItemPos,1);
		GemCarve_GemItem:SetActionItem(theAction:GetID());

		--获取雕琢的信息....
		local GemItemID = PlayerPackage : GetItemTableIndex( pos_packet )
		g_GemItemID = GemItemID;
		local ProductID
		ProductID, g_NeedItemID, g_NeedMoney = GemCarve:GetGemCarveInfo( GemItemID )
		if -1 == ProductID then
			g_RightGem = 0
			GemCarve_State : SetText("此宝石无法被雕琢。")
			return
		else
			g_RightGem = 1
		end

		--设置产品ActionButton....
		GemCarve_State : SetText("雕琢后的产物：")
		GemCarve_ProductItem:Show()
		local ProductAction = GemCarve:UpdateProductAction( ProductID )
		if ProductAction and ProductAction:GetID() ~= 0 then
			GemCarve_ProductItem:SetActionItem(ProductAction:GetID());
		else
			GemCarve_ProductItem:SetActionItem(-1);
		end

		--设置所需物品Tooltips....
		GemCarve_NeedItem : SetToolTip("需要放入#{_ITEM"..g_NeedItemID.."}")

		--设置所需钱数....
		GemCarve_Money : SetProperty("MoneyNumber", tostring(g_NeedMoney));
		
		--如果这次的所需物品与上次的相同....则直接把上次的所需物品放到所需物品栏内....
		if lastNeedItemID ~= -1 and lastNeedItemID == g_NeedItemID then
			GemCarve_Update( 2, lastNeedItemPos )
		end

	elseif pos_ui == 2 then

		if theAction:GetID() == 0 then
			return
		end

		if -1 == g_GemItemPos or g_RightGem == 0 then
			PushDebugMessage("请先放入需要雕琢的宝石")
			return
		end

		--不是需求的物品....
		if PlayerPackage:GetItemTableIndex( pos_packet ) ~= g_NeedItemID then
			PushDebugMessage("这里只能放入#{_ITEM"..g_NeedItemID.."}")
			return
		end

		--更换ActionButton....
		if g_NeedItemPos ~= -1 then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
		end
		g_NeedItemPos = pos_packet;
		LifeAbility : Lock_Packet_Item(g_NeedItemPos,1);
		GemCarve_NeedItem:SetActionItem(theAction:GetID());

		--如果物品都正确了并且钱也够就Enable雕琢按钮....
		local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")  --交子普及 Vega
		if selfMoney >= g_NeedMoney then
			GemCarve_Accept:Enable();
		end

	end

end

--=========================================================
--清除ActionButton
--=========================================================
function Resume_Equip_GemCarve(nIndex)

	if(nIndex == 1) then
		GemCarve_Clear()
	else
		if(g_NeedItemPos ~= -1) then
			LifeAbility : Lock_Packet_Item(g_NeedItemPos,0);
			GemCarve_NeedItem : SetActionItem(-1);
			g_NeedItemPos	= -1;
		end
		GemCarve_Accept:Disable();
	end

end

--=========================================================
--确定
--=========================================================
function GemCarve_Buttons_Clicked()

	if g_GemItemPos == -1 or g_RightGem == 0 then
		return
	end

	if g_NeedItemPos == -1 then
		return
	end
	
	if(g_LastGemItemID ~= g_GemItemID or g_LastNeedItemID ~= g_NeedItemID) then
	  g_LastGemItemID = g_GemItemID
	  g_LastNeedItemID = g_NeedItemID
	  --根据宝石是否绑定和宝石雕琢符是否绑定，决定摘除后的宝石是否绑定
	  if (GetItemBindStatus(g_GemItemPos) == EB_BINDED or GetItemBindStatus(g_NeedItemPos) == EB_BINDED) then
	    ShowSystemInfo("INTERFACE_XML_GemCarve_7");
	    --LifeAbility:Carve_Confirm("OnGemCarve",800117,g_GemItemPos,g_NeedItemPos,2);
	  return
	  end
	end


	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnGemCarve");
		Set_XSCRIPT_ScriptID(800117);
		Set_XSCRIPT_Parameter(0,g_GemItemPos);
		Set_XSCRIPT_Parameter(1,g_NeedItemPos);
		Set_XSCRIPT_Parameter(2,ObjCaredIDID);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	GemCarve_Close()

end

--=========================================================
--关闭
--=========================================================
function GemCarve_Close()
	this:Hide();
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--界面隐藏
--=========================================================
function GemCarve_OnHide()
	StopCareObject_GemCarve()
	GemCarve_Clear();
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_GemCarve()
	this:CareObject(ObjCaredID, 1, "GemCarve");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_GemCarve()
	this:CareObject(ObjCaredID, 0, "GemCarve");
end

--=========================================================
--玩家金钱变化
--=========================================================
function GemCarve_UserMoneyChanged()
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ") --交子普及 Vega
	if selfMoney < g_NeedMoney then
		GemCarve_Accept:Disable();
	else
		if g_GemItemPos ~= -1 and g_NeedItemPos ~= -1 then
			GemCarve_Accept:Enable();
		end
	end

end