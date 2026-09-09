
local XINFA_BUTTONS_NUM = 8;
local XINFA_BUTTONS = {};

local SKILL_BUTTONS_NUM = 5;
local SKILL_BUTTONS = {};

local g_XinfaID = {};
local g_XinfaDefineID = {};

local g_SkillID = {};

-- 当前选中的Button，如果选中的是Xinfa，值等于Xinfa的nIndex
-- 									 如果选中的是Skill，值等于Skill的nIndex + XINFA_BUTTONS_NUM
local g_CurSelectButton;

-- 当前选中的心法
local g_CurSelect;

--当前选中的心法Id
local g_CurSelectXinfaId;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;


local MenPai_UsedAttr = {
[0] = {image = "set:Menpaishuxing image:Shuxing_Dark", Tooltip = "MPZSX_20071221_13", },			--少林
[1] = {image = "set:Menpaishuxing image:Shuxing_Fire", Tooltip = "MPZSX_20071221_12",},			--明教
[2] = {image = "set:Menpaishuxing image:Shuxing_PoisonFire", Tooltip = "MPZSX_20071221_15",},		--丐帮
[3] = {image = "set:Menpaishuxing image:Shuxing_DarkIce", Tooltip = "MPZSX_20071221_16",},		--武当
[4] = {image = "set:Menpaishuxing image:Shuxing_IceDark", Tooltip = "MPZSX_20071221_17",},		--峨眉
[5] = {image = "set:Menpaishuxing image:Shuxing_Poison", Tooltip = "MPZSX_20071221_14",},			--星宿
[6] = {image = "set:Menpaishuxing image:Shuxing_FIPD", Tooltip = "MPZSX_20071221_18",}, --天龙
[7] = {image = "set:Menpaishuxing image:Shuxing_Ice", Tooltip = "MPZSX_20071221_11",},			--天山
[8] = {image = "set:Menpaishuxing image:Shuxing_FirePoison", Tooltip = "MPZSX_20071221_19",},		--逍遥
[9] = {image = "", Tooltip = "无门派",},	--无门派
};



--===============================================
-- OnLoad()
--===============================================
function ActionSkillsStudy_PreLoad()

	this:RegisterEvent("TOGLE_SKILLSTUDY");
	this:RegisterEvent("SKILLSTUDY_SUCCEED");
	this:RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("UNIT_EXP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("MONEYJZ_CHANGE");
	
end

function ActionSkillsStudy_OnLoad()
	XINFA_BUTTONS[1] = ActionSkillsStudy_XinfaSkill_1;
	XINFA_BUTTONS[2] = ActionSkillsStudy_XinfaSkill_2;
	XINFA_BUTTONS[3] = ActionSkillsStudy_XinfaSkill_3;
	XINFA_BUTTONS[4] = ActionSkillsStudy_XinfaSkill_4;
	XINFA_BUTTONS[5] = ActionSkillsStudy_XinfaSkill_5;
	XINFA_BUTTONS[6] = ActionSkillsStudy_XinfaSkill_6;
	XINFA_BUTTONS[7] = ActionSkillsStudy_XinfaSkill_7;
	XINFA_BUTTONS[8] = ActionSkillsStudy_XinfaSkill_8;

	SKILL_BUTTONS[1] = ActionSkillsStudy_ZhaoshiSkill_1;
	SKILL_BUTTONS[2] = ActionSkillsStudy_ZhaoshiSkill_2;
	SKILL_BUTTONS[3] = ActionSkillsStudy_ZhaoshiSkill_3;
	SKILL_BUTTONS[4] = ActionSkillsStudy_ZhaoshiSkill_4;
	SKILL_BUTTONS[5] = ActionSkillsStudy_ZhaoshiSkill_5;

	g_CurSelectButton = 1;
	g_CurSelect				= 1;

end

--===============================================
-- ActionSkillsStudy_OnEvent
--===============================================
function ActionSkillsStudy_OnEvent(event)

	if(event == "TOGLE_SKILLSTUDY") then
		--关心NPC
		objCared = tonumber(arg0);
		this:CareObject(objCared, 1, "ActionSkillsStudy");

		this:Show();
		ActionSkillsStudy_UpdateFrame();
		ActionSkillsStudy_NpcName:SetText("#gFF0FA0" ..Target:GetXinfaNpcName());

	--刷新金钱
	elseif(event == "UNIT_MONEY") then
		local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

		ActionSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--刷新交子
	elseif (event == "MONEYJZ_CHANGE") then
		ActionSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));	
	--刷新经验值
	elseif(event == "UNIT_EXP") then

		local nExpNow = Player:GetData("EXP");
		ActionSkillsStudy_CurrentlyExp_Character_Text:SetText("当前经验:" .. tostring(nExpNow));
	
	-- 人物升级
	elseif(event == "UNIT_LEVEL") then
		ActionSkillsStudy_UpdateFrame();
		
	elseif(event == "SKILLSTUDY_SUCCEED") then
		ActionSkillsStudy_UpdateFrame();

	elseif (event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "ActionSkillsStudy");
		end

	end
