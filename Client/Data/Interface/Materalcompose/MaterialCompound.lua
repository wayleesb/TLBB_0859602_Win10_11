--/* modified by cuiyinjie 开放4级三精合成功能 */
local STUFF_SLOTS = {}										-- 物品槽
local ITEM_IN_SLOTS = {}									-- 物品槽中的物品背包位置
local Current = 0											-- 界面的当前状态 1：宝石合成 2：材料合成 3: 寒玉合成
local Type = -1												-- 当前合成的材料类型
local Grade = -1											-- 当前合成的材料档次
local theNPC = -1											-- 功能 NPC
local MATERIAL_COUNT = 5									-- 放合成材料的槽的数量
local SLOT_COUNT = 6										-- 所有能放东西的槽的数量
local SPECIAL_MATERIAL_SLOT = 6								-- 放特殊材料的格子号
local MAX_OBJ_DISTANCE = 3.0

local LaskPack = {}

local curSuccRate = 0;
local RuleTable = {
	{
		msgDiffTypeErr = "必须为同种的宝石方可进行合成。",
		msgDiffGradeErr = "需要合成的宝石必须等级相同方可合成。",
		msgLackMoney = "您身上的金钱不足#{_EXCHG%d}。",
		msgLackStuff = "每次合成放置的物品必须大于2个。",
		msgSlotEmpty = "请放入要合成的宝石。",         -- add  by zchw
		maxGrade = 9,
		msgGradeLimited = "合成的宝石最高等级为9级，您的宝石不能继续合成。",
		[1] = { SpecialStuff = 30900015, MoneyCost = 5000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[2] = { SpecialStuff = 30900015, MoneyCost = 6000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[3] = { SpecialStuff = 30900015, MoneyCost = 7000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[4] = { SpecialStuff = 30900016, MoneyCost = 8000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[5] = { SpecialStuff = 30900016, MoneyCost = 9000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[6] = { SpecialStuff = 30900016, MoneyCost = 10000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[7] = { SpecialStuff = 30900016, MoneyCost = 11000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
		[8] = { SpecialStuff = 30900016, MoneyCost = 12000, CountTable = { [3] = { SuccOdds = 25, SuccOddsWithSpecStuff = 50, }, [4] = { SuccOdds = 50, SuccOddsWithSpecStuff = 75, }, [5] = { SuccOdds = 75, SuccOddsWithSpecStuff = 100, }, }, },
	},
	{
		msgDiffTypeErr = "必须使用同种材料方可合成。",
		msgDiffGradeErr = "必须等级相同的材料方可合成。",
		msgLackMoney = "您身上的金钱不足#{_EXCHG%d}。",
		msgLackStuff = "每次合成放置的物品必须大于2个。",
		msgSlotEmpty = "请放入要合成的材料。",				-- add by zchw
		maxGrade = 5,	-- 物品表里的等级，3级材料为4级，所以边界为5级 mark by cuiyinjie maxGrade add 1
		msgGradeLimited = "最高可放入3级材料，您的材料不能继续合成。", --等级加1级
		[1] = { SpecialStuff = -1, MoneyCost = 500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[2] = { SpecialStuff = -1, MoneyCost = 1000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[3] = { SpecialStuff = -1, MoneyCost = 1500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
		[4] = { SpecialStuff = -1, MoneyCost = 5000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, }, -- modify by cuiyinjie cost 20yin -> cost 50yin
--		[5] = { SpecialStuff = -1, MoneyCost = 2500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[6] = { SpecialStuff = -1, MoneyCost = 3000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[7] = { SpecialStuff = -1, MoneyCost = 3500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[8] = { SpecialStuff = -1, MoneyCost = 4000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
	},
	{
		msgDiffTypeErr = "必须使用玄天寒玉方可合成。",
		msgDiffGradeErr = "必须同一种玄天寒玉方可合成。",
		msgLackMoney = "您身上的金钱不足#{_EXCHG%d}。",
		msgLackStuff = "每次合成放置的物品必须大于2个。",
		msgSlotEmpty = "请放入要合成的玄天寒玉。",
		maxGrade = 2,
		msgGradeLimited = "必须放入同一种玄天寒玉。，您的玄天寒玉不能继续合成。",
		[1] = { SpecialStuff = -1, MoneyCost = 10000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[2] = { SpecialStuff = -1, MoneyCost = 1000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[3] = { SpecialStuff = -1, MoneyCost = 1500, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[4] = { SpecialStuff = -1, MoneyCost = 2000, CountTable = { [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[5] = { SpecialStuff = -1, MoneyCost = 2500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[6] = { SpecialStuff = -1, MoneyCost = 3000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[7] = { SpecialStuff = -1, MoneyCost = 3500, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
--		[8] = { SpecialStuff = -1, MoneyCost = 4000, CountTable = { [3] = { SuccOdds = 50, SuccOddsWithSpecStuff = 0, }, [4] = { SuccOdds = 75, SuccOddsWithSpecStuff = 0, }, [5] = { SuccOdds = 100, SuccOddsWithSpecStuff = 0, }, }, },
	},
}

-- 注册事件
function MaterialCompound_PreLoad()
	this:RegisterEvent("UI_COMMAND")						-- 激活界面事件

	this:RegisterEvent("UPDATE_COMPOSE_GEM")				-- 刷新宝石合成界面
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")				-- 背包中物品改变需要判断……
	this:RegisterEvent("OBJECT_CARED_EVENT")				-- 关注实施合成的 NPC
	this:RegisterEvent("RESUME_ENCHASE_GEM")				-- 合成完毕
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE")			-- 关闭本界面
	-- this:RegisterEvent("TOGLE_SKILL_BOOK")				-- 打开门派技能界面是否需要关闭此界面
	-- this:RegisterEvent("TOGLE_COMMONSKILL_PAGE")			-- 打开普通技能界面是否需要关闭？
	-- this:RegisterEvent("CLOSE_SKILL_BOOK")				-- 关闭门派技能界面
	-- this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM")		-- 所有合成相关的物品需要锁定
	-- this:RegisterEvent("UPDATE_COMPOSE_ITEM")			-- 物品合成界面打开，此界面是否需要关闭？
	-- this:RegisterEvent("OPEN_COMPOSE_ITEM")				-- 物品合成界面打开，此界面是否需要关闭？
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--交子普及 Vega
end

-- 界面载入
function MaterialCompound_OnLoad()
	STUFF_SLOTS[1] = Materalcompose_Space1
	STUFF_SLOTS[2] = Materalcompose_Space2
	STUFF_SLOTS[3] = Materalcompose_Space3
	STUFF_SLOTS[4] = Materalcompose_Space4
	STUFF_SLOTS[5] = Materalcompose_Space5
	STUFF_SLOTS[6] = Materalcompose_Special_Button

	ITEM_IN_SLOTS[1] = -1
	ITEM_IN_SLOTS[2] = -1
	ITEM_IN_SLOTS[3] = -1
	ITEM_IN_SLOTS[4] = -1
	ITEM_IN_SLOTS[5] = -1
	ITEM_IN_SLOTS[6] = -1
	
	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1
end

-- 监控各种事件
function MaterialCompound_OnEvent( event )
	if event == "UI_COMMAND" and tonumber( arg0 ) == 23 then	-- 宝石合成
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 1 then				-- 如果界面开着，则关掉
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000成功率");
		Current = 1
		Materalcompose_DragTitle : SetText("#gFF0FA0合成宝石")
		MaterialCompose_Info : SetText("合成宝石可以将低级的宝石合成为高级的宝石#G（合成的宝石需要大于两个）#W")
		Materalcompose_Static1 : Show()
		Materalcompose_Special : Show()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UI_COMMAND" and tonumber( arg0 ) == 19810424 then	-- 材料合成
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 2 then				-- 如果界面开着，则关掉
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000成功率");
		Current = 2
		Materalcompose_DragTitle : SetText("#gFF0FA0合成材料")
		MaterialCompose_Info : SetText("合成材料可以将棉布、秘银、精铁进行升级合成。（#G合成材料需要五个#Y）")
		Materalcompose_Static1 : Hide()
		Materalcompose_Special : Hide()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UI_COMMAND" and tonumber( arg0 ) == 86021935 then	-- 寒玉合成
		MaterialCompound_Clear();			-- add by zchw
		if this : IsVisible() and Current ~= 3 then				-- 如果界面开着，则关掉
			MaterialCompound_Close()
		end
		Materalcompose_SuccessValue : SetText("#cFF0000成功率");
		Current = 3
		Materalcompose_DragTitle : SetText("#gFF0FA0寒玉合成")
		MaterialCompose_Info : SetText("可以用5个玄天寒玉合成1个寒玉精粹（#G合成材料玄天寒玉需要五个#Y）")
		Materalcompose_Static1 : Hide()
		Materalcompose_Special : Hide()
		this : Show()

		local npcObjId = Get_XParam_INT( 0 )
		MaterialCompound_BeginCareObject( npcObjId )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			MaterialCompound_Cancel_Clicked()
		end
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_COMPOSE_GEM" and this : IsVisible() then
		MaterialCompound_Update( arg0, arg1 )
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "PACKAGE_ITEM_CHANGED" and this : IsVisible() then
		if not arg0 or tonumber( arg0 ) == -1 then
			return
		end

		for i = 1, SLOT_COUNT do
			if ITEM_IN_SLOTS[i] == tonumber( arg0 ) then
				MaterialCompound_Remove( i )
				break
			end
		end
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "RESUME_ENCHASE_GEM" and this : IsVisible() then
		if arg0 then
			MaterialCompound_Remove( tonumber( arg0 ) - 6 )
		end

		return
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end

	if event == "CLOSE_SYNTHESIZE_ENCHASE" and this : IsVisible() then
		MaterialCompound_Cancel_Clicked()
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		Materalcompose_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Materalcompose_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
end

-- 点击合成按钮
function MaterialCompound_OK_Clicked()
	-- 根据当前所处的界面进行检查
	local Notify = 0;
	local CurrentRule = RuleTable[Current]
	if not CurrentRule then
		return
	end
	
	--检查绑定状态
	--下面这一段是材料绑定提示，张宁写的有bug，全部注掉，采用新的逻辑
--		for i = 1, MATERIAL_COUNT do

--			if(LaskPack[i] ~= ITEM_IN_SLOTS[i]) then
			
--				LaskPack[i] = ITEM_IN_SLOTS[i];
--				Notify = 1;
				
--			end
			
--		end
		
--		if(Notify == 1) then
				
--			for i = 1, MATERIAL_COUNT do
			
--				if(ITEM_IN_SLOTS[i] == -1) then
				
--					continue
					
--				end
				
--				if(MaterialCompound_IsBind(ITEM_IN_SLOTS[i]) == 1) then
				--检查有没有绑定的物品
--					ShowSystemInfo("BSHE_20070924_001");
--					return;					
					
--				end
				
--			end
						
--		end
	
	local materialCount = 0
	
	-- add by zchw
	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] ~= -1 then
			Grade = MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] );
			break;
		end
	end
	if Grade == -1 then
		PushDebugMessage( CurrentRule.msgSlotEmpty )
		return
	end
	-- end of zchw
	
	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] == -1 then
			continue
		end
		materialCount = materialCount + 1

		-- 检查是否都是同种材料
		if MaterialCompound_ItemInterface( ITEM_IN_SLOTS[i] ) ~= Current then
			PushDebugMessage( CurrentRule.msgDiffTypeErr )
			return
		end

		if Type ~= MaterialCompound_GetItemType( ITEM_IN_SLOTS[i] ) then
			PushDebugMessage( CurrentRule.msgDiffTypeErr )
			return
		end

		-- 检查材料是否等级相同
		if not CurrentRule[Grade] or Grade ~= MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) then
			PushDebugMessage( CurrentRule.msgDiffGradeErr )
			return
		end

		-- 检查材料是否是最高等级
		if MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) >= RuleTable[Current].maxGrade then
			PushDebugMessage( CurrentRule.msgGradeLimited )
			return
		end
		--合成8，9级宝石功能关闭
		-- if Current == 1 then
			-- if MaterialCompound_GetItemGrade( ITEM_IN_SLOTS[i] ) > 6 then
				-- PushDebugMessage( "#{BSHC_090313_1}" )
				-- return				
			-- end
		-- end
	end

	-- 检查身上的金钱是否足够
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if selfMoney < CurrentRule[Grade].MoneyCost then
		PushDebugMessage( string.format( CurrentRule.msgLackMoney, CurrentRule[Grade].MoneyCost ) )
		return
	end

	-- 检查材料数量是否足够
	if not CurrentRule[Grade].CountTable[materialCount] then
		PushDebugMessage( CurrentRule.msgLackStuff )
		return
	end

	-- 如果是宝石合成界面，则如果没有放入特殊材料将给出界面提示
	if Current == 1 then
		if ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] and ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] == -1 then
--			local dialogStr = "如果不使用#{_ITEM" .. CurrentRule[Grade].SpecialStuff ..
--				"}进行合成的话，合成的成功率最高只有75％，您是否确定继续合成？"
--			LifeAbility : Do_Combine( ITEM_IN_SLOTS[1], ITEM_IN_SLOTS[2],
--				ITEM_IN_SLOTS[3], ITEM_IN_SLOTS[4],
--				ITEM_IN_SLOTS[5], ITEM_IN_SLOTS[6], 0, dialogStr )
			PushDebugMessage( "合成宝石需要放入宝石合成符。" )
			return
		end
	end

	LifeAbility : Do_Combine( ITEM_IN_SLOTS[1], ITEM_IN_SLOTS[2],
		ITEM_IN_SLOTS[3], ITEM_IN_SLOTS[4],
		ITEM_IN_SLOTS[5], ITEM_IN_SLOTS[6],(curSuccRate.."%") )
end

-- 点击取消或者关闭按钮
function MaterialCompound_Cancel_Clicked()
	MaterialCompound_Close()
	MaterialCompound_StopCareObject()
end

-- 关闭界面
function MaterialCompound_Close()
	this : Hide()
	MaterialCompound_Clear()
end

-- 清空界面元素
function MaterialCompound_Clear()
	Current = 0
	Type = -1
	Grade = -1
	Materalcompose_SuccessValue : SetText("#cFF0000成功率")
	Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
	Materalcompose_OK : Disable()

	for i = 1, SLOT_COUNT do
		STUFF_SLOTS[i] : SetActionItem(-1)

		if ITEM_IN_SLOTS[i] ~= -1 then
			LifeAbility : Lock_Packet_Item( ITEM_IN_SLOTS[i], 0 )
		end

		STUFF_SLOTS[i] : Enable()
		ITEM_IN_SLOTS[i] = -1
	end
	LifeAbility:ClearComposeItems();
	LaskPack[1] = -1
	LaskPack[2] = -1
	LaskPack[3] = -1
	LaskPack[4] = -1
	LaskPack[5] = -1
	LaskPack[6] = -1
end

-- 判断某个背包格子中的物品是否宝石
function MaterialCompound_IsGem( bagPos )
	if PlayerPackage : IsGem( bagPos ) == 1 then
		return 1
	else
		return 0
	end
end

-- 判断某个背包格子中的物品是否材料
function MaterialCompound_IsMaterial( bagPos )
	local MatIdentifier = PlayerPackage : GetItemSubTableIndex( bagPos, 0 ) * 100 + PlayerPackage : GetItemSubTableIndex( bagPos, 1 )
	if(PlayerPackage:GetItemTableIndex(bagPos)==20502009)then
		return 0
	end
	if MatIdentifier == 205 then
		return 1
	else
		return 0
	end
end

-- 得到某个背包格子中的物品的类型
function MaterialCompound_GetItemType( bagPos )
	if MaterialCompound_IsGem( bagPos ) == 1 then
		return ( PlayerPackage : GetItemSubTableIndex( bagPos, 2 ) * 1000 + PlayerPackage : GetItemSubTableIndex( bagPos, 3 ) )
	elseif MaterialCompound_IsMaterial( bagPos ) == 1 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 2 )
	elseif PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 2 )
	end

	return -1
end

-- 得到某个背包格子中的物品的等级
function MaterialCompound_GetItemGrade( bagPos )
	if MaterialCompound_IsGem( bagPos ) == 1 then
		return PlayerPackage : GetItemSubTableIndex( bagPos, 1 )
	elseif MaterialCompound_IsMaterial( bagPos ) == 1 then
		return PlayerPackage : GetItemGrade( bagPos )
	elseif PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		return PlayerPackage : GetItemGrade( bagPos )
	end

	return PlayerPackage : GetItemGrade( bagPos )
end

-- 得到当前界面应该匹配的特殊材料号
-- 如果不是宝石界面则返回 -1
-- 如果是宝石界面但是还没有放任何宝石则返回 -1
function MaterialCompound_GetSpecialMaterial()
	local CurrentRule = RuleTable[Current]
	if CurrentRule then
		if CurrentRule[Grade] then
			return CurrentRule[Grade].SpecialStuff
		end
	end

	return -1
end

-- 判断某个背包格子中的物品属于那个界面，匹配 Current，没有匹配的用 0
-- 界面的当前状态 1：宝石合成 2：材料合成
function MaterialCompound_ItemInterface( bagPos )
	if Current == 1 then
		if MaterialCompound_IsGem( bagPos ) == 1 then
			return Current
		end

		if PlayerPackage : GetItemTableIndex( bagPos ) == MaterialCompound_GetSpecialMaterial() then
			return Current
		end
	elseif Current == 2 then
		if MaterialCompound_IsMaterial( bagPos ) == 1 then
			return Current
		end
	elseif Current == 3 then
		if(PlayerPackage:GetItemTableIndex(bagPos)==20310110)then
			return Current
		end
	end

	return 0
end

-- 刷新合成界面上的物品
function MaterialCompound_Update( pos0, pos1 )
	local slot = tonumber( pos0 )
	local bagPos = tonumber( pos1 )

	-- AxTrace( 0, 1, "Current=".. Current )
	-- AxTrace( 0, 1, "slot=".. slot )
	-- AxTrace( 0, 1, "bagPos=".. bagPos )
	local CurrentRule = RuleTable[Current]
	if not CurrentRule then
		return
	end

	if not this : IsVisible() then					-- 界面未打开
		return
	end

	-- 验证物品有效性
	local bagItem = EnumAction( bagPos, "packageitem" )
	if bagItem : GetID() == 0 then
		return
	end

	-- AxTrace( 0, 1, "MaterialCompound_ItemInterface( bagPos )=".. MaterialCompound_ItemInterface( bagPos ) )
	-- 找到 bagPos 的物品类型，来判断是否符合当前界面，否则没有任何提示
	if MaterialCompound_ItemInterface( bagPos ) ~= Current then
		PushDebugMessage( "材料类型不符" )
		return
	end

	-- 如果 bagPos 是当前界面需要的物品，找到该物品应该处在的格子范围
	-- 如果是宝石或者材料
	if MaterialCompound_IsGem( bagPos ) == 1 or MaterialCompound_IsMaterial( bagPos ) == 1 or PlayerPackage:GetItemTableIndex(bagPos) == 20310110 then
		-- AxTrace( 0, 1, "it's a main material." )
		-- 判断一下是否类型相同，不相同给出提示
		if Type ~= -1 then
			if Type ~= MaterialCompound_GetItemType( bagPos ) then
				PushDebugMessage( CurrentRule.msgDiffTypeErr )
				return
			end
		end

		-- 判断一下是否档次相同，如果不相同给出提示
		if Grade ~= -1 then
			if Grade ~= MaterialCompound_GetItemGrade( bagPos ) then
				PushDebugMessage( CurrentRule.msgDiffGradeErr )
				return
			end
		elseif MaterialCompound_GetItemGrade( bagPos ) >= RuleTable[Current].maxGrade then
			PushDebugMessage( CurrentRule.msgGradeLimited )
			return
		end

		if slot == 0 then						-- 自动寻找空格
			-- 从 1 ~ MATERIAL_COUNT 之间找一个空着的格子，如果没有空格子了，则返回
			for i = 1, MATERIAL_COUNT do
				if ITEM_IN_SLOTS[i] == -1 then
					slot = i
					break
				end
			end

			-- AxTrace( 0, 1, "slot=".. slot )

			if slot == 0 then
				return
			end
		else
			-- 判断 bagPos 是否应该处在这个格子，格子不对则直接返回
			if slot < 1 or slot > MATERIAL_COUNT then
				return
			end
		end
	-- 如果是特殊材料
	elseif PlayerPackage : GetItemTableIndex( bagPos ) == MaterialCompound_GetSpecialMaterial() then
		-- AxTrace( 0, 1, "it's a special material." )
		if slot == 0 then						-- 自动寻找空格
			-- 看看第 SPECIAL_MATERIAL_SLOT 个格子是否空着的格子，如果不是，则返回
			if ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] and ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] == -1 then
				slot = SPECIAL_MATERIAL_SLOT
			else
				return
			end
		else
			-- 判断 bagPos 是否应该处在这个格子，格子不对则直接返回
			if slot ~= SPECIAL_MATERIAL_SLOT then
				PushDebugMessage( "请放置于特殊材料栏" )
				return
			end
		end
	end

	-- AxTrace( 0, 1, "ITEM_IN_SLOTS[slot]=".. ITEM_IN_SLOTS[slot] )
	-- 把物品放到格子上
	-- 如果原来的格子有物品，则移除原来的物品
	if ITEM_IN_SLOTS[slot] ~= -1 then
		MaterialCompound_Remove( slot )
	end

	-- 将本物品放到物品格，并锁定所在的背包格
	STUFF_SLOTS[slot] : SetActionItem( bagItem : GetID() )
	ITEM_IN_SLOTS[slot] = bagPos
	LifeAbility : Lock_Packet_Item( bagPos, 1 )

	if Type == -1 then
		Type = MaterialCompound_GetItemType( bagPos )
	end

	if Grade == -1 then
		Grade = MaterialCompound_GetItemGrade( bagPos )
	end

	-- 更新界面的成功率显示
	MaterialCompound_RecalcSuccOdds()

	-- 如果物品不是特殊材料，并且当前的类型和档次都是 -1，则根据该物品进行相应设置，并据此显示金钱消耗
	if PlayerPackage : GetItemTableIndex( bagPos ) ~= MaterialCompound_GetSpecialMaterial() then
		MaterialCompound_RecalcCost()
	end
end

-- 移除一个材料
function MaterialCompound_Remove( slot )
	if not this : IsVisible() then
		return
	end

	if slot < 1 or slot > SLOT_COUNT then
		return
	end

	if ITEM_IN_SLOTS[slot] == -1 then
		return
	end

	STUFF_SLOTS[slot] : SetActionItem( -1 )
	LifeAbility : Lock_Packet_Item( ITEM_IN_SLOTS[slot], 0 )
	ITEM_IN_SLOTS[slot] = -1

	if slot >= 1 and slot <= MATERIAL_COUNT then
		local materialCount = 0

		for i = 1, MATERIAL_COUNT do
			if ITEM_IN_SLOTS[i] ~= -1 then
				materialCount = materialCount + 1
			end
		end

		if materialCount == 0 then					-- 没有材料了则移除特殊材料
			Type = -1
			Grade = -1
			MaterialCompound_Remove( SPECIAL_MATERIAL_SLOT )
		end

		MaterialCompound_RecalcSuccOdds()
		MaterialCompound_RecalcCost()
	elseif slot == SPECIAL_MATERIAL_SLOT then
		MaterialCompound_RecalcSuccOdds()
	end
end

-- 重新计算成功率
function MaterialCompound_RecalcSuccOdds()
	if not RuleTable[Current] or not RuleTable[Current][Grade] then
		Materalcompose_SuccessValue : SetText("#cFF0000成功率")
		Materalcompose_OK : Disable()
		return
	end

	local currentRule = RuleTable[Current][Grade]
	local materialCount = 0

	for i = 1, MATERIAL_COUNT do
		if ITEM_IN_SLOTS[i] ~= -1 then
			materialCount = materialCount + 1
		end
	end

	-- AxTrace( 0, 1, "materialCount=".. materialCount )
	local str = "#cFF0000成功率:"

	if not currentRule.CountTable[materialCount] then
		curSuccRate = 0;
		str = str .. "无法合成"
		Materalcompose_OK : Disable()
	elseif ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] ~= -1
	 and currentRule.SpecialStuff == PlayerPackage : GetItemTableIndex( ITEM_IN_SLOTS[SPECIAL_MATERIAL_SLOT] )
	then
		-- AxTrace( 0, 1, "SuccOddsWithSpecStuff=".. currentRule.CountTable[materialCount].SuccOddsWithSpecStuff )
		str = str .. currentRule.CountTable[materialCount].SuccOddsWithSpecStuff .. "%"
		curSuccRate = currentRule.CountTable[materialCount].SuccOddsWithSpecStuff;
		Materalcompose_OK : Enable()
	else
		-- AxTrace( 0, 1, "SuccOdds=".. currentRule.CountTable[materialCount].SuccOdds )
		str = str .. currentRule.CountTable[materialCount].SuccOdds .. "%"
		curSuccRate = currentRule.CountTable[materialCount].SuccOdds;
		Materalcompose_OK : Enable()
	end

	Materalcompose_SuccessValue : SetText( str )
end

-- 重新计算金钱消耗
function MaterialCompound_RecalcCost()
	if not RuleTable[Current] or not RuleTable[Current][Grade] then
		Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	Materalcompose_NeedMoney : SetProperty( "MoneyNumber", tostring( RuleTable[Current][Grade].MoneyCost ) )
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function MaterialCompound_BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	-- AxTrace( 0, 1, "theNPC0: " .. theNPC )
	if theNPC == -1 then
		PushDebugMessage("未发现 NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "MaterialCompound" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function MaterialCompound_StopCareObject()
	this : CareObject( theNPC, 0, "MaterialCompound" )
	theNPC = -1
end

function MaterialCompound_IsBind( ItemID )

	if(GetItemBindStatus(ItemID, 0) == 1) then
		
		return 1;
		
	else
	
		return 0;
		
	end
	
end