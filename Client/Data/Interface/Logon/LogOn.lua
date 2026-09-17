local currentSoftKeyAim = 0;

-- 登陆邮件名列表
local TailName ={
		[0] = "@game.sohu.com",
		"@changyou.com",
		"@Sohu.com",
		"@chinaren.com",
		"@sogou.com",
		"@17173.com",
		}
local g_bLogOnMode;

local PhoneCode ={
	"#{DHMB_080917_001}",
	"#{DHMB_080917_002}",
	"#{DHMB_080917_003}"
}

local PhoneCount = 3

local PhoneIndex = {-1,-1,-1,-1,-1}

local MiBaoDhCount = 0
local PasswdProctectTels = {"", "", "", "", ""}


-- 注册PreLoad事件
function LoginLogOn_PreLoad()
	-- 打开界面
	this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_COUNT_INPUT");
	
	-- 进入游戏后清空帐号
	this:RegisterEvent("GAMELOGIN_CLEAR_ACCOUNT");
	
	-- passport注册失败
	this:RegisterEvent("PASSPORTREG_FAILD");
	this:RegisterEvent("LOGIN_MIBAO");
	
	-- 通知客户端显示密保提示
	this:RegisterEvent("GAMELOGIN_NOTIFY_PASSWDTEL_OPENED");

end

-- 注册onLoad事件
function LoginLogOn_OnLoad()
		
		-- 随机队列设置初值
		for i=1,PhoneCount do
			PhoneIndex[i] = -1
		end 

	-- 生成邮箱帐号的下拉列表
  local TailCount = 6
	local i = 0;
	
	for i = 0, TailCount-1 do
		LogOn_Region:ComboBoxAddItem( TailName[ i ], i );
	end
	LogOn_Region:SetCurrentSelect( 0 );
	
	-- 081014 start /* 如果有文件配置密保，则读配置 */
	-- 从配置文件里随机取3个电话
	--math.randomseed(os.time() + 250);
	math.random(0,100);math.random(0,100)
	local arrIdx = {-1,-1,-1};
	local MAX_TEL_SHOWCOUNT = 3
	local iGetCount = 0
	MiBaoDhCount = GameProduceLogin:GetPasswdTelCount();
	if( MiBaoDhCount > 0 and MiBaoDhCount < 5000 ) then
		while (iGetCount < MiBaoDhCount and iGetCount < MAX_TEL_SHOWCOUNT) do
			local iTmpIdx = math.random(0,MiBaoDhCount-1);
			local bExitIdx = 0;
			for i = 1, iGetCount do
				if (arrIdx[i] == iTmpIdx) then
					bExitIdx = 1;
					break;
				end;
			end;
			if ( 1 ~= bExitIdx ) then
				iGetCount = iGetCount + 1;
				arrIdx[iGetCount] = iTmpIdx;
			end;
		end;
		if (MiBaoDhCount > MAX_TEL_SHOWCOUNT) then --考虑到提示框大小， 密保电话数量限定为3个
			MiBaoDhCount = MAX_TEL_SHOWCOUNT
	end
		
		for i=1,MiBaoDhCount do
			local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
			PasswdProctectTels[i] = strTel;
				end

		local str = "#{DHMB_080917_004}".."#r"
		local str1=""
		for i=1,MiBaoDhCount do
			local strTel = GameProduceLogin:GetPasswdTelByIndex(arrIdx[i]);
			PasswdProctectTels[i] = strTel;
			--str1 = str1..strTel.."  "; -- 索引下标起始和c++里不一样
		end
		
		 --dengxx
    for i=1,MiBaoDhCount-1 do
		  str1 = str1..PasswdProctectTels[i].." ";
	  end
	  str1 = str1..PasswdProctectTels[MiBaoDhCount];
	  str1 = str1.."#r".."#{DHMB_090205_1}"; 
		MiBaoTips_InfoWindow:SetText(str..str1);
		LogOn_MibaoSetToolTip()
		return;
	end
	-- 081014 end /**/
	
	local iNum1 =math.random(1,3); --第一个随机数总是1，加这个增加随机性
	for i=1,PhoneCount do
		bFlag = 0
		while bFlag == 0 do
			local iNum =math.random(1,3);
			if 0 == RandNumExist(iNum) then
				PhoneIndex[i] = iNum
				bFlag = 1
			end
		end 
	end

	local str = "#{DHMB_080917_004}".."#r"
	local str1=""
	--dengxx  显示空间太小，需要少砍掉一个空格
	for i=1,PhoneCount-1 do
		str1 = str1..PhoneCode[PhoneIndex[i]].." ";
	end
	str1 = str1..PhoneCode[PhoneIndex[PhoneCount]];
	str1 = str1.."#r".."#{DHMB_090205_1}"; 
	MiBaoTips_InfoWindow:SetText(str..str1);
