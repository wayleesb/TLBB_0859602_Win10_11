
local PS_BUTTON_NUM = 20;
local PS_BUTTON = {};

-- 下列两个值需要保持同步（物品ID、物品位置）
local g_nCurSelectItemID = -1;
local g_nCurSelectItem = -1;
local g_nCurStallIndex = -1;
local g_StallNum = 0;

--标志当前是宠物界面还是物品界面
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
-- OnLoad()
--===============================================
function PS_Transfer_PreLoad()

	this:RegisterEvent("PS_OPEN_OTHER_TRANS");
	this:RegisterEvent("PS_UPDATE_OTHER_TRANS");
	this:RegisterEvent("PS_OTHER_TRANS_SELECT");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_MONEY");

end

function PS_Transfer_OnLoad()
	PS_BUTTON[1]  = PS_Transfer_Item1; 
	PS_BUTTON[2]  = PS_Transfer_Item2; 
	PS_BUTTON[3]  = PS_Transfer_Item3; 
	PS_BUTTON[4]  = PS_Transfer_Item4; 
	PS_BUTTON[5]  = PS_Transfer_Item5; 
	PS_BUTTON[6]  = PS_Transfer_Item6; 
	PS_BUTTON[7]  = PS_Transfer_Item7; 
	PS_BUTTON[8]  = PS_Transfer_Item8; 
	PS_BUTTON[9]  = PS_Transfer_Item9; 
	PS_BUTTON[10] = PS_Transfer_Item10;
	PS_BUTTON[11] = PS_Transfer_Item11;
	PS_BUTTON[12] = PS_Transfer_Item12;
	PS_BUTTON[13] = PS_Transfer_Item13;
	PS_BUTTON[14] = PS_Transfer_Item14;
	PS_BUTTON[15] = PS_Transfer_Item15;
	PS_BUTTON[16] = PS_Transfer_Item16;
	PS_BUTTON[17] = PS_Transfer_Item17;
	PS_BUTTON[18] = PS_Transfer_Item18;
	PS_BUTTON[19] = PS_Transfer_Item19;
	PS_BUTTON[20] = PS_Transfer_Item20;

	PS_STALL_BOTTON[1]   = PS_Transfer_Page1;
	PS_STALL_BOTTON[2]   = PS_Transfer_Page2;
	PS_STALL_BOTTON[3]   = PS_Transfer_Page3;
	PS_STALL_BOTTON[4]   = PS_Transfer_Page4;
	PS_STALL_BOTTON[5]   = PS_Transfer_Page5;
	PS_STALL_BOTTON[6]   = PS_Transfer_Page6;
	PS_STALL_BOTTON[7]   = PS_Transfer_Page7;
	PS_STALL_BOTTON[8]   = PS_Transfer_Page8;
	PS_STALL_BOTTON[9]   = PS_Transfer_Page9;
	PS_STALL_BOTTON[10]  = PS_Transfer_Page10;
	
	for i=1 ,20   do
		g_PetIndex[i] = -1;
	end

end

--===============================================
-- OnEvent
--===============================================
function PS_Transfer_OnEvent(event)

	if ( event == "PS_OPEN_OTHER_TRANS" )   then
	
		this:Show();
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Transfer");	
		
		--切换是宠物还是物品
		if( tonumber(arg1) == 1 ) then
			g_CurStallObj = STALL_ITEM;
			PS_Transfer_Item_Set:Show();
			PS_Transfer_PetList:Hide();
			for  i=1, PS_BUTTON_NUM   do
				PS_BUTTON[i]:Show();
			end
		else
			g_CurStallObj = STALL_PET;
			PS_Transfer_Item_Set:Hide();
			PS_Transfer_PetList:Show();
			for  i=1, PS_BUTTON_NUM   do
				PS_BUTTON[i]:Hide();
			end
		end
		
		g_nCurStallIndex = 1;
		g_StallNum = PlayerShop:GetStallNum("other");
		
		PS_Transfer_UpdateFrame();
		
	elseif ( event == "PS_UPDATE_OTHER_TRANS" )   then
		PS_Transfer_UpdateFrame();
	
	elseif ( event == "PS_OTHER_TRANS_SELECT" )   then
		--PS_Transfer_UpdateFrame();
	
	elseif ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_Transfer");
		end	
	elseif(event =="UNIT_MONEY") then
		PS_Transfer_Self_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	end
end


