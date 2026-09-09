local g_KeepHeight = 105; --屏幕上方不可覆盖的区域所占的高度
local g_MinHeight = 107; --聊天区域高度的最小值
local g_MaxHeight = 449-28; --聊天区域高度的最大值
local g_MinWidth	=	320;	--聊天区域宽度的最小值
local g_MaxWidth	=	800-180;	--聊天区域宽度的最大值

local g_MoveUpHeight = 70; --屏幕分辨率变化时的上升高度
local g_CurSpeakerName = "";
local channel_config = {};
local CHANNEL_DATA = {};

local channel_seltab = 0;		--默认选择“全部”
local channel_tab = {};
local CHANNEL_TAB_MAX = 7;	--最大有五个页面Tab
local channel_tab_total = 4;	--默认有两个页面Tab, 0 & 1

local channel_sendhis = 0;	--0 不是从发送历史里获取的字串
														--1 是从发送历史里获取的字串
local channel_sendhis2 = 0;

local g_CurFlashTab = -1;

local channel_flash = {};
local CHANNEL_DATA_NEAR = 
	{	
		"set:Buttons image:Channelvicinity_Normal", 		-- 频道选择按钮普通
		"set:Buttons image:ChannelVicinity_Hover", 		-- 频道选择按钮激活
		"set:Buttons image:ChannelVicinity_Pushed",		-- 频道选择按钮按下
		"#cFFFFFF",									-- 聊天内容颜色
		"#e010101#cFFFFFF",						-- 名称【附近】
--		"#91#e010101#cFFFFFF",
	};
	
local CHANNEL_DATA_SCENE = 
	{
		"set:Buttons image:ChannelWorld_Normal", 
		"set:Buttons image:ChannelWorld_Hover", 
		"set:Buttons image:ChannelWorld_Pushed",
		"#cFFFFFF",
		"#e010101#c00FFCC",					--【世界】
--		"#92#e010101#c00FF00",
	};
	
local CHANNEL_DATA_PRIVATE = 
	{
		"set:Buttons image:ChannelPersonal_Normal", 
		"set:Buttons image:ChannelPersonal_Hover", 
		"set:Buttons image:ChannelPersonal_Pushed",
		"#cFFFFFF",
		"#e010101#cFF7C80",					--【私聊】
--		"#98#e010101#c99CC00",
	};

local CHANNEL_DATA_SYSTEM = 
	{
		"set:Buttons image:ChannelPersonal_Normal", 
		"set:Buttons image:ChannelPersonal_Hover", 
		"set:Buttons image:ChannelPersonal_Pushed",
		"#cFF0000",
		"#e010101#cFF0000",					--【系统】
--		"#96#e010101#cFFFF00",
	};
	
local CHANNEL_DATA_TEAM = 
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
		"#cFFFFFF",
		"#e010101#cCC99FF",					--【队伍】
--	"#93#e010101#cFFFF00",
	};

local CHANNEL_DATA_SELF =
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
		"#e010101#cFFFFFF",
--		"#e010101#cFFFF00",				--【自用】
		"nouse",
	};
	
local CHANNEL_DATA_HELP =
	{
		"set:Buttons image:ChannelTeam_Normal", 
		"set:Buttons image:ChannelTeam_Hover", 
		"set:Buttons image:ChannelTeam_Pushed",
		"#e010101#cFFFFFF",
--		"#e010101#cFFFF00",				--【帮助】
		"nouse",
	};
	
local CHANNEL_DATA_MENPAI =
	{
		"set:Buttons image:ChannelMenpai_Normal", 
		"set:Buttons image:ChannelMenpai_Hover", 
		"set:Buttons image:ChannelMenpai_Pushed",
		"#cFFFFFF",
		"#e010101#cFFFF00",					--【门派】
--		"#94#e010101#cFFFF00",
	};

local CHANNEL_DATA_GUILD = 
	{
		"set:Buttons image:ChannelCorporative_Normal", 
		"set:Buttons image:ChannelCorporative_Hover", 
		"set:Buttons image:ChannelCorporative_Pushed",
		"#cFFFFFF",
		"#e010101#cFFCC99",					--【帮会】
--		"#95#e010101#cFFFF00",
	};

local CHANNEL_DATA_GUILD_LEAGUE = 
	{
		"set:CommonFrame6 image:ChannelTongMeng_Normal", 
		"set:CommonFrame6 image:ChannelTongMeng_Hover", 
		"set:CommonFrame6 image:ChannelTongMeng_Pushed",
		"#cFFFFFF",
		"#e010101#c66c4fc",					--【帮会同盟】
--		"#95#e010101#cFFFF00",
	};

local CHANNEL_DATA_IPREGION =
	{
		"set:UIIcons image:ChannelCorporative_Normal", 
		"set:UIIcons image:ChannelCorporative_Hover", 
		"set:UIIcons image:ChannelCorporative_Pushed",
		"#e010101#cFFFFFF",
--		"#e010101#cFFFF00",				--【同城】
		"nouse",
	};

