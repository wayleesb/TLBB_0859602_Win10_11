--随身元宝 NPC
--注意本脚本含有随身元宝相关功能，请一定参照现有的例子进行修改。

x181003_g_scriptId 	= 181003
x181003_g_buyrate 	= 0.5

x181003_g_shoptableindex=120
x181003_g_zengdianshop=121

x181003_g_goodact		= 1		--元宝商店
x181003_g_buyact	 	= 2		--兑换元宝
x181003_g_ticketact = 3		--兑换元宝票
x181003_g_zdianact	= 4		--赠点商店
x181003_g_gotodali	= 5		--返回洛阳

x181003_g_normalzdianshop	= 6		--普通增点商店
x181003_g_lv1zdianshop	= 7			--一级材料
x181003_g_lv2zdianshop	= 8			--二级材料
x181003_g_lv3zdianshop	= 9			--三级材料
x181003_g_lv4zdianshop	= 10		--四级材料
x181003_g_lv5zdianshop	= 11		--五级材料
x181003_g_lv6zdianshop	= 12		--六级材料
x181003_g_lv7zdianshop	= 13		--七级材料
x181003_g_lv8zdianshop	= 14		--八级材料
x181003_g_lv9zdianshop	= 15		--九级材料
x181003_g_lv10zdianshop	= 16		--十级材料
x181003_g_newprize	= 17		--查看中奖
x181003_g_YuanBaoIntro	= 18	--元宝介绍

x181003_g_leave			= 20	--离开
x181003_g_return		= 21	--返回(主菜单)
x181003_g_return1		= 22	--返回(元宝商店)
x181003_g_DZYBact		= 23	--打造图元宝商店

--元宝商店	-modify by xindefeng
x181003_g_YBShop		=
{
	--索引（顺序递增 1-N），name = 商店名称，id = 商店ID，key = GetNumText（顺序递增 101-N）
	[1]	= { name = "#gff00f0热卖商店", id = 151, key = 101 },
	[2]	= { name = "#c6de4fe天龙宠物馆", id = -1, key = 102 },
	[3]	= { name = "天宫御马监", id = 134, key = 103 },	
	[4]	= { name = "#c6de4fe天龙形象馆", id = -1, key = 104 },
	[5]	= { name = "浏阳花炮店", id = 132, key = 105 },
	[6]	= { name = "春城百花宫", id = 133, key = 106 },	
	[7]	= { name = "扁鹊灵药店", id = 136, key = 107 },
	[8]	= { name = "#gff00f0桃堡奇物店", id = 137, key = 108 },	
	[9] = { name = "#c6de4fe天龙宝石斋", id = -1, key = 109 },	
	[10]	= { name = "还施水阁", id = 146, key = 110 },
	[11]	= { name = "三清神符观", id = 144, key = 111 }
}

--元宝珍兽店--add by xindefeng
x181003_g_YBPetShops =
{
	[1]	= { name = "霏霏珍兽馆", id = 152, key = 112 },
	[2]	= { name = "飘飘珍兽馆", id = 135, key = 113 }
}

--元宝形象店--add by xindefeng
x181003_g_YBXingXiangShops =
{
	[1]	= { name = "米兰时装店", id = 120, key = 114 },
	[2] = { name = "如意变身斋", id = 181, key = 115 },
	[3] = { name = "天扬发艺馆", id = 145, key = 116 },
	[4] = { name = "兰雨美容坊", id = 182, key = 117 }	--add by zchw
}

--元宝宝石店--add by xindefeng
x181003_g_YBBaoshiShops =
{
	[1]	= { name = "大理宝石斋", id = 149, key = 118 },
	[2]	= { name = "苏州宝石斋", id = 150, key = 119 },
	[3]	= { name = "洛阳宝石斋", id = 178, key = 120 },
	[4]	= { name = "#gff00f0宝石精华店", id = 198, key = 132 }   -- added by houzhifang in 20081107 tt:40793; 120--131被用过了
}

