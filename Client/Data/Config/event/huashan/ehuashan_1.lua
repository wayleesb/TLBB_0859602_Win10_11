--MisDescBegin
x001230_g_ScriptId = 1230
x001230_g_Update = {
["id01"] = 0,
["id02"] = 20,
["id03"] = 30,
}
x001230_g_msg = {
["cj"]	= "参加华山论剑",
["jl"]	= "领取华山论剑奖励",
["Mail"]	= "确认奖励",
}
x001230_g_nActivityId = 9
x001230_g_nScnenId = 125
x001230_g_bHuashaning = 0
x001230_g_nMenpaikills = {{id=0,kill=0},
{id=1,kill=0},
{id=2,kill=0},
{id=3,kill=0},
{id=4,kill=0},
{id=5,kill=0},
{id=6,kill=0},
{id=7,kill=0},
{id=8,kill=0},}
x001230_g_nMenpaiQiansan = {{id=0,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=1,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=2,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=3,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=4,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=5,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=6,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=7,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},
{id=8,player01="",player02="",player03="",playerid01=0,playerid02=0,playerid03=0},}
x001230_g_nMenpaiShiZhuang = {{id=10124009,name="空色"},
{id=10124010,name="圣火"},
{id=10124011,name="碧陌"},
{id=10124013,name="鹤雪"},
{id=10124012,name="泣影"},
{id=10124014,name="凶落"},
{id=10124017,name="阳潇"},
{id=10124015,name="月漫"},
{id=10124016,name="幻殇"},}
x001230_g_nCailiaoJiangli	 = {{id=20500000,name="精铁碎片"},
{id=20501000,name="棉布碎片"},
{id=20502000,name="秘银碎片"},}
x001230_g_bEndTime = 0
x001230_g_bMenpai = ""
x001230_g_WorldGlobal = 21
x001230_g_PlayerKc = {}				-- 每个玩家杀人的数目
x001230_g_PlayerName = {}			-- 每个玩家的名字
x001230_g_PlayerNum = 0				-- 玩家数目
x001230_g_PlayerMenpai = {}		-- 每个玩家的门派
x001230_g_PlayerId = {}
x001230_g_PreTime = 0
x001230_g_MJPosA = {
{x=135, y=125},{x=141, y=123}
}
x001230_g_MJPosB = {
{x=143, y=140, rand=-1},
{x=153, y=121, rand=-1},
{x=150, y=110, rand=-1},
{x=138, y=104, rand=-1},
{x=125, y=107, rand=-1},
{x=120, y=111, rand=-1},
{x=122, y=132, rand=-1},
{x=131, y=138, rand=-1}
}
x001230_g_MJTblA = {
5009,5010
}
x001230_g_MJTblB = {
5004,5005,5006,5007,5008
}
x001230_g_MJNameTbl = {
"紫色秘笈",
"黄色秘笈",
"绿色秘笈",
"白色秘笈",
"黑色秘笈",
"蓝色秘笈",
"红色秘笈"
}
x001230_g_MJScript = 001235
function x001230_OnDefaultEvent( sceneId, selfId, targetId )
local	key	= GetNumText()
if key == x001230_g_Update["id01"] then
if LuaFnHasTeam( sceneId, selfId ) ~= 0  then
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  请离开队伍之后再报名参加。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return 0
end
if LuaFnGetDRideFlag(sceneId, selfId) ~= 0  then
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  双人骑乘状态下，不能报名参加华山论剑。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return 0
end
if GetLevel(sceneId, selfId) < 30  then
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  参加华山论剑必须要30级以上才能参加，阁下修为还不够，等到30级之后再来找我吧。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return 0
end
local nWeek = GetTodayWeek()
if (nWeek==0 or nWeek==4 or nWeek==2) ~= 1  then
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  现在不是参加华山论剑的报名时间，请于周二、周四和周日再来。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return
end
local nQuarter = mod(GetQuarterTime(),100);
if ((nWeek==0) and (nQuarter < 60 or nQuarter >= 62 )) or 
( (nWeek==2 or nWeek==4) and (nQuarter < 76 or nQuarter >= 78))  then		--报名时间2 4的19:00-19:30，日的15:00-15:30
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  现在不是参加华山论剑的报名时间，等到活动开始的时候再来找我吧。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return
end
local nMenpai = LuaFnGetMenPai(sceneId, selfId)
if nMenpai == 9   then
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  对不起，你没有门派，你是怎么混到30级的啊！！！");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return 0
end
local nPeopleNum = GetActivityParam(sceneId, x001230_g_nActivityId, nMenpai)
if nPeopleNum < 10 then
elseif nPeopleNum >=10 and nPeopleNum < 30  then
for i=0, 8   do
if nMenpai ~= i   then
if GetActivityParam(sceneId, x001230_g_nActivityId, nMenpai) >= nPeopleNum  then
end
end
end
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  对不起，本次华山论剑贵门派参加的人数过多，请等待其他门派人进入之后再进入。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return 0
elseif nPeopleNum >= 30  then
BeginEvent(sceneId)
AddText(sceneId,"#B华山论剑");
AddText(sceneId,"  对不起，贵门派参加的人数已满30人。");
EndEvent(sceneId)
DispatchEventList(sceneId,selfId,targetId)
return 0
end
local nPos_X;
local nPos_Z;
if nMenpai == 0  then
nPos_X = 134
nPos_Z = 18
elseif nMenpai == 1   then
nPos_X = 22
nPos_Z = 123
elseif nMenpai == 2   then
nPos_X = 236
nPos_Z = 108
elseif nMenpai == 3   then
nPos_X = 193
nPos_Z = 233
elseif nMenpai == 4   then
nPos_X = 93
nPos_Z = 236
elseif nMenpai == 5   then
nPos_X = 236
nPos_Z = 174
elseif nMenpai == 6   then
nPos_X = 23
nPos_Z = 182
elseif nMenpai == 7   then
nPos_X = 48
nPos_Z = 34
elseif nMenpai == 8   then
nPos_X = 228
nPos_Z = 38
elseif nMenpai == 9   then
nPos_X = 100
nPos_Z = 100
end
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 0 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 0 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 0 )
CallScriptFunction((400900), "TransferFunc",sceneId, selfId, x001230_g_nScnenId, nPos_X, nPos_Z)
LuaFnAuditQuest(sceneId, selfId, "华山论剑")
elseif key == x001230_g_Update["id02"] then
local nWeek = GetTodayWeek()
local nQuarter = mod(GetQuarterTime(),100);
if ( (nWeek==0) and (nQuarter < 68 and nQuarter >= 64) ) 
or( (nWeek==2 or nWeek==4) and (nQuarter < 84 and nQuarter >= 80) )  then
x001230_OnHuashanJiangli( sceneId, selfId, targetId )
return 0
else            
x001230_MyMsgBox( sceneId, selfId, "领取华山论剑奖励的时间已过，等到活动结束一个小时内再来找我吧。" )
return 0		
end
elseif key == x001230_g_Update["id03"] then
local index01 =	GetMissionFlag( sceneId, selfId, MF_LunjianJiangli01 )
local index02 =	GetMissionFlag( sceneId, selfId, MF_LunjianJiangli02 )
local index03 =	GetMissionFlag( sceneId, selfId, MF_LunjianJiangli03 )
if ( index01 == 1 and index02 == 1 and index03 == 1 ) then
BeginEvent(sceneId)
local strText = "您已经领过奖励，请再接再厉，下次夺魁时再来找我吧。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)	
return 0
end
if LuaFnIsObjValid( sceneId, selfId ) ~= 1 then
return 0
end
if LuaFnIsCanDoScriptLogic( sceneId, selfId ) ~= 1 then
return 0
end
LuaFnAskNpcScriptMail(sceneId, selfId, MAIL_HUASHANJIANGLI)
local strLogCheck = format(	"HuaShanLunJian_AskNpcScriptMail    id=%X, Param01=%d, Param02=%d, Param03=%d", LuaFnGetGUID(sceneId, selfId), index01, index02, index03 )
LuaFnLogCheck(strLogCheck)
return 0
end
end
function x001230_OnEnumerate( sceneId, selfId, targetId )	
AddNumText( sceneId, x001230_g_ScriptId, x001230_g_msg["cj"], 6, x001230_g_Update["id01"] )        
local nWeek = GetTodayWeek()
local nQuarter = mod(GetQuarterTime(),100);    
if ((nWeek==0) and (nQuarter < 68 and nQuarter >= 64)) or 
( (nWeek==2 or nWeek==4) and (nQuarter < 84 and nQuarter >= 80))  then
AddNumText( sceneId, x001230_g_ScriptId, x001230_g_msg["Mail"], 6, x001230_g_Update["id03"] )
AddNumText( sceneId, x001230_g_ScriptId, x001230_g_msg["jl"], 6, x001230_g_Update["id02"] )        
end
end
function x001230_CheckAccept( sceneId, selfId )
end
function x001230_OnAccept( sceneId, selfId, targetId )
end
function x001230_AcceptEnterCopyScene( sceneId, selfId )
end
function x001230_OnHumanDie( sceneId, selfId, killerId )
end
function x001230_OnAbandon( sceneId, selfId )
end
function x001230_OnContinue( sceneId, selfId, targetId )
end	
function x001230_CheckSubmit( sceneId, selfId, selectRadioId )
end
function x001230_OnSubmit( sceneId, selfId, targetId, selectRadioId )
end
function x001230_OnKillObject( sceneId, selfId, objdataId, objId )
end
function x001230_OnEnterZone( sceneId, selfId, zoneId )
end
function x001230_OnItemChanged( sceneId, selfId, itemdataId )
end
function x001230_OnCopySceneTimer( sceneId, nowTime )
end
function x001230_OnHuashanJiangli( sceneId, selfId, targetId )
local name   	= GetName(sceneId, selfId)
local strText = ""
local menpai  = GetMenPai(sceneId, selfId)	
menpai = menpai+1
local temp		=	-1	
local idx			= {}
idx[1] = 0
idx[2] = 0
idx[3] = 0
local strLogCheck = ""
local	timeidx = GetMissionData( sceneId, selfId, MD_HUASHANJIANGLI_TIME )
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay
local	timenow = LuaFnGetCurrentTime()
if nData ~= 0 and nData ~= timeidx	then
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 0 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 0 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 0 )
end
local index01 =	GetMissionFlag( sceneId, selfId, MF_LunjianJiangli01 )
local index02 =	GetMissionFlag( sceneId, selfId, MF_LunjianJiangli02 )
local index03 =	GetMissionFlag( sceneId, selfId, MF_LunjianJiangli03 )
if ( index01 == 0 and index02 == 0 and index03 == 1 )
or ( index01 == 0 and index02 == 1 and index03 == 0 )
or ( index01 == 0 and index02 == 1 and index03 == 1 )
or ( index01 == 1 and index02 == 0 and index03 == 0 )
or ( index01 == 1 and index02 == 0 and index03 == 1 )
or ( index01 == 1 and index02 == 1 and index03 == 0 )
or ( index01 == 1 and index02 == 1 and index03 == 1 ) then
if index01 == 1 and index02 == 1 and index03 == 1 then		 			
BeginEvent(sceneId)
strText = "您已经领过奖励，请再接再厉，下次夺魁时再来找我吧。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)	
else			 		
if index01 == 0 and index02 == 0 and index03 == 1 then						 				
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nMenpaiShiZhuang[menpai].id, 1 )
ret1 = EndAddItem( sceneId, selfId )
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nCailiaoJiangli[1].id, 3 )
ret2 = EndAddItem( sceneId, selfId )
if ret1 > 0 and ret2 > 0 then
idx[1] = 0
idx[2] = 0
idx[3] = 0
local	itemInfo	=	{}
itemInfo[1]	=	""
itemInfo[2]	=	""
itemInfo[3]	=	""
local bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nMenpaiShiZhuang[menpai].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
local itemInfo01 = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nMenpaiShiZhuang[menpai].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
temp = random(3)																								
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
temp = random(3)																				
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )								
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
temp = random(3)																											
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )	
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)							
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 1 )
if idx[1] > 0 and idx[2] > 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1], idx[2], itemInfo[2], idx[3], itemInfo[3] )
elseif idx[1] > 0 and idx[2] > 0 and idx[3] == 0 then
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1], idx[2], itemInfo[2] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1], idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[2], itemInfo[2], idx[3], itemInfo[3] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1] )
elseif idx[1] == 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[2], itemInfo[2] )
end
BroadMsgByChatPipe(sceneId,selfId, strText, 7)				 																			
else
BeginEvent(sceneId)
strText = "物品栏或材料栏没有足够的空间，请整理后再来领取。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)
end			 				
elseif index01 == 0 and index02 == 1 and index03 == 0 then						 				
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nMenpaiShiZhuang[menpai].id, 1 )
ret1 = EndAddItem( sceneId, selfId )
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nCailiaoJiangli[1].id, 2 )
ret2 = EndAddItem( sceneId, selfId )
if ret1 > 0 and ret2 > 0 then
idx[1] = 0
idx[2] = 0
idx[3] = 0
local	itemInfo	=	{}
itemInfo[1]	=	""
itemInfo[2]	=	""
itemInfo[3]	=	""
local bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nMenpaiShiZhuang[menpai].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
local itemInfo01 = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nMenpaiShiZhuang[menpai].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
temp = random(3)												
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
temp = random(3)												
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 1 )
if idx[1] > 0 and idx[2] > 0 and idx[3] == 0 then
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1], idx[2], itemInfo[2] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1], idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[2], itemInfo[2], idx[3], itemInfo[3] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1] )
elseif idx[1] == 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[2], itemInfo[2] )
end
BroadMsgByChatPipe(sceneId,selfId, strText, 7)				 											
else
BeginEvent(sceneId)
strText = "物品栏或材料栏没有足够的空间，请整理后再来领取。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)
end							 						 						 				 				
elseif index01 == 0 and index02 == 1 and index03 == 1 then						 				
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nMenpaiShiZhuang[menpai].id, 1 )
ret1 = EndAddItem( sceneId, selfId )
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nCailiaoJiangli[1].id, 1 )
ret2 = EndAddItem( sceneId, selfId )
if ret1 > 0 and ret2 > 0 then
idx[1] = 0
idx[2] = 0
idx[3] = 0
local	itemInfo	=	{}
itemInfo[1]	=	""
itemInfo[2]	=	""
itemInfo[3]	=	""
local bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nMenpaiShiZhuang[menpai].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
local itemInfo01 = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nMenpaiShiZhuang[menpai].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
temp = random(3)												
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 1 )
if idx[1] > 0 and idx[2] == 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[1], itemInfo[1] )
elseif idx[1] == 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL01}#{_INFOMSG%s}#{HSJL02}%d个#{_INFOMSG%s}#{HSJL03}", name, itemInfo01, idx[2], itemInfo[2] )
end
BroadMsgByChatPipe(sceneId,selfId, strText, 7)				 											
else
BeginEvent(sceneId)
strText = "物品栏或材料栏没有足够的空间，请整理后再来领取。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)
end								 								 			 				
elseif index01 == 1 and index02 == 0 and index03 == 0 then						 				
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nCailiaoJiangli[1].id, 3 )
ret = EndAddItem( sceneId, selfId )
if ret > 0 then
idx[1] = 0
idx[2] = 0
idx[3] = 0
local	itemInfo	=	{}
itemInfo[1]	=	""
itemInfo[2]	=	""
itemInfo[3]	=	""
temp = random(3)												
local bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
temp = random(3)												
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )								
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
temp = random(3)												
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )	
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)							
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 1 )
if idx[1] > 0 and idx[2] > 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1], idx[2], itemInfo[2], idx[3], itemInfo[3] )
elseif idx[1] > 0 and idx[2] > 0 and idx[3] == 0 then
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1], idx[2], itemInfo[2] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1], idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[2], itemInfo[2], idx[3], itemInfo[3] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1] )
elseif idx[1] == 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[2], itemInfo[2] )
end
BroadMsgByChatPipe(sceneId,selfId, strText, 7)				 											
else
BeginEvent(sceneId)
strText = "物品栏或材料栏没有足够的空间，请整理后再来领取。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)
end							 											 				
elseif index01 == 1 and index02 == 0 and index03 == 1 then						 				
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nCailiaoJiangli[1].id, 2 )
ret = EndAddItem( sceneId, selfId )
if ret > 0 then
idx[1] = 0
idx[2] = 0
idx[3] = 0
local	itemInfo	=	{}
itemInfo[1]	=	""
itemInfo[2]	=	""
itemInfo[3]	=	""
temp = random(3)												
local bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
temp = random(3)												
bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 1 )
if idx[1] > 0 and idx[2] > 0 and idx[3] == 0 then
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1], idx[2], itemInfo[2] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1], idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}，%d个#{_INFOMSG%s}#{HSJL05}", name, idx[2], itemInfo[2], idx[3], itemInfo[3] )
elseif idx[1] > 0 and idx[2] == 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1] )
elseif idx[1] == 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[2], itemInfo[2] )
end
BroadMsgByChatPipe(sceneId,selfId, strText, 7)				 											
else
BeginEvent(sceneId)
strText = "物品栏或材料栏没有足够的空间，请整理后再来领取。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)
end							 									 				 				
elseif index01 == 1 and index02 == 1 and index03 == 0 then
BeginAddItem( sceneId )
AddItem( sceneId, x001230_g_nCailiaoJiangli[1].id, 1 )
ret = EndAddItem( sceneId, selfId )
if ret > 0 then
idx[1] = 0
idx[2] = 0
idx[3] = 0
local	itemInfo	=	{}
itemInfo[1]	=	""
itemInfo[2]	=	""
itemInfo[3]	=	""
temp = random(3)												
local bagpos = TryRecieveItem( sceneId, selfId, x001230_g_nCailiaoJiangli[temp].id, QUALITY_MUST_BE_CHANGE )	-- 放不下就没有了
itemInfo[temp] = GetBagItemTransfer( sceneId, selfId, bagpos )
strLogCheck = format("HuaShanLunJian_GetPrize	userId:%X, itemId:%d, count:%d", LuaFnGetGUID(sceneId, selfId), x001230_g_nCailiaoJiangli[temp].id, 1)
LuaFnLogCheck(strLogCheck)
local	bindidx	=	LuaFnItemBind( sceneId, selfId, bagpos )
if bindidx ~= 1 then
local bindmsg = "绑定失败"													
BeginEvent( sceneId )
AddText( sceneId, bindmsg )
EndEvent( sceneId )
DispatchMissionTips( sceneId, selfId )
end
idx[temp] = idx[temp]+1
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 1 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 1 )
if idx[1] > 0 and idx[2] == 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[1], itemInfo[1] )
elseif idx[1] == 0 and idx[2] == 0 and idx[3] > 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[3], itemInfo[3] )
elseif idx[1] == 0 and idx[2] > 0 and idx[3] == 0 then																
strText = format("#{_INFOUSR%s}#P#{HSJL04}%d个#{_INFOMSG%s}#{HSJL05}", name, idx[2], itemInfo[2] )
end
BroadMsgByChatPipe(sceneId,selfId, strText, 7)				 											
else
BeginEvent(sceneId)
strText = "物品栏或材料栏没有足够的空间，请整理后再来领取。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)
end							 							 				
end				 		
end				 
else
BeginEvent(sceneId)
strText = "对不起，这次您没有获得本门派前三名的成绩，还望下次多加努力。"
AddText(sceneId,strText);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)						
end		
end
function x001230_OnHuashanSceneTimer( sceneId, selfId )
local nNowTimeEX = LuaFnGetCurrentTime()
if x001230_g_bEndTime ~= 0 and nNowTimeEX > x001230_g_bEndTime+60    then
BroadMsgByChatPipe(sceneId,0,"@*;SrvMsg;SCA:" .. "#P在本届华山论剑当中，#Y" .. x001230_g_bMenpai .. "#P经过上下一心的努力，终于获得#Y华山论剑第一#P的荣誉，作为奖励，其门下所有弟子在下届华山论剑活动结束前，每天的第一轮师门任务将会变为#Y3倍经验。",4)
local mingci = 1
local str = ""
local MenpaiTbl = {	"少林",
"明教",
"丐帮",
"武当",
"峨嵋",
"星宿",
"天龙",
"天山",
"逍遥"	}
for i=1, x001230_g_PlayerNum  do				
if mingci == 1  then
str = "第一名：" .. x001230_g_PlayerName[i] .. "#Y[" .. MenpaiTbl[x001230_g_PlayerMenpai[i]+1] .. "]"
mingci = 2					
elseif mingci == 2  then
str = "第二名：" .. x001230_g_PlayerName[i]	.. "#Y[" .. MenpaiTbl[x001230_g_PlayerMenpai[i]+1] .. "]"					
mingci = 3											
elseif mingci == 3  then
str = "第三名：" .. x001230_g_PlayerName[i] .. "#Y[" .. MenpaiTbl[x001230_g_PlayerMenpai[i]+1] .. "]"
mingci = 4
elseif mingci == 4  then
str = "第四名：" .. x001230_g_PlayerName[i] .. "#Y[" .. MenpaiTbl[x001230_g_PlayerMenpai[i]+1] .. "]"
mingci = 5					
elseif mingci == 5  then
str = "第五名：" .. x001230_g_PlayerName[i] .. "#Y[" .. MenpaiTbl[x001230_g_PlayerMenpai[i]+1] .. "]"
mingci = 6							
elseif mingci == 6  then
break
end
AddGlobalCountNews ( sceneId, str )
end
x001230_g_PlayerNum = 0
x001230_g_bEndTime = 0
end
local nHumanNum = LuaFnGetCopyScene_HumanCount(sceneId)
if nHumanNum == 0  then
return
end
local bIsTime = 1
local nWeek = GetTodayWeek()
if (nWeek==0 or nWeek==4 or nWeek==2) ~= 1  then
bIsTime = 0
end
local nQuarter = mod(GetQuarterTime(),100);
if ((nWeek==0) and (nQuarter < 60 or nQuarter >= 64)) or 
( (nWeek==2 or nWeek==4) and (nQuarter < 76 or nQuarter >= 80))  then
bIsTime = 0
end
if bIsTime == 1   then
if x001230_g_bHuashaning == 0   then
x001230_g_bHuashaning = 1
for i=1 ,400  do
x001230_g_PlayerKc[i] = 0
x001230_g_PlayerName[i] = ""
x001230_g_PlayerMenpai[i] = -1
x001230_g_PlayerId[i] = 0
end
x001230_g_PlayerNum = 0
for i=1, 9  do
x001230_g_nMenpaiQiansan[i].id = (i-1)
x001230_g_nMenpaiQiansan[i].player01=""
x001230_g_nMenpaiQiansan[i].player02=""
x001230_g_nMenpaiQiansan[i].player03=""				
x001230_g_nMenpaiQiansan[i].playerid01=0
x001230_g_nMenpaiQiansan[i].playerid02=0
x001230_g_nMenpaiQiansan[i].playerid03=0				
end			
if LuaFnIsObjValid(sceneId, selfId) == 1 and LuaFnIsCanDoScriptLogic(sceneId,selfId) == 1 then
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli01, 0 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli02, 0 )
SetMissionFlag( sceneId, selfId, MF_LunjianJiangli03, 0 )
end
end
if x001230_g_bHuashaning == 1   then
local nNowTime = LuaFnGetCurrentTime()
if x001230_g_PreTime == 0    then
x001230_g_PreTime = nNowTime
return
end
if nNowTime > x001230_g_PreTime+300    then
x001230_g_PreTime = nNowTime
x001230_GiveMJ( sceneId )
for i=1, 9    do
for j=1, i   do
if x001230_g_nMenpaikills[i].kill > x001230_g_nMenpaikills[j].kill   then
local nTempMenpai = x001230_g_nMenpaikills[j].id
local nKills = x001230_g_nMenpaikills[j].kill
x001230_g_nMenpaikills[j].id = x001230_g_nMenpaikills[i].id
x001230_g_nMenpaikills[j].kill = x001230_g_nMenpaikills[i].kill
x001230_g_nMenpaikills[i].id = nTempMenpai
x001230_g_nMenpaikills[i].kill = nKills
end
end
end
local nMingci = 1
local szStr = "#{HSJL_090113_01}" --"华山之颠，天下门派各呈雄风，目前从实力上排名在第一第二与第三名的门派：分别为" zchw
szStr = szStr .. x001230_Id2Menpai(x001230_g_nMenpaikills[1].id) .. x001230_g_nMenpaikills[1].kill .. "#{HSJL_090113_02}"
szStr = szStr .. x001230_Id2Menpai(x001230_g_nMenpaikills[2].id) .. x001230_g_nMenpaikills[2].kill .. "#{HSJL_090113_02}"
szStr = szStr .. x001230_Id2Menpai(x001230_g_nMenpaikills[3].id) .. x001230_g_nMenpaikills[3].kill .. "#{HSJL_090113_03}"
AddGlobalCountNews(sceneId, szStr)
end
end
end
if bIsTime == 0   then
if x001230_g_bHuashaning == 1   then
x001230_g_bHuashaning = 0
x001230_g_bEndTime = LuaFnGetCurrentTime()
for i=1, 9    do
for j=1, i   do
if x001230_g_nMenpaikills[i].kill > x001230_g_nMenpaikills[j].kill   then
local nTempMenpai = x001230_g_nMenpaikills[j].id
local nKills = x001230_g_nMenpaikills[j].kill
x001230_g_nMenpaikills[j].id = x001230_g_nMenpaikills[i].id
x001230_g_nMenpaikills[j].kill = x001230_g_nMenpaikills[i].kill
x001230_g_nMenpaikills[i].id = nTempMenpai
x001230_g_nMenpaikills[i].kill = nKills
end
end
end
local nMax = 0
for i=1, 9   do
if x001230_g_nMenpaikills[i].kill == x001230_g_nMenpaikills[1].kill   then
nMax = nMax+1
end
end
local nVMenpai = random(nMax)
if x001230_g_nMenpaikills[nVMenpai].kill < 1  then
return
end
LuaFnSetWorldGlobalData(x001230_g_WorldGlobal, x001230_g_nMenpaikills[nVMenpai].id + 10)
local szMenpai = ""
if x001230_g_nMenpaikills[nVMenpai].id == 0  then
szMenpai = "少林派"
elseif x001230_g_nMenpaikills[nVMenpai].id == 1  then
szMenpai = "明教"
elseif x001230_g_nMenpaikills[nVMenpai].id == 2  then
szMenpai = "丐帮"
elseif x001230_g_nMenpaikills[nVMenpai].id == 3  then
szMenpai = "武当派"
elseif x001230_g_nMenpaikills[nVMenpai].id == 4  then
szMenpai = "峨嵋派"
elseif x001230_g_nMenpaikills[nVMenpai].id == 5  then
szMenpai = "星宿派"
elseif x001230_g_nMenpaikills[nVMenpai].id == 6  then
szMenpai = "天龙派"
elseif x001230_g_nMenpaikills[nVMenpai].id == 7  then
szMenpai = "天山派"
elseif x001230_g_nMenpaikills[nVMenpai].id == 8  then
szMenpai = "逍遥派"
end
x001230_g_bMenpai = szMenpai
for i=1, 9   do
local strLog = "[huashan end]: menpai=" .. tostring(x001230_g_nMenpaikills[i].id) .. "   KillNum=" .. tostring(x001230_g_nMenpaikills[i].kill)
MissionLog(sceneId,strLog)
end
for i=1, 9  do
x001230_g_nMenpaikills[i].id = i-1
x001230_g_nMenpaikills[i].kill = 0
end
for i=1, x001230_g_PlayerNum   do
for j=1, i   do
if x001230_g_PlayerKc[i] > x001230_g_PlayerKc[j]  then
local Killcount = x001230_g_PlayerKc[i]
local KillName  = x001230_g_PlayerName[i]
local KillMenpai  = x001230_g_PlayerMenpai[i]
local UserId  = x001230_g_PlayerId[i]
x001230_g_PlayerKc[i] = x001230_g_PlayerKc[j]
x001230_g_PlayerName[i] = x001230_g_PlayerName[j]
x001230_g_PlayerMenpai[i] = x001230_g_PlayerMenpai[j]
x001230_g_PlayerId[i] = x001230_g_PlayerId[j]
x001230_g_PlayerKc[j] = Killcount
x001230_g_PlayerName[j] = KillName
x001230_g_PlayerMenpai[j] = KillMenpai
x001230_g_PlayerId[j] = UserId
end
end
end
local num = {}
for i=0 ,8  do
num[i] = 0
end
for i=1, x001230_g_PlayerNum   do
for j=0, 8   do
if x001230_g_PlayerMenpai[i] == j then
if num[j] == 0 then
x001230_g_nMenpaiQiansan[j+1].player01 = x001230_g_PlayerName[i]
x001230_g_nMenpaiQiansan[j+1].playerid01 = x001230_g_PlayerId[i]
num[j] = 1
elseif num[j] == 1 then
x001230_g_nMenpaiQiansan[j+1].player02 = x001230_g_PlayerName[i]
x001230_g_nMenpaiQiansan[j+1].playerid02 = x001230_g_PlayerId[i]
num[j] = 2
elseif num[j] == 2 then
x001230_g_nMenpaiQiansan[j+1].player03 = x001230_g_PlayerName[i]
x001230_g_nMenpaiQiansan[j+1].playerid03 = x001230_g_PlayerId[i]
num[j] = 3
end																							
end					
end
end
local strLogCheck = format(	"HuaShanLunJian_Rank_All    no.1=(id=%X, name=%s), no.2=(id=%X, name=%s), no.3=(id=%X, name=%s), ",
LuaFnGetGUID(sceneId, x001230_g_PlayerId[1]),x001230_g_PlayerName[1],
LuaFnGetGUID(sceneId, x001230_g_PlayerId[2]),x001230_g_PlayerName[2],
LuaFnGetGUID(sceneId, x001230_g_PlayerId[3]),x001230_g_PlayerName[3]
)
LuaFnLogCheck(strLogCheck)
for i=1, 9  do					
strLogCheck = format(	"HuaShanLunJian_Rank_MenPai(%s)    no.1=(id=%X, name=%s), no.2=(id=%X, name=%s), no.3=(id=%X, name=%s), ",
x001230_Id2Menpai(x001230_g_nMenpaiQiansan[i].id),
LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid01),x001230_g_nMenpaiQiansan[i].player01,
LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid02),x001230_g_nMenpaiQiansan[i].player02,
LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid03),x001230_g_nMenpaiQiansan[i].player03
)
LuaFnLogCheck(strLogCheck)	
AuditHuashanThreeWinners(sceneId,x001230_g_nMenpaiQiansan[i].playerid01)
AuditHuashanThreeWinners(sceneId,x001230_g_nMenpaiQiansan[i].playerid02)
AuditHuashanThreeWinners(sceneId,x001230_g_nMenpaiQiansan[i].playerid03)
end		
local mingci = 1
local KillCounts = 0
local str = ""
local mailStr = ""
for i=1, x001230_g_PlayerNum  do
if mingci == 1 and x001230_g_PlayerName[i] ~= "" then
mailStr = "恭喜您获得本届华山论剑总积分第一名!您可以找华山论剑主持人苏剑岭（苏州193，138）领取丰厚奖励!注意：领取时间1个小时，若超过1个小时仍未领取奖励就只能下次再加油咯!领取奖励之前请先点击确认奖励选项，收取领奖邮件后，点击领取华山论剑奖励方可领奖成功。"
local StartTime = LuaFnGetCurrentTime()
x001230_g_bMenpai = szMenpai
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay						
LuaFnSendScriptMail( sceneId, x001230_g_PlayerName[i], MAIL_HUASHANJIANGLI, nData, 1, 1)
strLogCheck = format(	"HuaShanLunJian_ScriptMail    FULL_NO.1=(id=%X, name=%s, Param01=%d, Param02=%d, Param03=%d)", LuaFnGetGUID(sceneId, x001230_g_PlayerId[i]), x001230_g_PlayerName[i], nData, 1, 1 )
LuaFnLogCheck(strLogCheck)
LuaFnSendSystemMail( sceneId, x001230_g_PlayerName[i], mailStr )
strLogCheck = format(	"HuaShanLunJian_SystemMail    FULL_NO.1=(id=%X, name=%s)", LuaFnGetGUID(sceneId, x001230_g_PlayerId[i]), x001230_g_PlayerName[i] )
LuaFnLogCheck(strLogCheck)
mingci = 2
if x001230_g_PlayerKc[i] ~= x001230_g_PlayerKc[i+1]  then
mingci = 2
end
elseif mingci == 2 and x001230_g_PlayerName[i] ~= "" then
mailStr = "恭喜您获得本届华山论剑总积分第二名!您可以找华山论剑主持人苏剑岭（苏州193，138）领取丰厚奖励!注意：领取时间1个小时，若超过1个小时仍未领取奖励就只能下次再加油咯!领取奖励之前请先点击确认奖励选项，收取领奖邮件后，点击领取华山论剑奖励方可领奖成功。"
local StartTime = LuaFnGetCurrentTime()
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay						
LuaFnSendScriptMail( sceneId, x001230_g_PlayerName[i], MAIL_HUASHANJIANGLI, nData, 1, 2)
strLogCheck = format(	"HuaShanLunJian_ScriptMail    FULL_NO.2=(id=%X, name=%s, Param01=%d, Param02=%d, Param03=%d)", LuaFnGetGUID(sceneId, x001230_g_PlayerId[i]), x001230_g_PlayerName[i], nData, 1, 2 )
LuaFnLogCheck(strLogCheck)
LuaFnSendSystemMail( sceneId, x001230_g_PlayerName[i], mailStr )
strLogCheck = format(	"HuaShanLunJian_SystemMail    FULL_NO.2=(id=%X, name=%s)", LuaFnGetGUID(sceneId, x001230_g_PlayerId[i]), x001230_g_PlayerName[i] )
LuaFnLogCheck(strLogCheck)
mingci = 3
if x001230_g_PlayerKc[i] ~= x001230_g_PlayerKc[i+1]  then
mingci = 3
end
elseif mingci == 3 and x001230_g_PlayerName[i] ~= "" then
mailStr = "恭喜您获得本届华山论剑总积分第三名!您可以找华山论剑主持人苏剑岭（苏州193，138）领取丰厚奖励!注意：领取时间1个小时，若超过1个小时仍未领取奖励就只能下次再加油咯!领取奖励之前请先点击确认奖励选项，收取领奖邮件后，点击领取华山论剑奖励方可领奖成功。"
local StartTime = LuaFnGetCurrentTime()
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay						
LuaFnSendScriptMail( sceneId, x001230_g_PlayerName[i], MAIL_HUASHANJIANGLI, nData, 1, 3)
strLogCheck = format(	"HuaShanLunJian_ScriptMail    FULL_NO.3=(id=%X, name=%s, Param01=%d, Param02=%d, Param03=%d)", LuaFnGetGUID(sceneId, x001230_g_PlayerId[i]), x001230_g_PlayerName[i], nData, 1, 3 )
LuaFnLogCheck(strLogCheck)
LuaFnSendSystemMail( sceneId, x001230_g_PlayerName[i], mailStr )
strLogCheck = format(	"HuaShanLunJian_SystemMail    FULL_NO.3=(id=%X, name=%s)", LuaFnGetGUID(sceneId, x001230_g_PlayerId[i]), x001230_g_PlayerName[i] )
LuaFnLogCheck(strLogCheck)
mingci = 4
if x001230_g_PlayerKc[i] ~= x001230_g_PlayerKc[i+1]  then
mingci = 4
end
elseif mingci == 4  then
mingci = 5
if x001230_g_PlayerKc[i] ~= x001230_g_PlayerKc[i+1]  then
mingci = 5
end
elseif mingci == 5  then
mingci = 6
if x001230_g_PlayerKc[i] ~= x001230_g_PlayerKc[i+1]  then
mingci = 6
break
end
end
end
for i=1, 9  do
str = "#P本次华山论剑已经结束，各位同门为振兴门派前仆后继，在战斗中表现神勇，他们中积分最高的是：#W"
if x001230_g_nMenpaiQiansan[i].playerid01 ~= 0 and x001230_g_nMenpaiQiansan[i].player01 ~= "" then
BroadMsgByChatPipe(sceneId,x001230_g_nMenpaiQiansan[i].playerid01, str, 7)
str = "第一名：" .. x001230_g_nMenpaiQiansan[i].player01
BroadMsgByChatPipe(sceneId,x001230_g_nMenpaiQiansan[i].playerid01, str, 7)	
end
if x001230_g_nMenpaiQiansan[i].playerid02 ~= 0 and x001230_g_nMenpaiQiansan[i].player02 ~= "" then
str = "第二名：" .. x001230_g_nMenpaiQiansan[i].player02
BroadMsgByChatPipe(sceneId,x001230_g_nMenpaiQiansan[i].playerid02, str, 7)			
end
if x001230_g_nMenpaiQiansan[i].playerid03 ~= 0 and x001230_g_nMenpaiQiansan[i].player03 ~= "" then
str = "第三名：" .. x001230_g_nMenpaiQiansan[i].player03
BroadMsgByChatPipe(sceneId,x001230_g_nMenpaiQiansan[i].playerid03, str, 7)							
end
if x001230_g_nMenpaiQiansan[i].player01 ~= ""
and x001230_g_nMenpaiQiansan[i].player01 ~= x001230_g_PlayerName[1] 
and x001230_g_nMenpaiQiansan[i].player01 ~= x001230_g_PlayerName[2] 
and x001230_g_nMenpaiQiansan[i].player01 ~= x001230_g_PlayerName[3] then
mailStr = "恭喜您获得本届华山论剑本门派第一名!您可以找华山论剑主持人苏剑岭（苏州193，138）领取丰厚奖励!注意：领取时间1个小时，若超过1个小时仍未领取奖励就只能下次再加油咯!领取奖励之前请先点击确认奖励选项，收取领奖邮件后，点击领取华山论剑奖励方可领奖成功。"
local StartTime = LuaFnGetCurrentTime()
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay						
LuaFnSendScriptMail( sceneId, x001230_g_nMenpaiQiansan[i].player01, MAIL_HUASHANJIANGLI, nData, 2, 1)
strLogCheck = format(	"HuaShanLunJian_ScriptMail    MenPai_NO.1=(id=%X, name=%s, Param01=%d, Param02=%d, Param03=%d)", LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid01), x001230_g_nMenpaiQiansan[i].player01, nData, 2, 1 )
LuaFnLogCheck(strLogCheck)
LuaFnSendSystemMail( sceneId, x001230_g_nMenpaiQiansan[i].player01, mailStr )
strLogCheck = format(	"HuaShanLunJian_SystemMail    MenPai_NO.1=(id=%X, name=%s)", LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid01), x001230_g_nMenpaiQiansan[i].player01 )
LuaFnLogCheck(strLogCheck)
end
if x001230_g_nMenpaiQiansan[i].player02 ~= ""
and x001230_g_nMenpaiQiansan[i].player02 ~= x001230_g_PlayerName[1] 
and x001230_g_nMenpaiQiansan[i].player02 ~= x001230_g_PlayerName[2] 
and x001230_g_nMenpaiQiansan[i].player02 ~= x001230_g_PlayerName[3] then						
mailStr = "恭喜您获得本届华山论剑本门派第二名!您可以找华山论剑主持人苏剑岭（苏州193，138）领取丰厚奖励!注意：领取时间1个小时，若超过1个小时仍未领取奖励就只能下次再加油咯!领取奖励之前请先点击确认奖励选项，收取领奖邮件后，点击领取华山论剑奖励方可领奖成功。"
local StartTime = LuaFnGetCurrentTime()
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay						
LuaFnSendScriptMail( sceneId, x001230_g_nMenpaiQiansan[i].player02, MAIL_HUASHANJIANGLI, nData, 2, 2)
strLogCheck = format(	"HuaShanLunJian_ScriptMail    MenPai_NO.2=(id=%X, name=%s, Param01=%d, Param02=%d, Param03=%d)", LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid02), x001230_g_nMenpaiQiansan[i].player02, nData, 2, 2 )
LuaFnLogCheck(strLogCheck)
LuaFnSendSystemMail( sceneId, x001230_g_nMenpaiQiansan[i].player02, mailStr )
strLogCheck = format(	"HuaShanLunJian_SystemMail    MenPai_NO.2=(id=%X, name=%s)", LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid02), x001230_g_nMenpaiQiansan[i].player02 )
LuaFnLogCheck(strLogCheck)
end				
if x001230_g_nMenpaiQiansan[i].player03 ~= ""
and	x001230_g_nMenpaiQiansan[i].player03 ~= x001230_g_PlayerName[1] 
and x001230_g_nMenpaiQiansan[i].player03 ~= x001230_g_PlayerName[2] 
and x001230_g_nMenpaiQiansan[i].player03 ~= x001230_g_PlayerName[3] then						
mailStr = "恭喜您获得本届华山论剑本门派第三名!您可以找华山论剑主持人苏剑岭（苏州193，138）领取丰厚奖励!注意：领取时间1个小时，若超过1个小时仍未领取奖励就只能下次再加油咯!领取奖励之前请先点击确认奖励选项，收取领奖邮件后，点击领取华山论剑奖励方可领奖成功。"
local StartTime = LuaFnGetCurrentTime()
local nMonth = LuaFnGetThisMonth()
local nDay   = LuaFnGetDayOfThisMonth()
local nData  = (nMonth+1)*100+nDay						
LuaFnSendScriptMail( sceneId, x001230_g_nMenpaiQiansan[i].player03, MAIL_HUASHANJIANGLI, nData, 2, 3)
strLogCheck = format(	"HuaShanLunJian_ScriptMail    MenPai_NO.3=(id=%X, name=%s, Param01=%d, Param02=%d, Param03=%d)", LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid03), x001230_g_nMenpaiQiansan[i].player03, nData, 2, 3 )
LuaFnLogCheck(strLogCheck)
LuaFnSendSystemMail( sceneId, x001230_g_nMenpaiQiansan[i].player03, mailStr )
strLogCheck = format(	"HuaShanLunJian_SystemMail    MenPai_NO.3=(id=%X, name=%s)", LuaFnGetGUID(sceneId, x001230_g_nMenpaiQiansan[i].playerid03), x001230_g_nMenpaiQiansan[i].player03 )
LuaFnLogCheck(strLogCheck)
end									
end						
for i=1, x001230_g_PlayerNum   do
x001230_g_PlayerKc[i] = 0										
end				
end
local i
for i=0, nHumanNum-1  do
local nHumanId = LuaFnGetCopyScene_HumanObjId(sceneId,i)
if LuaFnIsObjValid( sceneId, nHumanId ) == 1 and LuaFnIsCanDoScriptLogic( sceneId, nHumanId ) == 1 then
BeginEvent(sceneId)
AddText(sceneId, "#P华山论剑活动结束。")
EndEvent()
DispatchMissionTips(sceneId, nHumanId)
local nMenpaiScene
local nPos_X
local nPos_Z
local nMempai = LuaFnGetMenPai(sceneId, nHumanId)
if 		 nMempai == 0    then
nMenpaiScene = 9
nPos_X			 = 62
nPos_Z			 = 63
elseif nMempai == 1    then
nMenpaiScene = 11
nPos_X			 = 82
nPos_Z			 = 57
elseif nMempai == 2    then
nMenpaiScene = 10
nPos_X			 = 42
nPos_Z			 = 145
elseif nMempai == 3    then
nMenpaiScene = 12
nPos_X			 = 99
nPos_Z			 = 69
elseif nMempai == 4    then
nMenpaiScene = 15
nPos_X			 = 97
nPos_Z			 = 74
elseif nMempai == 5    then
nMenpaiScene = 16
nPos_X			 = 126
nPos_Z			 = 77
elseif nMempai == 6    then
nMenpaiScene = 13
nPos_X			 = 37
nPos_Z			 = 86
elseif nMempai == 7    then
nMenpaiScene = 17
nPos_X			 = 100
nPos_Z			 = 46
elseif nMempai == 8    then
nMenpaiScene = 14
nPos_X			 = 61
nPos_Z			 = 69
elseif nMempai == 9    then
nMenpaiScene = 1
nPos_X			 = 191
nPos_Z			 = 138
end
CallScriptFunction((400900), "TransferFunc",sceneId, nHumanId, nMenpaiScene, nPos_X, nPos_Z)
end
end --END for i=0, nHumanNum-1  do
end --END if bIsTime == 0
end
function x001230_KillPlayer(sceneId, killerId, diedId)
if x001230_g_bHuashaning == 0  then
return
end
local IsAddCnt = 1	
local killerLvl = GetLevel(sceneId, killerId)
local diedLvl = GetLevel(sceneId, diedId)
local lastplayer = GetMissionData( sceneId, killerId, MD_LASTPLAYER_ID )
if killerLvl - diedLvl >= 40 or lastplayer == diedId then
IsAddCnt = 0		
end
SetMissionData( sceneId, killerId, MD_LASTPLAYER_ID, diedId )
if IsAddCnt == 0 then
BeginEvent(sceneId)
AddText(sceneId, "由于您重复杀死同一个玩家或该玩家与您等级相差超过40级，您将不会获得门派贡献度和积分奖励。")
EndEvent(sceneId)
DispatchMissionTips(sceneId, killerId)
return 0
end
local nMenpaiPoint = GetHumanMenpaiPoint(sceneId, killerId)
SetHumanMenpaiPoint(sceneId, killerId, nMenpaiPoint+1)		--门派贡献度+1
local nKillerMenpai = GetMenPai(sceneId, killerId)
local nKillCount = 0
for i=1, 9  do
if x001230_g_nMenpaikills[i].id == nKillerMenpai   then
x001230_g_nMenpaikills[i].kill = x001230_g_nMenpaikills[i].kill + 1
nKillCount = x001230_g_nMenpaikills[i].kill
end
end
local nHumanNum = LuaFnGetCopyScene_HumanCount(sceneId)
for i=0, nHumanNum-1  do
local PlayerId = LuaFnGetCopyScene_HumanObjId(sceneId, i)
if LuaFnIsObjValid( sceneId, PlayerId ) == 1 and LuaFnIsCanDoScriptLogic( sceneId, PlayerId ) == 1 then
if nKillerMenpai == GetMenPai(sceneId, PlayerId)    then
BeginEvent(sceneId)
AddText(sceneId, "本门派当前得分：" .. nKillCount)
EndEvent(sceneId)
DispatchMissionTips(sceneId, PlayerId)
end
end
end
local strLog = "[huashan]: menpai=" .. tostring(nKillerMenpai) .. "   KillNum=" .. tostring(nKillCount)
MissionLog(sceneId,strLog)
local KillerName = GetName(sceneId, killerId)
local nIndex = 0
for i=0, x001230_g_PlayerNum  do
if KillerName == x001230_g_PlayerName[i]  then
x001230_g_PlayerKc[i] = x001230_g_PlayerKc[i]+1
BeginEvent(sceneId)
AddText(sceneId, "#{HSLJJF_1}" .. x001230_g_PlayerKc[i].."#{HSLJJF_2}")
EndEvent(sceneId)
DispatchMissionTips(sceneId, killerId)
return
end
end
x001230_AddPlayer(sceneId, KillerName, killerId)
end
function x001230_AddPlayer(sceneId, Name, PlayerId)
for i=1, x001230_g_PlayerNum  do
if Name == x001230_g_PlayerName[i]  then
return
end
end
x001230_g_PlayerNum = x001230_g_PlayerNum + 1;
x001230_g_PlayerKc[x001230_g_PlayerNum] = 1
BeginEvent(sceneId)
AddText(sceneId, "#{HSLJJF_1}1#{HSLJJF_2}")
EndEvent(sceneId)
DispatchMissionTips(sceneId, PlayerId)
x001230_g_PlayerName[x001230_g_PlayerNum] = Name
x001230_g_PlayerId[x001230_g_PlayerNum] = PlayerId
x001230_g_PlayerMenpai[x001230_g_PlayerNum] = GetMenPai(sceneId, PlayerId)
end
function x001230_Id2Menpai(nMenpaiId)
local szMenpai = ""
if nMenpaiId == 0  then
szMenpai = "少林派"
elseif nMenpaiId == 1  then
szMenpai = "明教"
elseif nMenpaiId == 2  then
szMenpai = "丐帮"
elseif nMenpaiId == 3  then
szMenpai = "武当派"
elseif nMenpaiId == 4  then
szMenpai = "峨嵋派"
elseif nMenpaiId == 5  then
szMenpai = "星宿派"
elseif nMenpaiId == 6  then
szMenpai = "天龙派"
elseif nMenpaiId == 7  then
szMenpai = "天山派"
elseif nMenpaiId == 8  then
szMenpai = "逍遥派"
end
return szMenpai
end
function x001230_MyMsgBox( sceneId, selfId, str )
BeginEvent(sceneId)    
AddText(sceneId,str);
EndEvent(sceneId)
DispatchMissionTips(sceneId,selfId)	
end
function x001230_GiveMJ( sceneId )
local nCount = GetMonsterCount(sceneId)
for i=0, nCount-1 do
local nMonsterId = GetMonsterObjID(sceneId, i)
local szName = GetName(sceneId, nMonsterId)
for j=1, getn(x001230_g_MJNameTbl)  do
if szName == x001230_g_MJNameTbl[j]  then
LuaFnDeleteMonster(sceneId, nMonsterId)
end
end
end
for i=1, getn(x001230_g_MJPosA)  do
local Rand = random(getn(x001230_g_MJTblA))
LuaFnCreateMonster(sceneId, x001230_g_MJTblA[Rand],
x001230_g_MJPosA[i].x, x001230_g_MJPosA[i].y,
3, 0, x001230_g_MJScript )
end
for i=1, getn(x001230_g_MJPosB) do
x001230_g_MJPosB[i].rand = random(100)
end
for i=1, 4 do
local MaxVal = -1
local index = 1
for j=1, getn(x001230_g_MJPosB) do
if x001230_g_MJPosB[j].rand > MaxVal then
MaxVal = x001230_g_MJPosB[j].rand
x001230_g_MJPosB[j].rand = -1
index = j
end
end
local Rand = random(getn(x001230_g_MJTblB))
LuaFnCreateMonster(sceneId, x001230_g_MJTblB[Rand],
x001230_g_MJPosB[index].x, x001230_g_MJPosB[index].y,
3, 0, x001230_g_MJScript )
end
end
