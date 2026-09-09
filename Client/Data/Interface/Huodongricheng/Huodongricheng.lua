local	campaign_today = 0	--当天所有活动
local	campaign_curDaily = 1	--目前日常活动
local	campaign_other	=2	--当天所有其他活动
local	campaign_daily	=3	--当天所有日常活动
local	campaign_tomorrowOther = 4 --明天的其他活动

--界面有效时间（一旦时间不同，所有的东西都要刷新）
local CurYear =0 ;
local CurMon = 0;
local CurDay = 0;
local CurWeekDay = "";
--最大显示特殊活动数目
local max_special_campaign  = 20;
local special_campaign_btn = {};
--当前特殊活动数
local cur_special_campaign = 0;

--休闲图片名
local idle_img = "Huodong_7";

--
local week_days = {};

local g_CurCampaignCtl = {}

local numToCh = {"零","一","二","三","四","五","六","七","八","九","十"}

function HuoDongRiCheng_PreLoad()
	this:RegisterEvent("GAMELOGIN_SHOW_CAMPAIGNS")
	this:RegisterEvent("CLOSE_TODAY_CAMPAIGN_LIST")
end

function HuoDongRiCheng_OnLoad()
	special_campaign_btn[1] = HuoDongRiCheng_Button1;
	special_campaign_btn[2] = HuoDongRiCheng_Button2;
	special_campaign_btn[3] = HuoDongRiCheng_Button3;
	special_campaign_btn[4] = HuoDongRiCheng_Button4;
	special_campaign_btn[5] = HuoDongRiCheng_Button5;
	special_campaign_btn[6] = HuoDongRiCheng_Button6;
	special_campaign_btn[7] = HuoDongRiCheng_Button7;
	special_campaign_btn[8] = HuoDongRiCheng_Button8;
	special_campaign_btn[9] = HuoDongRiCheng_Button9;
	special_campaign_btn[10] = HuoDongRiCheng_Button10;
	special_campaign_btn[11] = HuoDongRiCheng_Button11;
	special_campaign_btn[12] = HuoDongRiCheng_Button12;
	special_campaign_btn[13] = HuoDongRiCheng_Button13;
	special_campaign_btn[14] = HuoDongRiCheng_Button14;
	special_campaign_btn[15] = HuoDongRiCheng_Button15;
	special_campaign_btn[16] = HuoDongRiCheng_Button16;
	special_campaign_btn[17] = HuoDongRiCheng_Button17;
	special_campaign_btn[18] = HuoDongRiCheng_Button18;
	special_campaign_btn[19] = HuoDongRiCheng_Button19;
	special_campaign_btn[20] = HuoDongRiCheng_Button20;
	
	week_days[1] = "日";
	week_days[2] = "一";
	week_days[3] = "二";
	week_days[4] = "三";
	week_days[5] = "四";
	week_days[6] = "五";
	week_days[7] = "六";

	g_CurCampaignCtl = 	{
					{lableTime = HuoDongRiCheng_Text7, txtTime = HuoDongRiCheng_Text7_1,lableName = HuoDongRiCheng_Text8, txtName = HuoDongRiCheng_Text8_1,lableDesc = HuoDongRiCheng_Text9, txtDesc = HuoDongRiCheng_Text9_1},
					{lableTime = HuoDongRiCheng_Text10, txtTime = HuoDongRiCheng_Text10_1,lableName = HuoDongRiCheng_Text11, txtName = HuoDongRiCheng_Text11_1,lableDesc = HuoDongRiCheng_Text12, txtDesc = HuoDongRiCheng_Text12_1},
				};
end

-- OnEvent
function HuoDongRiCheng_OnEvent(event)
	if ( event == "GAMELOGIN_SHOW_CAMPAIGNS" ) then	
		local year = tonumber(arg0);
		local mon = tonumber(arg1);
		local day = tonumber(arg2);
		local wday = tonumber(arg3);
		if(CurYear~=year or CurMon~=mon or CurDay ~= day)then
			CurYear=year  
			CurMon=mon  
			CurDay = day
			CurWeekDay = week_days[wday+1];
			HuoDongRiCheng_SetConsts();
		end
		HuoDongRiCheng_UpdateVar();
		this:Show();
	elseif( event == "CLOSE_TODAY_CAMPAIGN_LIST") then
		this:Hide();
	end
end

function HideAllSpecialCampaignBtns()
	for i = 1,20 do
		special_campaign_btn[i]:Hide()
	end
end

