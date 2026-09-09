function ConfraternityPKStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDENEMY_DLG");		
end

function ConfraternityPKStart_OnLoad()
end


function ConfraternityPKStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDENEMY_DLG") then
		ConfraternityPKStart_InitDlg()
		this:Show()
	end
end

function ConfraternityPKStart_InitDlg()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityPKStart_Input:SetText("");
end


function ConfraternityPKStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityPKStart_OnHide()
end

function ConfraternityPKStart_OnHide()
	ConfraternityPKStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityPKStart_Accept_BtnClick()
	local guid = ConfraternityPKStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("帮会id不能为空！");
		return;
	end
	City:SendAddEnemyMsg(tonumber(guid));
	this:Hide();
end