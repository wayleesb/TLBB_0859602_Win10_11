
-- 脚本号
x801022_g_ScriptId = 801022
--**********************************
function x801022_OnDefaultEvent( sceneId, selfId, targetId )
	CallScriptFunction( 801016, "Broadcast_CANDIDATE_EXAM",sceneId, selfId )
end


--**********************************
--心跳函数
--**********************************
function x801022_OnTimer( sceneId, actId, uTime )
end

