
local g_nTheTabIndex = 0;
local PACKAGE_BUTTONS_NUM = 30;
local PACKAGE_BUTTONS = {};
local PACKAGE_TAB_TEXT = {};
local	LOCK_ICON = {};
local PACKAGE_EXTBAG_NUM = 10;
local PACKAGE_EXTBAG = {};

local g_CurSelect			= -1;
local g_CurSelectPet	= -1;
local g_PetIndex = {};

local PET_MAX_NUMBER = 6+4	--最大珍兽携带上限(包括兽栏)--add by xindefeng

--===============================================
-- PreLoad
--===============================================
function ItemCoffer_PreLoad()

	this:RegisterEvent("OPEN_ITEM_COFFER");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	
	this:RegisterEvent("UPDATE_ITEM_COFFER");
	this:RegisterEvent("UPDATE_PET_LIST");
	this:RegisterEvent("RESET_EXT_BAG");
	this:RegisterEvent("UI_COMMAND");

end

--===============================================
-- OnLoad
--===============================================
function ItemCoffer_OnLoad()

	PACKAGE_BUTTONS[1] = ItemCoffer_1;
	PACKAGE_BUTTONS[2] = ItemCoffer_2;
	PACKAGE_BUTTONS[3] = ItemCoffer_3;
	PACKAGE_BUTTONS[4] = ItemCoffer_4;
	PACKAGE_BUTTONS[5] = ItemCoffer_5;
	PACKAGE_BUTTONS[6] = ItemCoffer_6;
	PACKAGE_BUTTONS[7] = ItemCoffer_7;
	PACKAGE_BUTTONS[8] = ItemCoffer_8;
	PACKAGE_BUTTONS[9] = ItemCoffer_9;
	PACKAGE_BUTTONS[10] = ItemCoffer_10;
	PACKAGE_BUTTONS[11] = ItemCoffer_11;
	PACKAGE_BUTTONS[12] = ItemCoffer_12;
	PACKAGE_BUTTONS[13] = ItemCoffer_13;
	PACKAGE_BUTTONS[14] = ItemCoffer_14;
	PACKAGE_BUTTONS[15] = ItemCoffer_15;
	PACKAGE_BUTTONS[16] = ItemCoffer_16;
	PACKAGE_BUTTONS[17] = ItemCoffer_17;
	PACKAGE_BUTTONS[18] = ItemCoffer_18;
	PACKAGE_BUTTONS[19] = ItemCoffer_19;
	PACKAGE_BUTTONS[20] = ItemCoffer_20;
	PACKAGE_BUTTONS[21] = ItemCoffer_21;
	PACKAGE_BUTTONS[22] = ItemCoffer_22;
	PACKAGE_BUTTONS[23] = ItemCoffer_23;
	PACKAGE_BUTTONS[24] = ItemCoffer_24;
	PACKAGE_BUTTONS[25] = ItemCoffer_25;
	PACKAGE_BUTTONS[26] = ItemCoffer_26;
	PACKAGE_BUTTONS[27] = ItemCoffer_27;
	PACKAGE_BUTTONS[28] = ItemCoffer_28;
	PACKAGE_BUTTONS[29] = ItemCoffer_29;
	PACKAGE_BUTTONS[30] = ItemCoffer_30;
	
	LOCK_ICON[1]  = ItemCofferIcon_1;
	LOCK_ICON[2]  = ItemCofferIcon_2;
	LOCK_ICON[3]  = ItemCofferIcon_3;
	LOCK_ICON[4]  = ItemCofferIcon_4;
	LOCK_ICON[5]  = ItemCofferIcon_5;
	LOCK_ICON[6]  = ItemCofferIcon_6;
	LOCK_ICON[7]  = ItemCofferIcon_7;
	LOCK_ICON[8]  = ItemCofferIcon_8;
	LOCK_ICON[9]  = ItemCofferIcon_9;
	LOCK_ICON[10] = ItemCofferIcon_10; 
	LOCK_ICON[11] = ItemCofferIcon_11; 
	LOCK_ICON[12] = ItemCofferIcon_12; 
	LOCK_ICON[13] = ItemCofferIcon_13; 
	LOCK_ICON[14] = ItemCofferIcon_14; 
	LOCK_ICON[15] = ItemCofferIcon_15; 
	LOCK_ICON[16] = ItemCofferIcon_16; 
	LOCK_ICON[17] = ItemCofferIcon_17; 
	LOCK_ICON[18] = ItemCofferIcon_18; 
	LOCK_ICON[19] = ItemCofferIcon_19; 
	LOCK_ICON[20] = ItemCofferIcon_20; 
	LOCK_ICON[21] = ItemCofferIcon_21;
	LOCK_ICON[22] = ItemCofferIcon_22;
	LOCK_ICON[23] = ItemCofferIcon_23;
	LOCK_ICON[24] = ItemCofferIcon_24;
	LOCK_ICON[25] = ItemCofferIcon_25;
	LOCK_ICON[26] = ItemCofferIcon_26;
	LOCK_ICON[27] = ItemCofferIcon_27;
	LOCK_ICON[28] = ItemCofferIcon_28;
	LOCK_ICON[29] = ItemCofferIcon_29;
	LOCK_ICON[30] = ItemCofferIcon_30; 
		
	PACKAGE_EXTBAG[1]  = ItemCoffer_21;
	PACKAGE_EXTBAG[2]  = ItemCoffer_22;
	PACKAGE_EXTBAG[3]  = ItemCoffer_23;
	PACKAGE_EXTBAG[4]  = ItemCoffer_24;
	PACKAGE_EXTBAG[5]  = ItemCoffer_25;
	PACKAGE_EXTBAG[6]  = ItemCoffer_26;
	PACKAGE_EXTBAG[7]  = ItemCoffer_27;
	PACKAGE_EXTBAG[8]  = ItemCoffer_28;
	PACKAGE_EXTBAG[9]  = ItemCoffer_29;
	PACKAGE_EXTBAG[10] = ItemCoffer_30; 
	
	PACKAGE_TAB_TEXT = {
		[0] = "道具",
		"材料",
		"珍兽",
	};
	