function InitTomorrowOtherCampaign()
	cur_special_campaign = GetCampaignCount(tonumber(campaign_tomorrowOther));
	
	AxTrace(0, 0, "InitTomorrowOtherCampaign(): Start with Count = "..cur_special_campaign);
	if(cur_special_campaign>max_special_campaign) then
		cur_special_campaign = max_special_campaign;
	end
	
	if(cur_special_campaign>0)then
		for i = 0,cur_special_campaign-1 do
			local icon = EnumCampaign(tonumber(campaign_tomorrowOther),i,"icon");
			AxTrace(0, 0, "EnumCampaign(): Icon = "..icon);
			if(icon~=-1)then
				special_campaign_btn[i+1]:SetImage(icon);
				local str = "时间:";
				local strTime = "";
				local strEnd = EnumCampaign(tonumber(campaign_tomorrowOther),i,"endtime");
				if(strEnd ~= -1) then
					strTime = EnumCampaign(tonumber(campaign_tomorrowOther),i,"starttime").."--"..strEnd;
				else
					strTime = EnumCampaign(tonumber(campaign_tomorrowOther),i,"starttime");
				end
				local strHuodong = EnumCampaign(tonumber(campaign_tomorrowOther),i,"name");
				local strDesc = EnumCampaign(tonumber(campaign_tomorrowOther),i,"desc");
			        local strAddDesc =EnumCampaign(tonumber(campaign_tomorrowOther),i,"addtiondesc");
				if(strTime and  strTime~="")then
					str = str..strTime;
				end
				if(strHuodong and  strHuodong ~="")then
					str = str.."#r活动:"..strHuodong;
				end
				if(strDesc and  strDesc ~="")then
					str = str.."#r相关:"..strDesc;
				end
				if(strAddDesc and  strAddDesc ~="")then
					str = str.."#r     "..strAddDesc;
				end
				special_campaign_btn[i+1]:Show();
				special_campaign_btn[i+1]:SetToolTip(str);
			end
		end
	else
		--显示一张休闲图片
		special_campaign_btn[1]:SetImage(idle_img);
		special_campaign_btn[1]:Show();
		special_campaign_btn[1]:SetToolTip("明日无特殊活动");
	end
end

function InitCurOtherCampain()
	cur_special_campaign = GetCampaignCount(tonumber(campaign_other));
	if(cur_special_campaign>max_special_campaign) then
		cur_special_campaign = max_special_campaign;
	end
	if(cur_special_campaign>0)then
		for i = 0,cur_special_campaign-1 do
			local icon = EnumCampaign(tonumber(campaign_other),i,"icon");
			if(icon~=-1)then
				special_campaign_btn[i+1]:SetImage(icon);
				local str = "时间:";
				local strTime = "";
				local strEnd = EnumCampaign(tonumber(campaign_other),i,"endtime");
				if(strEnd ~= -1) then
					strTime = EnumCampaign(tonumber(campaign_other),i,"starttime").."--"..strEnd;
				else
					strTime = EnumCampaign(tonumber(campaign_other),i,"starttime");
				end
				local strHuodong = EnumCampaign(tonumber(campaign_other),i,"name");
				local strDesc = EnumCampaign(tonumber(campaign_other),i,"desc");
			        local strAddDesc =EnumCampaign(tonumber(campaign_other),i,"addtiondesc");
				if(strTime and  strTime~="")then
					str = str..strTime;
				end
				if(strHuodong and  strHuodong ~="")then
					str = str.."#r活动:"..strHuodong;
				end
				if(strDesc and  strDesc ~="")then
					str = str.."#r相关:"..strDesc;
				end
				if(strAddDesc and  strAddDesc ~="")then
					str = str.."#r     "..strAddDesc;
				end
				special_campaign_btn[i+1]:Show();
				special_campaign_btn[i+1]:SetToolTip(str);
			end
		end
	else
		--显示一张休闲图片
		special_campaign_btn[1]:SetImage(idle_img);
		special_campaign_btn[1]:Show();
		special_campaign_btn[1]:SetToolTip("当日无特殊活动");
	end
end

--填写一些一天中固定不变的东西
function HuoDongRiCheng_SetConsts()

	--填充每日特殊活动
	HideAllSpecialCampaignBtns();
	InitCurOtherCampain();
	SetNormalImage(1);
	--填充界面年月日
	local tmpyear = tonumber(CurYear);
	local tmpMon = tonumber(CurMon);
	local tmpDay = tonumber(CurDay);
	if(tmpyear == nil or tmpyear<2000 or tmpMon>12 or tmpDay>31)then
		HuoDongRiCheng_Text2:SetText("");
		HuoDongRiCheng_Text3:SetText("");
		HuoDongRiCheng_Text4:SetText("");
		return;
	end

	tmpyear =  math.mod(tmpyear,100);
	local si = math.floor(tmpyear /10) +1;
	local yi = math.mod(tmpyear,10)+1;
	HuoDongRiCheng_Text2:SetText("#gFF0FA0".."二零"..numToCh[si]..numToCh[yi].."年");

	si =  math.floor(tmpMon /10) ;
	yi = math.mod(tmpMon,10)
	local tmpstr = "";
	if(si>0)then
		tmpstr = tmpstr .."十";
	end
	if(yi>0)then
		tmpstr = tmpstr .. numToCh[yi+1];
	end
	si =  math.floor(tmpDay /10);
	yi = math.mod(tmpDay,10)
	local tmpstr1 = "";
	if(si>1)then
		tmpstr1 = tmpstr1 .. numToCh[si+1].."十";
	elseif(si>0)then
		
		tmpstr1 = tmpstr1 .. "十";
	end
	if(yi>0)then
		tmpstr1 = tmpstr1 .. numToCh[yi+1];
	end
	HuoDongRiCheng_Text3:SetText("#gFF0FA0"..tmpstr.."月"..tmpstr1.."日");
	HuoDongRiCheng_Text4:SetText("#gFF0FA0".."星期"..CurWeekDay);
