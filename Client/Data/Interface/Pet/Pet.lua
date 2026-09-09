local WuXingTbl = {
			{level =1,	per = "1.0%" ,	maxlevel=1,	color = "#c00D000"},
			{level =2,	per = "1.5%" ,	maxlevel=1,	color = "#c00D000"},
			{level =3,	per = "2.1%" ,	maxlevel=2,	color = "#c00D000"},
			{level =4,	per = "3.0%" ,	maxlevel=2,	color = "#c00D000"},
			{level =5,	per = "8.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =6,	per = "11.0%" ,	maxlevel=3,	color = "#c43DBFF"},
			{level =7,	per = "14.5%" ,	maxlevel=4,	color = "#c43DBFF"},
			{level =8,	per = "23.5%" ,	maxlevel=4,	color = "#cFF8001"},
			{level =9,	per = "30.0%" ,	maxlevel=5,	color = "#cFF8001"},
			{level =10,	per = "39.3%" ,	maxlevel=5,	color = "#cFF8001"},
}
local ShowColor = "#H";
local PETSKILL_BUTTONS_NUM = 12;
local PETSKILL_BUTTONS = {};
local PETATTR = {};
local PET_POTREMAIN = 0;
local PET_ATTR_COUNT = 5;
local PET_MAX_NUMBER = 6+4;
local PETNUM = 0;
local PET_REST = 1;
local PET_FIGHT= 0;
local PET_CURRENT_SELECT = 0;
local PET_AITYPE = {};
local Changed_Name_Flag = 0;
--			// 创建珍兽(即放出) 0
--			// 收回珍兽					1
--			// 销毁珍兽(即放生)	2
--			// 捕捉珍兽					3
--			可以在被放出后，通过消息，改变该珍兽在listbox中的名字的颜色。
local PET_TAB_TEXT = {};
local PET_ORIGINAL_NAME = "";

function Pet_PreLoad()
	this:RegisterEvent("TOGLE_PET_PAGE");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("RESET_ALLUI");
	this:RegisterEvent("UPDATE_PET_EXTRANUM");
	this:RegisterEvent("UNIT_LEVEL");
end

function Pet_OnLoad()

	PETSKILL_BUTTONS[1] = Pet_Skill1;
	PETSKILL_BUTTONS[2] = Pet_Skill2;
	PETSKILL_BUTTONS[3] = Pet_Skill3;
	PETSKILL_BUTTONS[4] = Pet_Skill4;
	PETSKILL_BUTTONS[5] = Pet_Skill5;
	PETSKILL_BUTTONS[6] = Pet_Skill6;
	PETSKILL_BUTTONS[7] = Pet_Skill7;
	PETSKILL_BUTTONS[8] = Pet_Skill8;
	PETSKILL_BUTTONS[9] = Pet_Skill9;
	PETSKILL_BUTTONS[10] = Pet_Skill10;
	PETSKILL_BUTTONS[11] = Pet_Skill11;
	PETSKILL_BUTTONS[12] = Pet_Skill12
;
	PET_AITYPE[0] = "胆小";
	PET_AITYPE[1] = "谨慎";
	PET_AITYPE[2] = "忠诚";
	PET_AITYPE[3] = "精明";
	PET_AITYPE[4] = "勇猛";
	
	PET_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		"骑乘",
		"其他",
	};

	Pet_chenghao:SetText("称号");
end

function Pet_OnEvent(event)
	if ( event == "TOGLE_PET_PAGE" ) then
		if( this:IsVisible() ) then
			Pet_Close();
			return
		else
			for i=1,PET_ATTR_COUNT do
				PETATTR[i] = 0;
			end
	
			if arg0 ~= nil and tonumber(arg0)~=nil and tonumber(arg0) < PET_MAX_NUMBER and tonumber(arg0) >= 0 then
				PET_CURRENT_SELECT = tonumber(arg0)
			end
		
			Pet_Open();
		end
		
		Pet_OnShown();
		
		return;
	elseif ( event == "UPDATE_PET_PAGE") then
		if(this:IsVisible())then
			Pet_Update();
			--Pet_FakeObject:Hide();
			--Pet_FakeObject:Show();
		else
			Pet_Update_NotVisible();
		end
		return;
	elseif( event == "ACCELERATE_KEYSEND" ) then
		Pet_HandleAccKey(arg0);
	elseif ( event == "DELETE_PET" ) then
		if(this:IsVisible())then
			for i=1,PET_ATTR_COUNT do
				PETATTR[i] = 0;
			end
			Pet_Update();
		else
			Pet_Update_NotVisible();
		end
	elseif(event == "RESET_ALLUI")then
		PET_CURRENT_SELECT = 0;
		Pet:SetSelectPetIdx(0);
	elseif(event == "UPDATE_PET_EXTRANUM" or event == "UNIT_LEVEL")then
		local nPetCount = Pet:GetPet_Count()
		local nMaxPetCount = GetMyCurMaxPetCount()
		Pet_List_Text:SetText("珍兽列表 "..nPetCount.."/"..nMaxPetCount)
	end
	
end

function Pet_HandleAccKey(op)
	if(op == "acc_pet") then
		if(this:IsVisible()) then
			Pet_Close();
			return;
		end
		
		--模拟收到了一个打开珍兽界面的事件。
		arg0 = "-1";
		Pet_OnEvent("TOGLE_PET_PAGE");
	end
