
local cooldownTime = 15*1000;		--结识的冷却时间
local pageCoolDownTime = 5*1000;	--翻页冷却时间，翻页消耗较大
local PET_AITYPE = {};
local FlashTextHeader = "#ecc33cc#cffcccc";		--调节这个来控制文字颜色和闪烁
local showWindowFlag = false;
local listflag = 0;
local showPrevPage = true;
local showNextPage = true;

function PetZhengYou_PreLoad()
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("OPEN_WINDOW");
end


function PetZhengYou_OnLoad()
	PET_AITYPE[0] = "#gFF0FA0胆小";
	PET_AITYPE[1] = "#gFF0FA0谨慎";
	PET_AITYPE[2] = "#gFF0FA0忠诚";
	PET_AITYPE[3] = "#gFF0FA0精明";
	PET_AITYPE[4] = "#gFF0FA0勇猛";
end

function PetZhengYou_Hide()
	this:Hide();
end

function PetZhengYou_OnEvent(event)
	if(event == "UPDATE_PETINVITEFRIEND") then
		if("notifypetlist" == arg0) then
			PetZhengYou_ShowWindow(listflag);
		elseif("searchlist" == arg0 or "searchlistbegin" == arg0) then
			this:Hide();
		elseif("noprevpage" == arg0) then
			showPrevPage = false;
			PetZhengYou_PageUp:Disable();
			PushDebugMessage("已经是第一页了");
		elseif("notifypetlistnone" == arg0) then
			if listflag == -1 then
				showPrevPage = false;
				PetZhengYou_PageUp:Disable();
				PushDebugMessage("已经是第一页了");
			elseif listflag == 1 then
				showNextPage = false;
				PetZhengYou_PageDown:Disable();
				PushDebugMessage("已经是最后一页了");
			else
				PetZhengYou_ShowWindow(-2);
			end
		end

	elseif ( event == "OPEN_WINDOW") then
		if( arg0 == "Show_Pet_Friends") then
			if(this:IsVisible()) then
				this:Hide();
			else
				PetInviteFriend:ShowPetFriends(0);
				listflag = 0;
			end
		end
	end
end
--收到World的数据后调用显示界面
local needEnable = false;
function PetZhengYou_ShowWindow(who)
	local num = PetInviteFriend:GetInviteNum("friends")
	if who == -2 then
		PetZhengYou_DisableAllWindow();
		this:Show();
		needEnable = true;
		return;
	end
	if needEnable then
		PetZhengYou_EnableAllWindow();
		needEnable = false;
	end
	if( num <= 0) then
		if who == -1 then
			PushDebugMessage("服务器上没有珍兽征友的数据");
			showPrevPage = false;
		elseif who == 1 then
			PushDebugMessage("服务器上没有珍兽征友的数据");
			showNextPage = false;
		else
			PetZhengYou_DisableAllWindow();
			showWindowFlag = true;
			this:Show();
		end
		return;
	else
		showNextPage = true;
		showPrevPage = true;
	end
	if who == 0 then
		showPrevPage = false;
	end
	if num <= 1 then
		showNextPage = false;
	end
	PetZhengYou_Clear_All();
	for i=1, num do
		PetZhengYou_Update(i);
	end
	if( num == 1 ) then
		PetZhengYou_DisableButton(1);
		PetZhengYou_HideWindow(1);
	end
	if showNextPage then
		PetZhengYou_PageDown:Enable();
	end
	if showPrevPage then
		PetZhengYou_PageUp:Enable();
	end
	this:Show();
end

