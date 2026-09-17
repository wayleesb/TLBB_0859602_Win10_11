
-- 脚本号
x801023_g_ScriptId = 801023
--**********************************
function x801023_OnDefaultEvent( sceneId, selfId, targetId )
	CallScriptFunction( 801016, "Broadcast_TOP_3_EXAM",sceneId, selfId )
end


--**********************************
--心跳函数
--**********************************
function x801023_OnTimer( sceneId, actId, uTime )
end

