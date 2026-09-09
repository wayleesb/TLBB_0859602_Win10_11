local CU_MONEY			= 1	-- 钱
local CU_GOODBAD		= 2	-- 善恶值
local CU_MORALPOINT	= 3	-- 师德点
local CU_TICKET			= 4 -- 官票钱
local CU_YUANBAO		= 5	-- 元宝
local CU_ZENGDIAN		= 6 -- 赠点
local CU_MENPAI_POINT	= 7 -- 师门贡献度
local CU_MONEYJZ		= 8 -- 交子

local g_pos1;
local g_pos2;
local g_PurpleColor = "#c9107e1";
local g_BlueColor   = "#c00ccff";
local g_YellowColor = "#cfeff95";
local g_GreenColor	= "#c5bc257";
local g_Stars;		

g_nUnlockingTimeNeeded = 259200;

function g_GetUnlockingStr ( nUnlockElapsedTime )
	local nLeftTime = g_nUnlockingTimeNeeded - nUnlockElapsedTime;
	local strLeftTime = "";
		
	if( nLeftTime <= 0 ) then
		strLeftTime = "解锁成功！请重新登录或切换场景正式解锁。";
	else
		nLeftTime = math.ceil( nLeftTime/3600 );
		if( nLeftTime >= 24 ) then
			strLeftTime = ""..math.floor(nLeftTime/24).." 天";
			nLeftTime = math.mod(nLeftTime,24);
		end
		if( nLeftTime > 0 ) then 
			strLeftTime = strLeftTime.." "..nLeftTime.." 小时";					
		end
		
		strLeftTime = strLeftTime.."后正式解锁";
	end
	
	return strLeftTime;
end

function SuperTooltip_PreLoad()
	this:RegisterEvent("SHOW_SUPERTOOLTIP");
	this:RegisterEvent("UPDATE_SUPERTOOLTIP");
end

function SuperTooltip_OnLoad()
	SuperTooltip_StaticPart_Money:SetClippedByParent(0);
	SuperTooltip_StaticPart_Money_JiaoZi:SetClippedByParent(0);
	g_Stars={
				SuperTooltip_StaticPart_Star1,
				SuperTooltip_StaticPart_Star2,
				SuperTooltip_StaticPart_Star3,
				SuperTooltip_StaticPart_Star4,
				SuperTooltip_StaticPart_Star5,
				SuperTooltip_StaticPart_Star6,
				SuperTooltip_StaticPart_Star7,
				SuperTooltip_StaticPart_Star8,
				SuperTooltip_StaticPart_Star9,
		};
	for i=1,9 do
		g_Stars[i]:Hide();
	end;
	--AxTrace(0, 2, "LoadSuperTooltips");
end										

function SuperTooltip_OnEvent(event)

--	SuperTooltip_StaticPart_Money:Hide();
	if(event == "SHOW_SUPERTOOLTIP") then
		if( arg0 == "1" and SuperTooltips:IsPresent()) then
			
			SuperTooltips:SendAskItemInfoMsg();
			if(SuperTooltip_Update()==1) then
				g_pos1, g_pos2 = _SuperTooltip_:PositionSelf(arg2, arg3, arg4, arg5);	
				this:Show();
			end;
			return;
		else
			this:Hide();
			return;

		end
	end
	
	if(event == "UPDATE_SUPERTOOLTIP") then
		if(this:IsVisible() and SuperTooltips:IsPresent()) then
			SuperTooltip_Update();
			_SuperTooltip_:PositionSelf(0, 0, g_pos1, g_pos2);
			return;
		end;
	end
	
end

