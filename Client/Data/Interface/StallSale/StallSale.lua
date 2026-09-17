
local g_CurrentPage = -1;
local g_DefaultPage = -1;

local PAGE_ITEM  =0;
local PAGE_PET   =1;

-- 物品相关
local STALL_BUTTONS_NUM = 20;
local STALL_BUTTON = {};

local g_nCurSelectItemID = -1;	--物品ID
local g_nCurSelectItem = -1;		--物品位置

--珍兽相关
local MAX_PET_NUM  = 20;		--最大上架的珍兽数量
local g_nSelectPet = -1;		--当前选中的Pet
local g_nPetID = {};				--珍兽ID表

--===============================================
-- OnLoad()
--===============================================
function StallSale_PreLoad()

	this:RegisterEvent("OPEN_STALL_SALE");
	this:RegisterEvent("UPDATE_STALL_SALE");
	this:RegisterEvent("STALL_SALE_SELECT");
	this:RegisterEvent("OPEN_STALL_BUY");
	
	this:RegisterEvent("UPDATE_STALL_ITEM_PRICE");
	this:RegisterEvent("UPDATE_STALL_NAME");
	--进入场景，自动关闭
	this:RegisterEvent("CLOSE_STALL_SELL");
	-- add by zchw
	this:RegisterEvent("CLOSE_STALL_MESSAGE");
end

function StallSale_OnLoad()
	STALL_BUTTON[1] 	= StallSale_Item1;
	STALL_BUTTON[2] 	= StallSale_Item2;
	STALL_BUTTON[3] 	= StallSale_Item3;
	STALL_BUTTON[4] 	= StallSale_Item4;
	STALL_BUTTON[5] 	= StallSale_Item5;
	STALL_BUTTON[6] 	= StallSale_Item6;
	STALL_BUTTON[7] 	= StallSale_Item7;
	STALL_BUTTON[8] 	= StallSale_Item8;
	STALL_BUTTON[9] 	= StallSale_Item9;
	STALL_BUTTON[10] 	= StallSale_Item10;
	STALL_BUTTON[11] 	= StallSale_Item11;
	STALL_BUTTON[12] 	= StallSale_Item12;
	STALL_BUTTON[13] 	= StallSale_Item13;
	STALL_BUTTON[14]	= StallSale_Item14;
	STALL_BUTTON[15]	= StallSale_Item15;
	STALL_BUTTON[16]	= StallSale_Item16;
	STALL_BUTTON[17]	= StallSale_Item17;
	STALL_BUTTON[18]	= StallSale_Item18;
	STALL_BUTTON[19]	= StallSale_Item19;
	STALL_BUTTON[20]	= StallSale_Item20;
	
	--AxTrace(0,0,"StallSale_OnLoad begin\n");
	for i=0, MAX_PET_NUM  do
		g_nPetID[i] = -1;
	end
	
	--暂时屏蔽拖动功能
	for i=1 ,STALL_BUTTONS_NUM     do
		STALL_BUTTON[i]:SetProperty("DraggingEnabled","False");
	end
		
end

--===============================================
-- OnEvent()
--===============================================
function StallSale_StallInfo(event)
	--填写摊位名字
	StallSale_Name:SetText(StallSale:GetStallName());
	--填写名字
	StallSale_Master_Text:SetText("摊主:" .. Player:GetName());
	--填写自己的GUID
	StallSale_ID_Text:SetText( "ID:" .. StallSale:GetGuid());
	--清除价格
	StallSale_TargetPrice_Money:SetProperty("MoneyNumber","");
	--填写税率
	StallSale_Tax_Text:SetText(tostring(StallSale:GetTradeTax()).."%");
end

--===============================================
-- OnEvent()
--===============================================
function StallSale_OnEvent(event)

	if(event == "OPEN_STALL_SALE") then
		StallSale_OnStallSaleOpen();
		
	elseif(event == "UPDATE_STALL_SALE")  then
		g_DefaultPage = StallSale_GetDefalutPage();

		StallSale_StallInfo();

		StallSale_ChangePage(g_CurrentPage);
		
		g_nCurSelectItemID = -1;
		g_nCurSelectItem = -1;
	
	elseif(event == "UPDATE_STALL_ITEM_PRICE")   then
		--获得修改第几个，然后修改价格
		StallSale_UpdateFrame();
		StallSale_ViewSelectAndPrice();

	elseif(event == "STALL_SALE_SELECT") then
		--PushDebugMessage("STALL_SALE_SELECT");
		StallSale_SelectUpdate();
		--将InputMoney需要的数据保存到全局数据区
		SetGlobalInteger(g_nCurSelectItemID,"StallSale_ItemID");
		SetGlobalInteger(g_nCurSelectItem,"StallSale_Item");

	elseif(event == "OPEN_STALL_BUY") then
		--实现买卖界面的互斥
		this:Hide();
		
	elseif(event == "UPDATE_STALL_NAME")  then
		--更改商店名字
		StallSale_Name:SetText(arg0);
		StallSale:ModifStallName(StallSale_Name:GetText());
		-- add by zchw
	elseif (event == "CLOSE_STALL_MESSAGE") then
		this:Hide(); 
	elseif(event == "CLOSE_STALL_SELL")  then
		this:Hide();
	end
	

