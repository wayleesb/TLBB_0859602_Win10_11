--暗器 属性调整页面
local MAX_OBJ_DISTANCE = 3.0;
local objCared = -1;
local g_Object = -1;
local AnqiShuxing_g_CommandType = 1
local Dark_Button = -1
local Dark_Bag_Index = -1
local Dark_Attr_Name = {[1] = "#{equip_attr_str}",[2] = "#{equip_attr_spr}",[3] = "#{equip_attr_con}",[4] = "#{equip_attr_int}",[5] = "#{equip_attr_dex}",}

function AnqiShuxing_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UI_UPDATE_DARKITEM");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("RESUME_ENCHASE_GEM");           --参见\ClientLib\Ui_cegui\UISystem.cpp，line:1018
	--金钱改变的处理
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
end

function AnqiShuxing_OnLoad()
	Dark_Button = AnqiShuxing_Special_Button;
end

function AnqiShuxing_OnEvent(event)
	if(event == "UI_COMMAND" and tonumber(arg0) == 800034) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			AnqiShuxing_Close();
		end
		
		objCared = -1;
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,0,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		AnqiShuxing_BeginCareObject(objCared);

		AnqiShuxing_g_CommandType = Get_XParam_INT(0);
		AnqiShuxing_InitDlg();
	elseif (event == "UI_UPDATE_DARKITEM" and this:IsVisible()) then
		AnqiShuxing_Update(arg0);
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			AnqiShuxing_Close()
		end
	elseif(event == "RESUME_ENCHASE_GEM" and this:IsVisible())then
		if(tonumber(arg0) == 72) then
			AnqiShuxing_Resume();
		end
	elseif( (event == "UNIT_MONEY" or event == "MONEYJZ_CHANGE") and this:IsVisible()) then
		AnqiShuxing_UpdateMoneyDisp();
	end
end

function AnqiShuxing_UpdateMoneyDisp()
		local playerMoney = Player:GetData("MONEY");
		local playerMoneyJZ = Player:GetData("MONEY_JZ");
		AnqiShuxing_NeedMoney:SetProperty("MoneyMaxNumber", playerMoney + playerMoneyJZ);
		--AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", nNeed);
		AnqiShuxing_SelfJiaozi:SetProperty("MoneyNumber", playerMoneyJZ);
		AnqiShuxing_SelfMoney:SetProperty("MoneyNumber", playerMoney);
end

function AnqiShuxing_InitDlg( )
	if (AnqiShuxing_g_CommandType <=5 and AnqiShuxing_g_CommandType >= 1) then   --重洗暗器属性
		AnqiShuxing_DragTitle:SetText("#{FBSJ_081209_79}");
		AnqiShuxing_Info:SetText("#{FBSJ_090106_95}"..Dark_Attr_Name[AnqiShuxing_g_CommandType].."#{FBSJ_090106_96}");
		AnqiShuxing_Static2:SetText("#{FBSJ_081209_55}");
		AnqiShuxing_UpdateMoneyDisp();
		AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", 10000);
		this:Show();
		AnqiShuxing_OK:Disable();
	elseif (AnqiShuxing_g_CommandType == 6) then   --重洗暗器技能
		AnqiShuxing_DragTitle:SetText("#{FBSJ_081209_80}");
		AnqiShuxing_Info:SetText("#{FBSJ_081209_56}");
		AnqiShuxing_Static2:SetText("#{FBSJ_081209_87}");
		AnqiShuxing_UpdateMoneyDisp();
		AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", 50000);
		this:Show();
		AnqiShuxing_OK:Disable();
	elseif ( AnqiShuxing_g_CommandType == 7 ) then   --重置暗器品阶
		AnqiShuxing_DragTitle:SetText("#{FBSJ_090311_02}");
		AnqiShuxing_Info:SetText("#{FBSJ_081209_58}");
		AnqiShuxing_Static2:SetText("#{FBSJ_090311_05}");
		AnqiShuxing_UpdateMoneyDisp();
		AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", 10000);
		this:Show();
		AnqiShuxing_OK:Disable();
	elseif (AnqiShuxing_g_CommandType == 8 ) then
		AnqiShuxing_DragTitle:SetText("#{FBSJ_090311_02}");
		AnqiShuxing_Info:SetText("#{FBSJ_081209_78}");
		AnqiShuxing_Static2:SetText("#{FBSJ_090311_05}");
		AnqiShuxing_UpdateMoneyDisp();
		AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", 10000);
		this:Show();
		AnqiShuxing_OK:Disable();
	elseif ( AnqiShuxing_g_CommandType == 9) then   --重置暗器
		AnqiShuxing_DragTitle:SetText("#{FBSJ_081209_81}");
		AnqiShuxing_Info:SetText("#{FBSJ_090311_07}");
		AnqiShuxing_Static2:SetText("#{FBSJ_081209_59}");
		AnqiShuxing_UpdateMoneyDisp();
		AnqiShuxing_NeedMoney:SetProperty("MoneyNumber", 10000);
		this:Show();
		AnqiShuxing_OK:Disable();
	end