local g_theCurrentChannel = "near";
local g_theCurrentChannelName = "";
local g_MoveCtl = nil;

function ChatFrame_PreLoad()
	this:RegisterEvent("APPLICATION_INITED");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHAT_MESSAGE");
	this:RegisterEvent("CHAT_CHANNEL_CHANGED");
	this:RegisterEvent("CHAT_CHANGE_PRIVATENAME");
	this:RegisterEvent("CHAT_TAB_CREATE_FINISH");
	this:RegisterEvent("CHAT_TAB_CONFIG_FINISH");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("CHAT_CONTEX_MENU");
	this:RegisterEvent("CHAT_ACTSET");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("CHAT_LOAD_TAB_CONFIG");
	this:RegisterEvent("CHAT_MENUBAR_ACTION");
	this:RegisterEvent("RESET_ALLUI");
	this:RegisterEvent("SHOW_SPEAKER");
	this:RegisterEvent("FLASH_TAB");
	
	-- 注册同城频道闪烁, 登录后闪烁X秒
	this:RegisterEvent("UI_COMMAND");
	
end
	
function ChatFrame_OnLoad()
	CHANNEL_DATA["near"] = CHANNEL_DATA_NEAR;
	CHANNEL_DATA["scene"] = CHANNEL_DATA_SCENE;
	CHANNEL_DATA["private"] = CHANNEL_DATA_PRIVATE;
	CHANNEL_DATA["system"] = CHANNEL_DATA_SYSTEM;
	CHANNEL_DATA["team"] = CHANNEL_DATA_TEAM;
	CHANNEL_DATA["self"] = CHANNEL_DATA_SELF;
	CHANNEL_DATA["menpai"] = CHANNEL_DATA_MENPAI;
	CHANNEL_DATA["guild"] = CHANNEL_DATA_GUILD;
	CHANNEL_DATA["guild_league"] = CHANNEL_DATA_GUILD_LEAGUE;
	CHANNEL_DATA["help"] = CHANNEL_DATA_HELP;
	CHANNEL_DATA["ipregion"] = CHANNEL_DATA_IPREGION;
	
	--TAB页的配置信息
	channel_tab[2] = Chat_SelfChk;
	channel_tab[3] = Chat_City;
	channel_tab[4] = Chat_CreateChk1;
	channel_tab[5] = Chat_CreateChk2;
	channel_tab[6] = Chat_CreateChk3;

	channel_flash[3] = Chat_City_Flash
	
	-- 按照GameDefine2.h 中 ENUM_CHAT_TYPE 顺序
	channel_config[0] = {"综合",1,1,1,1,1,1,1,1,0,1,0,0,1};
	channel_config[1] = {"系统",0,0,0,1,1,0,0,0,1,0,0,0,0};
	channel_config[2] = {"个人",0,1,0,1,0,0,1,0,0,0,0,0,1};
	channel_config[3] = {"同城",0,1,0,1,0,0,1,0,0,0,0,1,1};
	channel_config[4] = {"",1,1,1,1,1,1,1,1,1,1,0,0,1};
	channel_config[5] = {"",1,1,1,1,1,1,1,1,1,1,0,0,1};
	channel_config[6] = {"",1,1,1,1,1,1,1,1,1,1,0,0,1};
	
	--隐藏小喇叭
	Chat_ChatSpeaker_StarWindow:SetText( "" );
	Chat_ChatSpeaker_StarWindow:SetProperty( "Name","" );
	Chat_ChatSpeaker_StarWindow:Hide();
	Chat_ChatSpeaker_StarWindow2:Hide();

	NotFlashAllTab()
end

