
-- 脚本号
x801020_g_ScriptId = 801020
--**********************************
function x801020_OnDefaultEvent( sceneId, selfId, targetId )
	CallScriptFunction( 801016, "Broadcast_CANDIDATE_EXAM",sceneId, selfId )
end


--**********************************
--心跳函数
--**********************************
function x801020_OnTimer( sceneId, actId, uTime )
end

