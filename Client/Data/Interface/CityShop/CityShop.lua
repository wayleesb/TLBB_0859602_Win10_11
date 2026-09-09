--UI COMMAND ID 104
local g_MembersCtl = {};
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_CurPage = 1;			--当前在第几页
local g_TotalPage = 1;		--最大页数

function CityShop_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
	this:RegisterEvent("CITY_SHOW_SHOP");
end

function CityShop_OnLoad()
	--隐藏无用的控件
	CityShop_Repair:Hide();
	CityShop_AllRepair:Hide();
	
	--hzp 2009-03-02
	CityShop_Repair_bk:Hide();
	CityShop_AllRepair1_bk:Hide();
	
	CityShop_Callback1:Hide();
	CityShop_Callback2:Hide();
	CityShop_Callback3:Hide();
	CityShop_Callback4:Hide();
	CityShop_Callback5:Hide();
end

function CityShop_OnEvent(event)
	City_Shop_SetCtl();
	if(event == "UI_COMMAND" and tonumber(arg0) == 104) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		City:AskCityShop(Get_XParam_INT(1));
	elseif ( event == "CITY_SHOW_SHOP" and arg0 == "open") then
		if(this:IsVisible() and City_Shop_Is_TicketPrice_Idx(City:GetCityShopInfo(0, "bid")) > 0) then
			City_Shop_Update_CurPage();
		else
		this:CareObject(g_clientNpcId, 1, "CityShop");
		City_Shop_Clear();
		City_Shop_Update();
		this:Show();
		end
	elseif ( event == "CITY_SHOW_SHOP" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		City_Shop_CareEventHandle(arg0,arg1,arg2);
	end
end

function City_Shop_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end

function City_Shop_SetCtl()
	g_MembersCtl = 	{
										{act = CityShop_Item1, money = CityShop_ItemInfo1_Price, txt = CityShop_ItemInfo1_Text, mtxt = CityShop_ItemInfo1_GB},
										{act = CityShop_Item2, money = CityShop_ItemInfo2_Price, txt = CityShop_ItemInfo2_Text, mtxt = CityShop_ItemInfo2_GB},
										{act = CityShop_Item3, money = CityShop_ItemInfo3_Price, txt = CityShop_ItemInfo3_Text, mtxt = CityShop_ItemInfo3_GB},
										{act = CityShop_Item4, money = CityShop_ItemInfo4_Price, txt = CityShop_ItemInfo4_Text, mtxt = CityShop_ItemInfo4_GB},
										{act = CityShop_Item5, money = CityShop_ItemInfo5_Price, txt = CityShop_ItemInfo5_Text, mtxt = CityShop_ItemInfo5_GB},
										{act = CityShop_Item6, money = CityShop_ItemInfo6_Price, txt = CityShop_ItemInfo6_Text, mtxt = CityShop_ItemInfo6_GB},
										{act = CityShop_Item7, money = CityShop_ItemInfo7_Price, txt = CityShop_ItemInfo7_Text, mtxt = CityShop_ItemInfo7_GB},
										{act = CityShop_Item8, money = CityShop_ItemInfo8_Price, txt = CityShop_ItemInfo8_Text, mtxt = CityShop_ItemInfo8_GB},
										{act = CityShop_Item9, money = CityShop_ItemInfo9_Price, txt = CityShop_ItemInfo9_Text, mtxt = CityShop_ItemInfo9_GB},
										{act = CityShop_Item10, money = CityShop_ItemInfo10_Price, txt = CityShop_ItemInfo10_Text, mtxt = CityShop_ItemInfo10_GB},
										{act = CityShop_Item11, money = CityShop_ItemInfo11_Price, txt = CityShop_ItemInfo11_Text, mtxt = CityShop_ItemInfo11_GB},
										{act = CityShop_Item12, money = CityShop_ItemInfo12_Price, txt = CityShop_ItemInfo12_Text, mtxt = CityShop_ItemInfo12_GB},
										
										prv = CityShop_UpPage,
										nxt	=	CityShop_DownPage,
										ptxt = CityShop_CurrentlyPage,
									};
end

function City_Shop_Clear()
	City_Shop_Act_Clear();
	g_CurPage = 1;
	g_TotalPage = 1;
end

function City_Shop_Act_Clear()
	local i;
	for i = 1, table.getn(g_MembersCtl) do
		g_MembersCtl[i].act:SetActionItem(-1);
		g_MembersCtl[i].act:SetPushed(0);
		g_MembersCtl[i].act:Bright();
		g_MembersCtl[i].act:Hide();
		
		g_MembersCtl[i].money:SetProperty("MoneyNumber", "0");
		g_MembersCtl[i].money:Hide();
		
		g_MembersCtl[i].txt:SetText("");
		g_MembersCtl[i].txt:Hide();
		
		g_MembersCtl[i].mtxt:SetText("");
		g_MembersCtl[i].mtxt:Hide();
	end
end

function City_Shop_UpPage()
	City_Shop_NextPage(-1);
end

function City_Shop_DownPage()
	City_Shop_NextPage(1);
end

function City_Shop_NextPage(dir)
	if(g_CurPage == 1 and dir < 0) then return; end --已经是第一页
	local newPage = g_CurPage+dir;
	local newAction = (City:EnumCityShop((newPage-1)*12+1));
	if(newAction:GetID() == 0) then return; end --新页的第一个位置上就没有研究项目
	
	g_CurPage = newPage;	
	City_Shop_Update_CurPage();
end

function City_Shop_Update_CurPage()
	City_Shop_Act_Clear();
	local i = 1;
	while i <= 12 do
		City_Shop_Act_Set(i);
		
		i = i + 1;
	end

	City_Shop_BtnSet();
end

function City_Shop_Act_Set(i)
	local theAction, isSoldOut = City:EnumCityShop((g_CurPage-1)*12+(tonumber(i)));
		if theAction:GetID() ~= 0 then
			--设置ActionItem
			g_MembersCtl[i].act:SetActionItem(theAction:GetID());

			--设置是否已经售完
			--if(isSoldOut < 0) then
			--	g_MembersCtl[i].act:Bright();
			--elseif(isSoldOut > 0) then
			--	g_MembersCtl[i].act:Gloom();
			--end
						
			g_MembersCtl[i].act:Show();
			
		if(City_Shop_Is_TicketPrice_Idx(City:GetCityShopInfo(0, "bid")) > 0) then
			--设置商票金钱
			local money = City:GetCityShopInfo((g_CurPage-1)*12+(tonumber(i)), "tprice");
			g_MembersCtl[i].money:SetProperty("MoneyNumber", tostring(money));
			g_MembersCtl[i].money:Show();
			
			g_MembersCtl[i].txt:SetText("商票金钱");
			g_MembersCtl[i].txt:Show();
		else
			--设置金钱
			local money = City:GetCityShopInfo((g_CurPage-1)*12+(tonumber(i)), "price");
			g_MembersCtl[i].money:SetProperty("MoneyNumber", tostring(money));
			g_MembersCtl[i].money:Show();
			--设置帮贡
			local contribute = City:GetCityShopInfo((g_CurPage-1)*12+(tonumber(i)), "contribute");
			g_MembersCtl[i].txt:SetText("帮贡："..tostring(contribute));
			g_MembersCtl[i].txt:Show();
		end
		else
			g_MembersCtl[i].act:SetActionItem(-1);
		end
	end

function City_Shop_BtnSet()
	local preAction = (City:EnumCityShop((g_CurPage-1)*12));
	local nextAction = (City:EnumCityShop((g_CurPage-1)*12+12+1));

	if(preAction:GetID() ~= 0)then
		g_MembersCtl.prv:Enable();
	else
		g_MembersCtl.prv:Disable();
	end
	
	if(nextAction:GetID() ~= 0)then
		g_MembersCtl.nxt:Enable();
	else
		g_MembersCtl.nxt:Disable();
	end
	
	g_MembersCtl.ptxt:SetText(tostring(g_CurPage).."/"..tostring(g_TotalPage));
end

function City_Shop_Update()
	local total = City:GetCityShopInfo(0, "total");
	if(total/12 > 0) then
		g_TotalPage = math.floor(total/12) + 1;
	else
		g_TotalPage = math.floor(total/12);
	end
	
	City_Shop_NextPage(0);
end

function City_Shop_Act_Clicked(idx)
	City:DoCityShop((g_CurPage-1)*12+(tonumber(idx)));
end

function City_Shop_Is_TicketPrice_Idx(bid)
	--目前消耗商票金钱的建筑物类型，对应enum BUILDING_TYPE
	local tTicket = {3};
	local i = 1;
	while i <= table.getn(tTicket) do
		if(tTicket[i] == bid) then return 1; end
		i = i + 1;
	end
	return -1;
end