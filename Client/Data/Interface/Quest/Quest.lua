local QUEST_STATE_EVENTLIST 				= 1;
local QUEST_STATE_MISSON_INFO 			= 2;
local QUEST_STATE_CONTINUE_DONE 		= 3;
local QUEST_STATE_CONTINUE_NOTDONE 	= 4;
local QUEST_STATE_AFTER_CONTINUE		= 5;
g_nQuestState = 0;
g_nRewardItemID = 0;

local bBeingRadio = 0;
local bRadioSelect = 0;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

local Icon_Preference = {}
function Quest_PreLoad()
	this:RegisterEvent("QUEST_EVENTLIST");
	this:RegisterEvent("QUEST_INFO");
	this:RegisterEvent("QUEST_CONTINUE_DONE");
	this:RegisterEvent("QUEST_CONTINUE_NOTDONE");
	this:RegisterEvent("QUEST_AFTER_CONTINUE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("TOGLE_SKILLSTUDY");
	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("OPEN_ACCOUNT_SAFE");
end

function Quest_OnLoad()

	Icon_Preference[1] = 2
	Icon_Preference[2] = 3
	Icon_Preference[3] = 4
	Icon_Preference[4] = 5
	Icon_Preference[5] = 6
	Icon_Preference[6] = 7
	Icon_Preference[7] = 8
	Icon_Preference[8] = 13
	Icon_Preference[9] = 11
	Icon_Preference[10] = 10
	Icon_Preference[11] = 12
	Icon_Preference[12] = 9
	Icon_Preference[13] = 1
	
end

--=========================================================
-- 事件处理
--=========================================================
function Quest_OnEvent(event)
	local objCared = tonumber(arg0);
	AxTrace(0, 0, "event = ".. event);
	--第一次和npc对话，得到npc所能激活的操作
	if(event == "QUEST_EVENTLIST") then
		--关心NPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_EventListUpdate();


	--在接任务时，看到的任务信息
	elseif(event == "QUEST_INFO") then
		--关心NPC
		BeginCareObject_Quest(objCared)
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_QuestInfoUpdate()


	--接受任务后，再次和npc对话，所得到的任务需求信息，(任务完成)
	elseif(event == "QUEST_CONTINUE_DONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(1);

	--接受任务后，再次和npc对话，所得到的任务需求信息，(任务未完成)
	elseif(event == "QUEST_CONTINUE_NOTDONE") then
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionContinueUpdate(0);

		--关心NPC
		BeginCareObject_Quest(objCared)

	--点击“继续之后”，奖品选择界面
	elseif(event == "QUEST_AFTER_CONTINUE") then
		--关心NPC
		Quest_Open();
		QuestGreeting_Desc:ClearAllElement();
		Quest_MissionRewardUpdate();

	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Quest_Close();

			--取消关心
			StopCareObject_Quest(objCared);
		end

	elseif (event == "TOGLE_SKILLSTUDY") then
		AxTrace(0,0,"打开学习界面，关闭和NPC的对话框");
		Quest_Close();

		--取消关心
		StopCareObject_Quest(objCared);

	elseif (event == "TOGLE_BANK") then
		AxTrace(0,0,"打开银行界面，关闭和NPC的对话框");
		Quest_Close();

		--取消关心
		StopCareObject_Quest(objCared);
	elseif ( event == "REPLY_MISSION" ) then
		Quest_Close();

	-- 播放音效
	elseif ( event == "UI_COMMAND" ) then
		AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == 123 then
			PlaySoundEffect();
		elseif tonumber(arg0) == 124 then
			PlayBackSound()
		elseif tonumber(arg0) == 1000 then
			Quest_Close();
		elseif tonumber(arg0) == 0147005 then
			Quest_Close();
		elseif tonumber(arg0) == 0147006 then
			Quest_Close();
		end

	-- 切换场景
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Quest_Close();
		if objCared then
			StopCareObject_Quest(objCared);
		end
	elseif( event == "OPEN_ACCOUNT_SAFE") then
		Quest_Close();
	end

end

--=========================================================
-- 关闭相应
--=========================================================
function Quest_Close()
	--取消关心
	StopCareObject_Quest(objCared);
end

--=========================================================
-- 显示任务列表
--=========================================================
function Quest_EventListUpdate()
	local nEventListNum = DataPool:GetNPCEventList_Num();
	local i;
	local j =1;
	local k =1;
	local yy = 1;

	local canacceptArr ={}
	local cansubmitArr = {}
	local Sequence_OnefoldGenre = {}
	local Constitutes = {}
	local nTitleType = 0;
	for i=1, nEventListNum do
		local strType,strState,strScriptId,strExtra,strTemp = DataPool:GetNPCEventList_Item(i-1);
		AxTrace(0,0,"return single " .. strType);
		AxTrace(0,0,"return single " .. strState);
		AxTrace(0,0,"return single " .. strScriptId);
		AxTrace(0,0,"return single " .. strExtra);
		AxTrace(0,0,"return single " .. strTemp);
		
		AxTrace(0,0,"return ,,," .. strType..strState..strScriptId..strExtra..strTemp);
		if(strType == "text") then
			QuestGreeting_Desc:AddTextElement(strTemp);
		elseif(strType == "id") then
			if strState <= 0 or strState > 13 then
				strState = 8
			end
			if( tonumber( strScriptId ) == 808007 ) then
				if( strTemp == "我想临时解锁" ) then
					nTitleType = 1
				elseif( strTemp == "我想单个解锁" ) then
					nTitleType = 1
				elseif( strTemp == "全部加锁" ) then
					nTitleType = 2
				elseif( strTemp == "单个加锁" ) then
					nTitleType = 2
				elseif( strTemp == "确认" ) then
					nTitleType = 2
				end
			end
				
			
			strTemp = strTemp .. "&"
			strTemp = strTemp .. strScriptId
			strTemp = strTemp .. ","
			strTemp = strTemp .. strExtra
			strTemp = strTemp .. "$"
			strTemp = strTemp .. strState
			Constitutes = {strTemp,Icon_Preference[strState]}
			if table.getn(Sequence_OnefoldGenre) > 0 then
				local Inserted = 0
				for yy,eachConstitute in Sequence_OnefoldGenre do
					AxTrace(5,5,"yy="..yy)
					if not CompareTable_Quest(eachConstitute,Constitutes) then
						table.insert(Sequence_OnefoldGenre,yy,Constitutes)
						Inserted = 1
						break
					end
				end
				if Inserted == 0 then
					table.insert(Sequence_OnefoldGenre,Constitutes)
				end
			else
				table.insert(Sequence_OnefoldGenre,Constitutes)
			end

		end
	end
	

	for i,PerOption in ipairs(Sequence_OnefoldGenre) do 
		QuestGreeting_Desc:AddOptionElement(PerOption[1]);
	end
	Sequence_OnefoldGenre = {};


	g_nQuestState = QUEST_STATE_EVENTLIST;
	Quest_Frame_Debug:SetText("#gFF0FA0"..Target:GetDialogNpcName());--get npc的name
	if( nTitleType == 1 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0解锁" );
	elseif( nTitleType == 2 ) then
		Quest_Frame_Debug:SetText("#gFF0FA0加锁" );
	end
	AxTrace( 8,0,"title="..Target:GetDialogNpcName() );
	Quest_Button_Continue:SetText("继续");--继续
	Quest_Button_Continue:Disable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("再见");--再见
end

--=========================================================
-- 显示任务信息
--=========================================================
function Quest_QuestInfoUpdate()
	local nTextNum, nBonusNum = DataPool:GetMissionInfo_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionInfo_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

--	QuestGreeting_Desc:AddTextElement("#Y奖励：#W");
	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;

	for i=1, nBonusNum do
		--    奖励的类型，奖励物品ID，奖励多少个
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			
			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "exp") then
			QuestGreeting_Desc:AddTextElement("经验：" .. string.format("%.0f", nNum));
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end	
		elseif(strType == "itemrand") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			if (nRadio == 1) then
				nRadio = 0;
				QuestGreeting_Desc:AddTextElement("#Y完成任务后可选一个作为奖品:#W");
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		end
	end

	g_nQuestState = QUEST_STATE_MISSON_INFO
--	Quest_Frame_Debug:SetText("QUEST_STATE_MISSON_INFO");--get npc的name
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc的name
	end

	Quest_Button_Continue:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "1" );
	Quest_Button_Accept:Enable();
	Quest_Button_Continue:SetText("继续");--继续
	Quest_Button_Refuse:SetText("取消");--取消
end

--=========================================================
--Continue任务的对话框
--=========================================================
function Quest_MissionContinueUpdate(bDone)
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();
	local ActionID;
	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionDemand_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	if( nBonusNum>1 ) then
		QuestGreeting_Desc:AddTextElement("#Y需要物品:#W");
	end

	for i=1, nBonusNum do
		--    需要的类型，需要物品ID，需要多少个
		local nItemID, nNum = DataPool:GetMissionDemand_Item(i-1);
--		QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);
			nItemID = LifeAbility : GetQuestUI_Demand(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end

	end

	if (bDone == 1) then
		g_nQuestState = QUEST_STATE_CONTINUE_DONE;
--		Quest_Frame_Debug:SetText("CONTINUE_DONE");--get npc name
		Quest_Button_Continue:Enable();
	else
		g_nQuestState = QUEST_STATE_CONTINUE_NOTDONE;
--		Quest_Frame_Debug:SetText("CONTINUE_NOTDONE");--get npc name
		Quest_Button_Continue:Disable();
	end

	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc的name
	end

	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("取消");--取消
	Quest_Button_Continue:SetText("继续");--继续

end

--=========================================================
--收取奖励物品的对话框
--=========================================================
function Quest_MissionRewardUpdate()
	g_nQuestState = QUEST_STATE_AFTER_CONTINUE;
	if( Target:IsPresent()) then
		--Quest_Frame_Debug:SetText(Target:GetDialogNpcName());--get npc的name
	end
--	Quest_Frame_Debug:SetText("AFTER_CONTINUE");--get npc name

	Quest_Button_Continue:Enable();
	Quest_Button_Accept:Disable();
	Quest_Button_Accept:SetProperty( "Flash", "0" );
	Quest_Button_Refuse:SetText("取消");--取消
	Quest_Button_Continue:SetText("完成");--完成

	local nTextNum, nBonusNum = DataPool:GetMissionContinue_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionContinue_Text(i-1);
		QuestGreeting_Desc:AddTextElement(strInfo);
	end

	local nRadio = 1;
	local nRadio_Necessary = 1;
	local nItemID;
	local ActionID;
	
	bBeingRadio = 0;
	bRadioSelect = 0;
	for i=1, nBonusNum do
		--    奖励的类型，奖励物品ID，奖励多少个
		local strType, nItemID, nNum = DataPool:GetMissionInfo_Bonus(i-1);

		if(strType == "money") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddMoneyElement(nNum);
		elseif(strType == "exp") then
			QuestGreeting_Desc:AddTextElement("经验：" .. string.format("%.0f", nNum));
		elseif(strType == "item") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 0);		
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 0);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		elseif(strType == "itemrand") then
			if(nRadio_Necessary == 1) then
				QuestGreeting_Desc:AddTextElement("#Y固定奖励:#W")
				nRadio_Necessary = 0;
			end
			QuestGreeting_Desc:AddItemElement(-1, nNum, 0);
		elseif(strType == "itemradio") then
			bBeingRadio = 1;
			if (nRadio == 1) then
				nRadio = 0;
				if nRadio_Necessary == 1 then
					QuestGreeting_Desc:AddTextElement("#Y你可以从以下奖励中选择一项:#W");
				else
					QuestGreeting_Desc:AddTextElement("#Y还可以从以下奖励中选择一项:#W");
				end
				
			end
