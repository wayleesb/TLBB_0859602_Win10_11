local Price_Down = 1;
local Price_Up = 0;
local mission_index = -1;
local Carriage_Before_NPC = 0;
local Current = -1;
local Sell_Price = -1;
local Caoyun_Circle = 15
local nTransNPC = -1
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;

function Carriage_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
end
	
function Carriage_OnLoad()
	if(IsWindowShow("Shop_Fitting")) then
		--RestoreShopFitting();
		--CloseShopFitting();
		CloseWindow("Shop_Fitting", true);
	end
end

-- OnEvent
function Carriage_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		Carriage_FreightGroup2_Frame : Show();
		Carriage_FreightGroup1_Frame : Show()
		Carriage_Enchiridion : Hide();
--		Carriage_Enchiridion_Bak : Hide();
		if(tonumber(arg0) == 0) then
			Carriage_Quest_Shown();
		elseif(tonumber(arg0) == 1) then
			Carriage_Trade_Shown();
		end
	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--取消关心
			StopCareObject_Carriage(objCared);
		end
	end
	
	if(IsWindowShow("Shop_Fitting")) then
			CloseWindow("Shop_Fitting", true);
	end
end


function Carriage_Quest_Shown()

	local UI_ID = Get_XParam_INT(0);
	local misIndex;
	
	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	if UI_ID == 4 then
			
		Carriage_Redeem:Hide();
		Carriage_Draw:Show();


		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Hide();
		
		Carriage_Freight_Sell_1_1:Hide();
		Carriage_Freight_Sell_1_2:Hide();
		Carriage_Freight_Sell_2_2:Hide();
		Carriage_Freight_Sell_2_3:Hide();
		
		Carriage_ContrabandSalt_Freight:Hide();
		Carriage_Freight5:Hide();
		Carriage_Freight6:Hide();
		Carriage_Freight7:Hide();
		
		--Carriage_Abandon:Hide();
		
		Carriage_Down:Disable();
		Carriage_Up:Disable();
		
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_1:Show();
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Buy_1:Show();
		Carriage_Money_Buy_2:Show();
		
		Carriage_Freight_Buy_1_Info : SetText("")
		Carriage_Freight_Buy_2_Info : SetText("")
		Carriage_Freight_Sell_1_Info : SetText("")
		Carriage_Freight_Sell_2_Info : SetText("")
		
		Carriage_Info1:SetText("官票余额:")
		Carriage_Balance:SetProperty("MoneyNumber","");
		--Carriage_Info2:SetText("漕运环数:")
		Carriage_Info3:SetText("打压市场时机:")
		Carriage_Info4:SetText("哄抬市价时机:")

		this:Show();
		Carriage_Before_NPC = Get_XParam_INT(1);
		AxTrace(0,1,"Carriage_Before_NPC="..Carriage_Before_NPC);
		Carriage_Place = Get_XParam_INT(2);
		
		if Carriage_Place == 1 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_LuoYang");

		elseif Carriage_Place == 3 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Suzhou");

		elseif Carriage_Place == 2 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Dali");

		elseif Carriage_Place == 4 then
			Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Blackmarket");

		end
		
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		BeginCareObject_Carriage(objCared)
		
	elseif UI_ID == 3 then
		Carriage_Draw : Hide();
		Carriage_Redeem : Show();
		--Carriage_Abandon: Show();
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnPopupBargainingUI");
			Set_XSCRIPT_ScriptID(311010);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();

		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		BeginCareObject_Carriage(objCared)
				
	elseif UI_ID == 5 then
		local UI_Detail = Get_XParam_INT(1);
		AxTrace(0,6,"UI_Detail="..UI_Detail);
		
		if UI_Detail == 1 then
			PushDebugMessage("你已经有官票在身了，还不快去运送货物！");

		elseif UI_Detail == 2 then
			PushDebugMessage("给你官票，现在你就是大宋民间漕运使了。");
			Carriage_Draw : Hide();
			Carriage_Redeem : Show();
	
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnEnumerate");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_Parameter(0,Carriage_Before_NPC);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
				
		elseif UI_Detail == 3 then
			PushDebugMessage("我马上给你兑换官票。");
				
		elseif UI_Detail == 4 then
			PushDebugMessage("你没有官票，是不能进行兑换的。");
				
		elseif UI_Detail == 5 then
			PushDebugMessage("你去兑换官票吧，本次交易已经超限。");
				
		elseif UI_Detail == 6 then
			PushDebugMessage("你把官票弄丢了吧！");
		
		elseif UI_Detail == 7 then
			
			local cargo = Get_XParam_INT(2)
			local cargo_name;
			
			if cargo == 1 then
				cargo_name = "盐"
			elseif cargo == 2 then
				cargo_name = "铁"
			elseif cargo == 3 then
				cargo_name = "米"
			end
			
			PushDebugMessage("你的"..cargo_name.."舱已满！");
			
		elseif UI_Detail == 8 then
			
			local cargo = Get_XParam_INT(2)
			local cargo_name;
			
			if cargo == 1 then
				cargo_name = "盐"
			elseif cargo == 2 then
				cargo_name = "铁"
			elseif cargo == 3 then
				cargo_name = "米"
			end
			PushDebugMessage("你没有"..cargo_name.."！");
			
		elseif UI_Detail == 9 then
			
			local time_caoyun = Get_XParam_INT(2);
			PushDebugMessage("冷却时间未到！");
			local Time_Str1 = math.floor(time_caoyun/60);
			local Time_Str2 = time_caoyun - Time_Str1*60;
			PushDebugMessage(" " .. math.floor(Time_Str1) .. "分" ..	math.floor(Time_Str2) .."秒后，才可再次使用该技能")
			
		elseif UI_Detail == 10 then
			PushDebugMessage("今天是昨天的明天！");
			
		elseif UI_Detail == 11 then
			Refresh_My_Freight()
		
		elseif UI_Detail == 12 then
			Current = 100;
			Carriage_Quest_GuanPiao_Show();
			return

		elseif UI_Detail == 13 then
			PushDebugMessage("你的热销冷却时间结束了！");
			
		elseif UI_Detail == 14 then
			PushDebugMessage("你的杀价冷却时间结束了！");

		end
				
	end
	Current = UI_ID;
		
