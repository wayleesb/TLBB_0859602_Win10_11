
local InvitePlayer = { NAME = "", GUID = "" }

function MessageBox_Friend_PreLoad()
	this:RegisterEvent("INVITE_ADD_ME_FRIEND");
end

function MessageBox_Friend_OnLoad()
	InitPlayer();
	this:Hide();
end

function MessageBox_Friend_OnEvent(event)

	if ( event == "INVITE_ADD_ME_FRIEND" ) then
			InitPlayer();
			MessageBox_Friend_Text:Show();
	    InvitePlayer.NAME = tostring( arg0 );
	    InvitePlayer.GUID = tostring( arg1 );
	    MessageBox_Friend_Text:SetText("玩家"..InvitePlayer.NAME.."请求您加他（她）为好友");
			this:Show();
	end
end


function MessageBox_Friend_Cancel_Clicked()
	this:Hide();
	InitPlayer();
end

function MessageBox_Friend_Detail_Clicked()

	if( Friend:IsPlayerIsFriend( InvitePlayer.NAME ) == 1 ) then	
		local nGroup,nIndex;
		nGroup,nIndex = DataPool:GetFriendByName( InvitePlayer.NAME );
		--Friend:SetCurrentSelect( nIndex );
		DataPool:ShowFriendInfo( InvitePlayer.NAME );
	else
		DataPool:ShowChatInfo( InvitePlayer.NAME );
	end

	--DataPool:ShowChatInfo( InvitePlayer.NAME );
	--AskDetailByGuid(InvitePlayer.GUID);
end

function MessageBox_Friend_Ok_Clicked()
	DataPool:AddFriend( 0, InvitePlayer.NAME);
	this:Hide();
	InitPlayer();
end

function InitPlayer()
  InvitePlayer.NAME = "";
  InvitePlayer.GUID = "";
end