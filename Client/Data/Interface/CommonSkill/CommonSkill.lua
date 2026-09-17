local COMMON_BUTTONS = {};
--local COMMON_LEVEL = {};
local COMMON_INDEX = {};
local Current = 1;
local COMMON_BUTTONS_NUM = 20;
local Current_Page = 0;

function CommonSkill_PreLoad()
	this:RegisterEvent("TOGLE_LIFE_PAGE");
	this:RegisterEvent("TOGLE_SKILL_BOOK");
	this:RegisterEvent("TOGLE_COMMONSKILL_PAGE");
	this:RegisterEvent("UPDATE_LIFESKILL_PAGE");
	this:RegisterEvent("SKILL_UPDATE");
	this:RegisterEvent("CLOSE_SKILL_BOOK");
end
	
function CommonSkill_OnLoad()
	COMMON_BUTTONS[1] = CommonSkill_Skill1;
	COMMON_BUTTONS[2] = CommonSkill_Skill2;
	COMMON_BUTTONS[3] = CommonSkill_Skill3;
	COMMON_BUTTONS[4] = CommonSkill_Skill4;
	COMMON_BUTTONS[5] = CommonSkill_Skill5;
	COMMON_BUTTONS[6] = CommonSkill_Skill6;
	COMMON_BUTTONS[7] = CommonSkill_Skill7;
	COMMON_BUTTONS[8] = CommonSkill_Skill8;
	COMMON_BUTTONS[9] = CommonSkill_Skill9;
	COMMON_BUTTONS[10] = CommonSkill_Skill10;
	COMMON_BUTTONS[11] = CommonSkill_Skill11;
	COMMON_BUTTONS[12] = CommonSkill_Skill12;
	COMMON_BUTTONS[13] = CommonSkill_Skill13;
	COMMON_BUTTONS[14] = CommonSkill_Skill14;
	COMMON_BUTTONS[15] = CommonSkill_Skill15;
	COMMON_BUTTONS[16] = CommonSkill_Skill16;
	COMMON_BUTTONS[17] = CommonSkill_Skill17;
	COMMON_BUTTONS[18] = CommonSkill_Skill18;
	COMMON_BUTTONS[19] = CommonSkill_Skill19;
	COMMON_BUTTONS[20] = CommonSkill_Skill20;
	
--	COMMON_LEVEL[1] = CommonSkill_Skill1_Text;
--	COMMON_LEVEL[2] = CommonSkill_Skill2_Text;
--	COMMON_LEVEL[3] = CommonSkill_Skill3_Text;
--	COMMON_LEVEL[4] = CommonSkill_Skill4_Text;
--	COMMON_LEVEL[5] = CommonSkill_Skill5_Text;
--	COMMON_LEVEL[6] = CommonSkill_Skill6_Text;
--	COMMON_LEVEL[7] = CommonSkill_Skill7_Text;
--	COMMON_LEVEL[8] = CommonSkill_Skill8_Text;
--	COMMON_LEVEL[9] = CommonSkill_Skill9_Text;
--	COMMON_LEVEL[10] = CommonSkill_Skill10_Text;
--	COMMON_LEVEL[11] = CommonSkill_Skill11_Text;
--	COMMON_LEVEL[12] = CommonSkill_Skill12_Text;
--	COMMON_LEVEL[13] = CommonSkill_Skill13_Text;
--	COMMON_LEVEL[14] = CommonSkill_Skill14_Text;
--	COMMON_LEVEL[15] = CommonSkill_Skill15_Text;
--	COMMON_LEVEL[16] = CommonSkill_Skill16_Text;
--	COMMON_LEVEL[17] = CommonSkill_Skill17_Text;
--	COMMON_LEVEL[18] = CommonSkill_Skill18_Text;
--	COMMON_LEVEL[19] = CommonSkill_Skill19_Text;
--	COMMON_LEVEL[20] = CommonSkill_Skill20_Text;
	
	for i=1,20 do
		COMMON_INDEX[i] = -1;
--		COMMON_LEVEL[i] :SetText("");
	end;
	
	CommonSkill_SetTabColor();
end

function CommonSkill_OnEvent(event)

	if ( event == "TOGLE_COMMONSKILL_PAGE" ) then
		local selfUnionPos = Variable:GetVariable("SkillUnionPos");
		if(selfUnionPos ~= nil) then
			CommonSkill_Frame:SetProperty("UnifiedPosition", selfUnionPos);
		end
		CommonSkill_Open();
		CommonSkill_Update();
		return;
	elseif ( event == "SKILL_UPDATE" and this:IsVisible() ) then
		CommonSkill_Update();
	elseif ( event == "TOGLE_SKILL_BOOK" ) then
		CommonSkill_Close();
	elseif ( event == "TOGLE_LIFE_PAGE" ) then
		CommonSkill_Close();
	elseif ( event == "CLOSE_SKILL_BOOK" ) then
		CommonSkill_Close();
	end