end	

function Carriage_Quest_GuanPiao_Show()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Help");

		local CD_Time_Sell = Get_XParam_INT(2)
		local CD_Time_Buy = Get_XParam_INT(3)
		local circle = Get_XParam_INT(4)
		mission_index = Get_XParam_INT(5)
		Sell_Price = Get_XParam_INT(7)
		
		AxTrace(0,1,"CD_Time_Sell="..CD_Time_Sell)
		AxTrace(0,1,"CD_Time_Buy="..CD_Time_Buy)
		
		if CD_Time_Buy > 0 then
			CD_Time_Buy = CD_Time_Buy / 60;
			if CD_Time_Buy < 1 then
				CD_Time_Buy = 1;
			end
			CD_Time_Buy = tostring(math.floor(CD_Time_Buy)).."分";
		else
			CD_Time_Buy = "现在即可"
		end
		Carriage_Down : Disable();
		
		if CD_Time_Sell > 0 then
			CD_Time_Sell = CD_Time_Sell / 60;
			if CD_Time_Sell < 1 then
				CD_Time_Sell = 1;
			end
			CD_Time_Sell = tostring(math.floor(CD_Time_Sell)).."分";
		else
			CD_Time_Sell = "现在即可"
		end
		Carriage_Up : Disable();
		
		Carriage_Draw : Hide();
		Carriage_Redeem : Hide();

		
		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Hide();

		Carriage_Freight_Sell_1_1:Hide();
		Carriage_Freight_Sell_1_2:Hide();
		Carriage_Freight_Sell_2_2:Hide();
		Carriage_Freight_Sell_2_3:Hide();
		
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
		Carriage_Money_Sell_1:Hide();
		Carriage_Money_Sell_2:Hide();
		Carriage_Money_Buy_1:Hide();
		Carriage_Money_Buy_2:Hide();
		
		Carriage_Freight_Buy_1_Info : SetText("")
		Carriage_Freight_Buy_2_Info : SetText("")
		Carriage_Freight_Sell_1_Info : SetText("")
		Carriage_Freight_Sell_2_Info : SetText("")
		
		--Carriage_Info2:SetText("漕运环数:"..tostring(circle).."环");
		Carriage_Info3:SetText("打压市场时机:"..CD_Time_Buy)
		Carriage_Info4:SetText("哄抬市价时机:"..CD_Time_Sell)
