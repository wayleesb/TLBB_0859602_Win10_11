local Classes ={};
local Types ={};
local Items ={};
local ItemMaxNums = {};
local ItemDis = {};
local ItemtableIdxs ={};
local ClassBtnCount = 10;
local TypeBtnCount = 16;
local ItemBtnCount =12;

local TypeCount = 0;
local ClassCount =0;
local ItemCount =0;

local CurSelClass = -1;
local CurSelType = -1;
local CurSelItem = -1;

local CurItemPage = 0;
local PageSize = 12;

local CurSelItemIdx = 0;
local Type =-1;
function SelRecycleItem_PreLoad()
	this:RegisterEvent("OPEN_SELECTRECYCLEITEM_DLG");	
	this:RegisterEvent( "CLOSE_RECYCLESHOP_MSG" );
end
function cleanUpItemMaxNums()
	for i =1, ItemBtnCount do
		ItemMaxNums[i] = nil;
	end
end
function cleanUpItemDis()
	for i =1, ItemBtnCount do
		ItemDis[i] = nil;
	end
end
function cleanUpItemtableIdxs()
	for i =1, ItemBtnCount do
		ItemtableIdxs[i] = nil;
	end
end
function cleanUpItemArr()
	cleanUpItemtableIdxs();
	cleanUpItemDis();
	cleanUpItemMaxNums();
	CurSelItemIdx = 0;
	Hide_All_Item_Btn();
	SelRecycleItem_CleanUpInput();
	
end
function SelRecycleItem_OnLoad()
	Classes[1]=SelRecycleItem_1;
	Classes[2]=SelRecycleItem_2;
	Classes[3]=SelRecycleItem_3;
	Classes[4]=SelRecycleItem_4;
	Classes[5]=SelRecycleItem_5;
	Classes[6]=SelRecycleItem_6;
	Classes[7]=SelRecycleItem_7;
	Classes[8]=SelRecycleItem_8;
	Classes[9]=SelRecycleItem_9;
	Classes[10]=SelRecycleItem_10;

	Types[1] = SelRecycleItem_12;
	Types[2] = SelRecycleItem_13;
	Types[3] = SelRecycleItem_14;
	Types[4] = SelRecycleItem_15;
	Types[5] = SelRecycleItem_16;
	Types[6] = SelRecycleItem_17;
	Types[7] = SelRecycleItem_18;
	Types[8] = SelRecycleItem_19;
	Types[9] = SelRecycleItem_20;
	Types[10] = SelRecycleItem_21;
	Types[11] = SelRecycleItem_22;
	Types[12] = SelRecycleItem_23;
	Types[13] = SelRecycleItem_24;
	Types[14] = SelRecycleItem_25;
	Types[15] = SelRecycleItem_26;
	Types[16] = SelRecycleItem_27;
	
	Items[1] = SelRecycleItem_28;
	Items[2] = SelRecycleItem_29;
	Items[3] = SelRecycleItem_30;
	Items[4] = SelRecycleItem_31;
	Items[5] = SelRecycleItem_32;
	Items[6] = SelRecycleItem_33;
	Items[7] = SelRecycleItem_34;
	Items[8] = SelRecycleItem_35;
	Items[9] = SelRecycleItem_36;
	Items[10] = SelRecycleItem_37;
	Items[11] = SelRecycleItem_38;
	Items[12] = SelRecycleItem_39;
end

function SelRecycleItem_OnEvent(event)
	if ( event == "OPEN_SELECTRECYCLEITEM_DLG" )   then
		Type =tonumber(arg0);
		SelRecycleItem_InitDlg();
		SelRecycleItem_Type_Clicked(1);
		this:Show();
	end
	if(event == "CLOSE_RECYCLESHOP_MSG" ) then
		if(this:IsVisible()) then
			this:Hide();
			return;
		end	
	end
end

function SelRecycleItem_InitDlg()
	CurSelClass =-1;
	CurSelType  =-1;
	CurSelItem = -1;
	CurItemPage =0;
	SelRecycleItem_PageUp:Hide()
	SelRecycleItem_PageDown:Hide()
	Hide_All_Class_Btn();
	Hide_All_Type_Btn();
	Hide_All_Item_Btn();
	ClassCount = PlayerShop:GetRecycleItemClassCount();
	for i=1,ClassCount do
		local ClassName = PlayerShop:EnumRecycleItemClass(i);
		Classes[i]:SetText(ClassName);
		Classes[i]:Show();
	end
	cleanUpItemArr();
end

