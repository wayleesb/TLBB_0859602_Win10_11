
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";

local g_NeedClickHide = 0;
local g_FirstShow = 1;

function SuperTooltip2_PreLoad()
	this:RegisterEvent("SHOW_SUPERTOOLTIP2");
end

function SuperTooltip2_OnLoad()
	SuperTooltip2_StaticPart_Money:SetClippedByParent(0);
		g_Stars={
				SuperTooltip2_StaticPart_Star1,
				SuperTooltip2_StaticPart_Star2,
				SuperTooltip2_StaticPart_Star3,
				SuperTooltip2_StaticPart_Star4,
				SuperTooltip2_StaticPart_Star5,
				SuperTooltip2_StaticPart_Star6,
				SuperTooltip2_StaticPart_Star7,
				SuperTooltip2_StaticPart_Star8,
				SuperTooltip2_StaticPart_Star9,
		};
	for i=1,9 do
		g_Stars[i]:Hide();
	end;
	--AxTrace(0, 2, "LoadSuperTooltips");
end										

function SuperTooltip2_OnEvent(event)

--	SuperTooltip2_StaticPart_Money:Hide();
	if(event == "SHOW_SUPERTOOLTIP2") then
		if( arg0 == "1" and SuperTooltips2:IsPresent()) then
			
			SuperTooltips2:SendAskItemInfoMsg();
			SuperTooltip2_Update();
			_SuperTooltip2_:PositionSelf(0, 0, 1, 1);
			local rH = _SuperTooltip2_:GetProperty("AbsoluteHeight");
			SuperTooltip2_Frame:SetProperty("AbsoluteHeight", tostring(rH+5.0));

			if(g_FirstShow == 1) then 
				SuperTooltip2_Frame:CenterWindow();
				g_FirstShow = 0;
			end
			
			this:Show();
			return;
		else
			this:Hide();
			return;
		end
	end
	
	this:Hide();	
end

