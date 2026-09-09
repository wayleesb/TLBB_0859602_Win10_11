--UI COMMAND ID 101
local g_MembersCtl = {};
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

function CityTrendGraph_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
	
	this:RegisterEvent("CITY_SHOW_TREND_LEGEND");
end

function CityTrendGraph_OnLoad()
	CityTrendGraph_Trendline:SetProperty("Image", "set:GuidLegend_RenderTexture image:View");
end

function CityTrendGraph_OnEvent(event)
	City_Trend_SetCtl();
	if(event == "UI_COMMAND" and tonumber(arg0) == 101) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		--City:AskCityTrend();
	elseif(event == "CITY_SHOW_TREND_LEGEND" and arg0 == "open") then
		this:CareObject(g_clientNpcId, 1, "CityTrend");
		City_Trend_Update();
		this:Show();
	elseif(event == "CITY_SHOW_TREND_LEGEND" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		City_Trend_CareEventHandle(arg0,arg1,arg2);
	end
end

function City_Trend_SetCtl()
	g_MembersCtl =	{
										CityTrendGraph_Numerical1,		--工业率
										CityTrendGraph_Numerical4,		--农业率
										CityTrendGraph_Numerical6,		--商业率
										CityTrendGraph_Numerical2,		--国防率
										CityTrendGraph_Numerical5,		--科技率
										CityTrendGraph_Numerical3,		--扩张率
										
										plus = CityTrendGraph_Text14,	--剩余点数
										
										addbtn =	{
																CityTrendGraph_Addition_Button1,
																CityTrendGraph_Addition_Button4,
																CityTrendGraph_Addition_Button2,
																CityTrendGraph_Addition_Button5,
																CityTrendGraph_Addition_Button3,
																CityTrendGraph_Addition_Button6,
															},
										
										decbtn =	{
																CityTrendGraph_Decrease_Button1,
																CityTrendGraph_Decrease_Button4,
																CityTrendGraph_Decrease_Button2,
																CityTrendGraph_Decrease_Button5,
																CityTrendGraph_Decrease_Button3,
																CityTrendGraph_Decrease_Button6,
															},
									};
end

function City_Trend_SetBtnState()
	local k;
	local btnNum = table.getn(g_MembersCtl.addbtn);
	
	--剩余点数
	if(0 >= tonumber(g_MembersCtl.plus:GetText())) then
		for k = 1, btnNum do
			g_MembersCtl.decbtn[k]:Enable();
			g_MembersCtl.addbtn[k]:Disable();
		end
	else
		for k = 1, btnNum do
			g_MembersCtl.decbtn[k]:Enable();
			g_MembersCtl.addbtn[k]:Enable();
		end
	end
	
	--逐项调整
	for k = 1, btnNum do
		if(tonumber(g_MembersCtl[k]:GetText()) <= 10) then
			g_MembersCtl.decbtn[k]:Disable();
		elseif(tonumber(g_MembersCtl[k]:GetText()) >= 100) then
			g_MembersCtl.addbtn[k]:Disable();
		end
	end
	
end

function City_Trend_Update()
	local k;
	local te = {City:GetCityTrend()};
	local teNum = table.getn(te);
	
	for k = 1, teNum-1 do
		g_MembersCtl[k]:SetText(tostring(te[k]));
	end
	g_MembersCtl.plus:SetText(tostring(te[teNum]));
	
	City_Trend_SetBtnState();
	City_Trend_Rebulid_Legend();
end

function City_Trend_Rebulid_Legend()
	City:RebulidLegend(
											tonumber(g_MembersCtl[1]:GetText()),
											tonumber(g_MembersCtl[2]:GetText()),
											tonumber(g_MembersCtl[3]:GetText()),
											tonumber(g_MembersCtl[4]:GetText()),
											tonumber(g_MembersCtl[5]:GetText()),
											tonumber(g_MembersCtl[6]:GetText())
										);
end

function City_Trend_Add(ty)
	City_Trend_Change_Value(1, ty);
end

function City_Trend_Dec(ty)
	City_Trend_Change_Value(-1, ty);
end

function City_Trend_Change_Value(dir, ty)
	local offset = tonumber(dir);
	local ctl = g_MembersCtl[tonumber(ty)];
	
	if(nil == ctl) then return; end
	local newVal = tonumber(ctl:GetText())+offset;
	local newPoint = tonumber(g_MembersCtl.plus:GetText())+offset*-1;
	
	if(newVal < 10 or newVal > 100 or newPoint < 0) then
		return;
	end
	ctl:SetText(tostring(newVal));
	g_MembersCtl.plus:SetText(tostring(newPoint));

	City_Trend_SetBtnState();	
	City_Trend_Rebulid_Legend();
end

function City_Trend_Accept_Clicked()
	--City:FixCityTrend(
	--										tonumber(g_MembersCtl[1]:GetText()),
	--										tonumber(g_MembersCtl[2]:GetText()),
	--										tonumber(g_MembersCtl[3]:GetText()),
	--										tonumber(g_MembersCtl[4]:GetText()),
	--										tonumber(g_MembersCtl[5]:GetText()),
	--										tonumber(g_MembersCtl[6]:GetText()),
	--										tonumber(g_MembersCtl.plus:GetText())
	--									);
	City:DoConfirm(
									6,
									tonumber(g_MembersCtl[1]:GetText()),
									tonumber(g_MembersCtl[2]:GetText()),
									tonumber(g_MembersCtl[3]:GetText()),
									tonumber(g_MembersCtl[4]:GetText()),
									tonumber(g_MembersCtl[5]:GetText()),
									tonumber(g_MembersCtl[6]:GetText()),
									tonumber(g_MembersCtl.plus:GetText())
								);
	--this:Hide();
end

function City_Trend_CareEventHandle(careId, op, distance)
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