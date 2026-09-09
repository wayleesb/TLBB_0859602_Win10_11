local ACTION_BUTTON = {};
local ACTION_BUTTON_NUMBERS = 25;

function Action_PreLoad()
	this:RegisterEvent("CHAT_ACT_SELECT");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end

function Action_OnLoad()
	ACTION_BUTTON[1] = Action_1;
	ACTION_BUTTON[2] = Action_2;
	ACTION_BUTTON[3] = Action_3;
	ACTION_BUTTON[4] = Action_4;
	ACTION_BUTTON[5] = Action_5;
	ACTION_BUTTON[6] = Action_6;
	ACTION_BUTTON[7] = Action_7;
	ACTION_BUTTON[8] = Action_8;
	ACTION_BUTTON[9] = Action_9;
	ACTION_BUTTON[10] = Action_10;
	ACTION_BUTTON[11] = Action_11;
	ACTION_BUTTON[12] = Action_12;
	ACTION_BUTTON[13] = Action_13;
	ACTION_BUTTON[14] = Action_14;
	ACTION_BUTTON[15] = Action_15;
	ACTION_BUTTON[16] = Action_16;
	ACTION_BUTTON[17] = Action_17;
	ACTION_BUTTON[18] = Action_18;
	ACTION_BUTTON[19] = Action_19;
	ACTION_BUTTON[20] = Action_20;
	ACTION_BUTTON[21] = Action_21;
	ACTION_BUTTON[22] = Action_22;
	ACTION_BUTTON[23] = Action_23;
	ACTION_BUTTON[24] = Action_24;
	ACTION_BUTTON[25] = Action_25;
end

function Action_OnEvent( event )
	if( event == "CHAT_ACT_SELECT" ) then
		Action_OnShow(arg0);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		Action_AdjustMoveCtl();
	end
end

function Action_OnShow(pos)
	local i = 1;
	if(this:IsVisible() or this:ClickHide()) then
		this:Hide();
		return;
	end
	Action_ChangePosition(pos);
	while i <= ACTION_BUTTON_NUMBERS do
		local theAction = Talk:EnumChatMood(i-1);
		
		if(theAction:GetID() ~= 0) then
			ACTION_BUTTON[i]:SetActionItem(theAction:GetID());
			ACTION_BUTTON[i]:Enable();
			--local strTip = theAction:GetDesc();
			--ACTION_BUTTON[i]:SetToolTip(strTip);
		else
			ACTION_BUTTON[i]:SetActionItem(-1);
			ACTION_BUTTON[i]:Disable();
			--ACTION_BUTTON[i]:SetToolTip("");
		end
		
		i=i+1;
	end
	
--	local ctl = Chat_SelfActionFrame;
--	ctl:SetProperty("UnifiedXPosition", "{0.0,0.0}");
--	local udimYPos = ctl:GetProperty("UnifiedPosition");
--	local udimSize = ctl:GetProperty("UnifiedSize");
--	AxTrace(0,0,"Action1: Action_AdjustMoveCtl: Pos:"..udimYPos.." Size:"..udimSize);
	
	this:Show();
	
--	udimYPos = ctl:GetProperty("UnifiedPosition");
--	udimSize = ctl:GetProperty("UnifiedSize");
--	AxTrace(0,0,"Action2: Action_AdjustMoveCtl: Pos:"..udimYPos.." Size:"..udimSize);
end

function Action_AdjustMoveCtl()
	this:Hide();
end

function Action_ChangePosition(pos)
	Action_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos.."}");
end

--function Chat_SelfActionFrame_DebugMsg()
--	local all = Chat_SelfActionFrame;
--	local ctl = Action_Frame;
--	
--	local udimXPosition = all:GetProperty("UnifiedXPosition");
--	local udimYPosition = all:GetProperty("UnifiedYPosition");
--	local udimSize = all:GetProperty("UnifiedSize");
--	local absWidth = all:GetProperty("AbsoluteWidth");
--	local absHeight = all:GetProperty("AbsoluteHeight");
--	
--	AxTrace(0,0,"ScreenList: begin------------------------------------------------");
--	AxTrace(0,0,"ScreenList: all:      XPosition:"..udimXPosition);
--	AxTrace(0,0,"ScreenList: all:      YPosition:"..udimYPosition);
--	AxTrace(0,0,"ScreenList: all:           Size:"..udimSize);
--	AxTrace(0,0,"ScreenList: all:  AbsoluteWidth:"..absWidth);	
--	AxTrace(0,0,"ScreenList: all: AbsoluteHeight:"..absHeight);
--
--	udimXPosition = ctl:GetProperty("UnifiedXPosition");
--	udimYPosition = ctl:GetProperty("UnifiedYPosition");
--	udimSize = ctl:GetProperty("UnifiedSize");
--	absWidth = ctl:GetProperty("AbsoluteWidth");
--	absHeight = ctl:GetProperty("AbsoluteHeight");
--	
--	AxTrace(0,0,"ScreenList: ctl:      XPosition:"..udimXPosition);
--	AxTrace(0,0,"ScreenList: ctl:      YPosition:"..udimYPosition);
--	AxTrace(0,0,"ScreenList: ctl:           Size:"..udimSize);
--	AxTrace(0,0,"ScreenList: ctl:  AbsoluteWidth:"..absWidth);	
--	AxTrace(0,0,"ScreenList: ctl: AbsoluteHeight:"..absHeight);
--	AxTrace(0,0,"ScreenList: end--------------------------------------------------");
--end