end

function Pet_OnShown()
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		Pet_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end


	Pet_SelfEquip : SetCheck(0);
	Pet_SelfData : SetCheck(0);
	Pet_Pet : SetCheck(1);
	Pet_Ride : SetCheck(0);
	Pet_OtherInfo : SetCheck(0);
	
	Pet_Accept:Disable();
	Pet_Cancel:Disable();
	Pet_Amend:Disable();
	Pet_Free:Disable();
	Pet_LockPet:Disable();
	Pet_Domesticate:Disable();
	Pet_Feed:Disable();
	Pet_Rest:Disable();
	Pet_Campaign:Disable();
	Pet_Str_Addition:Disable();
	Pet_Int_Addition:Disable();
	Pet_Dex_Addition:Disable();
	Pet_PF_Addition:Disable();
	Pet_Sta_Addition:Disable();
	Pet_Str_Subtraction:Disable();
	Pet_Int_Subtraction:Disable();
	Pet_Dex_Subtraction:Disable();
	Pet_PF_Subtraction:Disable();
	Pet_Sta_Subtraction:Disable();
	Pet_Page_Clear();


	Pet_Update();


end

function Pet_Page_Clear()
	Pet_FakeObject:RotateEnd();
	Pet_FakeObject:RotateEnd();
	Pet_Accept:Disable();
	Pet_Cancel:Disable();
	Pet_Amend:Disable();
	Pet_Rest:Disable();
	Pet_Free:Disable();
	Pet_LockPet:Disable();
	Pet_Domesticate:Disable();
	Pet_Feed:Disable();
	Pet_Campaign:Disable();
	Pet_Str_Addition:Disable();
	Pet_Int_Addition:Disable();
	Pet_Dex_Addition:Disable();
	Pet_PF_Addition:Disable();
	Pet_Sta_Addition:Disable();
	Pet_Str_Subtraction:Disable();
	Pet_Int_Subtraction:Disable();
	Pet_Dex_Subtraction:Disable();
	Pet_PF_Subtraction:Disable();
	Pet_Sta_Subtraction:Disable();
	
	Pet_PetName : SetText( "" );
	Pet_PetName : Disable();
	Pet_Type : SetText("");
	
	Pet_PageHeader : SetText( "#gFF0FA0珍兽" );
	Pet_ConsortID : SetText( "" );
	Pet_PetID : SetText( "" );
	Pet_Sex : SetText("");
	Pet_Life : SetText( "" );
	Pet_Happy : SetText("");
--	Pet_LoyalgGade : SetText( "" );
	Pet_Level : SetText( "" );
--	Pet_Type : SetText( "" );
	Pet_StrAptitude : SetText( "" );
	Pet_PhysicalStrengthAptitude : SetText( "" );
	Pet_DexterityAptitude : SetText( "" );
	Pet_NimbusAptitude : SetText( "" );
	Pet_StabilityAptitude : SetText( "" );
	Pet_Exp : SetText( "" );
	Pet_Blood : SetText( "" );
--	Pet_MP : SetText( "" .. " / " .. "" );
	Pet_Str : SetText( "" );
--	Pet_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_Nimbus : SetText( "" );
--	Pet_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_Dexterity : SetText( "" );
--	Pet_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_PhysicalStrength : SetText( "" );
--	Pet_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_Stability : SetText( "" );
--	Pet_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_GenGu : SetText( "" );
	Pet_Potential : SetText( "" );
--	Pet_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_PhysicsAttack : SetText( "" );
	Pet_MagicAttack : SetText( "" );
	Pet_PhysicsRecovery : SetText( "" );
	Pet_MagicRecovery : SetText( "" );
	Pet_Miss : SetText( "" );
	Pet_WuXing : SetText( "" );
	Pet_ShootProbability : SetText( "" );
	Pet_CriticalAttack:SetText("");
	Pet_CriticalDefence:SetText("")
	Pet_Growth : SetText("")
	-------------------------------
	--zchw 44493
	Pet_Growth1 : SetText("") 
	Pet_GenGu	: SetToolTip("")
	Pet_WuXing : SetToolTip("")
	Pet_Growth : SetToolTip("")
	Pet_Type : SetToolTip("")
	-------------------------------
	Pet_FakeObject : SetFakeObject( "" );
	PetAttack_Type : Hide();
	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end
	PetFood_Type : Hide();
	Pet_lock : Hide();
	PET_POTREMAIN = 0
	Pet_Refresh_ADDSUB_Button();
	Pet_NeedLevel:SetText( "" );
	Pet_Jian : Hide();
	
	--设置珍兽数量信息--add by xindefeng
	local nPetCount = Pet:GetPet_Count()
	local nMaxPetCount = GetMyCurMaxPetCount()
	Pet_List_Text:SetText("珍兽列表 "..nPetCount.."/"..nMaxPetCount)	
end