end

--===============================================
-- UpdateFrame
--===============================================
function ActionSkillsStudy_UpdateFrame()

	-- Xinfa
	local i=1;
	local nActionIndex = 0;
	
	local nPlayerLevel = Player:GetData("LEVEL")

	--绘制心法图标
	while i<= XINFA_BUTTONS_NUM do

		local theAction = EnumAction(nActionIndex, "xinfa");

		if (theAction:GetID() == 0) then
			XINFA_BUTTONS[i]:SetActionItem(-1);
			g_XinfaID[i] = -1;
			g_XinfaDefineID[i] = -1;
		else
			XINFA_BUTTONS[i]:SetActionItem(theAction:GetID());
			--记录每个格子的心法ID
			g_XinfaID[i] = theAction:GetID();
			g_XinfaDefineID[i] = theAction:GetDefineID();
			
			-- 如果玩家不到20级，那么他将有部分的心法不能升级
			if nPlayerLevel < 20  then
				XINFA_BUTTONS[2]:Disable()
				XINFA_BUTTONS[3]:Disable()
				XINFA_BUTTONS[6]:Disable()
			else
				XINFA_BUTTONS[2]:Enable()
				XINFA_BUTTONS[3]:Enable()
				XINFA_BUTTONS[6]:Enable()
			end
		end


		i = i+1;
		nActionIndex = nActionIndex + 1;

	end

	--玩家身上金钱
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = Player:GetData("MONEY");

	ActionSkillsStudy_Currently_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	ActionSkillsStudy_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	--ActionSkillsStudy_Icon_Gold_Currently_Text:SetText(tostring(nGold));
	--ActionSkillsStudy_Icon_Silver_Currently_Text:SetText(tostring(nSilverCoin));
	--ActionSkillsStudy_Icon_CopperCoin_Currently_Text:SetText(tostring(nCopperCoin));

	--玩家已经取得的经验
	local nExpNow = Player:GetData("EXP");
	ActionSkillsStudy_CurrentlyExp_Character_Text:SetText("当前经验:" .. tostring(nExpNow));

	--更新当前选中的心法的技能
	ActionSkillsStudy_Xinfa_Clicked(g_CurSelect);
	--更新主属性信息
	ActionSkillsStudy_UpdateMenPaiText();

end

--===============================================
-- 技能的更新绘制
--===============================================
function ActionSkillsStudy_UpdateSkill( nIndex )

	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetActionItem(-1);
		g_SkillID[i] = -1;
	end

		local nSumSkill = GetActionNum("skill");
		local nSkillIndex = 1;

		--AxTrace(0,0,"nSumSkill = ".. nSumSkill);


		for i=1, nSumSkill do
			theAction = EnumAction(i-1, "skill");

			if theAction:GetOwnerXinfa() == g_XinfaID[nIndex] then
				SKILL_BUTTONS[nSkillIndex]:SetActionItem(theAction:GetID());
				g_SkillID[nSkillIndex] = theAction:GetID();
				--AxTrace(0,0,"g_SkillID[nSkillIndex] = ".. g_SkillID[nSkillIndex]);
				nSkillIndex = nSkillIndex+1;
			end
		end
