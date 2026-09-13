--道具：暗器双倍经验使用相关
--脚本号 332207
--Author:  houzhifang  2008-12-11

x332207_g_scriptId = 332207

x332207_DarkItem_DoubleExp = 
{
	{ItemIndex = 30503117, ImpactId = 32409, GiveExp = 2},
	{ItemIndex = 30503116, ImpactId = 32408, GiveExp = 1.5},
}

x332207_DarkItem_AdjustAttrItem = 30503115
x332207_DarkItem_AdjustSkillItem = 30503118
x332207_DarkItem_ResetQuality = {type1= 30503119, type2= 30503120}
x332207_DarkItem_Resetdark = 30503121

--**********************************
--事件交互入口
--**********************************
function x332207_OnDefaultEvent( sceneId, selfId, bagIndex )
-- 不需要这个接口，保留空函数
end

--**********************************
--这个物品的使用过程是否类似于技能：
--系统会在执行开始时检测这个函数的返回值，如果返回失败则忽略后面的类似技能的执行。
--返回1：技能类似的物品，可以继续类似技能的执行；返回0：忽略后面的操作。
--**********************************
function x332207_IsSkillLikeScript( sceneId, selfId)
	return 1; --这个脚本需要动作支持
end

--**********************************
--直接取消效果：
--系统会直接调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：已经取消对应效果，不再执行后续操作；返回0：没有检测到相关效果，继续执行。
--**********************************
function x332207_CancelImpacts( sceneId, selfId )
	return 0; --不需要这个接口，但要保留空函数,并且始终返回0。
end

--**********************************
--条件检测入口：
--系统会在技能检测的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：条件检测通过，可以继续执行；返回0：条件检测失败，中断后续执行。
--**********************************
function x332207_OnConditionCheck( sceneId, selfId )
	if(1~=LuaFnVerifyUsedItem(sceneId, selfId)) then
		return 0
	end
	
	local nItemIndex = LuaFnGetItemIndexOfUsedItem( sceneId, selfId )
	local nGiveExp = 0
	local nGiveImpactId = 0	

	for i = 1, getn(x332207_DarkItem_DoubleExp) do
		if x332207_DarkItem_DoubleExp[i].ItemIndex == nItemIndex then
			nGiveExp = x332207_DarkItem_DoubleExp[i].GiveExp
			nGiveImpactId = x332207_DarkItem_DoubleExp[i].ImpactId
			break
		end
	end
	
	if nGiveExp == 0 or nGiveImpactId == 0 then
		return 0;
	end
	
	local nHaveImpact = 0
	--houzf 20090114修改，如果已经设置过2倍的，就不能再设了，如果已经设过的是1.5倍的，则可以被2倍的顶掉，不能再设1.5倍的
	if (nItemIndex == x332207_DarkItem_DoubleExp[2].ItemIndex) then
		for i = 1, getn(x332207_DarkItem_DoubleExp) do
			local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[i].ImpactId)
			if nRet == 1 then
				nHaveImpact = 1
			end
		end
	elseif (nItemIndex == x332207_DarkItem_DoubleExp[1].ItemIndex) then
		local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[1].ImpactId)
		if nRet == 1 then
			nHaveImpact = 1
		end
	end

	--for i = 1, getn(x332207_DarkItem_DoubleExp) do
	--	local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[i].ImpactId)
	--	if nRet == 1 then
	--		nHaveImpact = 1
	--	end
	--end
	
	if nHaveImpact == 1 then
		local strNotice =  "#{FBSJ_081209_88}"
		x332207_ShowNotice( sceneId, selfId, strNotice)
		return 0;
	end
	
	return 1; --不需要任何条件，并且始终返回1。
end

--**********************************
--消耗检测及处理入口：
--系统会在技能消耗的时间点调用这个接口，并根据这个函数的返回值确定以后的流程是否执行。
--返回1：消耗处理通过，可以继续执行；返回0：消耗检测失败，中断后续执行。
--注意：这不光负责消耗的检测也负责消耗的执行。
--**********************************
function x332207_OnDeplete( sceneId, selfId )
	
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
function x332207_OnActivateOnce( sceneId, selfId )

	local nItemIndex = LuaFnGetItemIndexOfUsedItem( sceneId, selfId )
	local nGiveExp = 0
	local nGiveImpactId = 0
	for i = 1, getn(x332207_DarkItem_DoubleExp) do
		if x332207_DarkItem_DoubleExp[i].ItemIndex == nItemIndex then
			nGiveExp = x332207_DarkItem_DoubleExp[i].GiveExp
			nGiveImpactId = x332207_DarkItem_DoubleExp[i].ImpactId
			break
		end
	end
	
	if nGiveExp == 0 or nGiveImpactId == 0 then
		return 0;
	end
	
	local nHaveImpact = 0
	--houzf 20090114修改，如果已经设置过2倍的，就不能再设了，如果已经设过的是1.5倍的，则可以被2倍的顶掉，不能再设1.5倍的
	if (nItemIndex == x332207_DarkItem_DoubleExp[2].ItemIndex) then
		for i = 1, getn(x332207_DarkItem_DoubleExp) do
			local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[i].ImpactId)
			if nRet == 1 then
				nHaveImpact = 1
			end
		end
	elseif (nItemIndex == x332207_DarkItem_DoubleExp[1].ItemIndex) then
		local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[1].ImpactId)
		if nRet == 1 then
			nHaveImpact = 1
		end
	end
	
	--for i = 1, getn(x332207_DarkItem_DoubleExp) do
	--	local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[i].ImpactId)
	--	if nRet == 1 then
	--		nHaveImpact = 1
	--	end
	--end
	
	if nHaveImpact == 1 then
		local strNotice = "#{FBSJ_081209_88}"
		x332207_ShowNotice( sceneId, selfId, strNotice)
		return 0;
	end
	
	LuaFnSendSpecificImpactToUnit(sceneId, selfId, selfId, selfId, nGiveImpactId, 0)
	
	return 1;