function Pet_ListBox_Selected()
	PETNUM = Pet_List : GetFirstSelectItem();
	local nPetCount = Pet : GetPet_Count();
	
	if(PETNUM == PET_CURRENT_SELECT) then
		return;
	end
	
	if(PETNUM < 0 and nPetCount > 0) then
		PETNUM = PET_CURRENT_SELECT;
		return;
	end

	for i=1,PET_ATTR_COUNT do
		PETATTR[i] = 0;
	end
	
	Pet_Page_Clear();
	Changed_Name_Flag = 0;
	PET_CURRENT_SELECT = PETNUM;
	AxTrace(0,1,"here="..PET_CURRENT_SELECT)
	Pet_FakeObject : SetFakeObject( "" );
	Pet : SetModel(PETNUM);
	Pet_FakeObject : SetFakeObject( "My_Pet" );
	
	
	Pet_Show_Appoint(PETNUM);

	Pet:NotifySelChange(PETNUM);

	local	tcount = Pet:GetTitleNum(PET_CURRENT_SELECT);
	if(tcount>0)then
		Pet_chenghao:Enable()
	else
		Pet_chenghao:Disable()
	end

end

function Pet_ListBox_RClicked()
	local clkNum = Pet_List : GetClickItem();
	--AxTrace(0,0,"Pet_ListBox_RClicked "..tostring(clkNum));
	if(clkNum >= 0) then
		Pet:CheckRClick(clkNum);
	end
end

function Pet_Update_NotVisible()
	local nPetCount = Pet : GetPet_Count();
	if nPetCount < 1 then
		PET_CURRENT_SELECT = -1;
		Pet:SetSelectPetIdx(-1);
		return;
	end
	local bSelect = 0;
	local firSel = -1;
	for	i=1, PET_MAX_NUMBER do
		if Pet:IsPresent(i-1) then
			if(firSel == -1)then
				firSel = i-1;
			end
			if( i-1 == PET_CURRENT_SELECT) then
				bSelect = 1;
			end
		end
	end
	--有选中对象的，才进行选中操作。
	if bSelect == 1 then
		--do nothing
	else
		PET_CURRENT_SELECT = firSel;
		Pet:SetSelectPetIdx(firSel);
	end
end

function Pet_Update()
	Pet_chenghao:Disable()
	Pet_SelfEquip : SetCheck(0);
	Pet_SelfData : SetCheck(0);
	Pet_Pet : SetCheck(1);
	Pet_Ride : SetCheck(0);
	Pet_OtherInfo : SetCheck(0);
	local nPetCount = Pet : GetPet_Count();
	AxTrace(3,3,"nPetCount = "..nPetCount);
	local szPetName;

	Pet_Page_Clear();
	Pet_List : ClearListBox();
	
	if nPetCount < 1 then
		PET_CURRENT_SELECT = -1;
		Pet:SetSelectPetIdx(-1);
		return;
	end
	
	local bSelect = 0;
	local firSel = -1;
	for	i=1, PET_MAX_NUMBER do
		if Pet:IsPresent(i-1) then
			if(firSel == -1)then
				firSel = i-1;
			end
			szPetName = Pet : GetPetList_Appoint(i-1);
			AxTrace(0,1,"第"..i.."只叫"..szPetName);
			
			if(Pet : GetIsFighting(i-1)) then
				Pet_List : AddItem(szPetName, i-1,"FF0A9605");
			else
				Pet_List : AddItem(szPetName, i-1);
			end
			if( i-1 == PET_CURRENT_SELECT) then
				bSelect = 1;
			end
			--这里必须有这么2句，要不会出错。
			Pet_DisableAddButton();
			Pet_DisableSubButton();
		end
	end
	local tcount = 0;
	--有选中对象的，才进行选中操作。
	if bSelect == 1 then
		Pet_List : SetItemSelectByItemID(PET_CURRENT_SELECT);
		Pet_FakeObject : SetFakeObject( "" );
		Pet : SetModel(PET_CURRENT_SELECT);
		Pet_FakeObject : SetFakeObject( "My_Pet" );	
		Pet_Show_Appoint(PET_CURRENT_SELECT);
		tcount = Pet:GetTitleNum(PET_CURRENT_SELECT);
		if(tcount>0)then
			Pet_chenghao:Enable()
		end
	else
		PET_CURRENT_SELECT = firSel;
		if(firSel == -1)then
			Pet:SetSelectPetIdx(-1);
			
			return;
		end
		Pet_List : SetItemSelectByItemID(PET_CURRENT_SELECT);
		Pet_FakeObject : SetFakeObject( "" );
		Pet : SetModel(PET_CURRENT_SELECT);
		Pet_FakeObject : SetFakeObject( "My_Pet" );	
		Pet_Show_Appoint(PET_CURRENT_SELECT);
		tcount = Pet:GetTitleNum(PET_CURRENT_SELECT);
		if(tcount>0)then
			Pet_chenghao:Enable()
		end
	end
	
	if PET_CURRENT_SELECT > PET_MAX_NUMBER then
		PET_CURRENT_SELECT = PET_MAX_NUMBER;
	end
	
	Pet_PetName:SetProperty("DefaultEditBox", "False");
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = Pet:GetTakeLevel(PET_CURRENT_SELECT );
	
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";
	Pet_NeedLevel:SetText( strNeedLevel );
	
end

