local GOODS_BUTTONS_NUM = 18;
local GOODS_BUTTONS = {};
local GOODS_DESCS = {};
local GOOD_BAD    = {};
local SHOP_LIST_A = {};
local SHOP_LIST_B = {};
local SHOP_SEARCH_LIST ={};

local nPageNum = 1;
local maxPage = 1;
local objCared = -1;
local lastA = 0
local lastB = 0
local lastSelect = 0
local maxChildShop = 8
local isCareObj = 0

--存储随机排序的索引值
local	g_tOrderPool	= {};
--当前商店的商品数量
local	g_nTotalNum		= 0;

function YuanbaoShop_PreLoad()

	this:RegisterEvent("OPEN_YUANBAOSHOP");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UPDATE_BOOTH");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("CLOSE_BOOTH");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("TOGGLE_YUANBAOSHOP");
	this:RegisterEvent("UPDATE_YUANBAO");
	this:RegisterEvent("UI_COMMAND");
end

function YuanbaoShop_OnLoad()
	GOODS_BUTTONS[1] = YuanbaoShop_Item1;
	GOODS_BUTTONS[2] = YuanbaoShop_Item2;
	GOODS_BUTTONS[3] = YuanbaoShop_Item3;
	GOODS_BUTTONS[4] = YuanbaoShop_Item4;
	GOODS_BUTTONS[5] = YuanbaoShop_Item5;
	GOODS_BUTTONS[6] = YuanbaoShop_Item6;
	GOODS_BUTTONS[7] = YuanbaoShop_Item7;
	GOODS_BUTTONS[8] = YuanbaoShop_Item8;
	GOODS_BUTTONS[9] = YuanbaoShop_Item9;
	GOODS_BUTTONS[10]= YuanbaoShop_Item10;
	GOODS_BUTTONS[11]= YuanbaoShop_Item11;
	GOODS_BUTTONS[12]= YuanbaoShop_Item12;
	GOODS_BUTTONS[13]= YuanbaoShop_Item13;
	GOODS_BUTTONS[14]= YuanbaoShop_Item14;
	GOODS_BUTTONS[15]= YuanbaoShop_Item15;
	GOODS_BUTTONS[16]= YuanbaoShop_Item16;
	GOODS_BUTTONS[17]= YuanbaoShop_Item17;
	GOODS_BUTTONS[18]= YuanbaoShop_Item18;
	
	GOODS_DESCS[1] = YuanbaoShop_ItemInfo1_Text;
	GOODS_DESCS[2] = YuanbaoShop_ItemInfo2_Text;
	GOODS_DESCS[3] = YuanbaoShop_ItemInfo3_Text;
	GOODS_DESCS[4] = YuanbaoShop_ItemInfo4_Text;
	GOODS_DESCS[5] = YuanbaoShop_ItemInfo5_Text;
	GOODS_DESCS[6] = YuanbaoShop_ItemInfo6_Text;
	GOODS_DESCS[7] = YuanbaoShop_ItemInfo7_Text;
	GOODS_DESCS[8] = YuanbaoShop_ItemInfo8_Text;
	GOODS_DESCS[9] = YuanbaoShop_ItemInfo9_Text;
	GOODS_DESCS[10]= YuanbaoShop_ItemInfo10_Text;
	GOODS_DESCS[11]= YuanbaoShop_ItemInfo11_Text;
	GOODS_DESCS[12]= YuanbaoShop_ItemInfo12_Text;
	GOODS_DESCS[13]= YuanbaoShop_ItemInfo13_Text;
	GOODS_DESCS[14]= YuanbaoShop_ItemInfo14_Text;
	GOODS_DESCS[15]= YuanbaoShop_ItemInfo15_Text;
	GOODS_DESCS[16]= YuanbaoShop_ItemInfo16_Text;
	GOODS_DESCS[17]= YuanbaoShop_ItemInfo17_Text;
	GOODS_DESCS[18]= YuanbaoShop_ItemInfo18_Text;

	GOOD_BAD[1]  =     YuanbaoShop_ItemInfo1_GB;
	GOOD_BAD[2]  =     YuanbaoShop_ItemInfo2_GB;
	GOOD_BAD[3]  =     YuanbaoShop_ItemInfo3_GB;
	GOOD_BAD[4]  =     YuanbaoShop_ItemInfo4_GB;
	GOOD_BAD[5]  =     YuanbaoShop_ItemInfo5_GB;
	GOOD_BAD[6]  =     YuanbaoShop_ItemInfo6_GB;
	GOOD_BAD[7]  =     YuanbaoShop_ItemInfo7_GB;
	GOOD_BAD[8]  =     YuanbaoShop_ItemInfo8_GB;
	GOOD_BAD[9]  =     YuanbaoShop_ItemInfo9_GB;
	GOOD_BAD[10] =     YuanbaoShop_ItemInfo10_GB;
	GOOD_BAD[11] =     YuanbaoShop_ItemInfo11_GB;
	GOOD_BAD[12] =     YuanbaoShop_ItemInfo12_GB;
	GOOD_BAD[13] =     YuanbaoShop_ItemInfo13_GB;
	GOOD_BAD[14] =     YuanbaoShop_ItemInfo14_GB;
	GOOD_BAD[15] =     YuanbaoShop_ItemInfo15_GB;
	GOOD_BAD[16] =     YuanbaoShop_ItemInfo16_GB;
	GOOD_BAD[17] =     YuanbaoShop_ItemInfo17_GB;
	GOOD_BAD[18] =     YuanbaoShop_ItemInfo18_GB;
	--大卖场
	SHOP_LIST_A[1] = {btn = YuanbaoShop_Button1 , shoplist = {}}
	SHOP_LIST_A[1].shoplist[1] = "#{YBSD_081225_019}"   --"新品上架";
	SHOP_LIST_A[1].shoplist[2] = "#{YBSD_081225_020}"   --"热卖商店";
	SHOP_LIST_A[1].shoplist[3] = "#{YBSD_081225_021}"   --"特价商品";

	--宝石商城
	SHOP_LIST_A[2] = {btn = YuanbaoShop_Button2 , shoplist = {}}
	--SHOP_LIST_A[2].shoplist[1] = "#{YBSD_081225_022}"	--"大理宝石斋";
	SHOP_LIST_A[2].shoplist[1] = "#{YBSD_081225_023}"	--"苏州宝石斋";
	SHOP_LIST_A[2].shoplist[2] = "#{YBSD_081225_024}"	--"洛阳宝石斋";
	SHOP_LIST_A[2].shoplist[3] = "#{YBSD_081225_025}"	--"宝石精华店";
	SHOP_LIST_A[2].shoplist[4] = "#{YBSD_081225_026}"	--"宝石加工坊";

	--珍兽商城
	SHOP_LIST_A[3] = {btn = YuanbaoShop_Button3 , shoplist = {}}
	SHOP_LIST_A[3].shoplist[1] = "#{YBSD_081225_027}"	--"稀有珍兽馆";
	SHOP_LIST_A[3].shoplist[2] = "#{YBSD_081225_028}"	--"普通技能馆";
	SHOP_LIST_A[3].shoplist[3] = "#{YBSD_081225_029}"	--"高级技能馆";
	SHOP_LIST_A[3].shoplist[4] = "#{YBSD_081225_030}"	--"珍兽灵药坊";
	--南北杂货
	SHOP_LIST_A[4] = {btn = YuanbaoShop_Button4 , shoplist = {}}
	SHOP_LIST_A[4].shoplist[1] = "#{YBSD_081225_091}"	--"仙丹灵药";
	SHOP_LIST_A[4].shoplist[2] = "#{YBSD_081225_031}"	--"奇珍异宝";
	SHOP_LIST_A[4].shoplist[3] = "#{YBSD_081225_032}"	--"三清神符";

	--形象广场
	SHOP_LIST_A[5] = {btn = YuanbaoShop_Button5 , shoplist = {}}
	SHOP_LIST_A[5].shoplist[1] = "#{YBSD_081225_033}"	--"米兰时装店";
	SHOP_LIST_A[5].shoplist[2] = "#{YBSD_081225_034}"	--"如意变身斋";
	SHOP_LIST_A[5].shoplist[3] = "#{YBSD_081225_035}"	--"天扬发艺馆";
	SHOP_LIST_A[5].shoplist[4] = "#{YBSD_081225_036}"	--"兰雨美容坊";
	SHOP_LIST_A[5].shoplist[5] = "#{YBSD_081225_037}"	--"坐骑商城";

	--花舞人间
	SHOP_LIST_A[6] = {btn = YuanbaoShop_Button6 , shoplist = {}}
	SHOP_LIST_A[6].shoplist[1] = "#{YBSD_081225_038}"	--"传统烟花";
	SHOP_LIST_A[6].shoplist[2] = "#{YBSD_081225_039}"	--"个性烟花";
	SHOP_LIST_A[6].shoplist[3] = "#{YBSD_081225_040}"	--"全场景烟花";
	SHOP_LIST_A[6].shoplist[4] = "#{YBSD_081225_041}"	--"鲜花";

	--武功秘籍
	SHOP_LIST_A[7] = {btn = YuanbaoShop_Button7 , shoplist = {}}
	SHOP_LIST_A[7].shoplist[1] = "#{YBSD_081225_042}"	--"还施水阁";
	--打造图
	SHOP_LIST_A[8] = {btn = YuanbaoShop_Button8 , shoplist = {}}
	SHOP_LIST_A[8].shoplist[1] = "#{YBSD_081225_043}"	--"刀斧和枪棒";
	SHOP_LIST_A[8].shoplist[2] = "#{YBSD_081225_044}"	--"单短和双短";
	SHOP_LIST_A[8].shoplist[3] = "#{YBSD_081225_045}"	--"扇和环";
	SHOP_LIST_A[8].shoplist[4] = "#{YBSD_081225_096}"	--"衣服和帽子";
	SHOP_LIST_A[8].shoplist[5] = "#{YBSD_081225_046}"	--"手套和鞋子";
	SHOP_LIST_A[8].shoplist[6] = "#{YBSD_081225_047}"	--"护腕和护肩";
	SHOP_LIST_A[8].shoplist[7] = "#{YBSD_081225_048}"	--"腰带和项链";
	SHOP_LIST_A[8].shoplist[8] = "#{YBSD_081225_049}"	--"戒指和护符";
	--二级商店
	SHOP_LIST_B[1] = YuanbaoShop_Button01
	SHOP_LIST_B[2] = YuanbaoShop_Button02
	SHOP_LIST_B[3] = YuanbaoShop_Button03
	SHOP_LIST_B[4] = YuanbaoShop_Button04
	SHOP_LIST_B[5] = YuanbaoShop_Button05
	SHOP_LIST_B[6] = YuanbaoShop_Button06
	SHOP_LIST_B[7] = YuanbaoShop_Button07
	SHOP_LIST_B[8] = YuanbaoShop_Button08
	
	if lastA ~= nil and lastA > 0 and lastA < 9 then
		SHOP_LIST_A[lastA].btn:SetCheck(1)
	end

	if lastB ~= nil and lastB > 0 and lastB < 9 then 
		SHOP_LIST_B[lastB]:SetCheck(1)
	end
	
	for i =1 ,8 do
		SHOP_LIST_B[i]:Hide()
	end

	--我要更强大
	SHOP_SEARCH_LIST[1] = {}
	SHOP_SEARCH_LIST[1][1] = "#{YBSD_081225_023}"	--"苏州宝石斋";
	SHOP_SEARCH_LIST[1][2] = "#{YBSD_081225_024}"	--"洛阳宝石斋";
	SHOP_SEARCH_LIST[1][3] = "#{YBSD_081225_025}"	--"宝石精华店";
	SHOP_SEARCH_LIST[1][4] = "#{YBSD_081225_027}"	--"稀有珍兽馆";
	SHOP_SEARCH_LIST[1][5] = "#{YBSD_081225_091}"	--"仙丹灵药";
	--我要更有魅力
	SHOP_SEARCH_LIST[2] = {}
	SHOP_SEARCH_LIST[2][1] = "#{YBSD_081225_037}"	--"坐骑商城";
	SHOP_SEARCH_LIST[2][2] = "#{YBSD_081225_033}"	--"米兰时装店";
	SHOP_SEARCH_LIST[2][3] = "#{YBSD_081225_034}"	--"如意变身斋";
	SHOP_SEARCH_LIST[2][4] = "#{YBSD_081225_035}"	--"天扬发艺馆";
	SHOP_SEARCH_LIST[2][5] = "#{YBSD_081225_036}"	--"兰雨美容坊";
	--我要打造极品装备
	SHOP_SEARCH_LIST[3] = {}
