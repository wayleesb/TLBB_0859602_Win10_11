
local g_nSaveOrGetMoney;

local SAVE_MONEY				= 1;
local GET_MONEY					= 2;
local EXCHANGE_MONEY 		= 3;
local STALLSALE_PRICE		= 4;
local STALLSALE_REPRICE	= 5;
local PS_PRICE_ITEM		  = 6;
local PS_IMMITBASE			= 7;
local PS_IMMIT					= 8;
local PS_DRAW						= 9;
local STALL_PET_UP			= 10;
local STALL_PRICE_PET		= 11;
local PS_PRICE_PET			= 12;
local PS_TRANSFER				= 13;
local SAFEBOX_GET_MONEY = 14;
local SAFEBOX_SAVE_MONEY= 15;

--修改摊位物品价格需要的
local nStallItemID = -1;
local nStallItemIndex = -1;

--===============================================
-- OnLoad()
--===============================================
function InputMoney_PreLoad()
	this:RegisterEvent("TOGLE_INPUT_MONEY");
	
	this:RegisterEvent("BEING_MONEY");
	this:RegisterEvent("CLOSE_INPUT_MONEY");
	
end

function InputMoney_OnLoad()
	
end

--===============================================
-- OnEvent
--===============================================
function InputMoney_OnEvent(event)

	if(event == "TOGLE_INPUT_MONEY") then
		if(arg0~="price")then
			StallSale:UnlockSelItem();
		end
		if (arg0 == "get") then
			this:TogleShow();
			
			
			g_nSaveOrGetMoney = GET_MONEY;
			InputMoney_Title:SetText("#gFF0FA0取  钱");
			InputMoney_Accept_Button:SetText("确定");
			
		elseif (arg0 == "save") then
			this:TogleShow();
			
			g_nSaveOrGetMoney = SAVE_MONEY;
			InputMoney_Title:SetText("#gFF0FA0存  钱");
			InputMoney_Accept_Button:SetText("确定");
			
		elseif (arg0 == "exch") then
			this:TogleShow();
		
			g_nSaveOrGetMoney = EXCHANGE_MONEY;
			InputMoney_Title:SetText("#gFF0FA0输入交易金钱");
			InputMoney_Accept_Button:SetText("确定");
			
		elseif (arg0 == "get_safebox") then
			this:TogleShow();
		
			g_nSaveOrGetMoney = SAFEBOX_GET_MONEY;
			InputMoney_Title:SetText("#gFF0FA0输入取钱的数量");
			InputMoney_Accept_Button:SetText("确定");
		
		elseif (arg0 == "save_safebox") then
			this:TogleShow();
		
			g_nSaveOrGetMoney = SAFEBOX_SAVE_MONEY;
			InputMoney_Title:SetText("#gFF0FA0输入存钱的数量");
			InputMoney_Accept_Button:SetText("确定");
		
		elseif (arg0 == "price") then
			this:Show();
			
			g_nSaveOrGetMoney = STALLSALE_PRICE;
			InputMoney_Title:SetText("#gFF0FA0商品报价");
			InputMoney_Accept_Button:SetText("上架");
			
		elseif (arg0 == "reprice") then
			this:TogleShow();
			
			g_nSaveOrGetMoney = STALLSALE_REPRICE;
			InputMoney_Title:SetText("#gFF0FA0修改报价");
			InputMoney_Accept_Button:SetText("更改");
			
		--玩家商店上架(物品)
		elseif (arg0 == "ps_upitem" ) then
			this:Show();
			g_nSaveOrGetMoney = PS_PRICE_ITEM;
			InputMoney_Title:SetText("#gFF0FA0商品价格");
			InputMoney_Accept_Button:SetText("上架");
			
		elseif (arg0 == "ps_uppet" ) then
			this:Show();
			g_nSaveOrGetMoney = PS_PRICE_PET;
			InputMoney_Title:SetText("#gFF0FA0珍兽价格");
			InputMoney_Accept_Button:SetText("上架");
		
