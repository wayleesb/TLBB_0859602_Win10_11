--MisDescBegin
x600041_g_ScriptId	= 600041
x600041_g_MissionId	= 1113
x600041_g_Name			= "郑无名"
x600041_g_MissionLevel					= 10000
x600041_g_MissionKind						= 50
x600041_g_IfMissionElite				= 0
x600041_g_IsMissionOkFail				= 0	--0 任务完成标记
x600041_g_MissionParam_SubId		= 1	--1 子任务脚本号存放位置
x600041_g_MissionParam_Phase		= 2	--2 阶段号 此号用于区分当前任务UI的描述信息
x600041_g_MissionParam_NpcId		= 3	--3 任务 NPC 的 NPCId 号
x600041_g_MissionParam_ItemId		= 4	--4 任务物品的编号
x600041_g_MissionParam_MonsterId= 5	--5 任务 Monster 的 NPCId 号
x600041_g_MissionParam_IsCarrier= 6	--6 是否有送信任务
x600041_g_MissionRound					= 61
x600041_g_MissionName			= "研究任务"
x600041_g_MissionInfo			= "城市内政－研究任务"									--任务描述
x600041_g_MissionTarget		= "%f"																	--任务目标
x600041_g_ContinueInfo		= "    你的任务还没有完成么？"					--未完成任务的npc对话
x600041_g_SubmitInfo			= "    事情进展得如何？"								--完成未提交时的npc对话
x600041_g_MissionComplete	= "    甚好甚好，研究进度又加快了不少。"--完成任务npc说话的话
x600041_g_Parameter_Item_IDRandom = { { id = 4, num = 1 } }
x600041_g_StrForePart			= 2
x600041_g_FormatList			= {
"",
"    密信曰：呈吾友贵帮首领，所送来的%2i已收到，购入之银两随后奉上。吾当静候大驾来取。友：%1n顿首。",	--1 收条书信
"    找到%3n夺回%2i。",					--2 寻找研究要术
"    将%2i交还给帮会大总管。"		--3 送还
}
x600041_g_CityMissionScript	= 600001
x600041_g_ConstructionScript= 600040
--MisDescEnd
