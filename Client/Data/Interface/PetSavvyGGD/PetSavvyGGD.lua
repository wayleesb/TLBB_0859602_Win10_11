-- PetSavvyGGD.lua
-- 珍兽合成界面

local mainPet = { idx = -1, guid = { high = -1, low = -1 } }
local assisPet = { idx = -1, guid = { high = -1, low =-1 } }

local theNPC = -1													-- 功能 NPC
local MAX_OBJ_DISTANCE = 3.0

local currentChoose = -1

local moneyCosts = {													-- 索引是珍兽的当前悟性值
	[0] = 100,
	[1] = 110,
	[2] = 121,
	[3] = 133,
	[4] = 146,
	[5] = 161,
	[6] = 177,
	[7] = 194,
	[8] = 214,
	[9] = 235,
}

function PetSavvyGGD_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- 玩家从列表选定一只珍兽
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- 玩家身上的珍兽数据发生变化，包括增加一只珍兽
	this : RegisterEvent( "DELETE_PET" )							-- 玩家身上减少一只珍兽
	this : RegisterEvent( "OBJECT_CARED_EVENT" )					-- 关心 NPC 的存在和范围
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		--交子普及 Vega
end

function PetSavvyGGD_OnLoad()
	PetSavvyGGD_Clear()
end


function PetSavvyGGD_OK_Clicked()
	-- 首先判定玩家是否放入需要提升的珍兽，如果没有放入NPC将会弹出对话并返回：
	if mainPet.idx == -1 then
	-- 请放入您要提升悟性等级的珍兽。
		ShowSystemTipInfo( "请放入您要提升悟性等级的珍兽。" )
		return
	end

	-- 判定玩家的金钱是否足够，如果不够将会弹出对话。
	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end	

	-- 您的金钱不足，请确认
	local selfMoney = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--交子普及 Vega
	if selfMoney < cost then
		ShowSystemTipInfo( "您的金钱不足，请确认。" )
		return
	end
	
	--检查 跟骨 丹
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	AxTrace(0,0,"nSavvyNeed:"..nSavvyNeed);
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "低";
		nItemIdGenGuDan = 30502000;
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "中"
		nItemIdGenGuDan = 30502001;
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "高"
		nItemIdGenGuDan = 30502002;
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	
	if bExist <= 0 then
		local msg = "提升该珍兽悟性到"..nSavvyNeed.."需要"..msgTemp.."级根骨丹。";
		PetSavvyGGD_GGD : SetText( msg );
		SetNotifyTip( msg );
		return;
	end
	
	-- 发送 UI_Command 进行合成
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetSavvy" )
		Set_XSCRIPT_ScriptID( 800106 )
		Set_XSCRIPT_Parameter( 0, mainPet.guid.high )
		Set_XSCRIPT_Parameter( 1, mainPet.guid.low )		
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
		
	
end

function PetSavvyGGD_Cancel_Clicked()
	this : Hide()
end

