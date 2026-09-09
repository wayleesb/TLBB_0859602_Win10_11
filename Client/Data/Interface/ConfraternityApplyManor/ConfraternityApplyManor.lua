local MAX_CHARACTER_INPUTNAME = 12; --最长玩家名字
local MAX_COUNTRY_INPUTNAME   = 12; --最长帮会名字
local g_PortId = -1;
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Type = 0;
function ConfraternityApplyManor_PreLoad()
	this:RegisterEvent("CITY_SHOW_INPUT_NAME");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UI_COMMAND");
end

function ConfraternityApplyManor_OnLoad()
end

function ConfraternityApplyManor_OnEvent(event)
	if(event == "CITY_SHOW_INPUT_NAME" and arg0 == "open") then
		g_PortId = -1;
		g_PortId = tonumber(arg1);
		g_Type =0;
		ConfraternityApplyManor_Update(0, tonumber(arg2))
		this:Show();
	elseif(event == "CITY_SHOW_INPUT_NAME" and arg0 == "close") then
		this:Hide();
	elseif ( event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		City_InputName_CareEventHandle(arg0,arg1,arg2);
	elseif event == "UI_COMMAND" and (tonumber(arg0) == 5423  or tonumber(arg0) == 5424) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
			PushDebugMessage("server传过来的数据有问题。");
			return;
		end
		if(tonumber(arg0) == 5423)then
			g_Type =1;
		else
			g_Type =2;
		end
		
		ConfraternityApplyManor_Update(g_Type,objCared);
		this:Show();
	end
end

function ConfraternityApplyManor_Update(type,clientNpcId)
		ConfraternityApplyManor_FeudalName:SetProperty("DefaultEditBox", "True");
		ConfraternityApplyManor_FeudalName:SetText("");
		g_clientNpcId = clientNpcId;
		this:CareObject(g_clientNpcId, 1, "CityInputName");
		if(type == 0)then
			--新建城市
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength","12");
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_56}");	--#gFF0FA0申请城市领地
			ConfraternityApplyManor_Text1:SetText("#{INTERFACE_XML_627}"); --申请一块领地需要交纳1000两黄金或使用建城令牌
			ConfraternityApplyManor_Text1:Show();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_525}"); --请输入领地名
		elseif(type == 1)then
			--人物改名
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_CHARACTER_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_GAIMING_0}");	--#gFF0FA0角色改名
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_GAIMING_1}"); --请输入新的角色名称：
		elseif(type == 2)then
			--帮派改名
			ConfraternityApplyManor_FeudalName : SetProperty("MaxTextLength",""..MAX_COUNTRY_INPUTNAME);
			ConfraternityApplyManor_Text:SetText("#{INTERFACE_XML_GAIMING_2}");	--#gFF0FA0帮派改名
			ConfraternityApplyManor_Text1:Hide();
			ConfraternityApplyManor_Text2:SetText("#{INTERFACE_XML_GAIMING_3}"); --请输入新的帮派名称：
		end
end

function City_InputName_Clear()
	g_PortId = -1;
	ConfraternityApplyManor_FeudalName:SetText("");
end

function City_InputName_Confirm()
	if(g_PortId >= 0) then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		City:DoConfirm(1, g_PortId, txt);
	end
end

function City_InputName_CareEventHandle(careId, op, distance)
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

function ConfraternityApplyManor_Release_Button_Clicked()
	if g_Type == 0 then
		City_InputName_Confirm();
	elseif g_Type == 1 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Target:CharRnameCheck(txt);
		if(ret>0)then
			Target:CharRnameConfirm(txt);
			this:Hide();
		else
			City_InputName_Clear();
		end
	elseif g_Type == 2 then
		local txt = ConfraternityApplyManor_FeudalName:GetText();
		local ret = Guild:CityRnameCheck(txt);
		if(ret>0)then
			Guild:CityRnameConfirm(txt);
			this:Hide();
		else
			City_InputName_Clear();
		end
	end
end