--			QuestGreeting_Desc:AddItemElement(nItemID, nNum, 1);
			nItemID = LifeAbility : GetQuestUI_Reward(i-1);
--			AxTrace(1,1,"nItemID="..nItemID .." i-1=".. i-1);
			if nItemID ~= -1 then
				ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestGreeting_Desc:AddActionElement(ActionID, nNum, 1);
--				AxTrace(1,1,"ActionID ="..ActionID);
			end
		end
	end

end

--=========================================================
-- 选择一个任务
--=========================================================
function QuestOption_Clicked()

--	AxTrace(0,0,"click " .. arg0);
	--文字的格式是
	--QuestGreeting_option_03#211207,0
	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");

	local strOptionID = -1;
	local strOptionExtra1 = string.sub(arg0, pos2+1,pos3-1 );
	local strOptionExtra2 = string.sub(arg0, pos4+1);

--	AxTrace(0,0,"strOptionExtra1" .. strOptionExtra1);
--	AxTrace(0,0,"strOptionExtra2" .. strOptionExtra2);

--	AxTrace(0,0,"选中ID" .. tonumber(strOptionID));
--	AxTrace(0,0,"选中1Str" .. tonumber(strOptionExtra1));
--	AxTrace(0,0,"选中2Str" .. tonumber(strOptionExtra2));

	QuestFrameOptionClicked(tonumber(strOptionID),tonumber(strOptionExtra1),tonumber(strOptionExtra2));


