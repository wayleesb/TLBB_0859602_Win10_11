local nTheTabIndex = 0;
local PACKAGE_BUTTONS_NUM = 30;
local PACKAGE_BUTTONS = {};
local PACKAGE_BUTTON_BACK={};
local PACKAGE_EXTBAG_NUM = 10;
local PACKAGE_EXTBAG = {};
local PACKAGE_TAB_TEXT = {};
local Lock_Flag = 0;
local g_MaxLine = 0;
local g_PackageWidth = 183;
local g_PackageHeight={};
local PACKAGE_NUM_PER_LINE = 5;

g_PackageHeight["title"] = { 0, 25, };
g_PackageHeight["page"]  = { 25, 20, };
g_PackageHeight["bag"]	 = { 42, 36, };
g_PackageHeight["money"] = { 0, 50,};
function Packet_PreLoad()
	this:RegisterEvent("TOGLE_CONTAINER");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("TOGLE_BANK");
	this:RegisterEvent("OPEN_BOOTH");
	this:RegisterEvent("LOCK_WORK_Item");
	this:RegisterEvent("REPLY_MISSION");
	this:RegisterEvent("CLOSE_MISSION_REPLY");	
	this:RegisterEvent("OPEN_STALL_SALE");	
	this:RegisterEvent("OPEN_ITEM_COFFER");	
	this:RegisterEvent("PS_OPEN_MY_SHOP");
	this:RegisterEvent("RESET_EXT_BAG");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UPDATE_ZENGDIAN");
	this:RegisterEvent("CITY_SHOW_SHOP");
	
	-- 开始整理和结束整理
	this:RegisterEvent("BEGIN_PACKUP_PACKET");
	this:RegisterEvent("END_PACKUP_PACKET");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	this:RegisterEvent("OPEN_RECYCLESHOP_BUYER");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("OPEN_WINDOW")
end

function Packet_OnLoad()
	PACKAGE_BUTTONS =	{	Packet_Space_Line1_Row1_button,
							Packet_Space_Line1_Row2_button,
							Packet_Space_Line1_Row3_button,
							Packet_Space_Line1_Row4_button,
							Packet_Space_Line1_Row5_button,
							Packet_Space_Line2_Row1_button,
							Packet_Space_Line2_Row2_button,
							Packet_Space_Line2_Row3_button,
							Packet_Space_Line2_Row4_button,
							Packet_Space_Line2_Row5_button,
							Packet_Space_Line3_Row1_button,
							Packet_Space_Line3_Row2_button,
							Packet_Space_Line3_Row3_button,
							Packet_Space_Line3_Row4_button,
							Packet_Space_Line3_Row5_button,
							Packet_Space_Line4_Row1_button,
							Packet_Space_Line4_Row2_button,
							Packet_Space_Line4_Row3_button,
							Packet_Space_Line4_Row4_button,
							Packet_Space_Line4_Row5_button,
							Packet_Space_Line5_Row1_button,
							Packet_Space_Line5_Row2_button,
							Packet_Space_Line5_Row3_button,
							Packet_Space_Line5_Row4_button,
							Packet_Space_Line5_Row5_button,
							Packet_Space_Line6_Row1_button,
							Packet_Space_Line6_Row2_button,
							Packet_Space_Line6_Row3_button,
							Packet_Space_Line6_Row4_button,
							Packet_Space_Line6_Row5_button,
							Packet_Space_Line7_Row1_button,
							Packet_Space_Line7_Row2_button,
							Packet_Space_Line7_Row3_button,
							Packet_Space_Line7_Row4_button,
							Packet_Space_Line7_Row5_button,
							Packet_Space_Line8_Row1_button,
							Packet_Space_Line8_Row2_button,
							Packet_Space_Line8_Row3_button,
							Packet_Space_Line8_Row4_button,
							Packet_Space_Line8_Row5_button,
							Packet_Space_Line9_Row1_button,
							Packet_Space_Line9_Row2_button,
							Packet_Space_Line9_Row3_button,
							Packet_Space_Line9_Row4_button,
							Packet_Space_Line9_Row5_button,
							Packet_Space_Line10_Row1_button,
							Packet_Space_Line10_Row2_button,
							Packet_Space_Line10_Row3_button,
							Packet_Space_Line10_Row4_button,
							Packet_Space_Line10_Row5_button,
							};
														
	PACKAGE_EXTBAG  = {
						Packet_Space_Line1;
						Packet_Space_Line2;
						Packet_Space_Line3;
						Packet_Space_Line4;
						Packet_Space_Line5;
						Packet_Space_Line6;
						Packet_Space_Line7;
						Packet_Space_Line8;
						Packet_Space_Line9;
						Packet_Space_Line10;
						}
		
	PACKAGE_TAB_TEXT = {
		[0] = "道具",
		"材料",
		"任务",
	};
	
	Packet_Pet:Enable();
	
	--Packet_Lock:Disable();
	
