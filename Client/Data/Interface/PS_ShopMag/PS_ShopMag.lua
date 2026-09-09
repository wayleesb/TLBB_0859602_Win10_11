local PS_BUTTON_NUM = 20;
local PS_BUTTON = {};

local PS_STALL_NUM = 10;
local PS_STALL_BOTTON = {};

local g_nCurSelectItem = -1;
local g_nCurStallIndex = -1;

local g_StallNum = 0;
local g_bCurStallOpen = 0;

--标志当前是珍兽界面还是物品界面
local STALL_NONE = 0
local STALL_ITEM = 1;
local STALL_PET  = 2;
local g_CurStallObj = STALL_NONE;

local g_SaleOuting = 0;
 
local g_PetIndex  = {};

--标志自己身份（店主还是伙计）
g_SelfPlace  = "";

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_lastIndex = -1;
--===============================================
-- PreLoad
--===============================================
function PS_ShopMag_PreLoad()
	this:RegisterEvent("PS_OPEN_MY_SHOP");
	this:RegisterEvent("PS_UPDATE_MY_SHOP");
	this:RegisterEvent("PS_SELF_ITEM_CHANGED");
	this:RegisterEvent("PS_SELF_SELECT");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_SHOP_RENAME");
	this:RegisterEvent("PS_CLOSE_ALL_SHOP");
    this:RegisterEvent("UI_COMMAND");
	
end

--===============================================
-- OnLoad
--===============================================
function PS_ShopMag_OnLoad()
	
	PS_BUTTON[1]  = PS_ShopMag_Item1; 
	PS_BUTTON[2]  = PS_ShopMag_Item2; 
	PS_BUTTON[3]  = PS_ShopMag_Item3; 
	PS_BUTTON[4]  = PS_ShopMag_Item4; 
	PS_BUTTON[5]  = PS_ShopMag_Item5; 
	PS_BUTTON[6]  = PS_ShopMag_Item6; 
	PS_BUTTON[7]  = PS_ShopMag_Item7; 
	PS_BUTTON[8]  = PS_ShopMag_Item8; 
	PS_BUTTON[9]  = PS_ShopMag_Item9; 
	PS_BUTTON[10] = PS_ShopMag_Item10;
	PS_BUTTON[11] = PS_ShopMag_Item11;
	PS_BUTTON[12] = PS_ShopMag_Item12;
	PS_BUTTON[13] = PS_ShopMag_Item13;
	PS_BUTTON[14] = PS_ShopMag_Item14;
	PS_BUTTON[15] = PS_ShopMag_Item15;
	PS_BUTTON[16] = PS_ShopMag_Item16;
	PS_BUTTON[17] = PS_ShopMag_Item17;
	PS_BUTTON[18] = PS_ShopMag_Item18;
	PS_BUTTON[19] = PS_ShopMag_Item19;
	PS_BUTTON[20] = PS_ShopMag_Item20;
	
	PS_STALL_BOTTON[1]   = PS_ShopMag_Page1;
	PS_STALL_BOTTON[2]   = PS_ShopMag_Page2;
	PS_STALL_BOTTON[3]   = PS_ShopMag_Page3;
	PS_STALL_BOTTON[4]   = PS_ShopMag_Page4;
	PS_STALL_BOTTON[5]   = PS_ShopMag_Page5;
	PS_STALL_BOTTON[6]   = PS_ShopMag_Page6;
	PS_STALL_BOTTON[7]   = PS_ShopMag_Page7;
	PS_STALL_BOTTON[8]   = PS_ShopMag_Page8;
	PS_STALL_BOTTON[9]   = PS_ShopMag_Page9;
	PS_STALL_BOTTON[10]  = PS_ShopMag_Page10;
	
	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end
	
end

