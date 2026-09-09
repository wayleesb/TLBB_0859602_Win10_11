local g_InitiativeClose = 0;

--主动关闭窗口的一个标志
local g_CloseSign;		-- 

--button的个数
local BUTTON_NUMBER = 5;
--自己的
local SELF_BUTTON = {};
local SELF_TEXT = {};
--对方的
local OTHER_BUTTON = {};
local OTHER_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 6.0;

--交易能放入的最多的宠物数量
local MAX_PET_NUM  = 5;
local g_nSelfPetID = {};				--宠物ID表
local g_nOtherPetID = {};				--宠物ID表

local g_LastLockTime = 0;
local LOCK_TIME_DIFF = 10000           --10秒

--===============================================
-- OnLoad()
--===============================================
function Exchange_PreLoad()

	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("UPDATE_EXCHANGE");
	this:RegisterEvent("CANCEL_EXCHANGE");
	this:RegisterEvent("SUCCEED_EXCHANGE_CLOSE");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("EXCHANGE_ENABLE_ACCBTN");	
end

function Exchange_OnLoad()
	
	SELF_BUTTON[1] = Self_Exchange_Item1;
	SELF_BUTTON[2] = Self_Exchange_Item2;
	SELF_BUTTON[3] = Self_Exchange_Item3;
	SELF_BUTTON[4] = Self_Exchange_Item4;
	SELF_BUTTON[5] = Self_Exchange_Item5;
	SELF_BUTTON[6] = Self_Exchange_Item6;
	
	SELF_TEXT[1] = Self_Exchange_Item_Text1;
	SELF_TEXT[2] = Self_Exchange_Item_Text2;
	SELF_TEXT[3] = Self_Exchange_Item_Text3;
	SELF_TEXT[4] = Self_Exchange_Item_Text4;
	SELF_TEXT[5] = Self_Exchange_Item_Text5;
	SELF_TEXT[6] = Self_Exchange_Item_Text6;
	
	OTHER_BUTTON[1] = Other_Exchange_Item1;
	OTHER_BUTTON[2] = Other_Exchange_Item2;
	OTHER_BUTTON[3] = Other_Exchange_Item3;
	OTHER_BUTTON[4] = Other_Exchange_Item4;
	OTHER_BUTTON[5] = Other_Exchange_Item5;
	OTHER_BUTTON[6] = Other_Exchange_Item6;

	OTHER_TEXT[1] = Other_Exchange_Item_Text1;
	OTHER_TEXT[2] = Other_Exchange_Item_Text2;
	OTHER_TEXT[3] = Other_Exchange_Item_Text3;
	OTHER_TEXT[4] = Other_Exchange_Item_Text4;
	OTHER_TEXT[5] = Other_Exchange_Item_Text5;
	OTHER_TEXT[6] = Other_Exchange_Item_Text6;
	
	for i=0, MAX_PET_NUM    do
		g_nSelfPetID[i] = -1;
		g_nOtherPetID[i] = -1
	end
end

--===============================================
-- OnEvent()
--===============================================
function Exchange_OnEvent(event)

	if(event == "OPEN_EXCHANGE_FRAME") then
		--关心NPC
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "Exchange");
		ExchangeValidate_StopWatch1:SetProperty("Timer", "300");
		g_InitiativeClose = 0;
		--Update	
		Exchange_UpdateFrame();
		Exchange_Checkbox_other_Locked:Disable();
		Exchange_Frame:SetProperty("UnifiedXPosition","{0.0,0}");
		Exchange_Frame:SetProperty("UnifiedYPosition","{0.12,0}");
		this:Show();
		
	elseif(event == "UPDATE_EXCHANGE") then
		Exchange_UpdateFrame();
		
	elseif(evnet == "CANCEL_EXCHANGE") then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--取消关心
		this:CareObject(objCared, 0, "Exchange");
		
	elseif(event == "SUCCEED_EXCHANGE_CLOSE") then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--取消关心
		this:CareObject(objCared, 0, "Exchange");
	
	--死亡的时候需要取消交易
	elseif(event == "RELIVE_SHOW" and this:IsVisible()) then
		g_InitiativeClose = 1;
		this:Hide();
		Exchange:CloseExchangeInfo();
		--取消关心
		this:CareObject(objCared, 0, "Exchange");
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();
			Exchange:CloseExchangeInfo();
			
			--取消关心
			this:CareObject(objCared, 0, "Exchange");
		end
	
	elseif( event == "ACCELERATE_KEYSEND" and this:IsVisible()) then
		this:Hide();
		Exchange:CloseExchangeInfo();
		--取消关心
		this:CareObject(objCared, 0, "Exchange");
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		this:Hide();
		Exchange:CloseExchangeInfo();
		--取消关心
		this:CareObject(objCared, 0, "Exchange");
	end

	if event == "EXCHANGE_ENABLE_ACCBTN" then	--服务端返回验证是否通过....

		if not this:IsVisible() then
			return;
		end
		Exchange_UpdateFrame();
	end