function SuperTooltip2_Update()
		g_NeedClickHide = 0;
		-- 先清空以前显示的文字
		SuperTooltip2_ClearText();
		
		if(SuperTooltips2:IsTransferItem()) then
			g_NeedClickHide = 1;
		end
		
		local typeDesc = SuperTooltips2:GetTypeDesc();
		local nGemHoleCounts = SuperTooltips2:GetGemHoleCounts();
		local nMoney1, szMoneyDesc1 = SuperTooltips2:GetMoney1();
		local nMoney2, szMoneyDesc2 = SuperTooltips2:GetMoney2();
		local szPropertys = SuperTooltips2:GetPropertys();
		local szAuthor = SuperTooltips2:GetAuthorInfo();
		local szExplain = SuperTooltips2:GetExplain();
		local nYuanbaotrade = SuperTooltips2:GetYuanbaoTradeFlag();
		
		----------------------------------------------------------------------
		--显示静态头
		local toDisplay = "SuperTooltip2_PageHeader";
		
		--加上类型描述
		if( typeDesc ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_ShortDesc";
		end
		
		--宝石部分
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
			toDisplay = toDisplay .. ";SuperTooltip2_GemPart";
		end
		
		--元宝交易
		if (nYuanbaotrade == 1) then
			toDisplay = toDisplay .. ";SuperTooltip2_StaticPart_Yuanbaojiaoyi";
			SuperTooltip2_StaticPart_Yuanbaojiaoyi:SetText("#c00ff00元宝交易");
		end

		--金钱1
		if( nMoney1 ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_MoneyPart";
		end

		--金钱2
		if(nMoney2 ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_MoneyPart2";
		end

		--属性
		if(szPropertys ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_Property";
		end

		--作者
		if(szAuthor ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip2_Manufacturer_Frame";
		end

		--详细解释
		toDisplay = toDisplay .. ";SuperTooltip2_Explain";

		--显示组件内容
		_SuperTooltip2_:SetProperty("PageElements", toDisplay);
		
		----------------------------------------------------------------------
		--显示新的内容
		SuperTooltip2_StaticPart_Title:SetText(SuperTooltips2:GetTitle());
		SuperTooltip2_StaticPart_Item1:SetText(SuperTooltips2:GetDesc1());
		SuperTooltip2_StaticPart_Item2:SetText(SuperTooltips2:GetDesc2());
		SuperTooltip2_StaticPart_Item3:SetText(SuperTooltips2:GetDesc3());
		--SuperTooltip2_StaticPart_Item4:SetText(SuperTooltips2:GetDesc4());
		local StrongLevel	=SuperTooltips2:GetDesc4();
		local IsProtectd	=SuperTooltips2:GetDesc5();
		if(StrongLevel~="" and tonumber(StrongLevel)>0) then
			
			SuperTooltip2_StaticPart_Item4:SetText("#c0FFFFF强化: +"..SuperTooltips2:GetDesc4());
		end;
		--SuperTooltip_StaticPart_Item5:SetText(SuperTooltips:GetDesc5());
		SuperTooltip2_StaticPart_Icon:SetImage(SuperTooltips2:GetIconName());
		SuperTooltip2_ShortDesc_Text:SetText(typeDesc);

		--tongxi modify 显示星星		
		local qual =SuperTooltips2:GetEquipQual();
		if(type(qual) == "number" and tonumber(qual)>0)then
			local starNum	=	tonumber(qual);
			if(starNum<10) then
				for i=1,starNum do
					--AxTrace( 5,0,StrongLevel.."hehe" );
					if starNum <=4 then
						g_Stars[i]:SetProperty("Animate", "Animate_StarNoFlash");
					else
						g_Stars[i]:SetProperty("Animate", "Animate_Star");
					end
					g_Stars[i]:Show();
				end;
				for i=starNum+1, 9 do
					g_Stars[i]:SetProperty("Animate", "Animate_StarDark");
					g_Stars[i]:Show();
				end
			end;
		end;
		if(IsProtectd=="1") then
			SuperTooltip2_StaticPart_Icon_Protected:Show();
		end;
		--modify end
		
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0) then
			if(nGemHoleCounts > 0) then 
				SuperTooltip2_StaticPart_Gem1:Show();
			end
			
			if(nGemHoleCounts > 1) then 
				SuperTooltip2_StaticPart_Gem2:Show();
			end
			
			if(nGemHoleCounts > 2) then 
				SuperTooltip2_StaticPart_Gem3:Show();
			end
		
			if(nGemHoleCounts > 3) then 
				SuperTooltip2_StaticPart_Gem4:Show();
			end
			
			local gemIcon = SuperTooltips2:GetGemIcon1();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem1:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon2();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem2:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon3();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem3:SetImage(gemIcon);
			end
			
			gemIcon = SuperTooltips2:GetGemIcon4();
			if(gemIcon ~= "") then
				SuperTooltip2_StaticPart_Gem4:SetImage(gemIcon);
			end
			
		end
		
		if(nMoney1 ~= nil)  then
			SuperTooltip2_StaticPart_Money_Text:SetText(szMoneyDesc1);
			SuperTooltip2_StaticPart_Money:SetProperty("MoneyNumber", tostring(nMoney1));
		end
		
		if(nMoney2 ~= nil)  then
			SuperTooltip2_StaticPart_Money_Text_2:SetText(szMoneyDesc2);
			SuperTooltip2_StaticPart_Money_2:SetProperty("MoneyNumber", tostring(nMoney2));
		end
		
		if( szPropertys ~= nil) then
			SuperTooltip2_Property:SetText(szPropertys);
		end
		
		if(szAuthor ~= nil) then
			SuperTooltip2_Manufacturer:SetText(szAuthor);
		end

		SuperTooltip2_Explain:SetText(szExplain);
		
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function SuperTooltip2_ClearText()
		SuperTooltip2_StaticPart_Title:SetText("");
		SuperTooltip2_StaticPart_Item1:SetText("");
		SuperTooltip2_StaticPart_Item2:SetText("");
		SuperTooltip2_StaticPart_Item3:SetText("");
		SuperTooltip2_StaticPart_Item4:SetText("");
		SuperTooltip2_StaticPart_Gem1:SetImage("");
		SuperTooltip2_StaticPart_Gem2:SetImage("");
		SuperTooltip2_StaticPart_Gem3:SetImage("");
		SuperTooltip2_StaticPart_Gem4:SetImage("");
		SuperTooltip2_StaticPart_Gem1:Hide()
		SuperTooltip2_StaticPart_Gem2:Hide();
		SuperTooltip2_StaticPart_Gem3:Hide();
		SuperTooltip2_StaticPart_Gem4:Hide();
		
		SuperTooltip2_Explain:SetText("");
		SuperTooltip2_Property:SetText("");
		SuperTooltip2_Manufacturer:SetText("");
		SuperTooltip2_StaticPart_Icon_Protected:Hide();
		local starNum=9
		for i=1,starNum do
			g_Stars[i]:Hide();
		end;
end

function SuperTooltip2_LClick()
	if( 1 == g_NeedClickHide and this:IsVisible()) then
		g_NeedClickHide = 0;
		this:Hide();
	end
end