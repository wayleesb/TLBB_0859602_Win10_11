local PS_BUTTON_NUM = 20;
local PS_BUTTON = {};

-- 下列两个值需要保持同步（物品ID、物品位置）
local g_nCurSelectItemID = -1;
local g_nCurSelectItem = -1;
local g_nCurStallIndex = -1;
local g_StallNum = 0;

--标志当前是珍兽界面还是物品界面
local STALL_NONE = 0
local STALL_ITEM = 1;
local STALL_PET  = 2;
local g_CurStallObj = STALL_NONE;
local g_PetIndex = {};

local PS_STALL_NUM = 10;
local PS_STALL_BOTTON = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- OnLoad
--===============================================
function PS_Shop_PreLoad()
	this:RegisterEvent("PS_OPEN_OTHER_SHOP");
	this:RegisterEvent("PS_OTHER_SELECT");
	this:RegisterEvent("PS_UPDATE_OTHER_SHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_ALL_SHOP");
	
end

function PS_Shop_OnLoad()
	PS_BUTTON[1] = PS_Shop_Item1;
	PS_BUTTON[2] = PS_Shop_Item2;
	PS_BUTTON[3] = PS_Shop_Item3;
	PS_BUTTON[4] = PS_Shop_Item4;
	PS_BUTTON[5] = PS_Shop_Item5;
	PS_BUTTON[6] = PS_Shop_Item6;
	PS_BUTTON[7] = PS_Shop_Item7;
	PS_BUTTON[8] = PS_Shop_Item8;
	PS_BUTTON[9] = PS_Shop_Item9;
	PS_BUTTON[10] = PS_Shop_Item10;
	PS_BUTTON[11] = PS_Shop_Item11;
	PS_BUTTON[12] = PS_Shop_Item12;
	PS_BUTTON[13] = PS_Shop_Item13;
	PS_BUTTON[14] = PS_Shop_Item14;
	PS_BUTTON[15] = PS_Shop_Item15;
	PS_BUTTON[16] = PS_Shop_Item16;
	PS_BUTTON[17] = PS_Shop_Item17;
	PS_BUTTON[18] = PS_Shop_Item18;
	PS_BUTTON[19] = PS_Shop_Item19;
	PS_BUTTON[20] = PS_Shop_Item20;
	
	PS_STALL_BOTTON[1]   = PS_Shop_Page1;
	PS_STALL_BOTTON[2]   = PS_Shop_Page2;
	PS_STALL_BOTTON[3]   = PS_Shop_Page3;
	PS_STALL_BOTTON[4]   = PS_Shop_Page4;
	PS_STALL_BOTTON[5]   = PS_Shop_Page5;
	PS_STALL_BOTTON[6]   = PS_Shop_Page6;
	PS_STALL_BOTTON[7]   = PS_Shop_Page7;
	PS_STALL_BOTTON[8]   = PS_Shop_Page8;
	PS_STALL_BOTTON[9]   = PS_Shop_Page9;
	PS_STALL_BOTTON[10]  = PS_Shop_Page10;


	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end
	
end

--===============================================
-- OnEvent
--===============================================
function PS_Shop_OnEvent(event)
	if ( event == "PS_OPEN_OTHER_SHOP" )   then

		this:Show();
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Shop");	
		
		--切换是珍兽还是物品
		if( tonumber(arg1) == 1 ) then
			g_CurStallObj = STALL_ITEM;
			PS_Shop_PetList:Hide();
			for  i=1, PS_BUTTON_NUM   do
				PS_BUTTON[i]:Show();
			end
		else
			g_CurStallObj = STALL_PET;
			PS_Shop_PetList:Show();
			for  i=1, PS_BUTTON_NUM   do
				PS_BUTTON[i]:Hide();
			end
		end
		
		g_nCurStallIndex = 1;
		g_StallNum = PlayerShop:GetStallNum("other");
		
		PS_Shop_UpdateFrame();
		
	elseif( event == "PS_OTHER_SELECT" ) then
		if(this:IsVisible() and g_nCurStallIndex ~=-1) then
			g_nCurSelectItem = PlayerShop:GetSelectIndex("other");
			--g_nCurStallIndex = PlayerShop:GetCurSelectPage("other");

			PS_Shop_UpdateFrame();
		end
	elseif( event == "PS_UPDATE_OTHER_SHOP" ) then 
		PS_Shop_UpdateFrame();
	
	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_Shop");
		end	
	
	elseif( event == "PS_CLOSE_ALL_SHOP" )    then
		
		this:Hide();
		--取消关心
		this:CareObject(objCared, 0, "PS_Shop");
	
	end

