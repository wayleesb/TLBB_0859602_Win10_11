function Pswprotect_PreLoad()
	this:RegisterEvent("LOGIN_MIBAO");
end

function Pswprotect_OnLoad()
end

function Pswprotect_OnEvent(event)
	if(event == "LOGIN_MIBAO" and arg0 == "open") then
		MiBao_Clean();
		MiBao_Update();
		this:Show();
		Pswprotect_Input1:SetProperty("DefaultEditBox", "True");
		MiBao_Activated(1);
	elseif(event == "LOGIN_MIBAO" and arg0 == "close") then
		--SetSoftKeyAim( "" )
		--CloseWindow( "SoftKeyBoard" );
		this:Hide();
	end
end

function MiBao_Clean()
	Pswprotect_Input1:SetText("");
	Pswprotect_Input2:SetText("");
	Pswprotect_Input3:SetText("");
	
	Pswprotect_Text1:SetText("");
	Pswprotect_Text2:SetText("");
	Pswprotect_Text3:SetText("");
end

function MiBao_Update()
	local key1 = GameProduceLogin:GetMiBaoKey(0);
	local key2 = GameProduceLogin:GetMiBaoKey(1);
	local key3 = GameProduceLogin:GetMiBaoKey(2);
	OpenWindow( "SoftKeyBoard" );
	--AxTrace( 0,0, "MiBao_Update"..key1..key2..key3);
	--第3行，第4列的数字是
	Pswprotect_Text1:SetText("第"..string.upper(string.sub(key1,1,1)).."行，第"..string.sub(key1,-1).."列的数字是");
	Pswprotect_Text2:SetText("第"..string.upper(string.sub(key2,1,1)).."行，第"..string.sub(key2,-1).."列的数字是");
	Pswprotect_Text3:SetText("第"..string.upper(string.sub(key3,1,1)).."行，第"..string.sub(key3,-1).."列的数字是");
	
	Pswprotect_Input1:SetProperty("DefaultEditBox", "True");
end

function MiBao_Click_OK()
	local value1 = Pswprotect_Input1:GetText();
	local value2 = Pswprotect_Input2:GetText();
	local value3 = Pswprotect_Input3:GetText();
	
	GameProduceLogin:SetMiBaoValue(0,value1);
	GameProduceLogin:SetMiBaoValue(1,value2);
	GameProduceLogin:SetMiBaoValue(2,value3);
	
	GameProduceLogin:SendMiBaoCheckAccount();
	--MiBao_Click_Cancel();
	this:Hide();
end

function MiBao_Click_Cancel()
	GameProduceLogin:ReturnToAccountDlg();
	--CloseWindow( "SoftKeyBoard" );
	--SetSoftKeyAim( "" );
	this:Hide();
end

function MiBao_TabPressed(nPos)
	if(nPos == 1) then
		Pswprotect_Input1:SetProperty("DefaultEditBox", "False");
		Pswprotect_Input2:SetProperty("DefaultEditBox", "True");
		Pswprotect_Input3:SetProperty("DefaultEditBox", "False");
		SetSoftKeyAim( "Pswprotect_Input2" );
	elseif(nPos == 2) then
		Pswprotect_Input1:SetProperty("DefaultEditBox", "False");
		Pswprotect_Input2:SetProperty("DefaultEditBox", "False");
		Pswprotect_Input3:SetProperty("DefaultEditBox", "True");
		SetSoftKeyAim( "Pswprotect_Input3" );
	elseif(nPos == 3) then
		Pswprotect_Input1:SetProperty("DefaultEditBox", "True");
		Pswprotect_Input2:SetProperty("DefaultEditBox", "False");
		Pswprotect_Input3:SetProperty("DefaultEditBox", "False");
		SetSoftKeyAim( "Pswprotect_Input1" );
	end
end

function MiBao_Activated(nPos)
	if(nPos == 1) then
		SetSoftKeyAim( "Pswprotect_Input1" );
	elseif(nPos == 2) then
		SetSoftKeyAim( "Pswprotect_Input2" );
	elseif(nPos == 3) then
		SetSoftKeyAim( "Pswprotect_Input3" );
	end
end