end

function StallSale_GetDefalutPage()
	
	--local nCoinType = StallSale:GetStallType()
	
	--if( nCoinType == 1 ) then
	--	return  PAGE_ITEM;
	--end
	
	return StallSale:GetDefaultPage();
	
end

--===============================================
-- 初始化摆摊界面 dun.liu 2008.10.23
--===============================================
function StallSale_OnStallSaleOpen()
	this:Show();
	
	--打开留言版
	StallSale:OpenMessageSale();		
	
	--清空选择
	StallSale_ClearSelect();
		
	g_DefaultPage = StallSale_GetDefalutPage();
	g_CurrentPage = g_DefaultPage;
		
	if(g_CurrentPage == PAGE_ITEM)  then
		StallSale_Check_Item:SetCheck(1);
		StallSale_Check_Pet:SetCheck(0);
	else
		StallSale_Check_Item:SetCheck(0);
		StallSale_Check_Pet:SetCheck(1);
	end

	StallSale_StallInfo();
		
	-- 填入内容
	StallSale_ChangePage(g_CurrentPage);
	
	
	StallSale_TargetPrice:Hide();
	StallSale_TargetPrice_Yuanbao:Hide();
	
	local nCoinType = StallSale:GetStallType()
	-- 如果是金币摆摊
	if (nCoinType == 0) then
		--PushDebugMessage("金币摆摊");
		StallSale_TargetPrice:Show();
		StallSale_Check_Pet:Show()
		StallSale_Default_Page:Show()
		StallSale_SetPage_Text:Show()
		
	elseif( nCoinType == 1 ) then
		--PushDebugMessage("元宝摆摊");
		StallSale_TargetPrice_Yuanbao:Show();
		StallSale_Check_Pet:Show()
		StallSale_Default_Page:Show();
		StallSale_SetPage_Text:Show();
		StallSale_TargetPrice_Yuanbao:SetText("#cff99000 #W元宝")

	else
		PushDebugMessage("摆摊类型错误");
	end

end

--===============================================
-- 选中物品
--===============================================
function StallSale_SelectUpdate()

	local theAction = EnumAction(arg0+0, "st_self");
	
	g_nCurSelectItemID = theAction:GetID();
	g_nCurSelectItem = tonumber(arg0);

	StallSale_ViewSelectAndPrice();
	
end

--===============================================
-- 显示选中的物品（珍兽），和他们的标价
--===============================================
function StallSale_ViewSelectAndPrice()

	local nMoney = 0;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	if (g_CurrentPage == PAGE_ITEM) then 
		for i=1, STALL_BUTTONS_NUM do
			if(i==g_nCurSelectItem+1) then
				STALL_BUTTON[i]:SetPushed(1);
			else
				STALL_BUTTON[i]:SetPushed(0);
			end
		end
		nMoney,nGoldCoin,nSilverCoin,nCopperCoin = StallSale:GetPrice("item",g_nCurSelectItem);
		
	elseif(g_CurrentPage == PAGE_PET)  then
		if(g_nSelectPet ~= -1)   then
			StallSale_PetList:SetItemSelect(g_nSelectPet);
			nMoney,nGoldCoin,nSilverCoin,nCopperCoin = StallSale:GetPrice("pet",g_nPetID[g_nSelectPet]);
		end
	end
	
	local nCoinType = StallSale:GetStallType()
	if (nCoinType == 0) then
		StallSale_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));

		
		
	elseif( nCoinType == 1 ) then
		StallSale_SetTargetPrice(1, nMoney)
		--StallSale2_TargetPrice_Yuanbao:SetText("#Y"..tostring(nMoney).." 元宝");

		
	else
		PushDebugMessage("摆摊类型错误");
	end
	
end


--===============================================
-- 选中珍兽
--===============================================
function StallSale_PetList_Selected()
	
	--需要显示价格
	g_nSelectPet = StallSale_PetList:GetFirstSelectItem();
	
	if( g_nSelectPet == -1 )  then 
		return;
	end

	StallSale:SetSelectPet(g_nPetID[g_nSelectPet]);
	
	StallSale_ViewSelectAndPrice();
		
