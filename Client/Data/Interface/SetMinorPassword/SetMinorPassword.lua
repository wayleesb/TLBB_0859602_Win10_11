function SetMinorPassword_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("MINORPASSWORD_OPEN_SET_PASSWORD_DLG");

	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	
end

function SetMinorPassword_OnLoad()

end

-- OnEvent
function SetMinorPassword_OnEvent(event)
	 		
	if( event == "MINORPASSWORD_OPEN_SET_PASSWORD_DLG" ) then
	
		this:Show();
		
		SetMinorPassword_EditBox1:SetText( "" );
		SetMinorPassword_EditBox2:SetText( "" );
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "SetMinorPassword_EditBox1" );
	
	end;	

	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide();
	end
	
end;
function SetMinorPassword_EditBox1_OnActive()
	SetSoftKeyAim( "SetMinorPassword_EditBox1" );
end
function SetMinorPassword_EditBox2_OnActive()
	SetSoftKeyAim( "SetMinorPassword_EditBox2" );
end
---------------------------------------------------------------------------------------------------------
--
-- 确定设置密码
--
function SetMinorPassword_OK()

	local strPassword1 = SetMinorPassword_EditBox1:GetText();
	local strPassword2 = SetMinorPassword_EditBox2:GetText();
	
	-- 如果密码不一致
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("密码输入不一致！");
		return;
	end;
	
	local iLen = string.len(strPassword1);
	if(iLen < 4) then
	
		ShowSystemTipInfo("密码不能少于4个字符！");
		return;
	end;
	
	--AxTrace(0, 0, "密码长度"..tostring(iLen));
	-- 如果密码一致。发送改变密码消息。
	SendSetMinorPassword(tostring(strPassword1));
	this:Hide();
	
end;


---------------------------------------------------------------------------------------------------------
--
-- 取消设置密码
--
function SetMinorPassword_Exit()


	this:Hide();
end;

function SetMinorPassword_Frame_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end