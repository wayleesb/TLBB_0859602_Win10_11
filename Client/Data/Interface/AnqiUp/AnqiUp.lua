local Current = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local Bind_Item1 = -1
local Bind_Item2 = -1
local g_Object = -1;

local g_ObbpszCost = 2000000;
local g_Mainitem = {10155003,10155005};
local g_Othertem = {30008069,30008070};--20310115,20310116}; 

local g_Accept_Clicked_Num = 0;

function AnqiUp_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_ANQIUP")
	--this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function AnqiUp_OnLoad()

end

function AnqiUp_OnEvent(event)

	if Bind_Item1 == -1 or Bind_Item2 == -1 then
		AnqiUp_OK:Disable()   
	end
	if ( event == "UI_COMMAND" and tonumber(arg0) == 070825) then
		if this:IsVisible() then
			AnqiUp_Close();
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
		AnqiUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		AnqiUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))); 
		BeginCareObject_AnqiUp(objCared)
	elseif ( event == "UPDATE_ANQIUP" ) then
		if arg0~= nil then
			Anqi_Update(arg0,arg1)
			
		end	
		AnqiUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		AnqiUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) 

	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			AnqiUp_Resume_Gem(tonumber(arg0));
			
		end
		AnqiUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		AnqiUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) --zchw
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			AnqiUp_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Bind_Item1 == tonumber(arg0) ) then
				AnqiUp_Resume_Gem(81)			
			end
			if (Bind_Item2 == tonumber(arg0) ) then
				AnqiUp_Resume_Gem(82)			
			end
			
		end
		AnqiUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		AnqiUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ"))) 


	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		g_Accept_Clicked_Num = 0;
		AnqiUp_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		g_Accept_Clicked_Num = 0;
		AnqiUp_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end


end


function AnqiUp_OnShown()
	AnqiUp_Clear();
end

function AnqiUp_Clear()
	g_Accept_Clicked_Num = 0;
	AnqiUp_OK:Disable();
	if Bind_Item1 ~= -1 then
		AnqiUp_Object1:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item1,0);
		Bind_Item1 = -1

	end
	if Bind_Item2 ~= -1 then
		AnqiUp_Object2:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Bind_Item2,0);
		Bind_Item2 = -1
	end
	AnqiUp_Money:SetProperty("MoneyNumber", "");
		
end

function Anqi_Update(UI_index,Item_index)
	g_Accept_Clicked_Num = 0; 
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");

	if u_index == 1 then
		if theAction:GetID() ~= 0 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= g_Mainitem[1] and
					 PlayerPackage : GetItemTableIndex( i_index ) ~= g_Mainitem[2] then
					PushDebugMessage("#{AQSJ_090709_23}")
					return
				end
				if Bind_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				end
				AnqiUp_Object1:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item1 = i_index
				AnqiUp_Money:SetProperty("MoneyNumber", tostring(g_ObbpszCost));
		else
				AnqiUp_Object1:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);		
				Bind_Item1 = -1;
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= g_Othertem[1] and
					 PlayerPackage : GetItemTableIndex( i_index ) ~= g_Othertem[2] then
					PushDebugMessage("#{AQSJ_090709_24}")
					return
				end
				if Bind_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				end
				AnqiUp_Object2:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Bind_Item2 = i_index
		else
				AnqiUp_Object2:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);		
				Bind_Item2 = -1;
		end
	end

	if Bind_Item1 ~= -1 and Bind_Item2 ~= -1 then
		AnqiUp_OK:Enable()   --锻造按钮可用
	end

end

function AnqiUp_Buttons_Clicked()
	--AxTrace(0,5,"Bind_Item1="..Bind_Item1.." Bind_Item2="..Bind_Item2)
	
	if Bind_Item1 == -1 then 
		PushDebugMessage("#{AQSJ_XML_090709_06}")
		return
	end
	if Bind_Item2 == -1 then
		PushDebugMessage("#{AQSJ_XML_090709_07}")
		return
	end

	if (g_Accept_Clicked_Num == 0) then
			Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("AnqiConfirm")
			Set_XSCRIPT_ScriptID(260001)
			Set_XSCRIPT_Parameter(0,Bind_Item1)
			Set_XSCRIPT_Parameter(1,Bind_Item2)
			Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT();
			g_Accept_Clicked_Num = 1;

		else 	 
			Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "Anqi2Shenzhen" )
			Set_XSCRIPT_ScriptID( 260001 )
			Set_XSCRIPT_Parameter( 0, Bind_Item1 )
			Set_XSCRIPT_Parameter( 1, Bind_Item2 )
			Set_XSCRIPT_ParamCount(2)
			Send_XSCRIPT()
			g_Accept_Clicked_Num = 0; 													-- 第2次点击“确定”后，恢复 Accept_Clicked_Num 为未按过“确定”按钮。
			this:Hide();
	end


	--Clear_XSCRIPT();
		--Set_XSCRIPT_Function_Name("AnqiConfirm")
		--Set_XSCRIPT_ScriptID(260001)
		--Set_XSCRIPT_Parameter(0,Bind_Item1)
		--Set_XSCRIPT_Parameter(1,Bind_Item2)
		--Set_XSCRIPT_ParamCount(2)
	--Send_XSCRIPT();
end

function AnqiUp_Close()
	g_Accept_Clicked_Num = 0; 
	this:Hide()
end

function AnqiUp_Cancel_Clicked()
	AnqiUp_Close();
	return;
end

function AnqiUp_OnHiden()
	StopCareObject_AnqiUp(objCared)
	AnqiUp_Clear()
	return
end

function BeginCareObject_AnqiUp(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "AnqiUp");

end

function StopCareObject_AnqiUp(objCaredId)
	this:CareObject(objCaredId, 0, "AnqiUp");
	g_Object = -1;

end

function AnqiUp_Resume_Gem(nIndex)
	g_Accept_Clicked_Num = 0;
	AnqiUp_OK:Disable();
	if nIndex < 81 or nIndex > 82 then
		return
	end

	nIndex = nIndex - 80
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Bind_Item1 ~= -1 then
				AnqiUp_Object1:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item1,0);
				Bind_Item1 = -1
				AnqiUp_Money:SetProperty("MoneyNumber", 0);
			end
		else
			if Bind_Item2 ~= -1 then
				AnqiUp_Object2:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Bind_Item2,0);
				Bind_Item2 = -1
			end
		end
	end
	
end