function Pet_Show_Appoint(nIndex)

	local i;

	if(not (Pet:IsPresent(nIndex)) ) then
		return;
	end
	Pet:SetSelectPetIdx(nIndex);
	Pet_Accept:Disable();
	Pet_Cancel:Disable();
	Pet_Amend:Enable();
	Pet_Rest:Enable();
	Pet_Free:Enable();
	Pet_LockPet:Enable();
	Pet_Domesticate:Enable();
	Pet_Feed:Enable();
	Pet_Campaign:Enable();
	
	Pet_Str_Addition:Disable();
	Pet_Int_Addition:Disable();
	Pet_Dex_Addition:Disable();
	Pet_PF_Addition:Disable();
	Pet_Sta_Addition:Disable();
	Pet_Str_Subtraction:Disable();
	Pet_Int_Subtraction:Disable();
	Pet_Dex_Subtraction:Disable();
	Pet_PF_Subtraction:Disable();
	Pet_Sta_Subtraction:Disable();
	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end
 	
 	strName = Pet:GetAIType(nIndex);
 	
	local strAI;
	if(strName>4 or strName <0) then
		strAI = "错误";
	else
		strAI =	PET_AITYPE[strName];
	end

	
 	strName,strName2 = Pet:GetName(nIndex);
	local nEra, strTypeName = Pet:GetPetTypeName(nIndex);
 	if( 1 == nEra ) then
 	    strName2 = "二代"..strTypeName
 	end
 	
 
 	Pet_PageHeader : SetText("#gFF0FA0"..strName2);
 	Pet_Type :SetText("#gFF8E92"..strAI);
 	Changed_Name = Pet_PetName : GetText();

 	if(PlayerPackage:IsPetLock(nIndex) == 1) then
	 	Pet_lock : Show();
	 	
	 	local nUnlockElapsedTime = PlayerPackage:GetPUnlockElapsedTime_Pet(nIndex);
	 	if( nUnlockElapsedTime ==0) then
	 		Pet_lock : SetProperty("Image","set:UIIcons image:Icon_Lock");
	 		Pet_lock : SetToolTip ("已加锁");
	 	else
	 		local strLeftTime = g_GetUnlockingStr(nUnlockElapsedTime);		
	 		Pet_lock : SetProperty("Image","set:CommonFrame6 image:NewLock");
	 		Pet_lock : SetToolTip (strLeftTime);
	 	end
	 	
	else
	 	Pet_lock : Hide();
 end
	AxTrace(0,1,"Changed_Name="..Changed_Name)
--	if Changed_Name_Flag == 1 then
--		Pet_PetName : SetText( strName );
	if Changed_Name ~= strName and Changed_Name ~= "" then
		Pet_PetName : Enable();
--		PET_ORIGINAL_NAME = strName;
	else
		Pet_PetName : Enable();
		Pet_PetName : SetText( strName );
	end
	
--	Pet_PageHeader : SetText( strAI .. strName2 );

	strName,strName2,sex = Pet : GetID(nIndex);
	Pet_PetID : SetText( "珍兽ID:"..strName2 );
	AxTrace(0,0,"GetID="..strName .. strName2);
	
	strName = Pet : GetConsort(nIndex);
	if(strName == "00000000") then
		strName = "";
	end;
	Pet_ConsortID : SetText( "配偶ID:"..strName );
		
	if(sex == 1) then 
		strName = "雄性";
	else
		strName = "雌性";
	end

	Pet_Sex : SetText( strName );
	local strNeedLevel;
	local strNeedLevelColor;
	local nTakeLevel = Pet:GetTakeLevel(nIndex);
	
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor="#cFF0000";
	else
		strNeedLevelColor="#c00FF00";
	end
	strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";
	Pet_NeedLevel:SetText( strNeedLevel );
	strName = Pet : GetNaturalLife(nIndex);
--	strName2 = Pet:	GetMaxLife(nIndex);
	Pet_Life : SetText( "寿命:"..strName );
	
--	strName = Pet : GetLoyalgGade(nIndex);
--	Pet_LoyalgGade : SetText( strName );
	
--	strName = Pet : GetBasic(nIndex);
--	Pet_GenGu : SetText( "根骨:"..strName );

	strName = Pet : GetLevel(nIndex);
	Pet_Level : SetText( "等级:"..strName );
	
--	strName = Pet : GetType(nIndex);
--	Pet_Type : SetText( "第".. tostring(strName).."代" );

	strName = Pet : GetHappy(nIndex);
	Pet_Happy : SetText( "快乐:"..strName );

	strName = Pet : GetSavvy(nIndex);
	Pet_WuXing : SetText( "悟性:"..strName );
	
	local WuXingVal = tonumber(strName);
	strName = Pet : GetStrAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	Pet_StrAptitude : SetText( strName );

	strName = Pet : GetPFAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	Pet_PhysicalStrengthAptitude : SetText( strName );
	
	strName = Pet : GetDexAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	Pet_DexterityAptitude : SetText( strName );
	
	strName = Pet : GetIntAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	Pet_NimbusAptitude : SetText( strName );
	
	strName = Pet : GetStaAptitude(nIndex);
	if(WuXingTbl[WuXingVal])then
		strName = (WuXingTbl[WuXingVal].color)..strName..ShowColor.."(+"..(WuXingTbl[WuXingVal].per)..")";
	end
	Pet_StabilityAptitude : SetText( strName );
	
	strName,strName2 = Pet : GetExp(nIndex);
	Pet_Exp : SetText( "经验:"..strName .."/"..strName2);
--yy说，不空格	
	strName = Pet : GetHP(nIndex);
	strName2 = Pet:	GetMaxHP(nIndex);
	Pet_Blood : SetText( "血:"..strName .."/".. strName2);
