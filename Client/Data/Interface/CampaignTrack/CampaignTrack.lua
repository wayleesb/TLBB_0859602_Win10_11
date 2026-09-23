-- 活动跟踪   author：houzhifang

local g_strWndName = "CampaignTrack";

local g_dlgctrls = {}; --控件集合
local g_LockState = 0;   --0:未锁定，1：已锁定

function CampaignTrack_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("OPEN_MISSION_TRACK");
	this:RegisterEvent("UPDATE_CAMPAIGN_LIST");

	this:RegisterEvent("TRACK_ALPHA_ACTION");
	this:RegisterEvent("UNIT_LEVEL");
end

function CampaignTrack_OnLoad()
	CampaignTrack_UnLock:Hide();
	CampaignTrack_Lock:Show();
	CampaignTrack_ShowORHideFunc(0);
end

function CampaignTrack_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "CampaignTrack") then
			this:Show();
			CampaignTrack_ShowORHideFunc(0);
			CampaignTrack_UpdateList();
			DataPool:UpdateTrackStateButton(1);
		end
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "CampaignTrack") then
			this:Hide();
		end	
	elseif (event == "OPEN_MISSION_TRACK") then
		local nType = tonumber(arg0);
		if (nType == 2) then
			this:Show();
			CampaignTrack_ShowORHideFunc(0);
			CampaignTrack_UpdateList();
			DataPool:UpdateTrackStateButton(1);
		end
	elseif (event == "UPDATE_CAMPAIGN_LIST") then
		CampaignTrack_UpdateList();
	elseif (event == "TRACK_ALPHA_ACTION") then	
		CampaignTrack_SetAlpha(arg0)
		elseif (event == "UNIT_LEVEL") then
		if not this:IsVisible() then
			return;
		end
		CampaignTrack_UpdateList();
	end
end

function CampaignTrack_UpdateList()

	CampaignTrack_ListBoxTransparent:ClearListBoxEx();
	local	campaign_today = 0	--当天所有活动
	local g_TodalCampaignCount = GetCampaignCount(tonumber(campaign_today));

	for i=0 , g_TodalCampaignCount-1 do
		-- 活动类型
		local isCur  =  EnumCampaign(tonumber(campaign_today),i,"iscurcampaign");
		if(tonumber(isCur) == 1) then       --是当前的活动
			local nIsTrack = EnumCampaign(tonumber(campaign_today),i,"TrackIsOrNot");
			if (nIsTrack == 1) then
				local nCampaignID = EnumCampaign(tonumber(campaign_today),i,"id");
				if (DataPool:IsCampaignTrackOpen(nCampaignID) >= 1) then
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
					--追踪信息
					local strTrackDesc = EnumCampaign(tonumber(campaign_today),i,"TrackDesc");					
					local strTitle = "  #Y"..strTime.." "..strHuodong;
					strTrackDesc = "    #W"..strTrackDesc;
					local color = "FF0A9605";	--绿色
					CampaignTrack_ListBoxTransparent:AddItemExWithoutLayout(strTitle, nCampaignID, 3, color, 4)
					CampaignTrack_ListBoxTransparent:AddItemExWithoutLayout(strTrackDesc, nCampaignID, 0, color, 4)
				end
			end
		end
	end
	CampaignTrack_ListBoxTransparent:RequestLayout();
end


function CampaignTrack_CloseFunc()
	this:Hide();
	DataPool:SetTrackFuncShow(2, 0);
	DataPool:UpdateTrackStateButton(1);
end

function CampaignTrack_Func_MouseEnter()
	CampaignTrack_ShowORHideFunc(1);
end


function CampaignTrack_Func_MouseLeave()
	CampaignTrack_ShowORHideFunc(0);
end

function CampaignTrack_ItemContextClickedForEye()
	local nClickedItemInx = CampaignTrack_ListBoxTransparent:GetClickedButtonItem();
	DataPool:CampaignTrackGotoCampaignList(nClickedItemInx);	
end

function CampaignTrack_ItemContextClickedForClose()
	local nClickedItemInx = CampaignTrack_ListBoxTransparent:GetClickedButtonItem();
	DataPool:SetCampaignTrackOpen(nClickedItemInx, 0);
	CampaignTrack_UpdateList();
	DataPool:UpdateCampaignListByTrack();
end

function CampaignTrack_ShowORHideFunc(nShow)
	if (nShow >= 1 and g_LockState == 0) then
		CampaignTrack_Reduce:Show();
		CampaignTrack_Extend:Show();
		CampaignTrack_Add:Show();
		CampaignTrack_Sub:Show();
		CampaignTrack_Reset:Show();
	else
		CampaignTrack_Reduce:Hide();
		CampaignTrack_Extend:Hide();
		CampaignTrack_Add:Hide();
		CampaignTrack_Sub:Hide();
		CampaignTrack_Reset:Hide();
	end
