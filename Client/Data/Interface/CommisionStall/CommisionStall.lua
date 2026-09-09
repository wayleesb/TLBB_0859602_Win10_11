local g_Type = 0;
local g_CurSel = -1;
local Need_Money = 0;
local g_grade = -1;
local Tab_Ctl = {};
local STALL_BUTTON = {};
local g_ABCount = 20;
local CanPush =1;
local objCared = -1;
local g_objCared = -1;
local g_lastPushed = 0;
function CommisionStall_PreLoad()

	this:RegisterEvent("OPEN_STALL_COMMISION");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UPDATE_YUANBAO");	
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("COMMISION_BUY_CONFRIMED");	--购买确认框的确认消息
	
end

function CommisionStall_OnLoad()
	Tab_Ctl[1] = CommisionStall_ItemType1;
	Tab_Ctl[2] = CommisionStall_ItemType2;
	Tab_Ctl[3] = CommisionStall_ItemType3;
	
	STALL_BUTTON[1] 	= CommisionStall_Item1;
	STALL_BUTTON[2] 	= CommisionStall_Item2;
	STALL_BUTTON[3] 	= CommisionStall_Item3;
	STALL_BUTTON[4] 	= CommisionStall_Item4;
	STALL_BUTTON[5] 	= CommisionStall_Item5;
	STALL_BUTTON[6] 	= CommisionStall_Item6;
	STALL_BUTTON[7] 	= CommisionStall_Item7;
	STALL_BUTTON[8] 	= CommisionStall_Item8;
	STALL_BUTTON[9] 	= CommisionStall_Item9;
	STALL_BUTTON[10] 	= CommisionStall_Item10;
	STALL_BUTTON[11] 	= CommisionStall_Item11;
	STALL_BUTTON[12] 	= CommisionStall_Item12;
	STALL_BUTTON[13] 	= CommisionStall_Item13;
	STALL_BUTTON[14]	= CommisionStall_Item14;
	STALL_BUTTON[15]	= CommisionStall_Item15;
	STALL_BUTTON[16]	= CommisionStall_Item16;
	STALL_BUTTON[17]	= CommisionStall_Item17;
	STALL_BUTTON[18]	= CommisionStall_Item18;
	STALL_BUTTON[19]	= CommisionStall_Item19;
	STALL_BUTTON[20]	= CommisionStall_Item20;
	--暂时屏蔽拖动功能
	for i=1 ,g_ABCount     do
		STALL_BUTTON[i]:SetProperty("DraggingEnabled","False");
	end
	CommisionStall_ItemType1:SetProperty("CheckMode", "1");
	CommisionStall_ItemType2:SetProperty("CheckMode", "1");
	CommisionStall_ItemType3:SetProperty("CheckMode", "1");

end

--===============================================
-- OnEvent()
--===============================================
function CommisionStall_OnEvent(event)
	if(event == "OPEN_STALL_COMMISION") then
		CommisionShop:CloseBuyConfrim();
		if(tonumber(arg0)~=nil) then
			g_grad = tonumber(arg0)
			g_objCared = tonumber(arg1)
			if(g_grad<=2)then
				g_Type = 1;
			else
				g_Type = 2;
			end
			g_Type = tonumber(g_Type);
			CommisionStall_InitDlg(g_Type);
			this:Show();
			objCared = CommisionShop:GetNpcId();
			this:CareObject(objCared, 1, "CommisionStall");
			CanPush = 1;
		end
	end
	if (event == "UNIT_MONEY") then
		if(g_Type == 1)then
			CommisionStall_Cash_Money:SetProperty("MoneyNumber",tostring(Player:GetData("MONEY")));			
		end
	end
	if (event == "UPDATE_YUANBAO") then
		if(g_Type == 2)then
			CommisionStall_Cash_Yuanbao:SetText("元宝:"..tostring(Player:GetData("YUANBAO")).." ");
		end
	end
	if (event == "OPEN_EXCHANGE_FRAME") then
		CommisionStall_Close_Clicked();
	end
	if (event == "COMMISION_BUY_CONFRIMED") then
		CommisionStall_FinishBuy();
	end

end

