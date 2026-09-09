
local g_fullPath = "..\\Helper\\license-game.txt"
local g_Text = "no license..."
--===============================================
-- PreLoad()
--===============================================
function Agreement_PreLoad()

	this:RegisterEvent("OPEN_AGREEMENT_DLG");
	this:RegisterEvent("NET_HAS_CLOSED");
end

--===============================================
-- OnLoad()
--===============================================
function Agreement_OnLoad()
		local f = io.open(g_fullPath,"rb");
		if(f)then
			g_Text = f : read("*all");
		end
		if(f)then
			f : close();
			f = nil;
		end
end

--===============================================
-- OnEvent()
--===============================================
function Agreement_OnEvent(event)
	if(event == "OPEN_AGREEMENT_DLG") then
		CloseWindow( "SoftKeyBoard" );
		Agreement_Button_Accept : Enable();
		Agreement_Button_Continue : Enable();
		Agreement_Text : SetText(" ");
		Agreement_Text : SetText(g_Text);
		if(not this:IsVisible() ) then
			this:Show()
		end
	end
	if( event == "NET_HAS_CLOSED" ) then
		this : Hide();
	end
end

function Agreement_Accept()
	GameProduceLogin:AgreeProtocol();
	this : Hide();
end

function Agreement_Cancel()
	GameProduceLogin:ReturnToAccountDlg();
	this : Hide();
	OpenWindow( "SoftKeyBoard" );
	SetSoftKeyAim( "LogOn_PassWord" );	
end