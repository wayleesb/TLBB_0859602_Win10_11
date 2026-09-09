-- 征友平台 : 投票， cuiyinjie 2008.10.21
local g_total_Page = 1; --共有多少页
local g_curr_Page = 1  --当前在那一页
local MAX_INFO_PETPAGE = 10  --每页10条信息

function VotedPlayer_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("ZHENGYOUPT_RESPONSE_VOTEDPLAYERLIST");
end

function VotedPlayer_OnLoad()
	VotedPlayer_List:ClearListBox();
	VotedPlayer_Frame:SetProperty("AlwaysOnTop","True");
end

function VotedPlayer_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "VotedPlayer") then
			this:Show();
		end

	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "VotedPlayer") then
			this:Hide();
		end
	elseif(event == "ZHENGYOUPT_RESPONSE_VOTEDPLAYERLIST")then
		VotedPlayer_InitAndShowWindow();
		VotedPlayer_UpdateVoteInfo();
	end
end

function VotedPlayer_UpdateVoteInfo()
	VotedPlayer_List:ClearListBox();

	local nTotalVoteNum = FindFriendDataPool:GetVoteInfoNum();
	local nPos = (g_curr_Page-1)*MAX_INFO_PETPAGE;
	local nStartPos = nPos;
	local nInListPos = 0;
	AxTrace(0, 0, "nPos"..tostring(nPos)..",nTotalVoteNum:"..tostring(nTotalVoteNum));
	while nPos < nTotalVoteNum and nPos < nStartPos + 10 do
		local nVotedName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(nPos);
		local namecolor = "#cC4B299";				-- 不在线玩家的用户名显示颜色
		if(nOnlineFlag == 1) then
			namecolor = "#W";									-- 在线玩家的用户名显示颜色
		end

		VotedPlayer_List:AddItem( "", nInListPos, "FFFFFFFF", 4 );
		VotedPlayer_List:SetListItemText( nInListPos, namecolor..nVotedName);
		nPos = nPos + 1;
		nInListPos = nInListPos + 1;
	end

	VotedPlayer_UpdateWindowState();
end

function VotedPlayer_InitAndShowWindow()
   this:Show();
   VotedPlayer_List:ClearListBox();
   g_curr_Page = 1;
   local nTotalVoteNum = FindFriendDataPool:GetVoteInfoNum();
   g_total_Page = math.floor(nTotalVoteNum / MAX_INFO_PETPAGE) + 1;
   VotedPlayer_Amount:SetText(g_curr_Page.."/"..g_total_Page);
end

function VotedPlayer_UpdateWindowState()
	local nTotalVoteNum = FindFriendDataPool:GetVoteInfoNum();
   	g_total_Page = math.floor(nTotalVoteNum / MAX_INFO_PETPAGE) + 1;
   	VotedPlayer_Amount:SetText(g_curr_Page.."/"..g_total_Page);
   	
   	AxTrace(0, 0, "g_curr_Page:"..tostring(g_curr_Page)..",g_total_Page:"..tostring(g_total_Page));
   	if(g_curr_Page <= 1) then
		VotedPlayer_PageUp:Disable();
	else
		VotedPlayer_PageUp:Enable();
	end

	if(g_curr_Page == g_total_Page) then
		VotedPlayer_PageDown:Disable();
	else
		VotedPlayer_PageDown:Enable();		
	end
end

function VotedPlayer_PageUp_Func()
	if(g_curr_Page >1) then
		g_curr_Page = g_curr_Page - 1;
		VotedPlayer_UpdateVoteInfo();
	end
end

function VotedPlayer_PageDown_Func()
	if(g_curr_Page < g_total_Page) then
		g_curr_Page = g_curr_Page + 1;
		VotedPlayer_UpdateVoteInfo();
	end
end

function VotedPlayer_PlayerSelect(arg0)
	if(arg0 == 0) then
		AxTrace(0,0,"Click VotePlayer");
	elseif(arg0 == 1) then
		local nIndex = VotedPlayer_List:GetFirstSelectItem();
		local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(nIndex);
		local player = Player:GetName();   
		if(szName == player) then
			--PushDebugMessage("对不起，这是您自己投的票。");
			return;
		end
		if (szName ~= nil) then
			DataPool:OpenMail( szName );
		end
	end
end

function VotedPlayer_OpenMenu()
	local nIndex = VotedPlayer_List:GetFirstSelectItem();
	AxTrace(0,0,"Index is:"..tostring(nIndex));
	local szName, nOnlineFlag = FindFriendDataPool:GetVoteInfoByPos(nIndex);
	if (nOnlineFlag ~= 1) then
		--PushDebugMessage("对不起，玩家 "..szName.." 目前不在线！");
		return;
	end
	local player = Player:GetName();   
	if(szName == player) then
		--PushDebugMessage("对不起，这是您自己投的票。");
		return;
	end
	FindFriendDataPool:ContexMenuForVoteInfo(nIndex);
end

function VotedPlayer_Hide()
   this:Hide();
end

