local	campaign_today = 0	--当天所有活动
local	campaign_curDaily = 1	--目前日常活动
local	campaign_other	=2	--当天所有其他活动
local	campaign_daily	=3	--当天所有日常活动

local g_TodalCampaignCount = 0;		--今天的活动数目

-- 界面控件
local g_AllCampaignDetailDescs = {};	-- 所有活动的详细描述信息列表

function TodayCampaignList_PreLoad()
	this:RegisterEvent("SHOW_TODAY_CAMPAIGN_LIST")
end

function TodayCampaignList_OnLoad()
	
end

-- OnEvent
function TodayCampaignList_OnEvent(event)
	if ( event == "SHOW_TODAY_CAMPAIGN_LIST" ) then
		this:TogleShow();
		TodayCampaignList_Init()
	end
end

function TodayCampaignList_Init()
	-- 清除刚才打开时的信息
	TodayCampaignList_DetailDesc:ClearAllElement();
	TodayCampaignList_ListCtl:RemoveAllItem();

	local g_TodalCampaignCount = GetCampaignCount(tonumber(campaign_today));

	for i=0 , g_TodalCampaignCount-1 do
		-- 活动时间
		local strTime = "";
		local strEnd = EnumCampaign(tonumber(campaign_today),i,"endtime");
		if(strEnd ~= -1) then
			strTime = EnumCampaign(tonumber(campaign_today),i,"starttime").."--"..strEnd;
		else
			strTime = EnumCampaign(tonumber(campaign_today),i,"starttime");
		end

		-- 活动名
		local strHuodong = EnumCampaign(tonumber(campaign_today),i,"name");
		
		-- 活动描述
		local strDesc = EnumCampaign(tonumber(campaign_today),i,"desc");
		local ends = EnumCampaign(tonumber(campaign_today),i,"addtiondesc");
		if(ends and ends~="")then
			strDesc = strDesc.."、"..ends;
		end
		AxTrace( 5,3, strDesc );

		-- 详细活动描述
		local strDetailDesc = EnumCampaign(tonumber(campaign_today),i,"detailDesc");
		
		-- 活动类型
		local isCur  =  EnumCampaign(tonumber(campaign_today),i,"iscurcampaign");
		if(tonumber(isCur) == 1)then
			strTime = "#G" .. strTime;
			strHuodong = "#G" .. strHuodong;
			strDesc = "#G" .. strDesc;
		else
			local isDaliy  =  EnumCampaign(tonumber(campaign_today),i,"timetype");
			if(tonumber(isDaliy) == 1)then
				strTime = "#W" .. strTime;
				strHuodong = "#W" .. strHuodong;
				strDesc = "#W" .. strDesc;
			else
				strTime = "#Y" .. strTime;
				strHuodong = "#Y" .. strHuodong;
				strDesc = "#Y" .. strDesc;			
			end			
		end

		TodayCampaignList_ListCtl:AddNewItem(strTime, 0, i);
		TodayCampaignList_ListCtl:AddNewItem(strHuodong, 1, i);
		TodayCampaignList_ListCtl:AddNewItem(strDesc, 2, i);

		g_AllCampaignDetailDescs[i+1] = strDetailDesc;		-- 记录当前活动的详细描述信息
	end
	
	-- 打开窗口时，没有选中任何任务时的显示内容
	TodayCampaignList_DetailDesc:AddTextElement("#{MRHD_090413_1}");
	TodayCampaignList_DetailDesc:Show();

end

-- 鼠标点击具体活动后的相应函数
function TodayCampaignList_List_OnSelectionChanged()

	-- 清除刚才选择的活动信息
	TodayCampaignList_DetailDesc:ClearAllElement();		-- 清除活动描述信息
	
	local nSel = TodayCampaignList_ListCtl:GetSelectItem();	-- 当前选择的行号 (0 ~ g_TodalCampaignCount-1)
	
	-- 显示当前选中的活动信息	
	TodayCampaignList_DetailDesc:AddTextElement(tostring(g_AllCampaignDetailDescs[nSel+1]));
	TodayCampaignList_DetailDesc:Show();	
end

-- 关闭
function TodayCampaignList_OnClosed()
	this:Hide();
	
	-- 清空当前活动数据
	TodayCampaignList_DetailDesc:ClearAllElement();		-- 清除活动描述信息

	-- 清空所有已经读取的今日活动列表数据
	for i=1 , g_TodalCampaignCount do		
		g_AllCampaignDetailDescs[i] = "";
	end	
end

-- 取消
function TodayCampaignList_OnCancel()
	this:Hide();
	
	-- 清空当前活动数据
	TodayCampaignList_DetailDesc:ClearAllElement();		-- 清除活动描述信息

	-- 清空所有已经读取的今日活动列表数据
	for i=1 , g_TodalCampaignCount do		
		g_AllCampaignDetailDescs[i] = "";
	end	
end
