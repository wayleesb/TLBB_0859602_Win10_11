function ErjimimaXiugai_PreLoad()
	-- 打开界面
	this:RegisterEvent("MINORPASSWORD_OPEN_CHANGE");
	this:RegisterEvent("MINORPASSWORD_CLEAR_PASSWORD_DLG");

end


function ErjimimaXiugai_OnLoad()


end

function ErjimimaXiugai_OnEvent( event )
	if(event == "MINORPASSWORD_OPEN_CHANGE") then

		if( this:IsVisible() ) then
			return;
		end
		
		local safeTimePos = Variable:GetVariable("SafeTimePos");
		if(safeTimePos ~= nil) then
			ErjimimaXiugai_Frame:SetProperty("UnifiedPosition", safeTimePos);
		end

		CloseWindow("SafeTime", true)
		CloseWindow("ErjimimaShezhi", true)
		CloseWindow("ErjimimaJiesuo", true)
		CloseWindow("Fangdao", true)

		this:Show();
		ErjimimaXiugai_Before:SetText( "" );
		ErjimimaXiugai_After:SetText( "" );
		ErjimimaXiugai_Queren:SetText( "" );
		ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_Before" );
		ErjimimaXiugai_AQtime:SetCheck(0);
		ErjimimaXiugai_Erjimima:SetCheck(1)

	elseif(event == "MINORPASSWORD_CLEAR_PASSWORD_DLG") then 
	
		ErjimimaXiugai_Before:SetText( "" );
		ErjimimaXiugai_After:SetText( "" );
		ErjimimaXiugai_Queren:SetText( "" );
	end

end

function ErjimimaXiugai_Before_OnActive()
	ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_Before" );
end
function ErjimimaXiugai_After_OnActive()
	ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_After" );
end
function ErjimimaXiugai_Queren_OnActive()
	ErjimimaXiugai_SoftKey:SetAimEditBox( "ErjimimaXiugai_Queren" );
end

function ErjimimaXiugai_AQtime_Clicked()
	ErjimimaXiugai_Close();
	OpenDlg4ProtectTime();
end

function ErjimimaXiugai_Close()
	Variable:SetVariable("SafeTimePos", ErjimimaXiugai_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function ErjimimaXiugai_OnHide()
	Variable:SetVariable("SafeTimePos",ErjimimaXiugai_Frame:GetProperty("UnifiedPosition"), 1);
end

function ErjimimaXiugai_gotoWeb()
	GameProduceLogin:OpenURL( "http://sde.game.sohu.com/lndex.jsp" )
end

function ErjimimaXiugai_OK_Click()
	-- 旧的密码
	local strPasswordOld = ErjimimaXiugai_Before:GetText();
	
	-- 新的密码。
	local strPassword1 = ErjimimaXiugai_After:GetText(); 
	local strPassword2 = ErjimimaXiugai_Queren:GetText();

	
	-- 如果密码不一致
	if(strPassword1 ~= strPassword2) then
	
		ShowSystemTipInfo("密码输入不一致！")
		
		ErjimimaXiugai_Before:SetText( "" );
		ErjimimaXiugai_After:SetText( "" );
		ErjimimaXiugai_Queren:SetText( "" );
		return
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
	
	ErjimimaXiugai_Before:SetText( "" );
	ErjimimaXiugai_After:SetText( "" );
	ErjimimaXiugai_Queren:SetText( "" );
end

--强制解除
function ErjimimaXiugai_Jiechu()
	-- 强制接触密码
	ForceUnLockMinorPassword();
	
	-- 隐藏窗口.
	ErjimimaXiugai_Close();

end