--	SHOP_SEARCH_LIST[3][1] = "#{YBSD_081225_022}"	--"大理宝石斋";
	SHOP_SEARCH_LIST[3][1] = "#{YBSD_081225_023}"	--"苏州宝石斋";
	SHOP_SEARCH_LIST[3][2] = "#{YBSD_081225_024}"	--"洛阳宝石斋";
	SHOP_SEARCH_LIST[3][3] = "#{YBSD_081225_026}"	--"宝石加工坊";
	SHOP_SEARCH_LIST[3][4] = "#{YBSD_081225_031}"	--"奇珍异宝";
	--我要打造极品珍兽
	SHOP_SEARCH_LIST[4] = {}
	SHOP_SEARCH_LIST[4][1] = "#{YBSD_081225_027}"	--"稀有珍兽馆";
	SHOP_SEARCH_LIST[4][2] = "#{YBSD_081225_028}"	--"普通技能馆";
	SHOP_SEARCH_LIST[4][3] = "#{YBSD_081225_029}"	--"高级技能馆";
	SHOP_SEARCH_LIST[4][4] = "#{YBSD_081225_030}"	--"珍兽灵药坊";
	
	--我要移动的更快
	SHOP_SEARCH_LIST[5] = {}
	SHOP_SEARCH_LIST[5][1] = "#{YBSD_081225_037}"	--"坐骑商城";
	SHOP_SEARCH_LIST[5][2] = "#{YBSD_081225_032}"	--"三清神符";
	--我要向别人表白
	SHOP_SEARCH_LIST[6] = {}
	SHOP_SEARCH_LIST[6][1] = "#{YBSD_081225_039}"	--"个性烟花";
	SHOP_SEARCH_LIST[6][2] = "#{YBSD_081225_040}"	--"全场景烟花";
	SHOP_SEARCH_LIST[6][3] = "#{YBSD_081225_041}"	--"鲜花";
	SHOP_SEARCH_LIST[6][4] = "#{YBSD_081225_033}"	--"米兰时装店";
	SHOP_SEARCH_LIST[6][5] = "#{YBSD_081225_037}"	--"坐骑商城";
	--我要学习新技能
	SHOP_SEARCH_LIST[7] = {}
	SHOP_SEARCH_LIST[7][1] = "#{YBSD_081225_042}"	--"还施水阁";
	SHOP_SEARCH_LIST[7][2] = "#{YBSD_081225_028}"	--"普通技能馆";
	SHOP_SEARCH_LIST[7][3] = "#{YBSD_081225_029}"	--"高级技能馆";
	

	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_055}" ,1)	--我要更强大
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_056}" ,2)	--"我要更有魅力"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_057}" ,3)	--"我要打造极品装备"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_058}",4)	--"我要打造极品珍兽"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_059}",5)	--"我要移动的更快"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_060}",6)	--"我要向别人表白"
	YuanbaoShop_SearchMode:AddTextItem("#{YBSD_081225_061}",7)	--"我要学习新技能"

