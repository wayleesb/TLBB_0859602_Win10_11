--=======================================================
--	香港、台湾H1N1活动, zhangqiang
--=======================================================

--脚本号
x889061_g_scriptId = 889061

--活动NPC
x889061_g_NpcName = "孙八爷"

--重楼玉兑换NPC
x889061_g_RewardNpcName = "梁师成"

--活动等级限制
x889061_g_LevelLimit = 30

--活动每天最多参加次数
x889061_g_MaxDayCount = 4

--重楼玉ID
x889061_g_RewardId = 10423024

--赤子爱心，秘制良药
x889061_g_DonateItemList = { 30504111, 30504112 }

--五行令牌
x889061_g_LingpaiList = { 20600010, 20600011, 20600012, 20600013, 20600014 }

--活动奖励类型，概率基数为1000000
x889061_g_RewardTypeList =	{	{ Min = 1, Max = 50000, Type = 20600011 },		--五行令牌(木)
					{ Min = 50001, Max = 52500, Type = 20600012 },		--五行令牌(水)
					{ Min = 52501, Max = 55000, Type = 20600013 },		--五行令牌(火)
					{ Min = 55001, Max = 55500, Type = 20600014 },		--五行令牌(土)
					{ Min = 55501, Max = 55625, Type = 20600010 },		--五行令牌(金)
					{ Min = 55626, Max = 655625, Type = 0 },		--经验
					{ Min = 655626, Max = 1000000, Type = 1 }		--经验+金钱
				}


x889061_g_ExpTbl = {

			[30] =1785,[31] =1837,[32] =1890,[33] =1942,[34] =1995,
			[35] =2047,[36] =2100,[37] =2152,[38] =2205,[39] =2257,
			[40] =2310,[41] =2362,[42] =2415,[43] =2467,[44] =2520,
			[45] =2572,[46] =2625,[47] =2677,[48] =2730,[49] =2782,
			[50] =2835,[51] =2887,[52] =2940,[53] =2992,[54] =3045,
			[55] =3097,[56] =3150,[57] =3202,[58] =3255,[59] =3307,
			[60] =3360,[61] =3412,[62] =3465,[63] =3517,[64] =3570,
			[65] =3622,[66] =3675,[67] =3727,[68] =3780,[69] =3832,
			[70] =3885,[71] =3937,[72] =3990,[73] =4042,[74] =4095,
			[75] =4147,[76] =4200,[77] =4252,[78] =4305,[79] =4357,
			[80] =4410,[81] =4462,[82] =4515,[83] =4567,[84] =4620,
			[85] =4672,[86] =4725,[87] =4777,[88] =4830,[89] =4882,
			[90] =4935,[91] =4987,[92] =5040,[93] =5092,[94] =5145,
			[95] =5197,[96] =5250,[97] =5302,[98] =5355,[99] =5407,
			[100] =5460,[101] =5512,[102] =5565,[103] =5617,[104] =5670,
			[105] =5722,[106] =5775,[107] =5827,[108] =5880,[109] =5932,
			[110] =5985,[111] =6037,[112] =6090,[113] =6142,[114] =6195,
			[115] =6247,[116] =6300,[117] =6352,[118] =6405,[119] =6457,
			[120] =6510,[121] =6562,[122] =6615,[123] =6667,[124] =6720,
			[125] =6772,[126] =6825,[127] =6877,[128] =6930,[129] =6982,
			[130] =7035,[131] =7087,[132] =7140,[133] =7192,[134] =7245,
			[135] =7297,[136] =7350,[137] =7402,[138] =7455,[139] =7507,
			[140] =7560,[141] =7612,[142] =7665,[143] =7717,[144] =7770,
			[145] =7822,[146] =7875,[147] =7927,[148] =7980,[149] =8032,
			[150]=0,

		}