function PetZhengYou_Update( idx )
	if(idx < 0 or idx > 2 or idx == nil) then
		return;
	end
	idx = idx + 2;

	--获取珍兽主人信息
	local humanName = PetInviteFriend:GetHumanINFO(idx, "NAME");
	local humanMenPai = PetInviteFriend:GetHumanINFO(idx, "MENPAI");	
	local humanLevel = PetInviteFriend:GetHumanINFO(idx, "LEVEL");
	local humanSex  = PetInviteFriend:GetHumanINFO(idx, "SEX");
	humanMenPai = PetZhengYou_ConvertNumToMenPai(humanMenPai);
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
	--PushDebugMessage("idx = " .. tostring(idx));
	--PushDebugMessage(humanName);
	
	if( idx == 3 ) then
	  --设置珍兽信息
		PetZhengYou_Master1Pet_NameInfo:SetText(petName);
		PetZhengYou_Master1Pet_GenderInfo:SetText(petSex);
		PetZhengYou_Master1Pet_ChenZhangInfo:SetText(petGrow);
		PetZhengYou_Master1Pet_LevelInfo:SetText(petLevel);
		PetZhengYou_Type1:SetText(petAI);
		PetZhengYou_Flash_Name1:SetText(petTypeName);
		
		--设置主人信息
		PetZhengYou_Master1_NameInfo:SetText(humanName);
		PetZhengYou_Master1_LevelInfo:SetText(humanLevel);
		PetZhengYou_Master1_ManPaiInfo:SetText(humanMenPai);
		PetZhengYou_Master1_GenderInfo:SetText(humanSex);
			
		--设置模型信息
		PetInviteFriend:SetPetModel(idx);
		PetZhengYou_PetModel1:SetFakeObject("My_PetFriend01");
			
		PetZhengYou_Pet1_Investigate:Enable();
		PetZhengYou_Pet1_Investigate:Enable();
		PetZhengYou_PetModel1_TurnRight:Enable();
		PetZhengYou_PetModel1_TurnLeft:Enable();

	
	elseif( idx == 4 ) then
	  --设置珍兽信息
		PetZhengYou_Master2Pet_NameInfo:SetText(petName);
		PetZhengYou_Master2Pet_GenderInfo:SetText(petSex);
		PetZhengYou_Master2Pet_ChenZhangInfo:SetText(petGrow);
		PetZhengYou_Master2Pet_LevelInfo:SetText(petLevel);
		PetZhengYou_Type2:SetText(petAI);
		PetZhengYou_Flash_Name2:SetText(petTypeName);
		
		--设置主人信息
		PetZhengYou_Master2_NameInfo:SetText(humanName);
		PetZhengYou_Master2_LevelInfo:SetText(humanLevel);
		PetZhengYou_Master2_ManPaiInfo:SetText(humanMenPai);
		PetZhengYou_Master2_GenderInfo:SetText(humanSex);
			
		--设置模型信息
		PetInviteFriend:SetPetModel(idx);
		PetZhengYou_PetModel2:SetFakeObject("My_PetFriend02");
		
		--激活按钮
		PetZhengYou_Pet2_Investigate:Enable();
		PetZhengYou_Pet2_Acquaintance:Enable();
		PetZhengYou_PetModel2_TurnRight:Enable();
		PetZhengYou_PetModel2_TurnLeft:Enable();
		
			
		--显示文本
		PetZhengYou_Master2Pet_Name:Show();
		PetZhengYou_Master2Pet_Gender:Show();
		PetZhengYou_Master2Pet_ChenZhang:Show();
		PetZhengYou_Master2Pet_Level:Show();
		PetZhengYou_Master2_Name:Show();
		PetZhengYou_Master2_Level:Show();
		PetZhengYou_Master2_ManPai:Show();
		PetZhengYou_Master2_Gender:Show();
		PetZhengYou_Master2Pet_NameInfo:Show();
		PetZhengYou_Master2Pet_GenderInfo:Show();
		PetZhengYou_Master2Pet_ChenZhangInfo:Show();
		PetZhengYou_Master2Pet_LevelInfo:Show();
		PetZhengYou_Master2_NameInfo:Show();
		PetZhengYou_Master2_LevelInfo:Show();
		PetZhengYou_Master2_ManPaiInfo:Show();
		PetZhengYou_Master2_GenderInfo:Show();
		PetZhengYou_Master2Info2:Show();
		PetZhengYou_Type2:Show();
		PetZhengYou_Flash_Name2:Show();
	end	

end