--		--玩家商店冲入本金
--		elseif (arg0 == "immitbase") then
--			this:Show();
--			g_nSaveOrGetMoney = PS_IMMITBASE;
--			InputMoney_Title:SetText("#gFF0FA0充入本金");
--			InputMoney_Accept_Button:SetText("确定");
--		
--		--玩家商店冲入
--		elseif (arg0 == "immit") then
--			this:Show();
--			g_nSaveOrGetMoney = PS_IMMIT;
--			InputMoney_Title:SetText("#gFF0FA0充入");
--			InputMoney_Accept_Button:SetText("确定");
--		
--		--玩家商店取出
--		elseif (arg0 == "draw") then
--			this:Show();
--			g_nSaveOrGetMoney = PS_DRAW;
--			InputMoney_Title:SetText("#gFF0FA0支取");
--			InputMoney_Accept_Button:SetText("确定");
			
		elseif (arg0 == "st_pet") then
			this:Show();
			g_nSaveOrGetMoney = STALL_PET_UP;
			InputMoney_Title:SetText("#gFF0FA0珍兽价格");
			InputMoney_Accept_Button:SetText("上架");
		
		elseif (arg0 == "petrepice") then
			this:Show();
			g_nSaveOrGetMoney = STALL_PRICE_PET;
			InputMoney_Title:SetText("#gFF0FA0珍兽价格");
			InputMoney_Accept_Button:SetText("确定");
			
		elseif (arg0 == "transfershop") then
			this:Show();
			g_nSaveOrGetMoney = PS_TRANSFER;
			InputMoney_Title:SetText("#gFF0FA0输入商店定价");
			InputMoney_Accept_Button:SetText("确定");
			
		end
		
		InputMoney_Gold:SetText("");
		InputMoney_Silver:SetText("");
		InputMoney_CopperCoin:SetText("");
		InputMoney_Accept_Button:Disable();
		
		if (g_nSaveOrGetMoney == GET_MONEY) then
			local nMoney,nGold,nSilver,nCopper = Bank:GetBankMoney();
			if nGold>99999 then nGold = 99999; nSilver = 99; nCopper = 99; end
			if (nGold == 0) then 
				if (nSilver == 0) then
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_CopperCoin:SetText(tostring(nCopper));
					InputMoney_CopperCoin:SetSelected(0,-1);
					InputMoney_CopperCoin:SetProperty("DefaultEditBox", "True");
				else
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_Silver:SetSelected(0,-1);
					InputMoney_Silver:SetProperty("DefaultEditBox", "True");
					InputMoney_CopperCoin:SetText("0");
				end
			else
				InputMoney_Gold:SetText(tostring(nGold));
				InputMoney_Gold:SetSelected(0,-1);
				InputMoney_Gold:SetProperty("DefaultEditBox", "True");
				InputMoney_Silver:SetText("0");
				InputMoney_CopperCoin:SetText("0");
			end
			
		elseif (g_nSaveOrGetMoney == SAVE_MONEY) then
			local nGold,nSilver,nCopper = Bank:GetBagMoney();
			if nGold>99999 then nGold = 99999; nSilver = 99; nCopper = 99; end
			if (nGold == 0) then 
				if (nSilver == 0) then
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_CopperCoin:SetText(tostring(nCopper));
					InputMoney_CopperCoin:SetSelected(0,-1);
					InputMoney_CopperCoin:SetProperty("DefaultEditBox", "True");
				else
					InputMoney_Gold:SetText(tostring(nGold));
					InputMoney_Silver:SetText(tostring(nSilver));
					InputMoney_Silver:SetSelected(0,-1);
					InputMoney_Silver:SetProperty("DefaultEditBox", "True");
					InputMoney_CopperCoin:SetText("0");
				end
			else
				InputMoney_Gold:SetText(tostring(nGold));
				InputMoney_Gold:SetSelected(0,-1);
				InputMoney_Gold:SetProperty("DefaultEditBox", "True");
				InputMoney_Silver:SetText("0");
				InputMoney_CopperCoin:SetText("0");
			end

			
			
			
		end

		
		if( (this:IsVisible() == true) and (g_nSaveOrGetMoney ~= GET_MONEY) and (g_nSaveOrGetMoney ~= SAVE_MONEY) )  then 
			InputMoney_Gold:SetProperty("DefaultEditBox", "True");
			
			--确定这个窗口的放置位置
			--local nPosX ;
			--local nPosY ;
			--nPosX,nPosY = GetCurMousePos();
			--AxTrace(0,0,"nPosX =" .. tostring(nPosX) "   nPosY =" .. tostring(nPosY));
			--InputMoney_Frame:AutoMousePosition(nPosX, nPosY);

		end
		
	elseif( event == "CLOSE_INPUT_MONEY")	 then
		this:Hide();
	
	end
	
