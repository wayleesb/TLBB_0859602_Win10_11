local g_InitiativeClose = 0;

--背包及其编号
local PACK_BUTTONS_NUM = 5;
local PACK_BUTTONS = {};

--格子及其编号
local GRID_BUTTONS_NUM = 20;
local GRID_BUTTONS = {};

--实际每个背包具有的格子数
local nUsedGrid = {};

--当前打开的租赁箱
local g_CurrentRentBox = 1;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


--===============================================
-- OnLoad()
--===============================================
function Bank_PreLoad()

	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("UPDATE_BANK");
	this:RegisterEvent("OBJECT_CARED_EVENT");
end
	
function Bank_OnLoad()
	GRID_BUTTONS[1]  = Bank_Item1;
	GRID_BUTTONS[2]  = Bank_Item2;
	GRID_BUTTONS[3]  = Bank_Item3;
	GRID_BUTTONS[4]  = Bank_Item4;
	GRID_BUTTONS[5]  = Bank_Item5;
	GRID_BUTTONS[6]  = Bank_Item6;
	GRID_BUTTONS[7]  = Bank_Item7;
	GRID_BUTTONS[8]  = Bank_Item8;
	GRID_BUTTONS[9]  = Bank_Item9;
	GRID_BUTTONS[10] = Bank_Item10;
	GRID_BUTTONS[11] = Bank_Item11;
	GRID_BUTTONS[12] = Bank_Item12;
	GRID_BUTTONS[13] = Bank_Item13;
	GRID_BUTTONS[14] = Bank_Item14;
	GRID_BUTTONS[15] = Bank_Item15;
	GRID_BUTTONS[16] = Bank_Item16;
	GRID_BUTTONS[17] = Bank_Item17;
	GRID_BUTTONS[18] = Bank_Item18;
	GRID_BUTTONS[19] = Bank_Item19;
	GRID_BUTTONS[20] = Bank_Item20;
										 
	PACK_BUTTONS[1]  = Bank_patulousBox_1;
	PACK_BUTTONS[2]  = Bank_patulousBox_2;
	PACK_BUTTONS[3]  = Bank_patulousBox_3;
	PACK_BUTTONS[4]  = Bank_patulousBox_4;
	PACK_BUTTONS[5]  = Bank_patulousBox_5;
	

end										


--===============================================
-- OnEvent
--===============================================
function Bank_OnEvent(event)

	if(event == "TOGLE_BANK") then
		this:Show();
		g_InitiativeClose = 0;
		
		--关心NPC
		objCared = Bank:GetNpcId();
		this:CareObject(objCared, 1, "Bank");
		
		for i=1, PACK_BUTTONS_NUM do
			PACK_BUTTONS[i]:Hide();
		end
		
		--获得已经拥有的租赁箱个数
		local nRentNum = Bank:GetRentBoxNum();
		--设置已经拥有的租赁箱的图标
		for i=1, nRentNum do
			PACK_BUTTONS[i]:Show();
		end
		
		g_CurrentRentBox = 1;
		Bank_UpdateFrame(g_CurrentRentBox);
		
	elseif(event == "UPDATE_BANK")  then
		Bank_UpdateFrame(g_CurrentRentBox);
	
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();
			Bank:Close();

			--取消关心
			this:CareObject(objCared, 0, "Bank");
		end

	end
end

--===============================================
-- Bank_UpdateFrame
--===============================================
function Bank_UpdateFrame(nIndex)

		Bank:SetCurRentIndex(nIndex);
		for i=1, PACK_BUTTONS_NUM do
			if(i==nIndex) then
				PACK_BUTTONS[i]:SetPushed(1);
			else
				PACK_BUTTONS[i]:SetPushed(0);
			end
		end
		
		for i=1, GRID_BUTTONS_NUM do
			GRID_BUTTONS[i]:SetActionItem(-1);
			GRID_BUTTONS[i]:Enable();
		end
	
	
	--处理金钱
	local nMoney;
	local nGoldCoin;	
	local nSilverCoin;
	local nCopperCoin;

	nMoney,nGoldCoin,nSilverCoin,nCopperCoin = Bank:GetBankMoney();
	--Bank_Gold:SetText(tostring(nGoldCoin));
	--Bank_Silver:SetText(tostring(nSilverCoin));
	--Bank_CopperCoin:SetText(tostring(nCopperCoin));
	Bank_Money:SetProperty("MoneyNumber", tostring(nMoney));
	
	
		
	--获得这个背包可以使用的格子数
	local nBeginIndex,nGridNum = Bank:GetRentBoxInfo(nIndex);
	
	--点亮这些可以使用的格子，置灰不能使用的格子
	for i=1, nGridNum do
		GRID_BUTTONS[i]:Show();
	end
	
	for i=nGridNum+1 ,GRID_BUTTONS_NUM do
		GRID_BUTTONS[i]:SetProperty("NormalImage","set:Common2 image:Unopened_Normal");
		GRID_BUTTONS[i]:SetProperty("Empty","False");
		--设置四个角的数字，全设置为空
		GRID_BUTTONS[i]:SetProperty("CornerChar","TopLeft ");
		GRID_BUTTONS[i]:SetProperty("CornerChar","TopRight ");
		GRID_BUTTONS[i]:SetProperty("CornerChar","BotLeft ");
		GRID_BUTTONS[i]:SetProperty("CornerChar","BotRight ");
		GRID_BUTTONS[i]:Disable();
	end

	--从数据池中使用数据填入背包内的物品
	local nTotalNum = GetActionNum("bankitem");
	
	--AxTrace(0, 0, "Bank:nTotalNum =  " .. nTotalNum);

	local nActIndex = nBeginIndex;
	local i=1;
	
	--AxTrace(0, 0, "Bank:nActIndex =  " .. nActIndex);
	
	for i=1,  nGridNum  do
		
		local theAction, bLocked = Bank:EnumItem(nActIndex);
		nActIndex = nActIndex+1;

		--AxTrace(0, 0, "Bank:nActIndex =  " .. nActIndex);

		if theAction:GetID() ~= 0 then
			GRID_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(bLocked == true) then 
				GRID_BUTTONS[i]:Disable();
			else
				GRID_BUTTONS[i]:Enable();
			end
		else
			GRID_BUTTONS[i]:SetActionItem(-1);
		end
		
	end

end

--===============================================
-- 打开存钱的对话框
--===============================================
function Bank_Save_Clicked()
	Bank:OpenSaveFrame();
end

--===============================================
-- 打开取钱的对话框
--===============================================
function Bank_Get_Clicked()
	Bank:OpenGetFrame();
end


--===============================================
-- 点击租赁箱的操作 
--===============================================
function Bank_patulousBox_Clicked(nIndex)

	g_CurrentRentBox = nIndex;
	--AxTrace(0, 0, "Bank:g_CurrentRentBox =  " .. g_CurrentRentBox);
	Bank_UpdateFrame(nIndex);

end

--===============================================
-- 点击关闭
--===============================================
function Bank_Close_Clicked()
	if(g_InitiativeClose == 1)  then
		return;
	end
	
	this:CareObject(objCared, 0, "Bank");
	this:Hide();
	Bank:Close();
end


--========================================================================
--
-- 设置二级密码。
--
--========================================================================
function Bank_SuperPassword_Clicked()

		Player:SetSupperPassword();
end;