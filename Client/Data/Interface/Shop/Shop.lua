local GOODS_BUTTONS_NUM = 12;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOODS_PRICE = {};
local GOOD_BAD    = {};

local CALLBACK_BUTTON_FRAME = {};
local CALLBACK_BUTTON = {};

local nPageNum = 1;
local maxPage = 1;
local objCared = -1;

local CU_MONEY			= 1	-- 钱
local CU_GOODBAD		= 2	-- 善恶值
local CU_MORALPOINT	= 3	-- 师德点
local CU_TICKET			= 4 -- 官票钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点
local CU_MENPAI_POINT		= 7 -- 门派贡献度
local CU_MONEYJZ		= 8 -- 交子

local MAX_OBJ_DISTANCE = 3.0;

--存储随机排序的索引值
local	g_tOrderPool	= {};
--当前商店的商品数量
local	g_nTotalNum		= 0;

--===============================================
-- PreLoad
--===============================================
function Shop_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_BOOTH");
	this:RegisterEvent("UPDATE_BOOTH");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

--===============================================
-- OnLoad
--===============================================
function Shop_OnLoad()
	GOODS_BUTTONS[1] = Shop_Item1;
	GOODS_BUTTONS[2] = Shop_Item2;
	GOODS_BUTTONS[3] = Shop_Item3;
	GOODS_BUTTONS[4] = Shop_Item4;
	GOODS_BUTTONS[5] = Shop_Item5;
	GOODS_BUTTONS[6] = Shop_Item6;
	GOODS_BUTTONS[7] = Shop_Item7;
	GOODS_BUTTONS[8] = Shop_Item8;
	GOODS_BUTTONS[9] = Shop_Item9;
	GOODS_BUTTONS[10]= Shop_Item10;
	GOODS_BUTTONS[11]= Shop_Item11;
	GOODS_BUTTONS[12]= Shop_Item12;
	
	GOODS_DESCS[1] = Shop_ItemInfo1_Text;
	GOODS_DESCS[2] = Shop_ItemInfo2_Text;
	GOODS_DESCS[3] = Shop_ItemInfo3_Text;
	GOODS_DESCS[4] = Shop_ItemInfo4_Text;
	GOODS_DESCS[5] = Shop_ItemInfo5_Text;
	GOODS_DESCS[6] = Shop_ItemInfo6_Text;
	GOODS_DESCS[7] = Shop_ItemInfo7_Text;
	GOODS_DESCS[8] = Shop_ItemInfo8_Text;
	GOODS_DESCS[9] = Shop_ItemInfo9_Text;
	GOODS_DESCS[10]= Shop_ItemInfo10_Text;
	GOODS_DESCS[11]= Shop_ItemInfo11_Text;
	GOODS_DESCS[12]= Shop_ItemInfo12_Text;
	
	GOODS_PRICE[1] = Shop_ItemInfo1_Price;
	GOODS_PRICE[2] = Shop_ItemInfo2_Price;
	GOODS_PRICE[3] = Shop_ItemInfo3_Price;
	GOODS_PRICE[4] = Shop_ItemInfo4_Price;
	GOODS_PRICE[5] = Shop_ItemInfo5_Price;
	GOODS_PRICE[6] = Shop_ItemInfo6_Price;
	GOODS_PRICE[7] = Shop_ItemInfo7_Price;
	GOODS_PRICE[8] = Shop_ItemInfo8_Price;
	GOODS_PRICE[9] = Shop_ItemInfo9_Price;
	GOODS_PRICE[10]= Shop_ItemInfo10_Price;
	GOODS_PRICE[11]= Shop_ItemInfo11_Price;
	GOODS_PRICE[12]= Shop_ItemInfo12_Price;
	
	GOOD_BAD[1]  =     Shop_ItemInfo1_GB;
	GOOD_BAD[2]  =     Shop_ItemInfo2_GB;
	GOOD_BAD[3]  =     Shop_ItemInfo3_GB;
	GOOD_BAD[4]  =     Shop_ItemInfo4_GB;
	GOOD_BAD[5]  =     Shop_ItemInfo5_GB;
	GOOD_BAD[6]  =     Shop_ItemInfo6_GB;
	GOOD_BAD[7]  =     Shop_ItemInfo7_GB;
	GOOD_BAD[8]  =     Shop_ItemInfo8_GB;
	GOOD_BAD[9]  =     Shop_ItemInfo9_GB;
	GOOD_BAD[10] =     Shop_ItemInfo10_GB;
	GOOD_BAD[11] =     Shop_ItemInfo11_GB;
	GOOD_BAD[12] =     Shop_ItemInfo12_GB;
	
	CALLBACK_BUTTON[1] = Shop_Callback1;
	CALLBACK_BUTTON[2] = Shop_Callback2;
	CALLBACK_BUTTON[3] = Shop_Callback3;
	CALLBACK_BUTTON[4] = Shop_Callback4;
	CALLBACK_BUTTON[5] = Shop_Callback5;
	
	CALLBACK_BUTTON_FRAME[1] = Shop_Callback1_Frame;
	CALLBACK_BUTTON_FRAME[2] = Shop_Callback2_Frame;
	CALLBACK_BUTTON_FRAME[3] = Shop_Callback3_Frame;
	CALLBACK_BUTTON_FRAME[4] = Shop_Callback4_Frame;
	CALLBACK_BUTTON_FRAME[5] = Shop_Callback5_Frame;
	

