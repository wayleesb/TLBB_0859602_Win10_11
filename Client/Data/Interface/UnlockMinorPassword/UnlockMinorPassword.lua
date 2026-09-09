g_InputPassword_CurrectOperate = 0;  --1为pk状态切换需要的输入窗口. 2为打开银行时候需要的输出窗口
g_InputPassword_PKModeWant = 0;  --1为pk状态切换需要的输入窗口.

function UnlockMinorPassword_PreLoad()
	
	-- 打开界面
--	this:RegisterEvent("MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG");
--	this:RegisterEvent("OPENINPUTPASSWORD_PKVERIFY");
--	this:RegisterEvent("OPENINPUTPASSWORD_BANKVERIFY");
--	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function UnlockMinorPassword_OnLoad()
end



--===============================================
-- OnEvent()
--===============================================
function UnlockMinorPassword_OnEvent(event)

	if(event == "MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG") then
		this:Show();
		UnLockMinorPassword_MinorPasswordEditBox:SetText( "" );
		UnLockMinorPassword_MinorPasswordEditBox:SetProperty("DefaultEditBox", "True");
		
		g_InputPassword_CurrectOperate = 0
		UnLockMinorPassword_Frame_Title:SetText( "#{INTERFACE_XML_43}" )
		UnLockMinorPassword_WarningText:SetText( "#{INTERFACE_XML_0}" )
		UnLockMinorPassword_ForceUnLock:Show()
		UnLockMinorPassword_ChangeMinorPassword:Show()
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "UnLockMinorPassword_MinorPasswordEditBox" );
	end	
	
	if(event == "OPENINPUTPASSWORD_PKVERIFY") then
		g_InputPassword_PKModeWant = tonumber(arg0);
		UnLockMinorPassword_MinorPasswordEditBox:SetText( "" );
		UnLockMinorPassword_MinorPasswordEditBox:SetProperty("DefaultEditBox", "True");
		UnLockMinorPassword_ForceUnLock:Hide()
		UnLockMinorPassword_ChangeMinorPassword:Hide()
		g_InputPassword_CurrectOperate = 1
		
		UnLockMinorPassword_Frame_Title:SetText( "#{UITEXT_INPUTMINORPW}" )   --( "输入二级密码" )
		UnLockMinorPassword_WarningText:SetText( "#{UITEXT_PKNEEDPW}" )   --( "切换PK模式的时候需要输入二级密码" )
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "UnLockMinorPassword_MinorPasswordEditBox" );
		
		this:Show();
	end	
	
	if( event == "OPENINPUTPASSWORD_BANKVERIFY" ) then
		UnLockMinorPassword_MinorPasswordEditBox:SetText( "" );
		UnLockMinorPassword_MinorPasswordEditBox:SetProperty("DefaultEditBox", "True");
		UnLockMinorPassword_ForceUnLock:Hide()
		UnLockMinorPassword_ChangeMinorPassword:Hide()
		g_InputPassword_CurrectOperate = 2
		
		UnLockMinorPassword_Frame_Title:SetText( "#{UITEXT_INPUTMINORPW}" )   --( "输入二级密码" )
		UnLockMinorPassword_WarningText:SetText( "#{UITEXT_BANKNEEDPW}" )   --( "打开银行需要输入二级密码" )
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "UnLockMinorPassword_MinorPasswordEditBox" );
		
		this:Show();
	end
	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		UnLockMinorPassword_Close();
	end
				
end	
		

----------------------------------------------------------------------------------------------------
--
-- 修改密码。
--
function UnLockMinorPassword_ChangePassword_OnClick()

	-- 打开更改密码对话框。
	OpenChangeMinorPasswordDlg();
	UnLockMinorPassword_Close();
end


----------------------------------------------------------------------------------------------------
--
-- 点击确定按钮。
--
function UnLockMinorPassword_OK()
    if( 2 == g_InputPassword_CurrectOperate ) then
        local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
        local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("密码不能少于4个字符！");
			return;
		end
		
		BankAcquireListWithPW( strPassword )
		
		--Player:ChangePVPModeWithPassword( g_InputPassword_PKModeWant, strPassword )
        -- 隐藏窗口.
	   UnLockMinorPassword_Close();
        return
    end
    
    if( 1 == g_InputPassword_CurrectOperate ) then
        
        local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
        local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("密码不能少于4个字符！");
			return;
		end
		
		Player:ChangePVPModeWithPassword( g_InputPassword_PKModeWant, strPassword )
        -- 隐藏窗口.
	     UnLockMinorPassword_Close();
        return
    end

	local strPassword = UnLockMinorPassword_MinorPasswordEditBox:GetText();
	local iLen = string.len(strPassword);
	if(iLen < 4) then
	
		ShowSystemTipInfo("密码不能少于4个字符！");
		return;
	end;
	
	-- 解锁密码。
	UnLockMinorPassword(strPassword);
	
	-- 隐藏窗口.
	UnLockMinorPassword_Close();

end;


----------------------------------------------------------------------------------------------------
--
-- 强制解除
--
function UnLockMinorPassword_ForceUnLock_OnClick()

	-- 强制接触密码
	ForceUnLockMinorPassword();
	
	-- 隐藏窗口.
	UnLockMinorPassword_Close();
end;



----------------------------------------------------------------------------------------------------
--
-- 退出
--
function UnLockMinorPassword_Cancel()

	-- 打开密码设置按钮
	--OpenSetMinorPasswordDlg();
	
	-- 隐藏窗口.
	UnLockMinorPassword_Close();
		
end;

function UnLockMinorPassword_Frame_OnHiden()
	CloseWindow( "SoftKeyBoard" );
end

function UnLockMinorPassword_Close()
		-- 隐藏窗口.
	
	this:Hide();
end