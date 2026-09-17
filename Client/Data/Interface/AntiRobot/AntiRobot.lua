
local g_nUselSeld = -1;
local g_AnswerButton = {}

function AntiRobot_PreLoad()
	this:RegisterEvent("CAPTCHA_ACTIVE");
end

function AntiRobot_OnLoad()
	math.randomseed(os.time());
	
	g_AnswerButton[0] = AntiRobot_Answer1_Check;
	g_AnswerButton[1] = AntiRobot_Answer2_Check;
	g_AnswerButton[2] = AntiRobot_Answer3_Check;
	g_AnswerButton[3] = AntiRobot_Answer4_Check;
	
end

function AntiRobot_OnEvent(event)
	if ( event == "CAPTCHA_ACTIVE" ) then
		g_nUselSeld = -1;
		DataPool:UpdateCaptchaData("AntiRobot_Image", "AntiRobot_Answer1", "AntiRobot_Answer2", "AntiRobot_Answer3", "AntiRobot_Answer4", 1 );
		AntiRobot_Frame:SetProperty("AlwaysOnTop", "True");
		AntiRobot_StopWatch:SetProperty("Timer", "60");
		AntiRobot_Accept:SetProperty("Disabled", "True");

		--激活隐藏输入框，使回车键可以确认答案
		AntiRobot_EnterBox:SetText("");
		AntiRobot_EnterBox:SetProperty("DefaultEditBox", "True");

		g_AnswerButton[0]:SetProperty("Selected", "False");
		g_AnswerButton[1]:SetProperty("Selected", "False");
		g_AnswerButton[2]:SetProperty("Selected", "False");
		g_AnswerButton[3]:SetProperty("Selected", "False");

		--计算随即位置，左上角或者右下角
		local x_Left=math.random()/4.0;
		local y_Top=math.random()/4.0;
		
		AxTrace(0, 0, "AnitRobot(" .. x_Left .. ", " .. y_Top .. ")");
		AntiRobot_Frame:SetProperty("UnifiedPosition", "{{" .. x_Left .. ", 0.0},{" ..  y_Top .. ", 0.0}}");
		
		this:Show();
	end
end

function AntiRobot_SelAnswer(selIndex)
	if(selIndex<0 or selIndex>=4) then 
		return;
	end
	
	--取消原来的选中
	if(g_nUselSeld >=0 and g_nUselSeld<4) then
		g_AnswerButton[g_nUselSeld]:SetProperty("Selected", "False");
	end
	
	g_nUselSeld = selIndex;

	g_AnswerButton[g_nUselSeld]:SetProperty("Selected", "True");
	
	AntiRobot_Accept:SetProperty("Disabled", "False");
end

function AntiRobot_Commit()
	--未选中答案时(例如按回车)不提交
	if(g_nUselSeld<0 or g_nUselSeld >= 4) then
		return;
	end
	DataPool:SelCaptchaAnswer(g_nUselSeld);
	AxTrace(0, 0, "AnitRobotSel = " .. g_nUselSeld);
	this:Hide();
end

function AntiRobot_OnClose()
	--关闭时释放隐藏输入框的键盘焦点
	AntiRobot_EnterBox:SetProperty("DefaultEditBox", "False");
	if(g_nUselSeld<0 or g_nUselSeld >= 4) then
		DataPool:SelCaptchaAnswer(-1);
		AxTrace(0, 0, "AnitRobotSel = -1");
	end
	AntiRobot_StopWatch:SetProperty("Timer", "-1");
end

function AntiRobot_TimeReach()
	if(g_nUselSeld>=0 and g_nUselSeld < 4) then
		AntiRobot_Commit();
		return;
	end

	this:Hide();
end