end

--===============================================
-- OnEvent
--===============================================
function Shop_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Booth_Close();
		-- 显示经验
	end

	local nMult = NpcShop:GetShopType("buymult");		--modi:lby20071107 增加是否能批量购买
	
	if nMult <= 0 then
		Shop_Wholesale:Disable();
	else
		Shop_Wholesale:Enable();
	end 
	
	if ( event == "OPEN_BOOTH" ) then
		--使用什么作为货币
		local nUnit = NpcShop:GetShopType("unit");
		if(CU_YUANBAO == nUnit) then	--元宝
			Shop_querengoumai_Text:Show();
			Shop_querengoumai:Show();
			local check  = tonumber(NpcShop:GetBuyDirectly());
			if(check>=1)then
				Shop_querengoumai:SetCheck(0);
			else
				Shop_querengoumai:SetCheck(1);
			end
		else
			Shop_querengoumai_Text:Hide();
			Shop_querengoumai:Hide();
		end
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide();
		end
		g_nTotalNum	= 0;
		this:Show();
		Shop_Text:SetText("#gFF0FA0"..Target:GetShopNpcName());

		--关心商人Obj
		objCared = NpcShop:GetNpcId();
		if( 0 > objCared ) then
			Shop_Text:SetText("");
		end
		this:CareObject(objCared, 1, "Shop");
		NpcShop:CloseConfirm();
		Shop_UpdatePage(1);
		
		if(IsWindowShow("Shop_Fitting")) then
			RestoreShopFitting();
			--CloseShopFitting();
			CloseWindow("Shop_Fitting", true);
		end
		SetDefaultMouse();
		
	elseif ( event == "UPDATE_BOOTH" ) then
		Shop_UpdatePage(nPageNum);
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			SetDefaultMouse();
			--RestoreShopFitting();
			--CloseShopFitting();
			this:CareObject(objCared, 0, "Shop");
			NpcShop:CloseConfirm();
			this:Hide();			
		end
		
	elseif (event == "CLOSE_BOOTH") then
		--取消关心
		RestoreShopFitting();
		this:CareObject(objCared, 0, "Shop");
		NpcShop:CloseConfirm();
		this:Hide();	
		if(IsWindowShow("Shop_Fitting")) then
			--RestoreShopFitting();
			--CloseShopFitting();
			CloseWindow("Shop_Fitting", true);
		end
		
		SetDefaultMouse();
	
	end
end

