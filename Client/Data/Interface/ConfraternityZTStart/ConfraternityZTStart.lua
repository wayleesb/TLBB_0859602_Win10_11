function ConfraternityZTStart_PreLoad()
	this:RegisterEvent("CITY_OPEN_ADDBATTLE_DLG");		
end

function ConfraternityZTStart_OnLoad()
end


function ConfraternityZTStart_OnEvent(event)
	if ( event == "CITY_OPEN_ADDBATTLE_DLG") then
		ConfraternityZTStart_InitDlg()
		this:Show()
	end
end

function ConfraternityZTStart_InitDlg()
	ConfraternityZTStart_Input:SetProperty("DefaultEditBox", "True");	
	ConfraternityZTStart_Input:SetText("");
end


function ConfraternityZTStart_Cancel_BtnClick()
	this:Hide();
	ConfraternityZTStart_OnHide()
end

function ConfraternityZTStart_OnHide()
	ConfraternityZTStart_Input:SetProperty("DefaultEditBox", "False");	
end

function ConfraternityZTStart_Accept_BtnClick()
	local guid = ConfraternityZTStart_Input:GetText();
	if(tonumber(guid)==nil)then
		PushDebugMessage("帮会id不能为空！");
		return;
	end
	City:SendAddGuildBattleMsg(tonumber(guid));
	this:Hide();
end