--MisDescBegin
x600042_g_ScriptId	= 600042
x600042_g_MissionId	= 1113
x600042_g_Name			= "郑无名"
x600042_g_MissionLevel		= 10000
x600042_g_MissionKind			= 50
x600042_g_IfMissionElite	= 0
x600042_g_IsMissionOkFail					= 0	--0 任务完成标记
x600042_g_MissionParam_SubId			= 1	--1 子任务脚本号存放位置
x600042_g_MissionParam_Phase			= 2	--2 阶段号，此号用于区分当前任务UI的描述信息
x600042_g_MissionParam_NpcId			= 3	--3 任务NPC的NPCId号
x600042_g_MissionParam_ItemId			= 4	--4 任务物品的编号
x600042_g_Param_sceneid						= 5	--5 当前副本任务的场景号
x600042_g_Param_StateId						= 6	--6 状态
x600042_g_Param_RandomPos					= 7	--7 帮会场景中的随机坐标，前三位为X坐标，后三位为Y坐标( XXX YYY )
x600042_g_MissionRound						= 61
x600042_g_MissionName			= "研究任务"
x600042_g_MissionInfo			= "城市内政－研究任务"									--任务描述
x600042_g_MissionTarget		= "%f"																	--任务目标
x600042_g_ContinueInfo		= "    你的任务还没有完成么？"					--未完成任务的npc对话
x600042_g_SubmitInfo			= "    事情进展得如何？"								--完成未提交时的npc对话
x600042_g_MissionComplete	= "    甚好甚好，研究进度又加快了不少。"--完成任务npc说话的话
x600042_g_Parameter_Item_IDRandom = { { id = 4, num = 1 } }
x600042_g_StrForePart			= 2
x600042_g_FormatList			= {
"",
"    根据线索找出内鬼并取到%2i，送交给%1n。",			--1 副本中打出配方
"    将取到的%2i，送交给%1n。",										--2 找到NPC
"    任务完成，可以到帮会大总管那儿领取奖励了。"	--3 送还
}
x600042_g_CityMissionScript	= 600001
x600042_g_ConstructionScript= 600040
x600042_g_TransScript				= 400900
--MisDescEnd