function Shop_OnBtnClicked_OpenFitting()
	
	if IsIdleLogic() ~= 1 then
		SetNotifyTip("不能进行此操作。");
		return 0;
	end
	
	if(IsWindowShow("Shop_Fitting")) then
		--RestoreShopFitting();
		--CloseShopFitting();
		CloseWindow("Shop_Fitting", true);
	end
	--CloseShopFitting();
	this:Show();	
	MouseCmd_ShopFittingSet();
	SetNotifyTip("请点击您要试穿的时装或试骑的坐骑。");
end

--===============================================
-- UpdatePage
--===============================================
function Shop_UpdatePage(thePage)
	Shop_AllRepair:Show();
	
	Shop_Repair:Show();

	--收购
	local nBuyType = NpcShop:GetShopType("buy");
	if( nBuyType <= 0 )  then 
		Shop_Callback1:Hide(); 
		Shop_Callback1_Frame:Hide();
	else
		Shop_Callback1:Show();
		Shop_Callback1_Frame:Show();
	end

	--修理
	local nRepairType = NpcShop:GetShopType("repair");
	if( nRepairType <= 0 )  then 
		Shop_AllRepair:Hide();
		Shop_Repair:Hide();
	else
		Shop_AllRepair:Show();
		Shop_Repair:Show();
	end
	
	--回购
	local nCallbackType = NpcShop:GetShopType("callback");
	if( nCallbackType <= 0 ) then
		for i=1, 5 do
			CALLBACK_BUTTON_FRAME[i]:Hide();
		end
	else
		for i=1, 5 do
			CALLBACK_BUTTON_FRAME[i]:Show();
		end
		
		-- 显示回购物品
		nActIndex = 0;
		local nCallNum = NpcShop:GetCallBackNum();
		i=1;
		while i<=nCallNum do
			local theAction = NpcShop:EnumCallBackItem(nActIndex);
	
			if theAction:GetID() ~= 0 then
				CALLBACK_BUTTON[i]:SetActionItem(theAction:GetID());
				i = i+1;
			else
				CALLBACK_BUTTON[i]:SetActionItem(-1);
				i = i+1;
			end
			nActIndex = nActIndex+1;
		end
	end
	
	--使用什么作为货币
	local nUnit = NpcShop:GetShopType("unit");
	if(CU_MONEY	== nUnit or CU_TICKET == nUnit or CU_MONEYJZ == nUnit)       then      --钱，官票钱, 交子
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Hide()
			GOODS_PRICE[i]:Show();
		end
	elseif(CU_GOODBAD == nUnit) then			--善恶值
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide();
		end
	elseif(CU_MORALPOINT == nUnit)  then	--师德点
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide();
		end
	elseif(CU_YUANBAO == nUnit) then	--元宝
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide();
		end
	elseif(CU_ZENGDIAN == nUnit) then	--赠点
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide();
		end
	elseif(CU_MENPAI_POINT == nUnit) then	--门派贡献度
		for i=1, GOODS_BUTTONS_NUM  do
			GOOD_BAD[i]:Show()
			GOODS_PRICE[i]:Hide();
		end
	end

	local	i	= 1;
	if g_nTotalNum == 0 or g_nTotalNum ~= GetActionNum("boothitem") then
		g_nTotalNum	= GetActionNum("boothitem");
		Booth_Order();
	end
		
	-- 计算总页数
	local	nTotalPage;
	if( g_nTotalNum < 1 ) then
		nTotalPage	= 1;
	else
		nTotalPage	= math.floor((g_nTotalNum-1)/GOODS_BUTTONS_NUM)+1;
	end

	maxPage = nTotalPage;
	
	if(thePage < 1 or thePage > nTotalPage) then 
		return;	
	end
	--HEQUIP_DRESS		=16,	//时装                   
	--HEQUIP_RIDER		=8,		//骑乘	                          护符
	local bHaveRide=0;
	
	nPageNum = thePage;

	local nStartIndex = (thePage-1)*GOODS_BUTTONS_NUM;

	local nActIndex = nStartIndex;
	i	= 1;
	while i <= GOODS_BUTTONS_NUM do
		local	idx	= g_tOrderPool[nActIndex+1];
		if idx == nil then
			idx	= -1;
		end

		local theAction = EnumAction(idx, "boothitem");
		if theAction:GetID() ~= 0 then
			local nEquipPoint = theAction:GetEquipPoint();
			
			if nEquipPoint == 16 or nEquipPoint == 8 then
				bHaveRide = 1;
			end
			
			AxTrace(0,0, "jinggy:"..theAction:GetID().." nEquipPoint:"..nEquipPoint );
			AxTrace(0,0, "Name:"..theAction:GetName() );
			
			GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(theAction:GetItemColorInShop()~="") then
				GOODS_DESCS[i]:SetText( theAction:GetItemColorInShop()..theAction:GetName() );
			else
				GOODS_DESCS[i]:SetText( theAction:GetName() );
			end
			local	nPrice	= NpcShop:EnumItemPrice( idx )
			if( nUnit == CU_GOODBAD ) then
				GOOD_BAD[i]:SetText("善恶值:" .. tostring(nPrice) .. " 点")
			elseif( nUnit == CU_MORALPOINT ) then
				GOOD_BAD[i]:SetText("师德点:" .. tostring(nPrice) .. " 点")
			elseif( nUnit == CU_YUANBAO ) then
				GOOD_BAD[i]:SetText("元宝:" .. tostring(nPrice))
			elseif( nUnit == CU_ZENGDIAN ) then
				GOOD_BAD[i]:SetText("赠点:" .. tostring(nPrice))
			elseif( nUnit == CU_MENPAI_POINT ) then
				GOOD_BAD[i]:SetText("门派贡献度:" .. tostring(nPrice))
			elseif( nUnit == CU_MONEYJZ ) then
				GOODS_PRICE[i]:SetProperty("GoldIcon", "set:Button6 image:Lace_JiaoziJin")
				GOODS_PRICE[i]:SetProperty("SilverIcon", "set:Button6 image:Lace_JiaoziYin")
				GOODS_PRICE[i]:SetProperty("CopperIcon", "set:Button6 image:Lace_JiaoziTong")
			  GOODS_PRICE[i]:SetProperty("MoneyNumber", tostring(nPrice))
			else	--钱，官票钱
				GOODS_PRICE[i]:SetProperty("GoldIcon", "set:Button2 image:Icon_GoldCoin")
				GOODS_PRICE[i]:SetProperty("SilverIcon", "set:Button2 image:Icon_SilverCoin")
				GOODS_PRICE[i]:SetProperty("CopperIcon", "set:Button2 image:Icon_CopperCoin")
				GOODS_PRICE[i]:SetProperty("MoneyNumber", tostring(nPrice))
			end
			i = i+1;
		else
			GOODS_BUTTONS[i]:SetActionItem(-1);
			GOODS_DESCS[i]:SetText("");
			GOODS_PRICE[i]:SetText("");

			if(CU_MONEY	== nUnit or CU_TICKET == nUnit or CU_MONEYJZ == nUnit) then	--钱，官票钱, 交子
				GOODS_PRICE[i]:Hide();
			else
				GOOD_BAD[i]:SetText("");
			end
			
			i = i+1;		
		end
		nActIndex = nActIndex+1;
	end


	if bHaveRide >= 1 then
		Shop_Try:Show();		
	else
		Shop_Try:Hide();	
	end
	
	if( nTotalPage == 1 ) then
		Shop_UpPage:Hide();
		Shop_DownPage:Hide();
		Shop_CurrentlyPage:Hide();
	else
		Shop_UpPage:Show();
		Shop_DownPage:Show();
		Shop_CurrentlyPage:Show();
		
		Shop_UpPage:Enable();
		Shop_DownPage:Enable();

		if ( nPageNum == nTotalPage ) then
			Shop_DownPage:Disable();
		end
		
		if ( nPageNum == 1 ) then
			Shop_UpPage:Disable()
		end

		Shop_CurrentlyPage:SetText(tostring(nPageNum) .. "/" .. tostring(nTotalPage) );
	end
