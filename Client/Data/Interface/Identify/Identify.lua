--0 鉴定装备资质
--1 重新鉴定装备资质
local Current = 0;
local Identify_Item = -1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Tb_idx = 30008034;
local jingangcuo_id = 30008048;
local g_Object = -1;

function Identify_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_IDENTIFY")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function Identify_OnLoad()

end

function Identify_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
	
			if tonumber(arg0) == 1001 then
				Current = 0;
				Identify_Title:SetText( "#{INTERFACE_XML_93}" );
				Identify_Info:SetText( "#{INTERFACE_XML_883}" );
				Identify_Info2:SetText( "#{INTERFACE_XML_506}" );
			elseif tonumber(arg0) == 112233 then
				Current = 1;
				Identify_Title:SetText( "#gFF0FA0重新鉴定装备资质" );
				Identify_Info:SetText( "#{INTERFACE_XML_987}" );
				Identify_Info2:SetText( "请将装备拖入此框" );
			else
				return;
			end
			
			if this:IsVisible() then
				Identify_Close();
			end

			this:Show();
			objCared = -1
			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("server传过来的数据有问题。");
					return;
			end
			local playerMoney = Player:GetData("MONEY");
			Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
			--zchw
			Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		BeginCareObject_Identify(objCared)
	elseif  ( event == "UPDATE_IDENTIFY" ) then
		local playerMoney = Player:GetData("MONEY");
		Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if arg0~= nil then
			Identify_Update(arg0)

		end
	elseif( event == "RESUME_ENCHASE_GEM" and this:IsVisible() ) then
		local playerMoney = Player:GetData("MONEY");
		Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if(arg0~=nil and tonumber(arg0) == 20 ) then
			Identify_Resume_Equip_Gem(1)
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Identify_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		local playerMoney = Player:GetData("MONEY");
		Identify_SelfMoney:SetProperty("MoneyNumber", playerMoney);
		--zchw
		Identify_DemandJiaozi:SetProperty("MoneyNumber", Player:GetData("MONEY_JZ"));
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil and Current~=1) then	--重新鉴定装备资质不用移除装备....让玩家一直刷....
			if (Identify_Item == tonumber(arg0) ) then
				Identify_Resume_Equip_Gem(1)			
			end
		end
		if( arg0~= nil and Current==1) then
			--if (Identify_Item == tonumber(arg0) ) then
				--if(PlayerPackage:IsLock(tonumber(Identify_Item)) == 1) then
					--Identify_Resume_Equip_Gem(1)	
					--return;
				--end
			--end
			if(tonumber(arg0) and PlayerPackage:GetItemTableIndex(tonumber(arg0)) == Tb_idx) then
				if(PlayerPackage:IsLock(tonumber(arg0)) == 1) then
					--push事件干掉msgbox
					LifeAbility:CloseReIdentifyMsgBox();
					return;
				end
			end
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Identify_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--zchw
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Identify_DemandJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end


end

function Identify_OnShown()
	Identify_Clear();
end

function Identify_Clear()
	if Identify_Item ~= -1 then
		Identify_Object:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Identify_Item,0);
		Identify_Item = -1
		--push事件干掉msgbox
		LifeAbility:CloseReIdentifyMsgBox();
		Identify_DemandMoney : SetProperty("MoneyNumber", 0);
	end

end

