local TITLE_COUNT = {};
local EVENT_TYPE;
local strFrontTitle1
local strFrontTitle2

--===============================================
-- PreLoad
--===============================================
function Byname_PreLoad()
	this:RegisterEvent("DRAW_SWEAR_TITLE");
	this:RegisterEvent("CHANGE_SWEAR_TITLE");
end

--===============================================
-- OnLoad
--===============================================
function Byname_OnLoad()
	TITLE_COUNT[0] = "¡„";
	TITLE_COUNT[1] = "“ª";
	TITLE_COUNT[2] = "∂˛";
	TITLE_COUNT[3] = "»˝";
	TITLE_COUNT[4] = "Àƒ";
	TITLE_COUNT[5] = "ŒÂ";
	TITLE_COUNT[6] = "¡˘";
	
	Byname_Text4:SetText( "÷Æ" );
end

--===============================================
-- OnEvent
--===============================================
function Byname_OnEvent(event)
	EVENT_TYPE = event
	if ( event == "DRAW_SWEAR_TITLE" ) then
		Byname_Item1_Frame:Show();
		Byname_Item2_Frame:Hide();
		Byname_Text2:SetText( TITLE_COUNT[tonumber( arg0 )] )
	elseif ( event == "CHANGE_SWEAR_TITLE" ) then
		Byname_Item1_Frame:Hide();
		Byname_Item2_Frame:Show();
		Byname_Text3:SetText( tostring( arg0 ) )
		Byname_Text5:SetText( tostring( arg1 ) )
		strFrontTitle1 = tostring( arg0 )
		strFrontTitle2 = tostring( arg1 )
	end
	this:Show()
end

--===============================================
-- ¡Ï»°/–ﬁ∏ƒ≥∆∫≈
--===============================================
function DrawSwearTitle_Accept()
	--¡Ï»°≥∆∫≈
	if EVENT_TYPE == "DRAW_SWEAR_TITLE" then
		local msg = Byname_Input1:GetText();
		if msg == "" then
			AxTrace(0,0,"≥∆∫≈¥Ì¡À1")
			PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
			return
		end
		msg = Byname_Input3:GetText();
		if msg == "" then
			AxTrace(0,0,"≥∆∫≈¥Ì¡À3")
			PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
			return
		end
		local	buf	= Byname_Input1:GetText()..Byname_Text2:GetText()..Byname_Input3:GetText()
		if string.len( buf ) > 8 then
			AxTrace(0,0,"≥∆∫≈¥Ì¡À9")
			PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
			PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
			return
		end
			
		Player:DrawSwearTitle(buf)
	end
	
	--–ﬁ∏ƒ≥∆∫≈
	if EVENT_TYPE == "CHANGE_SWEAR_TITLE" then
		local msg = Byname_Input4:GetText();
		if msg == "" then
			AxTrace(0,0,"≥∆∫≈¥Ì¡À4")
			PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
			return
		end
		local	buf	= strFrontTitle1..Byname_Text4:GetText()..Byname_Input4:GetText()..strFrontTitle2
		if string.len( buf ) > 16 then
			AxTrace(0,0,"≥∆∫≈¥Ì¡À9£∫"..buf)
			PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
				PushDebugMessage( "≥∆∫≈ ‰»Î¥ÌŒÛ" )
				return
		end

		Player:ChangeSwearTitle(buf)
	end
	
	DrawSwearTitle_Cancel()
end

function DrawSwearTitle_Cancel()
	Byname_Input1:SetText( "" )
	Byname_Input3:SetText( "" )
	Byname_Input4:SetText( "" )
	this:Hide();
end

