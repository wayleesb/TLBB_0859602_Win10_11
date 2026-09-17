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
	TITLE_COUNT[0] = "零";
	TITLE_COUNT[1] = "一";
	TITLE_COUNT[2] = "二";
	TITLE_COUNT[3] = "三";
	TITLE_COUNT[4] = "四";
	TITLE_COUNT[5] = "五";
	TITLE_COUNT[6] = "六";
	
	Byname_Text4:SetText( "之" );
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
-- 领取/修改称号
--===============================================
function DrawSwearTitle_Accept()
	--领取称号
	if EVENT_TYPE == "DRAW_SWEAR_TITLE" then
		local msg = Byname_Input1:GetText();
		if msg == "" then
			AxTrace(0,0,"称号错了1")
			PushDebugMessage( "称号输入错误" )
			return
		end
		msg = Byname_Input3:GetText();
		if msg == "" then
			AxTrace(0,0,"称号错了3")
			PushDebugMessage( "称号输入错误" )
			return
		end
		local	buf	= Byname_Input1:GetText()..Byname_Text2:GetText()..Byname_Input3:GetText()
		if UTF8Length( buf ) > 8 then
			AxTrace(0,0,"称号错了9")
			PushDebugMessage( "称号输入错误" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
			PushDebugMessage( "称号输入错误" )
			return
		end
			
		Player:DrawSwearTitle(buf)
	end
	
	--修改称号
	if EVENT_TYPE == "CHANGE_SWEAR_TITLE" then
		local msg = Byname_Input4:GetText();
		if msg == "" then
			AxTrace(0,0,"称号错了4")
			PushDebugMessage( "称号输入错误" )
			return
		end
		local	buf	= strFrontTitle1..Byname_Text4:GetText()..Byname_Input4:GetText()..strFrontTitle2
		if UTF8Length( buf ) > 16 then
			AxTrace(0,0,"称号错了9："..buf)
			PushDebugMessage( "称号输入错误" )
			return
		end

		if Player:CheckSwearTitle(buf) == 0 then
				PushDebugMessage( "称号输入错误" )
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

