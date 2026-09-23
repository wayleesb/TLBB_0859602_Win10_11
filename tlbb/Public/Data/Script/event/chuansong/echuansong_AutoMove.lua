--跨场景传送服务端处理脚本
--主要是程序实现，脚本仅用于NPC传送的合法性检测
--客户端发起到下一个场景的请求
function x889888_ClientQueryTrans( sceneId, selfId, nTransPos )
	if not nTransPos then return end
	local nScoreSceneID,nScorePosX,nScorePosZ,nTargetSceneID,nNeedLevel,nTarPosX,nTarPosZ = LuaFnGetTransportByIndex(nTransPos)

	--没有数据
	if not nScoreSceneID or nScoreSceneID == -1 then
		return
	end
	--不是同一场景，这种都是非法数据
	-- 当前仅启用静态场景，不使用参考端的动态场景占位号例外。
	if nScoreSceneID ~= sceneId then
		return
	end
	--取得目前的位置是否足够
	local nCurPosX,nCurPosZ = GetWorldPos(sceneId,selfId)
	if not nCurPosX or not nCurPosZ or nCurPosX < 0 or nCurPosZ < 0
		or nScorePosX < 0 or nScorePosZ < 0 then
		return
	end
	local nDistance = floor(sqrt((nCurPosX-nScorePosX)*(nCurPosX-nScorePosX)+(nCurPosZ-nScorePosZ)*(nCurPosZ-nScorePosZ)))
	if nDistance > 6 then
		return
	end
	--等级不对
	if nNeedLevel > GetLevel(sceneId,selfId) then
		print("[debug]nNeedLevel > GetLevel(sceneId,selfId) %d,%d\n",nNeedLevel,GetLevel(sceneId,selfId))
		x889888_Notify(sceneId, selfId, "你的等级不符合此传送入口的要求。")
		return
	end
	if nTargetSceneID == -1 or nTarPosX < 0 or nTarPosZ < 0 then
		return
	end
	if nTargetSceneID < 0 or nTargetSceneID > 1289 then
		print("自动寻路异常,场景ID为负数"..nTargetSceneID)
		return
	end
	--不能是当前场景
	if nTargetSceneID == sceneId then
		return
	end

	-- 当前版本适配：服务端同样检查自动寻路的死亡、摆摊、漕运和跑商状态。
	if LuaFnIsCharacterLiving(sceneId, selfId) ~= 1 or LuaFnIsStalling(sceneId, selfId) == 1 then return end
	if IsHaveMission(sceneId, selfId, 4021) > 0 or GetItemCount(sceneId, selfId, 40002000) > 0 then
		x889888_Notify(sceneId, selfId, "漕运或跑商状态下无法使用自动传送。")
		return
	end
	--允许传送
	-- 当前版本适配：队友和双人坐骑乘客继续检查入口最低等级。
	CallScriptFunction((400900), "TransferFunc",sceneId, selfId, nTargetSceneID,nTarPosX,nTarPosZ,nNeedLevel)
end

function x889888_Notify(sceneId, selfId, message)
	BeginEvent(sceneId)
		AddText(sceneId, message)
	EndEvent(sceneId)
	DispatchMissionTips(sceneId, selfId)
end
