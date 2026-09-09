local g_ItemMax = 0;
local g_ItemIdx = -1;

local ARR_PRICE = {};

local CU_ZENGDIAN			= 6	-- 赠点

function ZdShop_BulkBuying_PreLoad()
	this:RegisterEvent("OPEN_BULKBUY_BOOTH_ZD");
	this:RegisterEvent("UPDATE_ZENGDIAN");
	this:RegisterEvent("CLOSE_BOOTH");
end

function ZdShop_BulkBuying_OnLoad()
	ARR_PRICE[1] = Shop_BulkBuying_Money1;
	ARR_PRICE[2] = Shop_BulkBuying_Money2;
	ARR_PRICE[3] = Shop_BulkBuying_Money3;
end

function ZdShop_BulkBuying_OnEvent(event)
	if(event == "OPEN_BULKBUY_BOOTH_ZD") then
		ZdShop_BulkBuying_Open(tonumber(arg0));
	elseif(event == "CLOSE_BOOTH") then
		this:Hide();
	elseif( (event == "UPDATE_ZENGDIAN" ) and this:IsVisible()) then
		local playerZengDian = Player:GetData("ZENGDIAN");
		ZdShop_BulkBuying_Money3:SetText(playerZengDian);
	end
end

function ZdShop_BulkBuying_Open( idx )
	--商店是消耗金钱的
	local i = 0;
	if(NpcShop:GetShopType("unit") == CU_ZENGDIAN) then
		--这个位置的物品的叠加数量是大于1的
		g_ItemMax = NpcShop:EnumItemMaxOverlay(idx);
		--if(g_ItemMax > 1) then
			--符合条件，显示界面
		
			ZdShop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			g_ItemIdx = idx;
			local price = NpcShop:EnumItemPrice(g_ItemIdx);
			--local playerZengDian = Player:GetData("IPREGION");
			local playerZengDian = Player:GetData("ZENGDIAN");
			--需要花费
			--Shop_BulkBuying_Money2:SetProperty("MoneyMaxNumber", playerMoney);
			ZdShop_BulkBuying_Money2:SetText(price*20);
			--物品单价
			ZdShop_BulkBuying_Money1:SetText(price);
			--身体携带
			ZdShop_BulkBuying_Money3:SetText(playerZengDian);
			--数量
			ZdShop_BulkBuying_IME:SetProperty("DefaultEditBox", "True");
			ZdShop_BulkBuying_IME:SetText("20");
			ZdShop_BulkBuying_IME:SetSelected( 0, -1 );
			--名称
			ZdShop_BulkBuying_PageHeader:SetText("#gFF0FA0"..NpcShop:EnumItemName(g_ItemIdx));
			this:Show();
		--end
	end
	
		
end

function ZdShop_BulkBuying_Accept_Clicked()
	--购买多个
	local num = tonumber(ZdShop_BulkBuying_IME:GetText());
	if(nil ~= num) then
		if( tonumber( num ) == 0  ) then
		else
			NpcShop:BulkBuyItem(g_ItemIdx, num);
		end
	end
	this:Hide();
end

function ZdShop_BulkBuying_TextChanged()
	local num = tonumber(ZdShop_BulkBuying_IME:GetText());
	if(nil == num or(num and num < 0)) then 
		ZdShop_BulkBuying_Money2:SetText(0);
		return; 
	end
	
	if(num > 20) then
		num = 20;
	end
	if(num == 0) then
		ZdShop_BulkBuying_Money2:SetText(0);
	end
	--if(tostring(num) ~= Shop_BulkBuying_IME:GetText())then --让金钱随时更新,by hukai#38377
		local price = NpcShop:EnumItemPrice(g_ItemIdx)*num;
		ZdShop_BulkBuying_Money2:SetText(price);
		ZdShop_BulkBuying_IME:SetTextOriginal(num); --修改原来的bug，递归调用导致客户端脚本系统死掉
	--end
	
end