--	strName = Pet : GetMP(nIndex);
--	strName2 = Pet:	GetMaxMP(nIndex);
--	Pet_MP : SetText( strName .." / ".. strName2);
	
	strName = Pet : GetStr(nIndex);
	Pet_Str : SetText( tonumber(strName) + PETATTR[1] );
--	Pet_Str : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = Pet : GetInt(nIndex);
	Pet_Nimbus : SetText( tonumber(strName) + PETATTR[2] );
--	Pet_Nimbus : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = Pet : GetDex(nIndex);
	Pet_Dexterity : SetText( tonumber(strName) + PETATTR[3] );
--	Pet_Dexterity : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = Pet : GetPF(nIndex);
	Pet_PhysicalStrength : SetText( tonumber(strName) + PETATTR[4] );
--	Pet_PhysicalStrength : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = Pet : GetSta(nIndex);
	Pet_Stability : SetText( tonumber(strName) + PETATTR[5] );
--	Pet_Stability : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	
	strName = Pet : GetBasic(nIndex);
	Pet_GenGu : SetText( "根骨:"..tonumber(strName) );

	Pet_CriticalAttack : SetText( Pet:GetCriticalAttack(nIndex)  );
	Pet_CriticalDefence : SetText(Pet:GetCriticalDefence(nIndex) )

	strName = Pet : GetPotential(nIndex);
	strName2 = tonumber(strName);
	local Sum_Attr = 0;
	for i=1,PET_ATTR_COUNT do
		Sum_Attr = Sum_Attr + PETATTR[i];
	end
	strName2 = strName2 - Sum_Attr;
	--出现这种情况是
	if(strName2 < 0) then
	 strName2 = 0 
	 for i=1,PET_ATTR_COUNT do
			PETATTR[i] = 0;
	 end
	end
	PET_POTREMAIN = strName2
	AxTrace(2,1,"Sum_Attr="..Sum_Attr)
	AxTrace(2,1,"strName2="..strName2)
	AxTrace(2,1,"PET_POTREMAIN="..PET_POTREMAIN)
	Pet_Potential : SetText( strName2 ); 
--	Pet_Potential : SetProperty("TextColours","tl:FFEFEFEF tr:FFEFEFEF bl:FFEFEFEF br:FFEFEFEF");
	Pet_Refresh_ADDSUB_Button();
	
	strName = Pet : GetPhysicsAttack(nIndex);
	Pet_PhysicsAttack : SetText( strName );
	
	strName = Pet : GetMagicAttack(nIndex);
	Pet_MagicAttack : SetText( strName );
	
	strName = Pet : GetPhysicsRecovery(nIndex);
	Pet_PhysicsRecovery : SetText( strName );
	
	strName = Pet : GetMagicRecovery (nIndex);
	Pet_MagicRecovery : SetText( strName );

	strName = Pet : GetGrowRate(nIndex);
	-----------------------------------------
	-- zchw 44493
	Pet_Growth1 : SetText("#{ZS_CZL}");
	Pet_GenGu : SetToolTip("#{INTERFACE_XML_287}");
	Pet_WuXing : SetToolTip("#{INTERFACE_XML_733}");
	Pet_Growth : SetToolTip("#{INTERFACE_XML_986}")
	Pet_Type : SetToolTip("#{INTERFACE_XML_857}")
	-----------------------------------------
	Pet_Growth : SetText("#G未知")
	local nGrowLevel = Pet : GetPetGrowLevel(nIndex,tonumber(strName));
	local strTbl = {"普通","优秀","杰出","卓越","完美"};
	
	if(nGrowLevel >= 0) then
		nGrowLevel = nGrowLevel + 1;	--c里是从0开始的枚举
		local nGrowRate = Pet : GetGrowRate(nIndex);
		if(strTbl[nGrowLevel]) then
			Pet_Growth : SetText("#G"..strTbl[nGrowLevel]..nGrowRate)
		end
	end

	--闪避率
	strName = Pet : GetMiss(nIndex);
	Pet_Miss : SetText( strName );

	--命中率
	strName = Pet : GetShootProbability(nIndex);
	Pet_ShootProbability : SetText( strName );
	
	strName,strIcon = Pet : GetAttackTrait(nIndex);
	AxTrace(0,0,"strIcon="..strIcon)
	if strIcon ~= "" then
		PetAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		PetAttack_Type : SetToolTip(strName)
		PetAttack_Type : Show();
	end
	
	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	local i=1;
	AxTrace(0,1,"SumPetSkill="..SumPetSkill);

	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill( nIndex, i-1, "petskill");
		i = i + 1;
		if theSkillAction:GetID() ~= 0 then
			AxTrace(0,1,"pet="..nIndex.." skill position="..i.." id="..theSkillAction:GetID());
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k+1;
			
--		if( (theSkillAction : GetPetSkillOwner() == nIndex) and (k <= PETSKILL_BUTTONS_NUM ) ) then
--			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
--			AxTrace(0,1,"pet="..nIndex.." skill position="..k.." id="..theSkillAction:GetID())
--			k = k + 1;
--		else
--			PETSKILL_BUTTONS[i]:SetActionItem(-1);
		end
		
