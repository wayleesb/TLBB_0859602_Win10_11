--金币兑换交子

x800119_g_ScriptId = 800119
--**********************************
--金币兑换交子
--**********************************
function x800119_DoMoneyToJiaozi(sceneId,selfId,nMoney)
	--安全时间
	if IsPilferLockFlag(sceneId,selfId) <= 0 then
		SendOResultToPlayer(sceneId,selfId,OR_PILFER_LOCK_FLAG)
		return
	end
	if GetMoney(sceneId,selfId) < nMoney then
		x800119_NotifyTip( sceneId, selfId, "#{JBJZ_090407_5}" )
		return	
	end
	--是否上限 GetMoney(sceneId,selfId) + 
	if nMoney + GetMoneyJZ(sceneId,selfId) > 144000000 then
		x800119_NotifyTip( sceneId, selfId, "#{JBJZ_090407_6}" ) --输入的金额过大或已达到交子携带上限。您的携带上限是14400金交子。
		return	
	end
	
	local nRet = LuaFnDoMoneyToJZ(sceneId,selfId,nMoney);
	if nRet ~= -1 then
		x800119_NotifyTip( sceneId, selfId, "#{JBJZ_090407_10}" )
		x800119_NotifyTip( sceneId, selfId, "#{JBJZ_090407_12}" )
	else
		x800119_NotifyTip( sceneId, selfId, "内部错误，请联系客服解决问题！DoMoneyToJiaozi" )
	end
	
	
end
--**********************************
--醒目提示
--**********************************
function x800119_NotifyTip( sceneId, selfId, Msg )
	BeginEvent( sceneId )
		AddText( sceneId, Msg )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )
end