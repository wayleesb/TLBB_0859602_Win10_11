local g_ItemMax = 0;
local g_ItemIdx = -1;

local ARR_PRICE = {};

local CU_MONEY			= 1	-- 钱
local CU_MONEYJZ		= 8 -- 交子

function Shop_BulkBuying_PreLoad()
	this:RegisterEvent("OPEN_BULKBUY_BOOTH");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function Shop_BulkBuying_OnLoad()
	ARR_PRICE[1] = Shop_BulkBuying_Money1;
	ARR_PRICE[2] = Shop_BulkBuying_Money2;
	ARR_PRICE[3] = Shop_BulkBuying_Money3;
end

function Shop_BulkBuying_OnEvent(event)
	if(event == "OPEN_BULKBUY_BOOTH") then
		Shop_BulkBuying_Open(tonumber(arg0));
	elseif(event == "CLOSE_BOOTH") then
		this:Hide();
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		local tmpjz = 0;
		if(NpcShop:GetShopType("unit") == CU_MONEYJZ) then
			tmpjz = playerMoneyJZ;
		end
		Shop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", math.min(2147483647, playerMoney + tmpjz));
		Shop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
		Shop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
	end
end

function Shop_BulkBuying_Open( idx )
	--商店是消耗金钱的
	local i = 0;
	if(NpcShop:GetShopType("unit") == CU_MONEY) then
		--这个位置的物品的叠加数量是大于1的
		g_ItemMax = NpcShop:GetBulkBuyLimit(idx);
		--if(g_ItemMax > 1) then
			--符合条件，显示界面
			for i = 1, 2 do
					ARR_PRICE[i]:SetProperty("GoldIcon", "set:Button2 image:Icon_GoldCoin")
				  ARR_PRICE[i]:SetProperty("SilverIcon", "set:Button2 image:Icon_SilverCoin")
				  ARR_PRICE[i]:SetProperty("CopperIcon", "set:Button2 image:Icon_CopperCoin")
			end
			Shop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			g_ItemIdx = idx;
			local price = NpcShop:EnumItemPrice(g_ItemIdx);
			local playerMoney = Player:GetData("MONEY");
			local playerMoneyJZ = Player:GetData("MONEY_JZ");
			--需要花费
			Shop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", playerMoney);
			Shop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
			--物品单价
			Shop_BulkBuying_Money1:SetProperty("MoneyNumber", math.max(0, price));
			--身体携带
			Shop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
			Shop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
			--数量
			Shop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			Shop_BulkBuying_IME:SetText(tostring(math.min(20, g_ItemMax)));
			Shop_BulkBuying_IME:SetSelected( 0, -1 );
			--名称
			Shop_BulkBuying_PageHeader:SetText("#gFF0FA0"..NpcShop:EnumItemName(g_ItemIdx));
			Shop_BulkBuying_TextChanged();
			this:Show();
		--end
	end
	
	--商店是优先扣交子的
	if(NpcShop:GetShopType("unit") == CU_MONEYJZ) then
		--这个位置的物品的叠加数量是大于1的
		g_ItemMax = NpcShop:GetBulkBuyLimit(idx);
		--if(g_ItemMax > 1) then
			--符合条件，显示界面
			for i = 1, 2 do
					ARR_PRICE[i]:SetProperty("GoldIcon", "set:Button6 image:Lace_JiaoziJin")
				  ARR_PRICE[i]:SetProperty("SilverIcon", "set:Button6 image:Lace_JiaoziYin")
				  ARR_PRICE[i]:SetProperty("CopperIcon", "set:Button6 image:Lace_JiaoziTong")
			end
			Shop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			g_ItemIdx = idx;
			local price = NpcShop:EnumItemPrice(g_ItemIdx);
			local playerMoney = Player:GetData("MONEY");
			local playerMoneyJZ = Player:GetData("MONEY_JZ");
			--需要花费
			Shop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", math.min(2147483647, playerMoney + playerMoneyJZ));
			Shop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
			--物品单价
			Shop_BulkBuying_Money1:SetProperty("MoneyNumber", math.max(0, price));
			--身体携带
			Shop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
			Shop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
			--数量
			Shop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			Shop_BulkBuying_IME:SetText(tostring(math.min(20, g_ItemMax)));
			Shop_BulkBuying_IME:SetSelected( 0, -1 );
			--名称
			Shop_BulkBuying_PageHeader:SetText("#gFF0FA0"..NpcShop:EnumItemName(g_ItemIdx));
			Shop_BulkBuying_TextChanged();
			this:Show();
		--end
	end
		
end

function Shop_BulkBuying_Accept_Clicked()
	if not Shop_BulkBuying_TextChanged() then
		PushDebugMessage(GetDictionaryString("STACK999_INVALID_QUANTITY"));
		return;
	end
	NpcShop:BulkBuyItem(g_ItemIdx, tonumber(Shop_BulkBuying_IME:GetText()));
	this:Hide();
end

function Shop_BulkBuying_TextChanged()
	local num = tonumber(Shop_BulkBuying_IME:GetText());
	local limit = NpcShop:GetBulkBuyLimit(g_ItemIdx);
	Shop_BulkBuying_Accept:SetProperty("Disabled", "True");
	Shop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
	if not num or num ~= math.floor(num) or num < 1 or num > limit then
		Shop_BulkBuying_Money2:SetText(GetDictionaryString("STACK999_INVALID_QUANTITY"));
		return false;
	end
	local unitPrice = NpcShop:EnumItemPrice(g_ItemIdx);
	local price = unitPrice * num;
	if unitPrice < 0 or price > 2147483647 then
		Shop_BulkBuying_Money2:SetText(GetDictionaryString("STACK999_PRICE_OUT_OF_RANGE"));
		return false;
	end
	Shop_BulkBuying_Money2:SetProperty("MoneyNumber", math.max(0, price));
	Shop_BulkBuying_Accept:SetProperty("Disabled", "False");
	return true;
end