--隐藏一些 窗口
function PetZhengYou_HideWindow(idx)
	if( idx == 0 ) then
		PetZhengYou_Master1Pet_Name:Hide();
		PetZhengYou_Master1Pet_Gender:Hide();
		PetZhengYou_Master1Pet_ChenZhang:Hide();
		PetZhengYou_Master1Pet_Level:Hide();
		PetZhengYou_Master1_Name:Hide();
		PetZhengYou_Master1_Level:Hide();
		PetZhengYou_Master1_ManPai:Hide();
		PetZhengYou_Master1_Gender:Hide();
	else
		PetZhengYou_Master2Pet_Name:Hide();
		PetZhengYou_Master2Pet_Gender:Hide();
		PetZhengYou_Master2Pet_ChenZhang:Hide();
		PetZhengYou_Master2Pet_Level:Hide();
		PetZhengYou_Master2_Name:Hide();
		PetZhengYou_Master2_Level:Hide();
		PetZhengYou_Master2_ManPai:Hide();
		PetZhengYou_Master2_Gender:Hide();
		PetZhengYou_Master2Pet_NameInfo:Hide();
		PetZhengYou_Master2Pet_GenderInfo:Hide();
		PetZhengYou_Master2Pet_ChenZhangInfo:Hide();
		PetZhengYou_Master2Pet_LevelInfo:Hide();
		PetZhengYou_Master2_NameInfo:Hide();
		PetZhengYou_Master2_LevelInfo:Hide();
		PetZhengYou_Master2_ManPaiInfo:Hide();
		PetZhengYou_Master2_GenderInfo:Hide();
		PetZhengYou_Master2Info2:Hide();
		PetZhengYou_Type2:Hide();
		PetZhengYou_Flash_Name2:Hide();
	end
end

--禁用一些按钮
function PetZhengYou_DisableButton(idx)
	if( idx == 0 ) then
		PetZhengYou_Pet1_Investigate:Disable();
		PetZhengYou_Pet1_Acquaintance:Disable();
		PetZhengYou_PetModel1_TurnRight:Disable();
		PetZhengYou_PetModel1_TurnLeft:Disable();
	else
		PetZhengYou_Pet2_Investigate:Disable();
		PetZhengYou_Pet2_Acquaintance:Disable();
		PetZhengYou_PetModel2_TurnRight:Disable();
		PetZhengYou_PetModel2_TurnLeft:Disable();

	end
end


function PetZhengYou_Clear_All()
	
		if showWindowFlag then
			PetZhengYou_EnableAllWindow();
			showWindowFlag = false;
		end
		PetZhengYou_DisableButton(1);
		PetZhengYou_HideWindow(1);
		PetZhengYou_PetModel1:SetFakeObject("");
		PetZhengYou_PetModel2:SetFakeObject("");
		if( Pet:GetPet_Count() == 0 ) then
			PetZhengYou_Search:Disable();
		else
			PetZhengYou_Search:Enable();
		end
		PetZhengYou_PageDown:Disable();
		PetZhengYou_PageUp:Disable();
	--end
end


function PetZhengYou_ShowTargetFrame(who)
	PetInviteFriend:ShowTargetPet(who);
end

function PetZhengYou_ConvertNumToMenPai( MenPaiId )
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
function PetZhengYou_Modle_TurnLeft(modelIdx,start)

		if( modelIdx == 3 ) then
		--向左旋转开始
			if(start == 1) then
				PetZhengYou_PetModel1:RotateBegin(-0.3);
			--向左旋转结束
			else
				PetZhengYou_PetModel1 :RotateEnd();
			end
		end
		if( modelIdx == 4 ) then
			if(start == 1) then
				PetZhengYou_PetModel2:RotateBegin(-0.3);
			--向左旋转结束
			else
				PetZhengYou_PetModel2 :RotateEnd();
			end
	 end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetZhengYou_Modle_TurnRight(modelIdx, start)
	if( modelIdx == 3 ) then
		--向左旋转开始
			if(start == 1) then
				PetZhengYou_PetModel1:RotateBegin(0.3);
			--向左旋转结束
			else
				PetZhengYou_PetModel1 :RotateEnd();
			end
	elseif( modelIdx == 4 ) then
			if(start == 1) then
				PetZhengYou_PetModel2:RotateBegin(0.3);
			--向左旋转结束
			else
				PetZhengYou_PetModel2 :RotateEnd();
			end
	end
end

--查询上一篇的珍兽征友信息
function PetZhengYou_PrevPage()
	listflag = -1;
	PetInviteFriend:ShowPetFriends(-1);
	PetZhengYou_PageUp:Disable();
	if showPrevPage then
		SetTimer("PetZhengYou","PetZhengYou_CoolPageUp();", pageCoolDownTime);
	end
end

