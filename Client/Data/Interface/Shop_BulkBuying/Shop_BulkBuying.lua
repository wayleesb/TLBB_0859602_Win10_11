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
		Shop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", playerMoney + tmpjz);
		Shop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
		Shop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
	end
end

function Shop_BulkBuying_Open( idx )
	--商店是消耗金钱的
	local i = 0;
	if(NpcShop:GetShopType("unit") == CU_MONEY) then
		--这个位置的物品的叠加数量是大于1的
		g_ItemMax = NpcShop:EnumItemMaxOverlay(idx);
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
			Shop_BulkBuying_Money2:SetProperty("MoneyNumber", price*20);
			--物品单价
			Shop_BulkBuying_Money1:SetProperty("MoneyNumber", price);
			--身体携带
			Shop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
			Shop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
			--数量
			Shop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			Shop_BulkBuying_IME:SetText("20");
			Shop_BulkBuying_IME:SetSelected( 0, -1 );
			--名称
			Shop_BulkBuying_PageHeader:SetText("#gFF0FA0"..NpcShop:EnumItemName(g_ItemIdx));
			this:Show();
		--end
	end
	
	--商店是优先扣交子的
	if(NpcShop:GetShopType("unit") == CU_MONEYJZ) then
		--这个位置的物品的叠加数量是大于1的
		g_ItemMax = NpcShop:EnumItemMaxOverlay(idx);
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
			Shop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
			Shop_BulkBuying_Money2:SetProperty("MoneyNumber", price*20);
			--物品单价
			Shop_BulkBuying_Money1:SetProperty("MoneyNumber", price);
			--身体携带
			Shop_BulkBuying_Money3:SetProperty("MoneyNumber", playerMoney);
			Shop_BulkBuying_Money4:SetProperty("MoneyNumber", playerMoneyJZ);
			--数量
			Shop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			Shop_BulkBuying_IME:SetText("20");
			Shop_BulkBuying_IME:SetSelected( 0, -1 );
			--名称
			Shop_BulkBuying_PageHeader:SetText("#gFF0FA0"..NpcShop:EnumItemName(g_ItemIdx));
			this:Show();
		--end
	end
		
end

function Shop_BulkBuying_Accept_Clicked()
	--购买多个
	local num = tonumber(Shop_BulkBuying_IME:GetText());
	if(nil ~= num) then
		if( tonumber( num ) == 0  ) then
		else
			NpcShop:BulkBuyItem(g_ItemIdx, num);
		end
	end
	this:Hide();
end

function Shop_BulkBuying_TextChanged()
	local num = tonumber(Shop_BulkBuying_IME:GetText());
	if(nil == num or(num and num < 0)) then 
		Shop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
		return; 
	end
	
	if(num > 20) then
		num = 20;
	end
	if(num == 0) then
		Shop_BulkBuying_Money2:SetText("");
		Shop_BulkBuying_Money2:SetProperty("MoneyNumber", 0);
	end
	--if(tostring(num) ~= Shop_BulkBuying_IME:GetText())then --让金钱随时更新,by hukai#38377
		local price = NpcShop:EnumItemPrice(g_ItemIdx)*num;
		Shop_BulkBuying_Money2:SetProperty("MoneyNumber", price);
		Shop_BulkBuying_IME:SetTextOriginal(num); --修改原来的bug，递归调用导致客户端脚本系统死掉
	--end
	
end