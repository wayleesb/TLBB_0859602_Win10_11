
-- [ QUFEI 2007-10-15 15:31 UPDATE BugID 26358 ]

local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local EQUIP_NPC_ID = -1
local EQUIP_PARA_PRICE = -1
local EQUIP_SHENQI_BEGIN = 10300000
local EQUIP_SHENQI_END = 10399999
--local SHENQI_NPC_NAME = "欧冶子"


local g_Object = -1;
--local g_Npc_Name = ""

local g_CommonRepair = 1

local g_NeedItemBonus={{sqid01=10300000, sqid02=10302000, sqid03=10304000, sqid04=10305000, sfid=30505800},
											 {sqid01=10300001, sqid02=10302001, sqid03=10304001, sqid04=10305001, sfid=30505801},
											 {sqid01=10300002, sqid02=10302002, sqid03=10304002, sqid04=10305002, sfid=30505802},
											 {sqid01=10300003, sqid02=10302003, sqid03=10304003, sqid04=10305003, sfid=30505803},
											 {sqid01=10300004, sqid02=10302004, sqid03=10304004, sqid04=10305004, sfid=30505804},
											 {sqid01=10300005, sqid02=10302005, sqid03=10304005, sqid04=10305005, sfid=30505805},
											 {sqid01=10300100, sqid02=10300100, sqid03=10300100, sqid04=10300100, sfid=30505806},		-- 褚少微
											 {sqid01=10300101, sqid02=10300101, sqid03=10300101, sqid04=10300101, sfid=30505806},
											 {sqid01=10300102, sqid02=10300102, sqid03=10300102, sqid04=10300102, sfid=30505806},
											 {sqid01=10301100, sqid02=10301100, sqid03=10301100, sqid04=10301100, sfid=30505806},
											 {sqid01=10301101, sqid02=10301101, sqid03=10301101, sqid04=10301101, sfid=30505806},
											 {sqid01=10301102, sqid02=10301102, sqid03=10301102, sqid04=10301102, sfid=30505806},
											 {sqid01=10301200, sqid02=10301200, sqid03=10301200, sqid04=10301200, sfid=30505806},
											 {sqid01=10301201, sqid02=10301201, sqid03=10301201, sqid04=10301201, sfid=30505806},
											 {sqid01=10301202, sqid02=10301202, sqid03=10301202, sqid04=10301202, sfid=30505806},
											 {sqid01=10302100, sqid02=10302100, sqid03=10302100, sqid04=10302100, sfid=30505806},
											 {sqid01=10302101, sqid02=10302101, sqid03=10302101, sqid04=10302101, sfid=30505806},
											 {sqid01=10302102, sqid02=10302102, sqid03=10302102, sqid04=10302102, sfid=30505806},
											 {sqid01=10303100, sqid02=10303100, sqid03=10303100, sqid04=10303100, sfid=30505806},
											 {sqid01=10303101, sqid02=10303101, sqid03=10303101, sqid04=10303101, sfid=30505806},
											 {sqid01=10303102, sqid02=10303102, sqid03=10303102, sqid04=10303102, sfid=30505806},
											 {sqid01=10303200, sqid02=10303200, sqid03=10303200, sqid04=10303200, sfid=30505806},
											 {sqid01=10303201, sqid02=10303201, sqid03=10303201, sqid04=10303201, sfid=30505806},
											 {sqid01=10303202, sqid02=10303202, sqid03=10303202, sqid04=10303202, sfid=30505806},
											 {sqid01=10304100, sqid02=10304100, sqid03=10304100, sqid04=10304100, sfid=30505806},
											 {sqid01=10304101, sqid02=10304101, sqid03=10304101, sqid04=10304101, sfid=30505806},
											 {sqid01=10304102, sqid02=10304102, sqid03=10304102, sqid04=10304102, sfid=30505806},
											 {sqid01=10305100, sqid02=10305100, sqid03=10305100, sqid04=10305100, sfid=30505806},
											 {sqid01=10305101, sqid02=10305101, sqid03=10305101, sqid04=10305101, sfid=30505806},
											 {sqid01=10305102, sqid02=10305102, sqid03=10305102, sqid04=10305102, sfid=30505806},
											 {sqid01=10305200, sqid02=10305200, sqid03=10305200, sqid04=10305200, sfid=30505806},
											 {sqid01=10305201, sqid02=10305201, sqid03=10305201, sqid04=10305201, sfid=30505806},
											 {sqid01=10305202, sqid02=10305202, sqid03=10305202, sqid04=10305202, sfid=30505806},
											 }		

