
local PETSKILL_BUTTONS_NUM = 12;
local PETSKILL_BUTTONS = {};

local g_serverNpcId = -1;
local g_clientNpcId = -1;

local g_selidx = -1;					--当前选择的珍兽索引
local g_selfrm = ""					--选中的技能书来源
local g_pidx = -1					--选中的技能书对应背包内索引
local g_petSkillStudyMoreMoney = 990000

function PetStudyNewSkill_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("UPDATE_PETSKILLSTUDY");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");	
	this:RegisterEvent("CONFIRM_PETSKILLSTUDY");
end



function PetStudyNewSkill_OnLoad()
	PETSKILL_BUTTONS[1] = PetStudyNewSkill_Skill01;
	PETSKILL_BUTTONS[2] = PetStudyNewSkill_Skill02;
	PETSKILL_BUTTONS[3] = PetStudyNewSkill_Skill03;
	PETSKILL_BUTTONS[4] = PetStudyNewSkill_Skill04;
	PETSKILL_BUTTONS[5] = PetStudyNewSkill_Skill05;
	PETSKILL_BUTTONS[6] = PetStudyNewSkill_Skill06;
	PETSKILL_BUTTONS[7] = PetStudyNewSkill_Skill07;
	PETSKILL_BUTTONS[8] = PetStudyNewSkill_Skill08;
	PETSKILL_BUTTONS[9] = PetStudyNewSkill_Skill09;
	PETSKILL_BUTTONS[10] = PetStudyNewSkill_Skill10;
	PETSKILL_BUTTONS[11] = PetStudyNewSkill_Skill11;
	PETSKILL_BUTTONS[12] = PetStudyNewSkill_Skill12;
end



function PetStudyNewSkill_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 223 ) then
		PetStudyNewSkill_OnUICommand();
	elseif( event == "UPDATE_PETSKILLSTUDY" and this:IsVisible() ) then
		PetStudyNewSkill_Update(arg0, arg1);
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		PetStudyNewSkill_Selected(tonumber(arg0));
	elseif ( event == "UPDATE_PET_PAGE" and this:IsVisible() ) then
		PetStudyNewSkill_Show();
	elseif ( event == "DELETE_PET" and this:IsVisible() ) then
		PetStudyNewSkill_Hide();
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetStudyNewSkill_CareEventHandle(arg0,arg1,arg2);
	elseif ( event == "CONFIRM_PETSKILLSTUDY") then
		PetStudyNewSkill_ConfirmPetStudyNewSkill()
	end
end


function PetStudyNewSkill_OnUICommand()
	
	if this:IsVisible() then
		return
	end

	g_serverNpcId = Get_XParam_INT(0);
	g_clientNpcId = Target:GetServerId2ClientId(g_serverNpcId);
	this:CareObject(g_clientNpcId, 1, "PetStudyNewSkill");
	
	g_selidx = -1;
	PetStudyNewSkill_Hide();	
	PetStudyNewSkill_Show();	

end
--选择珍兽
function PetStudyNewSkill_Selected(selidx)
	if( -1 == selidx ) then
		return;
	end

	PetStudyNewSkill_PetModel:SetFakeObject("");
	Pet:SetStudyNewSkillModel(selidx);
	PetStudyNewSkill_PetModel:SetFakeObject( "My_PetStudyNewSkill" );

	--如果当前书和宠都选好了....则计算是否是开新的手动技能格....如果是则多收钱....
	if( g_sleidx ~= selidx and g_pidx ~= -1) then
		if Pet:CheckPetSkillStudyMoreMoneyMode( selidx , g_pidx ) == 1 then
			PetStudyNewSkill_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
		else
			local ptlv = Pet:GetTakeLevel(selidx);
			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
			PetStudyNewSkill_Money:SetProperty("MoneyNumber", tostring(ptM));
		end
	end


	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end

	local i=1;
	local k=1;
	
	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill( selidx, i-1, "petskill");
		i = i + 1;
		if theSkillAction:GetID() ~= 0 then
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k+1;
		end
	end
	
	g_selidx = selidx;	--已经选好了珍兽

	Pet:ClosePetSkillStudyMsgBox()
end
--更新界面
function PetStudyNewSkill_Update(aidxs, pidxs)
	
	local aidx = tonumber(aidxs);
	local pidx = tonumber(pidxs);
	
	if(aidx < 1 or aidx > 1) then
		return;
	end
	
	--解除原来被锁定的物品
	if("package" == g_selfrm) then
		Pet:SkillStudyUnlock(g_pidx);
	end
	
	--设置新的物品
	local action = EnumAction(pidx, "packageitem");
	if(action:GetID() ~= 0) then
		PetStudyNewSkill_Skill1:SetActionItem(action:GetID());
		g_selfrm = "package";
		g_pidx = pidx;
	end
	
	--珍兽打技能书....
	--如果当前书和宠都选好了....则计算是否是开新的手动技能格....如果是则多收钱....
	if g_selidx ~= -1 and action:GetID() ~= 0 then
		if Pet:CheckPetSkillStudyMoreMoneyMode( g_selidx, pidx ) == 1 then
			PetStudyNewSkill_Money:SetProperty( "MoneyNumber", g_petSkillStudyMoreMoney );
		else
			local ptlv = Pet:GetTakeLevel(g_selidx);
			local ptM = PetSkillStudy_GetTakeLevelCostMoney(ptlv);
			PetStudyNewSkill_Money:SetProperty("MoneyNumber", tostring(ptM));
		end
	end

	Pet:ClosePetSkillStudyMsgBox()