function ChatFrame_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();
		--设置历史消息记录保存的最大值
		Talk:SetMaxSaveNumber(tonumber(Chat_Frame_History:GetProperty("ChatBoardNumber")));
		--设置系统消息的自动消失时间间隔
		Talk:SetDisappearTime(tonumber(Chat_Frame_History:GetProperty("BoardKillTimer")));
		Talk:SetCurTab(channel_seltab);

		ChatFrame_SetTabConfig( 0 );
		ChatFrame_SetTabConfig( 1 );
		ChatFrame_SetTabConfig( 2 );
		ChatFrame_SetTabConfig( 3 );
		channel_tab[3]:SetText("同城");
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, g_theCurrentChannelName);

	elseif (event == "CHAT_MESSAGE" ) then
		--ChatFrame_InsertChatContent(arg0, arg1, arg2);
	elseif (event == "CHAT_CHANNEL_CHANGED" ) then
		ChatFrame_ChannelChanged(arg0);
	elseif (event == "CHAT_TAB_CREATE_FINISH") then
		ChatFrame_CreateTabFinish(arg0,arg1,arg2);
	elseif (event == "CHAT_TAB_CONFIG_FINISH") then
		ChatFrame_ConfigTabFinish(arg0,arg1,arg2);
	elseif (event == "ACCELERATE_KEYSEND") then
		ChatFrame_HandleAccKey(arg0,arg1,arg2);
	elseif (event == "CHAT_CHANGE_PRIVATENAME") then
		ChatFrame_ChangePrivateName(arg0);
	elseif (event == "CHAT_CONTEX_MENU") then
		ChatFrame_ContexMenu_Open(arg0,arg1);
	elseif (event == "CHAT_ACTSET")	then
		ChatFrame_ActSetMessage(arg0);
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		ChatFrame_AdjustMoveCtl(arg0, arg1);
	elseif (event == "CHAT_LOAD_TAB_CONFIG") then
		ChatFrame_LoadTabConfig(arg2,arg0,arg1);
	elseif (event == "CHAT_MENUBAR_ACTION") then
		ChatFrame_HandleMenuBarAction(arg0,arg1,arg2);
	elseif (event == "RESET_ALLUI") then
		-- 隐藏多余的Tab窗体
		channel_tab_total = 4;
		for i= channel_tab_total, CHANNEL_TAB_MAX-1 do
			ChatFrame_SetTabMouseRButtonHollow(i, 1);
			channel_tab[i]:Hide();
		end
		g_theCurrentChannel = "near";
		g_theCurrentChannelName = "";
		channel_seltab = 0;
		--隐藏小喇叭
		Chat_ChatSpeaker_StarWindow:SetText( "" );
		Chat_ChatSpeaker_StarWindow:SetProperty( "Name","" );
		Chat_ChatSpeaker_StarWindow:Hide();
		Chat_ChatSpeaker_StarWindow2:Hide();

		Chat_SystemChk : SetCheck(1)

		NotFlashAllTab()
	elseif (event == "SHOW_SPEAKER") then
		g_CurSpeakerName = arg0;
		g_CurSpeakerContex = arg1;
		if(Player:GetName() == g_CurSpeakerName)then
			Chat_ChatSpeaker_StarWindow:SetText( "#e010101["..tostring( arg0 ).."]#W:"..tostring(arg1) );
		else
			Chat_ChatSpeaker_StarWindow:SetText( "#e010101#c00ccff["..tostring( arg0 ).."]#W:"..tostring(arg1) );
		end
		
		Chat_ChatSpeaker_StarWindow:SetProperty( "Name",tostring(arg0) );
		Chat_ChatSpeaker_StarWindow:SetProperty( "Reset","false" );
		Chat_ChatSpeaker_StarWindow2:SetProperty( "Reset","false" );
		Talk:HideContexMenu4Speaker();

--	取消每次在同城发言中出现按钮闪烁
--	elseif (event == "FLASH_TAB") then
--
--		local showTab = tonumber(arg0);
--		local isShow  = tonumber(arg1);
--		
--		if(showTab > 0 and showTab < CHANNEL_TAB_MAX -1) then
--			if(isShow > 0 ) then
--				FlashTab(showTab);
--			else
--				NotFlashTab(showTab);
--			end
--		end
	
	-- 上线同城频道闪烁
	elseif (event == "UI_COMMAND") then
		if (tonumber( arg0 ) == 870001001) then
			FlashTab(3);
			SetTimer("ChatFrame","StopFlashCityChannel()", 5000);		--设置定时器10秒钟关闭窗口
		end
	end
end

function StopFlashCityChannel()
	NotFlashTab(3);
	KillTimer("StopFlashCityChannel()");		--关闭定时器
end

function NotFlashTab(idx)
	for i =2, 6 do
		if(idx == i and channel_flash[i])then
			g_CurFlashTab = -1;
			channel_flash[i] : Play( false );
		end
	end  
end

function FlashTab(idx)
	for i =2, 6 do
		if(idx == i and channel_flash[i])then
			g_CurFlashTab = idx;
			channel_flash[i] : Play( true );
		end
	end  
end

function NotFlashAllTab()
	for i =2, 6 do
		if(channel_flash[i])then
			
			channel_flash[i] : Play( false );
		end
		
	end  

	g_CurFlashTab = -1;
end

function ChatFrame_TextAccepted(arg)
	--AxTrace(0,0,"ChatFrame_TextAccepted arg:"..arg);
	--local txt = arg;
	--local prvname = Talk:SendChatMessage(g_theCurrentChannel, txt);
	local prvname = arg;
	
	if("" ~= prvname) then
		Talk:HandleHistoryAction("editbox", prvname,"");
	else
		Talk:HandleHistoryAction("editbox", "","");
	end
end

function ChatFrame_ChannelSelect(pos)
	ChatFrame_ChannelSelect_ChangePosition(pos);
	Chat_Frame_ChannelFrame:Show();

	local nChannelNum = Talk:GetChannelNumber();
	Chat_Frame_Channel:ClearAllChannel();
	
	--PushDebugMessage("ChannelNum:"..tostring(nChannelNum))
	
	local i=1;
	local FoundPrv=-1;
	while i<=nChannelNum do
		local strChannelType, strChannelName = Talk:GetChannel(i-1);
		if(strChannelType == "-" or CHANNEL_DATA[strChannelType] == nil) then
			return;
		end
