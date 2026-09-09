
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


--===============================================
-- OnLoad
--===============================================
function PS_CreateShop_PreLoad()
	this:RegisterEvent("PS_OPEN_CREATESHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_CREATESHOP");
	
end

function PS_CreateShop_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_CreateShop_OnEvent(event)
	if ( event == "PS_OPEN_CREATESHOP" ) then
		this:Show();
		-- objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_CreateShop");

		PS_CreateShop_InputShopName:SetProperty("DefaultEditBox", "True");
		
		--商业指数
		local szCommercialFactor = PlayerShop:GetCommercialFactor();
		PS_CreateShop_TradeIndex:SetText("商业指数:" .. szCommercialFactor);

		--当前能开的店
		local nType = PlayerShop:GetCanOpenShopType();
		
		if(nType == 1)     then
			--只能开物品店
			PS_CreateShop_Text3:Show();
			PS_CreateShop_Text4:Hide();
			PS_CreateShop_Prop:Show();
			PS_CreateShop_Pet:Hide();
			PS_CreateShop_Prop:SetCheck(1);
			
		elseif(nType == 2) then
			--只能开宠物店
			PS_CreateShop_Text3:Hide();
			PS_CreateShop_Text4:Show();
			PS_CreateShop_Prop:Hide();
			PS_CreateShop_Pet:Show();
			PS_CreateShop_Pet:SetCheck(1);
			
		elseif(nType == 3) then
			--两种店都能开
			PS_CreateShop_Text3:Show();
			PS_CreateShop_Text4:Show();
			PS_CreateShop_Prop:Show();
			PS_CreateShop_Pet:Show();
			PS_CreateShop_Prop:SetCheck(1);
			PS_CreateShop_Pet:SetCheck(0);
		end

		PS_CreateShop_Demand_Text:SetText("#cff0000开张新店铺需要一本掌柜要诀#r#cFFF263当前的商业指数为".. szCommercialFactor ..",如果开一间一柜台的店铺需要缴纳的费用如下。");
		
		local nOpenNeedMoney = PlayerShop:GetMoney("open","self");
		PS_CreateShop_DemandMoney:SetProperty("MoneyNumber", tostring(nOpenNeedMoney));
	
		PS_CreateShop_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));

		PS_CreateShop_InputShopName:SetText("");

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_CreateShop");
		end
		
	elseif ( event == "PS_CLOSE_CREATESHOP" )   then
		this:Hide();
		--取消关心
		this:CareObject(objCared, 0, "PS_CreateShop");
		
	end

end

--===============================================
-- Refuse
--===============================================
function PS_CreateShopRefuse_Clicked()
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_CreateShop");

end

--===============================================
-- Accept
--===============================================
function PS_CreateShopAccept_Clicked()

	local szName = PS_CreateShop_InputShopName:GetText();
	local bItem = PS_CreateShop_Prop:GetCheck();
	local bPet  = PS_CreateShop_Pet:GetCheck();

	local temp;
	if  ( bItem == 1 )  then
		temp = 1;
	else
		temp = 2;
	end

	if  (bItem == bPet)  then
		temp = 0 ;
	end

	PlayerShop:CreateShop(szName,temp);
	
end

--===============================================
-- OnHiden
--===============================================
function PS_CreateShop_OnHiden()
		PS_CreateShop_InputShopName:SetProperty("DefaultEditBox", "False");
	
end