function EquipRepair_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_EQUIP_REPAIR");
	this:RegisterEvent("RESUME_ENCHASE_GEM");

end

function EquipRepair_OnLoad()
	EQUIP_BUTTONS = EquipRepair_Item
end

function EquipRepair_OnEvent(event)

	--g_Npc_Name =	Target:GetDialogNpcName();	

	if ( event == "UI_COMMAND" and tonumber(arg0) == 19810313) then
		
		EQUIP_NPC_ID = Get_XParam_INT(0);
		EQUIP_PARA_PRICE = Get_XParam_INT(1);
		g_CommonRepair = 1
		if  EQUIP_PARA_PRICE == -1 then
			this:Show();			
			EquipRepair_ShenQiXiuLi:Hide()
			EquipRepair_ShenQiInfo:Hide()
			EquipRepair_ShenCaiInfo:Hide()
			EquipRepair_DragTitle:Show()
			EquipRepair_Explain1:Show()
			EquipRepair_CurrentlyMoney_Text:Show()			
			objCared = DataPool : GetNPCIDByServerID(EQUIP_NPC_ID);
			AxTrace(0,1,"EQUIP_NPC_ID="..EQUIP_NPC_ID .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("server传过来的数据有问题。");
					return;
			end	
			BeginCareObject_EquipRepair(objCared)					
		else
			if this:IsVisible() then
				--显示价钱
				EquipRepair_DemandMoney:SetProperty("MoneyNumber", EQUIP_PARA_PRICE)
				EQUIP_PARA_PRICE = -1
			end
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 101526358) then
		
		EQUIP_NPC_ID = Get_XParam_INT(0);
		EQUIP_PARA_PRICE = Get_XParam_INT(1);
		g_CommonRepair = 0
		if  EQUIP_PARA_PRICE == -1 then
			this:Show();			
			EquipRepair_DragTitle:Hide()			
			EquipRepair_Explain1:Hide()
			EquipRepair_CurrentlyMoney_Text:Hide()
			EquipRepair_ShenQiXiuLi:Show()			
			EquipRepair_ShenQiInfo:Show()
			EquipRepair_ShenCaiInfo:Show()
						
			objCared = DataPool : GetNPCIDByServerID(EQUIP_NPC_ID);
			AxTrace(0,1,"EQUIP_NPC_ID="..EQUIP_NPC_ID .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("server传过来的数据有问题。");
					return;
			end	
			BeginCareObject_EquipRepair(objCared)					
		else
			if this:IsVisible() then
				--显示价钱
				EquipRepair_DemandMoney:SetProperty("MoneyNumber", EQUIP_PARA_PRICE)
				EQUIP_PARA_PRICE = -1
			end
		end
		
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			EquipRepair_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (EQUIP_QUALITY == tonumber(arg0) ) then
				EquipRepair_Clear()
				EquipRepair_Update(tonumber(arg0))
			end
		end
	elseif( event == "UPDATE_EQUIP_REPAIR") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 ~= nil then
			EquipRepair_Clear()
			EquipRepair_Update(tonumber(arg0));
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 25) then
			Resume_Equip()
		end		
	end	
end

function EquipRepair_OnShown()
	EquipRepair_Clear()
end

function EquipRepair_Clear()
				
		if g_CommonRepair == 0 then
			EQUIP_BUTTONS : SetActionItem(-1);
			EquipRepair_ShenQiInfo:SetText("#{INTERFACE_XML_1002}")
			EquipRepair_ShenCaiInfo:SetText("#{INTERFACE_XML_1003}")				
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EquipRepair_ShenCaiName : SetProperty("Text", "")				
				EQUIP_QUALITY = -1;
			end
		else
			EQUIP_BUTTONS : SetActionItem(-1);
			EquipRepair_Explain1:SetText("请放入要修理的装备：")
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
				EquipRepair_DemandMoney : SetProperty("MoneyNumber", 0);
				EQUIP_QUALITY = -1;
			end		
		end
end