function PetSavvyGGD_SelectPet( petIdx )
	if -1 == petIdx then
		return
	end
	
	local petName = Pet : GetPetList_Appoint( petIdx )
	local guidH, guidL = Pet : GetGUID( petIdx )

	-- 判断 petIdex 代表的是被提升的宠还是辅助宠
	-- 如果是被提升的宠

		-- 如果原来已经选择了一个被提升的宠
		-- 则清空原来的数据
		PetSavvyGGD_RemoveMainPet()

		-- XX 如果原来就有辅助宠并且辅助宠不符合新的条件
		-- XX 则清空辅助宠的数据
		-- 记录该宠的位置号、GUID
		mainPet.idx = petIdx
		mainPet.guid.high = guidH
		mainPet.guid.low = guidL
		
		local savvy = Pet : GetSavvy( mainPet.idx )
		
		if savvy <=9 then
			-- 将珍兽名字填到文本框中
			PetSavvyGGD_Pet : SetText( petName )
			-- 给珍兽上锁
			Pet : SetPetLocation( petIdx, 3 )
		else
			--悟性大于9就不能再提升了....
			PetSavvyGGD_Pet : SetText( "" )
			PetSavvyGGD_GGD : SetText( "" )
			PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", 0 )
			PetSavvyGGD_Text2 : SetText( "无法提升" )
			PetSavvyGGD_OK:Disable();
			return
		end

	-- 更新金钱和几率显示
	PetSavvyGGD_CalcSuccOdds()
	PetSavvyGGD_CalcCost()
	
	local savvy = Pet : GetSavvy( mainPet.idx )
	--检查 跟骨 丹
	local nSavvyNeed = savvy+1;	
	local nItemIdGenGuDan = 0;
	local msgTemp;
	
	AxTrace(0,0,"nSavvyNeed:"..nSavvyNeed);
	if nSavvyNeed >= 1 and nSavvyNeed <= 3 then
		msgTemp = "低";		
	elseif nSavvyNeed >= 4 and nSavvyNeed <= 6 then
		msgTemp = "中"		
	elseif nSavvyNeed >= 7 and nSavvyNeed <= 10 then
		msgTemp = "高"		
	end
	
	local bExist = IsItemExist( nItemIdGenGuDan );
	
	if bExist <= 0 then
		local msg = "提升该珍兽悟性到"..nSavvyNeed.."需要"..msgTemp.."级根骨丹。";
		PetSavvyGGD_GGD : SetText( msg );		
		return;
	end
	
end

function PetSavvyGGD_OnEvent(event)
	if event == "UI_COMMAND" and tonumber( arg0 ) == 19820425 then	-- 打开界面
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end

		this : Show()
		PetSavvyGGD_Pet : SetText( "" )
		PetSavvyGGD_Text2 : SetText( "" )
		PetSavvyGGD_NeedMoney:SetProperty("MoneyNumber", tostring(0));
		local npcObjId = Get_XParam_INT( 0 )
		BeginCareObject( npcObjId )
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		PetSavvyGGD_OK:Disable();
		return
	end
	
	if event == "REPLY_MISSION_PET" then		-- 玩家选了一只珍兽
		PetSavvyGGD_GGD : SetText( "" );
		PetSavvyGGD_SelectPet( tonumber( arg0 ) )
	
		PetSavvyGGD_SelfMoney_Text:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "UPDATE_PET_PAGE" and this : IsVisible() then		-- 玩家身上的珍兽数据发生变化，包括增加一只珍兽
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "DELETE_PET" and this : IsVisible() then			-- 玩家身上减少一只珍兽
		PetSavvyGGD_UpdateSelected()
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		return
	end

	if event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- 关心 NPC 的存在和范围
		Pet : ShowPetList( 0 )
		if tonumber( arg0 ) ~= theNPC then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			
			PetSavvyGGD_Cancel_Clicked()
		end
		return
	end
	if (event == "UNIT_MONEY" and this:IsVisible()) then
		PetSavvyGGD_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
	if (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetSavvyGGD_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	end
	
end

function PetSavvyGGD_Choose_Clicked( type )

	-- 关一下再开，清空数据
	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end


function PetSavvyGGD_Close()
	Pet : ShowPetList( 0 )
	StopCareObject()
	PetSavvyGGD_Clear()
end

function PetSavvyGGD_RemoveMainPet()
	if mainPet.idx ~= -1 then
		Pet : SetPetLocation( mainPet.idx, -1 )
	end

	mainPet.idx = -1
	mainPet.guid.high = -1
	mainPet.guid.low = -1
end

function PetSavvyGGD_Clear()
	PetSavvyGGD_RemoveMainPet()
	
	PetSavvyGGD_GGD : SetText( "" );
	PetSavvyGGD_Pet : SetText( "" );
	PetSavvyGGD_Text2 : SetText( "#cFF0000成功率" )
	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )

	PetSavvyGGD_OK : Disable()

	currentChoose = -1
end

