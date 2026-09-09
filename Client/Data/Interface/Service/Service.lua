local EQUIP_BUTTONS;
local EQUIP_QUALITY = -1;
local Need_Item = 0
local Need_Money =0
local Need_Item_Count = 0
local Bore_Count=0
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Current = 0;

local g_Object = -1;
local Prompt_Text = {}

function Service_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_SERVICE");
	this:RegisterEvent("RESUME_ENCHASE_GEM");

end

function Service_OnLoad()
	EQUIP_BUTTONS = Service_Item
	Prompt_Text[1] = "  你可以在铸造台修理耐久降低的武器。要修理的武器的需求等级至少要>=40级。40级以下武器请找售货商人直接修理。#r  修理武器需要你的铸造技能等级*12不小于武器的需求等级。#r  修理有可能失败，累计失败3次武器报废。你的铸造技能等级越高，失败的可能性越小。#r  请把要修理的武器拖动到下面的物品栏中，点击“修理”。#r  每次修理消耗活力=武器等级+4。#r  武器等级=武器需求等级/10+1后取整。"
	Prompt_Text[2] = "  你可以在缝纫台修理耐久降低的防具。要修理的防具的需求等级至少要>=40级。40级以下防具请找售货商人直接修理。#r  修理防具需要你的缝纫技能等级*12不小于防具的需求等级。#r  修理有可能失败，累计失败3次防具报废。你的缝纫技能等级越高，失败的可能性越小。#r  请把要修理的防具拖动到下面的物品栏中，点击“修理”。#r  每次修理消耗活力=防具等级+4。#r  防具等级=防具需求等级/10+1后取整。"
	Prompt_Text[3] = "  你可以在工艺台修理耐久降低的饰品。要修理的饰品的需求等级至少要>=40级。40级以下饰品请找售货商人直接修理。#r  修理饰品要求你的工艺技能等级*12不小于饰品的需求等级。#r  修理有可能失败，累计失败3次饰品报废。你的工艺技能等级越高，失败的可能性越小。#r  请把要修理的饰品拖动到下面的物品栏中，点击“修理”。#r  每次修理消耗活力=饰品等级+4。#r  饰品等级=饰品需求等级/10+1后取整。"
end

function Service_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 41) then
			this:Show();

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("server传过来的数据有问题。");
					return;
			end
			BeginCareObject_Service(objCared)
			Current = Get_XParam_INT(1);
			Service_Text:SetText(Prompt_Text[Current]);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Service_Cancel_Clicked()
		end

	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (EQUIP_QUALITY == tonumber(arg0) ) then
				Service_Clear()
				Service_Update(tonumber(arg0))
			end
		end
	elseif( event == "UPDATE_SERVICE") then
		AxTrace(0,1,"arg0="..arg0)
		if arg0 ~= nil then
			Service_Clear()
			Service_Update(tonumber(arg0));
		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		if(arg0~=nil and tonumber(arg0) == 5) then
			Service_Clear()
		end
		
	end
	
end

function Service_OnShown()
	Service_Clear()
end

function Service_Clear()

	EQUIP_BUTTONS : SetActionItem(-1);
	Service_Item_Explain:SetText("")
	LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
	EQUIP_QUALITY = -1;

end

function Service_Update(pos0)
	local pos_packet;
	pos_packet = tonumber(pos0);

	local theAction = EnumAction(pos_packet, "packageitem");
	
	if theAction:GetID() ~= 0 then
		EQUIP_BUTTONS:SetActionItem(theAction:GetID());
		Service_Item_Explain:SetText(theAction:GetName());
		if EQUIP_QUALITY ~= -1 then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
		--让之前的东西变亮
		EQUIP_QUALITY = pos_packet;
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,1);
	else
		EQUIP_BUTTONS:SetActionItem(-1);
		Service_Item_Explain:SetText("")
		LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		EQUIP_QUALITY = -1;
		return;
	end

--add here
end

function Service_Buttons_Clicked()

	if EQUIP_QUALITY ~= -1 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnService");
			Set_XSCRIPT_ScriptID(801015);
			Set_XSCRIPT_Parameter(0,EQUIP_QUALITY);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	else
		PushDebugMessage("请把要修理的装备拖动到物品框中。")
	end
	
end

function Service_Close()
	--并设置，让背包里的位置变亮
	if( this:IsVisible() ) then
		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
		end
	end
	this:Hide();
	Service_Clear();
	StopCareObject_Service(objCared)
end

function Service_Cancel_Clicked()
	Service_Close();
	return;
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Service(objCaredId)

	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "Service");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Service(objCaredId)
	this:CareObject(objCaredId, 0, "Service");
	g_Object = -1;

end

function Resume_Equip()

	if( this:IsVisible() ) then

		if(EQUIP_QUALITY ~= -1) then
			LifeAbility : Lock_Packet_Item(EQUIP_QUALITY,0);
			EQUIP_BUTTONS : SetActionItem(-1);
			Service_Item_Explain:SetText("")
			EQUIP_QUALITY	= -1;
		end	
	end
	
end