function EquipRepair_Update(pos0)
	
	local pos_packet = tonumber(pos0);
	local theAction = EnumAction(pos_packet, "packageitem");
	local ItemID = PlayerPackage : GetItemTableIndex(pos_packet)		
	
	if theAction:GetID() ~= 0 then
		local EquipPoint = LifeAbility:Get_Equip_Point(pos_packet)	
		if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
			if EquipPoint ~= -1 then
				PushDebugMessage("此物品不需要修理。")
			end
			return
		end
		
		EQUIP_BUTTONS:SetActionItem(theAction:GetID());		
		
		
		if g_CommonRepair == 0 then
			local shenfuid = 0
			EquipRepair_ShenQiInfo:SetText(theAction:GetName());
			
			for i, item in g_NeedItemBonus do								
				if ItemID == item.sqid01
					 or ItemID == item.sqid02
					 or ItemID == item.sqid03
					 or ItemID == item.sqid04 then
					 shenfuid = item.sfid
					 break
				end
			end
			
			EquipRepair_ShenCaiName:SetText("#{_ITEM"..shenfuid.."}");
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			end
			--让之前的东西变亮
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);			
		else		
			EquipRepair_Explain1:SetText(theAction:GetName());		
			if EQUIP_QUALITY ~= -1 then
				LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			end
			--让之前的东西变亮
			EQUIP_QUALITY = pos_packet;
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
			if ItemID < EQUIP_SHENQI_BEGIN or ItemID > EQUIP_SHENQI_END then				
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("CalRepairPrice");
					Set_XSCRIPT_ScriptID(805027);
					Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
					Set_XSCRIPT_Parameter(1,EQUIP_NPC_ID);
					Set_XSCRIPT_ParamCount(2);
				Send_XSCRIPT();		
			end
		end
	else
		
		if g_CommonRepair == 0 then
			EQUIP_BUTTONS:SetActionItem(-1);
			EquipRepair_ShenQiInfo:SetText("#{INTERFACE_XML_1002}")
			EquipRepair_ShenCaiInfo:SetText("#{INTERFACE_XML_1003}")				
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EquipRepair_ShenCaiName : SetProperty("Text", "")				
			EQUIP_QUALITY = -1;
			return;
		else
			EQUIP_BUTTONS:SetActionItem(-1);
			EquipRepair_Explain1:SetText("请放入要修理的装备：")
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_QUALITY = -1;
			return;
		end
	end

end

function EquipRepair_Buttons_Clicked()
	
	if EQUIP_QUALITY ~= -1 then
		-- [ QUFEI 2007-10-15 15:31 UPDATE BugID 26358 ]
		
		local nEquipID = PlayerPackage : GetItemTableIndex(EQUIP_QUALITY)		
		if g_CommonRepair == 0 then
			if nEquipID < EQUIP_SHENQI_BEGIN or nEquipID > EQUIP_SHENQI_END then				
				SetNotifyTip("这里只能修理神器")			
				EquipRepair_Clear();
				return 0
			end			
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnEquipRepair");
				Set_XSCRIPT_ScriptID(805027);
				Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EquipRepair_Clear();
		else
			if nEquipID >= EQUIP_SHENQI_BEGIN and nEquipID <= EQUIP_SHENQI_END then				
				SetNotifyTip("这里无法修理神器")			
				EquipRepair_Clear();
				return 0
			end			
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnEquipRepair");
				Set_XSCRIPT_ScriptID(805027);
				Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EquipRepair_Clear();
		end
	else
		PushDebugMessage("请把要修理的装备拖动到物品框中。")
	end
	
end

function EquipRepair_Close()
	
	--并设置，让背包里的位置变亮
	if( this:IsVisible() ) then
		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
	end
	this:Hide();
	EquipRepair_Clear();
	StopCareObject_EquipRepair(objCared)
	EQUIP_NPC_ID = -1
end

function EquipRepair_Cancel_Clicked()
	EquipRepair_Close();
	return;
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_EquipRepair(objCaredId)
	
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "EquipRepair");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_EquipRepair(objCaredId)
	
	this:CareObject(objCaredId, 0, "EquipRepair");
	g_Object = -1;

end

function Resume_Equip()
	
	if( this:IsVisible() ) then

		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_BUTTONS : SetActionItem(-1);
			
			if g_CommonRepair == 0 then				
				EquipRepair_ShenQiInfo:SetText("#{INTERFACE_XML_1002}")				
			else
				EquipRepair_Explain1:SetText("请放入要修理的装备：")
			end
			EQUIP_QUALITY	= -1;
		end	
	end
	
end