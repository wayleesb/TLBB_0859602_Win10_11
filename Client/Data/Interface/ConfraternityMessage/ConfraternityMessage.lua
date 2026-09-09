-- ConfraternityMessage.lua
-- 帮会留言界面

local currentChoose = -1											-- 1：确认框；2：输入框；3：查看框
local waitLeaveWordUpdate = 0                 -- 是否正在等待LeaveWord更新

local moneyCosts = 1000												-- 留言消耗

function ConfraternityMessage_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "GUILD_LEAVE_WORD" )						-- 帮会留言
end

function ConfraternityMessage_OnLoad()
	ConfraternityMessage_Clear()
end

function ConfraternityMessage_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19840424 then	-- 打开界面
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end

		currentChoose = 1
		ConfraternityMessage_RefreshWindow()
		this : Show()
		return
	end

	if event == "GUILD_LEAVE_WORD" and this : IsVisible() then		-- 帮会留言
		if currentChoose == 2 then
			return
		end

		currentChoose = 2
		ConfraternityMessage_RefreshWindow()
		return
	end
	
	--准备打开查看留言界面....不直接打开是因为客户端中的LeaveWord可能不是最新的....
	--与帮会总管对话选查看留言时会向world请求最新的LeaveWord....等最新的LeaveWord过来后会发送UI_COMMAND 19841121....到时候再显示留言窗口....
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19841120 then
		
		--设置当前状态为等待LeaveWord更新....
		waitLeaveWordUpdate = 1
		--向World请求帮会留言(更新本地帮会留言)....
		Guild : AskGuildLeaveWord()

	end

	--LeaveWord已经更新....如果当前状态为等待LeaveWord更新则打开查看留言界面....
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19841121 then

		if waitLeaveWordUpdate == 1 then
			currentChoose = 3
			ConfraternityMessage_RefreshWindow()
			this : Show()
			waitLeaveWordUpdate = 0
			return
		end
		
	end

end

function ConfraternityMessage_RefreshWindow()

	local str = ""

	if currentChoose == 1 then										-- 1：确认框；2：输入框。；3：查看框
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_55}" )
		ConfraternityMessage_EditInfo : Hide()
		ConfraternityMessage_Set : Hide()
		ConfraternityMessage_WarningText : SetText( "#{INTERFACE_XML_820}" )
		ConfraternityMessage_WarningText : Show()
		ConfraternityMessage_Ok : Show()
	elseif currentChoose == 2 then									-- 1：确认框；2：输入框。；3：查看框
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_55}" )
		ConfraternityMessage_WarningText : Hide()
		ConfraternityMessage_Ok : Hide()
		ConfraternityMessage_EditInfo : Show()
		ConfraternityMessage_Set : Show()
	elseif currentChoose == 3 then									-- 1：确认框；2：输入框。；3：查看框
		ConfraternityMessage_Title : SetText( "#{INTERFACE_XML_972}" )
		str = Guild : GetGuildLeaveWord();
		ConfraternityMessage_WarningText : SetText( str )
		ConfraternityMessage_WarningText : Show()
		ConfraternityMessage_Ok : Hide()
		ConfraternityMessage_EditInfo : Hide()
		ConfraternityMessage_Set : Hide()
	end
	
end

function ConfraternityMessage_OK_Clicked()
	if currentChoose == 1 then										-- 1：确认框；2：输入框。；3：查看框
		-- 您的金钱不足，请确认
		if (Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" ) )< moneyCosts then
			PushDebugMessage( "你的金钱似乎不足以支付啊。" )
		else
			-- 同意支付
			Guild : ModifyGuildLeaveWord( 1 )
			return
		end
	elseif currentChoose == 2 then									-- 1：确认框；2：输入框。；3：查看框
		local ret = Guild : ModifyGuildLeaveWord( ConfraternityMessage_EditInfo : GetText() )
		if ret == false then
			return
		end
	end

	ConfraternityMessage_Close()
end

function ConfraternityMessage_Cancel_Clicked()
	ConfraternityMessage_Close()
end

function ConfraternityMessage_Close()
	this : Hide()
	ConfraternityMessage_Clear()
end

function ConfraternityMessage_Clear()
	currentChoose = -1
	ConfraternityMessage_EditInfo : SetText( "" )
end