--打造图商店
x181003_g_DZYBShop	=
{
	--索引（顺序递增 1-N），name = 商店名称，id = 商店ID，key = GetNumText（顺序递增 201-N）
	[1]	= { name = "刀斧和枪棒打造图", id = 156, key = 201 },
	[2]	= { name = "单短和双短打造图", id = 157, key = 202 },
	[3]	= { name = "扇和环打造图", id = 158, key = 203 },
	[4]	= { name = "帽子和衣服打造图", id = 159, key = 204 },
	[5]	= { name = "手套和鞋子打造图", id = 160, key = 205 },
	[6]	= { name = "护腕和护肩打造图", id = 161, key = 206 },
	[7]	= { name = "腰带打造图", id = 162, key = 207 },
	[8]= { name = "项链打造图", id = 163, key = 208 },
	[9]	= { name = "戒指打造图", id = 164, key = 209 },
	[10]	= { name = "护符打造图", id = 165, key = 210 },
}

--浏阳花炮店
x181003_g_YBHuaPaoShops =
{
	[1]	= { name = "火树银花", id = 190, key = 300 },
	[2]	= { name = "节日喜庆", id = 191, key = 301 },
	[3]	= { name = "倾城之姿", id = 192, key = 302 },
}

--桃堡奇物店
x181003_g_YBQiWuShops =
{
	[1]	= { name = "玲珑石头记", id = 193, key = 303 },
	[2]	= { name = "异兽加工坊", id = 194, key = 304 },
	[3]	= { name = "南北杂货店", id = 195, key = 305 },
	[4]	= { name = "原桃堡奇物店", id = 137, key = 306 },
}

--热卖商店
x181003_g_YBReMaiShops =
{
	[1]	= { name = "新品上架", id = 188, key = 307 },
	[2] = { name = "人气商品", id = 189, key = 309 },
}

--**********************************
--事件交互入口
--**********************************
function x181003_OnDefaultEvent( sceneId, selfId, targetId )
	if targetId == -1 then
		x181003_OnEventRequest( sceneId, selfId, targetId, nil )
	else
		BeginEvent( sceneId )
--			local strText = "    有钱能使鬼推磨，虽然江湖当中以武力为上，但是有了元宝可能会使原来很多比较难办的事情变得简单起来，您想做些什么呢？"
--			AddText( sceneId, strText )
--			AddNumText( sceneId, x181003_g_scriptId, "我想购买商品", 2, x181003_g_goodact)
--			if targetId >= 0 then
--				AddNumText( sceneId, x181003_g_scriptId, "我想兑换元宝", 2, x181003_g_buyact)
--				if IsShutout( sceneId, selfId, ONOFF_T_YBCASH ) == 0 then
--					AddNumText( sceneId, x181003_g_scriptId, "我想兑换元宝票", 2, x181003_g_ticketact)
--				end
--			else
--				targetId = -1	--为了能正常弹出选项
--			end
			for i = 1, getn( x181003_g_YBShop ) do
				AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBShop[i].name, 7, x181003_g_YBShop[i].key )
			end
			AddNumText(sceneId,x181003_g_scriptId, "打造图专卖", 7, x181003_g_DZYBact)
			AddNumText( sceneId, x181003_g_scriptId, "元宝和赠点商店介绍", 11, x181003_g_YuanBaoIntro)
			if targetId < 0 then
				targetId = -1
			end
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	end
end

--**********************************
--事件列表选中一项
--**********************************
function x181003_OnEventRequest( sceneId, selfId, targetId, eventId )
	if GetNumText() == x181003_g_buyact then
		--先询问自己的剩余点数
		CallScriptFunction( PRIZE_SCRIPT_ID, "AskPoint", sceneId, selfId )
		
		BeginUICommand( sceneId )
			UICommand_AddInt( sceneId, targetId )
			UICommand_AddInt( sceneId, x181003_g_buyrate*1000)
		EndUICommand( sceneId )
		DispatchUICommand( sceneId, selfId, 2001 )
	elseif GetNumText() == x181003_g_newprize then
		CallScriptFunction( PRIZE_SCRIPT_ID, "AskPrize", sceneId, selfId)
	elseif GetNumText() == x181003_g_return then
		local nID = targetId;
		if nID < 0 then nID = -2 end -- -2是菜单，-1是响应
		x181003_OnDefaultEvent( sceneId, selfId, nID )
	elseif GetNumText() == x181003_g_goodact or GetNumText() == x181003_g_return1 then
