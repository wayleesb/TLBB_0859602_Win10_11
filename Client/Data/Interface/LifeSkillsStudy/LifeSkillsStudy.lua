local g_nAbilityID = -1;

local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;

--===============================================
-- OnLoad()
--===============================================
function LifeSkillsStudy_PreLoad()

	this:RegisterEvent("TOGLE_ABILITY_STUDY");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("OBJECT_CARED_EVENT");

end

function LifeSkillsStudy_OnLoad()
	
end										

--===============================================
-- LifeSkillsStudy_OnEvent
--===============================================
function LifeSkillsStudy_OnEvent(event)
	if(event == "TOGLE_ABILITY_STUDY") then
		this:Show();
		
		--设置关心NPC
		objCared = LifeAbility:GetNpcId();
		this:CareObject(objCared, 1, "AbilityStudy");
	
		LifeSkillsStudy_UpdateFrame();
		LifeSkillsStudy_UpLevel:Enable();

	elseif(event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			Bank:Close();

			--取消关心
			this:CareObject(objCared, 0, "AbilityStudy");
		end
		
	elseif(event == "UNIT_MONEY" and this:IsVisible()) then
		local nMoneyNow = Player:GetData("MONEY");
		LifeSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
		
	elseif(event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		
		LifeSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
		
	elseif(event == "UNIT_LEVEL" and this:IsVisible()) then 
		
		
	elseif(event == "UNIT_EXP" and this:IsVisible()) then
		local nExpNow = Player:GetData("EXP");
		LifeSkillsStudy_CurrentlyExp_Character_Text:SetText("当前经验:" .. tostring(nExpNow));
		
	end
	
end

--===============================================
-- LifeSkillsStudy_UpdateFrame
--===============================================
function LifeSkillsStudy_UpdateFrame()

	--技能ID
	g_nAbilityID = AbilityTeacher:GetAbilityID();
	
	
	--当前的金钱
	local nMoneyNow = Player:GetData("MONEY");
	LifeSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	
	--当前的交子
	LifeSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));

	--需要的金钱
	nMoneyNow,nGold,nSilverCoin,nCopperCoin = AbilityTeacher:GetNeedMoney();
	LifeSkillsStudy_Demand_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));

	--当前的经验
	local nExpNow = Player:GetData("EXP");
	LifeSkillsStudy_CurrentlyExp_Character_Text:SetText("当前经验:" .. tostring(nExpNow));
	
	--需要的经验
	local nNeedExp = AbilityTeacher:GetNeedExp();
	LifeSkillsStudy_DemandExp_Character_Text:SetText("所需经验:" .. tostring(nNeedExp));

	ActionSkillsStudy_UpdateAbility(g_nAbilityID);
end


--===============================================
-- 更新生活技能
--===============================================
function ActionSkillsStudy_UpdateAbility(nAbilityID)

	local nAbilityNum = GetActionNum("life");
	
	for i=0, nAbilityNum do
	
		local theAction = EnumAction(i, "life");
		if theAction:GetDefineID() == nAbilityID then
		
			if theAction:GetID() == 0 then
				LifeSkillsStudy_Icon:SetActionItem(-1);
			else
				LifeSkillsStudy_Icon:SetActionItem(theAction:GetID());
				
				-- 生活技能名字
				local szName = theAction:GetName();
				-- 生活技能的等级
				local nLevel = Player:GetAbilityInfo(nAbilityID, "level");
				-- 生活技能的最大等级
				local nMaxLevel = Player:GetAbilityInfo(nAbilityID, "maxlevel");
				-- 生活技能熟练度
				local nSkillExp = Player:GetAbilityInfo(nAbilityID, "skillexp");
				-- 生活技能解释
				local szExplain = Player:GetAbilityInfo(nAbilityID, "explain");			
				
				local nNeedLevel    = AbilityTeacher:GetNeedLevel();
				-- local nLevel        = Player:GetData("LEVEL");
				
				local nNeedSkillExp = AbilityTeacher:GetNeedSkillExp();
				
				LifeSkillsStudy_SkillName:SetText(szName);
				LifeSkillsStudy_SkillLevel:SetText("技能等级:".. tostring(nLevel).."/"..tostring(nMaxLevel));
				LifeSkillsStudy_skilledDegree:SetText("当前熟练度:"..tostring(nSkillExp) .. "/" .. tostring(nNeedSkillExp) );
				LifeSkillsStudy_PlayerLevel:SetText("玩家等级要求:" .. tostring(nNeedLevel));
				
				LifeSkillsStudy_Explain_Desc:SetText("  "..szExplain);
			end
		end
	end

end

function LifeSkillsStudy_UpLevel_Click()


	-- 获得服务器脚本的一些数据，然后再次去调用服务器的这些数据
	local ScriptId = AbilityTeacher:GetServerData("scriptid");
	local NpcId    = AbilityTeacher:GetServerData("npcid");

	Player:AskLeanAbility(g_nAbilityID, NpcId);
	
	--不关闭窗口，只将窗口学习按钮Disable
	LifeSkillsStudy_UpLevel:Disable();
	--this:Hide()
	
		
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnDefaultEvent");
		Set_XSCRIPT_ScriptID(ScriptId);
		Set_XSCRIPT_Parameter(0,NpcId);
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	
	--this:CareObject(objCared, 0, "AbilityStudy");

end 


function LifeSkillsStudy_Close()
	this:Hide()
	this:CareObject(objCared, 0, "AbilityStudy");

	
end