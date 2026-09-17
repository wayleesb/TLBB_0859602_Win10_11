--***********************************************************************************************************************************************
--***********************************************************************************************************************************************
--
-- 组队列表框的主要脚本事件
-- 
--
--
--************************************************************************************************************************************************
--************************************************************************************************************************************************



--------------------------------------------------------------------------------------------------------------------------------------------------
--
-- 局部变量的定义.
--
local PARTYFRAMEs = {};
local PARTY_HP = {};
local PARTY_MP = {};
local PARTY_FRAME = {};
local PARTY_NAME  = {};
local Portrait_ToolTips = {};
local UnLink_flag = {};					-- 掉线标记
local Porttrait_Mask = {};			-- 灰掉蒙子

-- 显示hp的text
local HP_Text_Tip = {};

local	MemberName;
local strIconIndex;
local HPValue;
local HPMax;
local MPValue;
local MPMax;
local Fammily;
local Level;
local Anger;
local DeadLink;
local Dead;
local sex;

-- 显示队友所中的buf
local PARTY_BUFF_MAX = 6;
local PARTY_IMPACT_CTL = {};

-- 队友出战珍兽按钮
local Team_Member_Pet_Button = {};
-- 队友的出战珍兽显示信息
local PetPortrait_ToolTips = {};

--***********************************************************************************************************************************************
--
-- 
--
--
--************************************************************************************************************************************************
function PartyFrame_PreLoad()

	--AxTrace( 0,0, "partyframe_Preload");
	this:RegisterEvent("TEAM_ENTER_MEMBER");				-- 注册队员加入事件
	this:RegisterEvent("TEAM_UPDATE_MEMBER");				-- 注册队员更新事件
	this:RegisterEvent("TEAM_HIDE_ALL_PLAYER");			-- 隐藏所有队员事件
	this:RegisterEvent("TEAM_REFRESH_DATA");				-- 更新某一个队员的事件
	this:RegisterEvent("ON_TEAM_UPDATE_PARTYFRAME");			-- 更新PartyFrame界面			add by WTT
	
end