--AxTrace(0,0, "i=" .. i .. "strChannelType=" .. strChannelType .. "strChannelName=" .. strChannelName);
		if(strChannelType ~= "private") then
			Chat_Frame_Channel:AddChannel(strChannelType, CHANNEL_DATA[strChannelType][1], strChannelName);
		else
			FoundPrv = i-1;
		end
		
		i = i+1;
	end
	
	-- 私聊对象列表加入，todo_yangjun
	if(-1 ~= FoundPrv) then
		local strPrvType, strPrvName1, strPrvName2, strPrvName3 = Talk:GetChannel(FoundPrv);
		if(CHANNEL_DATA[strPrvType] == nil) then
			return;
		end
		if(strPrvName1 ~= "" and strPrvName1 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName1);
		end
		if(strPrvName2 ~= "" and strPrvName2 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName2);
		end
		if(strPrvName3 ~= "" and strPrvName3 ~= nil) then
			Chat_Frame_Channel:AddChannel(strPrvType, CHANNEL_DATA[strPrvType][1], strPrvName3);
		end
	end
end

function ChatFrame_ChannelListSelect()
	Chat_Frame_ChannelFrame:Hide();

	local selCh = Chat_Frame_Channel:GetProperty("HoverChannel");
	local prv = Chat_Frame_Channel:GetHoverChannelName();
	
	ChatFrame_ChannelListChange( selCh, prv );
end

function ChatFrame_ChannelListChange( selChannel, prvtxt)

	--PushDebugMessage(selChannel.." - "..prvtxt)

	if(CHANNEL_DATA[selChannel] == nil) then
		return;
	end

	g_theCurrentChannel = selChannel;
	g_theCurrentChannelName = prvtxt;

	Talk:HandleHistoryAction("listChange", g_theCurrentChannel, g_theCurrentChannelName);
	Talk:HandleHistoryAction("modifyTxt", "","");
end

function ChatFrame_ChangePrivateName( newname )
	if(ChatFrame_IsNameMySelf(newname) > 0) then
		return;
	end

	Talk:HandleHistoryAction("privateChange", newname, "");
end

function ChatFrame_InsertChatContent(chatType, chatTalkerName, chatContent)
	if(CHANNEL_DATA[chatType] == nil) then
		return
	end
	
	--if(chatContent == "@" or chatContent == "*") then return; end
	
	local strFinal;
	local strHeader = Talk:GetChannelHeader(chatType, chatTalkerName);
	if(nil == strHeader) then
		--AxTrace(0,0,"Err!!! ChatFrame Type:"..chatType);
		return
	end
	if(chatTalkerName == "" and chatType ~= "self") then
		strFinal = CHANNEL_DATA[chatType][5];
		strFinal = strFinal .. "[" .. strHeader .. "]";
		strFinal = strFinal .. CHANNEL_DATA[chatType][4] ..chatContent;
	else
		if(chatType ~= "self") then
			strFinal = CHANNEL_DATA[chatType][5];
			if(string.byte(chatContent, 1) ~= 64 and string.byte(chatContent, 1) ~= 42) then -- '@' 文字表情解析
				strFinal = strFinal .. "[" .. strHeader .. "]";
				if(ChatFrame_IsNameMySelf(chatTalkerName) > 0) then
					strFinal = strFinal .. "#W[" .. chatTalkerName .. "]";
				else
					--strFinal = strFinal .. "#c00CCFF[#aB{" .. chatTalkerName .. "}" .. chatTalkerName .. "#aE]";
					strFinal = strFinal .. Talk:GetHyperLinkString(chatType,chatTalkerName);
				end
				strFinal = strFinal .. CHANNEL_DATA[chatType][4] .. "：" ..chatContent;
			else
				local strTemplate = Talk:GetTalkTemplateString(chatTalkerName, chatContent);
				strFinal = strFinal .. "[" .. strHeader .. "]";
				strFinal = strFinal .. strTemplate;
			end
		else
			strFinal = CHANNEL_DATA[chatType][4] .. chatContent;
		end
	end
	
	--AxTrace(0, 0, strFinal);
	--if( 0 == channel_seltab ) then
		Chat_Frame_History:InsertChatString(strFinal);
	--else
		--local pos = Talk:GetChannelType(chatType);
		-- todo_yangjun
		--if( 1 == channel_config[channel_seltab][pos+2]) then
			--Chat_Frame_History:InsertChatString(strFinal);
		--end
	--end
	
end

function ChatFrame_PrepareMove()
	g_MoveCtl = {
								frame = Chat_Frame,
								check = Chat_CheckBox_Frame,
								history = Chat_Frame_HistoryFrame,
								
								--nomove = Chat_Frame_NoMoveFrame,
							};
end