function Identify_Update(Item_index)
	local index = tonumber(Item_index)
	local theAction = EnumAction(index, "packageitem");
	
	if theAction:GetID() ~= 0 then
			
			local EquipPoint = LifeAbility : Get_Equip_Point(index)
			if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
				if EquipPoint ~= -1 then
					PushDebugMessage("不能放入这种装备。")
				end
				return
			end
			if Identify_Item ~= -1 then
				LifeAbility : Lock_Packet_Item(Identify_Item,0);
			end
			--push事件干掉msgbox
			LifeAbility:CloseReIdentifyMsgBox();
			Identify_Object:SetActionItem(theAction:GetID());
			LifeAbility : Lock_Packet_Item(index,1);
			Identify_Item = index
			local Equip_Level = LifeAbility : Get_Equip_Level(index);
			local NeedMoney 
			
			if Current == 0 then
				if Equip_Level >= 1 and Equip_Level <= 9 then
						NeedMoney = 10 
					elseif Equip_Level >= 10 and Equip_Level <= 19 then
						NeedMoney = 100 
					elseif Equip_Level >= 20 and Equip_Level <= 29 then
						NeedMoney = 1000 
					elseif Equip_Level >= 30 and Equip_Level <= 39 then
						NeedMoney = 3000 
					elseif Equip_Level >= 40 and Equip_Level <= 49 then
						NeedMoney = 4000 
					elseif Equip_Level >= 50 and Equip_Level <= 59 then
						NeedMoney = 5000 
					elseif Equip_Level >= 60 and Equip_Level <= 69 then
						NeedMoney = 6000 
					elseif Equip_Level >= 70 and Equip_Level <= 79 then
						NeedMoney = 7000 
					elseif Equip_Level >= 80 and Equip_Level <= 89 then
						NeedMoney = 8000 
					elseif Equip_Level >= 90 and Equip_Level <= 99 then
						NeedMoney = 10000 
					elseif Equip_Level < 110 then
						NeedMoney = 20000
					elseif Equip_Level < 120 then
						NeedMoney = 30000
					else
						NeedMoney = 40000
					end
					
			elseif Current == 1 then
				NeedMoney = Equip_Level * 20 + 50;
			end
			
			Identify_DemandMoney : SetProperty("MoneyNumber", tostring(NeedMoney));
			
	else
			Identify_Object:SetActionItem(-1);			
			LifeAbility : Lock_Packet_Item(Identify_Item,0);		
			Identify_Item = -1;
			--push事件干掉msgbox
			LifeAbility:CloseReIdentifyMsgBox();
	end
	
end
local EB_FREE_BIND = 0;				-- 无绑定限制
local EB_BINDED = 1;				-- 已经绑定
local	EB_GETUP_BIND =2			-- 拾取绑定
local	EB_EQUIP_BIND =3			-- 装备绑定
function Identify_Buttons_Clicked()
	if Identify_Item ~= -1 and PlayerPackage : GetItemTableIndex( Identify_Item ) ~= -1 then
		
		if Current == 0 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("FinishAdjust");
				Set_XSCRIPT_ScriptID(809261);
				Set_XSCRIPT_Parameter(0,Identify_Item);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
		elseif Current == 1 then
			local index,BindState = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(Tb_idx));
			local index2,BindState2 = PlayerPackage:FindFirstBindedItemIdxByIDTable(tonumber(jingangcuo_id));
			if(index == -1 and index2 == -1)then
				local str = "缺少#{_ITEM"..Tb_idx.."}或#{_ITEM"..jingangcuo_id.."}，或者它们被加锁。";
				PushDebugMessage(str);
				return
			end
			if(BindState == EB_BINDED or BindState2 == EB_BINDED)then
				--如果已绑定
				local tmp = PlayerPackage:GetItemBindStatusByIndex(Identify_Item);
				if(tmp == EB_BINDED)then
					Clear_XSCRIPT();
						Set_XSCRIPT_Function_Name("FinishReAdjust");
						Set_XSCRIPT_ScriptID(809261);
						Set_XSCRIPT_Parameter(0,Identify_Item);
						Set_XSCRIPT_ParamCount(1);
					Send_XSCRIPT();
				else
					PlayerPackage:OpenReIdentifyMsgBox(tonumber(Identify_Item));
				end
			else
				Clear_XSCRIPT();
					Set_XSCRIPT_Function_Name("FinishReAdjust");
					Set_XSCRIPT_ScriptID(809261);
					Set_XSCRIPT_Parameter(0,Identify_Item);
					Set_XSCRIPT_ParamCount(1);
				Send_XSCRIPT();
			end
		end

	else
		PushDebugMessage("请放入要鉴定资质的装备。")
	end
end

function Identify_Close()
	this:Hide()
end

function Identify_Cancel_Clicked()
	Identify_Close();
	return;
end

function Identify_OnHiden()
	StopCareObject_Identify(objCared)
	Identify_Clear()
	return
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Identify(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Identify");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Identify(objCaredId)
	this:CareObject(objCaredId, 0, "Identify");
	g_Object = -1;

end

function Identify_Resume_Equip_Gem(nIndex)

	if( this:IsVisible() ) then
		if nIndex == 1 then
			if(Identify_Item ~= -1) then
				LifeAbility : Lock_Packet_Item(Identify_Item,0);
				Identify_Object : SetActionItem(-1);
				Identify_Item	= -1;
				Identify_DemandMoney : SetProperty("MoneyNumber", 0);
				--push事件干掉msgbox
				LifeAbility:CloseReIdentifyMsgBox();
			end
		end
	end

end