function PetZhengYou_CoolPageUp()
	if showPrevPage then
		PetZhengYou_PageUp:Enable();
	else
		PetZhengYou_PageUp:Disable();
	end
	KillTimer("PetZhengYou_CoolPageUp();");
end


--查询下一篇的珍兽征友信息
function PetZhengYou_NextPage()
	listflag = 1;
	PetInviteFriend:ShowPetFriends(1);
	PetZhengYou_PageDown:Disable();
	if showNextPage then
		SetTimer("PetZhengYou","PetZhengYou_CoolPageDown();", pageCoolDownTime);
	end
end

function PetZhengYou_CoolPageDown()
	if showNextPage then
		PetZhengYou_PageDown:Enable();
	else
		PetZhengYou_PageDown:Disable();
	end
	KillTimer("PetZhengYou_CoolPageDown();");
end


--给珍兽主人发邮件，说明想征友
function PetZhengYou_SendMail( idx )
	if( idx == 3 or idx == 4 ) then
		local owner = PetInviteFriend:GetHumanINFO(idx, "NAME");
		local player = Player:GetName();
		if(owner == player) then
			PushDebugMessage("不能和自己的珍兽结识");
			return;
		end
			--给该珍兽主人发送邮件告诉他她你的珍兽想和他她的珍兽结识
		DataPool:OpenMail( owner,"我想结识你的宝宝" );
	end
	
	if( idx == 3 ) then
		SetTimer("PetZhengYou","PetZhengYou_CoolDown3();" ,cooldownTime);
		PetZhengYou_Pet1_Acquaintance:Disable();
	elseif(idx == 4 ) then
		SetTimer("PetZhengYou","PetZhengYou_CoolDown4();" ,cooldownTime);
		PetZhengYou_Pet2_Acquaintance:Disable();
	end
end

function PetZhengYou_CoolDown3()
		PetZhengYou_Pet1_Acquaintance:Enable();
		KillTimer("PetZhengYou_CoolDown3();");
end
function PetZhengYou_CoolDown4()
		PetZhengYou_Pet2_Acquaintance:Enable();
		KillTimer("PetZhengYou_CoolDown4();");
end

--搜索合适珍兽
function PetZhengYou_OnSearch()
	Pet:ShowPetList(1);
	--this:Hide();
end

--这个函数写的很无奈呀！，窗口没有设计好，如果有个父窗口，就好了
function PetZhengYou_DisableAllWindow()
		PetZhengYou_Master1Pet_Name:Hide();
		PetZhengYou_Master1Pet_Gender:Hide();
		PetZhengYou_Master1Pet_ChenZhang:Hide();
		PetZhengYou_Master1Pet_Level:Hide();
		PetZhengYou_Master1_Name:Hide();
		PetZhengYou_Master1_Level:Hide();
		PetZhengYou_Master1_ManPai:Hide();
		PetZhengYou_Master1_Gender:Hide();
		PetZhengYou_Master1Pet_NameInfo:Hide();
		PetZhengYou_Master1Pet_GenderInfo:Hide();
		PetZhengYou_Master1Pet_ChenZhangInfo:Hide();
		PetZhengYou_Master1Pet_LevelInfo:Hide();
		PetZhengYou_Master1_NameInfo:Hide();
		PetZhengYou_Master1_LevelInfo:Hide();
		PetZhengYou_Master1_ManPaiInfo:Hide();
		PetZhengYou_Master1_GenderInfo:Hide();
		PetZhengYou_Master1Info:Hide();
		PetZhengYou_Type1:Hide();
		PetZhengYou_Flash_Name1:Hide();
			
		PetZhengYou_Master2Pet_Name:Hide();
		PetZhengYou_Master2Pet_Gender:Hide();
		PetZhengYou_Master2Pet_ChenZhang:Hide();
		PetZhengYou_Master2Pet_Level:Hide();
		PetZhengYou_Master2_Name:Hide();
		PetZhengYou_Master2_Level:Hide();
		PetZhengYou_Master2_ManPai:Hide();
		PetZhengYou_Master2_Gender:Hide();
		PetZhengYou_Master2Pet_NameInfo:Hide();
		PetZhengYou_Master2Pet_GenderInfo:Hide();
		PetZhengYou_Master2Pet_ChenZhangInfo:Hide();
		PetZhengYou_Master2Pet_LevelInfo:Hide();
		PetZhengYou_Master2_NameInfo:Hide();
		PetZhengYou_Master2_LevelInfo:Hide();
		PetZhengYou_Master2_ManPaiInfo:Hide();
		PetZhengYou_Master2_GenderInfo:Hide();
		PetZhengYou_Master2Info2:Hide();
		PetZhengYou_Type2:Hide();
		PetZhengYou_Flash_Name2:Hide();
			
		PetZhengYou_Pet1_Investigate:Disable();
		PetZhengYou_Pet1_Acquaintance:Disable();
		PetZhengYou_PetModel1_TurnRight:Disable();
		PetZhengYou_PetModel1_TurnLeft:Disable();
		PetZhengYou_Pet2_Investigate:Disable();
		PetZhengYou_Pet2_Acquaintance:Disable();
		PetZhengYou_PetModel2_TurnRight:Disable();
		PetZhengYou_PetModel2_TurnLeft:Disable();
		PetZhengYou_PageDown:Disable();
		PetZhengYou_PageUp:Disable();
		PetZhengYou_Search:Disable();
		PetZhengYou_PetModel1:SetFakeObject("");
		PetZhengYou_PetModel2:SetFakeObject("");