--===============================================
-- OnEvent
--===============================================
function PS_ShopMag_OnEvent(event)
	if ( event == "PS_OPEN_MY_SHOP" )   then
		this:Show();
		--objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_ShopMag");	
		PS_ShopMag_FriendID:SetText( "" );


		--查询是不是处于盘出状态
		g_SaleOuting = PlayerShop:IsSaleOut("self");

		--切换是珍兽还是物品
		if( tonumber(arg1) == 1 ) then
			g_CurStallObj = STALL_ITEM;
			PS_ShopMag_PetList:Hide();
			PS_ShopMag_Item_Frame:Show();
			PS_ShopMag_OpenRecycleShop_Btn:Show();
		else
			g_CurStallObj = STALL_PET;
			PS_ShopMag_PetList:Show();
			PS_ShopMag_Item_Frame:Hide();
			PS_ShopMag_OpenRecycleShop_Btn:Hide();
		end
		
		g_nCurStallIndex = 1;

		PlayerShop:SetCurSelectPage("self",g_nCurStallIndex-1);
		g_StallNum = PlayerShop:GetStallNum("self");
		
		PS_ShopMag_UpdateFrame();
		
	--更名商店
	elseif(event == "PS_SHOP_RENAME")      then
		--店名
		local szShopName = PS_ShopMag_MerchantName:GetText();
		PS_ShopMag_MerchantName:SetText(szShopName);
		PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);
		
		
	--更新商店
	elseif(event == "PS_UPDATE_MY_SHOP")      then
		if(this:IsVisible() == false)  then
			return;
		end
		
		--查询是不是处于盘出状态
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		PlayerShop:ClearSelectPos("self");
		g_StallNum = PlayerShop:GetStallNum("self");
		PS_ShopMag_UpdateFrame();
		
	elseif(event == "PS_SELF_ITEM_CHANGED")   then
		--查询是不是处于盘出状态
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		PS_ShopMag_UpdateFrame();
		
	--选中物品的操作
	elseif(event == "PS_SELF_SELECT")   then
		--查询是不是处于盘出状态
		g_SaleOuting = PlayerShop:IsSaleOut("self");
		g_nCurSelectItem = PlayerShop:GetSelectIndex("self");
		PS_ShopMag_UpdateFrame();
		
		local nOnSale = PlayerShop:IsSelectOnSale("item");
	 	
	 	if nOnSale == 0  then
	 		PS_ShopMag_DownStall:SetText("上架");
	 	else
	 		PS_ShopMag_DownStall:SetText("下架");
	 	end

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_ShopMag");
		end	
		
	elseif( event == "PS_CLOSE_ALL_SHOP" )    then
		this:Hide();
		
		--取消关心
		this:CareObject(objCared, 0, "PS_ShopMag");
		
	elseif( event == "UI_COMMAND" )    then
	    if( tonumber(arg0) == 19810222 ) then
    	    this:Hide();
		
		    --取消关心
		    this:CareObject(objCared, 0, "PS_ShopMag");
    	end
	 	
	end
end

--===============================================
-- 选中珍兽的操作
--===============================================
function PS_ShopMag_PetList_Selected()
	
	local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end
	
	PlayerShop:SetSelectPet( g_PetIndex[nIndex] );
	local nOnSale = PlayerShop:IsSelectOnSale("pet",g_PetIndex[nIndex]);

 	if nOnSale == 0  then
 		PS_ShopMag_DownStall:SetText("上架");
 	else
 		PS_ShopMag_DownStall:SetText("下架");
 	end
 	
 	--通知C＋＋
	PlayerShop:SetCurSelectPetIndex("self",g_nCurStallIndex-1,g_PetIndex[nIndex]);
	
	--通知界面刷新"名称"和"价格"
	-- 显示现在的选中的物品或者是珍兽的价格
	if( g_CurStallObj == STALL_PET )then
		local nMoney = PlayerShop:GetObjPrice("self","pet");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szPetName = PlayerShop:GetObjName("self","pet");
		PS_ShopMag_TradeName:SetText(szPetName);
		
	end	
	
end

