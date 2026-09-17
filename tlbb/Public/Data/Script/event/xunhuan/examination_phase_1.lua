
-- 脚本号
x801019_g_ScriptId = 801019
--**********************************
function x801019_OnDefaultEvent( sceneId, selfId, targetId )
	CallScriptFunction( 801016, "Broadcast_CANDIDATE_EXAM",sceneId, selfId )
end


--**********************************
--心跳函数
--**********************************
function x801019_OnTimer( sceneId, actId, uTime )
end

