--当前窗口类型....
local g_TextValidate_UIType = -1;

local g_TextValidate_UITypes = {
	CREATE_ROLE	= 0,	--创建角色验证....
	LOGIN_CHECK	= 1,	--登陆验证....
	EXCHANGE	= 2,		--交易验证....
	LEVELUP_CHECK	= 3,--升级验证....
}

local g_TextValidate_UserLoginType = "";
local g_TextValidate_UserLoginRoleId = -1;
local g_TextValidate_UserLoginScene = -1;


function TextValidate_PreLoad()

	--创建角色....
	this:RegisterEvent("SHOW_CREATE_ROLE_CODE_VALIDATE");	--打开并更新本图形验证界面....
	this:RegisterEvent("CREATE_ROLE_CODE_RET");	--服务端返回验证是否通过....

	--登录....
	this:RegisterEvent("SHOW_LOGIN_CODE_VALIDATE");	--打开并更新本图形验证界面....
	this:RegisterEvent("LOGIN_CODE_RET");	--服务端返回验证是否通过....
	this:RegisterEvent("TEXTVALIDATE_SAVELOGINSELECT");	--缓存玩家验证前的登陆选择....

	---------------------------------------------------------------
	--交易相关begin
	this:RegisterEvent("EXCHANGE_BOX_CLOSED");	--交易盒关闭的时候，要关掉这个框。
	this:RegisterEvent("EXCHANGE_THISBOX_INVALID");	--交易时此对话框已经无效
	this:RegisterEvent("ACCEPT_EXCHANGE_CODE_VALIDATE");	--交易验证码的消息	
	this:RegisterEvent("EXCHANGE_IF_CODE_VALIDATE");	--交易验证码是否通过
	--交易相关end
	---------------------------------------------------------------

	--升级验证....
	this:RegisterEvent("SHOW_LEVELUP_CODE_VALIDATE");	--打开并更新本图形验证界面....
	this:RegisterEvent("LEVELUP_CODE_RET");	--服务端返回验证是否通过....

end

function TextValidate_OnLoad()

end