end

--===============================================
-- OnEvent
--===============================================
function ItemCoffer_OnEvent(event)

	if ( event == "OPEN_ITEM_COFFER" )         then
		this:Show();
		g_nTheTabIndex = tonumber(arg0);
		g_CurSelect = -1;
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "UPDATE_ITEM_COFFER" )   then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "UPDATE_PET_LIST" )   then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);

	elseif ( event == "RESET_EXT_BAG" ) then
		ItemCoffer_UpdateFrame(g_nTheTabIndex);
		
	elseif ( event == "UI_COMMAND" ) then
		if ( tonumber(arg0) == 5421 ) then
			this:Show();
			g_nTheTabIndex = tonumber(0);
			g_CurSelect = -1;
			ItemCoffer_UpdateFrame(g_nTheTabIndex);
		end

	end
	
end

--===============================================
-- OnEvent
--===============================================
function ItemCoffer_UpdateFrame(nIndex)


	--先隐藏所有锁定图标
	for i=1 ,PACKAGE_BUTTONS_NUM   do
		LOCK_ICON[i]:Hide();
	end

	local i=1;
	local szPacketName = "";
	local CurrNum = 20;
	local BaseNum = 20;
	local MaxNum = 30;

	ItemCoffer_PetList:Hide();
	ItemCoffer_Set:Hide();
	if(nIndex == 0) then
		CurrNum = DataPool:GetBaseBag_Num();
		BaseNum = DataPool:GetBaseBag_BaseNum();
		MaxNum = DataPool:GetBaseBag_MaxNum();
		ItemCoffer_Check_Material:SetCheck(1);
		szPacketName = "base";
		
		for i=1 ,BaseNum  do
			PACKAGE_BUTTONS[i]:Show();
		end
		i = 1;
		while i <= CurrNum-BaseNum do
			PACKAGE_EXTBAG[i]:Show();
			PACKAGE_BUTTONS[BaseNum+i]:Enable();
			PACKAGE_BUTTONS[BaseNum+i]:Show();
			i = i + 1;
		end
		i = CurrNum-BaseNum+1;
		while i <= MaxNum-BaseNum do
			PACKAGE_EXTBAG[i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Disable();
			i = i + 1;
		end
		ItemCoffer_Set:Show();
		ItemCoffer_UpDateItem(szPacketName);
		
	elseif(nIndex == 1) then
		CurrNum = DataPool:GetMatBag_Num();
		BaseNum = DataPool:GetMatBag_BaseNum();
		MaxNum = DataPool:GetMatBag_MaxNum();

		ItemCoffer_Check_Stall:SetCheck(1);
		szPacketName = "material";
		
		for i=1 ,BaseNum  do
			PACKAGE_BUTTONS[i]:Show();
		end
		i = 1;
		while i <= CurrNum-BaseNum do
			PACKAGE_EXTBAG[i]:Show();
			PACKAGE_BUTTONS[BaseNum+i]:Enable();
			PACKAGE_BUTTONS[BaseNum+i]:Show();
			i = i + 1;
		end
		i = CurrNum-BaseNum+1;
		while i <= MaxNum-BaseNum do
			PACKAGE_EXTBAG[i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Hide();
			PACKAGE_BUTTONS[BaseNum+i]:Disable();
			i = i + 1;
		end
		ItemCoffer_Set:Show();
		ItemCoffer_UpDateItem(szPacketName);
		
	elseif(nIndex == 2) then
		MaxNum = DataPool:GetTaskBag_MaxNum();

		ItemCoffer_Check_Pet:SetCheck(1);
		szPacketName = "pet";
		
		for i=1 ,MaxNum  do
			PACKAGE_BUTTONS[i]:Hide();
		end
		ItemCoffer_PetList:Show();
		ItemCoffer_UpDatePet();
		
	end
	
	ItemCoffer_UpdateRect( CurrNum );
end

function ItemCoffer_UpdateRect( currNum )
	local offset = 55;
	local buttonHeight = 45;
	local itemHeight = 38;
	local nLine = math.floor( currNum / 5 );
	if( nLine * 5 < currNum ) then
		nLine = nLine + 1;
	end
	ItemCoffer_Frame:SetProperty( "AbsoluteHeight",nLine * itemHeight + offset + buttonHeight );
		
	
end
--===============================================
-- 更新物品
--===============================================
function ItemCoffer_UpDateItem(szPacketName)

	local i=1;
	while i<=PACKAGE_BUTTONS_NUM do
		local theAction,bLocked,bProtect,nUnlockElapsedTime = PlayerPackage:EnumItem(szPacketName, i-1);

		if theAction:GetID() ~= 0 then
			PACKAGE_BUTTONS[i]:SetActionItem(theAction:GetID());
			if( g_CurSelect == i )   then 
				PACKAGE_BUTTONS[i]:SetPushed(1);
			else
				PACKAGE_BUTTONS[i]:SetPushed(0);
			end
		else
			PACKAGE_BUTTONS[i]:SetActionItem(-1);
		end
		
		if bLocked == 1 then
			PACKAGE_BUTTONS[i]:Disable();
		else
			PACKAGE_BUTTONS[i]:Enable();
		end
		
		if( bProtect == 1 )   then
			LOCK_ICON[i]:Show();
			
			if( nUnlockElapsedTime == 0 ) then
				LOCK_ICON[i]:SetProperty("Image","set:UIIcons image:Icon_Lock");
			else
				LOCK_ICON[i]:SetProperty("Image","set:CommonFrame6 image:NewLock");
			end
		end

		i = i+1;
	end
end

--===============================================
-- 更新珍兽
--===============================================
function ItemCoffer_UpDatePet()

	ItemCoffer_PetList:ClearListBox();
	local nPetCount = Pet:GetPet_Count();
	local PetInListIndex = 0;

	for	i=1, PET_MAX_NUMBER do	--modify by xindefeng
		local szPetName,szOn = Pet:GetPetList_Appoint(i-1);
		local strToolTips = "";
		if(szPetName ~= "")   then
			if( szOn ~= "on_packa" )  then 
				szPetName = "#c808080" .. szPetName;
			end
			if(PlayerPackage:IsPetLock(i-1) == 1)    then
				local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(i-1);
				if( nUnlockElapsedTime == 0 ) then
					szPetName = szPetName.. "  #-05";
					
					strToolTips =  "已加锁" ;
				else
					szPetName = szPetName.. "  #-10";
					
					local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);			
					strToolTips = strLeftTime ;
				end
			end
		
			ItemCoffer_PetList:AddItem(szPetName, PetInListIndex);
			
			ItemCoffer_PetList:SetItemTooltip( PetInListIndex, strToolTips );
			
			g_PetIndex[PetInListIndex] = i-1;
			PetInListIndex = PetInListIndex + 1 ;
		end	
	end
end


--===============================================
-- 选中珍兽
--===============================================
function ItemCoffer_ListSelected()
	
end

--===============================================
-- 右键选中珍兽
--===============================================
function ItemCoffer_ShowTargetPet()
	local nIndex = ItemCoffer_PetList:GetFirstSelectItem();

	if( -1 == nIndex ) then
		return;
	end
	Pet:ShowTargetPet(g_PetIndex[nIndex]);
end

--===============================================
-- 换页
--===============================================
function ItemCoffer_Check_ChangeTabIndex(nIndex)
	PlayerPackage:OpenLockFrame(nIndex);
	
end

--===============================================
-- 加锁
--===============================================
function ItemCoffer_Lock_Clicked()

	if( g_nTheTabIndex == 2 )  then  -- 珍兽界面
		local nPetIndex = ItemCoffer_PetList:GetFirstSelectItem();
		if(nPetIndex == -1)  then
			PlayerPackage:Lock("lock", "pet", -1);
		else
			PlayerPackage:Lock("lock", "pet", g_PetIndex[nPetIndex]);
		end
		
	else
		if( g_CurSelect == -1 )  then 
			PlayerPackage:Lock("lock", "item", -1);
		else
			PlayerPackage:Lock("lock", "item", g_nTheTabIndex*PACKAGE_BUTTONS_NUM + g_CurSelect-1);
		end
	end
	
end

--===============================================
-- 解锁
--===============================================
function ItemCoffer_Unlock_Clicked()

	if( g_nTheTabIndex == 2 )  then  -- 珍兽界面
		local nPetIndex = ItemCoffer_PetList:GetFirstSelectItem();
		if(nPetIndex == -1)  then
			PlayerPackage:Lock("unlock", "pet", -1);
		else
			PlayerPackage:Lock("unlock", "pet", g_PetIndex[nPetIndex]);
		end
		
	else
		if( g_CurSelect == -1 )  then 
			PlayerPackage:Lock("unlock", "item", -1);
		else
			PlayerPackage:Lock("unlock", "item", g_nTheTabIndex*PACKAGE_BUTTONS_NUM + g_CurSelect-1);
		end
	end
	
end

--===============================================
-- 选中物品
--===============================================
function ItemCofferClicked(nIndex)
	g_CurSelect = nIndex;
	ItemCoffer_UpdateFrame(g_nTheTabIndex)
end