--===============================================
-- OnEvent
--===============================================
function PS_Transfer_UpdateFrame()
	--通知C ++
	PlayerShop:SetCurSelectPage("other",g_nCurStallIndex-1);
	
	--店主	--改为超链接 by wangdw
	local szName = PlayerShop:GetShopInfo("other","ownername");
	PS_Transfer_Master:SetChatString("#Y店主:#{_INFOUSR".. szName .. "}");
	--店主ID
	local szID = PlayerShop:GetShopInfo("other","ownerid");
	PS_Transfer_ID:SetText("ID: ".. szID);
	
	--店名
	local szShopName = PlayerShop:GetShopInfo("other","shopname");
	PS_Transfer_Name_Text:SetText("店铺名:" .. szShopName);
	PS_Transfer_PageHeader_Name:SetText("#gFF0FA0" ..szShopName);
	
	--当前本金
	local nBaseMoney = PlayerShop:GetMoney("base","other");
	PS_Transfer_CurBase_Money:SetProperty("MoneyNumber", tostring(nBaseMoney));
	
	--赢利资金
	local nProfitMoney = PlayerShop:GetMoney("profit","other");
	PS_Transfer_Gain_Money:SetProperty("MoneyNumber", tostring(nProfitMoney));
	
	--盘出店价格
	local nSaleOutMoney = PlayerShop:GetMoney("saleout","other");
	PS_Transfer_Sale_Money:SetProperty("MoneyNumber", tostring(nSaleOutMoney));
	
	--身上现金
	PS_Transfer_Self_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

	--界面控件的一些更新
	if( g_nCurStallIndex == 1 )  then
		PS_Transfer_Last:Disable();
	else
		PS_Transfer_Last:Enable();
	end
	if( g_nCurStallIndex == g_StallNum )   then
		PS_Transfer_Next:Disable();
	else
		PS_Transfer_Next:Enable();
	end
	PS_Transfer_PageNum:SetText(tostring(g_nCurStallIndex).."/".. tostring(g_StallNum));
	
	--能够点击的1234567890
	for i=1 ,PS_STALL_NUM  do
		PS_STALL_BOTTON[i]:Disable();
	end
	for i=1 ,g_StallNum  do
		PS_STALL_BOTTON[i]:Enable();
	end
	
	if( g_CurStallObj == STALL_ITEM )then
		PS_Transfer_UpdateItem();
	else
		PS_Transfer_UpdatePet();
	end
	PS_STALL_BOTTON[g_nCurStallIndex]:SetCheck(1);
end

--===============================================
-- UpdatePet
--===============================================
function PS_Transfer_UpdatePet()
	PS_Transfer_PetList:ClearListBox();
	
	local PetInListIndex = 0
	for i=1,  20  do
		local szPetName,szType = PlayerShop:EnumPet("other",g_nCurStallIndex -1, i-1);
		if (szPetName ~= "")   then

			PS_Transfer_PetList:AddItem(szPetName .. "#cffff00 (" .. szType .. ")", PetInListIndex);
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end
	end
end


--===============================================
-- UpdateItem
--===============================================
function PS_Transfer_UpdateItem()
	--更新商品
	for i=1, PS_BUTTON_NUM    do
		local theAction, bLocked = PlayerShop:EnumItem(g_nCurStallIndex-1, i-1, "other");

		if theAction:GetID() ~= 0 then
			PS_BUTTON[i]:SetActionItem(theAction:GetID());
			
			if g_nCurSelectItem == i   then 
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
-- 购买
--===============================================
function PS_Transfer_BuyClick()
	local HaveMoney = Player:GetData("MONEY");
	local nSaleOutMoney = PlayerShop:GetMoney("saleout","other");
	if(tonumber(HaveMoney)<tonumber(nSaleOutMoney))then
		PushDebugMessage("#{GMGameInterface_Script_PlayerShop_NOMONEY}")
		return
	end
	local nlevel = Player:GetData( "LEVEL" );
	if(nlevel<50)then
		PushDebugMessage("#{GMGameInterface_Script_PlayerShop_12}")
		return
	end
	PlayerShop:BuyShop();
	
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Transfer");
end

--===============================================
-- 离开
--===============================================
function PS_Transfer_ExitClick()
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Transfer");
end

--===============================================
-- 选择编号
--===============================================
function PS_Transfer_Page_Click(nIndex)

	g_nCurStallIndex = nIndex;

	--向服务器请求数据
	PS_Transfer_Last:Disable();	
	PS_Transfer_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- 上一间
--===============================================
function PS_Transfer_Last_Click()
	
	if(g_nCurStallIndex == 1) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex - 1;

	--向服务器请求数据
	PS_Transfer_Last:Disable();	
	PS_Transfer_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- 下一间
--===============================================
function PS_Transfer_Next_Click()
	
	if(g_nCurStallIndex == g_StallNum) then
		return;
	end
	
	g_nCurStallIndex = g_nCurStallIndex + 1;

	--向服务器请求数据
	PS_Transfer_Last:Disable();	
	PS_Transfer_Next:Disable();
	local i;
	for  i = 1 ,PS_STALL_NUM  do  
		PS_STALL_BOTTON[i]:Disable();
	end
	
	PlayerShop:AskStallData("other",g_nCurStallIndex -1);

end

--===============================================
-- 左键选中宠物
--===============================================
function PS_Transfer_PetList_Selected()
	
	local nIndex = PS_Transfer_PetList:GetFirstSelectItem();

end

--===============================================
-- 右键选中宠物
--===============================================
function PS_Transfer_PetList_RClick()

	local nIndex = PS_Transfer_PetList:GetFirstSelectItem();
	
	if( nIndex == -1 )   then
		return;
	end
	
	PlayerShop:ViewPetDesc("other",g_PetIndex[nIndex]);

end
