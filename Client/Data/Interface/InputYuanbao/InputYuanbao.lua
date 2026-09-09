
local YuanbaoStall_DefPrice = 1; --元宝商品定价
local YuanbaoStall_RePrice = 2; --元宝商品改价
local YuanbaoStall_PetPrice = 3;  --珍兽上架定价
local YuanbaoStall_PetRePrice = 4;  --珍兽修改价钱


local g_YuanbaoInputWindowType = YuanbaoStall_DefPrice;

--===============================================
-- OnLoad()
--===============================================
function InputYuanbao_PreLoad()
	this:RegisterEvent("OPEN_INPUT_YUANBAO");
	this:RegisterEvent("CLOSE_INPUT_YUANBAO");
end

function InputYuanbao_OnLoad()
	
end

function InputYuanbao_OnEvent(event)
	if(event == "OPEN_INPUT_YUANBAO") then
		InputYuanbao_OnOpen(arg0);
		this:Show();
	elseif(event == "CLOSE_INPUT_YUANBAO") then
		InputYuanbao_OnCancel();
		this:Hide();
	end
end

function InputYuanbao_OnOpen(arg0)
	InputYuanbao_EditBox:SetText("")
	
	if ( arg0 == "price" ) then
		InputYuanbao_Title:SetText("#{INTERFACE_XML_1182}");
		InputYuanbao_Accept_Button:SetText("上架");
		g_YuanbaoInputWindowType = YuanbaoStall_DefPrice;
	elseif ( arg0 == "reprice" ) then
		InputYuanbao_Accept_Button:SetText("更改");
		g_YuanbaoInputWindowType = YuanbaoStall_RePrice;
		InputYuanbao_Title:SetText("#{INTERFACE_XML_1182}");
	elseif (arg0 == "pet_price") then
		InputYuanbao_Title:SetText("#{INTERFACE_XML_1182}");
		InputYuanbao_Accept_Button:SetText("上架");
		g_YuanbaoInputWindowType = YuanbaoStall_PetPrice;
	elseif (arg0 == "pet_reprice") then
		InputYuanbao_Title:SetText("#{INTERFACE_XML_1182}");
		InputYuanbao_Accept_Button:SetText("更改");
		g_YuanbaoInputWindowType = YuanbaoStall_PetRePrice;
	end
	
	InputYuanbao_EditBox:SetProperty("DefaultEditBox", "True");
end

function InputYuanbao_OnClose()
	StallSale:UnlockSelItem();
	this:Hide();
end



--===========================================================
-- 确定输入的金钱
--===========================================================
function InputYuanbao_OnOK()
	local nYuanbao = InputYuanbao_EditBox:GetText();
	local nStallItemID	= GetGlobalInteger("StallSale_ItemID");
	local nStallItemIndex = GetGlobalInteger("StallSale_Item");
	
	if ( nYuanbao == "" or nStallItemID == nil or nStallItemIndex == nil ) then
		return
	end
	
	if( g_YuanbaoInputWindowType == YuanbaoStall_DefPrice ) then
		StallSale:ReferItemPrice(tonumber(nYuanbao));
		
	elseif( g_YuanbaoInputWindowType == YuanbaoStall_RePrice ) then
		--从全局变量中取出数据

		--PushDebugMessage("InputYuanbao_OnOK:ItemReprice: "..nYuanbao..", "..nStallItemID..", "..nStallItemIndex);
		StallSale:ItemReprice(tonumber(nYuanbao),nStallItemID,nStallItemIndex);
	elseif (g_YuanbaoInputWindowType == YuanbaoStall_PetPrice) then
		StallSale:PetUpStall(tonumber(nYuanbao));
	elseif (g_YuanbaoInputWindowType == YuanbaoStall_PetRePrice) then
		StallSale:PetReprice(tonumber(nYuanbao));
	end
	this:Hide();
end

function InputYuanbao_OnCancel()
	StallSale:UnlockSelItem();
	this:Hide();
end
