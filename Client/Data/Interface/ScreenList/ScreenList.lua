function ScreenList_PreLoad()
	this:RegisterEvent("CHAT_PINGBI_LIST");
	this:RegisterEvent("CHAT_PINGBI_UPDATE");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end

function ScreenList_OnLoad()
end

function ScreenList_OnEvent( event )
	if(event == "CHAT_PINGBI_LIST") then
		ScreenList_Clear();
		ScreenList_Update();
		if(this:IsVisible() or this:ClickHide()) then
			this:Hide();
		else
			this:Show();
			ScreenList_ChangePosition(arg0);
		end
	elseif(event == "CHAT_PINGBI_UPDATE" and this:IsVisible()) then
		ScreenList_Clear();
		ScreenList_Update();	
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then	
		ScreenList_AdjustMoveCtl();
	end
end

function ScreenList_Clear()
	ScreenList_List:ClearListBox();
end

function ScreenList_Update()
	local Num = Talk:GetPingBiNum();
	if(Num == 0 or nil == Num) then
		return;
	end
	
	local i = 0;
	while i < Num do
		ScreenList_List:AddItem(Talk:GetPingBiName(i),i);
		i = i + 1;
	end
	
	if(Num > 0) then
		ScreenList_List:SetItemSelectByItemID(0);
	end
end

function ScreenList_Del_Clicked()
	local idx = ScreenList_List:GetFirstSelectItem();
	if(idx ~= -1) then
		Talk:DelPingBi(idx);
	end
end

function ScreenList_AdjustMoveCtl( screenWidth, screenHeight )
	this:Hide();
end

function ScreenList_ChangePosition(pos)
	ScreenList_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos.."}");
end