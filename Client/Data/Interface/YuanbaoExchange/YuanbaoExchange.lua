local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local Exchange_Rate = 1;
local g_Point = 0;
local g_Object = -1;

function YuanbaoExchange_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function YuanbaoExchange_OnLoad()

end

function YuanbaoExchange_OnEvent(event)

	if ( event == "UI_COMMAND" and tonumber(arg0) == 2001 ) then
			if this:IsVisible() then
				YuanbaoExchange_Close();
				return
			end
			g_Object = Get_XParam_INT(0);
			BeginCareObject_YuanbaoExchange(Target:GetServerId2ClientId(g_Object));
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			YuanbaoExchange_OnShown();
			this:Show();
			YuanbaoExchange_Count_Change();
			YuanbaoExchange_Max:Disable()
			YuanbaoExchange_OK : Disable()
	elseif ( event == "UI_COMMAND" and tonumber(arg0) == 2003 ) then
		if(this:IsVisible()) then
			YuanbaoExchange_Moral_Value:SetProperty("DefaultEditBox", "True");
			YuanbaoExchange_Moral_Value:SetSelected( 0, -1 );
			g_Point = Get_XParam_INT(0)/1000;
			YuanbaoExchange_Text1 : SetText("您目前账户上还剩余点数："..g_Point)
			YuanbaoExchange_Max:Enable()
			YuanbaoExchange_OK:Enable()
			YuanbaoExchange_Moral_Value:Enable();
		end
	elseif ( event == "OBJECT_CARED_EVENT") then
		YuanbaoExchange_CareEventHandle(arg0,arg1,arg2);
	end

end

function YuanbaoExchange_OnShown()
	YuanbaoExchange_Clear();
	YuanbaoExchange_Update();
end

function YuanbaoExchange_Clear()
	YuanbaoExchange_Text1 : SetText("")
	YuanbaoExchange_Moral_Value : SetText("")
	YuanbaoExchange_Text3 : SetText("")
	g_Point = 0;
	Exchange_Rate = 1;
end

function YuanbaoExchange_Update()
	Exchange_Rate = Get_XParam_INT(1)/1000
	
	YuanbaoExchange_Text1 : SetText("#cff0000#b剩余点数正在查询中，请稍候……")
	YuanbaoExchange_Text3 : SetText("需要花费点数：0")
	
end

function YuanbaoExchange_OK_Clicked()
	local str = YuanbaoExchange_Moral_Value : GetText();
	
	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 1 "..tostring(str));

	if str == nil or str == "" then
		YuanbaoExchange_Text3 : SetText("需要花费点数：0")
		PushDebugMessage("请输入要兑换的元宝数额")
		return
	end
	
	if tonumber(str) > 10000 then
		PushDebugMessage("每次兑换的元宝数量最多为10000点，请输入小于等于10000点的数字。")
		return
	end
	if( tonumber(str) <= 0 ) then
		PushDebugMessage("每次兑换的元宝数量最少为1点，请输入大于等于1点的数字。")
		return
	end
	
	--AxTrace(0,0,"YuanbaoExchange_OK_Clicked 2");
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("BuyYuanbao");
		Set_XSCRIPT_ScriptID(181000);
		Set_XSCRIPT_Parameter(0,tonumber(str));
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
	
	YuanbaoExchange_Close();
end

function YuanbaoExchange_Close()
	YuanbaoExchange_OnHiden();
	this:Hide()
end

function YuanbaoExchange_Cancel_Clicked()
	YuanbaoExchange_Close();
	return;
end

function YuanbaoExchange_OnHiden()
	StopCareObject_YuanbaoExchange(objCared)
	YuanbaoExchange_Clear()
	return
end

function YuanbaoExchange_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			YuanbaoExchange_Close();
		end
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_YuanbaoExchange(objCaredId)

	g_Object = objCaredId;
	--AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "YuanbaoExchange");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_YuanbaoExchange(objCaredId)
	this:CareObject(objCaredId, 0, "YuanbaoExchange");
	g_Object = -1;

end

function YuanbaoExchange_Count_Change()
	local str = YuanbaoExchange_Moral_Value : GetText();
	local strNumber = 0;	
	
	if ( str == nil ) then
		return;
	elseif( str == "" ) then
		strNumber = 1;
	else
		strNumber = tonumber( str );
	end
	str = tostring( strNumber );
	YuanbaoExchange_Moral_Value:SetTextOriginal( str );
	YuanbaoExchange_Text3 : SetText("需要花费点数："..tostring( Exchange_Rate * strNumber ) )
end

function YuanbaoExchange_Max_Clicked()
	local maxYuanBao = 10000;
	local point2YuanBao = g_Point/Exchange_Rate;
	if point2YuanBao < 0 then point2YuanBao = 0; end
	
	YuanbaoExchange_Moral_Value:SetProperty("ClearOffset", "True");
	if point2YuanBao > maxYuanBao then
		YuanbaoExchange_Moral_Value:SetText(tostring(maxYuanBao));
	else
		YuanbaoExchange_Moral_Value:SetText(tostring(point2YuanBao));
	end
	YuanbaoExchange_Moral_Value:SetProperty("CaratIndex", 1024);
end