--MisDescBegin
x600026_g_ScriptId = 600026
x600026_g_MissionId = 1110
x600026_g_Name = "佟芙蓉"
x600026_g_MissionLevel = 10000
x600026_g_MissionKind = 50
x600026_g_IfMissionElite = 0
x600026_g_IsMissionOkFail			=0	--0 任务完成标记
x600026_g_MissionParam_SubId		=1	--1 子任务脚本号存放位置
x600026_g_Param_sceneid				=2	--2 当前副本任务的场景号
x600026_g_MissionParam_Phase		=3	--3 阶段号 此号用于区分当前任务UI的描述信息
x600026_g_MissionParam_MasterId		=4	--4 门派掌门的NPCId号
x600026_g_MissionParam_MenpaiIndex	=5	--5 某门派的索引，分别用于查找字符串列表中某门派的名称[客户端]以及任务与门派相关的信息[服务器端]
x600026_g_MissionRound = 55
x600026_g_MissionName = "扩张任务"
x600026_g_MissionInfo = ""													--任务描述
x600026_g_MissionTarget = "%f"												--任务目标
x600026_g_ContinueInfo = "    你的任务还没有完成么？"						--未完成任务的npc对话
x600026_g_SubmitInfo = "    事情进展得如何？"								--完成未提交时的npc对话
x600026_g_MissionComplete = "    甚好，此次行动江湖尽知，无不称我帮大德大义。"	--完成任务npc说话的话
x600026_g_StrForePart = 3
x600026_g_FormatList = {
"",
"    找%1n援救该门派大劫大难。",
"    护送%2s弟子走出禁地。",
}
x600026_g_StrList = {
[0] = "少林",
[1] = "明教",
[2] = "丐帮",
[3] = "武当",
[4] = "峨嵋",
[5] = "天龙寺",
[6] = "星宿",
[7] = "天山",
[8] = "逍遥",
}
x600026_g_MenpaiInfo = {
[0] = { Name = "少林",		NpcId = 1700008,	CopySceneName = "塔林",		Type = FUBEN_TALIN1,		    Map = "tongrenxiang_2.nav",		Exit = "tongrenxiang_2_area.ini",	Monster = "tongrenxiang_2_monster_%d.ini", 	EntrancePos = { x = 28, z = 52 },	BackPos = { x = 38, z = 97 }, },
[1] = { Name = "明教",		NpcId = 1700009,	CopySceneName = "光明洞",	Type = FUBEN_GUANGMINGDONG1,	Map = "guangmingdong_2.nav",	Exit = "guangmingdong_2_area.ini",	Monster = "guangmingdong_2_monster_%d.ini", EntrancePos = { x = 19, z = 42 },	BackPos = { x = 98, z = 57 }, },
[2] = { Name = "丐帮",		NpcId = 1700010,	CopySceneName = "酒窖",		Type = FUBEN_JIUJIAO1,			Map = "jiujiao_2.nav",			Exit = "jiujiao_2_area.ini",		Monster = "jiujiao_2_monster_%d.ini", 		EntrancePos = { x = 45, z = 47 },	BackPos = { x = 91, z = 99 }, },
[3] = { Name = "武当",		NpcId = 1700011,	CopySceneName = "灵性峰",	Type = FUBEN_LINGXINGFENG1,		Map = "lingxingfeng_2.nav",		Exit = "lingxingfeng_2_area.ini",	Monster = "lingxingfeng_2_monster_%d.ini", 	EntrancePos = { x = 42, z = 46 },	BackPos = { x = 77, z = 86 }, },
[4] = { Name = "峨嵋",		NpcId = 1700012,	CopySceneName = "桃花阵",	Type = FUBEN_TAOHUAZHEN1,		Map = "taohuazhen_2.nav",		Exit = "taohuazhen_2_area.ini",		Monster = "taohuazhen_2_monster_%d.ini", 	EntrancePos = { x = 26, z = 46 },	BackPos = { x = 96, z = 73 }, },
[5] = { Name = "天龙寺",	NpcId = 1700013,	CopySceneName = "塔底",		Type = FUBEN_TADI1,				Map = "tadi_2.nav",				Exit = "tadi_2_area.ini",			Monster = "tadi_2_monster_%d.ini", 			EntrancePos = { x = 45, z = 48 },	BackPos = { x = 96, z = 67 }, },
[6] = { Name = "星宿",		NpcId = 1700014,	CopySceneName = "五神洞",	Type = FUBEN_WUSHENDONG1,		Map = "wushendong_2.nav",		Exit = "wushendong_2_area.ini",		Monster = "wushendong_2_monster_%d.ini", 	EntrancePos = { x = 14, z = 40 },	BackPos = { x = 142, z = 56 }, },
[7] = { Name = "天山",		NpcId = 1700015,	CopySceneName = "折梅峰",	Type = FUBEN_ZHEMEIFENG1,		Map = "zhemeifeng_2.nav",		Exit = "zhemeifeng_2_area.ini",		Monster = "zhemeifeng_2_monster_%d.ini", 	EntrancePos = { x = 29, z = 49 },	BackPos = { x = 90, z = 45 }, },
[8] = { Name = "逍遥",		NpcId = 1700016,	CopySceneName = "谷底",		Type = FUBEN_GUDI1,				Map = "gudi_2.nav",				Exit = "gudi_2_area.ini",			Monster = "gudi_2_monster_%d.ini", 			EntrancePos = { x = 42, z = 47 },	BackPos = { x = 124, z = 145 }, },
}
x600026_g_CityMissionScript = 600001
x600026_g_ExpandScript = 600023
--MisDescEnd