--	PETSKILL_DESC[i]:SetText(theSkillAction:GetName());
	end
	
	if(Pet : GetIsFighting(nIndex)) then
		Pet_Campaign : Hide();
		Pet_Rest : Show();
		AxTrace(0,0,"鸭子可休息");
	else
		Pet_Rest : Hide();
		Pet_Campaign : Show();
		AxTrace(0,0,"鸭子可战斗");
	end
	
	local food = Pet : GetFoodType(nIndex);
	strName = "";
	AxTrace(0,1,"food="..food);
	if(food >= 1000) then
		strName = strName .. "肉";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "草";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "虫";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "谷";
	end
	PetFood_Type : Show();
	PetFood_Type : SetToolTip( strName );
	
	Pet_Jian : Show();	
end

function Pet_Str_Add_Clicked()
	if( PET_POTREMAIN >0 ) then
		PETATTR[1] = PETATTR[1] +1;
		PET_POTREMAIN = PET_POTREMAIN - 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Str : SetText( Pet_Str : GetText() + 1 );
--		Pet_Str : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
	Pet_Str_Subtraction:Enable()
	end
	if( PET_POTREMAIN <=0 ) then
--		Pet_Str_Addition:Disable();
		Pet_DisableAddButton();
	end
end

function Pet_Int_Add_Clicked()
	if( PET_POTREMAIN >0 ) then
		PETATTR[2] = PETATTR[2] +1;
		PET_POTREMAIN = PET_POTREMAIN - 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Nimbus : SetText( Pet_Nimbus : GetText() + 1 );
--		Pet_Nimbus : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Int_Subtraction:Enable();
	end
	if( PET_POTREMAIN <=0 ) then
--		Pet_Int_Addition:Disable();
		Pet_DisableAddButton();
	end
end

function Pet_Dex_Add_Clicked()
	if( PET_POTREMAIN >0 ) then
		PETATTR[3] = PETATTR[3] +1;
		PET_POTREMAIN = PET_POTREMAIN - 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Dexterity : SetText( Pet_Dexterity : GetText() + 1 );
--		Pet_Dexterity : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Dex_Subtraction:Enable();
	end
	if( PET_POTREMAIN <=0 ) then
--		Pet_Dex_Addition:Disable();
		Pet_DisableAddButton();
	end
end

function Pet_PF_Add_Clicked()
	if( PET_POTREMAIN >0 ) then
		PETATTR[4] = PETATTR[4] +1;
		PET_POTREMAIN = PET_POTREMAIN - 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_PhysicalStrength : SetText( Pet_PhysicalStrength : GetText() + 1 );
--		Pet_PhysicalStrength : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_PF_Subtraction:Enable();
	end
	if( PET_POTREMAIN <=0 ) then
--		Pet_PF_Addition:Disable();
		Pet_DisableAddButton();
	end
end

function Pet_Sta_Add_Clicked()
	if( PET_POTREMAIN >0 ) then
		PETATTR[5] = PETATTR[5] +1;
		PET_POTREMAIN = PET_POTREMAIN - 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Stability : SetText( Pet_Stability : GetText() + 1 );
--		Pet_Stability : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Sta_Subtraction:Enable();
	end
	if( PET_POTREMAIN <=0 ) then
--		Pet_Sta_Addition:Disable();
		Pet_DisableAddButton();
	end
end

function Pet_Str_Sub_Clicked()
	if( PETATTR[1] >0 ) then
		PETATTR[1] = PETATTR[1] -1;
		PET_POTREMAIN = PET_POTREMAIN + 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Str : SetText( Pet_Str : GetText() - 1 );
--		Pet_Str : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
--		Pet_Str_Addition:Enable();
		Pet_EnableAddButton();
	end
	if( PETATTR[1] <= 0 ) then
		Pet_Str_Subtraction:Disable();
	end
end

function Pet_Int_Sub_Clicked()
	if( PETATTR[2] >0 ) then
		PETATTR[2] = PETATTR[2] -1;
		PET_POTREMAIN = PET_POTREMAIN + 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Nimbus : SetText( Pet_Nimbus : GetText() - 1 );
--		Pet_Nimbus : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
--		Pet_Int_Addition:Enable();
		Pet_EnableAddButton();
	end
	if( PETATTR[2] <= 0 ) then
		Pet_Int_Subtraction:Disable();
	end
end

function Pet_Dex_Sub_Clicked()
	if( PETATTR[3] >0 ) then
		PETATTR[3] = PETATTR[3] -1;
		PET_POTREMAIN = PET_POTREMAIN + 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Dexterity : SetText( Pet_Dexterity : GetText() - 1 );
--		Pet_Dexterity : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
--		Pet_Dex_Addition:Enable();
		Pet_EnableAddButton();
	end
	if( PETATTR[3] <= 0 ) then
		Pet_Dex_Subtraction:Disable();
	end
end

function Pet_PF_Sub_Clicked()
	if( PETATTR[4] >0 ) then
		PETATTR[4] = PETATTR[4] -1;
		PET_POTREMAIN = PET_POTREMAIN + 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_PhysicalStrength : SetText( Pet_PhysicalStrength : GetText() - 1 );
--		Pet_PhysicalStrength : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
--		Pet_PF_Addition:Enable();
		Pet_EnableAddButton();
	end
	if( PETATTR[4] <= 0 ) then
		Pet_PF_Subtraction:Disable();
	end
