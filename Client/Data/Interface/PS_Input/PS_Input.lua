
local g_MoneyType=-1;

local PS_IMMITBASE			= 1;
local PS_IMMIT					= 2;
local PS_DRAW						= 3;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Input_PreLoad()
	this:RegisterEvent("PS_INPUT_MONEY");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_SHOP_MAG");
end

--===============================================
-- OnLoad
--===============================================
function PS_Input_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_Input_OnEvent(event)

	if(event == "PS_INPUT_MONEY") then
		--玩家商店冲入本金
		if (arg0 == "immitbase") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMITBASE;
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("base","self");

			PS_Input_DragTitle:SetText("#gFF0FA0充入本金");
			PS_Input_Accept:SetText("充入");
			PS_Input_Warning:SetText("充入本金最低数为10#-02#r当前本金基础为".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(nBaseMoney));
			PS_Input_Text1:SetText("请充入本金：");
			PS_Input_Text2:SetText("当前本金：");
			
			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			
		--玩家商店冲入
		elseif (arg0 == "immit") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_IMMIT;
			PS_Input_DragTitle:SetText("#gFF0FA0充入盈利资金");
			PS_Input_Accept:SetText("充入");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
			
			local nBaseMoney;
			local nMoney1;
			local nMoney2;
			local nMoney3;
			nBaseMoney,nMoney1,nMoney2,nMoney3 = PlayerShop:GetMoney("input_profit","self");
			local szCom = PlayerShop:GetCommercialFactor()

			local szInfo = "充入盈利资金最低数不得小于本金基础值：本金基础：30" .. "#-02" .. "*商业指数*柜台数，当前的商业指数为".. szCom .. "，你至少要充入".. tostring(nMoney1) .."#-02" .. tostring(nMoney2) .. "#-03" .. tostring(nMoney3) .. "#-04";
			PS_Input_Warning:SetText(szInfo);
			
			PS_Input_Text1:SetText("请充入盈利资金：");
			PS_Input_Text2:SetText("当前盈利资金：");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");

		--玩家商店取出
		elseif (arg0 == "draw") then
			this:Show();
			objCared = PlayerShop:GetNpcId();
			this:CareObject(objCared, 1, "PS_Input");	

			g_nSaveOrGetMoney = PS_DRAW;
			PS_Input_DragTitle:SetText("#gFF0FA0支取盈利资金");
			PS_Input_Accept:SetText("支取");

			PS_Input_Warning:SetText("#{SHOPTIPS_090205_2}");--[tx44221]

			PS_Input_Text1:SetText("要支取盈利资金：");
			PS_Input_Text2:SetText("当前盈利资金：");

			PS_Input_Gold:SetProperty("DefaultEditBox", "True");
			PS_Input_CurrentlyPrincipal:SetProperty("MoneyNumber", tostring(PlayerShop:GetMoney("profit","self")));
		end		
		PS_Input_Frame:SetForce();
		PS_Input_Gold:SetText("");
		PS_Input_Silver:SetText("");
		PS_Input_CopperCoin:SetText("");
		
	elseif ( event == "OBJECT_CARED_EVENT" )   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_Input");
		end	
	
	elseif( event == "PS_CLOSE_SHOP_MAG" )    then
	
		if( this:IsVisible() )   then
			this:Hide();
			--取消关心
			this:CareObject(objCared, 0, "PS_Input");
		end
		
	end	
	
end

--===============================================
-- Accept
--===============================================
function PS_Input_Accept_Clicked()
	local szGold = PS_Input_Gold:GetText();
	local szSilver = PS_Input_Silver:GetText();
	local szCopperCoin = PS_Input_CopperCoin:GetText();
	
	--在程序里头再检测输入字符的有效性和数值
	local bAvailability,nMoney = Bank:GetInputMoney(szGold,szSilver,szCopperCoin);
	if(bAvailability == true) then
	
		if( g_nSaveOrGetMoney == PS_IMMITBASE ) then
			--充入本金
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immitbase",nMoney)
			if( szResult == "ok" )   then
				this:Hide();
				--取消关心
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nMoney);
				
			elseif(szResult == "few" )  then
				

			elseif(szResult == "more" )  then
				this:Hide();
				--取消关心
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immitbase",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_IMMIT ) then
			--充入
			local szResult;
			local nResult;
			szResult,nResult= PlayerShop:DealMoney("immit",nMoney);
			
			if( szResult == "ok" )   then
				this:Hide();
				--取消关心
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nMoney);
			
			elseif(szResult == "few" )  then
				
			
			elseif(szResult == "more" )  then
				this:Hide();
				--取消关心
				this:CareObject(objCared, 0, "PS_Input");

				PlayerShop:ApplyMoney("immit",nResult);

			end
		
		elseif( g_nSaveOrGetMoney == PS_DRAW ) then
			--支取
			PlayerShop:ApplyMoney("draw_ok",nMoney);
			this:Hide();
			--取消关心
			this:CareObject(objCared, 0, "PS_Input");
			
		end
	end
end

--===============================================
-- Cancel
--===============================================
function PS_Input_Cancel_Clicked()
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Input");
end


--===============================================
-- OnHiden
--===============================================
function PS_Input_Frame_OnHiden()
	PS_Input_Gold:SetProperty("DefaultEditBox", "False");
	PS_Input_Silver:SetProperty("DefaultEditBox", "False");
	PS_Input_CopperCoin:SetProperty("DefaultEditBox", "False");
end