end

local maxShow = 2;
--更新时刻都在变的东西
function HuoDongRiCheng_UpdateVar()
	HuoDongRiCheng_ClearVar();
	--更新当前正常活动
	

	

	local count =GetCampaignCount(tonumber(campaign_curDaily));
	if(count == 0)then
		--如果当前一条都没有
		--do nothing
	else
		if(count>=maxShow)then
			count = maxShow;
		end
		for i =1,count do
			local strTime = "";
			local strEnd = EnumCampaign(tonumber(campaign_curDaily),i-1,"endtime");
			if(strEnd ~= -1) then
				strTime = EnumCampaign(tonumber(campaign_curDaily),i-1,"starttime").."--"..strEnd;
			else
				strTime = EnumCampaign(tonumber(campaign_curDaily),i-1,"starttime");
			end
			g_CurCampaignCtl[i].txtTime:SetText(strTime);
			g_CurCampaignCtl[i].lableTime:Show();
			local strHuodong = EnumCampaign(tonumber(campaign_curDaily),i-1,"name");
			g_CurCampaignCtl[i].txtName:SetText(strHuodong);
			g_CurCampaignCtl[i].lableName:Show();
			local strDesc = EnumCampaign(tonumber(campaign_curDaily),i-1,"desc").."#r"..EnumCampaign(tonumber(campaign_curDaily),i-1,"addtiondesc");
			g_CurCampaignCtl[i].txtDesc:SetText(strDesc);
			g_CurCampaignCtl[i].lableDesc:Show();
		end
	end
end

function HuoDongRiCheng_ClearVar()
	HuoDongRiCheng_Text7:Hide();
	HuoDongRiCheng_Text7_1:SetText("");

	HuoDongRiCheng_Text8:Hide();
	HuoDongRiCheng_Text8_1:SetText("");

	HuoDongRiCheng_Text9:Hide();
	HuoDongRiCheng_Text9_1:SetText("");

	HuoDongRiCheng_Text10:Hide();
	HuoDongRiCheng_Text10_1:SetText("");

	HuoDongRiCheng_Text11:Hide();
	HuoDongRiCheng_Text11_1:SetText("");

	HuoDongRiCheng_Text12:Hide();
	HuoDongRiCheng_Text12_1:SetText("");
end

function HuoDongRiCheng_next_click()
	--this:Hide();
	GameProduceLogin:ExitToSelectServer();
end

function Do_OpenTadayHD()
	HideAllSpecialCampaignBtns();
	InitCurOtherCampain();
	SetNormalImage(1);
end

function Do_OpenTomorrowHD()
	HideAllSpecialCampaignBtns();
	InitTomorrowOtherCampaign();
	SetNormalImage(2);
end

function SetNormalImage(flag)
	if flag == 2 then
		HuoDongRiCheng_jinrianniu : SetProperty("NormalImage", "set:ButtonCampaign2 image:Campaign_IMG_jinri_Normal");    --明日活动按钮变化
		HuoDongRiCheng_jinrianniu : SetProperty("HoverImage", "set:ButtonCampaign2 image:Campaign_IMG_jinri_Hover");   
		HuoDongRiCheng_jinrianniu : SetProperty("PushedImage", "set:ButtonCampaign2 image:Campaign_IMG_jinri_Pushed"); 
		
		HuoDongRiCheng_mingrianniu : SetProperty("NormalImage", "set:ButtonCampaign2 image:Campaign_IMG_mingriL_Pushed");
		HuoDongRiCheng_mingrianniu : SetProperty("HoverImage", "set:ButtonCampaign2 image:Campaign_IMG_mingriL_Hover");
		HuoDongRiCheng_mingrianniu : SetProperty("PushedImage", "set:ButtonCampaign2 image:Campaign_IMG_mingriL_Pushed");
	else
		HuoDongRiCheng_jinrianniu : SetProperty("NormalImage", "set:ButtonCampaign2 image:Campaign_IMG_jinriL_Pushed");     --今日活动按钮变化
		HuoDongRiCheng_jinrianniu : SetProperty("HoverImage", "set:ButtonCampaign2 image:Campaign_IMG_jinriL_Hover"); 
		HuoDongRiCheng_jinrianniu : SetProperty("PushedImage", "set:ButtonCampaign2 image:Campaign_IMG_jinriL_Pushed"); 
		
		HuoDongRiCheng_mingrianniu : SetProperty("NormalImage", "set:ButtonCampaign2 image:Campaign_IMG_mingri_Normal");
		HuoDongRiCheng_mingrianniu : SetProperty("HoverImage", "set:ButtonCampaign2 image:Campaign_IMG_mingri_Hover");
		HuoDongRiCheng_mingrianniu : SetProperty("PushedImage", "set:ButtonCampaign2 image:Campaign_IMG_mingri_Pushed");
	end
end