function PartyFrame_OnLoad()
	
	
	PARTYFRAMEs[1] = PartyFrame1;
	PARTYFRAMEs[2] = PartyFrame2;
	PARTYFRAMEs[3] = PartyFrame3;
	PARTYFRAMEs[4] = PartyFrame4;
	PARTYFRAMEs[5] = PartyFrame5;

	PARTY_HP[1] = PartyFrame_HP1;
	PARTY_HP[2] = PartyFrame_HP2;
	PARTY_HP[3] = PartyFrame_HP3;
	PARTY_HP[4] = PartyFrame_HP4;
	PARTY_HP[5] = PartyFrame_HP5;

	--PARTY_MP[1] = PartyFrame_MP1;
	--PARTY_MP[2] = PartyFrame_MP2;
	--PARTY_MP[3] = PartyFrame_MP3;
	--PARTY_MP[4] = PartyFrame_MP4;
	--PARTY_MP[5] = PartyFrame_MP5;

	PARTY_FRAME[1] = PartyFrame_Party1;
	PARTY_FRAME[2] = PartyFrame_Party2;
	PARTY_FRAME[3] = PartyFrame_Party3;
	PARTY_FRAME[4] = PartyFrame_Party4;
	PARTY_FRAME[5] = PartyFrame_Party5;
	
	--PARTY_NAME[1] = Name1;
	--PARTY_NAME[2] = Name2;
	--PARTY_NAME[3] = Name3;
	--PARTY_NAME[4] = Name4;
	--PARTY_NAME[5] = Name5;
	
	Portrait_ToolTips[1] = Portrait_Icon1;
	Portrait_ToolTips[2] = Portrait_Icon2;
	Portrait_ToolTips[3] = Portrait_Icon3;
	Portrait_ToolTips[4] = Portrait_Icon4;
	Portrait_ToolTips[5] = Portrait_Icon5;
	
	HP_Text_Tip[1] = PartyFrame_HP_Text1;
	HP_Text_Tip[2] = PartyFrame_HP_Text2;
	HP_Text_Tip[3] = PartyFrame_HP_Text3;
	HP_Text_Tip[4] = PartyFrame_HP_Text4;
	HP_Text_Tip[5] = PartyFrame_HP_Text5;
	
	--2006年5月20日, 修改掉线信息功能
	UnLink_flag[1] = Team_Leader_Flag2;
	UnLink_flag[2] = Team_Leader2_Flag2;
	UnLink_flag[3] = Team_Leader3_Flag2;
	UnLink_flag[4] = Team_Leader4_Flag2;
	UnLink_flag[5] = Team_Leader5_Flag2;
	
	
	--2006年5月20日, 修改死亡蒙子
	Porttrait_Mask[1] = Portrait_Icon1_Mask;
	Porttrait_Mask[2] = Portrait_Icon2_Mask;
	Porttrait_Mask[3] = Portrait_Icon3_Mask;
	Porttrait_Mask[4] = Portrait_Icon4_Mask;
	Porttrait_Mask[5] = Portrait_Icon5_Mask;
	
	
	PARTY_IMPACT_CTL[1] = {
												PartyFrame_1_Buff1,
												PartyFrame_1_Buff2,
												PartyFrame_1_Buff3,
												PartyFrame_1_Buff4,
												PartyFrame_1_Buff5,
												PartyFrame_1_Buff6,
											};
	PARTY_IMPACT_CTL[2] = {
												PartyFrame_2_Buff1,
												PartyFrame_2_Buff2,
												PartyFrame_2_Buff3,
												PartyFrame_2_Buff4,
												PartyFrame_2_Buff5,
												PartyFrame_2_Buff6,
											};
	PARTY_IMPACT_CTL[3] = {
												PartyFrame_3_Buff1,
												PartyFrame_3_Buff2,
												PartyFrame_3_Buff3,
												PartyFrame_3_Buff4,
												PartyFrame_3_Buff5,
												PartyFrame_3_Buff6,
											};
	PARTY_IMPACT_CTL[4] = {
												PartyFrame_4_Buff1,
												PartyFrame_4_Buff2,
												PartyFrame_4_Buff3,
												PartyFrame_4_Buff4,
												PartyFrame_4_Buff5,
												PartyFrame_4_Buff6,
											};
	PARTY_IMPACT_CTL[5] = {
												PartyFrame_5_Buff1,
												PartyFrame_5_Buff2,
												PartyFrame_5_Buff3,
												PartyFrame_5_Buff4,
												PartyFrame_5_Buff5,
												PartyFrame_5_Buff6,
											};
							
											
	Team_Leader2_Flag:Hide();
	Team_Leader3_Flag:Hide();
	Team_Leader4_Flag:Hide();
	Team_Leader5_Flag:Hide();
	
	-- 第1至5号队友的出战宠物按钮
	-- add by WTT
	Team_Member_Pet_Button[1] = Team_Pet_Button;
	Team_Member_Pet_Button[2] = Team_Pet2_Button;
	Team_Member_Pet_Button[3] = Team_Pet3_Button;
	Team_Member_Pet_Button[4] = Team_Pet4_Button;
	Team_Member_Pet_Button[5] = Team_Pet5_Button;
	
	-- 珍兽头像上的浮动信息
	-- add by WTT
	PetPortrait_ToolTips[1]= Team_Pet_Button;
	PetPortrait_ToolTips[2]= Team_Pet2_Button;
	PetPortrait_ToolTips[3]= Team_Pet3_Button;
	PetPortrait_ToolTips[4]= Team_Pet4_Button;
	PetPortrait_ToolTips[5]= Team_Pet5_Button;
	
end

--****************************************************************************************************************
--
-- 事件入口
--
--****************************************************************************************************************
function PartyFrame_OnEvent(event)
	
	--AxTrace( 0,0, "event面");
	----------------------------------------------------------------------------------------------------------------
	--
	-- 隐藏所有队友界面
	if ( event == "TEAM_HIDE_ALL_PLAYER" ) then
	
		--AxTrace( 0,0, "删除所有界面");
		Hide_All_Play_Func();
		return;
	end


	-----------------------------------------------------------------------------------------------------------------
	--
	-- 更新所有队友界面.
	if( event == "TEAM_REFRESH_DATA" ) then
	
		Refresh_All_Member_Info_Func();
			return;
	end



	------------------------------------------------------------------------------------------------------------------
	--
	-- 有新的队员进入
	if ( event == "TEAM_ENTER_MEMBER" ) then
		Refresh_All_Member_Info_Func();
		return;

	end
	
	
	
	--------------------------------------------------------------------------------------------------------------------
	--
	-- 更新队员信息.
	if ( event == "TEAM_UPDATE_MEMBER" ) then
			Refresh_All_Member_Info_Func();
		return;

	end
	
	--------------------------------------------------------------------------------------------------------------------
	--
	-- 更新PartyFrame界面
	-- add by WTT
	if ( event == "ON_TEAM_UPDATE_PARTYFRAME" ) then
		Refresh_All_Member_Info_Func();
		return;
	end
	
	
