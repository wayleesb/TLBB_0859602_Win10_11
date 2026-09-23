local	campaign_today = 0	--当天所有活动
local	campaign_curDaily = 1	--目前日常活动
local	campaign_other	=2	--当天所有其他活动
local	campaign_daily	=3	--当天所有日常活动

local g_TodalCampaignCount = 0;		--今天的活动数目

-- 界面控件
local g_AllCampaignDetailDescs = {};	-- 所有活动的详细描述信息列表
local g_AllCampaignID = {};          --记录下所有活动ID

function TodayCampaignList_PreLoad()
	this:RegisterEvent("SHOW_TODAY_CAMPAIGN_LIST")
	this:RegisterEvent("SHOW_TODAY_CAMPAIGN_LIST_FROM_TRACK");
	this:RegisterEvent("UPDATE_CAMPAGIN_BY_TRACK");
end

function TodayCampaignList_OnLoad()
	
end

-- OnEvent
function TodayCampaignList_OnEvent(event)
	if ( event == "SHOW_TODAY_CAMPAIGN_LIST" ) then
		this:TogleShow();
		TodayCampaignList_Init();
	elseif ( event == "SHOW_TODAY_CAMPAIGN_LIST_FROM_TRACK") then
		local nSelectID = tonumber(arg0)
		if not this:IsVisible() then
			this:TogleShow();
			TodayCampaignList_Init(nSelectID);
		else
			--TodayCampaignList_Init(-1);
			TodayCampaignList_OnClosed();
		end
	elseif (event == "UPDATE_CAMPAGIN_BY_TRACK") then
		if not this:IsVisible() then
			return;
		else
			TodayCampaignList_Init(-1);
		end
	elseif (event == "UPDATE_CAMPAGIN_BY_TRACK") then
		if this:IsVisible() then
			TodayCampaignList_Init(-1);
		end
	end
end

function TodayCampaignList_Init(nSelectID)
	-- 清除刚才打开时的信息
	TodayCampaignList_DetailDesc:ClearAllElement();
	TodayCampaignList_ListCtl:RemoveAllItem();
	local g_Current_Select_index = -1;

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
		
		local nCampaignID = EnumCampaign(tonumber(campaign_today),i,"id");
		local nIsTrack = EnumCampaign(tonumber(campaign_today),i,"TrackIsOrNot");
		if ( nSelectID == nCampaignID) then
			g_Current_Select_index = i;
		end
		if (DataPool:IsCampaignTrackOpen(nCampaignID) >= 1 and nIsTrack == 1) then
			strHuodong = "√" .. strHuodong;
		else
			strHuodong = "  " .. strHuodong;
		end
		TodayCampaignList_ListCtl:AddNewItem(strHuodong, 1, i);
		TodayCampaignList_ListCtl:AddNewItem(strDesc, 2, i);

		g_AllCampaignDetailDescs[i+1] = strDetailDesc;		-- 记录当前活动的详细描述信息
		g_AllCampaignID[i+1] = nCampaignID;
	end
	
	if (g_Current_Select_index == -1) then
		g_Current_Select_index = 0;
	end
	TodayCampaignList_ListCtl:SetSelectItem(g_Current_Select_index);
	TodayCampaignList_ListCtl:SetVertScollPosition(g_Current_Select_index);
	TodayCampaignList_TrackButtonState();
	g_Current_Select_index = -1;
	
	-- 打开窗口时，没有选中任何任务时的显示内容
	--TodayCampaignList_DetailDesc:AddTextElement("#{MRHD_090413_1}");
	TodayCampaignList_DetailDesc:Show();

end

-- 鼠标点击具体活动后的相应函数
function TodayCampaignList_List_OnSelectionChanged()

	-- 清除刚才选择的活动信息
	TodayCampaignList_DetailDesc:ClearAllElement();		-- 清除活动描述信息
	
	local nSel = TodayCampaignList_ListCtl:GetSelectItem();	-- 当前选择的行号 (0 ~ g_TodalCampaignCount-1)
	TodayCampaignList_TrackButtonState();
	-- 显示当前选中的活动信息	
	if (g_AllCampaignDetailDescs[nSel+1] ~= nil) then
		TodayCampaignList_DetailDesc:AddTextElement(tostring(g_AllCampaignDetailDescs[nSel+1]));
	end
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
		g_AllCampaignID[i] = nil;
	end	
end

-- 取消
function TodayCampaignList_OnCancel()
	--this:Hide();
	-- 清空当前活动数据
	--TodayCampaignList_DetailDesc:ClearAllElement();		-- 清除活动描述信息
	-- 清空所有已经读取的今日活动列表数据
	--for i=1 , g_TodalCampaignCount do		
	--	g_AllCampaignDetailDescs[i] = "";
	--end	
	
	
	local nSel = TodayCampaignList_ListCtl:GetSelectItem();	-- 当前选择的行号 (0 ~ g_TodalCampaignCount-1)
	local nCampaignID = tonumber(g_AllCampaignID[nSel+1]);
	if (nCampaignID == nil or nCampaignID < 0) then
		return
	end
	if (DataPool:IsCampaignCanTrack(nCampaignID) > 0) then
		if (DataPool:IsCampaignTrackOpen(nCampaignID) > 0) then
			DataPool:SetCampaignTrackOpen(nCampaignID, 0);
		else
			if (DataPool:IsTrackFuncShow(2) == 0) then
				OpenWindow("CampaignTrack");
				DataPool:SetTrackFuncShow(2, 1);
			end
			DataPool:SetCampaignTrackOpen(nCampaignID, 1);
		end
		DataPool:UpdateCampaignTrack();
		TodayCampaignList_TrackButtonState();
		TodayCampaignList_Init(nCampaignID);		
	end
end

function TodayCampaignList_TrackButtonState()
	local nSel = TodayCampaignList_ListCtl:GetSelectItem();	-- 当前选择的行号 (0 ~ g_TodalCampaignCount-1)
	local nCampaignID = tonumber(g_AllCampaignID[nSel+1]);
	
	if (nCampaignID ~= nil and DataPool:IsCampaignCanTrack(nCampaignID) > 0) then
		if (DataPool:IsCampaignTrackOpen(nCampaignID) > 0) then
			TodayCampaignList_Cancel:SetText("取消追踪");
		else
			TodayCampaignList_Cancel:SetText("开始追踪");
		end
		TodayCampaignList_Cancel:Enable();
	else
		TodayCampaignList_Cancel:SetText("不可追踪");
		TodayCampaignList_Cancel:Disable();
	end
end