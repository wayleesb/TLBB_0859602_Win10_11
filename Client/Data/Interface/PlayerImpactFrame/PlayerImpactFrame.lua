
--最多显示的效果数量
local IMPACT_NUM = 12;

local IMPACT_DESC = {};
IMPACT_DESC[1] = 0;
IMPACT_DESC[2] = 0;
IMPACT_DESC[3] = 0;
IMPACT_DESC[4] = 0;
IMPACT_DESC[5] = 0;
IMPACT_DESC[6] = 0;
IMPACT_DESC[7] = 0;
IMPACT_DESC[8] = 0;
IMPACT_DESC[9] = 0;
IMPACT_DESC[10] = 0;
IMPACT_DESC[11] = 0;
IMPACT_DESC[12] = 0;

local PlayerImpactFrame_TimeCtrl = {};
PlayerImpactFrame_TimeCtrl[1] = 0;
PlayerImpactFrame_TimeCtrl[2] = 0;
PlayerImpactFrame_TimeCtrl[3] = 0;
PlayerImpactFrame_TimeCtrl[4] = 0;
PlayerImpactFrame_TimeCtrl[5] = 0;
PlayerImpactFrame_TimeCtrl[6] = 0;
PlayerImpactFrame_TimeCtrl[7] = 0;
PlayerImpactFrame_TimeCtrl[8] = 0;
PlayerImpactFrame_TimeCtrl[9] = 0;
PlayerImpactFrame_TimeCtrl[10] = 0;
PlayerImpactFrame_TimeCtrl[11] = 0;
PlayerImpactFrame_TimeCtrl[12] = 0;

local IMPACT_BUTTONS = {};

function PlayerImpactFrame_PreLoad()
	this:RegisterEvent("IMPACT_SELF_UPDATE");
	this:RegisterEvent("IMPACT_SELF_UPDATE_TIME");

end

function PlayerImpactFrame_OnLoad()

	IMPACT_BUTTONS[1] = PlayerImpact_Image1;
	IMPACT_BUTTONS[2] = PlayerImpact_Image2;
	IMPACT_BUTTONS[3] = PlayerImpact_Image3;
	IMPACT_BUTTONS[4] = PlayerImpact_Image4;
	IMPACT_BUTTONS[5] = PlayerImpact_Image5;
	IMPACT_BUTTONS[6] = PlayerImpact_Image6;
	IMPACT_BUTTONS[7] = PlayerImpact_Image7;
	IMPACT_BUTTONS[8] = PlayerImpact_Image8;
	IMPACT_BUTTONS[9] = PlayerImpact_Image9;
	IMPACT_BUTTONS[10] = PlayerImpact_Image10;
	IMPACT_BUTTONS[11] = PlayerImpact_Image11;
	IMPACT_BUTTONS[12] = PlayerImpact_Image12;
	
	PlayerImpactFrame_TimeCtrl[1] = PlayerImpact_Text1;
	PlayerImpactFrame_TimeCtrl[2] = PlayerImpact_Text2;
	PlayerImpactFrame_TimeCtrl[3] = PlayerImpact_Text3;
	PlayerImpactFrame_TimeCtrl[4] = PlayerImpact_Text4;
	PlayerImpactFrame_TimeCtrl[5] = PlayerImpact_Text5;
	PlayerImpactFrame_TimeCtrl[6] = PlayerImpact_Text6;
	PlayerImpactFrame_TimeCtrl[7] = PlayerImpact_Text7;
	PlayerImpactFrame_TimeCtrl[8] = PlayerImpact_Text8;
	PlayerImpactFrame_TimeCtrl[9] = PlayerImpact_Text9;
	PlayerImpactFrame_TimeCtrl[10] = PlayerImpact_Text10;
	PlayerImpactFrame_TimeCtrl[11] = PlayerImpact_Text11;
	PlayerImpactFrame_TimeCtrl[12] = PlayerImpact_Text12;
end

function PlayerImpactFrame_OnEvent(event)

	if ( event == "IMPACT_SELF_UPDATE" ) then
		PlayerImpactFrame_Update( 1, 1 );
		return;
	end

	if ( event == "IMPACT_SELF_UPDATE_TIME" ) then
		PlayerImpactFrame_Update( 0, 1 );
		return;
	end

end

function PlayerImpactFrame_Update( bUpdateImage, bUpdateTime )

	local buff_num = Player:GetBuffNumber();

	if ( buff_num > IMPACT_NUM ) then
		buff_num = IMPACT_NUM;
	end

	if( buff_num == 0) then 
		this:Hide();
		return;
	end

	this:Show();

	if ( bUpdateImage > 0 ) then
		local szIconName, szToolTips;
		local i;

		i = 0;
		while i<buff_num do
			szIconName = Player:GetBuffIconNameByIndex(i);
			szToolTips = Player:GetBuffToolTipsByIndex(i);
			IMPACT_BUTTONS[i+1]:SetProperty("ShortImage", szIconName);
			IMPACT_BUTTONS[i+1]:SetProperty("MouseHollow","False");
			IMPACT_BUTTONS[i+1]:SetToolTip(szToolTips);
			IMPACT_BUTTONS[i+1]:Show();
			i = i+1;
		end

		while i<IMPACT_NUM do
			IMPACT_BUTTONS[i+1]:SetProperty("MouseHollow","True");
			IMPACT_BUTTONS[i+1]:Hide();
			i = i+1;
		end
	end
	
	if ( bUpdateTime > 0 ) then
		local szTimeText;
		local i;

		i = 0;
		while i<buff_num do
			szTimeText = Player:GetBuffTimeTextByIndex(i);
--			PlayerImpactFrame_TimeCtrl[i+1]:SetText(szTimeText);
			PlayerImpactFrame_TimeCtrl[i+1] : SetProperty("Timer",tostring(szTimeText));
			PlayerImpactFrame_TimeCtrl[i+1]:Show();
			i = i+1;
		end

		while i<IMPACT_NUM do
			PlayerImpactFrame_TimeCtrl[i+1]:SetProperty("Timer","-2");
			PlayerImpactFrame_TimeCtrl[i+1]:Hide();
			i = i+1;
		end
	end

end

function PlayerImpactFrame_Image1_Click()
	Player:DispelBuffByIndex( 0 );
end

function PlayerImpactFrame_Image2_Click()
	Player:DispelBuffByIndex( 1 );
end

function PlayerImpactFrame_Image3_Click()
	Player:DispelBuffByIndex( 2 );
end

function PlayerImpactFrame_Image4_Click()
	Player:DispelBuffByIndex( 3 );
end

function PlayerImpactFrame_Image5_Click()
	Player:DispelBuffByIndex( 4 );
end

function PlayerImpactFrame_Image6_Click()
	Player:DispelBuffByIndex( 5 );
end

function PlayerImpactFrame_Image7_Click()
	Player:DispelBuffByIndex( 6 );
end

function PlayerImpactFrame_Image8_Click()
	Player:DispelBuffByIndex( 7 );
end

function PlayerImpactFrame_Image9_Click()
	Player:DispelBuffByIndex( 8 );
end

function PlayerImpactFrame_Image10_Click()
	Player:DispelBuffByIndex( 9 );
end

function PlayerImpactFrame_Image11_Click()
	Player:DispelBuffByIndex( 10 );
end

function PlayerImpactFrame_Image12_Click()
	Player:DispelBuffByIndex( 11 );
end