end

function CommonSkill_OnShown()
	CommonSkill_Update();
end

function CommonSkill_Update()
	AxTrace(0,1,"here")

	CommonSkill_Target_Skill_Name : SetText("");
	CommonSkill_Target_Skill_Explain : SetText("");
	CommonSkill_Target_Skill:SetActionItem(-1);
	CommonSkill_ActionSkill : SetCheck(0);
	CommonSkill_LifeSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1);

	if Current_Page == 0 then
		CommonSkill_PageUp : Disable();
	else
		CommonSkill_PageUp : Enable();
	end
	
--	local nLifeAbilityCount = GetActionNum("life");
--	local i=1;

--	while i <= nLifeAbilityCount do
--		local theAction = EnumAction(i-1, "life");

--		if theAction:GetID() ~= 0 then
--			LIFE_BUTTONS[i]:SetActionItem(theAction:GetID());
--			LIFE_INDEX[i] = theAction:GetID();

--			local lifeid =	LifeAbility : GetLifeAbility_Number(LIFE_INDEX[i]);
--			local life_level= Player:GetAbilityInfo(lifeid,"level");
--			LIFE_LEVEL[i] : SetText(life_level);
--		end
--		i = i+1;
--	end
	
	local nSumSkill = GetActionNum("skill");
	local nCommonIndex = 1;
	
	for i=1, COMMON_BUTTONS_NUM do
		COMMON_BUTTONS[i]:SetActionItem(-1);
		COMMON_INDEX[i] = -1;
	end
	local Begin_Index = 0;
	local nSumCommonSkill = 0;
	if(Current_Page==0)then
		nCommonIndex = 3;
		local thePetFight = Pet:GetPetFightAction();
		local thePetRelex = Pet:GetPetRelaxAction();
		if(thePetFight:GetID() and thePetRelex:GetID())then
			COMMON_BUTTONS[1]:SetActionItem(thePetFight:GetID());
			COMMON_BUTTONS[2]:SetActionItem(thePetRelex:GetID());
			COMMON_INDEX[1] = thePetFight:GetID();
			COMMON_INDEX[2] = thePetRelex:GetID();
		end
	end
	for i=1, nSumSkill do
		theAction = EnumAction(i-1, "skill");
		if theAction:GetOwnerXinfa() == -9999 then			
			nSumCommonSkill = nSumCommonSkill + 1;
			if(Current_Page==0) then
				if(nSumCommonSkill == 1)then
					Begin_Index = i;
				end
			else
				if nSumCommonSkill == Current_Page*COMMON_BUTTONS_NUM+1-2  then
					Begin_Index = i;
				end	
			end
	
		end
	end
	
	
	AxTrace(0,1,"nSumCommonSkill="..nSumCommonSkill)
	
	--PushDebugMessage("sumcommon:"..tostring(nSumCommonSkill)..",index:"..tostring(Begin_Index)..",page:"..tostring(Current_Page)..",sumskill:"..tostring(nSumSkill))
	
	--bug30290，alan，2007-12-26
	--前面的代码在普通技能第一页添加了珍兽出战与珍兽休息两个技能，这样相当于普通技能的总数实际上多了2个
	--在判断是否允许翻页按钮时也需要考虑这多出来的2个技能
	--if (Current_Page+1)*COMMON_BUTTONS_NUM <= nSumCommonSkill then
	if (Current_Page+1)*COMMON_BUTTONS_NUM < nSumCommonSkill+2 then
		CommonSkill_PageDown : Enable();
	else
		CommonSkill_PageDown : Disable();
	end
	
	AxTrace(0,1,"Current_Page="..Current_Page)
	--1+Current_Page*COMMON_BUTTONS_NUM
	if Begin_Index~=0 then
		for i=Begin_Index, nSumSkill do
			theAction = EnumAction(i-1, "skill");
			if theAction:GetOwnerXinfa() == -9999 then
	
				COMMON_BUTTONS[nCommonIndex]:SetActionItem(theAction:GetID());
				COMMON_INDEX[nCommonIndex] = theAction:GetID();
				local nCommonId = LifeAbility : GetLifeAbility_Number(COMMON_INDEX[nCommonIndex]);
				
				if(Player:GetSkillInfo(nCommonId,"learn")) then
					COMMON_BUTTONS[nCommonIndex] : Enable();
				else
					COMMON_BUTTONS[nCommonIndex] : Disable();
				end
				
				nCommonIndex = nCommonIndex+1;
	
				if nCommonIndex > COMMON_BUTTONS_NUM then
					break;
				end
			end
		end
	end
	
	if(COMMON_INDEX[Current] ~= -1) then
		CommonSkill_Buttons_Clicked(Current);
	end;
	