end

--===============================================
-- UpdateFrame()
--===============================================
function PS_Shop_UpdateFrame()
	
	--通知C ++
	PlayerShop:SetCurSelectPage("other",g_nCurStallIndex-1);
	
	--店主	--改为超链接 by wangdw 2008.05.27
	local szName = PlayerShop:GetShopInfo("other","ownername");
	PS_Shop_Master_Text:SetChatString("#Y店主:#{_INFOUSR" .. szName .. "}");
	--PS_Shop_Master_Text:SetText("#Y店主:#{_INFOUSR" .. szName .. "}");
	--店主ID
	local szID = PlayerShop:GetShopInfo("other","ownerid");
	PS_Shop_ID_Text:SetText("ID:" .. szID);
	
	--店名
	local szShopName = PlayerShop:GetShopInfo("other","shopname");
	PS_Shop_Name_Text:SetText("店铺名:" .. szShopName);
	PS_Shop_DragTitle:SetText("#gFF0FA0" ..szShopName);

	--界面控件的一些更新
	if( g_nCurStallIndex == 1 )  then
		PS_Shop_Last:Disable();
	else
		PS_Shop_Last:Enable();
	end
	if( g_nCurStallIndex == g_StallNum )   then
		PS_Shop_Next:Disable();
	else
		PS_Shop_Next:Enable();
	end
	PS_Shop_PageNum:SetText( tostring(g_nCurStallIndex).."/".. tostring(g_StallNum));


	--提示这个柜台当前的状态是Open还是Close
	g_bCurStallOpen = PlayerShop:IsOpenStall("other",g_nCurStallIndex -1);
	
	if (g_bCurStallOpen == 2)  then 
		PS_Shop_State:SetText("#G开张");
	else
		PS_Shop_State:SetText("#R打烊");
	end

	--能够点击的1234567890
	for i=1 ,PS_STALL_NUM  do
		PS_STALL_BOTTON[i]:Disable();
	end
	for i=1 ,g_StallNum  do
		PS_STALL_BOTTON[i]:Enable();
	end

	
	if( g_CurStallObj == STALL_ITEM )then
		PS_Shop_UpdateItem();
	else
		PS_Shop_UpdatePet();
	end
	
	--显示选中内容的价格
	if( g_CurStallObj == STALL_ITEM )then
		--物品
		local nMoney = PlayerShop:GetObjPrice("other","item");
		PS_Shop_TargetItem_Money:SetProperty("MoneyNumber", tostring(nMoney));
		
		local szItemName;
		local szNum;
		szItemName,szNum = PlayerShop:GetObjName("other","item");
		
		PS_Shop_TargetItem_Name:SetText(szItemName);
		PS_Shop_Item_Num:SetText(szNum);
		
	else
		--珍兽
		local nMoney = PlayerShop:GetObjPrice("other","pet");
		PS_Shop_TargetItem_Money:SetProperty("MoneyNumber", tostring(nMoney));
		
		local szPetName;
		local szNum;
		szPetName,szNum = PlayerShop:GetObjName("other","pet");
		PS_Shop_TargetItem_Name:SetText(szPetName);
		PS_Shop_Item_Num:SetText(szNum);

	end
	PS_STALL_BOTTON[g_nCurStallIndex]:SetCheck(1);
end