end

function RandNumExist(iNum)
	for i=1,PhoneCount do
		if PhoneIndex[i] ==iNum then
			return 1
		end
	end
	return 0
end

-- OnEvent

function LoginLogOn_OnEvent(event)

AxTrace( 1,1, event );

    if( event == "PASSPORTREG_FAILD" ) then
        local FaildInfo = tonumber( arg0 )
        
        if( 1 == FaildInfo ) then  --注册失败
            LogOn_Enroll1_Frame:Hide();
        end
        if( 2 == FaildInfo ) then  --注册已经存在
            LogOn_Enroll1_Frame:Hide();
        end
        if( 3 == FaildInfo ) then  --某些信息填写错误,允许重填
            LogOn_Enroll1_Accept:Enable()
        end
        
    end

	-- 打开帐号输入界面
 	if( event == "GAMELOGIN_OPEN_COUNT_INPUT" ) then
		LogOn_PassWord_Protect_Check:SetCheck(0)
		--LogOn_Phone_Protect_Check:SetCheck(0)
		
		-- 紧急修改，由于外网还没有开通此项服务，先关闭 刘盾 2008.7.30
		--LogOn_Phone_Protect_Check:Disable()
		--LogOn_Phone:Disable()
		
 		AxTrace(0,1,"GAMELOGIN_OPEN_COUNT_INPUT 0")
		this:Show();
		LogOn_Enroll1_Frame:Hide();
			
		if( arg0 == "1" ) then
			LogOn_Enroll1_Frame:Show();
			Logon_Enroll_Init();
			LogOn_Enroll1_Accept:Enable()
			g_bLogOnMode = 1;
		else
			g_bLogOnMode = 0;
			LogOn_Initilize();
		end
		OpenWindow( "SoftKeyBoard" );
		SetSoftKeyAim( "LogOn_PassWord" );	
		return;
	end
		
	
	-- 关闭帐号输入界面
	if( event == "GAMELOGIN_CLOSE_COUNT_INPUT") then
		
		-- 清空密码.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	-- 进入游戏后清空帐号
	if( event == "GAMELOGIN_CLEAR_ACCOUNT") then
		
		-- 清空密码.
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		CloseWindow( "SoftKeyBoard" );
		this:Hide();
		return;
	end
	
	if(event == "LOGIN_MIBAO" and arg0 == "softkey") then
		if( g_bLogOnMode == 1 ) then
			return;
		end
		if( currentSoftKeyAim == 1 ) then
			LogOn_LogonPassWord_Active();
		else
			LogOn_LogonID_Active();
		end
		return;
	end
	
	if(event == "GAMELOGIN_NOTIFY_PASSWDTEL_OPENED") then
		LogOn_MibaoShowSystemInfo(); 
	end
end

function LogOn_Initilize()
		LogOn_LogonID_Active();
		LogOn_PassWord:SetText("");
		LogOn_ID:SetText("");
		LogOn_PassWord:Enable();
		LogOn_ID:Enable();
		
end
----------------------------------------------------------------------------------------------------------
--
-- 退到服务器选择界面
--
function LogOn_ExitToSelectServer()
-- 退到服务器选择界面
	GameProduceLogin:ExitToSelectServer();
	
	--this:Hide();
