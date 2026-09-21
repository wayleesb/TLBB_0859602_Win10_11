--NPC
--
--普通
x001154_g_ScriptId = 001154
--**********************************
--事件交互入口
--**********************************
function x001154_OnDefaultEvent( sceneId, selfId,targetId )
	BeginEvent(sceneId)
		AddText(sceneId,"#{AQSJ_090709_01}")
		AddNumText( sceneId, x001154_g_ScriptId, "#{AQSJ_090709_02}", 6, 1 )
		AddNumText( sceneId, x001154_g_ScriptId, "#{AQSJ_090709_03}", 6, 2 )
		AddNumText( sceneId, x001154_g_ScriptId, "#{AQSJ_090709_04}", 11, 3 )
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end
--**********************************
--事件列表选中一项
--**********************************
function x001154_OnEventRequest( sceneId, selfId, targetId, eventId )
	local nNumText = GetNumText();
	--锻造冰魄神针
	if nNumText == 1 then
		BeginUICommand( sceneId )
			UICommand_AddInt(sceneId,targetId)
		EndUICommand(sceneId)
		DispatchUICommand( sceneId, selfId,070825)
		return
	end
	--兑换寒冰星石
	if nNumText == 2 then
		BeginEvent(sceneId)
			AddText(sceneId,"#{AQSJ_090709_13}")
			AddNumText( sceneId, x001154_g_ScriptId, "#{AQSJ_090709_14}", 6, 10 )
			AddNumText( sceneId, x001154_g_ScriptId, "#{AQSJ_090709_15}", 0, 4 )
		EndEvent(sceneId)
		DispatchEventList(sceneId,selfId,targetId)
	end
	--冰魄神针介绍
	if nNumText == 3 then
		x001154_MsgBox( sceneId, selfId, targetId, "#{AQSJ_090709_19}")
		return
	end
	--返回上一页
	if nNumText == 4 then
		x001154_OnDefaultEvent( sceneId, selfId,targetId )
		return
	end
	--兑换寒冰星屑主逻辑
	if nNumText == 10 then
		x001154_AddHanBingXingShi(sceneId,selfId)
	end
end
--**********************************
--寒冰星石主逻辑
--**********************************
function x001154_AddHanBingXingShi(sceneId,selfId)
	local ItemInfo = {20310113,20310114}
	local Bind = 0
	local HaveItemNum = LuaFnMtl_GetCostNum(sceneId,selfId,ItemInfo[1],ItemInfo[2])
	if HaveItemNum < 20 then
		x001154_NotifyTips(sceneId, selfId, "#{AQSJ_090709_16}")
		return
	end
	if LuaFnGetPropertyBagSpace(sceneId,selfId) < 1 then
		x001154_NotifyTips(sceneId, selfId, "#{AQSJ_090709_17}")
		return
	end
	--扣除材料前检测一下是否存在绑定的寒冰星屑
	local nBindNum = LuaFnGetBindItemCountInBag(sceneId, selfId, ItemInfo[2]) --优先寻找绑定材料
	if nBindNum > 0 then
		Bind = 1
	end
	-- 先生成独立物品，失败时不扣材料；扣料失败则撤销刚生成的物品。
	local itemId = 30008069
	if Bind == 1 then itemId = 30008070 end
	local newPos = LuaFnTryRecieveSingleItem(sceneId,selfId,itemId,1,0)
	if newPos == nil or newPos < 0 then
		x001154_NotifyTips(sceneId,selfId,"#{AQSJ_090709_17}")
		return
	end
	-- 用户指定绑定材料优先，因此将绑定编号放在扣除参数首位。
	if LuaFnMtl_CostMaterial(sceneId,selfId,20,ItemInfo[2],ItemInfo[1]) ~= 1 then
		EraseItem(sceneId,selfId,newPos)
		x001154_NotifyTips(sceneId,selfId,"#{AQSJ_090709_27}")
		return
	end
	--兑换成功提示
	x001154_NotifyTips(sceneId,selfId,"#{AQSJ_090709_18}")
end
--**********************************
--对话窗口信息提示
--**********************************
function x001154_MsgBox( sceneId, selfId, targetId, msg )
	BeginEvent( sceneId )
		AddText( sceneId, msg )
	EndEvent( sceneId )
	DispatchEventList( sceneId, selfId, targetId )
end
--**********************************
-- 信息提示
--**********************************
function x001154_NotifyTips(sceneId, selfId, msg)
	BeginEvent( sceneId )
	AddText( sceneId, msg )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )
end
