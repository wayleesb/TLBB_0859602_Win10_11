g_InitiativeClose = 0;
local g_currentList = 0;
local g_currentIndex = 0;
-- 摆摊地租提示窗口，在这里有发送给服务器的确定开始摆摊的消息
local Recycle_Type = -1;
local Recycle_CurSelectItem = -1
local g_FrameInfo = -1;
local FrameInfoList = {
	STALL_RENT_FRAME			= 1,
	DISCARD_ITEM_FRAME			= 2,
	CANNT_DISCARD_ITEM			= 3,
	TEAM_ASKJOIN				= 4,	--有人邀请你加入队伍
    TEAM_MEMBERINVERT			= 5,	--队员邀请某人加入队伍请求你同意
    TEAM_SOMEASK				= 6,	--某人申请加入队伍
    TEAM_FOLLOW		 			= 7,	--进入组队跟随模式
    FRAME_AFFIRM_SHOW 			= 8,	--进入放弃任务确认模式
    GUILD_CREATE_CONFIRM		= 9, 	--帮会创建确认模式
    SYSTEM_TIP_INFO 			= 10,	--系统提示对话框模式
    GUILD_QUIT_CONFIRM 			= 11,	--帮会退出确认模式
    GUILD_DESTORY_CONFIRM		= 12,	--帮会删除确认模式
    CALL_OF						= 13,	--拉人
    NET_CLOSE_MESSAGE			= 14,	--断开网络
    PET_FREE_CONFIRM			= 15,	--珍兽放生确认
    CITY_CONFIRM				= 16,	--城市相关确认
    SAVE_STALL_INFO				= 17,	--保存摆摊信息
    PET_SYNC_CONFIRM			= 18,	--珍兽繁殖确认
    QUIT_GAME					= 19,	--退出游戏的确认
    EQUIP_ITEM					= 20,	--装备物品
    YUANBAO_BUY_ITEM		= 21, --元宝商店购买物品确认
    CONFIRM_REMOVE_STALL	= 22,--确认撤滩 add by zchw
    PET_PROCREATE_PROMPT			= 23, -- 珍兽繁殖提示 zchw

	--这个24一定不能改，改了出错的！！！！！Chris
	SERVER_CONTROL				= 24,	--Server控制弹出的提示框
	DELETE_FRIEND_MESSAGE		= 25,	--确定删除好友的提示框

    GEM_COMBINED_CONFIRM		= 88,	-- 确认宝石合成
   	ENCHASE_CONFIRM					= 99,	-- 确认镶嵌
   	ENCHASE_FOUR_CONFIRM		= 100,	-- add:lby20080527确认4镶嵌  
   	 	
   	--CARVE_CONFIRM				= 102,	-- 确认雕琢



    PS_RENAME_MESSAGE			= 116,	--更改玩家商店店名
    PS_READ_MESSAGE				= 117,	--更改玩家商店介绍（广告）
    PS_ADD_BASE_MONEY			= 118,	--充入本金
    PS_ADD_GAIN_MONEY			= 119,	--充入盈利金
    PS_DEC_GAIN_MONEY			= 120,	--取出盈利金
    PS_ADD_STALL				= 121,	--增加柜台
    PS_DEL_STALL				= 122,	--减少柜台
    PS_INFO_PANCHU				= 123,	--商店盘出
    PS_INFO_PANRU				= 124,	--商店盘入
    PS_INFO_MODIFY_TYPE			= 125,	--更改商店类型
    FREEFORALL					= 201,	--FREEFORALL: 个人混战
    FREEFORTEAM					= 202,	--FREEFORTEAM： 组队混战
    FREEFORGUILD				= 203,	-- FREEFORGUILD：帮派混战
    MAKESUREPVPCHALLENGE		= 204,
    EXCHANGE_MONEY_OVERFLOW			= 205, --交易后增加玩家是否到达钱上限的判定

    GUILD_DEMIS_CONFIRM		= 206, 			--禅让确认

    CHANGEPROTECTTIME		= 207, 				--安全时间
    COMMISION_BUY = 208, 							--寄售商店购买确认

    Player_Give_Rose		= 209,
    RECYCLE_DEL_ITEM		=210, 				--取消收购确认

    OPEN_IS_SELL_TO_RECSHOP	= 211, 		--出售物品确认

    CONFIRM_STENGTH = 212,

    CHAR_RANAME_CONFIRM = 213,

    CITY_RANAME_CONFIRM = 214,

    CONFIRM_RE_IDENTIFY = 215,

    KICK_MEMBER_MSGBOX = 216,
    
		SAFEBOX_LOCK_CONFIRM = 217,						--保险箱锁定确认框
		SAFEBOX_UNLOCK_CONFIRM = 218,					--保险箱解锁确认框
		
		LOCK_ITEM_CONFIRM_FRAME = 219,        --	加锁确认
    GUILD_LEAGUE_QUIT_CONFIRM = 220,			--	退出帮会同盟确认
    GUILD_LEAGUE_CREATE_CONFIRM = 221,		--	创建帮会同盟确认
		PET_SKILL_STUDY_CONFIRM = 222,				--	宠物学习技能确认
		EXCHANGE_BANGGONG = 223,							--	兑换帮贡牌确认
		PUT_GUILDMONEY = 224,									--	帮会资金捐助
		TLZ_CONFIRM_SETPOS = 225,							--	确认土灵珠重新定位

		DISMISS_TEAM = 226,										--	解散队伍						WTT		20090212
		DART_ADJUST = 227	-- 暗器属性调整   Vega 20090422
};

local PVPFLAG = { FREEFORALL = 201, FREEFORTEAM = 202, FREEFORGUILD = 203, MAKESUREPVPCHALLENGE = 204, ACCEPTDUEL = 205, DuelGUID = 0, DuelName = "" }
--FREEFORALL: 个人混战 FREEFORTEAM： 组队混战 FREEFORGUILD：帮派混战

--
local g_szData;
local g_nData;
local g_nData1
--

local Quest_Number;
local Pet_Number;
local Server_Script_Function = "";
local Server_Script_ID = "";
local Server_Return_1 = 0;
local Server_Return_2 = 0;
local Server_Return_3 = 0;

local g_CityData = {};						--由于upvalue的限制，城市和珍兽合成共用这个数据区

local strMessageString = "";		--对话框字符
local strMessageData   = 0;			--对话框类型，用于提示什么得对话框
local strMessageArgs = 0;				--按钮参数
local strMessageType = "Normal";--按钮风格
local strMessageArgs_2 = 0			--按钮参数2

local GemCombinedData = {}

local EnchaseData = {}

local SplitData = {}

local CarveData = {}

local CommisionBuyData = {}  --寄售商店购买确认框的数据

local MAX_OBJ_DISTANCE = 3.0;

local Client_ItemIndex = -1

local Dart_Data = {}			--暗器数据

function CancelLastOp(str)
	if(this:IsVisible() and str ~= g_FrameInfo) then
		MessageBox_Self_Cancel_Clicked(0);
	end