end


----------------------------------------------------------------------------------------------------------
--
-- 验证用户名和密码
--
function LogOn_CheckAccount()

	-- 退到服务器选择界面
	local strName = LogOn_ID:GetText();
	local strPassword = LogOn_PassWord:GetText();
	local strTail, nIndex = LogOn_Region:GetCurrentSelect();
	local bMiBao = 0;
	if(Variable:GetVariable("System_Region") == "1258") then
		-- Dummy
	else
		bMiBao = LogOn_PassWord_Protect_Check:GetCheck();
	end
	
	if( strTail == tostring( "-1" ) ) then
			strTail = "";
	end
	
	strTail = LogOn_Region:GetText();    --暂时修改,因为GetCurrentSelect的bug,导致在某些操作的时候不能正确取得当前的选择,而界面底层正在修改中,暂时用此函数解决用户名后缀为空的问题BugID:15422
	
	if(Variable:GetVariable("System_Region") == "1258") then
		strTail = "";
	end
	
	AxTrace( 0,0, "验证用户名"..strName.." "..strPassword);
	if( strName =="" ) then
		AxTrace( 0,0, "没有用户");
		return;
	end
	if( strPassword == "" ) then
		AxTrace( 0,0, "没有密码");
		return;
	end
	
--	GameProduceLogin:CheckAccount(strName..strTail, strPassword,bMiBao);
	GameProduceLogin:CheckAccount(strTail, bMiBao);
	if(bMiBao == 0) then
		--帐号密码editbox失去输入焦点
		LogOn_Frame_OnHiden();
	end
	
	-- 清空密码.
	--LogOn_PassWord:SetText("");
end;

--申请帐号
function LogOn_AccountReg()
    GameProduceLogin:StartAccountReg()
end
----------------------------------------------------------------------------------------------------------
--
-- id输入框失去焦点
--
function Logon_ID_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonPassWord_Active();
	end
end

function Logon_LogOn_ID_Return()
	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		LogOn_LogonPassWord_Active();
	end
end

----------------------------------------------------------------------------------------------------------
--
-- 密码输入框失去焦点
--
function Logon_Password_TabPressed()
	if( g_bLogOnMode == 0 ) then
		LogOn_LogonID_Active();
	end
end

function Logon_Password_Return()
	

	if(this:IsVisible() and (not IsWindowShow("LoginSelectServerQuest")) and (not IsWindowShow("FangChenMiRefuse"))) then
		LogOn_CheckAccount();
	end
end

----------------------------------------------------------------------------------------------------------
--
-- 帐号输入
--
function LogOn_ID_MouseEnter()

	LogOn_Info:SetText("在此输入你的账号");     --帐号  to  账号

end


----------------------------------------------------------------------------------------------------------
--
-- 密码输入框失去焦点
--
function LogOn_MouseLeave()

	LogOn_Info:SetText("");
end


function LogOn_PassWord_MouseEnter()

	LogOn_Info:SetText("在此输入你的密码");
end;


------------------------------------------------------------------------------------------------------
--
-- 模拟键盘
--
function LogOn_KeyBoard()
	ToggleWindow( "SoftKeyBoard" );
	SetSoftKeyAim( "LogOn_PassWord" );	
end


function LogOn_Keyboard_MouseEnter()

	LogOn_Info:SetText("如果你在公共场合上网，为了你的账号安全，推荐使用");  --帐号  to  账号
end


function LogOn_LogOnGame_MouseEnter()

	LogOn_Info:SetText("点击登入游戏");
end;

function LogOn_Payment_MouseEnter()

	LogOn_Info:SetText("为你的账号充值");  --帐号  to  账号
end

function LogOn_RequisitionID_MouseEnter()

	LogOn_Info:SetText("申请一个新账号");	--帐号  to  账号
end;

function LogOn_Author_MouseEnter()

	LogOn_Info:SetText("查看游戏开发团队信息");
end;