end

--===============================================
-- StallSale_UpdateFrame
--===============================================
function StallSale_UpdateFrame()
	
	if(g_CurrentPage == PAGE_ITEM)     then 
		UpdateItem();
		if( g_DefaultPage == g_CurrentPage  )   then
			StallSale_Default_Page:SetCheck(1);
		else
			StallSale_Default_Page:SetCheck(0);
		end

	elseif (g_CurrentPage == PAGE_PET) then
		if( g_DefaultPage == g_CurrentPage  )   then
			StallSale_Default_Page:SetCheck(1);
		else
			StallSale_Default_Page:SetCheck(0);
		end
		UpdatePet();

	end
	
	StallSale_SetTabColor();
end

--===============================================
-- 重新命名摊位名称
--===============================================
function StallSaleRename_Clicked()

	StallSale:ModifStallName(StallSale_Name:GetText());

end

--===============================================
-- 重新指定物品的价格（打开价格输入框）
--===============================================
function StallSaleReprice_Clicked()

	if (g_CurrentPage == PAGE_ITEM) then 
		-- 需要先判定是否有物品
		if(g_nCurSelectItemID~=-1) then
			if(g_nCurSelectItem~=-1) then
				StallSale:ModifItemPrice("item");
			end
		end
		
	elseif(g_CurrentPage == PAGE_PET)  then
		if(g_nSelectPet ~= -1) then 
			StallSale:ModifItemPrice("pet",g_nPetID[g_nSelectPet]);
		end
	end
	
end

--===============================================
-- 让一个物品(珍兽)下架
--===============================================
function StallSaleDelete_Clicked()
	
	if (g_CurrentPage == PAGE_ITEM) then 
		-- 需要先判定是否有物品
		if(g_nCurSelectItemID~=-1) then
			if(g_nCurSelectItem~=-1) then
				StallSale:DeleteItem("item",g_nCurSelectItemID);
			end
		end

	elseif(g_CurrentPage == PAGE_PET)  then
		if(g_nSelectPet ~= -1) then 
			StallSale:DeleteItem("pet",g_nPetID[g_nSelectPet]);
		end
	end

end

--===============================================
-- 收摊走人
--===============================================
function StallSalePutUpTheShutters_Clicked()
	--StallSale:CloseStall("ask");
	--this:Hide();
	--add by zchw
	StallSale:ConfirmRemoveStall();
end

--===============================================
-- 打开信息界面
--===============================================
function StallSale_Message_Clicked()
	StallSale:OpenMessageSale();
end

--===============================================
-- 关闭按钮
--===============================================
function StallSale_Close_Clicked()
	this:Hide();
	StallSale:CloseStallMessage();
	StallSale_Name:SetProperty("DefaultEditBox", "False");
	CloseMessageBoxCommon();
	CloseInputYuanbao();
end

--===============================================
-- 显示物品
--===============================================
function UpdateItem()
	local nItemNum = GetActionNum("st_self");
	for i=0, STALL_BUTTONS_NUM - 1  do
		local theAction = EnumAction(i, "st_self");
		if theAction:GetID() ~= 0 then
			STALL_BUTTON[i+1]:SetActionItem(theAction:GetID());
		else
			STALL_BUTTON[i+1]:SetActionItem(-1);
		end
	end
end

--===============================================
-- 显示珍兽
--===============================================
function UpdatePet()
	StallSale_PetList:ClearListBox();
	
	--local nPetNum = StallSale:GetPetNum();
	local nIndex = 0;
	for i=1 ,MAX_PET_NUM  do
		local szPetName, szType = StallSale:EnumPet(i-1);
		if(szPetName ~= "") then 
			StallSale_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")" , nIndex);
			g_nPetID[nIndex] = i-1;
			nIndex = nIndex + 1;
		end

	end
	
end

--===============================================
-- 换页
--===============================================
function StallSale_ChangeTabIndex(nIndex)
	--AxTrace(0,0,"StallSale_ChangeTabIndex begin\n");
	if(g_CurrentPage == nIndex)    then
		return;
	else
		StallSale_ChangePage(nIndex)
		StallSale_TargetPrice_Money:SetProperty("MoneyNumber","0");	
	end
	--AxTrace(0,0,"StallSale_ChangeTabIndex begin\n");
end