function ChatFrame_MoveCtl(dir)
	ChatFrame_PrepareMove();
	
	
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	
	
	local step;
	if(dir > 0) then
		step = -28
		if(absFrameHeight-step > g_MaxHeight) then
			return;
		end
	else
		step = 28;
		if(absFrameHeight-step < g_MinHeight) then
			return;
		end
	end

	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	--AxTrace(0,0,"udimStr:"..udimStr);
	_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
	--AxTrace(0,0,"udimStr:"..udimStr.." udimScale:"..udimScale);
	_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	--AxTrace(0,0,"udimStr:"..udimStr.." udimFrameYPos:"..udimFrameYPos);
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos)+step; --必须小于0，聊天窗口是左下角绑定的

	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	
	--frame
	udimStr = string.format("{%f,%f}", udimScale,udimFrameYPos);
	g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
	
	
	g_MoveCtl.frame:SetProperty("AbsoluteHeight", absFrameHeight-step);
	absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");

--	udimStr = string.format("{%f,-%f}", udimScale,absCheckHeight + 100);

	--check
	g_MoveCtl.check:SetProperty("AbsoluteHeight", absCheckHeight);

	--bakimg
	--history
	g_MoveCtl.history:SetProperty("AbsoluteHeight", absFrameHeight-absCheckHeight);
	g_MoveCtl.history:SetProperty("AbsoluteYPosition", absCheckHeight);

	local starPos;
	strPos = "{1.0,"..tostring( udimFrameYPos -83 )..".0}";
	AxTrace( 0,0,"Position="..tostring( strPos ) );
	Chat_ChatSpeaker:SetProperty("UnifiedYPosition", strPos );

	
	Chat_Frame_History:ScrollToEnd();
end

function ChatFrame_WidthCtl(dir)
	ChatFrame_PrepareMove();
	local absFrameWidth = g_MoveCtl.frame:GetProperty("AbsoluteWidth");
	
	local step;
	if(dir > 0) then
		step = -18
		if(absFrameWidth-step > g_MaxWidth) then
			return;
		end
	else
		step = 18;
		if(absFrameWidth-step < g_MinWidth) then
			return;
		end
	end

	--frame
	g_MoveCtl.frame:SetProperty("AbsoluteWidth", absFrameWidth-step);
	absFrameWidth = g_MoveCtl.frame:GetProperty("AbsoluteWidth");
	
	--history
	g_MoveCtl.history:SetProperty("AbsoluteWidth", absFrameWidth);

	Chat_Frame_History:ScrollToEnd();
end

function ChatFrame_AdjustMoveCtl( screenWidth, screenHeight )
	ChatFrame_PrepareMove();
	Chat_Frame_ChannelFrame:Hide();
	
	local tolHeight = tonumber(screenHeight);
	if(tolHeight < 480) then return end
	
	local absMoveUpHeight = 0;
	--if(tonumber(screenWidth) < 1080) then
		absMoveUpHeight = g_MoveUpHeight;
	--end
	
	local absCheckHeight = g_MoveCtl.check:GetProperty("AbsoluteHeight");
	local absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	
	--界面现在的高度是不是超出显示范围了。
	
	local udimStr = g_MoveCtl.frame:GetProperty("UnifiedYPosition");
	
	local udimScale;
	local udimFrameYPos;
	_,_,udimScale = string.find(udimStr, "{(%d+%.%d+),");
	_,_,udimFrameYPos = string.find(udimStr, ",([+-]?[0-9]+%.[0-9]+)}");
	udimScale = tonumber(udimScale);
	udimFrameYPos = tonumber(udimFrameYPos); --必须小于0，聊天窗口是左下角绑定的
	
	if((absFrameHeight + g_KeepHeight + absMoveUpHeight) > tolHeight) then	
		local newFrameYPos = (tolHeight - g_KeepHeight - absMoveUpHeight)*-1;
		local newFrameHeight = tolHeight - g_KeepHeight - absMoveUpHeight;
		--frame
		udimStr = string.format("{%f,%f}", udimScale,newFrameYPos);
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
		g_MoveCtl.frame:SetProperty("AbsoluteHeight", newFrameHeight);
	else
		local newFrameYPos = (absFrameHeight + absMoveUpHeight)*-1;
		--frame
		udimStr = string.format("{%f,%f}", udimScale,newFrameYPos);
		g_MoveCtl.frame:SetProperty("UnifiedYPosition", udimStr);
	end

	--设置子窗体的位置
	absFrameHeight = g_MoveCtl.frame:GetProperty("AbsoluteHeight");
	
	--check
	g_MoveCtl.check:SetProperty("AbsoluteHeight", absCheckHeight);
	
	--bakimg
	
	--history
	g_MoveCtl.history:SetProperty("AbsoluteHeight", absFrameHeight-absCheckHeight);
	g_MoveCtl.history:SetProperty("AbsoluteYPosition", absCheckHeight);

	Chat_Frame_History:ScrollToEnd();
end

function ChatFrame_AskFrameSizeUP()
	ChatFrame_MoveCtl(1);
end

function ChatFrame_AskFrameSizeDown()
	ChatFrame_MoveCtl(-1);
end

function ChatFrame_AskFrameWidthUP()
	ChatFrame_WidthCtl(1);
end

