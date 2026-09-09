
local LEVEL_LIMIT = 15;			--player level limit

function ChatSpeaker_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "SHOW_SPEAKER_INPUTBOX" )
end
	
function ChatSpeaker_OnLoad()
	
end

function ChatSpeaker_OnEvent(event)
	
	if( event == "UI_COMMAND" ) then
		if( tonumber( arg0 ) == 5422 ) then
			ChatSpeaker_Open();
		end
	end
	if( event == "SHOW_SPEAKER_INPUTBOX" ) then
		if( this:IsVisible() ) then
			ChatSpeaker_Hide();
		else
			ChatSpeaker_Open();
		end
	end
end
function ChatSpeaker_Open()
	local level = Player:GetData("LEVEL");
	if level < LEVEL_LIMIT then
		PushDebugMessage("您的等级不足15级，不能使用喇叭发言。");
		return;
	end
	ChatSpeaker_Edit:SetProperty("DefaultEditBox", "True");
	this:Show();
end

function ChatSpeaker_Hide()
	this:Hide()
end

function ChatSpeaker_SendMessage()
	local text = ChatSpeaker_Edit:GetText();
	if( text == "" ) then
		return;
	end
	Player:SendSpeakerMessage( text );
	ChatSpeaker_Hide();
end

function ChatSpeaker_GetBtnScreenPosX(btn)
	ChatSpeaker_PrepareBtnCtl();
	local barxpos = ChatSpeaker_Frame:GetProperty("AbsoluteXPosition");
	local btnxpos = g_ChatBtn[btn]:GetProperty("AbsoluteXPosition");
	
	return barxpos+btnxpos;
end
function ChatSpeaker_GetBtnScreenPosY(btn)
	ChatSpeaker_PrepareBtnCtl();
	local barxpos = ChatSpeaker_Frame:GetProperty("AbsoluteYPosition");
	local btnxpos = ChatSpeaker_Frame:GetProperty("AbsoluteHeight");
	return barxpos+btnxpos+2;
end

function ChatSpeaker_SelectTextColor()
	Talk:SelectTextColor("select", ChatSpeaker_GetBtnScreenPosX("color"),ChatSpeaker_GetBtnScreenPosY("color"));
end

function ChatSpeaker_SelectFaceMotion()
	Talk:SelectFaceMotion("select", ChatSpeaker_GetBtnScreenPosX("face"),ChatSpeaker_GetBtnScreenPosY("face"));
end

function ChatSpeaker_PrepareBtnCtl()
	g_ChatBtn = {
								color		= ChatSpeaker_LetterColor,
								face		= ChatSpeaker_Face,

							};
end