end

function Pet_Sta_Sub_Clicked()
	if( PETATTR[5] >0 ) then
		PETATTR[5] = PETATTR[5] -1;
		PET_POTREMAIN = PET_POTREMAIN + 1;
		Pet_Potential : SetText( PET_POTREMAIN );
--		Pet_Potential : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
		Pet_Stability : SetText( Pet_Stability : GetText() - 1 );
--		Pet_Stability : SetProperty("TextColours","tl:FFFEE601 tr:FFFEE601 bl:FFFEE601 br:FFFEE601");
--		Pet_Sta_Addition:Enable();
		Pet_EnableAddButton();
	end
	if( PETATTR[5] <= 0 ) then
		Pet_Sta_Subtraction:Disable();
	end
end

function Pet_Accept_Clicked()
	if(not (Pet:IsPresent(PETNUM)) ) then
		return;
	end
	--if(PlayerPackage:IsPetLock(PETNUM) == 1)    then
	--	PushDebugMessage("珍兽已加锁")
	--	for i=1,PET_ATTR_COUNT do
	--		PETATTR[i] = 0;
	--	end
	--	Pet_Show_Appoint(PETNUM);
	--	return;
	--end
	if(tonumber(DataPool:GetLeftProtectTime()) >0)    then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		for i=1,PET_ATTR_COUNT do
			PETATTR[i] = 0;
		end
		Pet_Show_Appoint(PETNUM);
		return;
	end
 	Pet : Add_Attribute(PETNUM ,PETATTR[1] ,PETATTR[2], PETATTR[3], PETATTR[4], PETATTR[5]);
	for i=1,PET_ATTR_COUNT do
		PETATTR[i] = 0;
	end
end

function Pet_Cancel_Clicked()
	if(not (Pet:IsPresent(PETNUM)) ) then
		return;
	end
	
	for i=1,PET_ATTR_COUNT do
		PETATTR[i] = 0;
	end

	Pet_Show_Appoint(PETNUM);
end

function Pet_Relax_Clicked()
	Pet : Go_Relax(PETNUM);
end

function Pet_Fight_Clicked()
	Pet	:	Go_Fight(PETNUM);
end

function Pet_Free_Clicked()
	if(Pet : GetIsFighting(PETNUM)) then
		--此为BUG 3921中杨婷的原话，在策划案中并没有该需求。
		--但项目紧急，没时间确认，所以就以BUG系统为准。
		PushDebugMessage("珍兽正在出战，不能被放生")
		return;
	end
	if(PlayerPackage:IsPetLock(PETNUM) == 1)    then
		PushDebugMessage("珍兽已加锁")
		return;
	end
	if Pet:GetPetLocation(PETNUM) ~= -1 then
		PushDebugMessage("珍兽正在进行其他操作，不能放生。")
		return;
	end
	Pet	:	Free_Confirm(PETNUM);
end

function Pet_LockPet_Clicked()
	PlayerPackage:OpenLockFrame(2);
end

function Pet_Feed_Clicked()
	Pet:Feed(PETNUM);
end

function Pet_Dome_Clicked()
	Pet:Dome(PETNUM);
end

function Pet_AmendName_Clicked()
	if(not (Pet:IsPresent(PETNUM)) ) then
		return;
	end
	strName = Pet_PetName : GetText()
	Changed_Name_Flag = 0;
	AxTrace(0,1,"string.len(strName)="..string.len(strName));
	if(string.len(strName) < 2  or string.len(strName) > 12 ) then
		Pet_Update();
		return;
	end
	Pet : Change_Name(PETNUM,Pet_PetName : GetText());
end

function Pet_Skill_Button_Clicked(nIndex)
--将来主动技能和被动技能，可以在表里查到。
	if(nIndex < 3) then
		
	end

	PETSKILL_BUTTONS[nIndex] : DoAction();

	local SumPetSkill = GetActionNum("petskill");
	local k=1;
	for i=1, SumPetSkill do
		local theSkillAction = EnumAction( i-1, "petskill");
		if( (theSkillAction : GetPetSkillOwner() == nIndex) and (k <= PETSKILL_BUTTONS_NUM ) ) then
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k + 1;
		end
	end
end

----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function Pet_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Pet_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		Pet_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function Pet_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Pet_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		Pet_FakeObject:RotateEnd();
	end
end

function SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	Pet_Close();
	Pet_SelfEquip : SetCheck(0);
	Pet_SelfData : SetCheck(0);
	Pet_Pet : SetCheck(1);
	
end

function Pet_Skill_Clicked(nSkillIndex)

	AxTrace(0,1,"234PETNUM="..PETNUM);

	if(PETNUM < 0 or PETNUM > PET_MAX_NUMBER) then
		return;
	end
	
	if(not (Pet:IsPresent(PETNUM)) ) then
		return;
	end
	
	if Pet : GetSkillPassive(PETNUM,nSkillIndex-1) == 0 then

		PushDebugMessage("请将该技能拖拽到技能快捷栏使用 。");
	
	end

end

function Pet_OnHiden()
	Pet:NotifyPetDlgClosed()
	Pet_PetName:SetProperty("DefaultEditBox", "False");
end

