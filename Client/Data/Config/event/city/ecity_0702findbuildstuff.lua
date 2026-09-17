--MisDescBegin
x600038_g_ScriptId	= 600038
x600038_g_MissionId	= 1111
x600038_g_Name			= "郑无名"
x600038_g_MissionLevel					= 10000
x600038_g_MissionKind						= 50
x600038_g_IfMissionElite				= 0
x600038_g_IsMissionOkFail				= 0	--0 任务完成标记
x600038_g_MissionParam_SubId		= 1	--1 子任务脚本号存放位置
x600038_g_MissionParam_Phase		= 2	--2 阶段号 此号用于区分当前任务UI的描述信息
x600038_g_MissionParam_NpcId		= 3	--3 任务 NPC 的 NPCId 号
x600038_g_MissionParam_ItemId		= 4	--4 任务物品的编号
x600038_g_MissionParam_MonsterId= 5	--5 任务 Monster 的 NPCId 号
x600038_g_MissionParam_IsCarrier= 6	--6 是否有送信任务
x600038_g_MissionRound					= 59
x600038_g_MissionName			= "建设任务"
x600038_g_MissionInfo			= "城市内政－建设任务"								--任务描述
x600038_g_MissionTarget		= "%f"																--任务目标
x600038_g_ContinueInfo		= "    你的任务还没有完成么？"				--未完成任务的npc对话
x600038_g_SubmitInfo			= "    事情进展得如何？"							--完成未提交时的npc对话
x600038_g_MissionComplete	= "    甚好甚好，建筑的进度又加快了。"--完成任务npc说话的话
x600038_g_Parameter_Item_IDRandom = { { id = 4, num = 1 } }
x600038_g_StrForePart			= 2
x600038_g_FormatList			= {
"",
"    密信曰：呈吾族首领启，属下夺得%2i若干，但不幸遭遇%1n所袭，无奈风紧扯乎，请速带兄弟们来支援属下。",	--1 求援书信
"    %3n抢走了%2i，需要你去夺回来。",		--2 寻找建筑材料
"    将%2i交还给帮会大总管。"						--3 送还
}
x600038_g_CityMissionScript	= 600001
x600038_g_ConstructionScript= 600035
--MisDescEnd