end
--关闭
function PetStudyNewSkill_Hide()
	
	Pet:ClosePetSkillStudyMsgBox()

	this:CareObject(g_clientNpcId, 0, "PetStudyNewSkill");
	PetStudyNewSkill_Unlock();
	this:Hide();
	Pet:ShowPetList(-1);
	g_selidx = -1;
	g_stduySkill = false;
	g_selfrm = ""
	g_pidx = -1
end
--左旋转
function PetStudyNewSkill_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetStudyNewSkill_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetStudyNewSkill_PetModel:RotateEnd();
	end

end
--右旋转
function PetStudyNewSkill_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetStudyNewSkill_PetModel:RotateBegin(0.3);
	--向右旋转结束
	else
		PetStudyNewSkill_PetModel:RotateEnd();
	end
end
--技能书栏点击
function PetStudyNewSkill_Btn_Click(aidx)

end

--点击确定
function PetStudyNewSkill_Do()
	
	if (-1 == g_selidx) then
		PushDebugMessage("请选择珍兽。");
		return;
	end
	
	if(-1 == g_pidx) then		
		PushDebugMessage("需要技能书。");
		return;
	end

	local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ");	--交子普及 Vega
	local nM = tonumber(PetStudyNewSkill_Money:GetProperty("MoneyNumber"));
	if( pM < nM) then
		PushDebugMessage("金钱不够，无法学习技能");
		return;
	end
	
	-- 如果是学习两个不同类的手动技能
	if Pet:CheckPetSkillStudyMoreMoneyMode( g_selidx, g_pidx ) == 1 then
		Pet:OpenPetSkillStudyMsgBox()	-- 通知客户端调用 MessageBox_Self 界面
		return
	else
		Pet:SkillStudy_Do( 1, g_selidx , g_pidx);			
		g_stduySkill = true;	--已经学过技能			
	end
end
--珍兽技能学习：两个不同类手动技能确认“学习”（该事件在 MessageBox_Self 界面中的 PET_SKILL_STUDY_CONFIRM 事件中触发）
function PetStudyNewSkill_ConfirmPetStudyNewSkill()
	
	if (-1 == g_selidx) then
		PushDebugMessage(g_selidx)
		PushDebugMessage("请选择珍兽。")
		return
	end
	
	if(-1 == g_pidx) then
		PushDebugMessage("需要技能书。")
		return
	end
	
	local pM = Player:GetData("MONEY") + Player:GetData("MONEY_JZ")   --交子普及 Vega
	local nM = tonumber(PetStudyNewSkill_Money:GetProperty("MoneyNumber"))
	if pM < nM then
		PushDebugMessage("金钱不够，无法学习技能")
		return
	end

	Pet:SkillStudy_Do( 1, g_selidx, g_pidx )

	g_stduySkill = true;	--已经学过技能

end


function PetStudyNewSkill_Show()
	
	if (g_stduySkill == false) then
		PetStudyNewSkill_PetModel:SetFakeObject( "" );
		PetStudyNewSkill_Unlock();
		for i=1, PETSKILL_BUTTONS_NUM do
			PETSKILL_BUTTONS[i]:SetActionItem(-1);
		end

	else
		if -1 ~= g_selidx then
			local i=1;
			local k=1;
			while i <= PETSKILL_BUTTONS_NUM do
				local theSkillAction = Pet:EnumPetSkill( g_selidx, i-1, "petskill");
				i = i + 1;
				if theSkillAction:GetID() ~= 0 then
					PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
					k = k+1;
				end
			end
		end
	end


	if g_selidx ~= -1 then
		local szPetName,szOn = Pet:GetPetList_Appoint(g_selidx)
		if( szOn ~= "on_packa" )  then 
			PetStudyNewSkill_PetModel:SetFakeObject( "" );
			PetStudyNewSkill_Unlock();
			for i=1, PETSKILL_BUTTONS_NUM do
				PETSKILL_BUTTONS[i]:SetActionItem(-1);
			end
			g_selidx = -1
		end
	end
	
	PetStudyNewSkill_Money:SetProperty("MoneyNumber", 0);

	PetStudyNewSkill_Skill1: SetPushed(0);
	PetStudyNewSkill_Skill1: SetActionItem(-1);
	PetStudyNewSkill_Unlock()
	g_selfrm = ""
	g_pidx = -1

	Pet:ClosePetSkillStudyMsgBox()
	this:Show();
	Pet:ShowPetList(1);		-- 打开珍兽列表
end


--窗口隐藏前先将背包中被锁定的物品解锁
function PetStudyNewSkill_Unlock()
	if("package" == g_selfrm) then
		Pet:SkillStudyUnlock(g_pidx);
	end

	Pet:SkillStudy_MenPaiSkill_Clear();
end


function PetStudyNewSkill_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then

			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetStudyNewSkill_Hide();
		end
end