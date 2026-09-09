--UI COMMAND ID 19824 by hukai 39440~39446

local g_clientNpcId = -1;

local g_MedicineHCID = -1;	--合成的灵兽丹ID
local g_ConsumeMoney = -1;	--需要的金钱
local g_NotifyBind = 1;
local PetMedicineHC_BTN = {};

function PetMedicineHC_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("PETMEDICINEHC");
	this:RegisterEvent("RESUME_ENCHASE_GEM") --知道为什么要这个消息吗，因为从合成框拖动到背包都是走特殊逻辑，从ClientLib到Game里面的Gxx编号都很恶心，龌龊
	
end

function PetMedicineHC_OnLoad()
	PetMedicineHC_BTN[1] = {PetMedicineHC_Space1, -1}; --{控件名,物品索引值}
	PetMedicineHC_BTN[2] = {PetMedicineHC_Space2, -1};
	PetMedicineHC_BTN[3] = {PetMedicineHC_Space3, -1};
	PetMedicineHC_BTN[4] = {PetMedicineHC_Space4, -1};
	PetMedicineHC_BTN[5] = {PetMedicineHC_Space5, -1};
end

function PetMedicineHC_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 19824) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end
		PetMedicineHC_Clear()
		PetMedicineHC_OnShow()

		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("未发现 NPC")
			PetMedicineHC_Close()
			return
		end
		
		this : CareObject( g_clientNpcId, 1, "PetMedicineHC" )
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			PetMedicineHC_Close()
		end
	
	elseif (event == "PETMEDICINEHC" and this:IsVisible()) then
		if( arg0 == nil or arg1 == nil ) then
			return;
		end
		
		PetMedicineHC_UpdateGoods(tonumber(arg0),tonumber(arg1))
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		PetMedicineHC_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		PetMedicineHC_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	elseif event == "RESUME_ENCHASE_GEM" and this:IsVisible() then
		--67~71之间
		PetMedicineHC_CancelGoods(tonumber(arg0)-66)
	end

end

function PetMedicineHC_OnShow()
	PetMedicineHC_SelfMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")))
	PetMedicineHC_SelfJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")))
	this : Show()
end

function PetMedicineHC_UpdateGoods(nUIPos, nGoodsIndex)
	
	--是否加锁....
	if PlayerPackage:IsLock(nGoodsIndex) == 1 then
		PushDebugMessage("#{Item_Locked}")
		return
	end
	
	local goodsID = PlayerPackage : GetItemTableIndex( nGoodsIndex )
	
	if g_MedicineHCID ~= -1 and g_MedicineHCID ~= goodsID then --前面已经选了一个物品
		PushDebugMessage("#{JNHC_81015_15}")
		return
	end
	
	if nUIPos == 0 then --自动寻找一个空的位置
		for i = 1, 5 do
			if PetMedicineHC_BTN[i][2] == -1 then
				nUIPos = i
				break
			end
		end
		
		if nUIPos == 0 then--没找到说明放满了
			return
		end
	end
	
	if nUIPos < 0 or nUIPos > 5 then
		return
	end
	
	local AfterMedicineHC,Money = Pet:GetPetPetMedicineHC(goodsID)
	--表里面没有的就不是灵兽丹
	if not AfterMedicineHC or not Money or AfterMedicineHC == -100 or Money == -100 then --100是程序里面写的返回值，区分于表里面填的-1
		PushDebugMessage("#{JNHC_81015_13}")
		return
	end
	
	--表里面有但是合成后ID是-1的表示暂不开放的，目前合成最高开放到2级合3级
	if AfterMedicineHC == -1 or Money == -1 then
		PushDebugMessage("#{JNHC_81015_14}")
		return
	end
	
	--先取消前面放入的物品的效果
	PetMedicineHC_CancelGoods(nUIPos)
	--放入新物品
	g_MedicineHCID = goodsID
	g_ConsumeMoney = Money
	
	--PushDebugMessage("g_MedicineHCID "..g_MedicineHCID.." g_ConsumeMoney "..g_ConsumeMoney)
	
	local theAction = EnumAction(nGoodsIndex, "packageitem");
	if theAction:GetID() ~= 0 then
		PetMedicineHC_BTN[nUIPos][1]:SetActionItem(theAction:GetID());
	end
	PetMedicineHC_BTN[nUIPos][2] = nGoodsIndex;
	LifeAbility : Lock_Packet_Item(nGoodsIndex,1);
	
	--PushDebugMessage("btn "..PetMedicineHC_BTN[nUIPos][2])
	
	--是否放最后一个
	for i = 1, 5 do
		if PetMedicineHC_BTN[i][2] == -1 then
			return
		end
	end
	
	PetMedicineHC_NeedMoney:SetProperty("MoneyNumber", tostring(g_ConsumeMoney))--设置需要金钱框数值
	PetMedicineHC_OK:Enable()
	PetMedicineHC_SuccessValue:SetText("#cFF0000成功率 100％")
	g_NotifyBind = 1
