
local g_nTheTabIndex = 0;
local PACKAGE_BUTTONS_NUM = 100;
local PACKAGE_NUM_PER_LINE = 10;
local PACKAGE_BUTTONS = {};
local PACKAGE_TAB_TEXT = {};
local	LOCK_ICON = {};

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
	PACKAGE_BUTTONS[31] = ItemCoffer_31;
	PACKAGE_BUTTONS[32] = ItemCoffer_32;
	PACKAGE_BUTTONS[33] = ItemCoffer_33;
	PACKAGE_BUTTONS[34] = ItemCoffer_34;
	PACKAGE_BUTTONS[35] = ItemCoffer_35;
	PACKAGE_BUTTONS[36] = ItemCoffer_36;
	PACKAGE_BUTTONS[37] = ItemCoffer_37;
	PACKAGE_BUTTONS[38] = ItemCoffer_38;
	PACKAGE_BUTTONS[39] = ItemCoffer_39;
	PACKAGE_BUTTONS[40] = ItemCoffer_40;
	PACKAGE_BUTTONS[41] = ItemCoffer_41;
	PACKAGE_BUTTONS[42] = ItemCoffer_42;
	PACKAGE_BUTTONS[43] = ItemCoffer_43;
	PACKAGE_BUTTONS[44] = ItemCoffer_44;
	PACKAGE_BUTTONS[45] = ItemCoffer_45;
	PACKAGE_BUTTONS[46] = ItemCoffer_46;
	PACKAGE_BUTTONS[47] = ItemCoffer_47;
	PACKAGE_BUTTONS[48] = ItemCoffer_48;
	PACKAGE_BUTTONS[49] = ItemCoffer_49;
	PACKAGE_BUTTONS[50] = ItemCoffer_50;
	PACKAGE_BUTTONS[51] = ItemCoffer_51;
	PACKAGE_BUTTONS[52] = ItemCoffer_52;
	PACKAGE_BUTTONS[53] = ItemCoffer_53;
	PACKAGE_BUTTONS[54] = ItemCoffer_54;
	PACKAGE_BUTTONS[55] = ItemCoffer_55;
	PACKAGE_BUTTONS[56] = ItemCoffer_56;
	PACKAGE_BUTTONS[57] = ItemCoffer_57;
	PACKAGE_BUTTONS[58] = ItemCoffer_58;
	PACKAGE_BUTTONS[59] = ItemCoffer_59;
	PACKAGE_BUTTONS[60] = ItemCoffer_60;
	PACKAGE_BUTTONS[61] = ItemCoffer_61;
	PACKAGE_BUTTONS[62] = ItemCoffer_62;
	PACKAGE_BUTTONS[63] = ItemCoffer_63;
	PACKAGE_BUTTONS[64] = ItemCoffer_64;
	PACKAGE_BUTTONS[65] = ItemCoffer_65;
	PACKAGE_BUTTONS[66] = ItemCoffer_66;
	PACKAGE_BUTTONS[67] = ItemCoffer_67;
	PACKAGE_BUTTONS[68] = ItemCoffer_68;
	PACKAGE_BUTTONS[69] = ItemCoffer_69;
	PACKAGE_BUTTONS[70] = ItemCoffer_70;
	PACKAGE_BUTTONS[71] = ItemCoffer_71;
	PACKAGE_BUTTONS[72] = ItemCoffer_72;
	PACKAGE_BUTTONS[73] = ItemCoffer_73;
	PACKAGE_BUTTONS[74] = ItemCoffer_74;
	PACKAGE_BUTTONS[75] = ItemCoffer_75;
	PACKAGE_BUTTONS[76] = ItemCoffer_76;
	PACKAGE_BUTTONS[77] = ItemCoffer_77;
	PACKAGE_BUTTONS[78] = ItemCoffer_78;
	PACKAGE_BUTTONS[79] = ItemCoffer_79;
	PACKAGE_BUTTONS[80] = ItemCoffer_80;
	PACKAGE_BUTTONS[81] = ItemCoffer_81;
	PACKAGE_BUTTONS[82] = ItemCoffer_82;
	PACKAGE_BUTTONS[83] = ItemCoffer_83;
	PACKAGE_BUTTONS[84] = ItemCoffer_84;
	PACKAGE_BUTTONS[85] = ItemCoffer_85;
	PACKAGE_BUTTONS[86] = ItemCoffer_86;
	PACKAGE_BUTTONS[87] = ItemCoffer_87;
	PACKAGE_BUTTONS[88] = ItemCoffer_88;
	PACKAGE_BUTTONS[89] = ItemCoffer_89;
	PACKAGE_BUTTONS[90] = ItemCoffer_90;
	PACKAGE_BUTTONS[91] = ItemCoffer_91;
	PACKAGE_BUTTONS[92] = ItemCoffer_92;
	PACKAGE_BUTTONS[93] = ItemCoffer_93;
	PACKAGE_BUTTONS[94] = ItemCoffer_94;
	PACKAGE_BUTTONS[95] = ItemCoffer_95;
	PACKAGE_BUTTONS[96] = ItemCoffer_96;
	PACKAGE_BUTTONS[97] = ItemCoffer_97;
	PACKAGE_BUTTONS[98] = ItemCoffer_98;
	PACKAGE_BUTTONS[99] = ItemCoffer_99;
	PACKAGE_BUTTONS[100] = ItemCoffer_100;

	LOCK_ICON[1] = ItemCofferIcon_1;
	LOCK_ICON[2] = ItemCofferIcon_2;
	LOCK_ICON[3] = ItemCofferIcon_3;
	LOCK_ICON[4] = ItemCofferIcon_4;
	LOCK_ICON[5] = ItemCofferIcon_5;
	LOCK_ICON[6] = ItemCofferIcon_6;
	LOCK_ICON[7] = ItemCofferIcon_7;
	LOCK_ICON[8] = ItemCofferIcon_8;
	LOCK_ICON[9] = ItemCofferIcon_9;
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
	LOCK_ICON[31] = ItemCofferIcon_31;
	LOCK_ICON[32] = ItemCofferIcon_32;
	LOCK_ICON[33] = ItemCofferIcon_33;
	LOCK_ICON[34] = ItemCofferIcon_34;
	LOCK_ICON[35] = ItemCofferIcon_35;
	LOCK_ICON[36] = ItemCofferIcon_36;
	LOCK_ICON[37] = ItemCofferIcon_37;
	LOCK_ICON[38] = ItemCofferIcon_38;
	LOCK_ICON[39] = ItemCofferIcon_39;
	LOCK_ICON[40] = ItemCofferIcon_40;
	LOCK_ICON[41] = ItemCofferIcon_41;
	LOCK_ICON[42] = ItemCofferIcon_42;
	LOCK_ICON[43] = ItemCofferIcon_43;
	LOCK_ICON[44] = ItemCofferIcon_44;
	LOCK_ICON[45] = ItemCofferIcon_45;
	LOCK_ICON[46] = ItemCofferIcon_46;
	LOCK_ICON[47] = ItemCofferIcon_47;
	LOCK_ICON[48] = ItemCofferIcon_48;
	LOCK_ICON[49] = ItemCofferIcon_49;
	LOCK_ICON[50] = ItemCofferIcon_50;
	LOCK_ICON[51] = ItemCofferIcon_51;
	LOCK_ICON[52] = ItemCofferIcon_52;
	LOCK_ICON[53] = ItemCofferIcon_53;
	LOCK_ICON[54] = ItemCofferIcon_54;
	LOCK_ICON[55] = ItemCofferIcon_55;
	LOCK_ICON[56] = ItemCofferIcon_56;
	LOCK_ICON[57] = ItemCofferIcon_57;
	LOCK_ICON[58] = ItemCofferIcon_58;
	LOCK_ICON[59] = ItemCofferIcon_59;
	LOCK_ICON[60] = ItemCofferIcon_60;
	LOCK_ICON[61] = ItemCofferIcon_61;
	LOCK_ICON[62] = ItemCofferIcon_62;
	LOCK_ICON[63] = ItemCofferIcon_63;
	LOCK_ICON[64] = ItemCofferIcon_64;
	LOCK_ICON[65] = ItemCofferIcon_65;
	LOCK_ICON[66] = ItemCofferIcon_66;
	LOCK_ICON[67] = ItemCofferIcon_67;
	LOCK_ICON[68] = ItemCofferIcon_68;
	LOCK_ICON[69] = ItemCofferIcon_69;
	LOCK_ICON[70] = ItemCofferIcon_70;
	LOCK_ICON[71] = ItemCofferIcon_71;
	LOCK_ICON[72] = ItemCofferIcon_72;
	LOCK_ICON[73] = ItemCofferIcon_73;
	LOCK_ICON[74] = ItemCofferIcon_74;
	LOCK_ICON[75] = ItemCofferIcon_75;
	LOCK_ICON[76] = ItemCofferIcon_76;
	LOCK_ICON[77] = ItemCofferIcon_77;
	LOCK_ICON[78] = ItemCofferIcon_78;
	LOCK_ICON[79] = ItemCofferIcon_79;
	LOCK_ICON[80] = ItemCofferIcon_80;
	LOCK_ICON[81] = ItemCofferIcon_81;
	LOCK_ICON[82] = ItemCofferIcon_82;
	LOCK_ICON[83] = ItemCofferIcon_83;
	LOCK_ICON[84] = ItemCofferIcon_84;
	LOCK_ICON[85] = ItemCofferIcon_85;
	LOCK_ICON[86] = ItemCofferIcon_86;
	LOCK_ICON[87] = ItemCofferIcon_87;
	LOCK_ICON[88] = ItemCofferIcon_88;
	LOCK_ICON[89] = ItemCofferIcon_89;
	LOCK_ICON[90] = ItemCofferIcon_90;
	LOCK_ICON[91] = ItemCofferIcon_91;
	LOCK_ICON[92] = ItemCofferIcon_92;
	LOCK_ICON[93] = ItemCofferIcon_93;
	LOCK_ICON[94] = ItemCofferIcon_94;
	LOCK_ICON[95] = ItemCofferIcon_95;
	LOCK_ICON[96] = ItemCofferIcon_96;
	LOCK_ICON[97] = ItemCofferIcon_97;
	LOCK_ICON[98] = ItemCofferIcon_98;
	LOCK_ICON[99] = ItemCofferIcon_99;
	LOCK_ICON[100] = ItemCofferIcon_100;

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
	-- 所有隐藏格都要清空，尤其是从100格切换到珍兽页或缩容时。
	for i=1, PACKAGE_BUTTONS_NUM do
		PACKAGE_BUTTONS[i]:SetActionItem(-1);
		PACKAGE_BUTTONS[i]:SetPushed(0);
		PACKAGE_BUTTONS[i]:Disable();
		PACKAGE_BUTTONS[i]:Hide();
		LOCK_ICON[i]:Hide();
	end

	local CurrNum = 20;
	local MaxNum = PACKAGE_BUTTONS_NUM;
	local szPacketName = "";
	ItemCoffer_PetList:Hide();
	ItemCoffer_Set:Hide();
	if nIndex == 0 then
		CurrNum = DataPool:GetBaseBag_Num();
		MaxNum = DataPool:GetBaseBag_MaxNum();
		ItemCoffer_Check_Material:SetCheck(1);
		szPacketName = "base";
	elseif nIndex == 1 then
		CurrNum = DataPool:GetMatBag_Num();
		MaxNum = DataPool:GetMatBag_MaxNum();
		ItemCoffer_Check_Stall:SetCheck(1);
		szPacketName = "material";
	elseif nIndex == 2 then
		g_CurSelect = -1;
		ItemCoffer_Check_Pet:SetCheck(1);
		ItemCoffer_PetList:Show();
		ItemCoffer_UpDatePet();
	else
		return;
	end

	if nIndex ~= 2 then
		CurrNum = math.min(CurrNum, MaxNum, PACKAGE_BUTTONS_NUM);
		if g_CurSelect > CurrNum then
			g_CurSelect = -1;
		end
		for i=1, CurrNum do
			PACKAGE_BUTTONS[i]:Show();
		end
		ItemCoffer_Set:Show();
		ItemCoffer_UpDateItem(szPacketName, CurrNum);
	end
	ItemCoffer_UpdateRect(CurrNum);
end

function ItemCoffer_UpdateRect( currNum )
	local offset = 55;
	local buttonHeight = 45;
	local itemHeight = 38;
	local nLine = math.floor( currNum / PACKAGE_NUM_PER_LINE );
	if( nLine * PACKAGE_NUM_PER_LINE < currNum ) then
		nLine = nLine + 1;
	end
	-- 珍兽列表保留原来的显示高度。
	if g_nTheTabIndex == 2 then nLine = 4; end
	ItemCoffer_Frame:SetProperty( "AbsoluteHeight",nLine * itemHeight + offset + buttonHeight );
		
	
end
--===============================================
-- 更新物品
--===============================================
function ItemCoffer_UpDateItem(szPacketName, CurrNum)

	local i=1;
	while i<=CurrNum do
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
			if g_CurSelect == i then g_CurSelect = -1; end
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
			PlayerPackage:Lock("lock", "item", (g_nTheTabIndex == 1 and DataPool:GetBaseBag_MaxNum() or 0) + g_CurSelect - 1);
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
			PlayerPackage:Lock("unlock", "item", (g_nTheTabIndex == 1 and DataPool:GetBaseBag_MaxNum() or 0) + g_CurSelect - 1);
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

