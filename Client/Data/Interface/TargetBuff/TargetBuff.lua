local TARGET_BUFF_MAX = 6;
local TARGET_IMPACT_CTL = {};

function TargetBuff_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("MAINTARGET_OPEN");
	this:RegisterEvent("MAINTARGET_BUFF_REFRESH");
end

function TargetBuff_OnLoad()
	TARGET_IMPACT_CTL[1] = TargetBuff_Image1;
	TARGET_IMPACT_CTL[2] = TargetBuff_Image2;
	TARGET_IMPACT_CTL[3] = TargetBuff_Image3;
	TARGET_IMPACT_CTL[4] = TargetBuff_Image4;
	TARGET_IMPACT_CTL[5] = TargetBuff_Image5;
	TARGET_IMPACT_CTL[6] = TargetBuff_Image6;
end

function TargetBuff_OnEvent( event )
	if(0 == TargetBuff_IsTargetValid()) then
		TargetBuff_Clear();
		this:Hide();
		return;
	end
	
	if(event == "MAINTARGET_OPEN") then
		--AxTrace(0,0,"event1:"..event);
		TargetBuff_Update();
		this:Show();
	elseif(event == "MAINTARGET_CHANGED") then
		if(-1 ~= tonumber(arg0)) then
			--AxTrace(0,0,"event2.1:"..event);
			TargetBuff_Update();
			this:Show();
		else
			--AxTrace(0,0,"event2.2:"..event);
			TargetBuff_Clear();
			this:Hide();
		end
	elseif(event == "MAINTARGET_BUFF_REFRESH") then
		--AxTrace(0,0,"event3:"..event);
		TargetBuff_Update();
		this:Show();
	end
end

-- 返回0，不显示。返回1，显示。
function TargetBuff_IsTargetValid()
	if(Target:IsPresent()) then
		return 1;
	elseif(Target:IsTargetTeamMember()) then
		return 1;
	else
		return 0;
	end
end

function TargetBuff_Update()
	local nBuffNum = Target:GetBuffNumber();
	if(0 == nBuffNum) then
		TargetBuff_Clear();
		this:Hide();	
	end
	if(nBuffNum > TARGET_BUFF_MAX) then nBuffNum = TARGET_BUFF_MAX; end
	
	local i = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;
		
		szIconName,szTipInfo = Target:GetBuffIconNameByIndex(i);
		TARGET_IMPACT_CTL[i+1]:SetProperty("ShortImage", szIconName);
		TARGET_IMPACT_CTL[i+1]:Show();
		TARGET_IMPACT_CTL[i+1]:SetToolTip(szTipInfo);
		i = i + 1;
	end
	
	while i < TARGET_BUFF_MAX do
		TARGET_IMPACT_CTL[i+1]:SetToolTip("");
		TARGET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
end

function TargetBuff_Clear()
	local i = 0;
	while i < TARGET_BUFF_MAX do
		TARGET_IMPACT_CTL[i+1]:SetToolTip("");
		TARGET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
end