--==================================
--事件交互入口
--==================================
function x889061_OnDefaultEvent( sceneId, selfId, targetId )
	
	--爱心救助活动
	if GetNumText() == 1 and LuaFnGetName( sceneId, targetId ) == x889061_g_NpcName then
		BeginEvent( sceneId )
			AddText( sceneId, "    金木水火土，是为五行。若是汇聚了五行的神力，便可福泽天下。#r    我正为朝廷收集具有五行神力的#Y五行令牌#W，若是你带来了#G五枚不同#W的#Y五行令牌#W，朝廷会以#Y重楼玉#W与你交换。#r    #Y五行令牌#W包括#Y五行令牌(金)#W、#Y五行令牌(木)#W、#Y五行令牌(水)#W、#Y五行令牌(火)#W、#Y五行令牌(土)#W。#r    去#G大理（172，147）#R孙八爷#W处参加#G爱心救助活动#W，将会有几率获得各种#Y五行令牌#W。" )
			AddNumText( sceneId, x889061_g_scriptId, "捐献爱心和良药", 6, 5 )
			AddNumText( sceneId, x889061_g_scriptId, "我再想想……", 6, 6 )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	end
	
	--关于爱心救助活动
	if GetNumText() == 2 and LuaFnGetName( sceneId, targetId ) == x889061_g_NpcName then
		BeginEvent( sceneId )						
			AddText( sceneId, "    在这疾病肆虐的日子里，让我们万众同心，携手对抗病魔的侵袭，为美好的生活而战吧！所有#G30级以上#W的英雄都可以在我这里参加#G爱心救助活动#W，贡献你自己的一份力量，让我们健康常在！幸福长享！#r    参加爱心救助活动需要你捐献一份#Y赤子爱心#W和一份#Y秘制良药#W。#Y赤子爱心#W可以通过参加以下活动获得：#G珍珑棋局#W、#G楼兰寻宝#W、#G贼兵入侵#W、#G偷袭门派#W。#Y秘制良药#W在#G初战缥缈峰副本#W和#G挑战燕子坞副本#W中有几率获得，也可以直接在#G元宝商店#W购买。#r    当然，参加爱心救助活动后的奖励也是丰厚的。你将有可能获得大量的#G经验#W、#G金钱#W或#Y五行令牌#W。#Y五行令牌分#G金#W、#G木#W、#G水#W、#G火#W、#G土#W五种，集齐所有五种令牌，能够去#G苏州（170，138）梁师成处兑换稀世珍宝#Y重楼玉#W一块。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		return
	end
	
	--五行神力
	if GetNumText() == 3 and LuaFnGetName( sceneId, targetId ) == x889061_g_RewardNpcName then
		BeginEvent( sceneId )	
			AddText( sceneId, "    金木水火土，是为五行。若是汇聚了五行的神力，便可福泽天下。#r    我正为朝廷收集具有五行神力的#Y五行令牌#W，若是你带来了#G五枚不同#W的#Y五行令牌#W，朝廷会以#Y重楼玉#W与你交换。#r    #Y五行令牌#W包括#Y五行令牌(金)#W、#Y五行令牌(木)#W、#Y五行令牌(水)#W、#Y五行令牌(火)#W、#Y五行令牌(土)#W。" )
			AddItemBonus( sceneId, x889061_g_RewardId, 1 )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		DispatchMissionContinueInfo( sceneId, selfId, targetId, x889061_g_scriptId, 0 )
		return
	end

	--关于五行神力
	if GetNumText() == 4 and LuaFnGetName( sceneId, targetId ) == x889061_g_RewardNpcName then
		BeginEvent( sceneId )						
			AddText( sceneId, "    金木水火土，是为五行。若是汇聚了五行的神力，便可福泽天下。#r    我正为朝廷收集具有五行神力的#Y五行令牌#W，若是你带来了#G五枚不同#W的#Y五行令牌#W，朝廷会以#Y重楼玉#W与你交换。#r    #Y五行令牌#W包括#Y五行令牌(金)#W、#Y五行令牌(木)#W、#Y五行令牌(水)#W、#Y五行令牌(火)#W、#Y五行令牌(土)#W。#r    去#G大理（172，147）#R孙八爷#W处参加#G爱心救助活动#W，将会有几率获得各种#Y五行令牌#W。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		return
	end

	--捐献
	if GetNumText() == 5 and LuaFnGetName( sceneId, targetId ) == x889061_g_NpcName then
		x889061_Donate( sceneId, selfId, targetId )
	end

	--离开
	if GetNumText() == 6 and LuaFnGetName( sceneId, targetId ) == x889061_g_NpcName then
		BeginUICommand( sceneId )
		EndUICommand( sceneId )
		DispatchUICommand( sceneId, selfId, 1000 )
	end

end


--==================================
--列举事件
--==================================
function x889061_OnEnumerate( sceneId, selfId, targetId )

	if GetName( sceneId, targetId ) == x889061_g_NpcName then

		AddNumText( sceneId, x889061_g_scriptId, "爱心救助活动", 6, 1 )
		AddNumText( sceneId, x889061_g_scriptId, "关于爱心救助活动", 11, 2 )
	
	elseif GetName( sceneId, targetId ) == x889061_g_RewardNpcName then
	
		AddNumText( sceneId, x889061_g_scriptId, "#G五行神力", 6, 3 )
		AddNumText( sceneId, x889061_g_scriptId, "#G五行神力介绍", 11, 4 )
	
	end

end

--==================================
--醒目提示
--==================================
function x889061_NotifyTip( sceneId, selfId, msg )
	BeginEvent( sceneId )
		AddText( sceneId, msg )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )
end

--==================================
--兑换重楼玉
--==================================
function x889061_OnSubmit( sceneId, selfId, targetId )

	if LuaFnGetName( sceneId, targetId ) ~= x889061_g_RewardNpcName then
		return
	end
	
	--检查是否有五个不同的五行令牌
	for i = 1, getn( x889061_g_LingpaiList ) do
		if HaveItemInBag( sceneId, selfId, x889061_g_LingpaiList[i] ) == -1 then
			BeginEvent( sceneId )						
				AddText( sceneId, "    兑换#Y重楼玉#W需要#G五枚不同#W的#Y五行令牌#W，请集齐#G五枚#Y五行令牌#W之后再来找我。" )
			EndEvent( sceneId )
			DispatchEventList( sceneId, selfId, targetId )
			return
		end
	end

	--检查是否锁定
	for i =  1, getn( x889061_g_LingpaiList ) do
		if LuaFnGetAvailableItemCount( sceneId, selfId, x889061_g_LingpaiList[i] ) < 1 then
			x889061_NotifyTip( sceneId, selfId, "#{Item_Locked}" )
			return
		end
	end

	--检查材料栏空间
	if LuaFnGetPropertyBagSpace( sceneId, selfId ) == 0 then
		BeginEvent( sceneId )						
			AddText( sceneId, "    请将#G道具栏#W留出一个#G空位#W，否则我#G无法#W将#Y重楼玉#W给你。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		return
	end
	
	--扣除道具
	for i =  1, getn( x889061_g_LingpaiList ) do
		if LuaFnDelAvailableItem( sceneId, selfId, x889061_g_LingpaiList[i], 1 ) ~= 1 then
			x889061_NotifyTip( sceneId, selfId, "#{DeleteItemFailed}" )
			return
		end
	end
	


	--释放重楼玉
	local nBagIndex = TryRecieveItem( sceneId, selfId, x889061_g_RewardId, 0 )
	if nBagIndex ~= -1 then
		--NPC对话告知成功
		BeginEvent( sceneId )						
			AddText( sceneId, "    感谢你为朝廷做出的贡献，这#Y重楼玉#W请收好。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		
		--你得到了：重楼玉
		x889061_NotifyTip( sceneId, selfId, "得到物品：重楼玉" )

		--发公告
		local szTranItm = GetBagItemTransfer( sceneId, selfId, nBagIndex )
		if szTranItm ~= nil then
			local szMsg = format( "#W#{_INFOUSR%s}#P收集到了全部#G五枚#Y五行令牌#P，在#G苏州（170，138）#Y梁师成#P处兑换到了神器#W#{_INFOMSG%s}#P！",
					LuaFnGetName( sceneId, selfId ),  szTranItm )
			AddGlobalCountNews( sceneId, szMsg )
		end

		--播放特效
		LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, 49, 0 )

		--记录日志
		local guid = LuaFnObjId2Guid( sceneId, selfId )
		if guid ~= nil then
			local szLog = format( "SceneId=%d", sceneId )
			ScriptGlobal_AuditGeneralLog( LUAAUDIT_H1N1_CHONGLOUYU, guid, szLog )
		end
	else
		x889061_NotifyTip( sceneId, selfId, "#{GiveItemFailed}" )
	end

end

--==================================
--捐献爱心和良药
--==================================
function x889061_Donate( sceneId, selfId, targetId )
	
	--检查玩家等级
	if GetLevel( sceneId, selfId ) < x889061_g_LevelLimit then
		BeginEvent( sceneId )						
			AddText( sceneId, "    你还未达到30级。请于达到30级之后再来。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		return
	end

	--检查当天参加活动次数
	local nDayCount = GetMissionData( sceneId, selfId, MD_HK_TW_DAY_H1N1_COUNT )
	local nLastDay = GetHighWord( nDayCount )
	local nCount = GetLowWord( nDayCount )
	local nToday = GetDayTime()
	if nDayCount == -1 then
		return
	elseif nLastDay == nToday and nCount >= x889061_g_MaxDayCount then
		BeginEvent( sceneId )						
			AddText( sceneId, "    爱心救助活动每天只能参加4次，请明天再来。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		return
	end

	--检查道具是否存在
	for i = 1, getn( x889061_g_DonateItemList ) do
		if HaveItemInBag( sceneId, selfId, x889061_g_DonateItemList[i] ) == -1 then
			BeginEvent( sceneId )						
				AddText( sceneId, "    你需要同时拥有#Y赤子爱心#W和#Y秘制良药#W哦。#r    #Y赤子爱心#W可以在#G珍珑棋局#W、#G楼兰寻宝#W、#G贼兵入侵#W和#G偷袭门派#W中获得。#Y秘制良药#W可以在#G初战缥缈峰#W和#G挑战燕子坞#W中获得，也可以在#G元宝商店#W购买。#r    参加爱心救助活动将有可能获得大量的#G经验#W、#G金钱#W或#Y五行令牌#W。" )
			EndEvent( sceneId )
			DispatchEventList( sceneId, selfId, targetId )
			return
		end
	end

	--检查道具是否加锁
	for i =  1, getn( x889061_g_DonateItemList ) do
		if LuaFnGetAvailableItemCount( sceneId, selfId, x889061_g_DonateItemList[i] ) < 1 then
			x889061_NotifyTip( sceneId, selfId, "#{Item_Locked}" )
			return
		end
	end
	
	--检查材料栏空间
	if LuaFnGetMaterialBagSpace( sceneId, selfId ) == 0 then
		x889061_NotifyTip( sceneId, selfId, "背包的材料栏缺少空间，请至少腾出一个空间。" )
		return
	end
	
	--关闭界面
	BeginUICommand( sceneId )
	EndUICommand( sceneId )
	DispatchUICommand( sceneId, selfId, 1000 )

	--扣除道具
	for i =  1, getn( x889061_g_DonateItemList ) do
		if LuaFnDelAvailableItem( sceneId, selfId, x889061_g_DonateItemList[i], 1 ) ~= 1 then
			x889061_NotifyTip( sceneId, selfId, "#{DeleteItemFailed}" )
			return
		end
	end

	--给奖励
	local nRand = random( 1000000 )
	for i =  1, getn( x889061_g_RewardTypeList ) do
		
		if nRand >= x889061_g_RewardTypeList[i].Min and nRand <= x889061_g_RewardTypeList[i].Max then
			
			if x889061_g_RewardTypeList[i].Type == 0 then		--经验
				local CurLevel = LuaFnGetLevel( sceneId, selfId )
				local CurExp = x889061_g_ExpTbl[CurLevel]
				LuaFnAddExp( sceneId, selfId, CurExp * 50 )
			
			elseif x889061_g_RewardTypeList[i].Type == 1 then	--经验+金钱
				local CurLevel = LuaFnGetLevel( sceneId, selfId )
				local CurExp = x889061_g_ExpTbl[CurLevel]
				LuaFnAddExp( sceneId, selfId, CurExp * 25 )
				AddMoney( sceneId, selfId, 100000 )
			
			else							--五行令牌
				local nItemId = x889061_g_RewardTypeList[i].Type
				local nBagIndex = TryRecieveItem( sceneId, selfId, nItemId, 0 )
				if nBagIndex ~= -1 then
					if nItemId == 20600011 then		--绑定木令牌
						LuaFnItemBind( sceneId, selfId, nBagIndex )
					end
					
					x889061_NotifyTip( sceneId, selfId, "你获得了" .. GetItemName( sceneId, nItemId ) )
					--发公告
					local szTranItm = GetBagItemTransfer( sceneId, selfId, nBagIndex )
					if szTranItm ~= nil then
						local szMsg = format( "#W#{_INFOUSR%s}#P大侠无私地奉献出#Y赤子爱心#P和#Y秘制良药#P，#G大理（172，147）#Y孙八爷#P大受感动，赠予其一枚#W#{_INFOMSG%s}#P，爱心的付出果然获得了丰厚的回报！",
								LuaFnGetName( sceneId, selfId ),  szTranItm )
						AddGlobalCountNews( sceneId, szMsg )
					end

					--记录日志
					local guid = LuaFnObjId2Guid( sceneId, selfId )
					if guid ~= nil then
						local szLog = format( "SceneId=%d,LingpaiID=%d", sceneId, nItemId )
						ScriptGlobal_AuditGeneralLog( LUAAUDIT_H1N1_WUXINGLINGPAI, guid, szLog )
					end
				else
					x889061_NotifyTip( sceneId, selfId, "#{GiveItemFailed}" )
				end
			end
			
			--播放特效
			LuaFnSendSpecificImpactToUnit( sceneId, selfId, selfId, selfId, 49, 0 )

			--更新活动参加次数
			local nData = 0
			if nLastDay ~= nToday then
				nData = SetHighWord( nData, nToday )
				nData = SetLowWord( nData, 1 )
			else
				nData = SetHighWord( nData, nToday )
				nData = SetLowWord( nData, nCount + 1 )
			end
			SetMissionData( sceneId, selfId, MD_HK_TW_DAY_H1N1_COUNT, nData )
			
			return
		end

	end
end