end

--这个函数写的很无奈呀！，窗口没有设计好，如果有个父窗口，就好了
function PetZhengYou_EnableAllWindow()
		PetZhengYou_Master1Pet_Name:Show();
		PetZhengYou_Master1Pet_Gender:Show();
		PetZhengYou_Master1Pet_ChenZhang:Show();
		PetZhengYou_Master1Pet_Level:Show();
		PetZhengYou_Master1_Name:Show();
		PetZhengYou_Master1_Level:Show();
		PetZhengYou_Master1_ManPai:Show();
		PetZhengYou_Master1_Gender:Show();
		PetZhengYou_Master1Pet_NameInfo:Show();
		PetZhengYou_Master1Pet_GenderInfo:Show();
		PetZhengYou_Master1Pet_ChenZhangInfo:Show();
		PetZhengYou_Master1Pet_LevelInfo:Show();
		PetZhengYou_Master1_NameInfo:Show();
		PetZhengYou_Master1_LevelInfo:Show();
		PetZhengYou_Master1_ManPaiInfo:Show();
		PetZhengYou_Master1_GenderInfo:Show();
		PetZhengYou_Master1Info:Show();
		PetZhengYou_Type1:Show();
		PetZhengYou_Flash_Name1:Show();
			
		PetZhengYou_Master2Pet_Name:Show();
		PetZhengYou_Master2Pet_Gender:Show();
		PetZhengYou_Master2Pet_ChenZhang:Show();
		PetZhengYou_Master2Pet_Level:Show();
		PetZhengYou_Master2_Name:Show();
		PetZhengYou_Master2_Level:Show();
		PetZhengYou_Master2_ManPai:Show();
		PetZhengYou_Master2_Gender:Show();
		PetZhengYou_Master2Pet_NameInfo:Show();
		PetZhengYou_Master2Pet_GenderInfo:Show();
		PetZhengYou_Master2Pet_ChenZhangInfo:Show();
		PetZhengYou_Master2Pet_LevelInfo:Show();
		PetZhengYou_Master2_NameInfo:Show();
		PetZhengYou_Master2_LevelInfo:Show();
		PetZhengYou_Master2_ManPaiInfo:Show();
		PetZhengYou_Master2_GenderInfo:Show();
		PetZhengYou_Master2Info2:Show();
		PetZhengYou_Type2:Show();
		PetZhengYou_Flash_Name2:Show();
			
		PetZhengYou_Pet1_Investigate:Enable();
		PetZhengYou_Pet1_Acquaintance:Enable();
		PetZhengYou_PetModel1_TurnRight:Enable();
		PetZhengYou_PetModel1_TurnLeft:Enable();
		PetZhengYou_Pet2_Investigate:Enable();
		PetZhengYou_Pet2_Acquaintance:Enable();
		PetZhengYou_PetModel2_TurnRight:Enable();
		PetZhengYou_PetModel2_TurnLeft:Enable();
		PetZhengYou_PageDown:Enable();
		PetZhengYou_PageUp:Enable();
		PetZhengYou_Search:Enable();
end