function ChatFrame_AskFrameWidthDown()
	ChatFrame_WidthCtl(-1);
end

function ChatFrame_ChannelChanged(force)
	if(force == "force_near") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_team" and g_theCurrentChannel == "team") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_menpai" and g_theCurrentChannel == "menpai") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_guild" and g_theCurrentChannel == "guild") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(force == "close_guild_league" and g_theCurrentChannel == "guild_league") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	elseif(g_theCurrentChannel == "private") then
		g_theCurrentChannel = "near"
		Talk:HandleHistoryAction("listChange", g_theCurrentChannel, "");
	end
end

-- 选中某一个Tab对应的频道
function Chat_ChangeTabIndex( nIndex )
	Chat_Frame_History:RemoveAllChatString();
	channel_seltab = nIndex;
	Talk:SetCurTab(channel_seltab);
	
	if channel_config[nIndex] == nil then
		Talk:InsertHistory( nIndex, "" );
	else
		local i = 2;
		local strConfig = "";
		while channel_config[nIndex][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[nIndex][i]);
			i = i+1;
		end
		Talk:InsertHistory( nIndex, strConfig);
	end
	
	Chat_Frame_History:ScrollToEnd();

	if(g_CurFlashTab == channel_seltab and channel_seltab > 0)then
		NotFlashTab(g_CurFlashTab);
	end
end

-- 捕捉Tab按钮失败时的操作
-- add by WTT 2009.4.20
-- 解决 TT：47859	【频道】左下方4个频道栏，左键按住一个频道栏标题，拖动到非频道栏标题后松手，频道栏标题改变，内容不变
function Chat_OnTabCaptureLost (nIndex)
	if nIndex ~= channel_seltab then
		Chat_ChangeTabIndex(nIndex);
	end
end

function ChatFrame_CreateTab(pos)
	if(channel_tab_total+1 > CHANNEL_TAB_MAX) then
		PushDebugMessage("不能创建更多频道");
	else
		--channel_tab_total = channel_tab_total + 1;
		Talk:CreateTab(pos);
		--AxTrace(0, 0, "createTab");
	end
end

function ChatFrame_CreateTabFinish(tabName,tabCfg, strFlg)
	if(tabName == nil or tabCfg == nil or strFlg == nil) then
		--channel_tab_total = channel_tab_total - 1;
		return;
	end
	
	if(strFlg == "cancel") then
		--channel_tab_total = channel_tab_total - 1;
	elseif(strFlg == "sucess") then
		channel_tab_total = channel_tab_total + 1;
		if(tabName == "") then
			tabName = "自建" .. tostring(channel_tab_total - 4);
		end
		
		channel_seltab = channel_tab_total-1;
		ChatFrame_ChangeTabConfig(tabCfg);
		channel_config[channel_seltab][1] = tabName;
		
		--AxTrace(0, 0, "CreateTabFinish Index: " .. tostring(channel_seltab).."Name: "..tostring(channel_config[channel_seltab][1]).." "..tabCfg);
		--保存配置
		Talk:SaveTab(channel_seltab, tabName, tabCfg);
		ChatFrame_SetTabConfig(channel_seltab);
		
		--AxTrace(0, 0, "createTabFinish");
		ChatFrame_SetTabMouseRButtonHollow(channel_seltab, 0);
		channel_tab[channel_seltab]:Show();
		channel_tab[channel_seltab]:SetCheck(1);
		channel_tab[channel_seltab]:SetText(channel_config[channel_seltab][1]);
		Chat_ChangeTabIndex(channel_seltab);
	end
end

function ChatFrame_ConfigTab(pos)
	if(channel_seltab == 0 or channel_seltab == 1) then
		PushDebugMessage("此频道不能配置");
		--AxTrace(0, 0, "此频道不能配置");
		return;
	end
		
	-- 获得当前配置
	local i = 2;
	local strConfig = "";
	--AxTrace(0,0,"channel_config xxxx"..tostring(table.getn(channel_config[channel_seltab])));
	while channel_config[channel_seltab][i] ~= nil do
		strConfig = strConfig .. tostring(channel_config[channel_seltab][i]);
		i = i+1;
	end
	
	ChatFrame_PrintTabConfig(channel_seltab);
	
	--AxTrace(0, 0, "configTab Index: " .. tostring(channel_seltab));
	--AxTrace(0, 0, "configTab: " .. strConfig .. " " .. tostring(channel_seltab) );
	-- 通知程序开始配置
	Talk:ConfigTab( channel_config[channel_seltab][1],strConfig,pos);
end

function ChatFrame_ConfigTabFinish(tabName, tabCfg, strFlg)
	if(tabName == nil or tabCfg == nil or strFlg == nil) then
		return;
	end
	
	if(strFlg == "cancel") then
	elseif(strFlg == "delete") then
		Chat_DestoryTabIndex(channel_seltab);
	elseif(strFlg == "sucess") then
		if(channel_seltab ~= 0) then
			ChatFrame_ChangeTabConfig(tabCfg);
			--Chat_ChangeTabIndex(channel_seltab);
			
			--保存配置
			Talk:SaveTab(channel_seltab, channel_config[channel_seltab][1], tabCfg);
			ChatFrame_SetTabConfig(channel_seltab);
		end
	end
