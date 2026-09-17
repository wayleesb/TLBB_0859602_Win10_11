local nCurrentMail = 0;
--===============================================
-- OnLoad()
--===============================================
function InfoBrowser_PreLoad()
	this:RegisterEvent("OPEN_EMAIL");
	this:RegisterEvent("UPDATE_EMAIL");
	this:RegisterEvent("HAVE_MAIL");
	
end

function InfoBrowser_OnLoad()
	Variable:SetVariable( "IsInfoBrowerShow","False", 1 );
	
end

--===============================================
-- OnEvent()
--===============================================
function InfoBrowser_OnEvent( event )
	--显示系统邮件的时候必定会关闭本界面
	if( event == "OPEN_EMAIL" ) then
		SystemInfo_NextPage();
		
	elseif( event == "UPDATE_EMAIL" ) then
		AxTrace( 0, 0, "UPDATE_EMAIL" );
		nCurrentMail = tonumber( arg0 );		
		
		-- [ QUFEI 2007-09-15 17:05 UPDATE BugID #25107 ]
		-- 收到无效邮件时关闭邮件读取窗口
		if( nCurrentMail < 100000 ) then
			Update_Player_Mail();
		elseif( nCurrentMail >= 100000 and nCurrentMail < 300000 ) then
			nCurrentMail = nCurrentMail - 100000;
			InfoBrowser_Close()			
		else
			nCurrentMail = nCurrentMail - 300000;
			Update_System_Mail();
		end
		
	elseif( event == "HAVE_MAIL" ) then
		if( this:IsVisible() ) then
			InfoBrowser_Update();
		end
	end

end
function Update_System_Mail()
	AxTrace( 0, 0, "Update_System_Mail" );
	SystemInfo_Show();
	SystemInfo_Update();
end

function Update_Player_Mail()
	AxTrace( 0, 0, "Update_Player_Mail" );
	InfoBrowser_Show();
	InfoBrowser_Update();
end

function InfoBrower_DisableButton()
	InfoBrowser_Next:Disable();
	InfoBrowser_AddFriend:Disable();
	InfoBrowser_ExamineData:Disable();
	InfoBrowser_AddFriend:Disable();
	InfoBrowser_Respondence:Disable();
	InfoBrowser_ExamineData:Disable();
	InfoBrowser_Next:Disable();
	InfoBrowser_PlayerHead:SetProperty("Image", "");
	AxTrace( 0,0,"InfoBrower_DisableButton" );
end
--===============================================
-- UpdateFrame()
--===============================================
function InfoBrowser_Update()
	InfoBrower_UpdateButton();
	Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
	local sender  = DataPool:GetMail( nCurrentMail,"SENDER" );
	local context = DataPool:GetMail( nCurrentMail,"CONTEX" );
	local time	  = DataPool:GetMail( nCurrentMail,"TIME" );

	
	InfoBrowser_From:SetText( "名字:"..sender.."#b#c0000FF#effffff(玩家)" );
	InfoBrowser_Time:SetText( "时间:"..time );
	InfoBrowser_Context:SetText( context );
	local strFaceImage = DataPool:GetMail( nCurrentMail,"PORTRAIT" );
	AxTrace( 0,0,"InfoBrowser_Update head image = "..tostring(strFaceImage) );
	InfoBrowser_PlayerHead:SetProperty("Image", tostring(strFaceImage));
	InfoBrowser_Report:Show();
	
	
end

function InfoBrower_UpdateButton()
	InfoBrower_DisableButton();
	if( DataPool:GetMailNumber() == 0 ) then
		InfoBrowser_Next:Disable();
	else
		InfoBrowser_Next:Enable();
	end

	local nchannel,nindex;
	nchannel, nindex  = DataPool:GetFriendByName( DataPool:GetMail( nCurrentMail,"SENDER" ) );
	
	if( tonumber( nchannel ) == -1 ) then
		InfoBrowser_AddFriend:Enable();
	else
		InfoBrowser_AddFriend:Disable();
	end
	
	InfoBrowser_ExamineData:Enable();
	
	InfoBrowser_Respondence:Enable();

end

function InfoBrowser_Close()
	this:Hide();
	Variable:SetVariable( "IsInfoBrowerShow","False", 1 );
end

function InfoBrowser_Show()
	this:Show();
	Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
	InfoBrowser_Frame_Title:SetText( "#gFF0FA0信件浏览" );
	InfoBrowser_Frame_System:Hide();
	InfoBrowser_Frame_Player:Show();
	InfoBrowser_Respondence:Show();
	InfoBrowser_AddFriend:Show();
	--投诉按钮show
end

function SystemInfo_Show()
	this:Show();
	Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
	InfoBrowser_Frame_Player:Hide();
	InfoBrowser_Frame_Title:SetText( "#gFF0FA0系统信息" );
	InfoBrowser_Frame_System:Show();
	InfoBrowser_AddFriend:Hide();
	InfoBrowser_Respondence:Hide();
	--投诉按钮hide	
end


function InfoBrowser_NextMail()
	DataPool:GetNextMail();
end

function InfoBrowser_AddToFriend()
	local sender  = DataPool:GetMail( nCurrentMail, "SENDER" );
	DataPool:AddFriend( Friend:GetCurrentTeam(), sender );
end

function InfoBrowser_PlayerInfo()
	local name = DataPool:GetMail( nCurrentMail, "SENDER" )
	if( Friend:IsPlayerIsFriend( name ) == 1 ) then	
		DataPool:ShowFriendInfo( name );
	else
		DataPool:ShowChatInfo( name );
	end

	
end

function InfoBrowser_MailBack()
	local sender  = DataPool:GetMail( nCurrentMail, "SENDER" );
	local nchannel,nindex;
	nchannel, nindex  = DataPool:GetFriendByName( sender );
	if( tonumber( nchannel ) == -1 ) then
		DataPool:AddFriend( 8, sender );
	end	
	DataPool:OpenMail( sender );
end

function InfoBrowser_Help()
end

function SystemInfo_Update()
	
		Variable:SetVariable( "IsInfoBrowerShow","True", 1 );
		InfoBrower_UpdateButton();
		local sender  = DataPool:GetMail( nCurrentMail,"SENDER" );
		local context = DataPool:GetMail( nCurrentMail,"CONTEX" );
		local time	  = DataPool:GetMail( nCurrentMail,"TIME" );
	
		
		SystemInfo_From:SetText( "#b#cFF0000#effffff系统邮件" );
		SystemInfo_Time:SetText( "时间:"..time );
		SystemInfo_Context:SetText( context );
		InfoBrowser_Report:Hide();
end


function SystemInfo_NextPage()
	InfoBrower_DisableButton();
	local mailnumber = DataPool:GetMailNumber();

	if( mailnumber > 0 ) then
		InfoBrowser_NextMail();
	end
end
function InfoBrowser_OnHiden()	
	Variable:SetVariable( "IsInfoBrowerShow","False", 1 );
end

function InfoBrowser_toushu()
	local MailTime = DataPool:GetMailTimeInt(nCurrentMail);
	local sender  = DataPool:GetMail( nCurrentMail,"SENDER" );
	local context = DataPool:GetMail( nCurrentMail,"CONTEX" );
	Talk:DisclosureToGM("mail",sender,context,MailTime);
end