end

--**********************************
--引导心跳处理入口：
--引导技能会在每次心跳结束时调用这个接口。
--返回：1继续下次心跳；0：中断引导。
--注：这里是技能生效一次的入口
--**********************************
function x332207_OnActivateEachTick( sceneId, selfId)
	return 1; --不是引导性脚本, 只保留空函数.
end

function x332207_ShowNotice( sceneId, selfId, strNotice)
	BeginEvent( sceneId )
		AddText( sceneId, strNotice )
	EndEvent( sceneId )
	DispatchMissionTips( sceneId, selfId )    
end

function x332207_ShowRandomSystemNotice( sceneId, selfId, strItemInfo )
	
	--这个函数现在没有用
	--local PlayerName = GetName(sceneId,selfId)
	--local str = format( x332206_g_strGongGaoInfo, PlayerName, strItemInfo )
	--BroadMsgByChatPipe( sceneId, selfId, str, 4 )
	
end



function x332207_DarkAttrAdjustForBagItem( sceneId, selfId, bagpos, attrfrom )
	
	local nCleanTimes = GetDarkCleanTimes(sceneId, selfId, bagpos);
	local nTotalCleanTimes = GetDarkTotalCleanTimes(sceneId, selfId, bagpos);
	if (nCleanTimes >= nTotalCleanTimes) then
		DarkOperateResult(sceneId, selfId, 0, -3);
		return
	end
	
	local nAttrValue = GetDarkAttrForBagItem(sceneId, selfId, bagpos, attrfrom);
	if (nAttrValue <= 1) then
		DarkOperateResult(sceneId, selfId, 0, -1);
		return
	end
	
	--有这个物品吗
	local bHave = LuaFnGetAvailableItemCount(sceneId, selfId, x332207_DarkItem_AdjustAttrItem);
	if(bHave < 1) then
		DarkOperateResult(sceneId, selfId, 0, -2);
		return
	end
	
	local bMoneyEnough = x332207_HaveEnoughMoney(sceneId, selfId, 0, 10000);
	if ( 1 ~= bMoneyEnough ) then
	    return
	end
	local bCostMoney = x332207_CostMoney(sceneId, selfId, 0, 10000);
	if ( 1 ~= bCostMoney ) then
	    return
	end
	
	--扣除成功
	if (LuaFnDelAvailableItem(sceneId, selfId, x332207_DarkItem_AdjustAttrItem, 1) ~= 1)  then
		DarkOperateResult(sceneId, selfId, 0, -2);
		return
	end
	
	SetDarkCleanTimes(sceneId, selfId, bagpos, nCleanTimes+1);
	local nAttrTo = AdjustDarkAttrForBagItem(sceneId, selfId, bagpos, attrfrom );
	if nAttrTo == -1 then
		--失败了，通知客户端
		DarkOperateResult(sceneId, selfId, 0, -1);
	else
		--成功了，通知客户端
		DarkOperateResult(sceneId, selfId, 0, nAttrTo);
		x332207_SendImpact(sceneId, selfId, 1);
	end
end

function x332207_DarkSkillAdjustForBagItem( sceneId, selfId, bagpos )
	
	--有这个物品吗
	local bHave = LuaFnGetAvailableItemCount(sceneId, selfId, x332207_DarkItem_AdjustSkillItem);
	if(bHave < 1) then
		DarkOperateResult(sceneId, selfId, 1, -2);
		return
	end
	local bMoneyEnough = x332207_HaveEnoughMoney(sceneId, selfId, 1, 50000);
	if ( 1 ~= bMoneyEnough ) then
	    return
	end
	local bCostMoney = x332207_CostMoney(sceneId, selfId, 1, 50000);
	if ( 1 ~= bCostMoney ) then
	    return
	end
	--扣除成功
	if (LuaFnDelAvailableItem(sceneId, selfId, x332207_DarkItem_AdjustSkillItem, 1) ~= 1)  then
		DarkOperateResult(sceneId, selfId, 1, -2);
		return
	end
	
	local nSucc = AdjustDarkSkillForBagItem(sceneId, selfId, bagpos);
	if nSucc ~= 1 then
		--失败了，通知客户端
		DarkOperateResult(sceneId, selfId, 1, -1);
	else
		--成功了，通知客户端
		DarkOperateResult(sceneId, selfId, 1, 1);
		x332207_SendImpact(sceneId, selfId, 2);
	end