end

-- 更改聊天页面Tab配置
function ChatFrame_ChangeTabConfig( tabCfg )
	local k = 1;
	--AxTrace(0,0,".....config:"..tostring(tabCfg).."!!!");
	--AxTrace(0,0,".....tabn:"..tostring(channel_config[channel_seltab]).."!!!");
	for i = 2, table.getn(channel_config[channel_seltab]) do
		if(string.byte(tabCfg, k) == 48) then -- 0
			channel_config[channel_seltab][i] = 0;
		elseif(string.byte(tabCfg, k) == 49) then -- 1
			channel_config[channel_seltab][i] = 1;
		else
			channel_config[channel_seltab][i] = 0;
		end

		k = k+1;
	end
	ChatFrame_PrintTabConfig(channel_seltab);
end

-- 删除聊天页面Tab
function Chat_DestoryTabIndex( nIndex )
	if( nIndex <= 3 ) then
		PushDebugMessage("此频道不可删除");
		return;
	end
	
	if(channel_tab_total-1 == 3) then
		return;
	end
	
	channel_tab_total = channel_tab_total - 1;
	--AxTrace(0, 0, "Chat_DestoryTabIndex Index: " .. tostring(nIndex) .. " TotalIndex: " .. tostring(channel_tab_total));
	
	-- 向前拷贝配置
	if( channel_tab_total ~= 3 ) then
		local i;
		for i=nIndex, channel_tab_total do
			local k=1;
			while channel_config[i][k] ~= nil and channel_config[i+1][k] ~= nil and i+1<CHANNEL_TAB_MAX do
				channel_config[i][k] = channel_config[i+1][k];
				k = k+1;
			end
			--保存配置
			local xxi = 2;
			local strConfig = "";
			while channel_config[i][xxi] ~= nil do
				strConfig = strConfig .. tostring(channel_config[i][xxi]);
				xxi = xxi+1;
			end
			--AxTrace(0, 0, "SaveTab Index: " .. tostring(i).."Name: "..tostring(channel_config[i][1]).." "..strConfig);
			if(nil ~= channel_config[i][1]) then
				Talk:SaveTab(i, channel_config[i][1], strConfig);
				ChatFrame_SetTabConfig(i);
			end
			--改变文字
			channel_tab[i]:SetText(channel_config[i][1]);
		end
	
		if(channel_seltab == channel_tab_total) then
			channel_seltab = channel_seltab - 1;
		end	
		
		if(1 < channel_seltab) then
			channel_tab[channel_seltab]:SetText(channel_config[channel_seltab][1]);
			channel_tab[channel_seltab]:SetCheck(1);
		end
	else
		channel_seltab = 0;
		Chat_CommonChk:SetCheck(1);
	end

	-- 隐藏多余的Tab窗体
	for i=channel_tab_total, CHANNEL_TAB_MAX-1 do
		ChatFrame_SetTabMouseRButtonHollow(i, 1);
		channel_tab[i]:Hide();
	end	
	Talk:ClearTab(channel_tab_total);
	
	-- 更新ChatHistory里的内容
	Talk:MoveTabHisQue(nIndex, channel_tab_total);
	Chat_ChangeTabIndex(channel_seltab);
end

function ChatFrame_HandleAccKey( op, msg )
	if( nil == op ) then
		return;
	end
	
	--AxTrace(0, 0, op .. " " .. msg);
	if(channel_sendhis == 0 and op == "save_old") then
	elseif( op == "shift_up" or op == "shift_down") then
		Talk:HandleHistoryAction("changMsg", msg,"");
	elseif( op == "acc_prevchannel") then
		ChatFrame_ChangeCurrentChannel(1); --当前频道的前一频道
	elseif( op == "acc_nextchannel") then
		ChatFrame_ChangeCurrentChannel(-1);	--当前频道的后一频道
	elseif( op == "acc_clearchat" ) then
		ChatFrame_extendRegionTest();
	end
end

function ChatFrame_extendRegionTest()
	Chat_Frame_History:ExtendClearRegion();
end

function ChatFrame_ClearSendHis()
	if(1 ~= channel_sendhis2) then
		channel_sendhis = 0;
	end
	
	channel_sendhis2 = 0;
end

function ChatFrame_ChangeCurrentChannel( dir )
	local newtype, newname = Talk:ChangeCurrentChannel( g_theCurrentChannel, g_theCurrentChannelName, dir );
	ChatFrame_ChannelListChange(newtype, newname);
end

function ChatFrame_ContexMenu_Open( strLink,msgid )
	if(nil == strLink or ChatFrame_IsNameMySelf(strLink)>0) then
		return;
	end
	
	Talk:ShowContexMenu( strLink,tonumber(msgid) );
end

