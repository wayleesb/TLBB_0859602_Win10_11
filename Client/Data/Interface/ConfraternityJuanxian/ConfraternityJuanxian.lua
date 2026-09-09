--UI COMMAND ID 19822

local g_clientNpcId = -1;

function ConfraternityJuanxian_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");
	
end

function ConfraternityJuanxian_OnLoad()
end

function ConfraternityJuanxian_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 19822) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end
		ConfraternityJuanxian_Clear()
		ConfraternityJuanxian_Moral_Value:SetText("1")
		ConfraternityJuanxian_Moral_Value:SetProperty("DefaultEditBox", "True");
		ConfraternityJuanxian_Moral_Value:SetSelected( 0, -1 )
		ConfraternityJuanxian_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		ConfraternityJuanxian_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
		this : Show()

		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("未发现 NPC")
			ConfraternityJuanxian_Close()
			return
		end
		
		this : CareObject( g_clientNpcId, 1, "ConfraternityJuanxian" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			ConfraternityJuanxian_Close()
		end
	
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		ConfraternityJuanxian_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
		ConfraternityJuanxian_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	end
	
end

function ConfraternityJuanxian_Cancel_Clicked()
	ConfraternityJuanxian_Close()
end

function ConfraternityJuanxian_Clear()
end

function ConfraternityJuanxian_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "ConfraternityJuanxian")
	g_clientNpcId = -1
	ConfraternityJuanxian_Clear()
end

function ConfraternityJuanxian_Count_Change()
	local str = ConfraternityJuanxian_Moral_Value:GetText()
	local strNumber = 0;
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	
	str = tostring( strNumber );
	ConfraternityJuanxian_Moral_Value:SetTextOriginal( str );
	
end

function ConfraternityJuanxian_OK_Clicked()	
	local str = ConfraternityJuanxian_Moral_Value:GetText()
	local strNumber = 0
	
	if str == nil or str == "" then
		return
	end
	
	strNumber = tonumber(str)
	strNumber = strNumber*10000 --输入单位是金所以×10000
	
	--PushDebugMessage("输入："..strNumber.." 拥有："..Player:GetData("MONEY"))
	if strNumber > Player:GetData("MONEY")+ Player:GetData("MONEY_JZ") then
		PushDebugMessage("#{BPZJ_0801014_007}")
		return
	end
	
--	Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name("PutGuildMoney");
--		Set_XSCRIPT_ScriptID(805012);
--		Set_XSCRIPT_Parameter(0,strNumber);
--		Set_XSCRIPT_ParamCount(1);
--	Send_XSCRIPT();
	
	Guild:PutGuildMoney(strNumber,g_clientNpcId)
	
	ConfraternityJuanxian_Close()
end

