--相关的C＋＋代码在“GMGameInterface_Script_Package”中

local g_nItemSum = 0;

--===============================================
-- PreLoad()
--===============================================
function SplitItem_PreLoad()

	this:RegisterEvent("SHOW_SPLIT_ITEM");
	this:RegisterEvent("HIDE_SPLIT_ITEM");
	
end

--===============================================
-- OnLoad()
--===============================================
function SplitItem_OnLoad()
	
end

--===============================================
-- OnEvent()
--===============================================
function SplitItem_OnEvent(event)

	if(event == "SHOW_SPLIT_ITEM") then

		g_nItemSum = PlayerPackage:GetSplitSum();
		SplitItem_Num:SetText("1");
		SplitItem_Num:SetSelected( 0, -1 );
		
		this:Show();
		
		--设置缺省的光标
		SplitItem_Num:SetProperty("DefaultEditBox", "True");
		
		SplitItem_Update();

	elseif( event == "HIDE_SPLIT_ITEM")	 then
		this:Hide();		
	end

end

--===============================================
-- Update()
--===============================================
function SplitItem_Update()

	SplitItem_ItemName:SetText(PlayerPackage:GetSplitName());
	
end

--===============================================
-- 点击确定
--===============================================
function SplitItemAccept_Clicked()

	local szTemp = SplitItem_Num:GetText();
	if( szTemp == "" )then 
		this:Hide();
		return ;
	end
	
	local nNum = szTemp + 0;
	PlayerPackage:SplitItem(nNum);
	this:Hide();

end


--===============================================
-- 取消
--===============================================
function SplitItemRefuse_Clicked()

	PlayerPackage:CancelSplitItem();
	this:Hide();
	SplitItem_Num:SetProperty("DefaultEditBox", "False");
end


--===============================================
-- 输入改变
--===============================================
function SplitItem_ChangeNum()

end

--===============================================
-- 个数加1
--===============================================
function SplitItemAdd_Clicked()
	
	local szNum = SplitItem_Num:GetText();
	local nNum = szNum + 0;
	
	if( nNum+1 >= g_nItemSum )then
		nNum = g_nItemSum-2
	end
	
	SplitItem_Num:SetText(tostring(nNum+1));
	
end

--===============================================
-- 个数减1
--===============================================
function SplitItemDecrease_Clicked()
	
	local szNum = SplitItem_Num:GetText();
	local nNum = szNum + 0;

	if( nNum-1 < 1 )then
		nNum = 2
	end
	
	SplitItem_Num:SetText(tostring(nNum-1));

end
