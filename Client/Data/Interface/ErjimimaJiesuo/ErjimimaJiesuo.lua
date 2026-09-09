local g_CurrectOperate = 0;  --1为pk状态切换需要的输入窗口. 2为打开银行时候需要的输出窗口
local g_PKModeWant = 0;  --1为pk状态切换需要的输入窗口.


function ErjimimaJiesuo_PreLoad()
	-- 打开界面
	this:RegisterEvent("MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG");
	this:RegisterEvent("OPENINPUTPASSWORD_PKVERIFY");
	this:RegisterEvent("OPENINPUTPASSWORD_BANKVERIFY");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end


function ErjimimaJiesuo_OnLoad()


end

function ErjimimaJiesuo_OnEvent( event )
	if(event == "MINORPASSWORD_OPEN_UNLOCK_PASSWORD_DLG") then
		g_CurrectOperate = 0
		ErjimimaJiesuo_Show()
	end	
	
	if(event == "OPENINPUTPASSWORD_PKVERIFY") then
		g_PKModeWant = tonumber(arg0);
		g_CurrectOperate = 1
		ErjimimaJiesuo_Show()
	end	
	
	if( event == "OPENINPUTPASSWORD_BANKVERIFY" ) then
		g_CurrectOperate = 2
		ErjimimaJiesuo_Show()
	end

	if(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		ErjimimaJiesuo_Close();
	end
end

function ErjimimaJiesuo_Show()
		CloseWindow("SafeTime" , true)
		CloseWindow("ErjimimaXiugai", true)
		CloseWindow("ErjimimaShezhi", true)
		CloseWindow("Fangdao", true)
		
		local safeTimePos = Variable:GetVariable("SafeTimePos");
		if(safeTimePos ~= nil) then
			ErjimimaJiesuo_Frame:SetProperty("UnifiedPosition", safeTimePos);
		end
		this:Show();
		ErjimimaJiesuo_Jiesuo:SetText( "" );
		ErjimimaJiesuo_SoftKey:SetAimEditBox( "ErjimimaJiesuo_Jiesuo" );

		ErjimimaJiesuo_AQtime:SetCheck(0)
		ErjimimaJiesuo_Erjimima:SetCheck(1)
end

function ErjimimaJiesuo_Jiesuo_OnActive()
	ErjimimaJiesuo_SoftKey:SetAimEditBox( "ErjimimaJiesuo_Jiesuo" );
end

function ErjimimaJiesuo_AQtime_Clicked()
	ErjimimaJiesuo_Close();
	OpenDlg4ProtectTime();
end


function ErjimimaJiesuo_Close()
	Variable:SetVariable("SafeTimePos", ErjimimaJiesuo_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function ErjimimaJiesuo_OnHide()
	Variable:SetVariable("SafeTimePos", ErjimimaJiesuo_Frame:GetProperty("UnifiedPosition"), 1);
end

function ErjimimaJiesuo_gotoWeb()
	GameProduceLogin:OpenURL( "http://sde.game.sohu.com/lndex.jsp" )
end

function ErjimimaJiesuo_OK_Click()
	if( 2 == g_CurrectOperate ) then
		local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
		local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("密码不能少于4个字符！");
			return;
		end
		BankAcquireListWithPW( strPassword )
		-- 隐藏窗口.
		ErjimimaJiesuo_Close();
	        return
	end
    
	if( 1 == g_CurrectOperate ) then
		local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
		local iLen = string.len(strPassword);
		if(iLen < 4) then
			ShowSystemTipInfo( "#{UITEXT_PWTOOSHORT}" )   --("密码不能少于4个字符！");
			return;
		end
		Player:ChangePVPModeWithPassword( g_PKModeWant, strPassword )
	        -- 隐藏窗口.
		ErjimimaJiesuo_Close();
		return
	end

	local strPassword = ErjimimaJiesuo_Jiesuo:GetText();
	local iLen = string.len(strPassword);
	if(iLen < 4) then
	
		ShowSystemTipInfo("密码不能少于4个字符！");
		return;
	end;
	-- 解锁密码。
	UnLockMinorPassword(strPassword);
	-- 隐藏窗口.
	ErjimimaJiesuo_Close();
end

--强制解除密码
function ErjimimaJiesuo_Jiechu()
	-- 强制接触密码
	ForceUnLockMinorPassword();
	
	-- 隐藏窗口.
	ErjimimaJiesuo_Close();
end