--		BeginEvent( sceneId )
--			for i = 1, getn( x181003_g_YBShop ) do
--				AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBShop[i].name, 7, x181003_g_YBShop[i].key )
--			end
--			AddNumText(sceneId,x181003_g_scriptId, "打造图专卖", 7, x181003_g_DZYBact)
--			AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return)
--		EndEvent( sceneId )
--		DispatchEventList( sceneId, selfId, targetId )
		local nID = targetId;
		if nID < 0 then nID = -2 end -- -2是菜单，-1是响应
		x181003_OnDefaultEvent( sceneId, selfId, nID )
	elseif GetNumText() == x181003_g_DZYBact then
		BeginEvent( sceneId )
			local strText = "  请根据需求选择不同的打造图商店："
			AddText( sceneId, strText )
			
			for i = 1, getn( x181003_g_DZYBShop ) do
				AddNumText( sceneId, x181003_g_scriptId, x181003_g_DZYBShop[i].name, 7, x181003_g_DZYBShop[i].key )
			end
			AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == x181003_g_zdianact then
		BeginEvent( sceneId )
			strText = "  请根据需求选择不同的赠点商店："
			AddText( sceneId, strText )
			AddNumText( sceneId, x181003_g_scriptId, "普通赠点商品", 7, x181003_g_normalzdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "一级材料 ", 7, x181003_g_lv1zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "二级材料 ", 7, x181003_g_lv2zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "三级材料 ", 7, x181003_g_lv3zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "四级材料 ", 7, x181003_g_lv4zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "五级材料 ", 7, x181003_g_lv5zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "六级材料 ", 7, x181003_g_lv6zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "七级材料 ", 7, x181003_g_lv7zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "八级材料 ", 7, x181003_g_lv8zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "九级材料 ", 7, x181003_g_lv9zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "十级材料 ", 7, x181003_g_lv10zdianshop)
			AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == x181003_g_gotodali then
		NewWorld(sceneId,selfId,0,200,177)
	elseif GetNumText() == x181003_g_ticketact then
		local nYuanBao = YuanBao(sceneId,selfId,targetId,3,0)
		BeginUICommand( sceneId )
			UICommand_AddInt( sceneId, targetId )
		EndUICommand( sceneId )
		DispatchUICommand( sceneId, selfId, 2002 )
	elseif GetNumText() == x181003_g_leave then
		BeginUICommand( sceneId )
			UICommand_AddInt( sceneId, targetId )
		EndUICommand( sceneId )
		DispatchUICommand( sceneId, selfId, 1000 )
	elseif GetNumText() == x181003_g_normalzdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 121 )
	elseif GetNumText() == x181003_g_lv1zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 122 )
	elseif GetNumText() == x181003_g_lv2zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 123 )
	elseif GetNumText() == x181003_g_lv3zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 124 )
	elseif GetNumText() == x181003_g_lv4zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 125 )
	elseif GetNumText() == x181003_g_lv5zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 126 )
	elseif GetNumText() == x181003_g_lv6zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 127 )
	elseif GetNumText() == x181003_g_lv7zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 128 )
	elseif GetNumText() == x181003_g_lv8zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 129 )
	elseif GetNumText() == x181003_g_lv9zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 130 )
	elseif GetNumText() == x181003_g_lv10zdianshop then
		x181003_NewDispatchShopItem( sceneId, selfId,targetId, 131 )
	elseif GetNumText() == x181003_g_YuanBaoIntro	then
		BeginEvent( sceneId )
			AddText( sceneId, "#{INTRO_YUANBAO}" )
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == 102 then	--天龙珍兽店	--add by xindefeng
		BeginEvent( sceneId )
		for i = 1, getn( x181003_g_YBPetShops ) do
			AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBPetShops[i].name, 7, x181003_g_YBPetShops[i].key )
		end
		AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == 104 then	--天龙形象馆	--add by xindefeng
		BeginEvent( sceneId )
		for i = 1, getn( x181003_g_YBXingXiangShops ) do
			AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBXingXiangShops[i].name, 7, x181003_g_YBXingXiangShops[i].key )
		end
		AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == 109 then	--天龙宝石店--add by xindefeng
		BeginEvent( sceneId )
		for i = 1, getn( x181003_g_YBBaoshiShops ) do
			AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBBaoshiShops[i].name, 7, x181003_g_YBBaoshiShops[i].key )
		end
		AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )		
	elseif GetNumText() == 105 then	--浏阳花炮店
		BeginEvent( sceneId )
		for i = 1, getn( x181003_g_YBHuaPaoShops ) do
			AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBHuaPaoShops[i].name, 7, x181003_g_YBHuaPaoShops[i].key )
		end
		AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == 108 then	--桃堡奇物店
		BeginEvent( sceneId )
		for i = 1, getn( x181003_g_YBQiWuShops ) do
			AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBQiWuShops[i].name, 7, x181003_g_YBQiWuShops[i].key )
		end
		AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	elseif GetNumText() == 101 then	--热卖商店
		BeginEvent( sceneId )
		for i = 1, getn( x181003_g_YBReMaiShops ) do
			AddNumText( sceneId, x181003_g_scriptId, x181003_g_YBReMaiShops[i].name, 7, x181003_g_YBReMaiShops[i].key )
		end
		AddNumText( sceneId, x181003_g_scriptId, "返回上一页", -1, x181003_g_return1)
		EndEvent( sceneId )
		DispatchEventList( sceneId, selfId, targetId )
	else
		--元宝商店
		for i = 1, getn( x181003_g_YBShop ) do
			if (GetNumText() == 102 or GetNumText() == 104 or GetNumText() == 109 or GetNumText() == 105 or GetNumText() == 108 or GetNumText() == 101) then	--商店类型选项--add by xindefeng
				break
			end
			if GetNumText() == x181003_g_YBShop[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBShop[i].id )
				break
			end
		end
		--天龙珍兽店--add by xindefeng
		for i = 1, getn( x181003_g_YBPetShops ) do
			if GetNumText() == x181003_g_YBPetShops[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBPetShops[i].id )
				break
			end
		end
		--天龙形象馆--add by xindefeng
		for i = 1, getn( x181003_g_YBXingXiangShops ) do
			if GetNumText() == x181003_g_YBXingXiangShops[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBXingXiangShops[i].id )
				break
			end
		end
		--宝石商店--add by xindefeng
		for i = 1, getn( x181003_g_YBBaoshiShops ) do
			if GetNumText() == x181003_g_YBBaoshiShops[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBBaoshiShops[i].id )
				break
			end
		end
		--打造图专卖
		for i = 1, getn( x181003_g_DZYBShop ) do
			if GetNumText() == x181003_g_DZYBShop[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_DZYBShop[i].id )
				break
			end
		end
		--浏阳花炮店
		for i = 1, getn( x181003_g_YBHuaPaoShops ) do
			if GetNumText() == x181003_g_YBHuaPaoShops[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBHuaPaoShops[i].id )
				break
			end
		end
		--桃堡奇物店
		for i = 1, getn( x181003_g_YBQiWuShops ) do
			if GetNumText() == x181003_g_YBQiWuShops[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBQiWuShops[i].id )
				break
			end
		end
		--热卖商店
		for i = 1, getn( x181003_g_YBReMaiShops ) do
			if GetNumText() == x181003_g_YBReMaiShops[i].key then
				x181003_NewDispatchShopItem( sceneId, selfId, targetId, x181003_g_YBReMaiShops[i].id )
				break
			end
		end
	end
end

--**********************************
--客户端购买元宝接口
--**********************************
function x181003_BuyYuanbao( sceneId, selfId, nYuanBao )
	--购买元宝
	if nYuanBao then
		if nYuanBao > 0 and nYuanBao <= 10000 then
			CallScriptFunction( PRIZE_SCRIPT_ID, "AskYuanBao", sceneId, selfId, nYuanBao, nYuanBao*x181003_g_buyrate*1000)
		end
	end
end

--**********************************
--按需来弹出商店，分为随身商店和NPC商店
--**********************************
function x181003_NewDispatchShopItem(sceneId,selfId,targetId,shopId)
	if targetId >= 0 then	
		DispatchShopItem( sceneId, selfId,targetId, shopId )
	else
		DispatchNoNpcShopItem( sceneId, selfId, shopId )
	end
end