function ChatFrame_ActSetMessage( strAct )
	if(strAct == nil or strAct == "") then
		return;
	end
	
	local strKey = "*" .. strAct;
	Talk:SendChatMessage(g_theCurrentChannel, strKey);
end

function ChatFrame_IsNameMySelf( strName )
	if( strName == nil or strName == "") then
		return -1;
	end
	
	local myselfName = Player:GetName();
	if( myselfName == strName) then
		return 1;
	else
		return -1;
	end
end

function ChatFrame_LoadTabConfig(tabIdx, tabName, tabConfig)
	if(nil == tabIdx or nil == tabName or nil == tabConfig) then
		return;
	end
	local selbak = channel_seltab;
	
	local tabId = tonumber(tabIdx);
	if(tabId > 0 and tabId < CHANNEL_TAB_MAX) then
		channel_seltab = tabId;
		ChatFrame_ChangeTabConfig(tabConfig);
		channel_config[channel_seltab][1] = tabName;

		ChatFrame_SetTabMouseRButtonHollow(channel_seltab, 0);
		if(channel_seltab == 3) then	--同城频道特殊处理
			channel_tab[channel_seltab]:SetText("同城");
		else
			channel_tab[channel_seltab]:SetText(channel_config[channel_seltab][1]);
		end
		channel_tab[channel_seltab]:Show();
		if(tabId > 3) then channel_tab_total = channel_tab_total + 1; end
		ChatFrame_SetTabConfig( tabId );
	end
	
	channel_seltab = selbak;
end

function ChatFrame_SetTabConfig( tabIdx )
	if(channel_config[tabIdx] ~= nil) then
		local i = 2;
		local strConfig = "";
		while channel_config[tabIdx][i] ~= nil do
			strConfig = strConfig .. tostring(channel_config[tabIdx][i]);
			i = i+1;
		end
		Talk:SetTabCfg(tabIdx, strConfig);
	end
end

function ChatFrame_SetTabMouseRButtonHollow( tabIdx, op )
	if(nil == tabIdx or tabIdx < 3 or tabIdx >= CHANNEL_TAB_MAX) then return end;

	if(0 == tonumber(op)) then
		channel_tab[tabIdx]:SetProperty("MouseRButtonHollow", "False");
	elseif(1 == tonumber(op)) then
		channel_tab[tabIdx]:SetProperty("MouseRButtonHollow", "True");
	end
end

function ChatFrame_HandleMenuBarAction(op,arg,new)
	if(op == "extendRegion") then
		ChatFrame_extendRegionTest();
	elseif(op == "createTab") then
		ChatFrame_CreateTab(arg);
	elseif(op == "configTab") then
		ChatFrame_ConfigTab(arg);
	elseif(op == "sizeUp") then
		ChatFrame_AskFrameSizeUP();
	elseif(op == "sizeDown") then
		ChatFrame_AskFrameSizeDown();
	elseif(op == "widthUp") then
		ChatFrame_AskFrameWidthUP();
	elseif(op == "widthDown") then
		ChatFrame_AskFrameWidthDown();
	elseif(op == "channelSelect") then
		ChatFrame_ChannelSelect(arg);
	elseif(op == "txtAccept") then
		ChatFrame_TextAccepted(arg);
	elseif(op == "saveChatLog") then
		Talk:SaveChatHistory(channel_seltab);
	elseif(op == "chatbkg") then
		ChatFrame_ChangeChatBkgAlpha(arg);
	elseif(op == "infochannel") then
		ChatFrame_ChannelListChange(arg,new);
	end
end

function ChatFrame_ChannelSelect_ChangePosition(pos)
	Chat_Frame_Channel:SetProperty("AnchorPosition", "x:"..tostring(pos-2).." y:23.0");
end

function ChatFrame_ChangeChatBkgAlpha(val)
	--AxTrace(0,0,"ChatFrame_ChangeChatBkgAlpha val:"..val);
	--Chat_CheckBox_Frame:SetProperty("Alpha", val);
	Chat_Frame_HistoryFrame:SetProperty( "Alpha", val );
	--Chat_Frame_ChannelFrame:SetProperty( "Alpha", val );
end

function ChatFrame_PrintTabConfig(idx)
	if(idx == nil or idx < 0 or idx > 6) then
		return;
	end	
	
	--channel_config[5] = {"",1,1,1,1,0,1,1,1,1};
	local strMsg = "ChatTabConfig idx:"..tostring(idx).." config:";
	for i = 2, table.getn(channel_config[idx]) do
		strMsg = strMsg..tostring(channel_config[idx][i]);
	end
	--AxTrace(0,0,strMsg);
end

function Chat_ChatSpeaker_NameLClick()
	ChatFrame_ChangePrivateName( g_CurSpeakerName );
end
function Chat_ChatSpeaker_NameRClick()
	if(nil == g_CurSpeakerName or ChatFrame_IsNameMySelf(g_CurSpeakerName)>0) then
		return;
	end
	Talk:ShowContexMenu4Speaker( g_CurSpeakerName, g_CurSpeakerContex);
end