--===============================================
-- UpdateFrame()
--===============================================
function PS_ShopMag_UpdateFrame()
	
	if( g_nCurStallIndex > g_StallNum )   then 
		g_nCurStallIndex = 1;
		PlayerShop:AskStallData("self",g_nCurStallIndex -1);
		return;
	end
	
	--店主  --改为超链接 by wangdw
	local szName = PlayerShop:GetShopInfo("self","ownername");
	PS_ShopMag_Shopkeeper_Name:SetChatString("#Y店主:#{_INFOUSR".. szName .. "}");
	
	--店主ID
	local szID = PlayerShop:GetShopInfo("self","ownerid");
	PS_ShopMag_Shopkeeper_ID:SetText("店主ID: ".. szID);
	
	--店名
	local szShopName = PlayerShop:GetShopInfo("self","shopname");
	PS_ShopMag_MerchantName:SetText(szShopName);
	PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);

	--描述
	local szShopDesc = PlayerShop:GetShopInfo("self","desc");
	PS_ShopMag_Bewrite:SetText(szShopDesc);
	
	--店主本金
	local nBaseMoney = PlayerShop:GetMoney("base","self");
	PS_ShopMag_ShopCorpus:SetProperty("MoneyNumber", tostring(nBaseMoney));
	
	--盈利资金
	local nProfitMoney = PlayerShop:GetMoney("profit","self");
	PS_ShopMag_ShopProfit:SetProperty("MoneyNumber", tostring(nProfitMoney));
	
	--商业指数
	local szCommercialFactor = PlayerShop:GetCommercialFactor();
	PS_ShopMag_CommerceExponential:SetText("商业指数:" .. szCommercialFactor);
	
	--扩建和缩减
	PS_ShopMag_Curtail:Enable();
	PS_ShopMag_Continuation:Enable();
	if ( g_StallNum == 1 )   then
		PS_ShopMag_Curtail:Disable();					--缩减
	end
	
	if(g_StallNum == 10)  then
		PS_ShopMag_Continuation:Disable();			--扩建
	end
	
	--通知C＋＋
	PlayerShop:SetCurSelectPage("self",g_nCurStallIndex-1);
	
	--刷新界面相关控件
	if( g_nCurStallIndex == 1 )  then
		PS_ShopMag_Last:Disable();
	else
		PS_ShopMag_Last:Enable();
	end
	
	if( g_nCurStallIndex == g_StallNum )   then
		PS_ShopMag_Next:Disable();
	else
		PS_ShopMag_Next:Enable();
	end
	
	PS_ShopMag_CurrentlyPageNumber:SetText(tostring(g_nCurStallIndex).."/".. tostring(g_StallNum));
	for i=1 ,PS_STALL_NUM  do
		PS_STALL_BOTTON[i]:Disable();
	end
	for i=1 ,g_StallNum  do
		PS_STALL_BOTTON[i]:Enable();
	end
	
	if( g_CurStallObj == STALL_ITEM )then
		PS_ShopMag_UpdateItem();
	else
		PS_ShopMag_UpdatePet();
	end
	
	--提示这个柜台当前的状态是Open还是Close
	g_bCurStallOpen = PlayerShop:IsOpenStall("self",g_nCurStallIndex -1);
	
	if (g_bCurStallOpen == 2)  then 
		PS_ShopMag_Open:SetText("打烊");
		PS_ShopMag_DownStall:Enable();
		PS_ShopMag_Stall_State:SetText("当前柜台状态:#G开张");
	else
		PS_ShopMag_Open:SetText("开张");
		PS_ShopMag_DownStall:Disable();
		PS_ShopMag_Stall_State:SetText("当前柜台状态:#R打烊");
	end
	
	-- 显示现在的选中的物品或者是珍兽的价格
	if( g_CurStallObj == STALL_ITEM )then
		local nMoney = PlayerShop:GetObjPrice("self","item");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szItemName = PlayerShop:GetObjName("self","item");
		PS_ShopMag_TradeName:SetText(szItemName);
		
	else
		local nMoney = PlayerShop:GetObjPrice("self","pet");
		PS_ShopMag_PriceTag:SetProperty("MoneyNumber", tostring(nMoney));
		local szPetName = PlayerShop:GetObjName("self","pet");
		PS_ShopMag_TradeName:SetText(szPetName);
		 
	end	
	
	PS_ShopMag_ShowHide_Windows();

	--合伙人管理部分
	PS_ShopMag_FriendList:ClearListBox();
	local nNum = PlayerShop:GetFriendNum();
	for i=0 ,nNum-1  do
		local szFriendName = PlayerShop:EnumFriend(i);
		PS_ShopMag_FriendList:AddItem(szFriendName, i);
	
	end
	PS_STALL_BOTTON[g_nCurStallIndex]:SetCheck(1);
	
end

