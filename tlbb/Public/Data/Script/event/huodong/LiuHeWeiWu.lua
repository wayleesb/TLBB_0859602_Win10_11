-- 六合威武 20090512

x889058_g_ScriptId = 889058;

-- 需求物品ID
x889058_g_NeedItemID		= {
	30504101,		-- 六合令牌(东)
	30504102,		-- 六合令牌(北)
	30504103,		-- 六合令牌(西)
	30504104,		-- 六合令牌(南)
	30504105,		-- 六合令牌(上)
	30504106,		-- 六合令牌(下)
}

-- 奖励相关
x889058_g_AwradInfo		=	{
	{ItemId = 10422016, LackItemMsg = "    兑换#Y重楼戒#W需要#G六枚不同#W的#Y六合令牌#W，请集齐#G六枚#Y六合令牌#W之后再来找我。", RetDlg = "    感谢你为朝廷做出的贡献，这#Y重楼戒#W请收好。", Notice = "得到物品：重楼戒", BagFullDlg = "    请将道具栏留出一个空位，否则我无法将#Y重楼戒#W给你。"},	-- 重楼戒
--	{ItemId = 10423024, LackItemMsg = "#{LHZD_090513_07}", RetDlg = "#{LHZD_090513_08}", Notice = "#{LHZD_090513_09}", BagFullDlg = "#{LHZD_090513_17}"}	-- 重楼玉
}


--**********************************
--列举事件
--**********************************
function x889058_OnEnumerate( sceneId, selfId, targetId )
	
	AddNumText( sceneId, x889058_g_ScriptId, "#G六合威武", 6, 10 )					-- 按钮： 六合威武
	AddNumText( sceneId, x889058_g_ScriptId, "#G六合威武介紹", 11, 11 )				-- 按钮： 六合威武介绍
	
end

--**********************************
--任务入口函数
--**********************************
function x889058_OnDefaultEvent( sceneId, selfId, targetId )

	local nNumText = GetNumText( )
	
	if( nNumText == 10 ) then
		-- 点击 六合威武
		-- BeginEvent( sceneId )
		-- AddText( sceneId, "#{LHZD_090513_01}#r" )
		-- for i, item in x889058_g_AwradInfo do
		-- 	AddRadioItemBonus( sceneId, item.ItemId, 1 )
		-- end
		-- EndEvent(sceneId)
		-- DispatchEventList( sceneId, selfId, targetId )
		-- DispatchMissionContinueInfo( sceneId, selfId, targetId, x889058_g_ScriptId, 0 )
		x889058_GiveGift( sceneId, selfId, targetId, 10422016 )
	elseif( nNumText == 11 ) then
		-- 点击 六合威武介绍
		BeginEvent( sceneId )	
			AddText( sceneId, "    东西南北上下，是为六合。若是拥有六合之力，便可威四方、震天下。#r    我正为朝廷收集具有六合之力的#Y六合令牌#W，若是你带来了六枚#G不同#W的#Y六合令牌#W，朝廷会以#Y重楼戒#W与你交换。#r    #Y六合令牌#W可以在#Y六合转蛋#W中得到。" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		
	end
		
end


--**********************************
--返回对话
--**********************************
function x889058_ReturnDlg(sceneId, selfId, targetId, msg)
	BeginEvent(sceneId)
		AddText(sceneId, msg);
	EndEvent()
	DispatchEventList(sceneId, selfId, targetId)
end

--**********************************
--ReturnTips
--**********************************
function x889058_Tips(sceneId, selfId, msg)
	BeginEvent(sceneId)
		AddText(sceneId, msg);
	EndEvent()
	DispatchMissionTips(sceneId, selfId)
end

--**********************************
--接受
--**********************************
function x889058_OnAccept( sceneId, selfId )
	
end

--**********************************
--放弃
--**********************************
function x889058_OnAbandon( sceneId, selfId )
end

--**********************************
--继续
--**********************************
function x889058_OnContinue( sceneId, selfId, targetId )
end

--**********************************
--检测是否可以提交
--**********************************
function x889058_CheckSubmit( sceneId, selfId )
	

	
end

--**********************************
--提交
--**********************************
function x889058_GiveGift( sceneId, selfId, targetId, selectRadioId )
	
	
	local LackItemMsg, RetDlg, Notice, BagFullDlg

	for i, ItemInfo in x889058_g_AwradInfo do
		if( ItemInfo.ItemId == selectRadioId ) then
			LackItemMsg		= ItemInfo.LackItemMsg
			RetDlg 				= ItemInfo.RetDlg
			Notice 				= ItemInfo.Notice
			BagFullDlg		= ItemInfo.BagFullDlg
			break
		end
	end
	
	-- 判断物品是否够
	for i, itemId in x889058_g_NeedItemID do
		if( LuaFnGetAvailableItemCount( sceneId, selfId, itemId ) < 1 ) then
			x889058_ReturnDlg( sceneId, selfId, targetId, LackItemMsg )
			return
		end
	end
	
	-- 扣物品
	for i, itemId in x889058_g_NeedItemID do
		if( LuaFnDelAvailableItem( sceneId, selfId, itemId, 1) < 1 ) then
			x889058_ReturnDlg( sceneId, selfId, targetId, LackItemMsg )
			return
		end
	end
	
	-- 检查背包空间
	BeginAddItem(sceneId)
	AddItem(sceneId, selectRadioId, 1)
	local bBagOk = LuaFnEndAddItemIgnoreFatigueState(sceneId, selfId)
	if bBagOk < 1 then
		x889058_ReturnDlg( sceneId, selfId, targetId, BagFullDlg )
		return
	else
		-- 添加物品
		LuaFnAddItemListToHumanIgnoreFatigueState( sceneId, selfId )
		
		-- 通知
		x889058_Tips( sceneId, selfId, Notice )
		x889058_ReturnDlg( sceneId, selfId, targetId, RetDlg )
		
		-- 公告
		local playerName = GetName(sceneId,selfId)
		local itemTransInfo = GetItemTransfer( sceneId, selfId, 0 )
		broadcastMsg	=	"#{_INFOUSR"..playerName.."}".."#I收集到了全部六枚#Y六合令牌#I，在#G苏州（170，138）#R梁师成#I处兑换到了神器".."#{_INFOMSG"..itemTransInfo.."}".."#I！"
	end
	
	BroadMsgByChatPipe( sceneId, selfId, broadcastMsg, 4 )
end
	

--**********************************
--杀死怪物或玩家
--**********************************
function x889058_OnKillObject( sceneId, selfId, objdataId )
end

--**********************************
--进入区域事件
--**********************************
function x889058_OnEnterArea( sceneId, selfId, zoneId )
end

--**********************************
--道具改变
--**********************************
function x889058_OnItemChanged( sceneId, selfId, itemdataId )
end

