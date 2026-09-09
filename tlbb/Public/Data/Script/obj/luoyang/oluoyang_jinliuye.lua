--洛阳NPC
--金六爷
--普通

x000100_g_scriptId 	= 181000
x000100_g_gotoact	 	= 2
x000100_g_YBBTIntro =11     --元宝摆摊介绍
x000100_g_leave			= 20

--**********************************
--事件交互入口
--**********************************
function x000100_OnDefaultEvent( sceneId, selfId,targetId )
	BeginEvent(sceneId)
		AddText(sceneId,"  欢迎光临，一看您就是贵客，我已经通知总部那边做好接待工作了，您现在就要去我们的总部吗？")
		
		AddNumText( sceneId, x000100_g_scriptId, "前往钱庄总部", 9, x000100_g_gotoact)
		AddNumText( sceneId, x000100_g_scriptId, "元宝摆摊介绍", 11, x000100_g_YBBTIntro)
		--AddNumText( sceneId, x000100_g_scriptId, "离开……", -1, x000100_g_leave)
	EndEvent(sceneId)
	DispatchEventList(sceneId,selfId,targetId)
end

--**********************************
--事件列表选中一项
--**********************************
function x000100_OnEventRequest( sceneId, selfId, targetId, eventId )
	if GetNumText() == x000100_g_gotoact then
		--NewWorld(sceneId,selfId,181,65,62)
		CallScriptFunction((400900), "TransferFunc",sceneId, selfId, 181,65,62)
	elseif GetNumText() == x000100_g_YBBTIntro then
	  BeginEvent( sceneId )
			AddText( sceneId, "#{YBBT_081023_2}" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
		return
	elseif GetNumText() == x000100_g_leave then
		BeginUICommand( sceneId )
			UICommand_AddInt( sceneId, targetId )
		EndUICommand( sceneId )
		DispatchUICommand( sceneId, selfId, 1000 )
	end
end