end

function CampaignTrack_Height_Reduce()
	local nHeightOld = CampaignTrack_Frame:GetProperty("AbsoluteHeight");
	local nListTopOld = CampaignTrack__Frame:GetProperty("AbsoluteYPosition");
	local nHeightOld2 = CampaignTrack__Frame:GetProperty("AbsoluteHeight");
	local nFunctionTopOld = CampaignTrack_Function_Frame:GetProperty("AbsoluteYPosition");
	if (tonumber(nHeightOld) > 123) then
		CampaignTrack_Frame:SetProperty("AbsoluteHeight", nHeightOld-17);	
		CampaignTrack__Frame:SetProperty("AbsoluteYPosition", nListTopOld);	
		CampaignTrack__Frame:SetProperty("AbsoluteHeight", nHeightOld2-17);	
		CampaignTrack_Function_Frame:SetProperty("AbsoluteYPosition", nFunctionTopOld);	
	end
end

function CampaignTrack_Height_Add()
	local nHeightOld = CampaignTrack_Frame:GetProperty("AbsoluteHeight");
	local nListTopOld = CampaignTrack__Frame:GetProperty("AbsoluteYPosition");
	local nHeightOld2 = CampaignTrack__Frame:GetProperty("AbsoluteHeight");
	local nFunctionTopOld = CampaignTrack_Function_Frame:GetProperty("AbsoluteYPosition");
	if (tonumber(nHeightOld) < 225) then
		CampaignTrack_Frame:SetProperty("AbsoluteHeight", nHeightOld+17);	
		CampaignTrack__Frame:SetProperty("AbsoluteHeight", nHeightOld2+17);
		CampaignTrack__Frame:SetProperty("AbsoluteYPosition", nListTopOld);	
		CampaignTrack_Function_Frame:SetProperty("AbsoluteYPosition", nFunctionTopOld);	
	end
end

function CampaignTrack_Width_Add()
	local nWidthOld = CampaignTrack_Frame:GetProperty("AbsoluteWidth");
	local nFrameLeftOld = CampaignTrack_Frame:GetProperty("AbsoluteXPosition");
	local nCheckBoxX = CampaignTrack__CheckBox_Frame:GetProperty("AbsoluteXPosition");
	local nDragX = CampaignTrack_DragTitle:GetProperty("AbsoluteXPosition");
	local nCloseX = CampaignTrack_Close:GetProperty("AbsoluteXPosition");
	local nWidthOld2 = CampaignTrack__Frame:GetProperty("AbsoluteWidth");
	local nFuncLeft = CampaignTrack_Function_Frame:GetProperty("AbsoluteXPosition");
	local nLockX = CampaignTrack_Lock:GetProperty("AbsoluteXPosition");
	if (tonumber(nWidthOld) < 310) then
		CampaignTrack_Frame:SetProperty("AbsoluteWidth", nWidthOld + 10);
		CampaignTrack_Frame:SetProperty("AbsoluteXPosition", nFrameLeftOld-10);
		CampaignTrack__CheckBox_Frame:SetProperty("AbsoluteXPosition", nCheckBoxX + 10);
		CampaignTrack_DragTitle:SetProperty("AbsoluteXPosition", nDragX + 10);
		CampaignTrack_Close:SetProperty("AbsoluteXPosition", nCloseX + 10);
		CampaignTrack__Frame:SetProperty("AbsoluteWidth", nWidthOld2 + 10);
		CampaignTrack_Function_Frame:SetProperty("AbsoluteXPosition", nFuncLeft + 10);
		CampaignTrack_Lock:SetProperty("AbsoluteXPosition", nLockX + 10);
		CampaignTrack_UnLock:SetProperty("AbsoluteXPosition", nLockX + 10);
	end
end

function CampaignTrack_Width_Reduce()
	local nWidthOld = CampaignTrack_Frame:GetProperty("AbsoluteWidth");
	local nFrameLeftOld = CampaignTrack_Frame:GetProperty("AbsoluteXPosition");
	local nCheckBoxX = CampaignTrack__CheckBox_Frame:GetProperty("AbsoluteXPosition");
	local nDragX = CampaignTrack_DragTitle:GetProperty("AbsoluteXPosition");
	local nCloseX = CampaignTrack_Close:GetProperty("AbsoluteXPosition");
	local nWidthOld2 = CampaignTrack__Frame:GetProperty("AbsoluteWidth");
	local nFuncLeft = CampaignTrack_Function_Frame:GetProperty("AbsoluteXPosition");
	local nLockX = CampaignTrack_Lock:GetProperty("AbsoluteXPosition");
	if (tonumber(nWidthOld) > 230) then
		CampaignTrack_Frame:SetProperty("AbsoluteWidth", nWidthOld - 10);
		CampaignTrack_Frame:SetProperty("AbsoluteXPosition", nFrameLeftOld+10);
		CampaignTrack__CheckBox_Frame:SetProperty("AbsoluteXPosition", nCheckBoxX - 10);
		CampaignTrack_DragTitle:SetProperty("AbsoluteXPosition", nDragX - 10);
		CampaignTrack_Close:SetProperty("AbsoluteXPosition", nCloseX - 10);
		CampaignTrack__Frame:SetProperty("AbsoluteWidth", nWidthOld2 - 10);
		CampaignTrack_Function_Frame:SetProperty("AbsoluteXPosition", nFuncLeft - 10);
		CampaignTrack_Lock:SetProperty("AbsoluteXPosition", nLockX - 10);
		CampaignTrack_UnLock:SetProperty("AbsoluteXPosition", nLockX - 10);
	end