end

--===============================================
-- 更新一个技能图标的操作
--===============================================
function ActionSkillsStudy_SkillInfo_Update( SkillID )

	--ActionSkillsStudy_XinfaSkillIcon_Frame:Hide();
	ActionSkillsStudy_XinfaIcon:Hide();
	--ActionSkillsStudy_ZhaoshiSkillIcon_Frame:Show();
	ActionSkillsStudy_SkillIcon:Show();

	ActionSkillsStudy_SkillIcon:SetActionItem( -1 );
	ActionSkillsStudy_SkillIcon:SetActionItem( SkillID );

	if(SkillID == -1)then

		--清空技能
		ActionSkillsStudy_SkillName:SetText("");
		ActionSkillsStudy_SkillLevel:SetText("");
		ActionSkillsStudy_SkillInfo:SetText("");

		return;
	end

	local nSkillId = LifeAbility : GetLifeAbility_Number(SkillID);


	--更新技能信息
	local szInfo = Player:GetSkillInfo(nSkillId,"explain");
	local szName = Player:GetSkillInfo(nSkillId,"name");
	--local szSkillData = Player:GetSkillInfo(nSkillId,"skilldata");

	ActionSkillsStudy_SkillName:SetText(szName);
	ActionSkillsStudy_SkillLevel:SetText("");
	ActionSkillsStudy_SkillInfo:SetText(szInfo);

end

--===============================================
-- 更新一个心法图标的操作
--===============================================
function ActionSkillsStudy_XinfaInfo_Update( nIndex )--XinfaID

	ActionSkillsStudy_SkillIcon:Hide();
	--ActionSkillsStudy_ZhaoshiSkillIcon_Frame:Hide();
	ActionSkillsStudy_XinfaIcon:Show();
	--ActionSkillsStudy_XinfaSkillIcon_Frame:Show();

	ActionSkillsStudy_XinfaIcon:SetActionItem( -1 );
	ActionSkillsStudy_XinfaIcon:SetActionItem( g_XinfaID[nIndex] );

	--获得现在的心法等级
	local nXinfaLevel = GetXinfaLevel( g_XinfaDefineID[nIndex] );

	--获得升级心法需要的金钱
	local nMoneyNow,nGold,nSilverCoin,nCopperCoin = GetUplevelXinfaSpendMoney(g_XinfaDefineID[nIndex],nXinfaLevel + 1);
	--获得升级心法需要的经验
	local nExp = GetUplevelXinfaSpendExp(g_XinfaDefineID[nIndex],nXinfaLevel + 1);

	--ActionSkillsStudy_Demand_Money:SetProperty("MoneyNumber", tostring(nMoneyNow));
	ActionSkillsStudy_Demand_Jiaozi:SetProperty("MoneyNumber", tostring(nMoneyNow));
	--ActionSkillsStudy_Icon_Gold_Demand_Text:SetText(tostring(nGold));
	--ActionSkillsStudy_Icon_Silver_Demand_Text:SetText(tostring(nSilverCoin));
	--ActionSkillsStudy_Icon_CopperCoin_Demand_Text:SetText(tostring(nCopperCoin));

	ActionSkillsStudy_DemandExp_Character_Text:SetText("所需经验:" .. tostring(nExp));

end

--===============================================
-- 玩家点击学习的响应
--===============================================
function ActionSkillsStudy_UpLevel_Clicked()
	--AxTrace(0, 0, "ActionSkillsStudy_Study" );

	--if (g_CurSelectButton < 1  or  g_CurSelectButton > XINFA_BUTTONS_NUM) then
	--	return;
		--需要提示不能升级技能
	--end

	-- 处理学习
	SkillsStudyFrame_study( g_XinfaDefineID[g_CurSelect] );