function CommisionStall_InitDlg(type)
	CommisionStall_ItemType1:Enable();
	CommisionStall_ItemType2:Enable();
	CommisionStall_ItemType3:Enable();
	if(type == 1)then
		--元宝商店
		CommisionStall_Name_Text:SetText("请选择您想购买的元宝类型");
		CommisionStall_ItemType1:SetText("50点");
		CommisionStall_ItemType2:SetText("200点");
		CommisionStall_ItemType3:SetText("500点");
		CommisionStall_Cash:SetText("拥有金钱");
		CommisionStall_TargetPrice_Yuanbao:Hide();
		CommisionStall_TargetPrice_Money:Show();
		CommisionStall_Cash_Yuanbao:Hide();
		CommisionStall_Cash_Money:Show();
		Need_Money = 0;
		CommisionStall_TargetPrice_Money:SetProperty("MoneyNumber","0");	 
		CommisionStall_Cash_Money:SetProperty("MoneyNumber",tostring(Player:GetData("MONEY")));	 

	else
		
		
		CommisionStall_Name_Text:SetText("请选择您想购买的金票类型");
		CommisionStall_ItemType1:SetText("10金");
		CommisionStall_ItemType2:SetText("50金");
		CommisionStall_ItemType3:SetText("150金");
		CommisionStall_Cash:SetText("拥有元宝");
		CommisionStall_TargetPrice_Yuanbao:Show();
		CommisionStall_TargetPrice_Money:Hide();
		CommisionStall_Cash_Yuanbao:Show();
		CommisionStall_Cash_Money:Hide();
		Need_Money = 0;
		CommisionStall_Cash_Yuanbao:SetText("元宝:"..tostring(Player:GetData("YUANBAO")).." ");
		--CommisionStall_TargetPrice_Yuanbao:SetText("元宝:"..tostring(Player:GetData("YUANBAO")));
		
	end
	g_CurSel = -1;
	CommisionStall_TargetPrice_Yuanbao:SetText("");
	CommisionStall_TargetPrice_Money:SetProperty("MoneyNumber",tonumber(0));
	Tab_Ctl[g_grad+1-(g_Type-1)*3]:SetCheck(1);
	g_lastPushed = g_grad+1-(g_Type-1)*3;
	for i = 1,g_ABCount do
		local theAction = CommisionShop:EnumAction(i-1);
		if theAction and theAction:GetID() ~= 0 then
			STALL_BUTTON[i]:SetActionItem(theAction:GetID());
		else
			STALL_BUTTON[i]:SetActionItem(-1);
		end
	end
end

function CommisionStall_Buy_Clicked()
	if(g_Type == 0)then
		return
	end
	if(g_CurSel<0 or g_CurSel>=20)then
		PushDebugMessage("请选择要购买的物品！")
		return
	end

	local price = CommisionShop:EnumItem(tonumber(g_Type-1),tonumber(g_CurSel),"price");
	local name = CommisionShop:EnumItem(tonumber(g_Type-1),tonumber(g_CurSel),"name");
	local strPrice
	if(g_Type == 1)then
		--元宝店
		strPrice = "#{_MONEY"..tostring(price).."}"
	else
		strPrice = tostring(price).."点元宝"
	end
	
	--不直接购买....而是打开购买确认框....
	CommisionShop:OpenBuyConfrim( name, strPrice );

end

function CommisionStall_FinishBuy()

	if(g_Type == 0)then
		return
	end
	if(g_CurSel<0 or g_CurSel>=20)then
		PushDebugMessage("请选择要购买的物品！")
		return
	end
	local price = CommisionShop:EnumItem(tonumber(g_Type-1),tonumber(g_CurSel),"price");
	if(g_Type == 1)then
		--元宝店
		if(Player:GetData("MONEY") < tonumber(price))then
			PushDebugMessage("金钱不足！")
			return
		end
	else
		if(Player:GetData("YUANBAO") <  tonumber(price))then
			PushDebugMessage("元宝不足！")
			return
		end
	end
	
	local Sailer = CommisionShop:EnumItem(tonumber(g_Type-1),tonumber(g_CurSel),"serial");
	--判断ok，buy
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("Buy");
		Set_XSCRIPT_ScriptID(800116);
		Set_XSCRIPT_Parameter(0,tonumber(g_objCared));
		Set_XSCRIPT_Parameter(1,tonumber(g_grad));
		Set_XSCRIPT_Parameter(2,tonumber(Sailer));
		Set_XSCRIPT_ParamCount(3);
	Send_XSCRIPT();
end

function CommisionStall_Close_Clicked()
	--关闭购买确认框
	CommisionShop:CloseBuyConfrim();
	this:Hide();
end

function CommisionStall_ChangeTabIndex(idx)
	if(g_lastPushed==idx)then
		return
	end
	
	CommisionShop:CloseBuyConfrim();
	
	g_lastPushed = idx
	if(CanPush==1)then
		local _grad = idx-1 + (g_Type-1)*3;
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OpenShop");
			Set_XSCRIPT_ScriptID(800116);
			Set_XSCRIPT_Parameter(0,tonumber(g_objCared));
			Set_XSCRIPT_Parameter(1,tonumber(_grad));
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
	end
	CanPush = 0;
	--DisableTabs();
end

function DisableTabs()
	CommisionStall_ItemType1:Disable();
	CommisionStall_ItemType2:Disable();
	CommisionStall_ItemType3:Disable();
end

function CommisionStall_Item_Click(idx)
	if(idx<1 or idx>g_ABCount) then
		return;
	end
	
	CommisionShop:CloseBuyConfrim();
	
	if(g_CurSel>=0 and g_CurSel<g_ABCount and g_CurSel~=idx-1)then
		STALL_BUTTON[g_CurSel+1]:SetPushed(0);
	end
	
	--检测鼠标点击的格子是否有物品....
	local theAction = CommisionShop:EnumAction(idx-1);
	if not theAction or theAction:GetID() == 0 then
		g_CurSel = -1;
		return;
	end
	
	g_CurSel = idx - 1;
	STALL_BUTTON[idx]:SetPushed(1);
	local price = CommisionShop:EnumItem(tonumber(g_Type-1),tonumber(g_CurSel),"price");
	if(tonumber(g_Type) == 2)then
		
		CommisionStall_TargetPrice_Yuanbao:SetText("元宝:"..price.." ");
	else
		CommisionStall_TargetPrice_Money:SetProperty("MoneyNumber",tonumber(price));
	end
end