end
--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_PreLoad()
	--this:RegisterEvent("MSGBOX_ACCEPTDUEL");
	this:RegisterEvent("MSGBOX_MAKESUREPVPCHALLENGE");
    this:RegisterEvent("MENU_SHOWACCEPTCHANGEPVP");
	this:RegisterEvent("OPEN_STALL_RENT_FRAME");
	this:RegisterEvent("OPEN_DISCARD_ITEM_FRAME");
	this:RegisterEvent("OPEN_CANNT_DISCARD_ITEM");
	this:RegisterEvent("AFFIRM_SHOW");
	this:RegisterEvent("NET_CLOSE");
	this:RegisterEvent("DELETE_FRIEND");
	this:RegisterEvent("TIME_UPDATE");
	this:RegisterEvent("PET_PROCREATE_PROMPT"); -- zchw pet procreate

	-- zchw fix Transfer bug
	this:RegisterEvent("OBJECT_CARED_EVENT");
	---- 有人邀请你加入队伍
	--this:RegisterEvent("SHOW_TEAM_YES_NO");
	---- 队员邀请某人加入队伍请你同意.
	--this:RegisterEvent("TEAM_MEMBER_INVITE");
	---- 某人申请加入队伍.
	--this:RegisterEvent("TEAM_APPLY");
	---- 队长邀请进入组队跟随模式
	--this:RegisterEvent("TEAM_FOLLOW_INVITE");

	-- 创建帮会确认
	this:RegisterEvent("GUILD_CREATE_CONFIRM");
	-- 删除帮会确认
	this:RegisterEvent("GUILD_DESTORY_CONFIRM");
	-- 退出帮会确认
	this:RegisterEvent("GUILD_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_QUIT_CONFIRM");
	this:RegisterEvent("GUILD_LEAGUE_CREATE_CONFIRM");

	this:RegisterEvent("PET_FREE_CONFIRM");

	this:RegisterEvent("OPEN_PS_MESSAGE_FRAME");

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("CITY_CONFIRM");
	--add by zchw
	this:RegisterEvent("OPEN_REMOVE_STALL");
	this:RegisterEvent("OPEN_SAVE_STALL_INFO");

	this:RegisterEvent("PET_SYNC_CONFIRM");
	this:RegisterEvent("QUEST_QUIT_GAME");

	this:RegisterEvent( "MESSAGE_BOX" );

	this:RegisterEvent( "GEM_COMBINED_CONFIRM" );
	this:RegisterEvent( "ENCHASE_CONFIRM" );  
	this:RegisterEvent( "ENCHASE_FOUR_CONFIRM" );-- add:lby20080527确认4镶嵌
	
	--this:RegisterEvent( "CARVE_CONFIRM" );
	this:RegisterEvent( "EXCHANGE_MONEY_OVERFLOW" );
	this:RegisterEvent( "GUILD_DEMIS_CONFIRM" );
	this:RegisterEvent("YUANBAO_BUY_ITEM_CONFIRM");

	this:RegisterEvent("CHANGEPROTECTTIME");
	
	this:RegisterEvent("CONFIRM_COMMISION_BUY"); --寄售商店购买确认

	this:RegisterEvent("PLAYER_GIVE_ROSE");

	this:RegisterEvent( "RECYCLE_DEL_ITEM" );

	this:RegisterEvent( "OPEN_IS_SELL_TO_RECSHOP" );

	this:RegisterEvent( "CLOSE_PS_CHANGETYPE_MSG" );

	this:RegisterEvent( "CONFIRM_STENGTH" );

	this:RegisterEvent( "EXCHANGE_BANGGONG" );
		
	this:RegisterEvent( "PUT_GUILDMONEY" );

	this:RegisterEvent( "CLOSE_STRENGTH_MSGBOX" );

	this:RegisterEvent( "CLOSE_RECYCLESHOP_MSG" );

	this:RegisterEvent( "ENCHASE_CLOSE_MSGBOX" );
	
	this:RegisterEvent( "CITY_RANAME_CONFIRM" );

	this:RegisterEvent( "CHAR_RANAME_CONFIRM" );	

	--当logon打开的时候，关闭所有MessageBox
	this:RegisterEvent( "GAMELOGIN_OPEN_COUNT_INPUT" );

	this:RegisterEvent( "CONFIRM_RE_IDENTIFY" );

	this:RegisterEvent( "CLOSE_RE_IDENTIFY_MSGBOX" );
	
	this:RegisterEvent( "KICK_MEMBER_MSGBOX" );
	
	this:RegisterEvent( "CLOSE_KICK_MEMBER_MSGBOX" );
	
	--保险箱锁定确认框
	this:RegisterEvent( "SAFEBOX_LOCK_CONFIRM" );

	--保险箱解锁确认框
	this:RegisterEvent( "SAFEBOX_UNLOCK_CONFIRM" );
	
	this:RegisterEvent( "CLOSE_SAFEBOX_CONFIRM" );
	
	--加锁确认
	this:RegisterEvent( "LOCK_ITEM_CONFIRM" );
	this:RegisterEvent( "OPEN_PETSKILLSTUDY_MSGBOX" );
	this:RegisterEvent( "CLOSE_PETSKILLSTUDY_MSGBOX" );
	--土灵珠定位确认
	this:RegisterEvent( "CONFIRM_SETPOS_TLZ" );
	
	-- 弹出解散队伍的二次确认窗口			add by WTT	20090212
	this:RegisterEvent( "OPNE_DISMISS_TEAM_MSGBOX" );

	this:RegisterEvent("PACKAGE_ITEM_CHANGED");

end

--===============================================
-- OnLoad()
--===============================================
function MessageBox_Self_OnLoad()

end

function  MessageBox_Self_UpdateRect()

	local nWidth, nHeight = MessageBox_Self_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBox_Self_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end
--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEventEx(event)

	local objCaredID = -1; -- zchw fix Transfer bug
	if(event == "QUEST_QUIT_GAME") then
		this:Show();
		g_FrameInfo = FrameInfoList.QUIT_GAME;
	-- add by zchw
	elseif event == "OPEN_REMOVE_STALL" then
		CancelLastOp(FrameInfoList.CONFIRM_REMOVE_STALL);
		g_FrameInfo = FrameInfoList.CONFIRM_REMOVE_STALL;
	-- zchw for pet procreate
	elseif event == "PET_PROCREATE_PROMPT" then
		CancelLastOp(FrameInfoList.PET_PROCREATE_PROMPT);
		g_FrameInfo = FrameInfoList.PET_PROCREATE_PROMPT;
	elseif event == "OPEN_SAVE_STALL_INFO"    then
		CancelLastOp(FrameInfoList.SAVE_STALL_INFO);
		g_FrameInfo = FrameInfoList.SAVE_STALL_INFO;
	elseif event == "YUANBAO_BUY_ITEM_CONFIRM" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM and this:IsVisible())then
			--如果是关于购物弹出的窗口，才关闭
				g_CityData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			g_CityData = {};
			g_CityData[1] = tonumber(arg2);	--在货架的位置
			g_CityData[2] = tonumber(arg3);	--在商店的售价
			g_CityData[3] = arg1;	--货物名称
			CancelLastOp(FrameInfoList.YUANBAO_BUY_ITEM);
			g_FrameInfo = FrameInfoList.YUANBAO_BUY_ITEM;
		end
	elseif( event == "PET_SYNC_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		CancelLastOp(FrameInfoList.PET_SYNC_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SYNC_CONFIRM;
	--寄售商店购买确认消息
	elseif event == "CONFIRM_COMMISION_BUY" then
		if(arg0 == "close") then
			if(g_FrameInfo == FrameInfoList.COMMISION_BUY and this:IsVisible())then
			--如果是寄售商店确认框，才关闭
				CommisionBuyData = {};
				this:Hide();
			end
			return -1;
		elseif(arg0 == "open") then
			CommisionBuyData = {};
			CommisionBuyData[1] = arg1;	--物品名称
			CommisionBuyData[2] = arg2;	--价格
			CancelLastOp(FrameInfoList.COMMISION_BUY);
			g_FrameInfo = FrameInfoList.COMMISION_BUY;
		end
	elseif event == "TIME_UPDATE" then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.STALL_RENT_FRAME ) then
			local xNow, yNow;
			xNow, yNow = Player:GetPos();
			
			local askPosX = Variable:GetVariable("AskBaiTanPosX");
			local askPosY = Variable:GetVariable("AskBaiTanPosY");
			
			if(tostring(xNow) ~= askPosX or tostring(yNow) ~= askPosY) then
				MessageBox_Self_Cancel_Clicked(1);
			end
		end

		return -1;
	end
	if g_FrameInfo == FrameInfoList.QUIT_GAME   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "您确定要离开天龙八部游戏世界吗？";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "RECYCLE_DEL_ITEM" ) then
		Recycle_Type = tonumber(arg0);
		Recycle_CurSelectItem = tonumber(arg1);
		CancelLastOp(FrameInfoList.RECYCLE_DEL_ITEM);
		g_FrameInfo = FrameInfoList.RECYCLE_DEL_ITEM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "您确定要取消此次收购吗？";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "OPEN_IS_SELL_TO_RECSHOP" ) then
		Recycle_Bag_idx = tonumber(arg0);
		Recycle_Shop_idx = tonumber(arg1);
		Recycle_Shop_Num =  tonumber(arg2);
		Recycle_Shop_AllPrice =  tonumber(arg3);
		CancelLastOp(FrameInfoList.OPEN_IS_SELL_TO_RECSHOP);
		g_FrameInfo = FrameInfoList.OPEN_IS_SELL_TO_RECSHOP;
		local name = PlayerShop:GetRecycleItem(Recycle_Shop_idx,3,"name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#W您要出售的材料为#G"..name.."#W，数量为"..Recycle_Shop_Num.."#W,所获金钱为#Y#{_MONEY"..Recycle_Shop_AllPrice.."}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	if ( event == "CONFIRM_STENGTH" ) then
		Stength_Equip_Idx = tonumber(arg0);
		Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_STENGTH);
		g_FrameInfo = FrameInfoList.CONFIRM_STENGTH;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "强化时将优先扣除物品栏已绑定的强化精华，强化后的装备也将与您绑定，确定要继续强化吗？#r提示：如果不想将强化后的装备绑定，请将背包中已绑定的强化精华放入仓库再来强化。";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	
	if ( event == "EXCHANGE_BANGGONG" ) then
		BangGong_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --这里不需要在使用GetNPCIDByServerID了
		if ObjCaredID ~= -1 then
			--开始关心NPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local extravalue = math.floor(BangGong_Value*0.1)
		CancelLastOp(FrameInfoList.EXCHANGE_BANGGONG);
		g_FrameInfo = FrameInfoList.EXCHANGE_BANGGONG;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BGCH_8922_28}"..BangGong_Value.."#{BGCH_8922_29}"..extravalue.."#{BGCH_8922_30}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
	
	if ( event == "PUT_GUILDMONEY" ) then
		GuildMoney_Value = tonumber(arg0);
		ObjCaredID = tonumber(arg1); --这里不需要在使用GetNPCIDByServerID了
		if ObjCaredID ~= -1 then
		--开始关心NPC
			this:CareObject(ObjCaredID, 1, "MsgBox");
		end
		local value = math.floor(GuildMoney_Value*0.9)
		CancelLastOp(FrameInfoList.PUT_GUILDMONEY);
		g_FrameInfo = FrameInfoList.PUT_GUILDMONEY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "#{BPZJ_0801014_008}#{_EXCHG"..GuildMoney_Value.."}#{BPZJ_0801014_009}#{_EXCHG"..value.."}#{BPZJ_0801014_013}";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "CONFIRM_RE_IDENTIFY" ) then
		RID_Equip_Idx = tonumber(arg0);
		--Stength_Item_Idx = tonumber(arg1);
		CancelLastOp(FrameInfoList.CONFIRM_RE_IDENTIFY);
		g_FrameInfo = FrameInfoList.CONFIRM_RE_IDENTIFY;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "重新鉴定装备资质时将优先扣除物品栏中已绑定的金刚砂或金刚锉，重新鉴定资质后的装备也将与您绑定，确定要继续鉴定吗？#r#G提示：如果不想鉴定后的装备绑定，请将背包中已绑定的金刚砂和金刚锉放入仓库再来鉴定。#W";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	if ( event == "KICK_MEMBER_MSGBOX" ) then
		Member_Idx = tonumber(arg0);
		Member_Name = arg1;
		CancelLastOp(FrameInfoList.KICK_MEMBER_MSGBOX);
		g_FrameInfo = FrameInfoList.KICK_MEMBER_MSGBOX;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0");
		local msg = "你确定要将玩家#G"..Member_Name.."#W开除出帮会吗？";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end

	
	return 1;