--===============================================
-- 换页刷新
--===============================================
function StallSale_ChangePage(nPage)
	--AxTrace(0,0,"StallSale_ChangePage begin\n");
	StallSale_ClearSelect();

	g_CurrentPage = nPage;
	
	if(g_CurrentPage == PAGE_ITEM) then
		StallSale_PetList:Hide();
		StallSale_Item_Set:Show();
		for i=1, STALL_BUTTONS_NUM   do
			STALL_BUTTON[i]:Show();
		end
		StallSale_ViewPets:Hide();
	else
		StallSale_PetList:Show();
		StallSale_Item_Set:Hide();
		for i=1, STALL_BUTTONS_NUM   do
			STALL_BUTTON[i]:Hide();
		end
		StallSale_ViewPets:Show();
	end
	StallSale_UpdateFrame();
	--AxTrace(0,0,"StallSale_ChangePage end\n");
	
end

--===============================================
-- 选中缺省页面
--===============================================
function StallSale_Default_Page_Clicked()

	local nCurrent = StallSale_Default_Page:GetCheck();
	--AxTrace(0,0,"StallSale_Default_Page_Clicked begin\n");
	if( g_CurrentPage == PAGE_ITEM )  then
		if( nCurrent == 1  )   then
			g_DefaultPage = PAGE_ITEM;
		else
			g_DefaultPage = PAGE_PET;
		end
	else
		if( nCurrent == 1  )   then
			g_DefaultPage = PAGE_PET;
		else
			g_DefaultPage = PAGE_ITEM;
		end
	
	end
	
	StallSale:SetDefaultPage(g_DefaultPage);
	--AxTrace(0,0,"StallSale_Default_Page_Clicked end\n");
end

--===============================================
-- 右键选中
--===============================================
function StallSale_PetList_RClick()

	g_nSelectPet = StallSale_PetList:GetFirstSelectItem();
	if(g_nSelectPet == -1)then
		PushDebugMessage("请选择一只珍兽后点击查看")
		return;
	end

	--显示珍兽
	StallSale:ViewPetDesc("self",g_nPetID[g_nSelectPet]);

end

--===============================================
-- 设置Tab颜色
--===============================================
function StallSale_SetTabColor()
	
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";

	if( PAGE_ITEM == g_CurrentPage ) then
		StallSale_Check_Item:SetText(selColor .. "物品");
		StallSale_Check_Pet:SetText(noselColor .. "珍兽");
	else
		StallSale_Check_Item:SetText(noselColor .. "物品");
		StallSale_Check_Pet:SetText(selColor .. "珍兽");
	end

end

--===============================================
-- 恢复选中状态（清空选中）
--===============================================
function StallSale_ClearSelect()
	g_nSelectPet = -1;				--当前选中的Pet
	g_nCurSelectItemID = -1;	--物品ID
	g_nCurSelectItem = -1;		--物品位置
end


function StallSale_SetTargetPrice(nCoinType, nMoney)
	
	local nMoneyEnd = 0;
	local nMoneyBegin = 0
	local nMoneyMid = 0;
	local strMoney = "";
	
	-- 如果是金币摆摊
	if (nCoinType == 0) then
		StallSale_TargetPrice_Money:SetProperty("MoneyNumber",tostring(nMoney));
			-- 元宝摆摊
	elseif( nCoinType == 1 ) then
		if (nMoney <100 ) then
			strMoney = string.format("#cff9900%s", nMoney);
		elseif (nMoney < 10000) then
			nMoneyEnd = nMoney - math.floor(nMoney/100)*100;
			nMoneyMid = math.floor(nMoney/100) - math.floor((math.floor(nMoney/100))/100)*100;
			local strEnd = "00";
			if (nMoneyEnd < 10) then
				strEnd = string.format("0%d", nMoneyEnd);
			else
				strEnd = tostring(nMoneyEnd);
			end
			strMoney = string.format("#W%d#cff9900%s", nMoneyMid, strEnd);
		else
			nMoneyEnd = nMoney - math.floor(nMoney/100)*100;
			nMoneyMid = math.floor(nMoney/100) - math.floor((math.floor(nMoney/100))/100)*100;
			nMoneyBegin = math.floor(nMoney/10000);
			local strEnd = "00";
			if (nMoneyEnd < 10) then
				strEnd = string.format("0%d", nMoneyEnd);
			else
				strEnd = tostring(nMoneyEnd);
			end
			local strMid = "00";
			if (nMoneyMid < 10) then
				strMid = string.format("0%d", nMoneyMid);
			else
				strMid = tostring(nMoneyMid);
			end
			strMoney = string.format("#Y%d#W%s#cff9900%s", nMoneyBegin, strMid, strEnd);
		end
		StallSale_TargetPrice_Yuanbao:SetText("#Y"..strMoney.." #W元宝");
	else
		PushDebugMessage("摆摊类型错误");
	end
end