end

function CampaignTrack_Lock_Func()
	if (g_LockState == 0) then   --锁定
		g_LockState = 1;
		CampaignTrack_UnLock:Show();
		CampaignTrack_Lock:Hide();
		CampaignTrack_Close:SetProperty("MouseHollow", "True");
		CampaignTrack_Frame:SetProperty("MouseHollow", "True");
		CampaignTrack_DragTitle:SetProperty("MouseHollow", "True");
		CampaignTrack_Function_Frame:SetProperty("MouseHollow", "True");
		CampaignTrack_Reduce:SetProperty("MouseHollow", "True");
		CampaignTrack_Extend:SetProperty("MouseHollow", "True");
		CampaignTrack_Add:SetProperty("MouseHollow", "True");
		CampaignTrack_Sub:SetProperty("MouseHollow", "True");
		CampaignTrack_Reset:SetProperty("MouseHollow", "True");
	else               --解锁
		g_LockState = 0;
		CampaignTrack_Lock:Show();
		CampaignTrack_UnLock:Hide();
		CampaignTrack_Close:SetProperty("MouseHollow", "False");
		CampaignTrack_Frame:SetProperty("MouseHollow", "False");
		CampaignTrack_DragTitle:SetProperty("MouseHollow", "False");
		CampaignTrack_Function_Frame:SetProperty("MouseHollow", "False");
		CampaignTrack_Reduce:SetProperty("MouseHollow", "False");
		CampaignTrack_Extend:SetProperty("MouseHollow", "False");
		CampaignTrack_Add:SetProperty("MouseHollow", "False");
		CampaignTrack_Sub:SetProperty("MouseHollow", "False");
		CampaignTrack_Reset:SetProperty("MouseHollow", "False");
	end
	CampaignTrack_ShowORHideFunc(0);
end

function CampaignTrack_Reset_Func()
	CampaignTrack_Frame:SetProperty("UnifiedSize", "{{0,230},{0.0,123}}");
	CampaignTrack_Frame:SetProperty("UnifiedXPosition", "{1.0,-266}");
	CampaignTrack_Frame:SetProperty("UnifiedYPosition", "{0.0,386}");
	
	CampaignTrack__Frame:SetProperty("AbsolutePosition", "x:0.000000 y:17.000000");
	CampaignTrack__Frame:SetProperty("AbsoluteSize", "w:212.000000 h:105.000000");
	
	CampaignTrack_Function_Frame:SetProperty("AbsolutePosition", "x:211.0 y:17.0");
	
	CampaignTrack_DragTitle:SetProperty("AbsolutePosition", "x:80.000000 y:0.000000");
	CampaignTrack_Close:SetProperty("AbsolutePosition", "x:196.000000 y:0.000000");
	CampaignTrack__CheckBox_Frame:SetProperty("AbsolutePosition", "x:0.000000 y:0.000000");
	CampaignTrack_Lock:SetProperty("AbsolutePosition", "x:180.000000 y:0.000000");
	CampaignTrack_UnLock:SetProperty("AbsolutePosition", "x:180.000000 y:0.000000");
end


function CampaignTrack_SetAlpha(val)
	local bNum = val
	if tonumber(bNum) < 0.3 then 
		CampaignTrack_Frame:SetProperty( "Alpha", "0.5" );
		CampaignTrack_Function_Frame:SetProperty( "Alpha", "0.5" );
		CampaignTrack_ListBoxTransparent:SetVScrollbarAlpha("0.3");
	elseif tonumber(bNum) < 0.5 then
		CampaignTrack_Frame:SetProperty( "Alpha", "0.5" );
		CampaignTrack_Function_Frame:SetProperty( "Alpha", "0.5" );
		CampaignTrack_ListBoxTransparent:SetVScrollbarAlpha(val);
	else
		CampaignTrack_Frame:SetProperty( "Alpha", val );
		CampaignTrack_Function_Frame:SetProperty( "Alpha", val );
		CampaignTrack_ListBoxTransparent:SetVScrollbarAlpha(val);
	end
	CampaignTrack_Frame_Context:SetProperty( "Alpha", val );
end