end


--===============================================
-- Button_Clicked
--===============================================
function GoodButton_Clicked(nIndex)
	if(nIndex < 1 or nIndex > 12) then 
		return;
	end
	GOODS_BUTTONS[nIndex]:DoAction();
end

--===============================================
-- PageUp
--===============================================
function Booth_PageUp()
	curPage = nPageNum - 1;
	if ( curPage >= maxPage ) then
		curPage = maxPage;
	end
	NpcShop:CloseConfirm();
	Shop_UpdatePage( curPage );
end

--===============================================
-- PageDown
--===============================================
function Booth_PageDown()
	curPage = nPageNum + 1;
	if ( curPage < 0 )  then
		curPage = 0;
	end
	NpcShop:CloseConfirm();
	Shop_UpdatePage( curPage );
end

--===============================================
-- Close
--===============================================
function Booth_Close()
	
	if(IsWindowShow("Shop_Fitting")) then
		--RestoreShopFitting();
		--CloseShopFitting();
		CloseWindow("Shop_Fitting", true);
	--	RestoreShopFitting();		
		AxTrace(0,0,"jinggy");
	end
	
	SetDefaultMouse();
	
	CloseBooth();	
	--取消关心
	this:CareObject(objCared, 0, "Shop");
	NpcShop:CloseConfirm();