--===============================================
-- 更新物品,先Show所有的Window，然后根据需要Hide相关
--===============================================
function PS_ShopMag_ShowHide_Windows()

	PS_ShopMag_NameAmend:Show();			-- 修改店名
	PS_ShopMag_BewriteAmend:Show();		-- 修改商店说明
	PS_ShopMag_SortAmend:Show();			-- 修改子类

	PS_ShopMag_DrawMoney:Show();			-- 支取
	
	PS_ShopMag_AccountBook:Show();		-- 账本
	PS_ShopMag_Open:Show();						-- 开张
	PS_ShopMag_DownStall:Show();			-- 上(下)架
	PS_ShopMag_TakeBack:Show();				-- 取回
	PS_ShopMag_DisposeOf:Show();			-- 盘出
	PS_ShopMag_Curtail:Show();				-- 缩减
	PS_ShopMag_Continuation:Show();		-- 扩建
	
	PS_ShopMag_Add:Show();						-- 添加合作伙伴
	PS_ShopMag_FriendID:Show();				-- 玩家ID输入框
	PS_ShopMag_Del:Show();						-- 删除合作伙伴
	PS_ShopMag_ViewLog:Show();				-- 查看伙伴记录
	if( g_CurStallObj == STALL_ITEM ) then
			PS_ShopMag_OpenRecycleShop_Btn:Show();
	else
			PS_ShopMag_OpenRecycleShop_Btn:Hide();
	end
	--PS_ShopMag_OpenRecycleShop_Btn:Show();			--收购
	if( g_SaleOuting == 1) then --处于盘出状态
		PS_ShopMag_DisposeOf:SetText("回购");
		--置灰不能使用的功能						
		PS_ShopMag_SortAmend:Hide();		-- 修改子类
		PS_ShopMag_Open:Hide();         -- 开张
		PS_ShopMag_DownStall:Hide();    -- 上(下)架
		PS_ShopMag_TakeBack:Hide();     -- 取回
		PS_ShopMag_NameAmend:Hide();    -- 修改店名
		PS_ShopMag_BewriteAmend:Hide(); -- 修改商店说明
		PS_ShopMag_DrawMoney:Hide();    -- 支取
		PS_ShopMag_AccountBook:Hide();	-- 账本
		PS_ShopMag_Curtail:Hide();			-- 缩减
		PS_ShopMag_Continuation:Hide();	-- 扩建
		
		--店名
		local szShopName = PlayerShop:GetShopInfo("self","shopname");
		szShopName = szShopName .. "(盘出中)"
		PS_ShopMag_PageHeader:SetText("#gFF0FA0"..szShopName);
		
		--物品将不能拖动
		for i=1 , 20   do
			PS_BUTTON[i]:SetProperty("DraggingEnabled", "False");
		end
		
		PS_ShopMag_OpenRecycleShop_Btn:Hide();	--收购
	else
		PS_ShopMag_DisposeOf:SetText("盘出");
		--回复物品的拖动
		for i=1 , 20   do
			PS_BUTTON[i]:SetProperty("DraggingEnabled", "True");
		end
	end

	-- 获得自己的身份
	g_SelfPlace = PlayerShop:GetSelfPlace();
	if(g_SelfPlace ~= "boss")   then
		PS_ShopMag_NameAmend:Hide();
		PS_ShopMag_BewriteAmend:Hide();
		PS_ShopMag_SortAmend:Hide();
		PS_ShopMag_DisposeOf:Hide();
		PS_ShopMag_Curtail:Hide();
		PS_ShopMag_Continuation:Hide();
		PS_ShopMag_Add:Hide();
		PS_ShopMag_FriendID:Hide();
		PS_ShopMag_DrawMoney:Hide();
		PS_ShopMag_Del:Hide();
	end

end
--收购按钮
function PS_ShopMag_OpenRecycleShop_Click()
	local SelfPlace = PlayerShop:GetSelfPlace();
	PlayerShop:OpenRecycleShopDLG(SelfPlace);
end