function Pet_EnableAddButton()
		Pet_Str_Addition:Enable();
		Pet_Int_Addition:Enable();
		Pet_Dex_Addition:Enable();
		Pet_PF_Addition:Enable();
		Pet_Sta_Addition:Enable();
end

function Pet_EnableSubButton()
		Pet_Str_Subtraction:Enable();
		Pet_Int_Subtraction:Enable();
		Pet_Dex_Subtraction:Enable();
		Pet_PF_Subtraction:Enable();
		Pet_Sta_Subtraction:Enable();
end

function Pet_DisableAddButton()
		Pet_Str_Addition:Disable();
		Pet_Int_Addition:Disable();
		Pet_Dex_Addition:Disable();
		Pet_PF_Addition:Disable();
		Pet_Sta_Addition:Disable();
end

function Pet_DisableSubButton()
		Pet_Str_Subtraction:Disable();
		Pet_Int_Subtraction:Disable();
		Pet_Dex_Subtraction:Disable();
		Pet_PF_Subtraction:Disable();
		Pet_Sta_Subtraction:Disable();
end

function Pet_Refresh_ADDSUB_Button()

	AxTrace(0,1,"PETATTR1="..PETATTR[1])
	AxTrace(0,1,"PETATTR2="..PETATTR[2])
	AxTrace(0,1,"PETATTR3="..PETATTR[3])
	AxTrace(0,1,"PETATTR4="..PETATTR[4])
	AxTrace(0,1,"PETATTR5="..PETATTR[5])
	AxTrace(0,1,"PET_POTREMAIN="..PET_POTREMAIN)

	if PETATTR[1] > 0 then
		Pet_Str_Subtraction:Enable();
		Pet_Accept:Enable();
		Pet_Cancel:Enable();
	end
	if PETATTR[2] > 0 then
		Pet_Int_Subtraction:Enable();
		Pet_Accept:Enable();
		Pet_Cancel:Enable();
	end
	if PETATTR[3] > 0 then
		Pet_Dex_Subtraction:Enable();
		Pet_Accept:Enable();
		Pet_Cancel:Enable();
	end
	if PETATTR[4] > 0 then
		Pet_PF_Subtraction:Enable();
		Pet_Accept:Enable();
		Pet_Cancel:Enable();
	end
	if PETATTR[5] > 0 then
		Pet_Sta_Subtraction:Enable();
		Pet_Accept:Enable();
		Pet_Cancel:Enable();
	end
	
	if PET_POTREMAIN > 0 then
		AxTrace(0,1,"yes here")
		Pet_EnableAddButton();
		Pet_Accept:Enable();
		Pet_Cancel:Enable();
	else
		Pet_DisableAddButton();
	end
	
	local Sum_Attr = 0;
	for i=1,PET_ATTR_COUNT do
		Sum_Attr = Sum_Attr + PETATTR[i];
	end
	
	if PET_POTREMAIN <=0 and Sum_Attr <= 0 then
		Pet_Accept:Disable();
		Pet_Cancel:Disable();
	end
	
end

function PetName_Change()
	if Pet_PetName:GetText() ~= "" then
		Changed_Name_Flag = 0;
		AxTrace(0,1,"here");
	end
end

function Pet_Ride_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1);

	OpenRidePage();
	Pet_Close();
	Pet_SelfEquip : SetCheck(0);
	Pet_SelfData : SetCheck(0);
	Pet_Pet : SetCheck(1);
	Pet_Ride : SetCheck(0);
	Pet_OtherInfo : SetCheck(0);
end

function Pet_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1);

	OtherInfoPage();
	Pet_Close();
	Pet_SelfEquip : SetCheck(0);
	Pet_SelfData : SetCheck(0);
	Pet_Pet : SetCheck(1);
	Pet_Ride : SetCheck(0);
	Pet_OtherInfo : SetCheck(0);
end

--打开自己的资料页面
function Pet_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", Pet_Frame:GetProperty("UnifiedPosition"), 1);

	SystemSetup:OpenPrivatePage("self");
	Pet_Close();
end


function Pet_Open()
	this:Show();
end
function Pet_Close()
	this:Hide();
end

function Pet_chenghao_Clicked()
	if(not (Pet:IsPresent(PETNUM)) ) then
		return;
	end
	Pet:PetOpenTitleList(PETNUM);
end

function Pet_Jian_Clicked()
	if(not (Pet:IsPresent(PETNUM)) ) then
		return;
	end
	Pet:PetOpenPetJian(PETNUM,"self");
end


--获取玩家当前等级最大携带数量(以后增加兽栏后要废除,而采用新的方法)-add by xindefeng
function GetMyCurMaxPetCount()
	local mylevel = Player:GetData("LEVEL") --获取玩家等级
	if mylevel == nil or type(mylevel) ~= "number" then
		return 2;
	end 
	local MaxCount = 0	--携带上限
	
	if mylevel < 21 then
		MaxCount = 2	--一开始就携带上限就是2
	elseif mylevel < 41 then
		MaxCount = 3
	elseif mylevel < 61 then
		MaxCount = 4
	elseif mylevel < 81 then
		MaxCount = 5
	else
		MaxCount = 6
	end
	MaxCount = MaxCount + Player:GetData("PET_EXTRANUM")
	
	if MaxCount > PET_MAX_NUMBER then
		MaxCount = PET_MAX_NUMBER
	end
	
	return MaxCount
end