end


--***********************************************************************************************************************************************
--
-- 显示一个新加入的队员
--
--************************************************************************************************************************************************
function PartyFrame_UpdatePage(index)

	
	--AxTrace( 0,0, "显示队友!" .. tostring(index));
	if((index < 1) or (index > 5)) then
			--AxTrace( 0,0, "界面索引出现异常!");
			return;
	end
		
	this:Show();
	
	--显示新加入队友的头像
	PARTYFRAMEs[index]:Show();
	
	--显示新加入队友的珍兽按钮
	PetButton_Show (index);

	--AxTrace( 0,0, "显示队友完毕!" .. tostring(index));
	
end



--***********************************************************************************************************************************************
--
-- 当右键点击窗口的时候, 弹出菜单
--
--************************************************************************************************************************************************
function Show_Team_Func(index)
	
	PartyFrame_SelectAsTarget(index)
	Show_Team_Func_Menu(index);
end


--***********************************************************************************************************************************************
--
-- 隐藏队列窗口
--
--************************************************************************************************************************************************
function Hide_All_Play_Func()
	
	local index = 1;
	while (index < 6) do 
		
			PARTYFRAMEs[index]:Hide();
			Team_Member_Pet_Button[index]:Hide();

			index = index + 1;
			
	end
	
	Team_Leader_Flag:Hide();
	PartyFrame_ClerAllBufInfo();
	
end


--***********************************************************************************************************************************************
--
-- 显示队员信息
--
--************************************************************************************************************************************************
function Show_Team_Member_Info_Func(index)
	
		--AxTrace( 0,0, "开始得到队友信息完毕!" .. tostring(index));
		-- 得到队员的个数
		local iMemCount = DataPool:GetTeamMemberCount();
		--AxTrace( 0,0, "得到队友个数!" .. tostring(iMemCount));
				
		if((iMemCount < 1)and(iMemCount > 5)) then
		
			--AxTrace( 0,0, "得到队友个数异常" .. tostring(iMemCount));
			return;
		end
		
		-- 得到队员的详细信息
		MemberName
		, strIconIndex
		, HPValue
		, HPMax
		, MPValue
		, MPMax 
		, Fammily
		, Level
		, Anger
		, DeadLink
		, Dead
		, sex
		, ScenceName
		= DataPool:GetTeamMemberInfo( index );
		
		--AxTrace( 0,0, "得到队友信息完毕!" .. tostring(index));
		-- 设置名字.
		--PARTY_NAME[index]:SetText(MemberName);
		
		-- 设置hp
		if(-1 ~= HPValue) then
			PARTY_HP[index]:SetProgress(tonumber(HPValue), tonumber(HPMax));
		else
			PARTY_HP[index]:SetProgress(1, 1);
		end;
		--AxTrace( 0,0, "当前血值!" .. tostring(HPValue));
		--AxTrace( 0,0, "血值最大!" .. tostring(HPMax));
		
		-- 设置mp
		--PARTY_MP[index]:SetProgress(tonumber(MPValue), tonumber(MPMax));
		--AxTrace( 0,0, "当前魔法!" .. tostring(MPValue));
		--AxTrace( 0,0, "魔法最大!" .. tostring(MPMax));
		
		
		Show_Leader_Flag_Func();
		
		-- 设置tooltips
		local bDead = "否";
		local bDeadLink = "否";
			
		Portrait_ToolTips[index]:SetProperty("Image", "set:PlayerFrame_Icon image:Icon_xiaoyao");
		Portrait_ToolTips[index]:SetProperty("Image", strIconIndex);
	
		--if(0 ~= Dead) then
		--	bDead = "是"
		--	Portrait_ToolTips[index]:SetProperty("Image", "set:TeamFrame5 image:Die_Icon");
		--end	
		
		--if(0 ~= DeadLink) then
		--	bDeadLink = "是"
		--	AxTrace( 0,0, "设置掉线信息");
		--	Portrait_ToolTips[index]:SetProperty("Image", "set:TeamFrame5 image:Downline_Icon");
		--end
		
		AxTrace( 0,0, "得到队友信息完毕!" .. tostring(index));
		if(0 ~= Dead) then
			bDead = "是"
			--Portrait_ToolTips[tonumber(index)]:Disable();
			Porttrait_Mask[index]:Show();
		else
		
			--Portrait_ToolTips[tonumber(index)]:Eable();
			Porttrait_Mask[index]:Hide();
		end	
		
		if(0 == DeadLink) then
		
			UnLink_flag[tonumber(index)]:Hide();
		else
		
			bDeadLink = "是"
			UnLink_flag[tonumber(index)]:Show();
		end
		
		
		--local strInfo = "\n 名字: "  
		--								.. tostring(MemberName)
		--      					.. "\n 门派:"
		--								.. tostring(Fammily)
		--								.. "\n 等级:"
		--								.. tostring(Level)
		--								.. " \n hp:"
		--								.. tostring(HPValue) .. "/" .. tostring(HPMax)
		--								.. " \n mp:"
		--								.. tostring(MPValue) .. "/" .. tostring(MPMax)
		--								.. " \n 怒气:"
		--								.. tostring(Anger)
		--								.. " \n 断线:"
		--								.. tostring(bDeadLink)
		--								.. " \n 死亡:"
		--								.. tostring(bDead);
		
		--AxTrace( 0,0, "fmaily  " .. tostring(Fammily));
		local strMenPai = "";
		-- 得到门派名称.
		if(0 == Fammily) then
			strMenPai = "少林";
	
		elseif(1 == Fammily) then
			strMenPai = "明教";
	
		elseif(2 == Fammily) then
			strMenPai = "丐帮";
	
		elseif(3 == Fammily) then
			strMenPai = "武当";
	
		elseif(4 == Fammily) then
			strMenPai = "峨嵋";
	
		elseif(5 == Fammily) then
			strMenPai = "星宿";
	
		elseif(6 == Fammily) then
			strMenPai = "天龙";
	
		elseif(7 == Fammily) then
			strMenPai = "天山";
	
		elseif(8 == Fammily) then
			strMenPai = "逍遥";
	
		elseif(9 == Fammily) then
			strMenPai = "无门派";
		end
	
		local strInfo = tostring(MemberName)
		      					.. "\n"
										.. tostring(strMenPai).."  "
										.. tostring(Level).. "级"
										.. "\n所在地："
										.. ScenceName;
									
										
		Portrait_ToolTips[index]:SetToolTip(strInfo);
		
		if(-1 == HPValue) then
		
			-- 跨场景的情况。
			PARTY_HP[index]:SetToolTip("未知");
		else
		
			PARTY_HP[index]:SetToolTip(tostring(HPValue).."/"..tostring(HPMax));
		end;	
		
		PartyFrame_ClerBufInfo(index);
		PartyFrame_UpdateBufInfo(index);

		-- 显示队员出战珍兽图标
		PetButton_Show(index);
	
