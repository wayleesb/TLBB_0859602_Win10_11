
local cooldownTime =15*1000;		--结识冷却时间
local pageCoolDownTime = 5*1000;	--翻页冷却时间，翻页消耗较大
local PET_AITYPE = {};
local FlashTextHeader = "#ecc33cc#cffcccc";		--调节这个来控制文字颜色和闪烁
local showPrevPage = true;
local showNextPage = true;

function PetFriendSearch_PreLoad()
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OPEN_WINDOW");
end

function PetFriendSearch_OnLoad()
	PET_AITYPE[0] = "胆小";
	PET_AITYPE[1] = "谨慎";
	PET_AITYPE[2] = "忠诚";
	PET_AITYPE[3] = "精明";
	PET_AITYPE[4] = "勇猛";
end

function PetFriendSearch_OnEvent(event)

	if(event == "UPDATE_PETINVITEFRIEND") then
		if("searchlist" == arg0) then
			showPrevPage = true;
			showNextPage = true;
			PetFriendSearch_ShowWindow();
		elseif("searchlistbegin" == arg0) then
			showPrevPage = false;
			PetFriendSearch_ShowWindow();
		elseif("searchnonextpage" == arg0) then
			PetFriendSearch_PageDown:Disable();
			showNextPage = false;
		elseif("searchnoprevpage" == arg0) then
			PetFriendSearch_PageUp:Disable();
			showPrevPage = false;
		end
	elseif ( event == "OPEN_WINDOW") then
		if( arg0 == "Show_Pet_Search") then
			this:Show();
		end
	end
end

function PetFriendSearch_ShowWindow()
	local num = PetInviteFriend:GetInviteNum("search")
	if( num <= 0 ) then
		PushDebugMessage("没有找到合适的珍兽数据");
		return;
	end
	PetFriendSearch_Clear_All();
	if( num == 1 ) then
		PetFriendSearch_DisableButton(1);
		PetFriendSearch_HideWindow(1);
		showNextPage = false;
	else
		showNextPage = true;
	end
	for i=1, num do
		PetFriendSearch_Update(i);
	end
	this:Show();
end

function PetFriendSearch_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	idx = idx + 4;

	--获取珍兽主人信息
	local humanName = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local humanMenPai = PetInviteFriend:GetHumanINFO(idx, "MENPAI");	
	local humanLevel = PetInviteFriend:GetHumanINFO(idx, "LEVEL");
	local humanSex  = PetInviteFriend:GetHumanINFO(idx, "SEX");
	humanMenPai = PetFriendSearch_ConvertNumToMenPai(humanMenPai);
	if( humanSex == 0 ) then
		humanSex = "女";
	else
		humanSex = "男";
	end
		
	--获取珍兽信息
	local petName = PetInviteFriend:GetPetINFO(idx, "NAME");
	local petGrow = PetInviteFriend:GetPetINFO(idx, "GROW");	
	local petLevel = PetInviteFriend:GetPetINFO(idx, "LEVEL");
	local petSex  = PetInviteFriend:GetPetINFO(idx, "SEX");
	local petAI   = PetInviteFriend:GetPetINFO(idx, "AITYPE");
	local petTypeName = PetInviteFriend:GetPetINFO(idx, "TYPENAME");
	petTypeName = FlashTextHeader .. petTypeName .. "宝宝";
	if( petSex == 0 ) then
		petSex = "雌";
	else
		petSex = "雄";
	end
	local strTbl = {"普通","优秀","杰出","卓越","完美"};
	
	if(petGrow >= 0) then
		petGrow = petGrow + 1;	--c里是从0开始的枚举
		if(strTbl[petGrow]) then
			petGrow = strTbl[petGrow];
		else
			petGrow = "未知";
		end
	else
		petGrow = "未知";
	end
	
	if(petAI>4 or petAI <0) then
		petAI = "错误的";
	else
		petAI =	PET_AITYPE[petAI];
	end

	
	if( idx == 5 ) then
	  --设置珍兽信息
		PetFriendSearch_Master1Pet_NameInfo:SetText(petName);
		PetFriendSearch_Master1Pet_GenderInfo:SetText(petSex);
		PetFriendSearch_Master1Pet_ChenZhangInfo:SetText(petGrow);
		PetFriendSearch_Master1Pet_LevelInfo:SetText(petLevel);
		PetFriendSearch_Type1:SetText(petAI);
		PetFriendSearch_Flash_Name1:SetText(petTypeName);
		
		--设置主人信息
		PetFriendSearch_Master1_NameInfo:SetText(humanName);
		PetFriendSearch_Master1_LevelInfo:SetText(humanLevel);
		PetFriendSearch_Master1_ManPaiInfo:SetText(humanMenPai);
		PetFriendSearch_Master1_GenderInfo:SetText(humanSex);
			
		--设置模型信息
		PetInviteFriend:SetPetModel(idx);
		PetFriendSearch_PetModel1:SetFakeObject("My_PetSearchFriend01");
			
		PetFriendSearch_Pet1_Investigate:Enable();
		PetFriendSearch_Pet1_Investigate:Enable();
		PetFriendSearch_PetModel1_TurnRight:Enable();
		PetFriendSearch_PetModel1_TurnLeft:Enable();
		if showPrevPage then
			PetFriendSearch_PageUp:Enable();
		else
			PetFriendSearch_PageUp:Disable();
		end

	
	elseif( idx == 6 ) then
	  --设置珍兽信息
		PetFriendSearch_Master2Pet_NameInfo:SetText(petName);
		PetFriendSearch_Master2Pet_GenderInfo:SetText(petSex);
		PetFriendSearch_Master2Pet_ChenZhangInfo:SetText(petGrow);
		PetFriendSearch_Master2Pet_LevelInfo:SetText(petLevel);
		PetFriendSearch_Flash_Name2:SetText(petTypeName);
		PetFriendSearch_Type2:SetText(petAI);
		
		--设置主人信息
		PetFriendSearch_Master2_NameInfo:SetText(humanName);
		PetFriendSearch_Master2_LevelInfo:SetText(humanLevel);
		PetFriendSearch_Master2_ManPaiInfo:SetText(humanMenPai);
		PetFriendSearch_Master2_GenderInfo:SetText(humanSex);
					
		--设置模型信息
		PetInviteFriend:SetPetModel(idx);
		PetFriendSearch_PetModel2:SetFakeObject("My_PetSearchFriend02");
		
		--激活按钮
		PetFriendSearch_Pet2_Investigate:Enable();
		PetFriendSearch_Pet2_Acquaintance:Enable();
		PetFriendSearch_PetModel2_TurnRight:Enable();
		PetFriendSearch_PetModel2_TurnLeft:Enable();
		if showNextPage then
			PetFriendSearch_PageDown:Enable()
		end
			
		--显示文本
		PetFriendSearch_Master2Pet_Name:Show();
		PetFriendSearch_Master2Pet_Gender:Show();
		PetFriendSearch_Master2Pet_ChenZhang:Show();
		PetFriendSearch_Master2Pet_Level:Show();
		PetFriendSearch_Master2_Name:Show();
		PetFriendSearch_Master2_Level:Show();
		PetFriendSearch_Master2_ManPai:Show();
		PetFriendSearch_Master2_Gender:Show();
		PetFriendSearch_Master2Pet_NameInfo:Show();
		PetFriendSearch_Master2Pet_GenderInfo:Show();
		PetFriendSearch_Master2Pet_ChenZhangInfo:Show();
		PetFriendSearch_Master2Pet_LevelInfo:Show();
		PetFriendSearch_Master2_NameInfo:Show();
		PetFriendSearch_Master2_LevelInfo:Show();
		PetFriendSearch_Master2_ManPaiInfo:Show();
		PetFriendSearch_Master2_GenderInfo:Show();
		PetFriendSearch_Type2:Show();
		PetFriendSearch_Flash_Name2:Show();
	end	