function PetSavvyGGD_Check()
	if mainPet.idx == -1 or assisPet.idx == -1 then
		return 0
	end

	if mainPet.idx == assisPet.idx then
		ShowSystemTipInfo( "请放入两只不同的珍兽。" )
		return 0
	end

	-- 判定参与珍兽的携带等级是否大于等于需要提升的珍兽的携带等级，如果不是，则弹出对话并返回：
	local mainCarryLevel = Pet : GetTakeLevel( mainPet.idx )
	local assisCarryLevel = Pet : GetTakeLevel( assisPet.idx )
	if assisCarryLevel < mainCarryLevel then
		-- 您的参与合成的珍兽携带等级为a，必须要找携带等级大于等于b的才能参与合成。（a为参与合成珍兽的携带等级、b为需要提升的珍兽的携带等级）
		ShowSystemTipInfo( "您的参与合成的珍兽携带等级为" .. assisCarryLevel .. "，必须要找携带等级大于等于" .. mainCarryLevel .. "的才能参与合成。" )
		return 0
	end

	-- 判定参与合成的珍兽的根骨是否大于等于需要提升的珍兽的悟性等级，如果判定不成立则弹出对话并返回：
	local savvy = Pet : GetSavvy( mainPet.idx )
	local con = Pet : GetBasic( assisPet.idx )
	if con < savvy then
		-- 参与合成的珍兽的根骨必须大于等于a（a为需要提升的珍兽的悟性等级）
		ShowSystemTipInfo( "参与合成的珍兽的根骨必须大于等于" .. savvy .. "。" )
		return 0
	end

	return 1
end

-- 计算成功率
function PetSavvyGGD_CalcSuccOdds()
	if mainPet.idx == -1 then
		PetSavvyGGD_Text2 : SetText( "#cFF0000成功率" )
		PetSavvyGGD_OK : Disable()
		return
	end

	succOdds = {													-- 索引是珍兽的当前悟性值
		[0] = 1000,
		[1] = 850,
		[2] = 750,
		[3] = 600,
		[4] = 200,
		[5] = 310,
		[6] = 310,
		[7] = 30,
		[8] = 70,
		[9] = 100,
	}

	local savvy = Pet : GetSavvy( mainPet.idx )
	local str = "#cFF0000"
	local odds = succOdds[savvy]
	if not odds then
		str = "无法提升"
		PetSavvyGGD_OK : Disable()
	else
		str = str .. math.floor( odds / 10 ) .. "%"
		PetSavvyGGD_OK : Enable()
	end

	PetSavvyGGD_Text2 : SetText( str )
end

-- 计算金钱消耗
function PetSavvyGGD_CalcCost()
	if mainPet.idx == -1 then
		PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( 0 ) )
		return
	end

	local savvy = Pet : GetSavvy( mainPet.idx )
	local cost = moneyCosts[savvy]
	if not cost then
		cost = 0
	end

	PetSavvyGGD_NeedMoney : SetProperty( "MoneyNumber", tostring( cost ) )
end


function PetSavvyGGD_UpdateSelected()
	-- 判断被选中的珍兽是否还在背包里
	if mainPet.idx ~= -1 then
		local newIdx = Pet : GetPetIndexByGUID( mainPet.guid.high, mainPet.guid.low )
		-- AxTrace( 0, 1, "newIdx=".. newIdx )

		-- 如果不在则删掉
		if newIdx == -1 then
			mainPet.idx = -1
			mainPet.guid.high = -1
			mainPet.guid.low = -1
			PetSavvyGGD_Pet : SetText( "" )
		-- 否则判断珍兽的位置是否发生变化
		elseif newIdx ~= mainPet.idx then
			-- 如果发生变化则对位置进行更新
			mainPet.idx = newIdx
		end
	end

	PetSavvyGGD_SelectPet( mainPet.idx );
	
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject( objCaredId )
	theNPC = DataPool : GetNPCIDByServerID( objCaredId )
	if theNPC == -1 then
		PushDebugMessage("未发现 NPC")
		this : Hide()
		return
	end

	this : CareObject( theNPC, 1, "PetSavvyGGD" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject()
	this : CareObject( theNPC, 0, "PetSavvyGGD" )
	Pet : ShowPetList( 0 )
	theNPC = -1
end