end

function CommonSkill_Buttons_Clicked(nIndex)

	if( COMMON_INDEX[nIndex] == -1) then
		return;
	end;

	COMMON_BUTTONS[Current]:SetPushed(0);
	

--	if( Current == nIndex) then
--		return;
--	end;

	Current = nIndex;
	COMMON_BUTTONS[Current]:SetPushed(1);
	if(Current_Page==0 and (nIndex ==1 or nIndex ==2))then
		local strName = "";
		local strExplan ="";
		local thisAction;
		if(nIndex ==1 )then
			thisAction = Pet:GetPetFightAction();
			strExplan = "#{Action_Pet_Fight_Exp}"; --"#c54FF00（拖至快捷栏中使用）#r#cFFFFFF运气时间：2.5秒#r召唤当前选择的珍兽出战，需要珍兽快乐在60以上。"
		else
			thisAction = Pet:GetPetRelaxAction();
			strExplan = "#{Action_Pet_Relex_Exp}";--"#c54FF00（拖至快捷栏中使用）#r#cFFFFFF运气时间：2.5秒#r召唤当前选择的珍兽出战，需要珍兽快乐在60以上。"
		end
		strName = thisAction:GetName();
		CommonSkill_Target_Skill_Name : SetText( strName );
		CommonSkill_Target_Skill_Explain : SetText( strExplan);

	else
		local commonid =	LifeAbility : GetLifeAbility_Number(COMMON_INDEX[nIndex]);
		local strName = Player:GetSkillInfo(commonid,"name");
		CommonSkill_Target_Skill_Name : SetText( strName );
	
		strName = Player:GetSkillInfo(commonid,"explain");
		strName2 = Player:GetSkillInfo(commonid,"skilldata");
		CommonSkill_Target_Skill_Explain : SetText( strName.."\n"..strName2 );
	end



	
	CommonSkill_Target_Skill:SetActionItem(COMMON_INDEX[nIndex]);

	if(Player:GetSkillInfo(commonid,"passivity") == 0) then
		CommonSkill_Use : Show();
--	else
--		CommonSkill_OnClose();
	end
	
end

function CommonSkill_Button_Clicked()

	if (Current ~= -1 and COMMON_INDEX[Current] ~= -1) then	
		if(Current_Page==0 and (Current ==1 or Current ==2))then
			local thisAction;
			if(Current ==1 )then
				thisAction = Pet:GetPetFightAction();
			else
				thisAction = Pet:GetPetRelaxAction();
			end
			if(thisAction:GetID()~=0)then
				CommonSkill_Target_Skill:DoAction();
			end
		else
			local commonid =	LifeAbility : GetLifeAbility_Number(COMMON_INDEX[Current]);
		
			if(Player:GetSkillInfo(commonid,"passivity") == 0) then
				CommonSkill_Target_Skill:DoAction();
			end
		end

	end
		
end

function Common_Action_Page_Switch()
	local menpai = Player:GetData("MEMPAI");
	if(menpai == 9) then
		CommonSkill_ActionSkill : SetCheck(0);
		CommonSkill_LifeSkill : SetCheck(0);
		CommonSkill_CommonlySkill : SetCheck(1);
		PushDebugMessage("你还没有拜入门派。");
		return; 
	end;
	OpenSkillBook();
	CommonSkill_OnClose();
	CommonSkill_ActionSkill : SetCheck(0);
	CommonSkill_LifeSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1);
end

function Common_Life_Page_Switch()
	OpenLifePage();
	CommonSkill_OnClose();
	CommonSkill_ActionSkill : SetCheck(0);
	CommonSkill_LifeSkill : SetCheck(0);
	CommonSkill_CommonlySkill : SetCheck(1);
end

function CommonSkill_SetTabColor()
	
	--AxTrace(0,0,tostring(idx));
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = CommonSkill_CommonlySkill,
								CommonSkill_ActionSkill,
								CommonSkill_LifeSkill,
							};

	local TAB_TEXT = {
		[0] = "普通",
		"门派",
		"生活",
	};
	
	tab[0]:SetText(selColor..TAB_TEXT[0]);
	tab[1]:SetText(noselColor..TAB_TEXT[1]);
	tab[2]:SetText(noselColor..TAB_TEXT[2]);
end

function CommonSkill_Page(nPage)
	
	Current_Page = Current_Page + nPage;

	CommonSkill_Update();

end

function CommonSkill_OnClose()
	Variable:SetVariable("SkillUnionPos", CommonSkill_Frame:GetProperty("UnifiedPosition"), 1);
	CommonSkill_Close();
end



function CommonSkill_Open()
	this:Show();
end
function CommonSkill_Close()
	this:Hide();
end