end

--隐藏一些 窗口
function PetFriendSearch_HideWindow(idx)
	if( idx == 0 ) then
		PetFriendSearch_Master1Pet_Name:Hide();
		PetFriendSearch_Master1Pet_Gender:Hide();
		PetFriendSearch_Master1Pet_ChenZhang:Hide();
		PetFriendSearch_Master1Pet_Level:Hide();
		PetFriendSearch_Master1_Name:Hide();
		PetFriendSearch_Master1_Level:Hide();
		PetFriendSearch_Master1_ManPai:Hide();
		PetFriendSearch_Master1_Gender:Hide();
	else
		PetFriendSearch_Master2Pet_Name:Hide();
		PetFriendSearch_Master2Pet_Gender:Hide();
		PetFriendSearch_Master2Pet_ChenZhang:Hide();
		PetFriendSearch_Master2Pet_Level:Hide();
		PetFriendSearch_Master2_Name:Hide();
		PetFriendSearch_Master2_Level:Hide();
		PetFriendSearch_Master2_ManPai:Hide();
		PetFriendSearch_Master2_Gender:Hide();
		PetFriendSearch_Master2Pet_NameInfo:Hide();
		PetFriendSearch_Master2Pet_GenderInfo:Hide();
		PetFriendSearch_Master2Pet_ChenZhangInfo:Hide();
		PetFriendSearch_Master2Pet_LevelInfo:Hide();
		PetFriendSearch_Master2_NameInfo:Hide();
		PetFriendSearch_Master2_LevelInfo:Hide();
		PetFriendSearch_Master2_ManPaiInfo:Hide();
		PetFriendSearch_Master2_GenderInfo:Hide();
		PetFriendSearch_Type2:Hide();
		PetFriendSearch_Flash_Name2:Hide();
	end
end

--禁用一些按钮
function PetFriendSearch_DisableButton(idx)
	if( idx == 0 ) then
		PetFriendSearch_Pet1_Investigate:Disable();
		PetFriendSearch_Pet1_Acquaintance:Disable();
		PetFriendSearch_PetModel1_TurnRight:Disable();
		PetFriendSearch_PetModel1_TurnLeft:Disable();
	else
		PetFriendSearch_Pet2_Investigate:Disable();
		PetFriendSearch_Pet2_Acquaintance:Disable();
		PetFriendSearch_PetModel2_TurnRight:Disable();
		PetFriendSearch_PetModel2_TurnLeft:Disable();
		--没有下一页的信息了	
		PetFriendSearch_PageDown:Disable();
	end