end

function x332207_DarkResetForBagItem( sceneId, selfId, bagpos )
	--有这个物品吗
	local nNeedItem = x332207_DarkItem_Resetdark;
		 
	local bHave = LuaFnGetAvailableItemCount(sceneId, selfId, nNeedItem);
	if(bHave < 1) then
		DarkOperateResult(sceneId, selfId, 6, -2);		
		return
	end
	local bMoneyEnough = x332207_HaveEnoughMoney(sceneId, selfId, 6, 10000);
	if ( 1 ~= bMoneyEnough ) then
	    return
	end
	local bCostMoney = x332207_CostMoney(sceneId, selfId, 6, 10000);
	if ( 1 ~= bCostMoney ) then
	    return
	end
	--扣除成功
	if (LuaFnDelAvailableItem(sceneId, selfId, nNeedItem, 1) ~= 1)  then
		DarkOperateResult(sceneId, selfId, 6, -2);
		return
	end
	
	local nSucc = ResetDarkForBagItem(sceneId, selfId, bagpos);
	if nSucc ~= 1 then
		--失败了，通知客户端
		DarkOperateResult(sceneId, selfId, 6, -1);
	else
		--成功了，通知客户端
		DarkOperateResult(sceneId, selfId, 6, 1);
		x332207_SendImpact(sceneId, selfId, 3);
	end
end

function x332207_DarkResetQualityForBagItem( sceneId, selfId, bagpos, resettype)
--有这个物品吗
	local nNeedItem = x332207_DarkItem_ResetQuality.type1;
	if(resettype == 2) then
		nNeedItem = x332207_DarkItem_ResetQuality.type2;
	end
		 
	local bHave = LuaFnGetAvailableItemCount(sceneId, selfId, nNeedItem);
	if(bHave < 1) then
		if(resettype == 2) then
			DarkOperateResult(sceneId, selfId, 2, -3);
		else
			DarkOperateResult(sceneId, selfId, 2, -2);		
		end
		return
	end
	
    local bMoneyEnough = x332207_HaveEnoughMoney(sceneId, selfId, 2, 10000);
	if ( 1 ~= bMoneyEnough ) then
	    return
	end
	local bCostMoney = x332207_CostMoney(sceneId, selfId, 2, 10000);
	if ( 1 ~= bCostMoney ) then
	    return
	end
	
	--扣除成功
	if (LuaFnDelAvailableItem(sceneId, selfId, nNeedItem, 1) ~= 1)  then
		DarkOperateResult(sceneId, selfId, 2, -2);
		return
	end
	
	local nSucc = ResetDarkQualityForBagItem(sceneId, selfId, bagpos, resettype);
	if nSucc ~= 1 then
		--失败了，通知客户端
		DarkOperateResult(sceneId, selfId, 2, -1);
	else
		--成功了，通知客户端
		DarkOperateResult(sceneId, selfId, 2, 1);
		x332207_SendImpact(sceneId, selfId, 3);
	end
end

function x332207_CalcDarkMultiExpRate(sceneId, selfId)
	local fRate = 1.0;
	for i = 1, getn(x332207_DarkItem_DoubleExp) do
		local nRet = LuaFnHaveImpactOfSpecificDataIndex(sceneId, selfId, x332207_DarkItem_DoubleExp[i].ImpactId)
		if nRet == 1 then
			fRate = x332207_DarkItem_DoubleExp[i].GiveExp;
			break;
		end
	end
	
	SetDarkGainExpRate(sceneId, selfId, fRate);
end


function x332207_SendImpact(sceneId, playerId, ntype)

	LuaFnSendSpecificImpactToUnit(sceneId, playerId, playerId, playerId, 18, 0 )   --与珍兽悟性提升的特效一致
	
end


function x332207_NotifyMailOnLogin(sceneId, selfId)

	if ( GetLevel(sceneId, selfId) >= 30 ) then
		local flag = GetMissionFlag(sceneId, selfId, MF_DARK_NOTIFYMAIL)
		if (flag == 0) then
			LuaFnSendSystemMail( sceneId, GetName( sceneId, selfId ), "#{FBSJ_090311_09}" )
			SetMissionFlag(sceneId, selfId, MF_DARK_NOTIFYMAIL, 1)
		end
	end
	
end

function x332207_HaveEnoughMoney(sceneId, selfId, nType, nMoney)
   	--判断玩家身上是否有足够的钱
	local nHaveMoney = GetMoney(sceneId, selfId) + GetMoneyJZ(sceneId, selfId);
	if (nHaveMoney >= nMoney) then
	    return 1;
	else
        DarkOperateResult(sceneId, selfId, nType, -4);
	    return 0;
	end
end

function x332207_CostMoney(sceneId, selfId, nType, nMoney)
   	--扣钱
	local nRet, nRetJB = LuaFnCostMoneyWithPriority(sceneId, selfId,nMoney);
	if (nRet == -1) then
        DarkOperateResult(sceneId, selfId, nType, -4);
	    return 0;
	else
		return 1;
	end
end