end

--===============================================
-- 选中一个心法图标
--===============================================
function ActionSkillsStudy_Xinfa_Clicked(nIndex)

	--AxTrace(0, 0, "ActionSkillsStudy_Xinfa_Clicked " ..nIndex );
	-- 数据超过范围，返回
	if(nIndex < 1 or nIndex > XINFA_BUTTONS_NUM) then
		return;
	end

	if g_XinfaID[nIndex] == -1 then
		return
	end

	local i = 1;
	for i=1, XINFA_BUTTONS_NUM do
		if(i==nIndex) then
			XINFA_BUTTONS[i]:SetPushed(1);
		else
			XINFA_BUTTONS[i]:SetPushed(0);
		end
	end

	local i = 1;
	for i=1, SKILL_BUTTONS_NUM do
		SKILL_BUTTONS[i]:SetPushed(0);
	end

	local nXinfaId = LifeAbility : GetLifeAbility_Number(g_XinfaID[nIndex]);

	--更新技能的说明
	local strName = Player:GetXinfaInfo(nXinfaId,"name");
	local nLevel= Player:GetXinfaInfo(nXinfaId,"level");
	local strInfo = Player:GetXinfaInfo(nXinfaId,"explain");

	ActionSkillsStudy_SkillName:SetText(strName);
	ActionSkillsStudy_SkillLevel:SetText("当前等级:".. nLevel);
	ActionSkillsStudy_SkillInfo:SetText(strInfo);

	--更新技能
	ActionSkillsStudy_UpdateSkill( nIndex );

	--更新说明内容
	ActionSkillsStudy_XinfaInfo_Update( nIndex );

	g_CurSelectButton = nIndex;
	g_CurSelect				= nIndex;
end

--===============================================
-- 选中一个技能图标
--===============================================
function ActionSkillsStudy_Skill_Clicked(nIndex)

	local i = 1;
	for i=1, SKILL_BUTTONS_NUM do
		if(i==nIndex) then
			SKILL_BUTTONS[i]:SetPushed(1);
		else
			SKILL_BUTTONS[i]:SetPushed(0);
		end
	end

	--AxTrace(0, 0, "ActionSkillsStudy_Skill_Clicked  " ..nIndex );
	if(nIndex < 1 or nIndex > SKILL_BUTTONS_NUM) then
		return;
	end

	g_CurSelectButton = nIndex + XINFA_BUTTONS_NUM;

	--更新说明内容
	ActionSkillsStudy_SkillInfo_Update( g_SkillID[nIndex] )

end


--===============================================
-- Close
--===============================================
function ActionSkillsStudy_Close_Cilcked()
	this:Hide()
	--取消关心
	this:CareObject(objCared, 0, "ActionSkillsStudy");

end


function ActionSkillsStudy_ClearStaticImage()
	ActionSkillsStudy_MenPai_ICON : SetProperty("Tooltip", "");
	ActionSkillsStudy_MenPai_ICON : SetProperty("Image","");
end

function ActionSkillsStudy_UpdateMenPaiText()
	local menpaiID = Player : GetData("MEMPAI");		--获取玩家门派ID
	if menpaiID ~= nil and menpaiID >=0 and menpaiID <=9 then
		if (menpaiID == 9) then
			ActionSkillsStudy_ClearStaticImage();
			ActionSkillsStudy_MenPai_Attr_Intro : SetText(""); --一般来说这里不会被调到
			return;
		end
		local	str = GetDictionaryString( "MPZSX_20071221_0" .. (menpaiID +1) );
		ActionSkillsStudy_MenPai_Attr_Intro : SetText("#Y" .. str);
		--ActionSkillsStudy_ClearStaticImage();

		ActionSkillsStudy_MenPai_ICON : SetToolTip(GetDictionaryString(MenPai_UsedAttr[menpaiID].Tooltip));
		ActionSkillsStudy_MenPai_ICON : SetProperty("Image",MenPai_UsedAttr[menpaiID].image);
	end
end