function LogOn_Last_MouseEnter()

	LogOn_Info:SetText("返回服务器选择界面");
end;

function LogOn_LogonID_Active()
	
	SetSoftKeyAim( "LogOn_ID" );	
	LogOn_ID:SetProperty("DefaultEditBox", "True");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 0;
end

function LogOn_LogonPassWord_Active()
	
	SetSoftKeyAim( "LogOn_PassWord" );	
	LogOn_PassWord:SetProperty("DefaultEditBox", "True");
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	currentSoftKeyAim = 1;
end

function LogOn_Frame_OnHiden()
	LogOn_ID:SetProperty("DefaultEditBox", "False");
	LogOn_PassWord:SetProperty("DefaultEditBox", "False");
end

function Logon_LogOn_Soft_Return()
	if( g_bLogOnMode == 1 ) then
		return;
	end
	if( currentSoftKeyAim == 1 ) then
		
		LogOn_LogonID_Active();
	else
		
		LogOn_LogonPassWord_Active();
	end
	
end

function LogOn_Enroll1_OK(iok)
	local strName 			= LogOn_Enroll1_Name:GetText();
	local strPassword 	= LogOn_Enroll1_Edit1:GetText();
	local strPassEx 		= LogOn_Enroll1_Edit2:GetText();
	local strSupPass  	= LogOn_Enroll1_Edit3:GetText();
	local strSupPassex 	= LogOn_Enroll1_Edit4:GetText();
	local strEmail      = LogOn_Enroll1_Edit6:GetText();
	
	if(iok == 1) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,1, strEmail );
	elseif (iok == 0) then
		GameProduceLogin:CheckBilling1( strName,strPassword,strPassEx,strSupPass,strSupPassex,0, strEmail );
	end
	
	LogOn_Enroll1_Accept:Disable()
	
end
function Logon_Enroll_Init()
	local strName = LogOn_ID:GetText();
	LogOn_Enroll1_Name:SetText( strName );
	LogOn_Enroll1_Edit1:SetText( "");
	LogOn_Enroll1_Edit2:SetText( "" );
	LogOn_Enroll1_Edit3:SetText( "" );
	LogOn_Enroll1_Edit4:SetText( "" );
	LogOn_Enroll1_Edit6:SetText( "" );
	LogOn_PassWord:Disable();
	LogOn_ID:Disable();

end
function LogOn_Enroll1_Cancel()
	g_bLogOnMode = 0;
	LogOn_Enroll1_Frame:Hide();
	LogOn_PassWord:Enable();
	LogOn_ID:Enable();
	
	--发送默认密码
	GameProduceLogin:PassportButNotReg();
	
end

function LogOn_AccountChongZhi()
	if(Variable:GetVariable("System_Region") == "1258") then
    GameProduceLogin:OpenURL( "http://psp.gate.vn" )
	else
    GameProduceLogin:OpenURL( "http://sde.game.sohu.com/" )
  end
end

function Logon_Enroll_PressTable( iIndex )
	
	if( 1 == iIndex ) then
		SetSoftKeyAim( "LogOn_Enroll1_Edit2" );
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 2 == iIndex ) then
		SetSoftKeyAim( "LogOn_Enroll1_Edit3" );
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit2:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 3 == iIndex ) then
		SetSoftKeyAim( "LogOn_Enroll1_Edit4" );
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit3:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 4 == iIndex ) then
		SetSoftKeyAim( "LogOn_Enroll1_Edit6" );
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit4:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	if( 5 == iIndex ) then
		SetSoftKeyAim( "LogOn_Enroll1_Edit1" );
		LogOn_Enroll1_Edit1:SetProperty("DefaultEditBox", "True");
		LogOn_Enroll1_Edit6:SetProperty("DefaultEditBox", "False");
		currentSoftKeyAim = 0;
	end
	
	
end