function SelRecycleItem_Class_Clicked(index)
	if(index>ClassCount) then
		return;
	end
	if(CurSelClass == index) then
		return;
	end
	CurSelType =  -1;
	CurItemPage = 0;
	SelRecycleItem_PageUp:Hide()
	SelRecycleItem_PageDown:Hide()
	CurSelClass = index;
	Hide_All_Type_Btn();
	TypeCount = PlayerShop:GetRecycleItemTypeCount(CurSelClass);
	for i=1,TypeCount  do
		local TypeName = PlayerShop:EnumRecycleItemType(i-1);
		Types[i]:SetText(TypeName);
		Types[i]:Show();
	end
	cleanUpItemArr();
	
end



function Hide_All_Class_Btn()
	for i = 1,ClassBtnCount do	
	 	Classes[i]:SetProperty("CheckMode", "1");
		Classes[i]:Hide();
	end
end

function Hide_All_Type_Btn()
	for i = 1,TypeBtnCount do	
	 	Types[i]:SetProperty("CheckMode", "1");
		Types[i]:SetCheck(0);
		Types[i]:Hide();
	end
end

function Hide_All_Item_Btn()
	for i = 1,ItemBtnCount do	
	 	Items[i]:SetProperty("CheckMode", "1");
		Items[i]:SetCheck(0);
		Items[i]:Hide();
	end
end

function SelRecycleItem_Type_Clicked(index)
	if(index>TypeCount) then
		return;
	end
	if(CurSelType == index -1) then
		return;
	end
	CurSelType = index -1;
	CurItemPage = 0;
	SelRecycleItem_PageUp:Hide()
	SelRecycleItem_PageDown:Hide()
	ItemCount = PlayerShop:GetRecycleItemCount(CurSelClass,CurSelType);
	SelRecycleItem_ShowItemPage();
end

function SelRecycleItem_ShowItemPage()
	--更新翻页按钮
	SelRecycleItem_UpdatePageBtn()
	cleanUpItemArr();
	--更新ItemBtn
	SelRecycleItem_UpdateItems()
end

function SelRecycleItem_CleanUpInput()
	SelRecycleItem_Name_Text0_Input:SetText("");
	SelRecycleItem_InputMoney_Gold:SetText("");
	SelRecycleItem_InputMoney_Silver:SetText("");	
	SelRecycleItem_InputMoney_CopperCoin:SetText("");
	SelRecycleItem_List3:SetText("");
	SelRecycleItem_Name_Text_TotalMoney:SetProperty("MoneyNumber", tostring(0));
end

function SelRecycleItem_UpdatePageBtn()
	SelRecycleItem_PageUp:Hide()
	SelRecycleItem_PageDown:Hide()
	if(CurItemPage*PageSize+ItemBtnCount<ItemCount) then
		SelRecycleItem_PageDown:Show();
	end
	if(CurItemPage>0)then
		SelRecycleItem_PageUp:Show();
	end
end

function SelRecycleItem_Page(id)
	if(id==-1)then
		CurItemPage=CurItemPage-1;
	else
		CurItemPage=CurItemPage+1;
	end
	SelRecycleItem_ShowItemPage();
end

function SelRecycleItem_UpdateItems()
	Hide_All_Item_Btn();
	local j = 1;
	local endItem = 0
	if(ItemCount - CurItemPage*PageSize >= ItemBtnCount) then
		endItem = CurItemPage*PageSize + ItemBtnCount -1;
	else	
		endItem = ItemCount- 1;
	end
	for i=CurItemPage*PageSize,endItem do
		 if(i < ItemCount) then		 		
			local TypeName,MaxNum,Des,tableIdx = PlayerShop:EnumRecycleItem(i);
			Items[j]:SetText(TypeName);
			ItemMaxNums[j] = MaxNum;
			ItemtableIdxs[j] = tableIdx;
			ItemDis[j] = Des;
			Items[j]:Show();
			j = j+1;
		else
			return;
		end;
	end
end		

function SelRecycleItem_Item_Clicked(index)
	 CurSelItemIdx = index;
	 SelRecycleItem_CleanUpInput();
	if(ItemDis[CurSelItemIdx]~=nil)then
		SelRecycleItem_List3:SetText(ItemDis[CurSelItemIdx]);
	end
end

function SelRecycleItem_CheckIfOK()
	local tmpnum = SelRecycleItem_Name_Text0_Input:GetText();
	if(tmpnum == nil or tmpnum == "") then
		SelRecycleItem_Name_Text_TotalMoney:SetProperty("MoneyNumber", tostring(0));
		return
	end
	local Num = tonumber(tmpnum);
	if tonumber(CurSelItemIdx)<1 then 
		if(Num == 0) then
			SelRecycleItem_Name_Text0_Input:SetText("");
		else
			Num = tostring(Num);
			if(Num~=tmpnum)then
				SelRecycleItem_Name_Text0_Input:SetText(Num);
			end
		end
		SelRecycleItem_Name_Text_TotalMoney:SetProperty("MoneyNumber", tostring(0));
		return;
	end
	if(ItemMaxNums[CurSelItemIdx] == nil or tonumber(ItemMaxNums[CurSelItemIdx])==-1) then
		SelRecycleItem_Name_Text_TotalMoney:SetProperty("MoneyNumber", tostring(0));
		SelRecycleItem_Name_Text0_Input:SetText("");
	else
		local MaxNum = tonumber(ItemMaxNums[CurSelItemIdx]);
		if(Num>MaxNum)then
			SelRecycleItem_Name_Text0_Input:SetText(ItemMaxNums[CurSelItemIdx]);
		elseif(Num == 0) then
			SelRecycleItem_Name_Text0_Input:SetText("");
		else
			Num = tostring(Num);
			if(Num~=tmpnum)then
				SelRecycleItem_Name_Text0_Input:SetText(Num);
			else
				SumTotalPrice();
			end
		end
		
	end	