end


function PetFriendSearch_Clear_All()
	--for i=0, 2 do
		PetFriendSearch_DisableButton(1);
		PetFriendSearch_HideWindow(1);
		PetFriendSearch_PetModel1:SetFakeObject("");
		PetFriendSearch_PetModel2:SetFakeObject("");
		
	--end
end


function PetFriendSearch_ShowTargetFrame(who)
	PetInviteFriend:ShowTargetPet(who);
end

function PetFriendSearch_Hide()
	this:Hide();
end


function PetFriendSearch_ConvertNumToMenPai( MenPaiId )
	local strMenPai = "???";
	-- 得到门派名称.
	if(0 == MenPaiId) then
		strMenPai = "少林";

	elseif(1 == MenPaiId) then
		strMenPai = "明教";

	elseif(2 == MenPaiId) then
		strMenPai = "丐帮";

	elseif(3 == MenPaiId) then
		strMenPai = "武当";

	elseif(4 == MenPaiId) then
		strMenPai = "峨嵋";

	elseif(5 == MenPaiId) then
		strMenPai = "星宿";

	elseif(6 == MenPaiId) then
		strMenPai = "天龙";

	elseif(7 == MenPaiId) then
		strMenPai = "天山";

	elseif(8 == MenPaiId) then
		strMenPai = "逍遥";

	elseif(9 == MenPaiId) then
		strMenPai = "无门派";
	end
	
	return strMenPai;
end
----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function PetFriendSearch_Modle_TurnLeft(modelIdx,start)

		if( modelIdx == 5 ) then
		--向左旋转开始
			if(start == 1) then
				PetFriendSearch_PetModel1:RotateBegin(-0.3);
			--向左旋转结束
			else
				PetFriendSearch_PetModel1 :RotateEnd();
			end
		end
		if( modelIdx == 6 ) then
			if(start == 1) then
				PetFriendSearch_PetModel2:RotateBegin(-0.3);
			--向左旋转结束
			else
				PetFriendSearch_PetModel2 :RotateEnd();
			end
	 end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetFriendSearch_Modle_TurnRight(modelIdx, start)
	if( modelIdx == 5 ) then
		--向左旋转开始
			if(start == 1) then
				PetFriendSearch_PetModel1:RotateBegin(0.3);
			--向左旋转结束
			else
				PetFriendSearch_PetModel1 :RotateEnd();
			end
	elseif( modelIdx == 6 ) then
			if(start == 1) then
				PetFriendSearch_PetModel2:RotateBegin(0.3);
			--向左旋转结束
			else
				PetFriendSearch_PetModel2 :RotateEnd();
			end
	end
end

--查询上一篇的珍兽征友信息
function PetFriendSearch_PrevPage()
	PetInviteFriend:ShowSearchPage(-1);
	PetFriendSearch_PageUp:Disable();
	SetTimer("PetFriendSearch","PetFriendSearch_CoolPageUp();",pageCoolDownTime);
end

function PetFriendSearch_CoolPageUp()
	if showPrevPage then
		PetFriendSearch_PageUp:Enable();
	end
	KillTimer("PetFriendSearch_CoolPageUp();");
end

--查询下一篇的珍兽征友信息
function PetFriendSearch_NextPage()
	PetInviteFriend:ShowSearchPage(1);
	PetFriendSearch_PageDown:Disable();
	SetTimer("PetFriendSearch","PetFriendSearch_CoolPageDown();",pageCoolDownTime);
end
function PetFriendSearch_CoolPageDown()
	if showNextPage then
		PetFriendSearch_PageDown:Enable();
	end
	KillTimer("PetFriendSearch_CoolPageDown();");
end

--给珍兽主人发邮件，说明想征友
function PetFriendSearch_SendMail( idx )
	if( idx == 5 or idx == 6 ) then
		local owner = PetInviteFriend:GetHumanINFO(idx, "NAME");
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("不能和自己的珍兽结识");
			return;
		end
			--给该珍兽主人发送邮件告诉他她你的珍兽想和他她的珍兽结识
		DataPool:OpenMail( owner,"我想结识你的宝宝" );
	end
	
	if( idx == 5 ) then
		SetTimer("PetFriendSearch","PetFriendSearch_CoolDown3();" ,cooldownTime);
		PetFriendSearch_Pet1_Acquaintance:Disable();
	elseif(idx == 6 ) then
		SetTimer("PetFriendSearch","PetFriendSearch_CoolDown4();" ,cooldownTime);
		PetFriendSearch_Pet2_Acquaintance:Disable();
	end
end

function PetFriendSearch_CoolDown3()
		PetFriendSearch_Pet1_Acquaintance:Enable();
		KillTimer("PetFriendSearch_CoolDown3();");
end
function PetFriendSearch_CoolDown4()
		PetFriendSearch_Pet2_Acquaintance:Enable();
		KillTimer("PetFriendSearch_CoolDown4();");
end