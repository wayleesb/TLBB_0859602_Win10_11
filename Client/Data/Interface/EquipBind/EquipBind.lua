local Current = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Bind_Item1 = -1
local Bind_Item2 = -1
local g_Object = -1;

function EquipBind_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_EQUIPBIND")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function EquipBind_OnLoad()

end

function EquipBind_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 1005) then
		if this:IsVisible() then
			EquipBind_Close();
		end
		this:Show();
		
		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); --zchw
		BeginCareObject_EquipBind(objCared)
	elseif ( event == "UPDATE_EQUIPBIND" ) then
		if arg0~= nil then
			EquipBind_Update(arg0,arg1)
			
		end	
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			EquipBind_Resume_Gem(tonumber(arg0));
			
		end
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			EquipBind_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Bind_Item1 == tonumber(arg0) ) then
				EquipBind_Resume_Gem(31)			
			end
			if (Bind_Item2 == tonumber(arg0) ) then
				EquipBind_Resume_Gem(32)			
			end
			
		end
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw

	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		EquipBind_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--zchw
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		EquipBind_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end


end

function EquipBind_OnShown()
	EquipBind_Clear();
end

function EquipBind_Clear()
	if Bind_Item1 ~= -1 then
		EquipBind_MainItem:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item1,0);
		Bind_Item1 = -1

	end
	if Bind_Item2 ~= -1 then
		EquipBind_OtherItem:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item2,0);
		Bind_Item2 = -1
	end
	EquipBind_NeedMoney:SetProperty("MoneyNumber", "");
		
end

function EquipBind_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");

	if u_index == 1 then
		if theAction:GetID() ~= 0 then
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
					if EquipPoint ~= -1 then
						PushDebugMessage("不能放入这种装备。")
					end
					return
				end
				if Bind_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				end
				EquipBind_MainItem:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item1 = i_index
				local equip_level = LifeAbility : Get_Equip_Level(i_index);
				local equip_point = LifeAbility : Get_Equip_Point(i_index);
				local needmoney
				
				if equip_point == 0 or equip_point == 2 then
					needmoney = 500 + equip_level * 200
				else
					needmoney = 250 + equip_level * 100
				end
				
				EquipBind_NeedMoney:SetProperty("MoneyNumber", tostring(needmoney));
		else
				EquipBind_MainItem:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);		
				Bind_Item1 = -1;
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900013 and
					 PlayerPackage : GetItemTableIndex( i_index ) ~= 30900014 then
					PushDebugMessage("这里必须放入刻铭符。")
					return
				end
				if Bind_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				end
				EquipBind_OtherItem:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item2 = i_index
		else
				EquipBind_OtherItem:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);		
				Bind_Item2 = -1;
		end
	end

end

function EquipBind_Buttons_Clicked()
	--AxTrace(0,5,"Bind_Item1="..Bind_Item1.." Bind_Item2="..Bind_Item2)
	
	if Bind_Item1 == -1 then 
		PushDebugMessage("请放入要刻铭的装备。")
		return
	end
	if Bind_Item2 == -1 then
		PushDebugMessage("请放入要刻铭符。")
		return
	end
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("FinishBind");
		Set_XSCRIPT_ScriptID(809266);
		Set_XSCRIPT_Parameter(0,Bind_Item1);
		Set_XSCRIPT_Parameter(1,Bind_Item2);
		Set_XSCRIPT_ParamCount(2);
	Send_XSCRIPT();
end

function EquipBind_Close()
	this:Hide()
end

function EquipBind_Cancel_Clicked()
	EquipBind_Close();
	return;
end

function EquipBind_OnHiden()
	StopCareObject_EquipBind(objCared)
	EquipBind_Clear()
	return
end
--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_EquipBind(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "EquipBind");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_EquipBind(objCaredId)
	this:CareObject(objCaredId, 0, "EquipBind");
	g_Object = -1;

end

function EquipBind_Resume_Gem(nIndex)
	if nIndex < 31 or nIndex > 32 then
		return
	end

	nIndex = nIndex - 30
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Bind_Item1 ~= -1 then
				EquipBind_MainItem:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				Bind_Item1 = -1
				EquipBind_NeedMoney:SetProperty("MoneyNumber", 0);
			end
		else
			if Bind_Item2 ~= -1 then
				EquipBind_OtherItem:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				Bind_Item2 = -1
			end
		end
	end
	
end