end

function SelRecycleItem_OK_Clicked()
	if(ItemtableIdxs[CurSelItemIdx]~=nil and tonumber(ItemtableIdxs[CurSelItemIdx])~=-1 )then 
		local szGold = SelRecycleItem_InputMoney_Gold:GetText();
		local szSilver = SelRecycleItem_InputMoney_Silver:GetText();
		local szCopperCoin = SelRecycleItem_InputMoney_CopperCoin:GetText();
		
		local num = SelRecycleItem_Name_Text0_Input:GetText();
		if(tonumber(num)==nil or tonumber(num)<=0) then
			PushDebugMessage("数量输入不能为空");
			return
		end
		if(  tonumber(szGold)==nil or tonumber(szGold)<0 ) then
			szGold = 0;
		end
		if(tonumber(szSilver)==nil or tonumber(szSilver)<0 ) then
			szSilver = 0;
		end
		if (tonumber(szCopperCoin)==nil or tonumber(szCopperCoin)<0) then
			szCopperCoin = 0;
		end
		if(szGold == 0 and szSilver == 0 and szCopperCoin == 0) then
			PushDebugMessage("金钱输入不能为0");
			return
		end
		--在程序里头再检测输入字符的有效性和数值
		local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	
		--???什么情况下失败需要再定
		if(bAvailability == true and tonumber(num)>0) then
			local pmoney = PlayerShop:GetRecycleShopProfitMoney(Type);
			if(pmoney>=math.floor(nMoney * num ))then
				PlayerShop:SendAddRecycleItemMsg(Type,ItemtableIdxs[CurSelItemIdx],tonumber(num),nMoney);
				this:Hide();
			else
				PushDebugMessage("对不起，您商店的盈利资金不够，无法收购！");		
			end
			
		else
			PushDebugMessage("数量或者金钱输入不符合条件！");
		end
	else
		PushDebugMessage("请选择一个材料！");
	end
end

function SelRecycleItem_Close_Clicked()
	this:Hide();
end

function SelRecycleItem_CheckMoneyIfOK(val)
	if tonumber(CurSelItemIdx)>=1 then 
		SumTotalPrice();
	end
	local editctl;
	if(val == 0) then
		editctl = SelRecycleItem_InputMoney_Gold;
	elseif(val == 1) then
		editctl = SelRecycleItem_InputMoney_Silver;
	else
		editctl = SelRecycleItem_InputMoney_CopperCoin;	
	end
	
	local tmpnum = editctl:GetText();
	if(tmpnum == nil or tmpnum == "") then
		return
	end
	local Num = tonumber(tmpnum);
	if(Num==0)then
		editctl:SetText("");
	else
		Num = tostring(Num);
		if(Num~=tmpnum)then
			editctl:SetText(Num);
		end
	end
end

function SumTotalPrice()
	local szGold = SelRecycleItem_InputMoney_Gold:GetText();
	local szSilver = SelRecycleItem_InputMoney_Silver:GetText();
	local szCopperCoin = SelRecycleItem_InputMoney_CopperCoin:GetText();
	if(  tonumber(szGold)==nil or tonumber(szGold)<0 ) then
		szGold = 0;
	end
	if(tonumber(szSilver)==nil or tonumber(szSilver)<0 ) then
		szSilver = 0;
	end
	if (tonumber(szCopperCoin)==nil or tonumber(szCopperCoin)<0) then
		szCopperCoin = 0;
	end
	local tmpnum = SelRecycleItem_Name_Text0_Input:GetText();
	if (tonumber(tmpnum)==nil or tonumber(tmpnum)<0) then
		tmpnum = 0;
	end
	szGold =  math.floor(szGold);
	szSilver =  math.floor(szSilver);
	szCopperCoin =  math.floor(szCopperCoin);
	tmpnum =  math.floor(tmpnum);
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	local all =  math.floor(tmpnum * nMoney);
	SelRecycleItem_Name_Text_TotalMoney:SetProperty("MoneyNumber", tostring(all));
end