function TextValidate_OnEvent(event)

	if ( event == "SHOW_CREATE_ROLE_CODE_VALIDATE"  ) then	--打开并更新本图形验证界面....

		g_TextValidate_UIType = g_TextValidate_UITypes.CREATE_ROLE;
		--更新图形验证信息....
		--这个接口是给选择类的图形验证用的....这个输入类的图形验证界面也套用这个接口....
		--5个参数分别是5个控件的名字....参数1是图形控件的名字..参数2~5是答案控件的名字....
		--调用后会刷新验证图片到图形控件....并刷新4个答案到4个答案控件的Text属性....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--如果是首次打开窗口(不是刷新图片)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end

		--每次刷新窗口都随机窗口位置....
		TextValidate_RandomWindowPos()

	elseif event == "CREATE_ROLE_CODE_RET" then	--服务端返回验证是否通过....
		
		if g_TextValidate_UIType ~= g_TextValidate_UITypes.CREATE_ROLE then
			return
		end

		if arg0 == "no" then
			--验证失败
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--验证成功....则关闭界面并切换到人物创建流程....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
		end
		

		--============================================

	elseif ( event == "SHOW_LOGIN_CODE_VALIDATE" ) then	--打开并更新本图形验证界面....

		g_TextValidate_UIType = g_TextValidate_UITypes.LOGIN_CHECK

		--更新图形验证信息....
		--这个接口是给选择类的图形验证用的....这个输入类的图形验证界面也套用这个接口....
		--5个参数分别是5个控件的名字....参数1是图形控件的名字..参数2~5是答案控件的名字....
		--调用后会刷新验证图片到图形控件....并刷新4个答案到4个答案控件的Text属性....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--如果是首次打开窗口(不是刷新图片)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end

		--每次刷新窗口都随机窗口位置....
		TextValidate_RandomWindowPos()

	elseif event == "LOGIN_CODE_RET" then	--服务端返回验证是否通过....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.LOGIN_CHECK then
			return
		end

		if arg0 == "no" then
			--验证失败
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--验证成功....则关闭界面....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
		end

	elseif event == "TEXTVALIDATE_SAVELOGINSELECT" then	--缓存玩家验证前的登陆选择....

		g_TextValidate_UserLoginType = tostring(arg0)
		g_TextValidate_UserLoginRoleId = tonumber(arg2)
		g_TextValidate_UserLoginScene = tonumber(arg3)

	--============================================

	elseif ( event == "SHOW_LEVELUP_CODE_VALIDATE" ) then	--打开并更新本图形验证界面....

		g_TextValidate_UIType = g_TextValidate_UITypes.LEVELUP_CHECK

		--更新图形验证信息....
		--这个接口是给选择类的图形验证用的....这个输入类的图形验证界面也套用这个接口....
		--5个参数分别是5个控件的名字....参数1是图形控件的名字..参数2~5是答案控件的名字....
		--调用后会刷新验证图片到图形控件....并刷新4个答案到4个答案控件的Text属性....
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--如果是首次打开窗口(不是刷新图片)....
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end

		--每次刷新窗口都随机窗口位置....
		TextValidate_RandomWindowPos()

	elseif event == "LEVELUP_CODE_RET" then	--服务端返回验证是否通过....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.LEVELUP_CHECK then
			return
		end

		if arg0 == "no" then
			--验证失败
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--验证成功....则关闭界面....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
		end

	end

	---------------------------------------------------------------
	--交易相关begin
	if  event == "ACCEPT_EXCHANGE_CODE_VALIDATE" then  --交易图形验证，代码在这里有重复，主要是方便合并文件
		g_TextValidate_UIType = g_TextValidate_UITypes.EXCHANGE;
		DataPool:UpdateCaptchaData("TextValidate_Image", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", "TextValidate_NotUse", 2 );

		TextValidate_Input:SetText("");

		--如果不是刷新图片
		if not this:IsVisible() then
			TextValidate_Frame:SetProperty("AlwaysOnTop", "True");
			TextValidate_WarningText:SetText("#{Create_Role_Code_Info}");	--文字就用以前那个
			TextValidate_Accept:SetProperty("Disabled", "False");
			TextValidate_ChangePic:SetProperty("Disabled", "False");
			TextValidate_Close:SetProperty("Disabled", "False");
			TextValidate_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
		end	
		--每次刷新窗口都随机窗口位置....
		TextValidate_RandomWindowPos()
	end
	if  event == "EXCHANGE_THISBOX_INVALID" or event == "EXCHANGE_BOX_CLOSED" then 
		if this:IsVisible() and g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE then	--对于交易来说，这里必须加g_TextValidate_UIType的判断
			this : Hide();	
		end
	end
	if event == "EXCHANGE_IF_CODE_VALIDATE" then	--服务端返回验证是否通过....

		if g_TextValidate_UIType ~= g_TextValidate_UITypes.EXCHANGE then
			return
		end

		if arg0 == "no" then
			--验证失败
			TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		elseif arg0 == "yes" then
			--验证成功....则关闭界面....
			TextValidate_WarningText:SetText("#{Create_Role_Code_Successed}");
			TextValidate_ChangePic:SetProperty("Disabled", "True");
			TextValidate_StopWatch2:SetProperty("Timer", "1");
			Exchange:AcceptExchange();
		end

	end
	--交易相关end
	---------------------------------------------------------------

end

function TextValidate_BtnCommitClick()
		
	--发送玩家输入的字符串给服务端....
	local strInput = TextValidate_Input:GetText();
	if( strInput == "" ) then
		TextValidate_WarningText:SetText("#{Create_Role_Code_Failed}");
		return;
	end
	if g_TextValidate_UIType == g_TextValidate_UITypes.CREATE_ROLE then
		DataPool:SendCreateCharCode( strInput )
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LOGIN_CHECK then
		DataPool:SendLoginCode( strInput )
	elseif (g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE)then	
		 Exchange:SendExchangeCheckCode( strInput )
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LEVELUP_CHECK then
		AnswerLevelUpCode( strInput )
	end
	TextValidate_DisableWindowSomeTime();

end

function TextValidate_BtnCloseClick()
	if (g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE)then	
		 Exchange:SendEnableAcceptBtn();
	end
	this:Hide();
end

function TextValidate_BtnChangePicClick()
	--向Login请求新的图形验证信息....
	if g_TextValidate_UIType == g_TextValidate_UITypes.CREATE_ROLE then
		DataPool:AskCreateCharCode();
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LOGIN_CHECK then
		DataPool:AskLoginCode();
	elseif (g_TextValidate_UIType == g_TextValidate_UITypes.EXCHANGE)then
		Exchange:AskExchangeCheckCode();
	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LEVELUP_CHECK then
		AskNewLevelUpCode();
	end
	TextValidate_DisableWindowSomeTime();
end


--禁用窗口一段时间....防止不断向Login请求图片....
function TextValidate_DisableWindowSomeTime()
	TextValidate_Accept:SetProperty("Disabled", "True");
	TextValidate_ChangePic:SetProperty("Disabled", "True");
	TextValidate_Close:SetProperty("Disabled", "True");
	TextValidate_StopWatch1:SetProperty("Timer", "3");
end

function TextValidate_TimeReach1()
	TextValidate_Accept:SetProperty("Disabled", "False");
	TextValidate_ChangePic:SetProperty("Disabled", "False");
	TextValidate_Close:SetProperty("Disabled", "False");
	TextValidate_StopWatch1:SetProperty("Timer", "-1");
end

function TextValidate_TimeReach2()

	TextValidate_StopWatch2:SetProperty("Timer", "-1");
	TextValidate_Input:SetProperty("DefaultEditBox", "False");
	this:Hide();

	if(g_TextValidate_UIType == g_TextValidate_UITypes.CREATE_ROLE)then		

		GameProduceLogin:ChangeToCreateRoleDlgFromSelectRole();

	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LOGIN_CHECK then

		--根据之前缓存的玩家登录选择自动进入游戏....
		if g_TextValidate_UserLoginType == "NormalLogin" then
			GameProduceLogin:SendEnterGameMsg(g_TextValidate_UserLoginRoleId)
		elseif g_TextValidate_UserLoginType == "NewPlayerLogin" then
			GameProduceLogin:EnterNewRoleScene(g_TextValidate_UserLoginRoleId, g_TextValidate_UserLoginScene)
		end

		g_TextValidate_UserLoginType = "";
		g_TextValidate_UserLoginRoleId = -1;
		g_TextValidate_UserLoginScene = -1;

	elseif g_TextValidate_UIType == g_TextValidate_UITypes.LEVELUP_CHECK then

		AskLevelUpAfterValidate();

	end

end

--**********************************
--随机窗口位置
--**********************************
function TextValidate_RandomWindowPos()

	local x = -95
	local y = 44
	x = x + math.random(-160,160)
	y = y + math.random(-160,160)
	TextValidate_Frame:SetProperty("UnifiedXPosition", "{0.4,"..x.."}")
	TextValidate_Frame:SetProperty("UnifiedYPosition", "{0.2,"..y.."}")

end

---------------------------------------------------------------
-- New begin
function TextValidate_Frame_Hidden()
	TextValidate_Input:SetProperty("DefaultEditBox", "False");
	TextValidate_StopWatch2:SetProperty("Timer", "-1");
	TextValidate_StopWatch1:SetProperty("Timer", "-1");
end
-- New end
---------------------------------------------------------------

function TextValidate_Input_TextAccepted()
	TextValidate_BtnCommitClick()
end