local Current = -1;									--选择的答案号
local Question_Max = 0;							--最大问题数
local Question_Sequence = 0;				--第几题
local CoupleQuestion_Buttons = {}		--每个答案按钮控件容器
local Button_Answer = {}						--每个答案按钮对应的答案编号
local IsEnableOK = 0;
					

local objCared = -1;								--关心NPC的Obj的编号（Server传过来）

function CoupleQuestion_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
end

function CoupleQuestion_OnLoad()
	CoupleQuestion_Buttons[1] = CoupleQuestion_Button_1;
	CoupleQuestion_Buttons[2] = CoupleQuestion_Button_2;
	CoupleQuestion_Buttons[3] = CoupleQuestion_Button_3;
end

function CoupleQuestion_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 888901) then
			CoupleQuestion_OnShown();
	end
end

function CoupleQuestion_OnShown()
	local UI_ID = Get_XParam_STR(0);
	
	if UI_ID == "start" then
		Question_Max = Get_XParam_INT(1)
		CoupleQuestion_ShowQuestion()
		this:Show();
	elseif UI_ID == "timeout" or UI_ID == "oknext" or UI_ID == "failnext" then
		IsEnableOK = 0;
		CoupleQuestion_ShowQuestion()
		this:Show();
	elseif UI_ID == "cancel" then
		CoupleQuestion_Cancel_Clicked();
		AxTrace( 0, 0, "UI_ID(1) "..tostring(UI_ID))
		return;
	else
		AxTrace( 0, 0, "UI_ID(2) "..tostring(UI_ID))
		return;
	end
	
	Current = -1;

	CoupleQuestion_Total_StopWatch:SetProperty("Timer", "60");
	CoupleQuestion_ok:Disable();
	CoupleQuestion_StopWatch_Text:SetText("请选择")
	
end



function CoupleQuestion_ShowQuestion()
	Question_Sequence = Get_XParam_INT(2)
	
	CoupleQuestion_Pageheader : SetText("#gFF0FA0夫妻问答");
	CoupleQuestion_NPCName_Text: SetText("总题数："..tostring(Question_Max))
	CoupleQuestion_Type_Text : SetText("当前题数："..tostring(Question_Sequence))
	CoupleQuestion_Number_Text:SetText("默契指数："..tostring(Get_XParam_INT(3)))
	CoupleQuestion_Text2:SetText("上题结果："..tostring(Get_XParam_STR(5)))

	CoupleQuestion_Text : SetText(Get_XParam_STR(1));

	for j=1,3 do
		CoupleQuestion_Buttons[j]:SetText("");
		CoupleQuestion_Buttons[j]:Enable();
		CoupleQuestion_Buttons[j]:SetProperty("Selected", "False");
	end
										
	for i=2,4 do
		local str_temp = Get_XParam_STR(i);
		local answer_position = Get_XParam_INT(3+i)
		if  str_temp~= "#" and str_temp~="" then
			CoupleQuestion_Buttons[answer_position] : SetText(str_temp)
			Button_Answer[answer_position] = i-1;
		end
	end
end

function CoupleQuestion_Button_Clicked(nAnswerNumber)
	if nAnswerNumber<=0 or nAnswerNumber > 3 then return; end
	
	--for i=1,3 do
	--	if i == nAnswerNumber then
	--		CoupleQuestion_Buttons[i]:SetProperty("Selected", "True");
	--		Current = Button_Answer[i];
	--	else
	--		CoupleQuestion_Buttons[i]:SetProperty("Selected", "False");
	--	end
	--end
	Current = Button_Answer[nAnswerNumber];
	if Current > 0 then
		CoupleQuestion_ok:Enable();
	else
		CoupleQuestion_ok:Disable();
	end
end

function CoupleQuestion_Quit_Clicked()
	Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CoupleQuestion_ClientAction");
			Set_XSCRIPT_ScriptID(888901);
			Set_XSCRIPT_Parameter(0,3);
			Set_XSCRIPT_Parameter(1,-1);
			Set_XSCRIPT_Parameter(2,Question_Sequence);	--modi:lby 增加题号检验检验当前问题是否是正在答的题
			
			Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	--CoupleQuestion_Cancel_Clicked();
end

function CoupleQuestion_Cancel_Clicked()
	--StopCareObject_CoupleQuestion(objCared)
	this:Hide();
	LifeAbility:CloseStrengthMsgBox();	--modi:lby 销毁当前的msg
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_CoupleQuestion(objCaredId)
	this:CareObject(objCaredId, 1, "CoupleQuestion");
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_CoupleQuestion(objCaredId)
	this:CareObject(objCaredId, 0, "CoupleQuestion");
	objCared = -1;
end

function CoupleQuestion_OK_Clicked()
	if Current<0 then return; end
	Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("CoupleQuestion_ClientAction");
			Set_XSCRIPT_ScriptID(888901);
			Set_XSCRIPT_Parameter(0,1);
			Set_XSCRIPT_Parameter(1,Current);
			Set_XSCRIPT_Parameter(2,Question_Sequence);	--modi:lby 增加题号检验检验当前问题是否是正在答的题
			Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
	
	CoupleQuestion_ok:Disable();
	IsEnableOK = 1;
	CoupleQuestion_Time_Event:SetProperty("Timer", "5");	--modi:lby 增加确定按钮计时器
	for j=1,3 do
		CoupleQuestion_Buttons[j]:Disable();
	end
	CoupleQuestion_StopWatch_Text:SetText("请等待对方选择")
end

--modi:lby 增加确定按钮计时器
--按钮定时器响应函数
function CoupleQuestion_TimeReach()
	if IsEnableOK ==1 then
	CoupleQuestion_ok:Enable();
	end
end