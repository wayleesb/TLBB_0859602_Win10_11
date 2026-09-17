
-- 脚本号
x801021_g_ScriptId = 801021
--**********************************
function x801021_OnDefaultEvent( sceneId, selfId, targetId )
	CallScriptFunction( 801016, "Broadcast_TOP_3_EXAM",sceneId, selfId )
end


--**********************************
--心跳函数
--**********************************
function x801021_OnTimer( sceneId, actId, uTime )
end