end

--=========================================================
-- 选择一个多选一的奖励物品
--=========================================================
function RewardItem_Clicked()
	--AxTrace(0, 1, "------------" .. arg0);
	local strRewardItemID = string.sub(arg0, -2, -1);
	g_nRewardItemID = tonumber(strRewardItemID);
	bRadioSelect = 1;
end

--=========================================================
-- Continue & Complete
--=========================================================
function MissionContinue_Clicked()
	if ( g_nQuestState == QUEST_STATE_CONTINUE_DONE ) then
		QuestFrameMissionContinue();
--		Quest_Close();
		--取消关心
--		StopCareObject_Quest(objCared);

	elseif( g_nQuestState == QUEST_STATE_AFTER_CONTINUE )then
		--AxTrace(0, 0, "MissionContinue_Clicked(" .. tostring(g_nRewardItemID) .. ")");
		if(bBeingRadio == 1) then
			if(bRadioSelect == 1)then
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--取消关心
				StopCareObject_Quest(objCared);
			else
				PushDebugMessage("请选择奖励物品！");
			end
		else
				QuestFrameMissionComplete(g_nRewardItemID);
				bBeingRadio = 0;
				bRadioSelect = 0;
				Quest_Close();
				--取消关心
				StopCareObject_Quest(objCared);
		end
	end
end

--=========================================================
-- 接受任务
--=========================================================
function QuestAccept_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameAcceptClicked()
	end

	Quest_Close();
	--取消关心
	StopCareObject_Quest(objCared);
end

--=========================================================
--拒绝任务
--=========================================================
function QuestRefuse_Clicked()
	if(g_nQuestState == QUEST_STATE_MISSON_INFO) then
		QuestFrameRefuseClicked()
	end

	Quest_Close();
	--取消关心
	StopCareObject_Quest(objCared);

	NpcShop:Close();

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Quest(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Quest");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Quest(objCaredId)
	this:CareObject(objCaredId, 0, "Quest");
	g_Object = -1;

end

--=========================================================
--播放音效
--=========================================================
function PlaySoundEffect()
	Sound:PlaySound( Get_XParam_INT(0), false );
end

--=========================================================
--播放背景音乐
--=========================================================
function PlayBackSound()
	Sound:PlaySound( Get_XParam_INT(0),false );
end


function CompareTable_Quest(table_a,table_b)
	if table_a[2] <= table_b[2] then
		return true
	else
		return false
	end
end

function Quest_Open()
	this:Show();
end
function Quest_Close()
	this:Hide();
end