end


function YuanbaoShop_OnEvent(event)

	if ( event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_LEAVE_WORLD") then
		YuanbaoShop_Close()
	end

	if event == "OPEN_YUANBAOSHOP" then
		g_nTotalNum	= 0;
		local check  = tonumber(NpcShop:GetBuyDirectly());
		if(check>=1)then
			YuanbaoShop_querengoumai:SetCheck(0);
		else
			YuanbaoShop_querengoumai:SetCheck(1);
		end
		if( this:IsVisible() == false ) then
			YubanbaoShop_ADRandom()
			this:Show();
			OpenWindow("Packet")
		end
		
		--关心商人Obj
		objCared = NpcShop:GetNpcId();
		this:CareObject(objCared, 1, "YuanbaoShop");
		
		NpcShop:CloseConfirm();
		YuanbaoShop_UpdatePage(1);
		
		if(IsWindowShow("Shop_Fitting")) then
			RestoreShopFitting();
			CloseWindow("Shop_Fitting", true);
		end
		SetDefaultMouse();
	elseif ( event == "TOGGLE_YUANBAOSHOP") then
		if( this:IsVisible() ) then
			YuanbaoShop_Close();
		else
			lastA = 1;
			lastB = 1;
			YuanbaoShop_Show()
		end
	elseif ( event == "UPDATE_BOOTH" ) then

		YuanbaoShop_UpdatePage(nPageNum);

	elseif (event == "CLOSE_BOOTH") then
		YuanbaoShop_Close()
	elseif (event == "UPDATE_YUANBAO" and this:IsVisible()) then
		YuanbaoShop_Text2:SetText("#{YBSD_081225_068}"..tostring(Player:GetData("YUANBAO")))
	elseif (event == "UI_COMMAND" and tonumber( arg0 ) == 888902) then
		ObjCared = Get_XParam_INT( 0 )
		if Get_XParam_INT( 1 ) ~= 0 and Get_XParam_INT( 2 ) ~= 0 then
			lastA = Get_XParam_INT( 1 ) 
			lastB = Get_XParam_INT( 2 )
		end
		YuanbaoShop_Show()
	end
end
--==================
--打开商店
function YuanbaoShop_Show()
	if lastA < 1 or lastA > maxChildShop then
		lastA = 1;
		lastB = 1;
	end
	if lastB < 1 or lastB > maxChildShop then
		lastB = 1;
	end
	lastSelect = 0;
	for i = 1 ,maxChildShop do
		SHOP_LIST_B[i]:Hide()
		if SHOP_LIST_A[lastA].shoplist[i] ~= nil then
			SHOP_LIST_B[i]:SetText(SHOP_LIST_A[lastA].shoplist[i])
			SHOP_LIST_B[i]:Show()
		end
	end
	SHOP_LIST_A[lastA].btn:SetCheck(1)
	SHOP_LIST_B[lastB]:SetCheck(1)
	UpdateShopItem( lastA , lastB )
end
--===============================
--刷新一页
function YuanbaoShop_UpdatePage(thePage)
	
	YuanbaoShop_Text2:SetText ("#{YBSD_081225_068}"..tostring(Player:GetData("YUANBAO")))
	for i=1, GOODS_BUTTONS_NUM  do
		GOOD_BAD[i]:Show()
	end

	local	i = 1;
	
	if g_nTotalNum == 0 or g_nTotalNum ~= GetActionNum("boothitem") then
		g_nTotalNum	= GetActionNum("boothitem");
		YuanbaoShop_Order();
	end
		
	-- 计算总页数
	local	nTotalPage;
	if( g_nTotalNum < 1 ) then
		nTotalPage	= 1;
	else
		nTotalPage	= math.floor((g_nTotalNum-1)/GOODS_BUTTONS_NUM)+1;
	end

	maxPage = nTotalPage;
	
	if(thePage < 1 or thePage > nTotalPage) then 
		return;	
	end
	--HEQUIP_DRESS		=16,	//时装                   
	--HEQUIP_RIDER		=8,	//骑乘	
	local bHaveRide=0;
	
	nPageNum = thePage;

	local nStartIndex = (thePage-1)*GOODS_BUTTONS_NUM;

	local nActIndex = nStartIndex;
	i = 1;
	while i <= GOODS_BUTTONS_NUM do
		local	idx	= g_tOrderPool[nActIndex+1];
		if idx == nil then
			idx	= -1;
		end

		local theAction = EnumAction(idx, "boothitem");
		if theAction:GetID() ~= 0 then
			local nEquipPoint = theAction:GetEquipPoint();
			
			if nEquipPoint == 16 or nEquipPoint == 8 then
				bHaveRide = 1;
			end
			
		
			GOODS_BUTTONS[i]:SetActionItem(theAction:GetID());
			if(theAction:GetItemColorInShop()~="") then
				GOODS_DESCS[i]:SetText( theAction:GetItemColorInShop()..theAction:GetName() );
			else
				GOODS_DESCS[i]:SetText( theAction:GetName() );
			end
			
			local	nPrice	= NpcShop:EnumItemPrice( idx )
			GOOD_BAD[i]:SetText("#{YBSD_081225_101}" .. tostring(nPrice))
			
			i = i+1;
		else
			GOODS_BUTTONS[i]:SetActionItem(-1);
			GOODS_DESCS[i]:SetText("");
			GOOD_BAD[i]:SetText("");
			i = i+1;		
		end
		nActIndex = nActIndex+1;
	end


	if bHaveRide >= 1 then
		YuanbaoShop_Try:Show();		
	else
		YuanbaoShop_Try:Hide();	
	end
	
	if( nTotalPage == 1 ) then
		YuanbaoShop_UpPage:Hide();
		YuanbaoShop_DownPage:Hide();
		YuanbaoShop_CurrentlyPage:Hide();
	else
		YuanbaoShop_UpPage:Show();
		YuanbaoShop_DownPage:Show();
		YuanbaoShop_CurrentlyPage:Show();
		
		YuanbaoShop_UpPage:Enable();
		YuanbaoShop_DownPage:Enable();

		if ( nPageNum == nTotalPage ) then
			YuanbaoShop_DownPage:Disable();
		end
		
		if ( nPageNum == 1 ) then
			YuanbaoShop_UpPage:Disable()
		end

		YuanbaoShop_CurrentlyPage:SetText(tostring(nPageNum) .. "/" .. tostring(nTotalPage) );
	end
end
--点击一级标签
function YuanbaoShop_UpdateList(nIndex)
	if nIndex <1 or nIndex > 8 or nIndex == lastA then
		return
	end

	for i = 1 ,maxChildShop do
		SHOP_LIST_B[i]:Hide()
		if SHOP_LIST_A[nIndex].shoplist[i] ~= nil then
			SHOP_LIST_B[i]:SetText(SHOP_LIST_A[nIndex].shoplist[i])
			SHOP_LIST_B[i]:Show()
		end
	end

	SHOP_LIST_B[1]:SetCheck(1)
	lastB = 1
	lastA = nIndex
	lastSelect = 0

	UpdateShopItem( lastA ,lastB )
end
--点击店铺
function YuanbaoShop_UpdateShop(nIndex)
	if nIndex <1 or nIndex > maxChildShop or nIndex == lastB then
		return
	end

	lastB = nIndex
	
	if lastSelect > 0 and lastSelect < 8 then
		UpdateShopItem( lastSelect+8 , lastB )
	elseif lastA > 0 and lastA < 9 then
		UpdateShopItem( lastA , lastB )
	else
		UpdateShopItem( 1 , 1)
	end
end
--查找
function YuanbaoShop_BeginSearch()

	local str , nIndex = YuanbaoShop_SearchMode:GetCurrentSelect()

	if nIndex <1 or nIndex > 7 then
		return
	end

	for i = 1 ,maxChildShop do
		SHOP_LIST_B[i]:Hide()
		if SHOP_SEARCH_LIST[nIndex][i] ~= nil then
			SHOP_LIST_B[i]:SetText(SHOP_SEARCH_LIST[nIndex][i])
			SHOP_LIST_B[i]:Show()
		end
	end

	SHOP_LIST_B[1]:SetCheck(1)
	lastB = 1
	lastA = 0
	lastSelect = nIndex

	for i = 1 ,8 do
		SHOP_LIST_A[i].btn:SetCheck(0)
	end

	UpdateShopItem( nIndex+8 , 1 )
end
--试穿
function YuanbaoShop_OpenFitting()
	if IsIdleLogic() ~= 1 and IsMoveLogic() ~= 1 then
		SetNotifyTip("#{YBSD_081225_100}");
		return 0;
	end
	StopMove();
	
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end
	RestoreShopFitting();
	this:Show();	
	MouseCmd_ShopFittingSet();
	SetNotifyTip("#{YBSD_081225_099}");
end
--请求商店信息
function UpdateShopItem( shopA , shopB)
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OpenYuanbaoShop");
		Set_XSCRIPT_ScriptID(888902);
		Set_XSCRIPT_Parameter(0,ObjCared);
		Set_XSCRIPT_Parameter(1,shopA);
		Set_XSCRIPT_Parameter(2,shopB);
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
end
--===============================================
-- Button_Clicked
--===============================================
function YuanbaoShop_GoodButton_Clicked(nIndex)
	if(nIndex < 1 or nIndex > 18) then 
		return;
	end
	GOODS_BUTTONS[nIndex]:DoAction();
end
--===============================================
-- PageUp
--===============================================
function YuanbaoShop_PageUp()
	curPage = nPageNum - 1;
	if ( curPage >= maxPage ) then
		curPage = maxPage;
	end
	NpcShop:CloseConfirm();
	YuanbaoShop_UpdatePage( curPage );
end

--===============================================
-- PageDown
--===============================================
function YuanbaoShop_PageDown()
	curPage = nPageNum + 1;
	if ( curPage < 0 )  then
		curPage = 0;
	end
	NpcShop:CloseConfirm();
	YuanbaoShop_UpdatePage( curPage );
end

--===============================================
-- Close
--===============================================
function YuanbaoShop_Close()
	ObjCared = -1
	this:CareObject(objCared, 0, "YuanbaoShop");
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end
	if(IsWindowShow("YBShopReference")) then
		CloseWindow("YBShopReference",true)
	end
	SetDefaultMouse();
	CloseBooth();
	NpcShop:CloseConfirm();
	RestoreShopFitting();
	this:Hide();	
end

--随机排序
function YuanbaoShop_Order()
	local	max		= g_nTotalNum;
	local oldt	= {};
	g_tOrderPool= {};

	for i = 1, tonumber(max) do
	  oldt[i] = i-1;
	end
	
	if tonumber(NpcShop:GetIsShopReorder()) == 0 then
		g_tOrderPool		= oldt;
	else
		for i = 1, table.getn(oldt) do
		 local idx	= math.random(1, table.getn(oldt));
		 local val	= oldt[idx];
		 g_tOrderPool[i]= val;
		 table.remove(oldt, idx);
		end
	end
end

--确认按钮
function YuanbaoShop_querengoumai_Clicked()
	if(NpcShop:GetBuyDirectly() == 0)then
--		YuanbaoShop_querengoumai:SetCheck(0);
		NpcShop:SetBuyDirectly(1);
	else
--		YuanbaoShop_querengoumai:SetCheck(1);
		NpcShop:SetBuyDirectly(0);
	end
end

--快速充值
function YuanbaoShop_web_Clicked()
	GameProduceLogin:OpenURL("http://sde.game.sohu.com")
end
--目录和查找说明
function YuanbaoShop_Dis_Clicked()
	OpenYBShopReference("#{YBSD_081225_070}")
end
--元宝商店使用说明
function YuanbaoShop_Dis2_Clicked()
	OpenYBShopReference("#{YBSD_081225_098}")
end


--滚动信息顺序随机排列
function YubanbaoShop_ADRandom()
	YuanbaoShop_ScrollInfo_Frame:ClearInfo()
	
	local ADInfo = {
				"#{YBSD_081225_093}",
				"#{YBSD_081225_094}",
				"#{YBSD_081225_095}"
			}
	for i = 0 ,1 do
		local idx = math.random(1 ,3 - i)
		local str = ADInfo[idx]
		ADInfo[idx] = ADInfo[3 - i]
		ADInfo[3 - i] = str
	end
	
	for i = 1 ,3 do
		YuanbaoShop_ScrollInfo_Frame:SetScrollInfoFixed(ADInfo[i])
	end
	
end