--	RestoreShopFitting();
--	CloseShopFitting();
	this:Hide();
end

--===============================================
-- Goods_Clicked
--===============================================
function Sold_Goods_Clicked(nIndex)

	if(IsWindowShow("Shop_Fitting")) then
		--RestoreShopFitting();
		--CloseShopFitting();
		CloseWindow("Shop_Fitting", true);
	end

	CALLBACK_BUTTON[nIndex]:DoAction();
end

--===============================================
-- RepairAll
--===============================================
function Booth_RepairAll()
	RepairAll();
end

--===============================================
-- RepairOne
--===============================================
function Booth_RepairOne()
	RepairOne();
end

--===============================================
-- MouseEnter
--===============================================
function Booth_RepairAll_MouseEnter()
	
	local nMoney = NpcShop:GetRepairAllPrice()
	
	local nGold,nSilver,nCopper = Bank:TransformCoin(nMoney);
	
	local szMoney = "";
	
	if(nGold~=0)   then
		szMoney = tostring(nGold) .. "#-14" ; --zchw 
	end
	
	if(nSilver~=0) then
		szMoney = szMoney .. tostring(nSilver) .. "#-15" --zchw
	end 
	
	szMoney = szMoney .. tostring(nCopper) .. "#-16" --zchw
	
	Shop_AllRepair:SetToolTip("全部修理#r费用：" .. szMoney);

end

function Booth_Sale()
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end
	PrepearSale();
end

function Booth_BuyMult()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	PrepearBuyMult();
end

--随机排序
function Booth_Order()
	local	max		= g_nTotalNum;
	local oldt	= {};
	g_tOrderPool= {};

	for i = 1, tonumber(max) do
	  oldt[i] = i-1;
	end
	
	if tonumber(NpcShop:GetIsShopReorder()) == 0 then
		g_tOrderPool		= oldt;
	else
		for i = 1, table.getn(oldt) do
		 local idx	= math.random(1, table.getn(oldt));
		 local val	= oldt[idx];
		 g_tOrderPool[i]= val;
		 table.remove(oldt, idx);
		end
	end
end

function Shop_querengoumai_Clicked()
	if(NpcShop:GetBuyDirectly() == 0)then
		Shop_querengoumai:SetCheck(0);
		NpcShop:SetBuyDirectly(1);
	else
		Shop_querengoumai:SetCheck(1);
		NpcShop:SetBuyDirectly(0);
	end
end