--		Carriage_Enchiridion_Bak : Show();
		local my_level = Player:GetData( "LEVEL" );
		Carriage_Enchiridion : Show();
		Carriage_Enchiridion : SetText("任务级别:"..my_level.."#r今天漕运的次数:"..Get_XParam_INT(6));
	
		Carriage_FreightGroup2_Frame : Hide();
		Carriage_FreightGroup1_Frame : Hide()
		Refresh_My_Freight();
		StopCareObject_Carriage(objCared);
		
end


function Carriage_Trade_Shown()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	local UI_ID = Get_XParam_INT(0);


	if UI_ID == 3 then

			mission_index = Get_XParam_INT(1);
			Carriage_Trade_Update()
			this:Show();
			
	elseif UI_ID == 4 then

			mission_index = Get_XParam_INT(1);
			Carriage_Trade_Update_Price(mission_index,Price_Up);
			this:Show();
			
	elseif UI_ID == 5 then

			mission_index = Get_XParam_INT(1);
			Carriage_Trade_Update_Price(mission_index,Price_Down);
			this:Show();
			
	end
	Current = UI_ID;
end

function Carriage_Trade_Update()
--1就是卖盐，买铁、米的
--2就是卖铁，买盐、米的
--3就是卖米，买盐、铁的
--4就是货商，啥都卖的
	local misIndex = mission_index;

	AxTrace(0,1,"Carriage_Trade_Update mission_index="..mission_index)
	nTransNPC = Get_XParam_INT(8)

	local CD_Time_Sell = Get_XParam_INT(6);

	local CD_Time_Buy = Get_XParam_INT(7);
	AxTrace(0,1,"CD_Time_Sell="..CD_Time_Sell)
	AxTrace(0,1,"CD_Time_Buy="..CD_Time_Buy)

	Carriage_Money_Buy_1:Hide();
	Carriage_Money_Buy_2:Hide();

	if CD_Time_Buy > 0 then
		CD_Time_Buy = CD_Time_Buy / 60;
		if CD_Time_Buy < 1 then
			CD_Time_Buy = 1;
		end
		CD_Time_Buy = tostring(math.floor(CD_Time_Buy)).."分钟后";
		Carriage_Down : Disable();
	else
		CD_Time_Buy = "现在即可"
		Carriage_Down : Enable();
	end
	
	if CD_Time_Sell > 0 then
		CD_Time_Sell = CD_Time_Sell / 60;
		if CD_Time_Sell < 1 then
			CD_Time_Sell = 1;
		end
		CD_Time_Sell = tostring(math.floor(CD_Time_Sell)).."分钟后";
		Carriage_Up : Disable();
	else
		CD_Time_Sell = "现在即可"
		Carriage_Up : Enable();
	end
	local Balance = DataPool:GetPlayerMission_Variable(misIndex,5)
	local Round = DataPool:GetPlayerMission_DataRound(Caoyun_Circle);
	AxTrace(0,1,"round="..Round)
	AxTrace(0,1,"Balance="..Balance)
	AxTrace(0,1,"nTransNPC="..nTransNPC)
	if nTransNPC == 1 then
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_LuoYang");
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_1_1:Show();
		Carriage_Freight_Buy_1_1:SetToolTip("盐，产自洛阳#r点击买入#r当前价格: #{_EXCHG"..Get_XParam_INT(2).."}");
		Carriage_Freight_Buy_1_Info : SetText("盐")
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(2)));
		Carriage_Money_Buy_1:Show();
			
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Hide();
		Carriage_Freight_Buy_2_Info : SetText("")
			
		Carriage_Freight_Sell_1_1:Hide();
--			Carriage_Freight_Sell_1_2:Show();
--			Carriage_Freight_Sell_1_2:SetToolTip("铁，产自大理#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_1_Info:SetText("铁")
		Carriage_Money_Sell_1:Show();
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			
		Carriage_Freight_Sell_2_2:Hide();
--			Carriage_Freight_Sell_2_3:Show();
--			Carriage_Freight_Sell_2_3:SetToolTip("米，产自苏州#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_2_Info : SetText("米")
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
		Sell_Price = Get_XParam_INT(3);
						
		Carriage_Down:Show();
		Carriage_Up:Show();
						
	elseif nTransNPC == 2 then
		
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Dali");
		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Show();
		Carriage_Freight_Buy_1_2:SetToolTip("铁，产自大理#r点击买入#r当前价格: #{_EXCHG"..Get_XParam_INT(2).."}");
		Carriage_Freight_Buy_1_Info : SetText("铁")
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(2)));
		Carriage_Money_Buy_1:Show();
			
		Carriage_Freight_Buy_2_3:Hide();
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_Info : SetText("")
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
			
		Carriage_Freight_Sell_1_2:Hide();