end


--***********************************************************************************************************************************************
--
-- 更新所有队员信息
--
--************************************************************************************************************************************************
function Refresh_All_Member_Info_Func()
	
		-- 先隐藏掉所有的队员.
		Hide_All_Play_Func();
		
		-- 得到队员的个数
		local iMemCount = DataPool:GetTeamMemberCount();
		--AxTrace( 0,0, "得到队友个数!" .. tostring(iMemCount));
		
		-- 
		if((iMemCount < 1)or(iMemCount > 6)) then
		
			--AxTrace( 0,0, "得到队友个数异常" .. tostring(iMemCount));
			return;
		end
						
		for index = 1, iMemCount - 1 do
			
				-- 显示一个队员
				PartyFrame_UpdatePage(index);
				
				-- 显示队员的详细信息
				Show_Team_Member_Info_Func(index);
				
				-- 显示队员的珍兽按钮
				PetButton_Show(index);

		end
		
		Show_Leader_Flag_Func();
	
end


--***********************************************************************************************************************************************
--
-- 显示队长信息
--
--************************************************************************************************************************************************
function Show_Leader_Flag_Func()

	-- 显示队长标记
	local iIsLeader = DataPool:IsTeamLeader();
	if (1 == iIsLeader) then
		
		Team_Leader_Flag:Show();
	end
		
end


--***********************************************************************************************************************************************
--
-- 选择队友作为target(同游戏中, 右键点击一个模型效果一样)
--
--************************************************************************************************************************************************
function PartyFrame_SelectAsTarget(UIIndex)

	--AxTrace( 0,0, "选择头像");
	DataPool:SelectAsTargetByUIIndex(UIIndex);
end;


--***********************************************************************************************************************************************
--
-- 鼠标移入事件
--
--************************************************************************************************************************************************