--===============================================
-- 更新物品
--===============================================
function PS_ShopMag_UpdateItem()

	-- 更新子类列表
	PS_ShopMag_SelectSort:ResetList();
	PS_ShopMag_SelectSort:ComboBoxAddItem("物品店",0);
	PS_ShopMag_SelectSort:ComboBoxAddItem("宝石店",1);
	PS_ShopMag_SelectSort:ComboBoxAddItem("武器店",2);
	PS_ShopMag_SelectSort:ComboBoxAddItem("护甲店",3);
	PS_ShopMag_SelectSort:ComboBoxAddItem("材料店",4);

	--商店子类
	local nShopSubType = PlayerShop:GetCurShopType("self");
	PS_ShopMag_SelectSort:SetCurrentSelect(nShopSubType - 1);
	-- 注意当前绘制的是第g_nCurStallIndex个柜台上的物品
	g_nCurSelectItem = PlayerShop:GetSelectIndex("self");
	
	for i=1, PS_BUTTON_NUM    do
		local theAction, bLocked = PlayerShop:EnumItem(g_nCurStallIndex -1, i-1, "self");

		if theAction:GetID() ~= 0 then
			PS_BUTTON[i]:SetActionItem(theAction:GetID());
			if g_nCurSelectItem == i   then
				PS_BUTTON[i]:SetPushed(1);
			else
				PS_BUTTON[i]:SetPushed(0);
			end
		else
			PS_BUTTON[i]:SetActionItem(-1);
		end
	end

end

--===============================================
-- 更新珍兽列表
--===============================================
function PS_ShopMag_UpdatePet()

	-- 更新子类列表
	PS_ShopMag_SelectSort:ResetList();
	PS_ShopMag_SelectSort:ComboBoxAddItem("珍兽店",0);

	--商店子类
	local nShopSubType = PlayerShop:GetCurShopType("self");
	PS_ShopMag_SelectSort:SetCurrentSelect(nShopSubType - 6);
	
	PS_ShopMag_PetList:ClearListBox();
	
	local PetInListIndex = 0
	for i=1,  20  do
		local szPetName,bOnSale,szType = PlayerShop:EnumPet("self",g_nCurStallIndex -1, i-1);
		if (szPetName ~= "")   then
			if(bOnSale ~= 0)  then
				-- 红色表示现在的物品是处于上架的状态
				szPetName = "#c808080" .. szPetName;
			end
			PS_ShopMag_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")", PetInListIndex);
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end
	end
	
end

--===============================================
-- 取回
--===============================================
function PS_ShopMag_Retake_Click()
	
	if( g_CurStallObj == STALL_ITEM )    then
		PlayerShop:RetackItem("item");
	else
		--检测是不是有珍兽被选中
		local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
		
		if(nIndex == -1)  then
			PushDebugMessage("请先选中一个珍兽。")
			return;
		end
		
		PlayerShop:RetackItem("pet");
	end
end

--===============================================
-- 上架(下架)
--===============================================
function PS_ShopMag_UpDownStall_Click()

	if( g_CurStallObj == STALL_ITEM )     then
		if(PS_ShopMag_DownStall:GetText() == "上架")  then
			PlayerShop:InputMoney("ps_upitem");
		else
			PlayerShop:DownSale("item");
		end
		
	elseif( g_CurStallObj == STALL_PET )  then
		
		--检测是不是有珍兽被选中
		local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
		
		if(nIndex == -1)  then
			return;
		end
		
		if(PS_ShopMag_DownStall:GetText() == "上架")  then
			PlayerShop:InputMoney("ps_uppet");
		else
			PlayerShop:DownSale("pet");
		end
	end
	
end

--===============================================
-- 上一间
--===============================================
function PS_ShopMag_Last_Click()
	if(g_nCurStallIndex == 1) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex - 1;
	
	--向服务器请求数据
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("self",g_nCurStallIndex -1);

end

--===============================================
-- 下一间
--===============================================
function PS_ShopMag_Next_Click()
	if(g_nCurStallIndex == g_StallNum) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex + 1;
	
	--向服务器请求数据
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("self",g_nCurStallIndex -1);

end

--===============================================
-- 1 2 3 4 5 6 7 8 9 10
--===============================================
function PS_ShopMag_Page_Click(nIndex)
	g_nCurStallIndex = nIndex;

	--向服务器请求数据
	PS_ShopMag_Last:Disable();
	PS_ShopMag_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("self",g_nCurStallIndex -1);

end

--===============================================
-- 冲入本金
--===============================================
function PS_ShopMag_ImmitCorpus_Click()
	PlayerShop:InputMoney("immitbase");
end

--===============================================
-- 冲入
--===============================================
function PS_ShopMag_Immit_Click()
	PlayerShop:InputMoney("immit");
end

--===============================================
-- 支取
--===============================================
function PS_ShopMag_DrawMoney_Click()
	PlayerShop:InputMoney("draw");