function LogOn_Show_MibaoPage()
	--暂时越南版和中文版都指向同样的页面，越南版的同学有需要自己改
	if(Variable:GetVariable("System_Region") == "1258") then
    GameProduceLogin:OpenURL( "http://tl.sohu.com/index_fd.shtml" )
	else
    GameProduceLogin:OpenURL( "http://tl.sohu.com/index_fd.shtml" )
	end
end

function PassWordProtectCheckClicked()
	local pwCheck = LogOn_PassWord_Protect_Check:GetCheck();
	if (pwCheck == 1) then
		LogOn_PassWord_Protect_Check:SetCheck(1)
	elseif (pwCheck == 0) then
		LogOn_PassWord_Protect_Check:SetCheck(0)
	end
	--local phCheck = LogOn_Phone_Protect_Check:GetCheck();
	--if( pwCheck == 1 and phCheck == 1 ) then
	--	AxTrace( 1,1, "pwCheck == 1 and phCheck == 1");
	--	LogOn_PassWord_Protect_Check:SetCheck(1)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
		
	--elseif( pwCheck == 1 and phCheck == 0 ) then
	--	AxTrace( 1,1, "pwCheck == 1 and phCheck == 0");
	--	LogOn_PassWord_Protect_Check:SetCheck(1)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
			
	--elseif( pwCheck == 0 and phCheck == 1 ) then
	--	AxTrace( 1,1, "pwCheck == 0 and phCheck == 1");
	--	LogOn_PassWord_Protect_Check:SetCheck(1)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
		
	--elseif( pwCheck == 0 and phCheck == 0 ) then
	--	AxTrace( 1,1, "pwCheck == 0 and phCheck == 0");
	--	LogOn_PassWord_Protect_Check:SetCheck(0)
	--	LogOn_Phone_Protect_Check:SetCheck(0)
	--end
end

--function MibaokaCheckClicked()
	--local pwCheck = LogOn_PassWord_Protect_Check:GetCheck();
--	local phCheck = LogOn_Phone_Protect_Check:GetCheck();
--	AxTrace( 1,1, "onMibaoCheckBoxChangeSelect: "..phCheck.." "..pwCheck);
--	if( pwCheck == 1 and phCheck == 1 ) then
--		AxTrace( 1,1, "pwCheck == 1 and phCheck == 1");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(1)
		
--	elseif( pwCheck == 0 and phCheck == 1 ) then
--		AxTrace( 1,1, "pwCheck == 0 and phCheck == 1");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(1)
			
--	elseif( pwCheck == 1 and phCheck == 0 ) then
--		AxTrace( 1,1, "pwCheck == 1 and phCheck == 0");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(1)
		
--	elseif( pwCheck == 0 and phCheck == 0 ) then
--		AxTrace( 1,1, "pwCheck == 0 and phCheck == 0");
--		LogOn_PassWord_Protect_Check:SetCheck(0)
--		LogOn_Phone_Protect_Check:SetCheck(0)
--	end
--end

function LogOn_MibaoSetToolTip()
	local strStart = "#{DHMB_081014_001_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_001_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount and i ~= 1) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;
		
	end
	strTmp = strTmp..strEnd
	-- LogOn_Phone_Protect_Text:SetProperty("Tooltip", strTmp); --这个不能转义
	--LogOn_Phone_Protect_Text:SetToolTip(strTmp);
end

function LogOn_MibaoShowSystemInfo()
	local strStart = "#{DHMB_081014_003_1}"
	local strCat = "#{WENZI_HUO}"
	local strEnd = "#{DHMB_081014_003_2}"
	local strTmp = strStart
	local strMid = ""
	local i = 0
	for i=1,MiBaoDhCount do
		if ( MiBaoDhCount > 1 and i < MiBaoDhCount) then
			strMid = PasswdProctectTels[i]..","
		elseif ( i == MiBaoDhCount and i ~= 1) then
			strMid = strCat.. PasswdProctectTels[i];
	    else
	        strMid = PasswdProctectTels[i];
		end	
		strTmp = strTmp..strMid;
		
	end
	strTmp = strTmp..strEnd
	GameProduceLogin:GameLoginShowSystemInfo(strTmp);
end