end

function PetMedicineHC_Cancel_Clicked()
	PetMedicineHC_Close()
end

function PetMedicineHC_CancelGoods(nGoodsIndex)
	if nGoodsIndex >=1 and nGoodsIndex <= 5 then
		PetMedicineHC_BTN[nGoodsIndex][1]:SetActionItem(-1) --清除界面
		if PetMedicineHC_BTN[nGoodsIndex][2] ~= -1 then
			LifeAbility : Lock_Packet_Item(PetMedicineHC_BTN[nGoodsIndex][2],0);
		end
		PetMedicineHC_BTN[nGoodsIndex][2] = -1							--清除对应物品索引
		
		--所有界面都清除了，则设置按钮不可用
		local isfindempty = 0
		for i = 1, 5 do
			if PetMedicineHC_BTN[i][2] == -1 then
				isfindempty = 1
				break
			end
		end
		
		if isfindempty == 1 then
			g_MedicineHCID = -1;
			g_ConsumeMoney = -1
			PetMedicineHC_OK:Disable()
			PetMedicineHC_SuccessValue:SetText("无法合成")
		end
		
	end
end

function PetMedicineHC_Clear()
	g_MedicineHCID = -1;
	g_ConsumeMoney = -1;
	g_NotifyBind = 1;
	
	for i = 1, 5 do
		PetMedicineHC_CancelGoods(i)
	end

	--PetMedicineHC_OK:Disable()
	PetMedicineHC_SelfMoney:SetProperty("MoneyNumber", "")
	PetMedicineHC_SelfJiaozi:SetProperty("MoneyNumber", "")
	PetMedicineHC_NeedMoney:SetProperty("MoneyNumber", "")
	--PetMedicineHC_SuccessValue:SetText("无法合成")
end

function PetMedicineHC_Close()
	this:Hide()
	this:CareObject(g_clientNpcId, 0, "PetMedicineHC")
	g_clientNpcId = -1
	PetMedicineHC_Clear()
end

function PetMedicineHC_Frame_OnHiden()
	PetMedicineHC_Close()
end

function PetMedicineHC_OK_Clicked()
	
	if g_ConsumeMoney < 0 then
		return
	end
	
	--检测物品索引，检测绑定状态
	local bHaveBind = 0
	for i = 1, 5 do
		if PetMedicineHC_BTN[i][2] == -1 then
			return
		end
		if GetItemBindStatus( PetMedicineHC_BTN[i][2] ) == 1 then
			bHaveBind = 1
		end
	end
	
	--是否金钱足够
	if Player:GetData("MONEY")+Player:GetData("MONEY_JZ") < g_ConsumeMoney then
		PushDebugMessage("#{JNHC_81015_18}#{_EXCHG"..g_ConsumeMoney.."}。")
		return
	end
	
	--如果有绑定的则需要提示
	if bHaveBind == 1 and g_NotifyBind == 1 then
		GameProduceLogin:ShowMessageBox("#{JNHC_81015_19}","OK", "-1")
		g_NotifyBind = 0
		return
	end
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("PetMedicineHC");
		Set_XSCRIPT_ScriptID(311112);
		for i = 1, 5 do
			Set_XSCRIPT_Parameter(i-1,PetMedicineHC_BTN[i][2]);
		end
		Set_XSCRIPT_ParamCount(5);
	Send_XSCRIPT();
	
	--合成界面不关闭
	PetMedicineHC_Clear()
	PetMedicineHC_OnShow()
	
end