end

--===============================================
-- OnEvent()
--===============================================
function MessageBox_Self_OnEvent(event)
	if event == "GEM_COMBINED_CONFIRM" then
		
		GemCombinedData[1] = tonumber( arg0 )
		GemCombinedData[2] = tonumber( arg1 )
		GemCombinedData[3] = tonumber( arg2 )
		GemCombinedData[4] = tonumber( arg3 )
		GemCombinedData[5] = tonumber( arg4 )
		GemCombinedData[6] = tonumber( arg5 )
		GemCombinedData[7] = arg6
		CancelLastOp(FrameInfoList.GEM_COMBINED_CONFIRM);
		g_FrameInfo = FrameInfoList.GEM_COMBINED_CONFIRM
		MessageBox_Self_UpdateFrame()
		return
	end

	if event == "EXCHANGE_MONEY_OVERFLOW" then
		MessageBox_Self_Text:SetText( "#Y您的钱已经到达上限，请尽快处理，在此期间不要做#R下线或者转移场景的操作，#Y否则会使得超出上限的金钱消失。" );
		
		MessageBox_Self_UpdateRect();
		CancelLastOp(FrameInfoList.EXCHANGE_MONEY_OVERFLOW);
		g_FrameInfo = FrameInfoList.EXCHANGE_MONEY_OVERFLOW
		
		this:Show();
	end
	if event == "GUILD_DEMIS_CONFIRM" then
		local TargetName = tostring( arg0 );
		MessageBox_Self_Text:SetText( "你确定要将帮主的职位禅让给"..TargetName.."吗？禅后你的职位将为副帮主。" );		
		MessageBox_Self_UpdateRect();	
		CancelLastOp(FrameInfoList.GUILD_DEMIS_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DEMIS_CONFIRM
		this:Show();
	end

	if event == "ENCHASE_CONFIRM" then
		MessageBox_Self_Text:SetText( "没有特殊材料会导致镶嵌失败之后宝石消失。您确定要继续镶嵌吗？" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_CONFIRM
		this:Show();
	end
	
	if event == "ENCHASE_FOUR_CONFIRM" then  -- add:lby20080527确认4镶嵌
		MessageBox_Self_Text:SetText( "没有特殊材料会导致镶嵌失败之后宝石消失。您确定要继续镶嵌吗？" );
		EnchaseData[1] = tonumber( arg0 )
		EnchaseData[2] = tonumber( arg1 )
		EnchaseData[3] = tonumber( arg2 )
		EnchaseData[4] = tonumber( arg3 )
		CancelLastOp(FrameInfoList.ENCHASE_FOUR_CONFIRM);
		g_FrameInfo = FrameInfoList.ENCHASE_FOUR_CONFIRM
		this:Show();
	end

	-- 打开珍兽技能学习的二次确认界面
	if event == "OPEN_PETSKILLSTUDY_MSGBOX" then
		MessageBox_Self_Text:SetText( "你的珍兽即将获得两个手动技能，这个操作需要花费#{_EXCHG990000}，你确定吗？" );
		CancelLastOp(FrameInfoList.PET_SKILL_STUDY_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_SKILL_STUDY_CONFIRM
		this:Show();
	end
	
	-- 关闭珍兽技能学习的二次确认界面
	if(event == "CLOSE_PETSKILLSTUDY_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
	
--	if event == "CARVE_CONFIRM" then
--		MessageBox_Self_Text:SetText( "注意！#您要雕琢的宝石或雕琢符为已绑定物品，雕琢后的宝石也将与您绑定，确认要继续雕琢的话请再次点击雕琢按钮。" );
--		CarveData[1] = tostring( arg0 )
--		CarveData[2] = tonumber( arg1 )
--		CarveData[3] = tonumber( arg2 )
--		CarveData[4] = tonumber( arg3 )
--		CarveData[5] = tonumber( arg4 )
--		CancelLastOp(FrameInfoList.CARVE_CONFIRM);
--		g_FrameInfo = FrameInfoList.CARVE_CONFIRM
--		this:Show();
--	end
	
	if(event == "OPEN_STALL_RENT_FRAME") then
		CancelLastOp(FrameInfoList.STALL_RENT_FRAME);
		--记录当前位置
		local xPos, yPos;
		xPos, yPos = Player:GetPos();
		Variable:SetVariable("AskBaiTanPosX", tostring(xPos), 1);
		Variable:SetVariable("AskBaiTanPosY", tostring(yPos), 1);
		
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.STALL_RENT_FRAME;
		

	elseif ( event == "MSGBOX_MAKESUREPVPCHALLENGE" ) then
	    local TargetName = tostring( arg0 )
	    --AxTrace(0,0,"MSGBOX_MAKESUREPVPCHALLENGE");
		CancelLastOp(FrameInfoList.MAKESUREPVPCHALLENGE);
		g_FrameInfo = FrameInfoList.MAKESUREPVPCHALLENGE;
	    MessageBox_Self_Text:SetText( "您确认向"..TargetName.."提出宣战么？杀死对方之后会增加您的杀气值，杀气高了人物死亡时会导致额外损失" );
		MessageBox_Self_UpdateRect();
		this:Show();

	elseif ( event == "MENU_SHOWACCEPTCHANGEPVP" ) then
		local Mode = tonumber( arg0 )
		local ModeText = ""
		if( 1 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORALL);
		    --AxTrace(0,0,FrameInfoList.FREEFORALL);
		    g_FrameInfo = FrameInfoList.FREEFORALL;
		    ModeText = "此模式下将会攻击除自己之外的所有玩家，请确认开启"
		end
		if( 2 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORTEAM);
		    --AxTrace(0,0,FrameInfoList.FREEFORTEAM);
		    g_FrameInfo = FrameInfoList.FREEFORTEAM;
		    ModeText = "此模式下将会攻击除队友之外的所有玩家，请确认开启"
		end
		if( 3 == Mode ) then
			CancelLastOp(FrameInfoList.FREEFORGUILD)
		    --AxTrace(0,0,FrameInfoList.FREEFORGUILD);
		    g_FrameInfo = FrameInfoList.FREEFORGUILD;
		    ModeText = "#{TM_20080311_18}"
		end
		if( Mode >= 1 and Mode <= 3 ) then
		    MessageBox_Self_Text:SetText( ModeText );
			MessageBox_Self_UpdateRect();
		    this:Show();
		end

	elseif ( event == "MSGBOX_ACCEPTDUEL" ) then
	    local Name = tostring( arg0 )
	    local GUID = tostring( arg1 )
	    PVPFLAG.DuelName = Name
	    PVPFLAG.DuelGUID = GUID
	    g_FrameInfo = PVPFLAG.ACCEPTDUEL;
	    local MsgText = Name.."向您提出决斗，您是否同意？注意：在决斗中死亡将会有惩罚。"
	    MessageBox_Self_Text:SetText( MsgText )
		MessageBox_Self_UpdateRect();
	    this:Show();

	elseif(event == "OPEN_DISCARD_ITEM_FRAME") then
		argDISCARD_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.DISCARD_ITEM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.DISCARD_ITEM_FRAME;

	elseif(event == "OPEN_CANNT_DISCARD_ITEM") then
		argCANNT_DISCARD_ITEM0 = arg0
		CancelLastOp(FrameInfoList.CANNT_DISCARD_ITEM);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.CANNT_DISCARD_ITEM;
		
	elseif(event == "LOCK_ITEM_CONFIRM") then
		argLOCK_ITEM_FRAME0 = arg0;
		CancelLastOp(FrameInfoList.LOCK_ITEM_CONFIRM_FRAME);
		this:Show();
		g_InitiativeClose = 0;
		g_FrameInfo = FrameInfoList.LOCK_ITEM_CONFIRM_FRAME;

	elseif(event == "AFFIRM_SHOW") then
		this:Show();
		g_InitiativeClose = 0;
		Quest_Number = tonumber(arg2);
		argFRAME_AFFIRM_SHOW0 = arg0;
		CancelLastOp(FrameInfoList.FRAME_AFFIRM_SHOW);
		g_FrameInfo = FrameInfoList.FRAME_AFFIRM_SHOW;


	-- 帮会成立需玩家确认
	elseif ( event == "GUILD_CREATE_CONFIRM" ) then
		argCREATE_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_CREATE_CONFIRM;
		MessageBox_Self_Text:SetText("是要创建" .. argCREATE_CONFIRM0 .. "吗?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- 帮会删除需玩家确认
	elseif ( event == "GUILD_DESTORY_CONFIRM" ) then
		argDESTORY_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_DESTORY_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_DESTORY_CONFIRM;
		MessageBox_Self_Text:SetText("是要删除" .. argDESTORY_CONFIRM0 .. "吗?");
		MessageBox_Self_UpdateRect();
		this:Show();

	-- 帮会退出需玩家确认
	elseif ( event == "GUILD_QUIT_CONFIRM" ) then
		argQUIT_CONFIRM0 = arg0
		CancelLastOp(FrameInfoList.GUILD_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_QUIT_CONFIRM;
		MessageBox_Self_Text:SetText("是要退出" .. argQUIT_CONFIRM0 .. "吗?");
		MessageBox_Self_UpdateRect();
		this:Show();
	
	--帮会同盟退出确认
	elseif event == "GUILD_LEAGUE_QUIT_CONFIRM" then
		argQUIT_LEAGUE_CONFIRM0 = arg0;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM
		MessageBox_Self_Text:SetText( "你确定要退出"..argQUIT_LEAGUE_CONFIRM0.."同盟吗？" );		
		MessageBox_Self_UpdateRect();	
		this:Show();
		
	--帮会同盟创建确认
	elseif event == "GUILD_LEAGUE_CREATE_CONFIRM" then
		argCREATE_LEAGUE_CONFIRM0 = arg0;
		argCREATE_LEAGUE_CONFIRM1 = arg1;
		CancelLastOp(FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM);
		g_FrameInfo = FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM
		MessageBox_Self_Text:SetText( "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}" );		
		MessageBox_Self_UpdateRect();	
		this:Show();
		

	-- 服务器断了
	elseif ( event == "NET_CLOSE" ) then
		argNET_CLOSE0 = arg0 
		CancelLastOp(FrameInfoList.NET_CLOSE_MESSAGE);
		g_FrameInfo = FrameInfoList.NET_CLOSE_MESSAGE;
		this:Show();

	elseif ( event == "PET_FREE_CONFIRM") then
		Pet_Number = tonumber(arg0);
		CancelLastOp(FrameInfoList.PET_FREE_CONFIRM);
		g_FrameInfo = FrameInfoList.PET_FREE_CONFIRM;
		this:Show();

	elseif ( event == "OPEN_PS_MESSAGE_FRAME" )  then


		AxTrace(0,0,"arg0 = " .. arg0);


		if( arg0 == "name" )    then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_RENAME_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_RENAME_MESSAGE;

		elseif( arg0 == "ad" )  then
			g_szData = arg1;
			g_nData = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_READ_MESSAGE);
			g_FrameInfo = FrameInfoList.PS_READ_MESSAGE;

		elseif( arg0 == "immitbase" )		then -- 本金
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_BASE_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_BASE_MONEY;

		elseif( arg0 == "immit" )				then -- 盈利金存入
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_ADD_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_ADD_GAIN_MONEY;

		elseif( arg0 == "draw" )				then -- 盈利金取出
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			g_nData1 = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_DEC_GAIN_MONEY);
			g_FrameInfo = FrameInfoList.PS_DEC_GAIN_MONEY;

		elseif( arg0 == "add_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_ADD_STALL);
			g_FrameInfo = FrameInfoList.PS_ADD_STALL;


		elseif( arg0 == "del_stall" )		then --
			g_szData = arg1;
			g_nData  = tonumber(arg2);
			CancelLastOp(FrameInfoList.PS_DEL_STALL);
			g_FrameInfo = FrameInfoList.PS_DEL_STALL;
			

		elseif( arg0 == "sale" )     	then 	-- 盘出
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANCHU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANCHU;
			

		elseif( arg0 == "back" )     	then	-- 取消盘出
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_PANRU);
			g_FrameInfo = FrameInfoList.PS_INFO_PANRU;

		elseif( arg0 == "ps_type" )		then	-- 更改玩家商店的子类提示信息
			g_szData = tonumber(arg2);
			g_nData  = tonumber(arg3);
			CancelLastOp(FrameInfoList.PS_INFO_MODIFY_TYPE);
			g_FrameInfo = FrameInfoList.PS_INFO_MODIFY_TYPE;


		end
	elseif ( event == "UI_COMMAND" ) then
		--AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0))
		if tonumber(arg0) == FrameInfoList.SERVER_CONTROL then
				CancelLastOp(FrameInfoList.SERVER_CONTROL);
				g_FrameInfo = FrameInfoList.SERVER_CONTROL;
				-- zchw fix Transfer bug
				local xx = Get_XParam_INT(1);
				ObjCaredID = DataPool : GetNPCIDByServerID(xx);
				if ObjCaredID ~= -1 then	
					--开始关心NPC
					this:CareObject(ObjCaredID, 1, "MsgBox");
				end
		elseif tonumber(arg0) == 332207 then
			g_FrameInfo = FrameInfoList.DART_ADJUST
			Dart_Data = {}
			Dart_Data[1] = Get_XParam_INT(0)
			Dart_Data[2] = Get_XParam_INT(1)
			MessageBox_Self_ShowDart()
			return
		else
				return;
		end
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if g_FrameInfo == FrameInfoList.DART_ADJUST then
			Dart_Data = {}
			this:Hide()
			return
		else
			return
		end
	-- zchw fix Transfer bug
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= ObjCaredID) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			if ObjCaredID ~= -1 then	
				this:CareObject(ObjCaredID, 0, "MsgBox");
			end
			this:Hide();
		end
	elseif( event == "DELETE_FRIEND" ) then
		g_currentList = tonumber(arg0);
		g_currentIndex = tonumber(arg1);
		CancelLastOp(FrameInfoList.DELETE_FRIEND_MESSAGE);
		g_FrameInfo = FrameInfoList.DELETE_FRIEND_MESSAGE;
	elseif( event == "CITY_CONFIRM" ) then
		g_CityData[1] = tonumber(arg0);
		g_CityData[2] = tonumber(arg1);
		g_CityData[3] = arg2;
		g_CityData[4] = arg3;
		g_CityData[5] = arg4;
		g_CityData[6] = arg5;
		g_CityData[7] = arg6;
		g_CityData[8] = arg7;
		CancelLastOp(FrameInfoList.CITY_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_CONFIRM;
	elseif( event == "MESSAGE_BOX" ) then
		MeesageBox_Init();
		return;
	elseif( event == "CHANGEPROTECTTIME" ) then
		g_ChangeTiemArg0 = tonumber(arg0);
		g_ChangeTiemArg1 = tonumber(arg1);
		CancelLastOp(FrameInfoList.CHANGEPROTECTTIME);
		g_FrameInfo = FrameInfoList.CHANGEPROTECTTIME;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0安全时间");
		if(g_ChangeTiemArg0 == 0)then
			MessageBox_Self_Text:SetText("一旦设置安全时间，下次上线时在安全时间内无法进行很多操作，因此请您合理设置您的安全时间。确定要设置吗？");
		else
			MessageBox_Self_Text:SetText("增加安全时间能使您的账号更安全，但您下次上线时在安全时间内也无法进行很多操作，因此请您合理设置您的安全时间。您确认要继续增加安全时间吗？");
			--帐号  to  账号
		end
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	elseif(event == "PLAYER_GIVE_ROSE")then
		g_RoseArg0 = arg0;
		g_RoseArg1 = arg1;
		g_RoseArg2 = arg2;
		g_RoseArg3 = arg3;
		g_RoseArg4 = arg4;
		if(g_RoseArg0==nil or g_RoseArg1 == nil )then
			return;
		end
		CancelLastOp(FrameInfoList.Player_Give_Rose);
		g_FrameInfo = FrameInfoList.Player_Give_Rose;
		MessageBox_Self_Text:SetText("#cFFF263是否送#c00ff00999朵玫瑰#cFFF263给#c00ff00"..g_RoseArg0.."#cFFF263?");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "CLOSE_PS_CHANGETYPE_MSG" ) then
		if(this:IsVisible() and g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE)then
			this:Hide();
		end
		return;
	end
	if(event == "CLOSE_STRENGTH_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_STENGTH  then 
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.SERVER_CONTROL then
				this:Hide();
			end
		end
		return;
	end
	
	if(event == "CLOSE_RE_IDENTIFY_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY  then 
				this:Hide();
			end
		end
		return;
	end
	
	if(event == "CLOSE_KICK_MEMBER_MSGBOX" ) then
		if(this:IsVisible()) then
			if g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX  then 
				this:Hide();
			end
		end
		return;
	end

	if(event == "CLOSE_SAFEBOX_CONFIRM" ) then
		if(this:IsVisible()) then
			if (g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM or g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM) then 
				this:Hide();
			end
		end
		return;
	end	
	

	if(event == "CLOSE_RECYCLESHOP_MSG" ) then
		if(this:IsVisible()) then
			
			if g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM  then 
				CancelLastOp(-1);
				this:Hide();
			elseif g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP then
				CancelLastOp(-1);
				this:Hide();
			end
		end
		return;
	end

	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
	
	
	
	-- add:lby20080527确认4镶嵌ENCHASE_FOUR_CONFIRM
	if(event == "ENCHASE_CLOSE_MSGBOX" ) then
		if(this:IsVisible() and  g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end

	if(event == "CHAR_RANAME_CONFIRM" ) then
		g_arg_chrc = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0角色改名");
		MessageBox_Self_Text:SetText("注意，您只有一次改名的机会。#r您确认要修改名字为#G"..g_arg_chrc.."#cFFF263么？");	
		CancelLastOp(FrameInfoList.CHAR_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CHAR_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if(event == "CITY_RANAME_CONFIRM" ) then
		g_arg_circ = arg0;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会改名");
		MessageBox_Self_Text:SetText("注意，您只有一次改名的机会。#r您确认要修改帮会名为#G"..g_arg_circ.."#cFFF263么？");	
		CancelLastOp(FrameInfoList.CITY_RANAME_CONFIRM);
		g_FrameInfo = FrameInfoList.CITY_RANAME_CONFIRM
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end

	if(event == "GAMELOGIN_OPEN_COUNT_INPUT") then
		if(this:IsVisible()) then
			CancelLastOp(-1);
			this:Hide();
		end
		return;
	end
		
	if(event == "SAFEBOX_LOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_LOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_LOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0保险箱锁定");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_10}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if(event == "SAFEBOX_UNLOCK_CONFIRM") then
		CancelLastOp(FrameInfoList.SAFEBOX_UNLOCK_CONFIRM);
		g_FrameInfo = FrameInfoList.SAFEBOX_UNLOCK_CONFIRM;
		MessageBox_Self_DragTitle:SetText("#gFF0FA0保险箱解锁");
		MessageBox_Self_Text:SetText("#{YHBXX_20071220_07}");
		MessageBox_Self_UpdateRect();
		this:Show();
		return;
	end
	
	if (event == "CONFIRM_SETPOS_TLZ") then
		CancelLastOp(FrameInfoList.TLZ_CONFIRM_SETPOS);
		g_FrameInfo = FrameInfoList.TLZ_CONFIRM_SETPOS;
		
		local itemIdx = tonumber(arg0)
		local szSceneName = tostring(arg1);
		local iPosX = tonumber(arg2);
		local iPosZ = tonumber(arg3);
		
		Client_ItemIndex = itemIdx
		
		if (szSceneName ~= "") then
			MessageBox_Self_Text:SetText("#{TLZ_081114_1}"..szSceneName.."（"..iPosX.."，"..iPosZ.."）".."#{TLZ_081114_2}")
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			MessageBox_Self_OK_Clicked()
			this:Hide()
			return
		end
		
	end
	
	-- 弹出解散队伍的二次确认窗口			add by WTT	20090212
	if (event == "OPNE_DISMISS_TEAM_MSGBOX")	then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0解散队伍");			-- 设置标题
		MessageBox_Self_Text:SetText( "#{TeamDismiss_090912_1}" );	-- 设置内容
		CancelLastOp(FrameInfoList.DISMISS_TEAM);
		g_FrameInfo = FrameInfoList.DISMISS_TEAM;
		MessageBox_Self_UpdateRect();																-- 恢复窗口大小到初始大小
		this:Show();
		return;
	end

	if(MessageBox_Self_OnEventEx(event) > 0) then
		MessageBox_Self_UpdateFrame();
	end

end

function MeesageBox_Init()
	strMessageString = tostring( arg0 );
	strMessageData	= tostring( arg1 );
	strMessageArgs = tostring(arg2);
	strMessageType	= tostring(arg3);
	strMessageArgs_2 = tostring(arg4)
	CancelLastOp(FrameInfoList.EQUIP_ITEM);
	g_FrameInfo = FrameInfoList.EQUIP_ITEM;
	MessageBox_Update();
end

function MessageBox_Update()
	this:Show();
	MessageBox_Self_OK_Button:Hide();
	MessageBox_Self_Cancel_Button:Hide();
	MessageBox_Self_Text:SetText( strMessageString );
	MessageBox_Self_DragTitle:SetText("#gFF0FA0#gFF0FA0确 认")
	if( strMessageType == "Normal" ) then
		MessageBox_Self_OK_Button:Show();
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "OK" ) then
		MessageBox_Self_OK_Button:Show();
	elseif( strMessageType == "Cancel" ) then
		MessageBox_Self_Cancel_Button:Show();
	elseif( strMessageType == "NoButton" ) then
	elseif( strMessageType == "Hide" ) then
		this:Hide();
	end
	MessageBox_Self_UpdateRect();
end
function MessageBox_Self_City_UpdateFrame()
	--AxTrace(0,0,"MessageBox_Self_City_UpdateFrame:"..tostring(g_CityData[1]));
	--取消当前建设建筑物的确认信息
	if(g_CityData[1] == 0) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0取消当前建设");
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		local szExist = City:GetBuildingInfo(bId, "exist");
		if(tonumber(szExist) > 0) then szExist = "升级"; else szExist = "修建"; end
		local szCurPro = tostring(City:GetCityManageInfo("CurProgress"));
		local szAttr = (City:GetBuildingInfo(bId, "condattrname"));

		local msg = "本帮目前正在"..szExist..szName.."中，已经完成了进度"..szCurPro.."。终止后，";
		msg = msg..szExist.."将失败，所有进度将为0，不退还任何帮资金和"..szAttr.."，你确定要终止当前的";
		msg = msg..szExist.."吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--申请领地确认信息
	elseif(g_CityData[1] == 1) then
		local szPortName = City:GetPortInfo(g_CityData[2], "Name");
		MessageBox_Self_DragTitle:SetText("#gFF0FA0申请领地");
		--你确定要申请所在于AA的“BB”领地吗？这项行为需要消耗1000个金币。
		local msg = "#cFFF263你确定要申请所在于#cFE7E82"..tostring(szPortName).."#cFFF263的#H"..g_CityData[3].."#cFFF263";
		msg = msg.."领地吗？这项行为需要消耗1000#-14或者一块建城令牌。";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--修建或升级建筑物
	elseif(g_CityData[1] == 2 or g_CityData[1] == 3) then
		local szName, bLevel, bId = City:GetCityManageInfo("CurBuilding");
		if(bLevel == -1 or bId == -1) then
			local szExist = "";
			if(g_CityData[1] == 2) then
				MessageBox_Self_DragTitle:SetText("#gFF0FA0建设新建筑");
				szExist = "修建";
			else
				MessageBox_Self_DragTitle:SetText("#gFF0FA0升级建筑");
				szExist = "升级";
			end

			local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
			--建设条件
			local cd = {City:GetBuildingInfo(g_CityData[2], "condition")};
			--0.金钱
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.消耗值
			local szAttr = (City:GetBuildingInfo(g_CityData[2], "condattrname"));
			local szAttrVal = tostring(cd[4]);
			--2.任务数
			local mn = tostring(cd[2]);

			local msg = szExist..szName.."需要帮资金"..money.."，消耗"..szAttr..szAttrVal;
			msg = msg.."点，同时发布任务"..mn.."个，你确定吗?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(0);	--取消当前建筑的确认信息
		end
	--降级或拆毁建筑物
	elseif(g_CityData[1] == 4 or g_CityData[1] == 5) then
		local szExist = "";
		if(g_CityData[1] == 4) then
			MessageBox_Self_DragTitle:SetText("#gFF0FA0降级建筑");
			szExist = "降级";
		else
			MessageBox_Self_DragTitle:SetText("#gFF0FA0拆毁建筑");
			szExist = "拆毁";
		end

		local szName = (City:GetBuildingInfo(g_CityData[2], "name"));
		local szPreAttr = "";
		_,szPreAttr = City:GetBuildingInfo(g_CityData[2], "condattrname");
		local msg = szExist..szName.."将会使建筑功能与作用减少，且不退还任何帮资金与";
		msg = msg..szPreAttr.."，你确定要这样做吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--修改城市反展趋势六率值
	elseif(g_CityData[1] == 6) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改发展方向");
		local msg = "修改发展方向将会消耗帮会资金50#-02，你确定要这样做吗?"
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--取消研究的确认信息
	elseif(g_CityData[1] == 7) then
		local rName, _, rIdx = City:GetResearchInfo("CurResearch");
		local szCurPro = tostring(City:GetResearchInfo("ResearchProcess"));

		MessageBox_Self_DragTitle:SetText("#gFF0FA0终止研究");
		local msg = "本帮目前正在研究"..rName.."中，已经完成了进度"..szCurPro.."。终止后，";
		msg = msg.."研究将失败，所有进度将为0，不退还任何帮资金和属性值，你确定要终止当前的研究吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();		
		this:Show();
	--开始研究的确认信息
	elseif(g_CityData[1] == 8) then
		local rName = City:GetResearchInfo("CurResearch");
		if("" == rName) then
			local bIdx = tonumber(g_CityData[2]);
			local rIdx = tonumber(g_CityData[3]);
			MessageBox_Self_DragTitle:SetText("#gFF0FA0研究配方");
			local szResearchName = City:GetResearchInfo("ResearchName", bIdx, rIdx);
			--建设条件
			local cd = {City:GetResearchInfo("ResearchCondition", bIdx, rIdx)};
			--0.金钱
			local money = cd[1];
			local txt = "";
			if(0 ~= tonumber(money)) then
				txt = txt.."#{_MONEY"..tostring(money).."}";
			else
				txt = txt.."0#-02";
			end
			money = txt;
			--1.所需值
			local szAttr = City:GetResearchInfo("RCAttrName", bIdx, rIdx);
			local szAttrVal = tostring(cd[4]);
			--2.任务数
			local mn = tostring(cd[2]);
			local msg = "研究"..szResearchName.."需要帮资金"..money.."，消耗";
			msg = msg..szAttr..szAttrVal.."，同时发布任务"..mn.."个，你确定吗?";
			MessageBox_Self_Text:SetText(msg);
			MessageBox_Self_UpdateRect();
			this:Show();
		else
			City:DoConfirm(7);	--取消当前研究的确认信息
		end
	--创建商业路线的确认信息
	elseif(g_CityData[1] == 9) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0创建商业路线");
		local msg = "此操作将与编号为"..tostring(g_CityData[2]).."的帮会建立商线，只有双方互建商线，商线才会生效，你确定要建立吗?";
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	--取消商业路线的确认信息
	elseif(g_CityData[1] == 10) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0取消商业路线");
		local dt = {City:GetCityRoadInfo("RoadDetail", g_CityData[2])};
		local msg = "";
		if(dt[4]) then
			msg = "此操作将使本帮与对方帮会的商业行为单方面终止，你确定要继续进行操作吗?";
		else
			msg = "此操作将使本帮与对方帮会不会再有互建商线的可能，你确定要继续进行操作吗?";
		end
		MessageBox_Self_Text:SetText(msg);
		MessageBox_Self_UpdateRect();
		this:Show();
	end
end

function MessageBox_Self_City_OK_Clicked()
	if(g_CityData[1] == 0) then
		local nBuildingId;
		_,_,nBuildingId = City:GetCityManageInfo("CurBuilding");
		City:DoBuilding(nBuildingId, "cancelup");
	elseif(g_CityData[1] == 1) then
		City:CreateCity(g_CityData[2],g_CityData[3]);
	elseif(g_CityData[1] == 2) then
		City:DoBuilding(g_CityData[2], "create");
	elseif(g_CityData[1] == 3) then
		City:DoBuilding(g_CityData[2], "up");
	elseif(g_CityData[1] == 4) then
		City:DoBuilding(g_CityData[2], "down");
	elseif(g_CityData[1] == 5) then
		City:DoBuilding(g_CityData[2], "destory");
	elseif(g_CityData[1] == 6) then
		local k;
		local valTab = {};
		for k = 2, 8 do
			valTab[k-1] = tonumber(g_CityData[k]);
		end
		City:FixCityTrend(
												valTab[1],valTab[2],valTab[3],valTab[4],
												valTab[5],valTab[6],valTab[7],valTab[8]
										 );
	elseif(g_CityData[1] == 7) then
		local rName, bIdx, rIdx = City:GetResearchInfo("CurResearch");
		City:DoResearch(bIdx, rIdx, "cancelresearch");
	elseif(g_CityData[1] == 8) then
		City:DoResearch(tonumber(g_CityData[2]), tonumber(g_CityData[3]), "research");
	elseif(g_CityData[1] == 9) then
		City:DoCityRoad("create", g_CityData[2]);
	elseif(g_CityData[1] == 10) then
		City:DoCityRoad("cancel", g_CityData[2]);
	end
	g_CityData = {};
end

function MessageBox_Self_City_Cancel_Clicked()
	g_CityData = {};
end


--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrameEx()

	if( g_FrameInfo==FrameInfoList.SAVE_STALL_INFO) then
		
		MessageBox_Self_DragTitle:SetText("#gFF0FA0保存摊位设置");
		local szInfo;
		szInfo = "#{INTERFACE_XML_681}";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- add by zchw
	elseif (g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0收摊");
		local szInfo;
		szInfo = "你真的要收摊吗？";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	-- zchw for pet procreate
	elseif (g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0注意");
		MessageBox_Self_Text:SetText("#{PET_FANZHI_20080313_01}");
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
		local szInfo;
		szInfo = "购买"..g_CityData[3].."需要花费"..tostring(g_CityData[2]).."个元宝，你确认吗？";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0购买商品");
		local szInfo;
		szInfo = "购买"..CommisionBuyData[1].."需要花费"..CommisionBuyData[2].."，你确认吗？";
		MessageBox_Self_Text:SetText(szInfo);
		this:Show();
		
	end

end

--===============================================
-- UpdateTitle
--===============================================
function UpdateTitle()
    --因为在MessageBox_Self_UpdateFrame函数中,"upvalue"严重超员,增加了这个函数用来更改msgbox的标题
    if ( PVPFLAG.FREEFORALL == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");
    elseif ( PVPFLAG.FREEFORTEAM == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");
    elseif ( PVPFLAG.FREEFORGUILD == g_FrameInfo ) then
        MessageBox_Self_DragTitle:SetText("#gFF0FA0更改PK模式");
    elseif ( PVPFLAG.MAKESUREPVPCHALLENGE == g_FrameInfo ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0宣战确认");
	end
	MessageBox_Self_UpdateRect();

end

--===============================================
-- UpdateFrame
--===============================================
function MessageBox_Self_UpdateFrame()

	MessageBox_Self_DragTitle:SetText("#gFF0FA0");
	UpdateTitle()

	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		this : Show()
		MessageBox_Self_Text : SetText( GemCombinedData[7] )
		MessageBox_Self_UpdateRect();
		return
	end

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--提示本的费用
		local nPosTax = StallSale:GetPosTax();
		local nTradeTax = StallSale:GetTradeTax();

		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(nPosTax);

		local szMoneyPosTax = "";
		if(nGoldCoin ~= 0)   then
		 	szMoneyPosTax = tostring(nGoldCoin) .. "#-14";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoneyPosTax = szMoneyPosTax .. tostring(nSilverCoin) .. "#-15";
		end
		if(nCopperCoin ~= 0)   then
			szMoneyPosTax = szMoneyPosTax .. tostring(nCopperCoin) .. "#-16";
		end

		local nCoinType = StallSale:GetStallType()
		if (nCoinType == 1) then --元宝摆摊
			local szInfo = "#{YBBT_081031_1}".. szMoneyPosTax .."#{YBBT_081031_2}1#{YBBT_081031_3}";
			MessageBox_Self_Text:SetText(szInfo);
		else
			local szInfo = "#{YBBT_081031_4}".. szMoneyPosTax .."#{YBBT_081031_5}".. tostring(nTradeTax) .."#{YBBT_081031_6}";
			MessageBox_Self_Text:SetText(szInfo);
		end

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--通知解除锁定
		MessageBox_Self_DragTitle:SetText("#gFF0FA0销毁物品");
		local szStr = "你真的要销毁".. argDISCARD_ITEM_FRAME0 .."?"
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0销毁物品");
		local szStr = argCANNT_DISCARD_ITEM0.."是任务物品，不能销毁";
		MessageBox_Self_Text:SetText(szStr);
		
	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0加锁");
		local szStr = "".."#cff0000注意！#r#Y为了保护您的财产安全，一旦物品或珍兽成功被加锁，再次解锁则需要等待#G3天#Y，您确定要继续加锁么？";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0放弃任务");
		local szStr = "#cFFF263你真的要放弃#R任务:"..argFRAME_AFFIRM_SHOW0.."#cFFF263吗？";
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- 帮会成立需玩家确认
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会成立");
		local szStr = "你确认创建" .. argCREATE_CONFIRM0 .. "帮会吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
	  MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会解散");
		local szStr = "你确认删除" .. argDESTORY_CONFIRM0 .. "帮会吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮会退出");
		local szStr = "你确认退出" .. argQUIT_CONFIRM0 .. "帮会吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0同盟退出");
		local szStr = "你确认退出" .. argQUIT_LEAGUE_CONFIRM0 .. "同盟吗？";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0同盟创建");
		local szStr = "#{TM_20080331_09}#{_EXCHG1000000}#{TM_20080331_02}";
		MessageBox_Self_Text:SetText(szStr);
	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		MessageBox_Self_Text:SetText(argNET_CLOSE0);
	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0珍兽放生");
		local petname = Pet:GetPetList_Appoint(Pet_Number) ;
		local strname, pettype = Pet:GetName(Pet_Number);
		local szStr = "是否确认放生["..petname.."]("..pettype..")?" ;
		MessageBox_Self_Text:SetText(szStr);

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改店名");
		--玩家商店更名需要的金钱数字
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "修改店名需要支付牌匾金字费2".."#-02".. "×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor().."需要支付"..szMoney.."，你确定要修改吗？"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--玩家商店更更改商店说明需要的金钱数字
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改店铺描述");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "修改店描述需要支付笔墨费".."50#-03".. "×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor().."需要支付"..szMoney.."，你确定要修改吗？"
		MessageBox_Self_Text:SetText(szInfo);

		this:Show()

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0充入本金");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "你将充入" .. szMoney .. "，系统还将收取你3%的投资税，你将需要额外支付" .. szMoney1 .. "，你确定要充入吗？";

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0充入盈利金");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData1);

		local szMoney1 = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney1 = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney1 = szMoney1 .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney1 = szMoney1 .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "你将充入" .. szMoney .. "，系统还将收取你3%的投资税，你将需要额外支付" .. szMoney1 .. "，你确定要充入吗？";

		MessageBox_Self_Text:SetText(szInfo);

	

	elseif(g_FrameInfo == FrameInfoList.PS_DEC_GAIN_MONEY)    then

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Server_Script_Function = Get_XParam_STR(0);
		Server_Script_ID = Get_XParam_INT(0);
		Server_Return_1 = Get_XParam_INT(1);
		Server_Return_2 = Get_XParam_INT(2);

		MessageBox_Self_Text:SetText(Get_XParam_STR(1));

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0扩张柜台");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_nData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "扩张柜台需要支付30#-02×商业指数×2×103%，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要扩张吗？"

		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)   then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0缩减柜台");
		MessageBox_Self_Text:SetText("缩减柜台后，您摆放到柜台中的货物也将被系统回收。您确定要这样做吗？");

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)  then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0盘出店铺");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "盘出店铺需要支付15#-02×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要盘出店铺吗？"
		MessageBox_Self_Text:SetText(szInfo);

	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)  then   --盘入

		MessageBox_Self_DragTitle:SetText("#gFF0FA0盘入店铺");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);

		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "取消盘出柜台需要支付5#-02×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要盘入店铺吗？"

		MessageBox_Self_Text:SetText(szInfo);

	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0修改店铺类型");
		local nGoldCoin;
		local nSilverCoin;
		local nCopperCoin;

		nGoldCoin, nSilverCoin, nCopperCoin = Bank:TransformCoin(g_szData);
		local szMoney = "";
		if(nGoldCoin ~= 0)   then
		 	szMoney = tostring(nGoldCoin) .. "#-02";
		end
		if(nSilverCoin ~= 0)   then
		 	szMoney = szMoney .. tostring(nSilverCoin) .. "#-03";
		end
		if(nCopperCoin ~= 0)   then
			szMoney = szMoney .. tostring(nCopperCoin) .. "#-04";
		end

		local szInfo = "修改店类型需要支付搬运费：5#-02 ×商业指数，当前的商业指数为".. PlayerShop:GetCommercialFactor() .."，需要支付" .. szMoney .. "，你确定要修改吗？"

		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0删除确认");
		local szInfo;
		local relationtype = DataPool:GetFriend(g_currentList,g_currentIndex, "RELATION_TYPE" )
		if relationtype == 7 then
			szInfo = "#cFFF263你确定要删除".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."吗？删除后将不能与对方进行任何师徒相关的活动。";
		else
			szInfo = "#cFFF263你确定要删除".."#R"..DataPool:GetFriend(g_currentList,g_currentIndex, "NAME"  ) .."#cFFF263".."吗？";
		end
		MessageBox_Self_Text:SetText(szInfo);
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_UpdateFrame();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0珍兽合成");
		local msg = "你确定将这两只珍兽合成为一只吗?";
		MessageBox_Self_Text:SetText(msg);
	elseif( g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG ) then
		MessageBox_Self_DragTitle:SetText("#gFF0FA0帮贡牌兑换");
	elseif( g_FrameInfo == FrameInfoList.PUT_GUILDMONEY ) then
		MessageBox_Self_DragTitle:SetText("#{BPZJ_0801014_020}");
	end

	MessageBox_Self_UpdateFrameEx();
	MessageBox_Self_UpdateRect();	
	this:Show();
end

--===============================================
-- 点击确定（IDOK）
--===============================================
function MessageBox_Self_OK_Clicked_Ex()
    AxTrace( 0, 0, "MessageBox_OnOKClick" )
	if( g_FrameInfo == FrameInfoList.FREEFORALL ) then --同意开启个人混战
        AxTrace( 0, 0, "FrameInfoList.FREEFORALL" )
        Player:ChangePVPMode( 1 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORTEAM ) then --同意开启队伍混战
        AxTrace( 0, 0, "FrameInfoList.FREEFORTEAM" )
        Player:ChangePVPMode( 3 );
    end
    if( g_FrameInfo == FrameInfoList.FREEFORGUILD ) then  --同意开启帮派混战
        AxTrace( 0, 0, "FrameInfoList.FREEFORGUILD" )
        Player:ChangePVPMode( 4 );
    end
    if( g_FrameInfo == FrameInfoList.MAKESUREPVPCHALLENGE ) then  --确认宣战
        AxTrace( 0, 0, "FrameInfoList.MAKESUREPVPCHALLENGE" )
        Player:PVP_Challenge( 2 );     --2为宣战确认对话框确认
    end
    
    if(g_FrameInfo == FrameInfoList.CHANGEPROTECTTIME)then
	if(g_ChangeTiemArg1 ~= nil)then
		SendSetProtectTimeMsg(g_ChangeTiemArg1);
		g_ChangeTiemArg1 =nil;
	end
    end
    if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
        DuelAccept( tostring( PVPFLAG.DuelName ),tostring( PVPFLAG.DuelGUID ), 1 )
    end


	if( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		StallSale:CloseStall("ok");
	-- add by zchw	
		StallSale:CloseStallMessage();
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		StallSale:CloseStall("ask");
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		PushEvent(462, 0); --PETPROCREATE_KEY_STATE 
		Pet:ConfirmPetProcreate(1);
		
	elseif  g_FrameInfo == FrameInfoList.QUIT_GAME  then
		EnterQuitWait(0);
		--QuitApplication("quit");
	elseif(g_FrameInfo == FrameInfoList.PS_DEL_STALL)    then
		PlayerShop:ChangeShopNum("del_ok");
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANCHU)    then
		PlayerShop:Transfer("apply", "sale", g_nData);
	elseif(g_FrameInfo == FrameInfoList.PS_INFO_PANRU)    then
		PlayerShop:Transfer("apply", "back", g_nData);
	elseif( g_FrameInfo == FrameInfoList.PS_INFO_MODIFY_TYPE ) then
		PlayerShop:ModifySubType("ps_type_ok", tonumber(g_nData));
	elseif( g_FrameInfo == FrameInfoList.DELETE_FRIEND_MESSAGE ) then
		DataPool:DelFriend( g_currentList, g_currentIndex );
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_OK_Clicked();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		MessageBox_Self_PetSyn_OK_Clicked();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_DEMIS_CONFIRM) then
		Guild:DemisGuildOK();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_QUIT_CONFIRM) then
		GuildLeague:Quit();
	elseif(g_FrameInfo ==FrameInfoList.GUILD_LEAGUE_CREATE_CONFIRM) then
		local r=GuildLeague:Create(argCREATE_LEAGUE_CONFIRM0,argCREATE_LEAGUE_CONFIRM1)
		if r==-1 then
			PushDebugMessage("#{TM_20080311_05}")
		elseif r==-2 then
			PushDebugMessage("#{TM_20080311_07}")	
		end
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		NpcShop:BulkBuyItem(g_CityData[1],1);
	elseif(g_FrameInfo == FrameInfoList.COMMISION_BUY) then
		CommisionShop:OnBuyConfrimed();
	end
	if( FrameInfoList.Player_Give_Rose == g_FrameInfo ) then
		Player:UseRose(tonumber(g_RoseArg1),tonumber(g_RoseArg2),tonumber(g_RoseArg3),tonumber(g_RoseArg4))
	end

	if(g_FrameInfo == FrameInfoList.RECYCLE_DEL_ITEM) then
		if(Recycle_Type<0 or Recycle_CurSelectItem<0) then
			return
		end
		PlayerShop:SendCancelRecItemMsg(Recycle_Type,Recycle_CurSelectItem);
		Recycle_Type =-1;
		Recycle_CurSelectItem = -1;
	end

	if(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx<0 or Recycle_Shop_idx<0) then
			return
		end
		PlayerShop:SendSellItem2RecycleShopMsg(Recycle_Bag_idx,Recycle_Shop_idx);
		Recycle_Bag_idx =-1;
		Recycle_Shop_idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_STENGTH) then
		if(Stength_Equip_Idx<0 or Stength_Item_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishEnhance");
			Set_XSCRIPT_ScriptID(809262);
			Set_XSCRIPT_Parameter(0,tonumber(Stength_Equip_Idx));
			Set_XSCRIPT_Parameter(1,tonumber(Stength_Item_Idx));
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		Stength_Equip_Idx =-1;
		Stength_Item_Idx = -1;
	end
	if(g_FrameInfo == FrameInfoList.EXCHANGE_BANGGONG) then
		if(BangGong_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("BanggongExchange");
			Set_XSCRIPT_ScriptID(805009);
			Set_XSCRIPT_Parameter(0,BangGong_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		BangGong_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.PUT_GUILDMONEY) then
		if(GuildMoney_Value < 0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("PutGuildMoney");
			Set_XSCRIPT_ScriptID(805012);
			Set_XSCRIPT_Parameter(0,GuildMoney_Value);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		GuildMoney_Value =-1;
	end
	if(g_FrameInfo == FrameInfoList.CONFIRM_RE_IDENTIFY) then
		if(RID_Equip_Idx<0) then
			return
		end
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishReAdjust");
			Set_XSCRIPT_ScriptID(809261);
			Set_XSCRIPT_Parameter(0,tonumber(RID_Equip_Idx));
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		RID_Equip_Idx =-1;
	end
	if(g_FrameInfo == FrameInfoList.KICK_MEMBER_MSGBOX) then
		if(Member_Idx < 0) then
			return
		end
		Guild:SureKickGuild(tonumber(Member_Idx));
		Member_Idx =-1;
		Member_Name = "";
	end
	
	if (g_FrameInfo == FrameInfoList.TLZ_CONFIRM_SETPOS) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("SetPosition");
			Set_XSCRIPT_ScriptID(330001);
			Set_XSCRIPT_Parameter(0, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
	
end

function MessageBox_OnOKClick()
	if( strMessageData == "EquipBind" ) then -- 绑定
		EquipItem( tonumber( strMessageArgs ),tonumber(strMessageArgs_2) );
	end
	this:Hide();
end
--===============================================
-- 点击确定（IDOK）
--===============================================
function MessageBox_Self_OK_Clicked()
	
	if g_FrameInfo == FrameInfoList.SAFEBOX_LOCK_CONFIRM then
		SafeBox("reallock");
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.SAFEBOX_UNLOCK_CONFIRM then
		SafeBox("realunlock");
		this : Hide()
		return
	end
	
	if g_FrameInfo == FrameInfoList.CITY_RANAME_CONFIRM then
		Guild : SendCityRnameMsg( g_arg_circ )
		this : Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.CHAR_RANAME_CONFIRM then
		Target : SendCharRnameMsg( g_arg_chrc )
		this : Hide()
		return
	end	
	
	if g_FrameInfo == FrameInfoList.GEM_COMBINED_CONFIRM then
		LifeAbility : Do_Combine( GemCombinedData[1], GemCombinedData[2],
			GemCombinedData[3], GemCombinedData[4],
			GemCombinedData[5], GemCombinedData[6], 1 )
		this : Hide()
		return
	end
	
	if g_FrameInfo == FrameInfoList.ENCHASE_CONFIRM then
		LifeAbility : Do_Enchase( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

-- add:lby20080527确认4镶嵌ENCHASE_FOUR_CONFIRM
	if g_FrameInfo == FrameInfoList.ENCHASE_FOUR_CONFIRM then
		LifeAbility : Do_Enchase_Four( EnchaseData[1], EnchaseData[2],EnchaseData[3], EnchaseData[4])
		this:Hide()
		return
	end

	-- 宠物学习技能确认：两个手动技能学习
	if g_FrameInfo == FrameInfoList.PET_SKILL_STUDY_CONFIRM then
		Pet:ConfirmPetSkillStudy()
		this:Hide()
		return
	end

--	if g_FrameInfo == FrameInfoList.CARVE_CONFIRM then
--	  Clear_XSCRIPT();
--		Set_XSCRIPT_Function_Name(CarveData[1]);
--		Set_XSCRIPT_ScriptID(CarveData[2]);
--		Set_XSCRIPT_Parameter(0,CarveData[3]);
--		Set_XSCRIPT_Parameter(1,CarveData[4]);
--		Set_XSCRIPT_ParamCount(CarveData[5]);
--	  Send_XSCRIPT();
--		this:Hide()
--		return
--	end
	

	if(g_FrameInfo == FrameInfoList.STALL_RENT_FRAME) then
		--通知服务器决定开始在这里摆摊
		StallSale:AgreeBeginStall();

	elseif(g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME) then
		--通知销毁物品
		DiscardItem();

	elseif(g_FrameInfo == FrameInfoList.CANNT_DISCARD_ITEM) then
		--任务物品不能销毁
		g_InitiativeClose = 1;
		this:Hide();
	
	elseif(g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME) then
		--通知加锁物品
		LockAfterConfirm();

	elseif(g_FrameInfo == FrameInfoList.FRAME_AFFIRM_SHOW) then
		--放弃任务
		if(Quest_Number > -1) then
			QuestFrameMissionAbnegate(Quest_Number);
		end
		g_InitiativeClose = 1;
		this:Hide();


	elseif(g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM) then
		-- 帮会成立需玩家确认
		Guild:CreateGuildConfirm(1);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM) then
		-- 帮会成立需玩家确认
		Guild:CreateGuildConfirm(2);
		this:Hide();
	elseif(g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM) then
		-- 帮会成立需玩家确认
		Guild:CreateGuildConfirm(3);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PET_FREE_CONFIRM) then
		Pet : Go_Free(Pet_Number);
		this:Hide();

	elseif(g_FrameInfo == FrameInfoList.PS_RENAME_MESSAGE)  then
		--玩家商店更名需要的金钱数字
		PlayerShop:Modify("name_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_READ_MESSAGE)    then
		--玩家商店更更改商店说明需要的金钱数字
		PlayerShop:Modify("ad_ok",g_szData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_BASE_MONEY)    then
		PlayerShop:ApplyMoney("immitbase_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_GAIN_MONEY)    then
		PlayerShop:ApplyMoney("immit_ok", g_nData);

	elseif(g_FrameInfo == FrameInfoList.SERVER_CONTROL)    then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name(Server_Script_Function);
			Set_XSCRIPT_ScriptID(Server_Script_ID);
			Set_XSCRIPT_Parameter(0,Server_Return_1);
			Set_XSCRIPT_Parameter(1,Server_Return_2);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();

	elseif(g_FrameInfo == FrameInfoList.PS_ADD_STALL)    then
		PlayerShop:ChangeShopNum("add_ok");
	end
	
	if( g_FrameInfo == FrameInfoList.EQUIP_ITEM ) then
		MessageBox_OnOKClick();
		return;
	end
	
	-- 确认解散队伍			add by WTT	20090212
	if g_FrameInfo == FrameInfoList.DISMISS_TEAM then
		Player:ConfirmDismissTeam()
		this:Hide()
		return
	end

	if g_FrameInfo == FrameInfoList.DART_ADJUST then
		if IsWindowShow("AnqiShuxing") then
			MessageBox_Self_AdjustDart()
		end
		this:Hide()
		return
	end

	MessageBox_Self_OK_Clicked_Ex();
	this:Hide();
end

function MessageBox_Self_PetSyn_OK_Clicked()
	Pet:Syn_Do(g_CityData[1], g_CityData[2]);
	g_CityData = {};
end
--===============================================
-- 放弃摆摊(IDCONCEL)
--===============================================
function MessageBox_Self_Cancel_Clicked(bClick)
	if( 1 == bClick ) then
		--AxTrace( 0, 0, bClick )
		if( PVPFLAG.ACCEPTDUEL == g_FrameInfo ) then
			DuelAccept( tostring( PVPFLAG.DuelName ), tostring( PVPFLAG.DuelGUID ), 0 )
		end
    end

	if ( g_FrameInfo == FrameInfoList.DISCARD_ITEM_FRAME ) then
		--通知解除锁定
		DiscardItemCancelLocked();

    elseif ( g_FrameInfo == FrameInfoList.LOCK_ITEM_CONFIRM_FRAME ) then
		--通知解除加锁
		CancelLockAfterConfirm();

	elseif ( g_FrameInfo == FrameInfoList.GUILD_CREATE_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_DESTORY_CONFIRM ) then
		Guild:CreateGuildConfirm(0);
	elseif ( g_FrameInfo == FrameInfoList.GUILD_QUIT_CONFIRM ) then
		Guild:CreateGuildConfirm(0);

	elseif(g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE) then
		QuitApplication("quit");
	elseif( g_FrameInfo == FrameInfoList.CITY_CONFIRM ) then
		MessageBox_Self_City_Cancel_Clicked();
	elseif(g_FrameInfo == FrameInfoList.YUANBAO_BUY_ITEM) then
		g_CityData = {};
	-- add by zchw
	elseif g_FrameInfo == FrameInfoList.CONFIRM_REMOVE_STALL then
		this:Hide();
	-- zchw for pet procreate
	elseif g_FrameInfo == FrameInfoList.PET_PROCREATE_PROMPT then
		if bClick == 1 then
			PushEvent(462, 1); --PETPROCREATE_KEY_STATE
		end
		this:Hide();
	elseif( g_FrameInfo == FrameInfoList.SAVE_STALL_INFO ) then
		if bClick == 1 then
			StallSale:CloseStall("cancel");
			-- add by zchw
			StallSale:CloseStallMessage();
		end
		-- add by zchw
		StallSale:CloseStallMessage();
	elseif( g_FrameInfo == FrameInfoList.PET_SYNC_CONFIRM ) then
		g_CityData = {};
--	elseif( g_FrameInfo == FrameInfoList.SERVER_CONTROL ) then
--		Clear_XSCRIPT();
--			Set_XSCRIPT_Function_Name(Server_Script_Function);
--			Set_XSCRIPT_ScriptID(Server_Script_ID);
--			Set_XSCRIPT_Parameter(0,Server_Return_1);
--			Set_XSCRIPT_Parameter(1,-1);
--			Set_XSCRIPT_ParamCount(2);
--		Send_XSCRIPT();
	elseif(g_FrameInfo == FrameInfoList.OPEN_IS_SELL_TO_RECSHOP) then
		if(Recycle_Bag_idx ~=nil and tonumber(Recycle_Bag_idx)>0) then
			PlayerShop:CancelSellItem2RecycleShop(Recycle_Bag_idx);
		end
	end

	this:Hide();


end

function MessageBox_Self_Help()
	if( g_FrameInfo == FrameInfoList.NET_CLOSE_MESSAGE ) then
		Helper:GotoHelper( "61" );
	else
		Helper:GotoHelper("*MessageBox_Self");
	end
end


function MessageBox_Self_ShowDart()
	if (Dart_Data[1] >=1 and Dart_Data[1] <= 5) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_2}" ); --神亦石
	elseif (Dart_Data[1] == 6) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_1}" ); --忘无石
	elseif (Dart_Data[1] == 7) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_5}" ); --百淬神玉
	elseif (Dart_Data[1] == 8) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_4}" ); --千淬神玉
	elseif (Dart_Data[1] == 9) then
		MessageBox_Self_Text:SetText( "#{FBSJ_090421_3}" ); --浴火石
	end
	
	MessageBox_Self_DragTitle:SetText("");
	MessageBox_Self_UpdateRect();	
	
	this:Show();
	MessageBox_Self_OK_Button:Show();
	MessageBox_Self_Cancel_Button:Show();
end


function MessageBox_Self_AdjustDart()
	if (Dart_Data[1] >=1 and Dart_Data[1] <= 5) then
		DataPool:DarkAdjustAttr(Dart_Data[2], Dart_Data[1], 1);	--神亦石
	elseif (Dart_Data[1] == 6) then
		DataPool:DarkAdjustSkill(Dart_Data[2] , 1);		--忘无石
	elseif (Dart_Data[1] == 7) then
		DataPool:DarkResetQuality(Dart_Data[2], 1, 1);    --百淬神玉
	elseif (Dart_Data[1] == 8) then
		DataPool:DarkResetQuality(Dart_Data[2], 2, 1);    --千淬神玉
	elseif (Dart_Data[1] == 9) then
		DataPool:DarkReset(Dart_Data[2], 1);		--浴火石
	end
end