end

--===============================================
-- 开张(打烊)           "PS_ShopMag_Open"
--===============================================
function PS_ShopMag_OpenCloseStall_Click()
	if(g_nCurStallIndex ~= -1)  then
		if ( g_bCurStallOpen == 1 )  then
			PlayerShop:OpenStall(g_nCurStallIndex -1, 1);
		else
			PlayerShop:OpenStall(g_nCurStallIndex -1, 0);
		end		
	end
	
end

--===============================================
-- 修改广告语言
--===============================================
function PS_ShopMag_ModifyShopAD()

	local szAd = PS_ShopMag_Bewrite:GetText();
	PlayerShop:Modify("ad",szAd);

end

--===============================================
-- 修改商店名称
--===============================================
function PS_ShopMag_ModifyShopName()

	local szName = PS_ShopMag_MerchantName:GetText();
	PlayerShop:Modify("name",szName);

end

--===============================================
-- 右键选中珍兽（查看珍兽）
--===============================================
function PS_ShopMag_PetList_RClick()
	local nIndex = PS_ShopMag_PetList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end
	
	PlayerShop:ViewPetDesc("self",g_PetIndex[nIndex]);
end

--===============================================
-- 盘出(盘回)
--===============================================
function PS_ShopMag_DisposeOf_Click()
	
	if(g_SaleOuting == 0)   then
		PlayerShop:Transfer("sale");
	else
		PlayerShop:Transfer("info","back",0);
	end
end

--===============================================
-- 是否处于盘出状态的界面更新，1=盘出状态，
--===============================================
function PS_ShopMag_Close()
	PlayerShop:CloseShop("self");
end

--===============================================
-- 打开关闭账本
--===============================================
function PS_ShopMag_AccountBook_Clicked()
	PlayerShop:OpenMessage("exchange",0);
end

--===============================================
-- 删除合作伙伴
--===============================================
function PS_ShopMag_Del_Click()

	local nIndex = PS_ShopMag_FriendList:GetFirstSelectItem();
	
	if(nIndex == -1)  then
		return;
	end

	PlayerShop:DealFriend("del", nIndex);
end

--===============================================
-- 查看伙伴记录
--===============================================
function PS_ShopMag_ViewLog_Click()
	PlayerShop:OpenMessage("manager",0);
end

--===============================================
-- 添加合作伙伴
--===============================================
function PS_ShopMag_Add_Click()
	PlayerShop:DealFriend("add", PS_ShopMag_FriendID:GetText());
end

--===============================================
-- 选中合伙人
--===============================================
function PS_ShopMag_FriendList_Selected()
	
end

--===============================================
-- 缩减
--===============================================
function PS_ShopMag_Curtail_Click()
	PlayerShop:ChangeShopNum("del");
end

--===============================================
-- 扩建
--===============================================
function PS_ShopMag_Continuation_Click()
	PlayerShop:ChangeShopNum("add");
end

function PS_ShopMag_SelectSort_Selected()
	
	local szName, nIndex = PS_ShopMag_SelectSort:GetCurrentSelect();
	if(nIndex == -1)  then
		return;
	end
	
	if(g_lastIndex ~= nIndex)then
		--关闭弹出框
		PlayerShop:CloseChangeTypeMsgBox();
	end
end
--===============================================
-- 修改商店类型
--===============================================
function PS_ShopMag_SortAmend_Click()
	local szName, nIndex = PS_ShopMag_SelectSort:GetCurrentSelect();
	if(nIndex == -1)then
		PushDebugMessage("您选择了一个无效值，请重新选择");
		return;
	end
	if( g_CurStallObj == STALL_ITEM )     then
		local nShopSubType = PlayerShop:GetCurShopType("self");		
		if(nIndex+1 == nShopSubType)then
			PushDebugMessage("请选择一个不同的商店类型再修改!");
			return;
		end
		g_lastIndex = nIndex;
		PlayerShop:ModifySubType("ps_type", nIndex+1);
	else
		PushDebugMessage("请选择一个不同的商店类型再修改!");
		return;		
	end	
end

--===============================================
-- OnHiden
--===============================================
function PS_ShopMag_Frame_OnHiden()
	-- 通知相关的界面关闭，(PetList,PS_Input,)
	PlayerShop:CloseShopMag();
end