end
function Packet_Open()
	this:Show();
	Packet_OnUpdateShow();
end
function Packet_Close()
	this:Hide();
	
	--关闭界面时，向Server请求背包同步
	--AskMyBagList函数本身有计时控制
	DataPool:AskMyBagList();
end
function Packet_OnEvent( event )
	if ( event == "TOGLE_CONTAINER" ) then
		if( this:IsVisible() ) then
			Packet_Close();
		else
			Packet_Open();
		end
	elseif ( event == "PS_OPEN_MY_SHOP" )  then
		Packet_Open();
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Packet_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible()) then
		Packet_ChangeTabIndex(nTheTabIndex);
	elseif ( event == "OPEN_EXCHANGE_FRAME" ) then
		Packet_Open();
	elseif ( event == "TOGLE_BANK" ) then
		Packet_Open();
	elseif ( event == "OPEN_BOOTH" ) then
		Packet_Open();
	elseif ( event == "OPEN_WINDOW" ) then
		if( arg0 == "Packet") then
			Packet_Open();
		end
	--锁定正在操作的背包中的物品
	elseif ( event == "LOCK_PACKET_ITEM" ) then 

	elseif ( event == "REPLY_MISSION" ) then 
		Packet_Open();
	elseif ( event == "CLOSE_MISSION_REPLY" ) then
		Packet_Close();
	elseif ( event == "OPEN_ITEM_COFFER" ) then
		
	elseif ( event == "OPEN_STALL_SALE" )  then
		Packet_Open(); 
	elseif ( event == "CITY_SHOW_SHOP" and arg0 == "open") then
		Packet_Open();		
	elseif ( event == "RESET_EXT_BAG" ) then
		ResetExtBag();
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		Packet_YuanBao2:SetText("元宝:"..tostring(Player:GetData("YUANBAO")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Packet_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	elseif (event == "UPDATE_ZENGDIAN" and this:IsVisible()) then
		Packet_YuanBao:SetText("赠点:"..tostring(Player:GetData("ZENGDIAN")));
		
	elseif ( event == "BEGIN_PACKUP_PACKET" )   then
		--锁定“整理按钮”
		Packet_Classify:Disable()
	
	elseif ( event == "END_PACKUP_PACKET" )	    then
		--打开“整理按钮”
		Packet_Classify:Enable()
	elseif(event == "PLAYER_LEAVE_WORLD" and this:IsVisible()) then
		Packet_Close();
	elseif(event == "OPEN_RECYCLESHOP_BUYER") then
		Packet_Open();		
	end
end

function ResetExtBag()
	Packet_OnUpdateShow();
	Packet_UpdateDragAcceptName();
end

function Packet_OnShow()
	Packet_ChangeTabIndex(nTheTabIndex);
end

function Packet_ChangeTabIndex(nTabIndex)
	if( nTabIndex < 0 or nTabIndex >=3) then
		return;
	end
	nTheTabIndex = nTabIndex;
	Packet_OnUpdateShow();
	Packet_UpdateDragAcceptName();
end
function Package_UpdateBagLine( nMaxLine )
	
	g_MaxLine = nMaxLine;
	local i
	for i = 1, 10 do
		if( i <= g_MaxLine ) then
			PACKAGE_EXTBAG[ i ]:Show();
		else
			PACKAGE_EXTBAG[ i ]:Hide();
		end
	end
	local nWindowHeight;
	nWindowHeight = g_MaxLine * 35 + 200;
	Packet_Frame:SetProperty( "AbsoluteHeight",nWindowHeight );
	
	--设置每一个控件的位置
end
function Packet_OnUpdateShow()	
	local i=1;
	local szPacketName = "";
	local CurrNum = 20;
	local BaseNum = 20;
	local MaxNum = 30;
	Lock_Flag = 0;

	if(nTheTabIndex == 0) then
		szPacketName = "base";
		CurrNum = DataPool:GetBaseBag_Num();
		BaseNum = DataPool:GetBaseBag_BaseNum();
		MaxNum = DataPool:GetBaseBag_MaxNum();
	elseif(nTheTabIndex == 1) then
		szPacketName = "material";
		CurrNum = DataPool:GetMatBag_Num();
		BaseNum = DataPool:GetMatBag_BaseNum();
		MaxNum = DataPool:GetMatBag_MaxNum();
	elseif(nTheTabIndex == 2) then
		szPacketName = "quest";
		CurrNum = DataPool:GetTaskBag_Num();
		BaseNum = DataPool:GetTaskBag_BaseNum();
		MaxNum = DataPool:GetTaskBag_MaxNum();
	else 
		return;
	end
	
	local nMaxLine = math.floor( CurrNum / PACKAGE_NUM_PER_LINE );
	--如果是整除了
	if( nMaxLine * PACKAGE_NUM_PER_LINE == CurrNum ) then
	else
		nMaxLine = nMaxLine + 1;
	end
	AxTrace( 8,0,"已经有的包格数"..tostring( CurrNum ).."  需要显示的行数"..tostring( nMaxLine ) );
	--如果超过当前显示的最大范围了，就更新包的行数
	Package_UpdateBagLine( nMaxLine );
	local nMaxDisplayNumber = nMaxLine * PACKAGE_NUM_PER_LINE;
	for i=1, nMaxDisplayNumber do
		--如果是需要显示的
		if( i <= CurrNum ) then
			local theAction,bLocked = PlayerPackage:EnumItem(szPacketName, i-1);
			PACKAGE_BUTTONS[ i ]:Show();
			if theAction:GetID() ~= 0 then
				PACKAGE_BUTTONS[i]:SetActionItem(theAction:GetID());
			else
				PACKAGE_BUTTONS[i]:SetActionItem(-1);
			end
			if bLocked == 1 then
				PACKAGE_BUTTONS[i]:Disable();
				Lock_Flag = 1
			else
				PACKAGE_BUTTONS[i]:Enable();
			end

		else  --这些是需要隐藏的
			PACKAGE_BUTTONS[ i ]:SetActionItem( -1 );
			PACKAGE_BUTTONS[ i ]:Hide();
		end
	end

	
	
	if Lock_Flag == 0 then
		Packet_Classify : Enable();
	else
		Packet_Classify : Disable();
	end
	--Money
	Packet_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	--YuanBao
	Packet_YuanBao2:SetText("元宝:"..tostring(Player:GetData("YUANBAO")));
	--ZengDian
	Packet_YuanBao:SetText("赠点:"..tostring(Player:GetData("ZENGDIAN")));
	--Money_JZ
	Packet_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
end

function Packet_UpdateDragAcceptName()
	local nStartAcceptIndex = 0;
	
	if(nTheTabIndex == 0) then
		nStartAcceptIndex = 1;
	elseif(nTheTabIndex == 1) then
		nStartAcceptIndex = DataPool:GetBaseBag_MaxNum()+1;
	elseif(nTheTabIndex == 2) then
		nStartAcceptIndex = DataPool:GetBaseBag_MaxNum()+DataPool:GetMatBag_MaxNum()+1;
	else 
		return;
	end

	local i=1;
	while i<=PACKAGE_BUTTONS_NUM do
		PACKAGE_BUTTONS[i]:SetProperty("DragAcceptName", "P"..tostring(nStartAcceptIndex));
		
		nStartAcceptIndex = nStartAcceptIndex+1;
		i = i+1;
	end
end


function Packet_ItemBtnClicked( nLine, nRow )

	local nIndex = ( nLine - 1 ) * PACKAGE_NUM_PER_LINE + nRow;
	if(nIndex < 1 or nIndex > PACKAGE_BUTTONS_NUM) then 
		return;
	end

	PACKAGE_BUTTONS[nIndex]:DoAction();

end

function Packet_ItemBtnSubClicked( nLine,nRow )
	local nIndex = ( nLine - 1 ) * PACKAGE_NUM_PER_LINE + nRow;
	if(nIndex < 1 or nIndex > PACKAGE_BUTTONS_NUM) then 
		return;
	end

	PACKAGE_BUTTONS[nIndex]:DoSubAction();
end



--===============================================
-- 启动摆摊界面(在摆摊前会先确认摊位费)
--===============================================
function Packet_Sale_Clicked()
	PlayerPackage:OpenStallSaleFrame();
end

function Packet_PackUp_Clicked()
	PlayerPackage:PackUpPacket(nTheTabIndex);
end


--===============================================
-- 点击锁定
--===============================================
function Packet_Lock_Open()
	PlayerPackage:OpenLockFrame(nTheTabIndex);
end
function OpenDlgForSetProtectTime()
	OpenFangdao();
end