function SuperTooltip_Update()
		-- 先清空以前显示的文字
		SuperTooltip_ClearText();
		
		local typeDesc = SuperTooltips:GetTypeDesc();
		local nGemHoleCounts = SuperTooltips:GetGemHoleCounts();
		local nMoney1, szMoneyDesc1 = SuperTooltips:GetMoney1();
		local nMoney2, szMoneyDesc2 = SuperTooltips:GetMoney2();
		local szPropertys = SuperTooltips:GetPropertys();
		local szAuthor = SuperTooltips:GetAuthorInfo();
		local szExplain = SuperTooltips:GetExplain();
		
		local unLockingElapsedTime	=SuperTooltips:GetPUnlockElapsedTime();
		local IsProtectd	=SuperTooltips:GetDesc5();
		local nYuanbaotrade = SuperTooltips:GetYuanbaoTradeFlag();
		
		----------------------------------------------------------------------
		--显示静态头
		local toDisplay = "";
		
		if(SuperTooltips:GetTitle()~="" and SuperTooltips:GetIconName()~="")then
			toDisplay = toDisplay .."SuperTooltip_PageHeader";
		end
		
		--剩余解锁时间
		if( IsProtectd == "1" and unLockingElapsedTime ~= 0) then
			toDisplay = toDisplay .. ";SuperTooltip_UnlockingTimePart";
		end
		
		
		--加上类型描述
		if( typeDesc ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip_ShortDesc";
		end
		
		--元宝交易
		if (nYuanbaotrade == 1) then
			toDisplay = toDisplay .. ";SuperTooltip_StaticPart_Yuanbaojiaoyi";
			SuperTooltip_StaticPart_Yuanbaojiaoyi:SetText("#c00ff00元宝交易");
		end
		
		--宝石部分
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0 ) then 
			toDisplay = toDisplay .. ";SuperTooltip_GemPart";
		end
		--金钱1
		if( nMoney1 ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip_MoneyPart";
		end

		--金钱2
		if(nMoney2 ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip_MoneyPart_2";
		end

		--属性
		if(szPropertys ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip_Property";
		end

		--作者
		if(szAuthor ~= nil) then 
			toDisplay = toDisplay .. ";SuperTooltip_Manufacturer_Frame";
		end

		--详细解释
		toDisplay = toDisplay .. ";SuperTooltip_Explain";

		--显示组件内容
		if(toDisplay=="") then
			this:Hide();
			return 0;
		end;
		AxTrace( 8,0,toDisplay );
		_SuperTooltip_:SetProperty("PageElements",  toDisplay);
		
		----------------------------------------------------------------------
		--显示新的内容
		SuperTooltip_StaticPart_Title:SetText(SuperTooltips:GetTitle());
		SuperTooltip_StaticPart_Item1:SetText(SuperTooltips:GetDesc1());
		SuperTooltip_StaticPart_Item2:SetText(SuperTooltips:GetDesc2());
		SuperTooltip_StaticPart_Item3:SetText(SuperTooltips:GetDesc3());
		local StrongLevel	=SuperTooltips:GetDesc4();
		
		if(StrongLevel~="" and tonumber(StrongLevel)>0) then
			
			SuperTooltip_StaticPart_Item4:SetText("#c0FFFFF强化: +"..SuperTooltips:GetDesc4());
		end;
		--SuperTooltip_StaticPart_Item5:SetText(SuperTooltips:GetDesc5());
		SuperTooltip_StaticPart_Icon:SetImage(SuperTooltips:GetIconName());
		SuperTooltip_ShortDesc_Text:SetText(typeDesc);
		
		
		if (IsProtectd == "1" and unLockingElapsedTime ~= 0) then		
			local strLeftTime = g_GetUnlockingStr(unLockingElapsedTime);		
			SuperTooltip_UnlockingTimePart:SetText("#b#cFFFF00"..strLeftTime);
			SuperTooltip_StaticPart_Icon_Protected : SetProperty("Image","set:CommonFrame6 image:NewLock");
		else
			SuperTooltip_UnlockingTimePart:SetText("");
			SuperTooltip_StaticPart_Icon_Protected : SetProperty("Image","set:UIIcons image:Icon_Lock");
		end

		--tongxi modify 显示星星
		--AxTrace( 5,0,StrongLevel );
		local qual =SuperTooltips:GetEquipQual();
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
			SuperTooltip_StaticPart_Icon_Protected:Show();
		end;
		--modify end
		if( type(nGemHoleCounts) == "number" and nGemHoleCounts>0) then
			AxTrace(5,1,"nGemHoleCounts="..nGemHoleCounts)
			if(nGemHoleCounts > 0) then 
				SuperTooltip_StaticPart_Gem1:Show();
			end
			
			if(nGemHoleCounts > 1) then 
				SuperTooltip_StaticPart_Gem2:Show();
			end
			
			if(nGemHoleCounts > 2) then 
				SuperTooltip_StaticPart_Gem3:Show();
			end
			
			if(nGemHoleCounts > 3) then 
				SuperTooltip_StaticPart_Gem4:Show();
			end
			
			
			local gemIcon = SuperTooltips:GetGemIcon1();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem1:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon2();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem2:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon3();
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem3:SetProperty("ShortImage", gemIcon);
			end
			
			gemIcon = SuperTooltips:GetGemIcon4();
			
			AxTrace(5,5,"gemIcon="..gemIcon)
			if(gemIcon ~= "") then
				SuperTooltip_StaticPart_Gem4:SetProperty("ShortImage", gemIcon);
			end
			
		end
		if(nMoney1 ~= nil)  then
			SuperTooltip_StaticPart_Money_Text:SetText(szMoneyDesc1);
			SetupMoneyPart(1,nMoney1);
			
		end		
		if(nMoney2 ~= nil)  then
			SuperTooltip_StaticPart_Money_Text_2:SetText(szMoneyDesc2);
			SetupMoneyPart(2,nMoney2);
		end
		
		if( szPropertys ~= nil) then
			SuperTooltip_Property:SetText(szPropertys);
		end
		
		if(szAuthor ~= nil) then
			SuperTooltip_Manufacturer:SetText(szAuthor);
		end
		
		SuperTooltip_Explain:SetText(szExplain);
		
		AxTrace( 8,0,"Show tooltip  "..szExplain);

		return 1;
		
end

-------------------------------------------------------------------------------------------------------------------------------
--
-- 清空显示文本
--
function SuperTooltip_ClearText()
		SuperTooltip_StaticPart_Title:SetText("");
		SuperTooltip_StaticPart_Item1:SetText("");
		SuperTooltip_StaticPart_Item2:SetText("");
		SuperTooltip_StaticPart_Item3:SetText("");
		SuperTooltip_StaticPart_Item4:SetText("");
		local starNum=9
		for i=1,starNum do
			g_Stars[i]:Hide();
		end;
		SuperTooltip_StaticPart_Gem1:SetImage("");
		SuperTooltip_StaticPart_Gem2:SetImage("");
		SuperTooltip_StaticPart_Gem3:SetImage("");
		SuperTooltip_StaticPart_Gem4:SetImage("");
		SuperTooltip_StaticPart_Gem1:Hide();
		SuperTooltip_StaticPart_Gem2:Hide()
		SuperTooltip_StaticPart_Gem3:Hide()
		SuperTooltip_StaticPart_Gem4:Hide()
		SuperTooltip_Explain:SetText("");
		SuperTooltip_Property:SetText("");
		SuperTooltip_Manufacturer:SetText("");
		SuperTooltip_StaticPart_Icon_Protected:Hide();
end

function SetupMoneyPart(type,nPrice)
	local StaticPart_GB_Ctl;
	local StaticPart_Money_Ctl;
		--使用什么作为货币
	local nUnit =  SuperTooltips:GetMoney1Type();
	if(type==1)then
		StaticPart_GB_Ctl = SuperTooltip_StaticPart_GB;
		local isShowJiaoZi = SuperTooltips:GetIsShowJiaoZi();
		if ( CU_MONEYJZ == nUnit ) then
			isShowJiaoZi = 1;
		end
		if (isShowJiaoZi == 1) then
			SuperTooltip_StaticPart_Money:Hide();
			StaticPart_Money_Ctl = SuperTooltip_StaticPart_Money_JiaoZi;
		else
			SuperTooltip_StaticPart_Money_JiaoZi:Hide()
			StaticPart_Money_Ctl = SuperTooltip_StaticPart_Money;
		end
	else
		StaticPart_GB_Ctl = SuperTooltip_StaticPart_GB_2;
		StaticPart_Money_Ctl = SuperTooltip_StaticPart_Money_2;
	end

	if(nUnit==nil)then
		nUnit = CU_MONEY;
	end;
	if(CU_MONEY	== nUnit or CU_TICKET == nUnit or CU_MONEYJZ == nUnit)       then      --钱，官票钱, 交子
			StaticPart_GB_Ctl:Hide()
			StaticPart_Money_Ctl:Show();
			StaticPart_Money_Ctl:SetProperty("MoneyNumber", tostring(nPrice));

	elseif(CU_GOODBAD == nUnit) then			--善恶值
			
			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("善恶值:" .. tostring(nPrice) .. " 点")


	elseif(CU_MORALPOINT == nUnit)  then	--师德点

			StaticPart_GB_Ctl:Show()
			SuperTooltip_StaticPart_Money:Hide();
			StaticPart_GB_Ctl:SetText("师德点:" .. tostring(nPrice) .. " 点")

	elseif(CU_YUANBAO == nUnit) then	--元宝

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("元宝:" .. tostring(nPrice))

	elseif(CU_ZENGDIAN == nUnit) then	--赠点

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("赠点:" .. tostring(nPrice))

	elseif(CU_MENPAI_POINT == nUnit) then	--师门贡献度

			StaticPart_GB_Ctl:Show()
			StaticPart_Money_Ctl:Hide();
			StaticPart_GB_Ctl:SetText("门派贡献度:" .. tostring(nPrice))

	end	
	
end;