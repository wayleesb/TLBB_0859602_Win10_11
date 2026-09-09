--UI COMMAND ID 105

local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_MembersCtl = {};
local g_selIdx = -1;

local g_GrayColor = "FFC8C8C8";

function SetCommerceNet_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
	this:RegisterEvent("CITY_SHOW_ROAD");
end

function SetCommerceNet_OnLoad()
end

function SetCommerceNet_OnEvent(event)
	City_Road_SetCtl();
	if(event == "UI_COMMAND" and tonumber(arg0) == 105) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		City:AskCityRoad();
	elseif(event == "CITY_SHOW_ROAD" and arg0 == "open") then
		this:CareObject(g_clientNpcId, 1, "CityRoad");
		City_Road_Clear();
		City_Road_Update();
		this:Show();
	elseif(event == "CITY_SHOW_ROAD" and arg0 == "openOwn") then
		City_Road_Clear();
		City_Road_Update();
		this:Show();
	elseif ( event == "CITY_SHOW_ROAD" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		City_Road_CareEventHandle(arg0,arg1,arg2);
	end
end

function City_Road_SetCtl()
	g_MembersCtl = {
									list = SetCommerceNet_Text1,
									btn = {
													SetCommerceNet_Accept,
													SetCommerceNet_Cancel,
												},
								 };
end

function City_Road_Clear()
	g_MembersCtl.list:RemoveAllItem();
	
	--for i = 1, table.getn(g_MembersCtl.btn) do
	--	g_MembersCtl.btn[i]:Disable();
	--end
	
	g_MembersCtl.btn[2]:Disable();
	g_selIdx = -1;
end

function City_Road_CareEventHandle(careId, op, distance)
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

function City_Road_Update()
	local roadNum = City:GetCityRoadInfo("RoadNum");
	for i = 1, roadNum do
		local detailInfo = {City:GetCityRoadInfo("RoadDetail", i-1)};
		--detailInfo[1]	帮会ID
		--detailInfo[2] 帮会名称
		--detailInfo[3] 城市所在
		--detailInfo[4] 对方是否和自己建立商业路线
		if(detailInfo[1] >= 0) then
			if(detailInfo[4]) then
				g_MembersCtl.list:AddNewItem(detailInfo[2],0,i-1);
				g_MembersCtl.list:AddNewItem(tostring(detailInfo[1]),1,i-1);
				g_MembersCtl.list:AddNewItem(detailInfo[3],2,i-1);
				g_MembersCtl.list:SetRowTooltip(i-1, "已互建商线");
			else
				g_MembersCtl.list:AddNewItem(detailInfo[2],0,i-1,g_GrayColor);
				g_MembersCtl.list:AddNewItem(tostring(detailInfo[1]),1,i-1,g_GrayColor);
				g_MembersCtl.list:AddNewItem(detailInfo[3],2,i-1,g_GrayColor);
				g_MembersCtl.list:SetRowTooltip(i-1, "未互建商线");
			end
		end
	end
end

function City_Road_SelectChanged()
	g_selIdx = g_MembersCtl.list:GetSelectItem();
	if(g_selIdx < 0) then
		g_MembersCtl.btn[2]:Disable();
	else
		g_MembersCtl.btn[2]:Enable();
	end
end

function City_Road_Clicked(idx)
	if(1 == idx) then	--建立
		City:DoCityRoad("create_show", g_clientNpcId);
	elseif(2 == idx) then	--取消
		City:DoConfirm(10, g_selIdx);
	end
end
