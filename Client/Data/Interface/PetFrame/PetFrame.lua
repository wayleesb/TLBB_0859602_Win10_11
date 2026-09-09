local PET_MAX_NUMBER = 6+4;
local PET_BUFF_MAX = 6;

local PET_HP = 0;
local PET_MAXHP = 1;
local PET_EXP = 0;
local PET_MAXEXP = 1;
local MousePos = 0;		--0,鼠标不在窗体内 1,鼠标在窗体内

local PET_IMPACT_CTL = {};
local g_FightPet = -1;

function PetFrame_PreLoad()
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

end

function PetFrame_OnLoad()
	PET_IMPACT_CTL[1] = PetFrame_Buff1;
	PET_IMPACT_CTL[2] = PetFrame_Buff2;
	PET_IMPACT_CTL[3] = PetFrame_Buff3;
	PET_IMPACT_CTL[4] = PetFrame_Buff4;
	PET_IMPACT_CTL[5] = PetFrame_Buff5;
	PET_IMPACT_CTL[6] = PetFrame_Buff6;
end

function PetFrame_OnEvent( event )
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		--this:Show();
		PetFrame_Update();
		return;
	elseif( event == "UPDATE_PET_PAGE") then
		PetFrame_Update();
	end
end

function PetFrame_Update()
	--查找战斗珍兽
	local nPetCount = Pet : GetPet_Count();
		
	if nPetCount < 1 then
		PetFrame_Clear();
		this:Hide();
		return;
	end
	
	g_FightPet = -1;
	for	i=1, PET_MAX_NUMBER do
		if Pet:IsPresent(i-1) then
			if(Pet : GetIsFighting(i-1)) then
				g_FightPet = i-1;
			end
		end
	end
	
	if(g_FightPet < 0 ) then
		PetFrame_Clear();
		this:Hide();
		return;
	end
	
	--战斗珍兽头像
	local szPortrait = Pet:GetPetPortraitByIndex(g_FightPet);
	if(nil ~= szPortrait and "" ~= szPortrait) then
		PetFrame_Header:SetProperty("Image", tostring(szPortrait));
		--AxTrace(0,0, "珍兽头像" .. szPortrait);
		PetFrame_Header:Show();
	end
	
	--战斗珍兽的HP/HPMAX
	PET_HP = Pet : GetHP(g_FightPet);
	PET_MAXHP = Pet:	GetMaxHP(g_FightPet);

	PetFrame_HP:SetProgress(PET_HP, PET_MAXHP);
	if( PET_HP / PET_MAXHP > 0.3 ) then
		PetFrame_HP_Flash:Play( false );
	else
		PetFrame_HP_Flash:Play( true );
	end
	
	PET_EXP,PET_MAXEXP = Pet : GetExp(g_FightPet);
	PetFrame_Exp:SetProgress(PET_EXP, PET_MAXEXP);	
	PetFrame_Update_Tooltip( 1 );	
	
	
	--战斗珍兽的Buf
	local nBuffNum = Pet:GetPetImpactNum(g_FightPet);
	if(nBuffNum > PET_BUFF_MAX) then nBuffNum = PET_BUFF_MAX; end
	
	local i = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;
		
		szIconName,szTipInfo = Pet:GetPetImpactIconNameByIndex(g_FightPet, i);
		PET_IMPACT_CTL[i+1]:SetProperty("ShortImage", szIconName);
		PET_IMPACT_CTL[i+1]:Show();
		PET_IMPACT_CTL[i+1]:SetToolTip(szTipInfo);
		i = i + 1;
	end
	
	while i < PET_BUFF_MAX do
		PET_IMPACT_CTL[i+1]:SetToolTip("");
		PET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
	--显示等级
	local nNumber = Pet:GetLevel(g_FightPet);
	PetFrame_Level:SetText("#cDED784"..tostring(nNumber));
	this:Show();
end

function PetFrame_Clear()
	local i = 0;
	while i < PET_BUFF_MAX do
		PET_IMPACT_CTL[i+1]:SetToolTip("");
		PET_IMPACT_CTL[i+1]:Hide();
		i = i + 1;
	end
	
	PET_HP = 0;
	PET_MAXHP = 1;
	PetFrame_HP:SetProgress(PET_HP, PET_MAXHP);
	PetFrame_Exp:SetProgress(PET_EXP, PET_MAXEXP);	
	PetFrame_Header:Hide();
	--PetFrame_HP_Text:SetText("");
	--PetFrame_HP_Text:SetProperty("MouseHollow", "True");
	PetFrame_HP:SetToolTip("");
end

function PetFrame_ShowMenu()
	Pet:ShowMyPetContexMenu();	
end

function PetFrame_HP_Text_MouseEnter()
	PetFrame_Update_Tooltip( 1 );	
end

function PetFrame_HP_Text_MouseLeave()
	MousePos = 0;
	--PetFrame_Update_Tooltip( 0 );		
end

function PetFrame_Update_Tooltip( arg )
	PetFrame_HP:SetToolTip("血:"..tostring( PET_HP ) .. "/" .. tostring( PET_MAXHP).."#r".."经验:"..tostring( PET_EXP ).."/"..tostring( PET_MAXEXP ) );
	PetFrame_Exp:SetToolTip("血:"..tostring( PET_HP ) .. "/" .. tostring( PET_MAXHP).."#r".."经验:"..tostring( PET_EXP ).."/"..tostring( PET_MAXEXP ) );
	
end

function PetFrame_SetFightPetAsTarget()
	Pet:SetFightPetAsMainTarget();
end