end

function AnqiShuxing_OK_Clicked()
	if (Dark_Bag_Index ~= -1) then
		local EquipPoint = LifeAbility : Get_Equip_Point(Dark_Bag_Index)
		if (EquipPoint ~= 17) then
			PushDebugMessage("#{FBSJ_081209_37}")
		end
		--客户端预先判断金钱，减轻服务器压力
		local nHave = AnqiShuxing_NeedMoney:GetProperty("MoneyMaxNumber");
		local nNeed = AnqiShuxing_NeedMoney:GetProperty("MoneyNumber");
		if (tonumber(nNeed) > tonumber(nHave)) then
			 PushDebugMessage("#{FBSJ_081209_25}");
			 return;
		end
		--洗属性，洗技能，重置
		if (AnqiShuxing_g_CommandType >=1 and AnqiShuxing_g_CommandType <= 5) then
			DataPool:DarkAdjustAttr(Dark_Bag_Index, AnqiShuxing_g_CommandType ,0);
		elseif (AnqiShuxing_g_CommandType == 6) then
			DataPool:DarkAdjustSkill(Dark_Bag_Index ,0);
		elseif (AnqiShuxing_g_CommandType == 7) then
			DataPool:DarkResetQuality(Dark_Bag_Index, 1 ,0);     --百淬神玉
		elseif (AnqiShuxing_g_CommandType == 8) then
			DataPool:DarkResetQuality(Dark_Bag_Index, 2 ,0);     --千淬神玉
		elseif (AnqiShuxing_g_CommandType == 9) then
			DataPool:DarkReset(Dark_Bag_Index ,0);
		end
		
		--LifeAbility : Lock_Packet_Item(Dark_Bag_Index,0);
		--Dark_Bag_Index = -1;
		--Dark_Button:SetActionItem(-1);
	end
	--AnqiShuxing_Close();
end


function AnqiShuxing_Cancel_Clicked()
	AnqiShuxing_Close();
end

function AnqiShuxing_Clear()
	 AnqiShuxing_Resume();
end


function AnqiShuxing_Update(Item_index)
	local i_index = tonumber(Item_index)
	local theAction = EnumAction(i_index, "packageitem");
	
	--先把对象给清了
	AnqiShuxing_Resume();
	
	AxTrace(0,0,tostring(i_index));
	if theAction:GetID() ~= 0 then
		Dark_Button:SetActionItem(theAction:GetID());
		Dark_Bag_Index = i_index;
		LifeAbility : Lock_Packet_Item(i_index,1);
		AnqiShuxing_OK:Enable();
	end
end


function AnqiShuxing_Resume()
	Dark_Button:SetActionItem(-1);
	AnqiShuxing_OK:Disable();
	if (Dark_Bag_Index ~= -1) then
		LifeAbility : Lock_Packet_Item(Dark_Bag_Index,0);
		Dark_Bag_Index = -1;
	end
end

function AnqiShuxing_Close()
	this:Hide()
	StopCareObject_Enchase(objCared)
end


--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function AnqiShuxing_BeginCareObject(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "AnqiShuxing");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function AnqiShuxing_StopCareObject(objCaredId)
	this:CareObject(objCaredId, 0, "AnqiShuxing");
	g_Object = -1;
	

end