end

--===============================================
-- 更新界面
--===============================================
function Exchange_UpdateFrame()

	--交易双方的名字
	--自己的
	Exchange_SelfName:SetText(Player:GetName());
	
	--对方的
	Exchange_OtherName:SetText("#b#c0000FF#effffff"..Exchange:GetOthersName());

	--对方的锁定按钮，（一直不可用）
	Exchange_Other_Locked_Button:Disable();
	--自己的交易按钮，（双方锁定后可用）
	Trade_Accept_Button:Disable();
	
	--======================
	--处理金钱
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	--对方的金钱数字
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Exchange:GetMoney("other");
	Exchange_Other_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--自己的金钱数字
	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Exchange:GetMoney("self");
	Exchange_Slfe_Money:SetProperty("MoneyNumber", tostring(nMoney));

	--=======================
	--处理物品
	--自己的
	local nSelfTotalNum = GetActionNum("ex_self");
	--AxTrace(0, 0, "Exchange:nSelfTotalNum =  " .. nSelfTotalNum);
	
	for i=0, BUTTON_NUMBER-1  do

		local theAction = EnumAction(i, "ex_self");

		--AxTrace(0, 0, "Exchange:nActIndex =  " .. i);

		if theAction:GetID() ~= 0 then
			SELF_BUTTON[i+1]:SetActionItem(theAction:GetID());
			SELF_TEXT[i+1]:SetText(theAction:GetName());
		else
			SELF_BUTTON[i+1]:SetActionItem(-1);
			SELF_TEXT[i+1]:SetText("");
		end
	
	end

	--对方的
	local nOtherTotalNum = GetActionNum("ex_other");
	--AxTrace(0, 0, "Exchange:nOtherTotalNum =  " .. nOtherTotalNum);

	for i=0, BUTTON_NUMBER-1  do

		local theAction = EnumAction(i, "ex_other");

		--AxTrace(0, 0, "Bank:nActIndex =  " .. i);

		if theAction:GetID() ~= 0 then
			OTHER_BUTTON[i+1]:SetActionItem(theAction:GetID());
			OTHER_TEXT[i+1]:SetText(theAction:GetName());
		else
			OTHER_BUTTON[i+1]:SetActionItem(-1);
			OTHER_TEXT[i+1]:SetText("");
		end

	end
	
	--=======================
	--处理锁定状态,从数据池获得数据，然后通知界面表现出来
	local bIsSelfLocked = Exchange:IsLocked("self");
	local bIsOtherLocked = Exchange:IsLocked("other");

	--自己的交易按钮，（双方锁定后可用）
	if( bIsSelfLocked == true ) then
		if( bIsOtherLocked == true ) then
			Trade_Accept_Button:Enable();
		end
	end
	
	--自己的
	local bIsSelfLocked = Exchange:IsLocked("self");
	if( bIsSelfLocked == true ) then
		Exchange_Checkbox_Locked:SetCheck(1);
		Exchange_Locked_Button:SetText("取消锁定");
	elseif ( bIsSelfLocked == false) then
		Exchange_Checkbox_Locked:SetCheck(0);
		Exchange_Locked_Button:SetText("锁定交易");
	end
	
	--对方的
	if( bIsOtherLocked == true ) then
		Exchange_Checkbox_other_Locked:SetCheck(1);
		Exchange_Other_Locked_Button:SetText("已经锁定");
	elseif ( bIsOtherLocked == false) then
		Exchange_Checkbox_other_Locked:SetCheck(0);
		Exchange_Other_Locked_Button:SetText("尚未锁定");
	end
	
	--=======================
	--处理宠物
	--自己的
	Exchange_Self_PetList:ClearListBox();
	
	--local nNum = Exchange:GetPetNum("self");
	local nIndex = 0;
	for i=1, MAX_PET_NUM     do
		local szPetName = Exchange:EnumPet("self", i-1);
		if( szPetName ~= "" )then
			Exchange_Self_PetList:AddItem(szPetName, nIndex);
			g_nSelfPetID[nIndex] = i-1;
			nIndex = nIndex + 1;
		end
	end
	
	--对方的
	Exchange_Other_PetList:ClearListBox();
	nIndex = 0;
	--local nNum = Exchange:GetPetNum("other");
	for i=1, MAX_PET_NUM      do
		local szPetName = Exchange:EnumPet("other", i-1);
		if( szPetName ~= "" )  then
			Exchange_Other_PetList:AddItem(szPetName, nIndex);
			g_nOtherPetID[nIndex] = i-1;
			nIndex = nIndex+1;
		end
	end

