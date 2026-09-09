





-------------------------------------------------------------------------------------------------------
--
-- 注册事件
--
function ChangeMinorPassword_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("MINORPASSWORD_OPEN_CHANGE_PASSWORD_DLG");
	this:RegisterEvent("MINORPASSWORD_CLEAR_PASSWORD_DLG");
end

function ChangeMinorPassword_OnLoad()
end


--===============================================
-- OnEvent()
--===============================================
function ChangeMinorPassword_OnEvent(event)

	if(event == "MINORPASSWORD_OPEN_CHANGE_PASSWORD_DLG") then
		this:Show();
		ChangeMinorPassword_EditBox1:SetText( "" );
		ChangeMinorPassword_EditBox2:SetText( "" );
		ChangeMinorPassword_EditBox3:SetText( "" );
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "ChangeMinorPassword_EditBox1" );
	elseif(event == "MINORPASSWORD_CLEAR_PASSWORD_DLG") then 
	
		ClearPassword_Box();
	end	
		
end	

function ChangeMinorPassword_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end


-------------------------------------------------------------------------------------------------------
--
-- 点击确认设置二级保护密码按钮。
--
function ChangeMinorPassword_SetPassword()
	
	-- 旧的密码
	local strPasswordOld = ChangeMinorPassword_EditBox1:GetText();
	
	-- 新的密码。
	local strPassword1 = ChangeMinorPassword_EditBox2:GetText(); 
	local strPassword2 = ChangeMinorPassword_EditBox3:GetText();

	
	-- 如果密码不一致
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("密码输入不一致！")
		
		ChangeMinorPassword_EditBox1:SetText("");
		ChangeMinorPassword_EditBox2:SetText(""); 
		ChangeMinorPassword_EditBox3:SetText("");
		return;
	end;
	
	
	local iLenOld = string.len(strPasswordOld);
	local iLenNew = string.len(strPassword1);
	if(iLenOld < 4) then
	
		ShowSystemTipInfo("旧密码不能少于4个字符！");
		return;
	end;
	
	if(iLenNew < 4) then
	
		ShowSystemTipInfo("新密码不能少于4个字符！");
		return;
	end;

	-- 如果密码一致。发送改变密码消息。
	ModifyMinorPassword(strPasswordOld, strPassword1);
	
	this:Hide();

end


-------------------------------------------------------------------------------------------------------
--
-- 点击取消设置二级保护密码按钮。
--
function ChangeMinorPassword_Cancel()
	CloseWindow( "SoftKeyBoard" );
 	this:Hide();
 	
 	-- 打开解锁对话框。 测试。
 	--OpenUnLockeMinorPasswordDlg();
end;

-------------------------------------------------------------------------------------------------------
--
-- 点击帮助按钮
--
function ChangeMinorPassword_Help()

end;


-------------------------------------------------------------------------------------------------------
--
-- 清空密码
--
function ClearPassword_Box()

	-- 旧的密码
	ChangeMinorPassword_EditBox1:SetText("");
	
	-- 新的密码。
	ChangeMinorPassword_EditBox2:SetText(""); 
	ChangeMinorPassword_EditBox3:SetText("");
	
end;


function ChangeMinorPassword_EditBox1_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox1" );
end
function ChangeMinorPassword_EditBox2_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox2" );
end
function ChangeMinorPassword_EditBox3_OnActive()
	SetSoftKeyAim( "ChangeMinorPassword_EditBox3" );
end
