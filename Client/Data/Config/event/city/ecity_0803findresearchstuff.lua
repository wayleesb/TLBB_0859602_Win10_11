--MisDescBegin
x600043_g_ScriptId	= 600043
x600043_g_MissionId	= 1113
x600043_g_Name			= "郑无名"
x600043_g_MissionLevel					= 10000
x600043_g_MissionKind						= 50
x600043_g_IfMissionElite				= 0
x600043_g_IsMissionOkFail				= 0	--0 任务完成标记
x600043_g_MissionParam_SubId		= 1	--1 子任务脚本号存放位置
x600043_g_MissionParam_Phase		= 2	--2 阶段号 此号用于区分当前任务UI的描述信息
x600043_g_MissionParam_NpcId		= 3	--3 任务 NPC 的 NPCId 号
x600043_g_MissionParam_ItemId		= 4	--4 任务物品的编号
x600043_g_MissionParam_MonsterId= 5	--5 任务 Monster 的 NPCId 号
x600043_g_MissionParam_IsCarrier= 6	--6 是否有送信任务
x600043_g_MissionRound					= 61
x600043_g_MissionName			= "研究任务"
x600043_g_MissionInfo			= "城市内政－研究任务"									--任务描述
x600043_g_MissionTarget		= "%f"																	--任务目标
x600043_g_ContinueInfo		= "    你的任务还没有完成么？"					--未完成任务的npc对话
x600043_g_SubmitInfo			= "    事情进展得如何？"								--完成未提交时的npc对话
x600043_g_MissionComplete	= "    甚好甚好，研究进度又加快了不少。"--完成任务npc说话的话
x600043_g_Parameter_Item_IDRandom = { { id = 4, num = 1 } }
x600043_g_StrForePart			= 2
x600043_g_FormatList			= {
"",
"    找到%2i，交给帮会大总管。",	--1 寻找所需物品
"    将%2i交还给帮会大总管。"			--2 送还
}
x600043_g_CityMissionScript	= 600001
x600043_g_ConstructionScript= 600040
--MisDescEnd
