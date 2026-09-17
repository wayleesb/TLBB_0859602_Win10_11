function ChatInfo_PreLoad()
	this:RegisterEvent("CHAT_SHOWUSERINFO");
end

function ChatInfo_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function ChatInfo_OnEvent( event )
	if(event == "CHAT_SHOWUSERINFO") then
		ChatInfo_Show();
	end
end


--===============================================
-- UpdateFrame()
-- 第几个频道的第几个人
--===============================================
function ChatInfo_Update()
	--AxTrace( 0,0,"char PORTRAIT" );
	local strFaceImage = DataPool:GetFriend( "chat", "PORTRAIT" );
	ChatInfo_PlayerHead:SetProperty("Image", tostring(strFaceImage));
	--AxTrace( 0,0,"char ID" );
	ChatInfo_ID:SetText( "ID:"..tostring( DataPool:GetFriend( "chat", "ID_TEXT" ) ) );
	--AxTrace( 0,0,"char NAME" );
	ChatInfo_Name:SetText( "姓名:"..DataPool:GetFriend( "chat", "NAME"  ) );
	--AxTrace( 0,0,"char LEVEL" );
	ChatInfo_Level:SetText( "级别:"..tostring( DataPool:GetFriend( "chat", "LEVEL" ) ) );
	--AxTrace( 0,0,"char MENPAI_TEXT" );
	ChatInfo_MenPai:SetText( "门派:"..DataPool:GetFriend( "chat", "MENPAI_TEXT" ) );
	--AxTrace( 0,0,"char GUID_NAME" );
	ChatInfo_Confraternity:SetText( "帮会名称:"..DataPool:GetFriend( "chat", "GUID_NAME" ) );
	ChatInfo_GuildLeague:SetText( "#{TM_20080311_30}"..DataPool:GetFriend( "chat", "GUILD_LEAGUE_NAME" ) );
	--AxTrace( 0,0,"char MOOD" );
	ChatInfo_Explain:SetText( "心情:"..DataPool:GetFriend( "chat", "MOOD" ) );
	--AxTrace( 0,0,"char TITLE" );
	ChatInfo_Agname:SetText( "称号:"..DataPool:GetFriend( "chat", "TITLE" ) );
end

function ChatInfo_Show()
	
	ChatInfo_Update();
	this:Show();
end

function ChatInfo_OnHide()
	this:Hide();
end

function ChatInfo_OnHelp()
end

function ChatInfo_AddFriend()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		DataPool:AddFriend( Friend:GetCurrentTeam(), szName);
	end
end

function ChatInfo_SetPrivateName()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Talk:ContexMenuTalk(szName);
	end
end

function ChatInfo_ShengQingTeam()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamApply(szName);
	end
end


function ChatInfo_YaoQingTeam()
	local szName = DataPool:GetFriend( "chat", "NAME"  );
	if(nil ~= szName and "" ~= szName) then
		Target:SendTeamRequest(szName);
	end
end