--===============================================
-- PS_Shop_UpdatePet()
--===============================================
function PS_Shop_UpdatePet()

	PS_Shop_PetList:ClearListBox();
	
	local PetInListIndex = 0
	for i=1,  20  do
		local szPetName, szType = PlayerShop:EnumPet("other",g_nCurStallIndex -1, i-1);
		if (szPetName ~= "")   then

			PS_Shop_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")", PetInListIndex);
			g_PetIndex[PetInListIndex] = i-1;
			
			PetInListIndex = PetInListIndex + 1 ;
		end
	end

end

--===============================================
-- UpdateFrame()
--===============================================
function PS_Shop_UpdateItem()
	
	--注意当前绘制的是第g_nCurStallIndex个柜台上的物品
	g_nCurSelectItem = PlayerShop:GetSelectIndex("other");

	for i=1, PS_BUTTON_NUM    do
		local theAction, bLocked = PlayerShop:EnumItem(g_nCurStallIndex-1, i-1, "other");

		if theAction:GetID() ~= 0 then
			PS_BUTTON[i]:SetActionItem(theAction:GetID());
			
			if (g_nCurSelectItem == i )   then 
				PS_BUTTON[i]:SetPushed(1);
			else
				PS_BUTTON[i]:SetPushed(0);
			end
			if(bLocked == true) then 
				PS_BUTTON[i]:Disable();
			else
				PS_BUTTON[i]:Enable();
			end
		else
			PS_BUTTON[i]:SetActionItem(-1);
		end
	end
end

--===============================================
-- 选择珍兽列表
--===============================================
function PS_Shop_PetList_Selected()

	local nIndex = PS_Shop_PetList:GetFirstSelectItem();
	
	if( nIndex == -1 )  then 
		return;
	end
	
	--通知C＋＋
	PlayerShop:SetCurSelectPetIndex("other",g_nCurStallIndex-1,g_PetIndex[nIndex]);
	--PS_Shop_UpdateFrame();
	
	--通知界面刷新"名称"和"价格"
	-- 显示现在的选中的物品或者是珍兽的价格
		--珍兽
	local nMoney = PlayerShop:GetObjPrice("other","pet");
	--价格
	PS_Shop_TargetItem_Money:SetProperty("MoneyNumber", tostring(nMoney));
	--名称
	local szPetName = PlayerShop:GetObjName("other","pet");
	PS_Shop_TargetItem_Name:SetText(szPetName);
		

end

--===============================================
-- 点击购买
--===============================================
function PS_Shop_BuyClick()
	if( g_CurStallObj == STALL_ITEM )  then
		PlayerShop:BuyItem("item");
	else
	
		local nIndex = PS_Shop_PetList:GetFirstSelectItem();
		
		if( nIndex == -1 )  then 
			PushDebugMessage("请先选中一个珍兽。");
			return;
		end
		
		PlayerShop:BuyItem("pet");
	end
	
end

--===============================================
-- 点击离开
--===============================================
function PS_Shop_ExitClick()
	this:Hide()
	--取消关心
	this:CareObject(objCared, 0, "PS_Shop");
	
	--关闭珍兽列表界面
	PlayerShop:CloseShop("other");

end

--===============================================
-- 上一间
--===============================================
function PS_Shop_Last_Click()
	if(g_nCurStallIndex == 1) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex - 1;

	--向服务器请求数据
	PS_Shop_Last:Disable();	
	PS_Shop_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- 下一间
--===============================================
function PS_Shop_Next_Click()
	if(g_nCurStallIndex == g_StallNum) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex + 1;

	--向服务器请求数据
	PS_Shop_Last:Disable();	
	PS_Shop_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- 1 2 3 4 5 6 7 8 9 10
--===============================================
function PS_Shop_Page_Click(nIndex)

	g_nCurStallIndex = nIndex;

	--向服务器请求数据
	PS_Shop_Last:Disable();	
	PS_Shop_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- RClick
--===============================================
function PS_Shop_PetList_RClick()
	local nIndex = PS_Shop_PetList:GetFirstSelectItem();
	
	if( nIndex == -1 )   then
		return;
	end
	
	PlayerShop:ViewPetDesc("other",g_PetIndex[nIndex]);
	
end
