--道具：暗金钥匙<ID:30008037>
--脚本号 332203
--Author: Steven.Han 10:39 2007-5-17

x332203_g_scriptId = 332203
x332203_g_JuBaoContainerInfo = ""

x332203_g_strGongGaoInfo = {
  "#{_INFOUSR%s}#H开启#G#{_ITEM30008037}#H时，竟然真的如愿获得了#{_INFOMSG%s}#H，真是令人羡慕啊！",
  "#{_INFOUSR%s}#H正在埋怨#G#{_ITEM30008037}#H太小时，竟然在里面发现了一个更大的#{_INFOMSG%s}！",
  "#{_INFOUSR%s}#H为了方便跑商，四处寻找#{_INFOMSG%s}#H，今天终于在#G#{_ITEM30008037}#H里找到了！",
}
--**********************************
--事件交互入口
--**********************************
function x332203_OnDefaultEvent( sceneId, selfId, bagIndex )
-- 不需要这个接口，但要保留空函数
end

--**********************************
--这个物品的使用过程是否类似于技能：
--系统会在执行开始时检测这个函数的返回值，如果返回失败则忽略后面的类似技能的执行。
--返回1：技能类似的物品，可以继续类似技能的执行；返回0：忽略后面的操作。
--**********************************
function x332203_IsSkillLikeScript( sceneId, selfId)
	return 1; --这个脚本需要动作支持
end

--**********************************
--直接取消效果：
--系统会直接调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：已经取消对应效果，不再执行后续操作；返回0：没有检测到相关效果，继续执行。
--**********************************
function x332203_CancelImpacts( sceneId, selfId )
	return 0; --不需要这个接口，但要保留空函数,并且始终返回0。
end

--**********************************
--条件检测入口：
--系统会在技能检测的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：条件检测通过，可以继续执行；返回0：条件检测失败，中断后续执行。
--**********************************
function x332203_OnConditionCheck( sceneId, selfId )
	if(1~=LuaFnVerifyUsedItem(sceneId, selfId)) then
		return 0
	end

--因为聚宝瓶是要先被消耗掉的所以不用判断是否需要空间	
--	local FreeSpace = LuaFnGetPropertyBagSpace( sceneId, selfId )
--	if( FreeSpace < 1 ) then
--	        local strNotice = "背包空间不足。"
--		      x332203_ShowNotice( sceneId, selfId, strNotice)
--	        return 0
--	end
			
	return 1; --不需要任何条件，并且始终返回1。
end

--**********************************
--消耗检测及处理入口：
--系统会在技能消耗的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：消耗处理通过，可以继续执行；返回0：消耗检测失败，中断后续执行。
--注意：这不光负责消耗的检测也负责消耗的执行。
--**********************************
function x332203_OnDeplete( sceneId, selfId )
	if(0<LuaFnDepletingUsedItem(sceneId, selfId)) then
		return 1;
	end

	return 0;
end

--**********************************
--只会执行一次入口：
--聚气和瞬发技能会在消耗完成后调用这个接口（聚气结束并且各种条件都满足的时候），而引导
--技能也会在消耗完成后调用这个接口（技能的一开始，消耗成功执行之后）。
--返回1：处理成功；返回0：处理失败。
--注：这里是技能生效一次的入口
--**********************************
function x332203_OnActivateOnce( sceneId, selfId )

    --数据统计：聚宝瓶的使用
	  LuaFnAuditJuBaoContainerUsed(sceneId, selfId, 0, 0)
	
    local RandomBase = GetJuBaoContainerItemDropCount( sceneId, selfId )
    if( RandomBase > 0 ) then    
       		
        local RandomNum = random( 0, RandomBase - 1 )
        local RandomID, Notice = JuBaoContainerItemDropRandom( sceneId, selfId, RandomNum )
       
        if( RandomID > 0 ) then
           BeginAddItem(sceneId)
				   AddItem( sceneId, RandomID, 1 )
			     local Ret = LuaFnEndAddItemIgnoreFatigueState( sceneId, selfId )
			     if Ret > 0 then
			       	LuaFnAddItemListToHumanIgnoreFatigueState(sceneId,selfId)
			       	if 1 == Notice then
			       	   local szItemTransfer = GetItemTransfer(sceneId,selfId,0)
					       x332203_ShowRandomSystemNotice( sceneId, selfId, szItemTransfer )
				      end
				      
				      local ItemName = GetItemName(sceneId, RandomID)
				      local strNotice = "您得到了"..ItemName
				      x332203_ShowNotice( sceneId, selfId, strNotice)
				      LuaFnSendSpecificImpactToUnit(sceneId, selfId, selfId, selfId, 18, 0);
				   else
				      local strNotice = "背包空间不足"
				      x332203_ShowNotice( sceneId, selfId, strNotice)
			     end
			
        end
        
    end
    
	return 1;
end

--**********************************
--引导心跳处理入口：
--引导技能会在每次心跳结束时调用这个接口。
--返回：1继续下次心跳；0：中断引导。
--注：这里是技能生效一次的入口
--**********************************
function x332203_OnActivateEachTick( sceneId, selfId)
	return 1; --不是引导性脚本, 只保留空函数.
end

function x332203_ShowNotice( sceneId, selfId, strNotice)
	BeginEvent( sceneId )
		AddText( sceneId, strNotice )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )    
end

function x332203_ShowRandomSystemNotice( sceneId, selfId, strItemInfo )
	
	local PlayerName = GetName(sceneId,selfId)
	local nMsgIndex = random( 1, 3 )
	local str
	if nMsgIndex == 1 then
		str = format( x332203_g_strGongGaoInfo[1], PlayerName, strItemInfo )
	elseif nMsgIndex == 2 then
		str = format( x332203_g_strGongGaoInfo[2], PlayerName, strItemInfo )
	else
		str = format( x332203_g_strGongGaoInfo[3], PlayerName, strItemInfo )
	end
	BroadMsgByChatPipe( sceneId, selfId, str, 4 )
	
end
