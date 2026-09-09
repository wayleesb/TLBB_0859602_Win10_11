--***********************************************************************************************************************************************
-- 复活界面		
--注意，此界面为复活专用，请不要用来做其他用途
--***********************************************************************************************************************************************
local Current_status = 0;
local Current_Quest = -1;
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-- 此处定义需要保存数据的局部变量
--

--------------------------------------------------------
-- 当前对话框的操作类型
local g_Event;

local Event_Relive = 0;
local Event_Callof = 1;


--***********************************************************************************************************************************************
--
-- OnLoad
--
--************************************************************************************************************************************************
function Relive_PreLoad()

	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("RELIVE_REFESH_TIME");

	--拉人技能
	this:RegisterEvent("OPEN_CALLOF_PLAYER");
	
end

function Relive_OnLoad()
end


--***********************************************************************************************************************************************
--
-- 事件响应函数
--
--
--************************************************************************************************************************************************
function Relive_OnEvent(event)
	AxTrace( 0,0, "here");
	if ( event == "RELIVE_SHOW" ) then
	
		Relive_Text:SetText( "你已经死亡，但由于你对人间还有些许执念，你是继续等待还是灵魂出窍？" );
--		Relive_Time_Text:SetText( arg2 );
		Relive_Time_Text : SetProperty("Timer",tostring(arg2));
		--有复活按钮
		if ( arg0 == "1" ) then
			Relive_Fool_Button:Enable();
		--无复活按钮
		else
			Relive_Fool_Button:Disable();
		end
		--有复活按钮
		if ( arg1 == "1" ) then
			Relive_Relive_Button:Enable();
		--无复活按钮
		else
			Relive_Relive_Button:Disable();
		end
		
		Question_Help:Disable();
		Question_Close:Disable();
		Current_status = 0;
		Relive_Fool_Button:SetText("新手");
		Relive_Release_Button:SetText("出窍");
		Relive_Relive_Button:SetText("复活");

		Question_Text:SetText("#gFF0FA0复活");
		this:Show();
		g_Event = Event_Relive;

	elseif ( event == "RELIVE_HIDE" ) then
		Current_status = 0;
		this:Hide();

	elseif ( event == "RELIVE_REFESH_TIME" ) then
	
		Relive_Time_Text : SetProperty("Timer",tostring(arg0));
		Current_status = 0;
	
		
	elseif ( event == "OPEN_CALLOF_PLAYER" )  then
		
		Relive_Text:SetText(arg0 .. "拉你过去，是否同意啊？");
			
		Relive_Release_Button:SetText("确定");
		Relive_Relive_Button:SetText("取消");

		Question_Text:SetText("#gFF0FA0拉人");

		Relive_Time_Text:SetProperty("Timer",tostring( arg3 ));
		this:Show()
		g_Event = Event_Callof;
		
	end
end



--***********************************************************************************************************************************************
--
-- 点击出窍按钮
--
--
--************************************************************************************************************************************************
function Relive_Out_Ghost()

	if( g_Event == Event_Callof )  then
		Friend:CallOf("ok");
		this:Hide();
	
	elseif(g_Event == Event_Relive)then
		if(Current_status == 1) then
			if(Current_Quest > -1) then
				QuestFrameMissionAbnegate(Current_Quest);
			end
			this:Hide();
			return;
		else
			Player:SendReliveMessage_OutGhost();
		end
		
	end

end


--***********************************************************************************************************************************************
--
-- 点击复活按钮
--
--
--***********************************************************************************************************************************************
function Relive_Relive()

	if( g_Event == Event_Relive )  then
		if(Current_status == 1) then
			this:Hide();
			return;
		else
			Player:SendReliveMessage_Relive();
		end;
		 
	elseif(g_Event == Event_Callof)then 
		this:Hide();
	
	end

end

--计时器＝0
function Relive_Time_Zero()
	if( g_Event == Event_Callof )  then
		this:Hide();
	end;

end

function Relive_Out_Fool()
	Player:SendReliveMessage_Fool();
end