--			Carriage_Freight_Sell_1_1:Show();
--			Carriage_Freight_Sell_1_1:SetToolTip("盐，产自洛阳#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_1_Info : SetText("盐")
		Carriage_Money_Sell_1:Show()
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			
		Carriage_Freight_Sell_2_2:Hide();
--			Carriage_Freight_Sell_2_3:Show();
--			Carriage_Freight_Sell_2_3:SetToolTip("米，产自苏州#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_2_Info : SetText("米")
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
		Sell_Price = Get_XParam_INT(3);
			
		Carriage_Down:Show();
		Carriage_Up:Show();
		
	elseif nTransNPC == 3 then
		
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Suzhou");
		Carriage_Freight_Buy_2_2:Hide();
		Carriage_Freight_Buy_2_3:Show();
		Carriage_Freight_Buy_2_3:SetToolTip("米，产自苏州#r点击买入#r当前价格: #{_EXCHG"..Get_XParam_INT(2).."}");
		Carriage_Freight_Buy_2_Info : SetText("米")
		Carriage_Money_Buy_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(2)));
		Carriage_Money_Buy_2:Show();
			
		Carriage_Freight_Buy_1_1:Hide();
		Carriage_Freight_Buy_1_2:Hide();
		Carriage_Freight_Buy_1_Info : SetText("")
		Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
			
		Carriage_Freight_Sell_1_2:Hide();