function PartyFrame_HP_Text_MouseEnter(UIIndex)

	
		-- 得到队员的详细信息
		--MemberName
		--, strIconIndex
		--, HPValue
		--, HPMax
		--, MPValue
		--, MPMax 
		--, Fammily
		--, Level
		--, Anger
		--, DeadLink
		--, Dead
		--, sex
		--= DataPool:GetTeamMemberInfo( UIIndex );
	--AxTrace( 0,0, "party frame enter"..tostring(UIIndex));
	--local ShowHpTipText = "";
	
	--if(-1 == HPValue) then
	
	--	ShowHpTipText = "未知";
	--else
	
	--	ShowHpTipText = tostring(HPValue).."/"..tostring(HPMax);
	--end;
	--HP_Text_Tip[UIIndex]:SetText(ShowHpTipText);
	
end;

--***********************************************************************************************************************************************
--
-- 鼠标移出事件
--
--************************************************************************************************************************************************

function PartyFrame_HP_Text_MouseLeave(UIIndex)

	--AxTrace( 0,0, "party frame out"..tostring(UIIndex));
	--HP_Text_Tip[UIIndex]:SetText("");
end;

function PartyFrame_ClerAllBufInfo()
	local i;
	for i = 1, 5 do
		PartyFrame_ClerBufInfo( i );
	end
end

function PartyFrame_ClerBufInfo( idx )
	if(idx == nil) then return; end
	if(idx < 1 or idx > 5) then return; end
	
	local i = 0;
	while i < PARTY_BUFF_MAX do
		--AxTrace(0,0,"PartyFrame_ClerBufInfo:"..idx);
		PARTY_IMPACT_CTL[idx][i+1]:SetToolTip("");
		PARTY_IMPACT_CTL[idx][i+1]:Hide();
		i = i + 1;
	end
end

function PartyFrame_UpdateBufInfo( idx )
	if(idx < 1 or idx > 5) then return; end
	local nBuffNum = DataPool:GetTeamMemBufNum(idx);
	if(nBuffNum > PARTY_BUFF_MAX) then nBuffNum = PARTY_BUFF_MAX; end
	
	local i = 0;
	while i < nBuffNum do
		local szIconName;
		local szTipInfo;
		
		szIconName,szTipInfo = DataPool:GetTeamMemBufInfo(idx, i);
		PARTY_IMPACT_CTL[idx][i+1]:SetProperty("ShortImage", szIconName);
		PARTY_IMPACT_CTL[idx][i+1]:Show();
		PARTY_IMPACT_CTL[idx][i+1]:SetToolTip(szTipInfo);
		i = i + 1;
	end
	
	while i < PARTY_BUFF_MAX do
		PARTY_IMPACT_CTL[idx][i+1]:SetToolTip("");
		PARTY_IMPACT_CTL[idx][i+1]:Hide();
		i = i + 1;
	end
end

--***********************************************************************************************************************************************
--
-- 显示队员的珍兽按钮
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_Show(UIIndex)
	
	-- 显示珍兽按钮
	Team_Member_Pet_Button[UIIndex]:Show();

	return
	
end

--***********************************************************************************************************************************************
--
-- 鼠标左键单击：选中队友的当前出战珍兽
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_SetFightPetAsTarget(UIIndex)	
	
	-- 首先通过UI索引来选中队友的珍兽作为当前选中目标
	local iFindFightingPet = DataPool:SelectTeamMemPetAsTargetByUIIndex(UIIndex);
	
	-- 如果找不到队友的出战珍兽
	if (iFindFightingPet == -1) then
	
		PushDebugMessage ("#{ZSAN_90311_2}");			-- 队友不在附近，或者无出战珍兽，无法查看珍兽信息。
			
	end
	
	-- 更新当前的PartyFrame界面
	Update_PartyFrame_Menu ();
	
end

--***********************************************************************************************************************************************
--
-- 鼠标右键单击：打开队友的出战珍兽的选项菜单
-- add by WTT
--
--************************************************************************************************************************************************
function PetButton_ToggleTargetPetPage(UIIndex)

	-- 首先通过UI索引来选中队友的珍兽作为当前选中目标
	local iFindFightingPet = DataPool:SelectTeamMemPetAsTargetByUIIndex(UIIndex);
	
	-- 如果找不到队友的出战珍兽
	if (iFindFightingPet == -1) then
	
		PushDebugMessage ("#{ZSAN_90311_2}");			-- 队友不在附近，或者无出战珍兽，无法查看珍兽信息。
		
	-- 如果能找到队友的出战珍兽
	else
	
		-- 弹出队友珍兽按钮的右键菜单
		Show_Team_Member_Pet_Menu ();
	
	end
	
	-- 更新当前的PartyFrame界面
	Update_PartyFrame_Menu ();
	
end