end


--===============================================
-- 输入金钱后确定
--===============================================
function InputMoneyAccept_Clicked()

	local szGold = InputMoney_Gold:GetText();
	local szSilver = InputMoney_Silver:GetText();
	local szCopperCoin = InputMoney_CopperCoin:GetText();
	
	--在程序里头再检测输入字符的有效性和数值
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	
	--???什么情况下失败需要再定
	if(bAvailability == true) then
		
		if( g_nSaveOrGetMoney == SAVE_MONEY ) then
			--执行存钱操作
			Bank:SaveMoneyToBank(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == GET_MONEY ) then
			--执行取钱操作
			Bank:GetMoneyFromBank(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == EXCHANGE_MONEY ) then
			--执行Exchang中的金钱的输入
			Exchange:GetMoneyFromInput(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == SAFEBOX_GET_MONEY ) then
			--执行保险箱中的金钱的输入
			SafeBox("realgetmoney", nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == SAFEBOX_SAVE_MONEY ) then
			--执行保险箱中的金钱的输入
			SafeBox("realsavemoney", nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALLSALE_PRICE ) then
			--执行StallSale中的商品标价(提交商品价格)
			StallSale:ReferItemPrice(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALLSALE_REPRICE ) then
			--执行StallSale中的商品更改价格

			--从全局变量中取出数据
			nStallItemID		= GetGlobalInteger("StallSale_ItemID");
			nStallItemIndex = GetGlobalInteger("StallSale_Item");

			StallSale:ItemReprice(nMoney,nStallItemID,nStallItemIndex);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == PS_PRICE_ITEM ) then
			--执行玩家商店的价格输入(物品)
			PlayerShop:UpStall("item",nMoney);
			this:Hide();
			
--		elseif( g_nSaveOrGetMoney == PS_IMMITBASE ) then
--			--充入本金
--			PlayerShop:DealMoney("immitbase",nMoney);
--			this:Hide();
--		
--		elseif( g_nSaveOrGetMoney == PS_IMMIT ) then
--			--充入
--			PlayerShop:DealMoney("immit",nMoney);
--			this:Hide();
--		
--		elseif( g_nSaveOrGetMoney == PS_DRAW ) then
--			--支取
--			PlayerShop:DealMoney("draw",nMoney);
--			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALL_PET_UP ) then
			--珍兽上架
			StallSale:PetUpStall(nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == STALL_PRICE_PET ) then
			StallSale:PetReprice(nMoney);
			this:Hide();
		
		elseif( g_nSaveOrGetMoney == PS_PRICE_PET ) then
			--执行玩家商店的价格输入(珍兽)
			PlayerShop:UpStall("pet",nMoney);
			this:Hide();
			
		elseif( g_nSaveOrGetMoney == PS_TRANSFER )  then
			--出价盘店
			-- add by zchw
			if (tonumber(nMoney) > 100000000) then
				InputMoney_Gold:SetText("");
				InputMoney_Silver:SetText("");
				InputMoney_CopperCoin:SetText("");
				PushDebugMessage("盘出商店价格不能超过10000金，请重新输入");
				return;
			end
			PlayerShop:Transfer("info", "sale", nMoney);
			this:Hide();
			
		end
		
	end
end


--===============================================
-- 取消
--===============================================
function InputMoneyRefuse_Clicked()
	StallSale:UnlockSelItem();
	this:Hide();
	InputMoney_CopperCoin:SetProperty("DefaultEditBox", "False");
	InputMoney_Gold:SetProperty("DefaultEditBox", "False");
	InputMoney_Silver:SetProperty("DefaultEditBox", "False");
end


--===============================================
-- 输入改变
--===============================================
function InputMoney_ChangeMoney()
	
	local szGold = InputMoney_Gold:GetText();
	local szSilver = InputMoney_Silver:GetText();
	local szCopperCoin = InputMoney_CopperCoin:GetText();
	
	if(szGold=="" and szSilver=="" and szCopperCoin=="")then
		InputMoney_Accept_Button:Disable();
	else
		InputMoney_Accept_Button:Enable();
	end

end