--			Carriage_Freight_Sell_1_1:Show();
--			Carriage_Freight_Sell_1_1:SetToolTip("盐，产自洛阳#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_1_Info : SetText("盐")
		Carriage_Money_Sell_1:Show()
		Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			
		Carriage_Freight_Sell_2_3:Hide();
--			Carriage_Freight_Sell_2_2:Show();
--			Carriage_Freight_Sell_2_2:SetToolTip("铁，产自大理#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
		Carriage_Freight_Sell_2_Info : SetText("铁")
		Carriage_Money_Sell_2:Show();
		Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
		Sell_Price = Get_XParam_INT(3);
						
		Carriage_Down:Show();
		Carriage_Up:Show();
		
	elseif nTransNPC == 4 then
		Carriage_Background_Facia:SetProperty("Image", "set:Carriage4 image:Carriage4_Blackmarket");
		Carriage_Draw : Hide();
		Carriage_Redeem : Hide();
		if(Get_XParam_INT(5) == 1) then
			
			Carriage_Freight_Buy_1_2:Hide();
			Carriage_Freight_Buy_1_1:Hide();
			Carriage_Freight_Buy_1_Info : SetText("")
			Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Buy_2_2:Hide();
			Carriage_Freight_Buy_2_3:Hide();
			Carriage_Freight_Buy_2_Info : SetText("")
			Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Sell_1_1:Hide();
			Carriage_Freight_Sell_1_2:Hide();
--				Carriage_Freight_Sell_1_2:Show();
--				Carriage_Freight_Sell_1_2:SetToolTip("铁，产自大理#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_1_Info : SetText("铁")
			Carriage_Money_Sell_1:Show()
			Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
				
			Carriage_Freight_Sell_2_3:Hide();
			Carriage_Freight_Sell_2_2:Hide();
--				Carriage_Freight_Sell_2_3:Show();
--				Carriage_Freight_Sell_2_3:SetToolTip("米，产自苏州#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_2_Info : SetText("米")
			Carriage_Money_Sell_2:Show();
			Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			Sell_Price = Get_XParam_INT(3);
				
			Carriage_Down:Disable();
			Carriage_Up:Show();
				
		elseif(Get_XParam_INT(5) == 2) then
			
			Carriage_Freight_Buy_1_1:Hide();
			Carriage_Freight_Buy_1_2:Hide();
			Carriage_Freight_Buy_1_Info : SetText("")
			Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Buy_2_3:Hide();
			Carriage_Freight_Buy_2_2:Hide();
			Carriage_Freight_Buy_2_Info : SetText("")
			Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Sell_1_2:Hide();
			Carriage_Freight_Sell_1_1:Hide();
--				Carriage_Freight_Sell_1_1:Show();
--				Carriage_Freight_Sell_1_1:SetToolTip("盐，产自洛阳#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_1_Info : SetText("盐")
			Carriage_Money_Sell_1:Show()
			Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
				
			Carriage_Freight_Sell_2_2:Hide();
			Carriage_Freight_Sell_2_3:Hide();
--				Carriage_Freight_Sell_2_3:Show();
--				Carriage_Freight_Sell_2_3:SetToolTip("米，产自苏州#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_2_Info : SetText("米")
			Carriage_Money_Sell_2:Show();
			Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			Sell_Price = Get_XParam_INT(3);
				
			Carriage_Down:Disable();
			Carriage_Up:Show();
				
		elseif(Get_XParam_INT(5) == 3) then
			
			Carriage_Freight_Buy_2_2:Hide();
			Carriage_Freight_Buy_2_3:Hide();
			Carriage_Freight_Buy_1_Info : SetText("")
			Carriage_Money_Buy_1:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Buy_1_1:Hide();
			Carriage_Freight_Buy_1_2:Hide();
			Carriage_Freight_Buy_2_Info : SetText("")
			Carriage_Money_Buy_2:SetProperty("MoneyNumber", "");
				
			Carriage_Freight_Sell_1_2:Hide();
			Carriage_Freight_Sell_1_1:Hide();
--				Carriage_Freight_Sell_1_1:Show();
--				Carriage_Freight_Sell_1_1:SetToolTip("盐，产自洛阳#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_1_Info : SetText("盐")
			Carriage_Money_Sell_1:Show()
			Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
				
			Carriage_Freight_Sell_2_3:Hide();
			Carriage_Freight_Sell_2_2:Hide();
--				Carriage_Freight_Sell_2_2:Show();
--				Carriage_Freight_Sell_2_2:SetToolTip("铁，产自大理#r点击卖出#r当前价格: #{_MONEY"..Get_XParam_INT(3).."}");
			Carriage_Freight_Sell_2_Info : SetText("铁")
			Carriage_Money_Sell_2:Show();
			Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Get_XParam_INT(3)));
			Sell_Price = Get_XParam_INT(3);
				
			Carriage_Down:Disable();
			Carriage_Up:Show();
		end
	

	end

	Carriage_Info1:SetText("官票余额:")
	Carriage_Balance:SetProperty("MoneyNumber",tostring(Balance));
	--Carriage_Info2:SetText("漕运环数:"..Round.."环")
	Carriage_Info3:SetText("打压市场时机:"..CD_Time_Buy)
	Carriage_Info4:SetText("哄抬市价时机:"..CD_Time_Sell)
		
	Carriage_Freight_Sell_1_1:Hide();
	Carriage_Freight_Sell_1_2:Hide();
	Carriage_Freight_Sell_2_2:Hide();
	Carriage_Freight_Sell_2_3:Hide();

	Refresh_My_Freight();

end


function Carriage_Trade_Update_Price(misIndex,nPrice_UpOrDown)
		local misIndex = mission_index;
		nTransNPC = Get_XParam_INT(4);
		local Price;

		local CD_Time_Sell = Get_XParam_INT(2);
		local CD_Time_Buy = Get_XParam_INT(3);

		if CD_Time_Buy > 0 then
			CD_Time_Buy = CD_Time_Buy / 60;
			if CD_Time_Buy < 1 then
				CD_Time_Buy = 1;
			end
			CD_Time_Buy = tostring(math.floor(CD_Time_Buy)).."分钟后";
			Carriage_Down : Disable();
		else
			CD_Time_Buy = "现在即可"
			Carriage_Down : Enable();
		end
		
		if CD_Time_Sell > 0 then
			CD_Time_Sell = CD_Time_Sell / 60;
			if CD_Time_Sell < 1 then
				CD_Time_Sell = 1;
			end
			CD_Time_Sell = tostring(math.floor(CD_Time_Sell)).."分钟后";
			Carriage_Up : Disable();
		else
			CD_Time_Sell = "现在即可"
			Carriage_Up : Enable();
		end
		if nTransNPC == 1 or nTransNPC == 2 or nTransNPC == 3 then
			Carriage_Info3:SetText("打压市场时机:"..CD_Time_Buy)
			Carriage_Info4:SetText("哄抬市价时机:"..CD_Time_Sell)
			if nPrice_UpOrDown == Price_Up then

				Price = DataPool:GetPlayerMission_Variable(misIndex,Price_Up)
				
				Carriage_Freight_Sell_1_1:SetToolTip("价格:"..Price);
				Carriage_Freight_Sell_1_2:SetToolTip("价格:"..Price);
				Carriage_Freight_Sell_2_2:SetToolTip("价格:"..Price);
				Carriage_Freight_Sell_2_3:SetToolTip("价格:"..Price);
				Carriage_Money_Sell_1:Show()
				Carriage_Money_Sell_2:Show()
				Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Price));
				Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Price));
				
				Sell_Price = Price;

--				if nTransNPC == 1 then
--					Carriage_Freight_Buy_1_1:SetToolTip("盐，产自洛阳#r点击买入#r当前价格:"..Price);
--				elseif nTransNPC == 2 then
--					Carriage_Freight_Buy_1_2:SetToolTip("铁，产自大理#r点击买入#r当前价格:"..Price);
--				elseif nTransNPC == 3 then
--					Carriage_Freight_Buy_2_3:SetToolTip("米，产自苏州#r点击买入#r当前价格:"..Price);
--				end

			elseif nPrice_UpOrDown == Price_Down then
			
				Price = DataPool:GetPlayerMission_Variable(misIndex,Price_Down)
	
				if nTransNPC == 1 then
					Carriage_Freight_Buy_1_1:SetToolTip("盐，产自洛阳#r点击买入#r当前价格: #{_EXCHG"..Price.."}");
				elseif nTransNPC == 2 then
					Carriage_Freight_Buy_1_2:SetToolTip("铁，产自大理#r点击买入#r当前价格: #{_EXCHG"..Price.."}");
				elseif nTransNPC == 3 then
					Carriage_Freight_Buy_2_3:SetToolTip("米，产自苏州#r点击买入#r当前价格: #{_EXCHG"..Price.."}");
				end
				
				if nTransNPC == 3 then
					Carriage_Money_Buy_2:SetProperty("MoneyNumber", tostring(Price));
				else
					Carriage_Money_Buy_1:SetProperty("MoneyNumber", tostring(Price));
				end
				
			end

		elseif nTransNPC == 4 then
			if nPrice_UpOrDown == Price_Up then

				Price = DataPool:GetPlayerMission_Variable(misIndex,0)
				
				Carriage_Freight_Sell_1_1:SetToolTip("价格:"..Price);
				Carriage_Freight_Sell_1_2:SetToolTip("价格:"..Price);
				Carriage_Freight_Sell_2_2:SetToolTip("价格:"..Price);
				Carriage_Freight_Sell_2_3:SetToolTip("价格:"..Price);
				Carriage_Money_Sell_1:Show()
				Carriage_Money_Sell_2:Show()
				Carriage_Money_Sell_1:SetProperty("MoneyNumber", tostring(Price));
				Carriage_Money_Sell_2:SetProperty("MoneyNumber", tostring(Price));
				
				Sell_Price = Price;
				
				Carriage_Info3:SetText("打压市场时机:"..CD_Time_Buy)
				Carriage_Info4:SetText("哄抬市价时机:"..CD_Time_Sell)

			end
		end
		Refresh_My_Freight();
end

function Carriage_Button1_Clicked()

	local UI_ID = Get_XParam_INT(0);
	
--	if UI_ID == 3 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnHaggleDown");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
--	end
	AxTrace(0,1,"button1 clicked")
	
end

function Carriage_Button2_Clicked()

	local UI_ID = Get_XParam_INT(0);
	
--	if UI_ID == 3 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnHaggleUp");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
--	end
	AxTrace(0,1,"button2 clicked")
end

function Carriage_Action_Clicked(nIndex)

	local UI_ID = Get_XParam_INT(0);
	local Send_Msg;
	local Text_Goods = {}
	
	Text_Goods[1] = "盐"
	Text_Goods[2] = "铁"
	Text_Goods[3] = "米"
	
	if nIndex < 1 then
		return ;
	end
	
	if Current == 100 then
		PushDebugMessage("不能通过货舱进行该操作！")
		return;
	end

--	misIndex = Get_XParam_INT(1);
	local misIndex = mission_index;
--	local nTransNPC = DataPool:GetPlayerMission_Variable(misIndex,6)

	AxTrace(0,1,"nTransNPC = "..nTransNPC .." nIndex="..nIndex)
	if nIndex>= 10 then
		if (nIndex / 10) == nTransNPC then
			
			PushDebugMessage("此处不收购"..Text_Goods[nTransNPC]);
			return ;
		end
	end
--以下是一段珍贵的代码，想了好久才搞出来的， 请不要删除。
--	if nTransNPC == 2 then
--			if nIndex == 1 then
--		 		Send_Msg = 2;
--			elseif nIndex == 2 then
--		 		Send_Msg = 1;
--		 	else
--		 		Send_Msg = 3;
--			end
--	elseif nTransNPC == 3 then
--			if nIndex == 1 then
--		 		 Send_Msg = 3;
--			else
--		 		Send_Msg = nIndex - 1;
--			end
--	else
--			Send_Msg = nIndex;
--	end
	if nIndex >=10 then
		Send_Msg = nIndex / 10;
	else
		Send_Msg = nIndex
	end
	AxTrace(0,1,"nTransNPC = "..nTransNPC .." nIndex="..nIndex .." Send_Msg ="..Send_Msg)
--	if UI_ID < 6 and UI_ID > 2 then
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnTrade");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_Parameter(0,Send_Msg);
				Set_XSCRIPT_ParamCount(1);
			Send_XSCRIPT();
--			this:Hide();
--	end
end

function Get_Writ()

	if(IsWindowShow("Shop_Fitting")) then
		CloseWindow("Shop_Fitting", true);
	end

	AxTrace(0,1,"here, current="..Current)
	if Current == 4 then
			AxTrace(0,1,"haha")
			Clear_XSCRIPT();
				Set_XSCRIPT_Function_Name("OnAcceptMission");
				Set_XSCRIPT_ScriptID(311010);
				Set_XSCRIPT_ParamCount(0);
			Send_XSCRIPT();
	end
	
	Carriage_Draw:Hide()
	--this:Hide();
end

function Convert_Writ()
		local Cargo = DataPool:GetPlayerMission_Variable(mission_index,2)
		
		if Cargo > 0 then
			PushDebugMessage("清舱后才能兑换官票。")
			return
		end
--	if Current == 3 then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnRedeemUI");
			Set_XSCRIPT_ScriptID(311010);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();
		
		this:Hide();
			
--	end
	
end

function Refresh_My_Freight()
	local Cargo = DataPool:GetPlayerMission_Variable(mission_index,2)
	local Balance = DataPool:GetPlayerMission_Variable(mission_index,5)
	local Price_Display = DataPool:GetPlayerMission_Variable(mission_index,0)
			
	local Cargo_Standard = 100
	if Cargo < Cargo_Standard then
		Carriage_Freight5:Hide();
	else
		Carriage_Freight5:Show();
		Carriage_Freight5:SetToolTip("盐，产自洛阳#r点击卖出#r当前价格: #{_EXCHG"..Sell_Price.."}");
	end
		
	Cargo_Standard = 10
	if math.mod(Cargo,100) < Cargo_Standard then
		Carriage_Freight6:Hide();
	else
		Carriage_Freight6:Show();
		Carriage_Freight6:SetToolTip("铁，产自大理#r点击卖出#r当前价格: #{_EXCHG"..Sell_Price.."}");
	end
		
	Cargo_Standard = 1
	if math.mod(Cargo,10) < Cargo_Standard then
		Carriage_Freight7:Hide();
	else
		Carriage_Freight7:Show();
		Carriage_Freight7:SetToolTip("米，产自苏州#r点击卖出#r当前价格: #{_EXCHG"..Sell_Price.."}");
	end
	
	Carriage_Info1:SetText("官票余额:")
	Carriage_Balance:SetProperty("MoneyNumber",tostring(Balance));
	local Round = DataPool:GetPlayerMission_DataRound(Caoyun_Circle);

	--Carriage_Info2:SetText("漕运环数:"..Round.."环")
	this:Show();

end


--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Carriage(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Carriage");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Carriage(objCaredId)
	this:CareObject(objCaredId, 0, "Carriage");
	g_Object = -1;

end

function Close_Carriage()
	this:Hide();
	--取消关心
	StopCareObject_Carriage(objCared);
end

function Abandon_Carriage()
	DataPool:Mission_Abnegate_Special_Quest_Popup(311010,"漕运");
	this:Hide();
end

function Close_Carriage_UI()
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Close_Carriage_UI");
		Set_XSCRIPT_ScriptID(311010);
		Set_XSCRIPT_ParamCount(0);
	Send_XSCRIPT();
	this:Hide();
end
