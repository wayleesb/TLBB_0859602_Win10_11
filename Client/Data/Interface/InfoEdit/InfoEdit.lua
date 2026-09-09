
--是否预览状态
local currentmode = 0;

local g_ChatBtn ={};

local isFirstClick = false;
--===============================================
-- OnLoad()
--===============================================
function InfoEdit_PreLoad()

	this:RegisterEvent("OPEN_EMAIL_WRITE");
	this:RegisterEvent("SEND_MAIL");
end

function InfoEdit_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function InfoEdit_OnEvent( event )
	
	if ( event == "OPEN_EMAIL_WRITE" ) then
		InfoEdit_Show();
		InfoEdit_Target:SetText( arg1 );
		InfoEdit_EditInfo:SetText(arg2);
		if arg1 ~= ""  then 
			if IsWindowShow("PetFriendSearch") or IsWindowShow("PetZhengYou") then
				InfoEdit_EditInfo:SetProperty("SelectionStart",0);
				InfoEdit_EditInfo:SetProperty("SelectionLength", -1);
				isFirstClick = true;
			end
		end
	elseif( event == "SEND_MAIL" ) then
		InfoEdit_SendMail();
	end

end

function InfoEdit_Empty()
	if isFirstClick == true then
		isFirstClick = false;
		InfoEdit_EditInfo:SetText("");
	end
end

--===============================================
-- UpdateFrame()
--===============================================
function InfoEdit_Update()
	InfoEdit_History:SetText("历史消息") -- zchw
	InfoEdit_Preview:SetText( "预览" );
	InfoEdit_PreviewInfo:Hide();
	InfoEdit_EditInfo:Show();
	InfoEdit_EditInfo:SetForce();
end

function InfoEdit_Show()
	this:Show();
	InfoEdit_Update();
	InfoEdit_EditInfo:SetText("");
	
end

function InfoEdit_Hide()
	this:Hide();
end

function InfoEdit_ClosePreviewClick()
	
	InfoEdit_Preview:SetText( "预览" );
	InfoEdit_PreviewInfo:Hide();
	InfoEdit_EditInfo:Show();
		
	
end
function InfoEdit_PreviewClick()
	if( InfoEdit_PreviewInfo:IsVisible() ) then
		InfoEdit_ClosePreviewClick();
	else
		InfoEdit_PreviewInfo:SetText( InfoEdit_EditInfo:GetText() );
		InfoEdit_Preview:SetText( "返回" );
		InfoEdit_PreviewInfo:Show();
		InfoEdit_EditInfo:Hide();
	end
	
end

function InfoEdit_SendMail()	
	local SendRet = nil	--标识发邮件是否成功--add by xindefeng
	
	if isFirstClick then
		isFirstClick = false;
	end
	local szValue= InfoEdit_EditInfo:GetText();
	if( szValue == "" ) then
		PushDebugMessage("不能发送空邮件");
		return;
	end
	if( this:IsVisible() ) then
		SendRet = DataPool:SendMail( InfoEdit_Target:GetText(), InfoEdit_EditInfo:GetText() )	--modify by xindefeng
		
		local nchannel,nindex;
		nchannel, nindex  = DataPool:GetFriendByName( InfoEdit_Target:GetText() );
		if( tonumber( nchannel ) == -1 ) then
			DataPool:AddFriend( 7, InfoEdit_Target:GetText() );
		end
	end
		
	if(SendRet == 0)then	--如果发邮件成功,关闭界面--modify by xindefeng
		InfoEdit_Hide()
	end
	
end

function InfoEdit_OnHidden()
	InfoEdit_EditInfo:SetProperty("DefaultEditBox", "False");
end

function InfoEdit_GetBtnScreenPosX(btn)
	InfoEdit_PrepareBtnCtl();
	local barxpos = InfoEdit_Frame:GetProperty("AbsoluteXPosition");
	local btnxpos = g_ChatBtn[btn]:GetProperty("AbsoluteXPosition");
	
	return barxpos+btnxpos;
end
function InfoEdit_GetBtnScreenPosY(btn)
	InfoEdit_PrepareBtnCtl();
	local barxpos = InfoEdit_Frame:GetProperty("AbsoluteYPosition");
	local btnxpos = InfoEdit_Frame:GetProperty("AbsoluteHeight");
	return barxpos+btnxpos+2;
end
function InfoEdit_SelectTextColor()
	Talk:SelectTextColor("select", InfoEdit_GetBtnScreenPosX("color"),InfoEdit_GetBtnScreenPosY("color"));
end

function InfoEdit_SelectFaceMotion()
	Talk:SelectFaceMotion("select", InfoEdit_GetBtnScreenPosX("face"),InfoEdit_GetBtnScreenPosY("face"));
end

function InfoEdit_PrepareBtnCtl()
	g_ChatBtn = {
								color		= InfoEdit_LetterColor,
								face		= InfoEdit_Face,

							};
end

-- add by zchw
function InfoEdit_MailHistory()
	DataPool:OpenHistroy( Friend:GetCurrentTeam(), Friend:GetCurrentSelect() );
end