end

--===============================================
-- 窗口关闭执行的   Hidden
--===============================================
function Exchange_Cancel()

	Exchange:ExchangeCancel();
	--取消关心
	this:CareObject(objCared, 0, "Exchange");

end

--===============================================
-- 点击锁定
--===============================================
function Exchange_Lock_Button_Clicked()

	local nNowTickCount = Exchange:GetTickCount();
	local bSelfIsLock = Exchange:IsLocked("self");
	
	if (bSelfIsLock == true) then	    --原来是锁定，准备取消锁定
		g_LastLockTime = nNowTickCount;		
	else                               --原来未锁定，准备锁定
		if(g_LastLockTime >0 and (nNowTickCount - g_LastLockTime) < LOCK_TIME_DIFF) then
			Exchange_Checkbox_Locked:SetCheck(0);
			PushDebugMessage("#{JYTX_090303_1}");
			return;
		end
	end
	
	Exchange:LockExchange();
end


--===============================================
-- 点击交易（同意交易）
--===============================================
function Trade_Accept_Button_Clicked()

	Trade_Accept_Button:Disable();
	Exchange:AcceptExchange();

end


--===============================================
-- 打开金钱对话框
--===============================================
function Exchange_Open_InputMoney_Clicked()

	Exchange:OpenPetFrame();

end

--===============================================
-- 删除选中的宠物
--===============================================
function Trade_DeletePet_Button_Clicked()
	
	local nIndex = Exchange_Self_PetList:GetFirstSelectItem();
	if(nIndex == -1)    then
		return ;
	end
	Exchange:DelSelectPet(g_nSelfPetID[nIndex]);
	
end 

--===============================================
-- 右键点击
--===============================================
function Exchange_Other_PetList_RClick()
	local nIndex = Exchange_Other_PetList:GetFirstSelectItem();
	
	if(nIndex == -1) then
		return ;
	end
	
	Exchange:ViewPetDesc("other",g_nOtherPetID[nIndex]);
end

--===============================================
-- 右键点击
--===============================================
function Exchange_Self_PetList_RClick()
	local nIndex = Exchange_Self_PetList:GetFirstSelectItem();

	if(nIndex == -1) then
		return ;
	end

	Exchange:ViewPetDesc("self",g_nSelfPetID[nIndex]);	
end

function ExchangeValidate_TimeReach1()
    PushDebugMessage("交易超时，请重新交易。");
    Exchange_Cancel();
    ExchangeValidate_StopWatch1:SetProperty("Timer", "-1");
end