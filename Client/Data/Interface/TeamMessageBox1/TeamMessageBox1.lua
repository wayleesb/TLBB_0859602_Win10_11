g_InitiativeClose = 0;

local InviteIndex = 0;

local g_Frame = {};
local g_ShowText = {};
	
--===============================================
-- OnLoad()
--===============================================
function TeamMessageBox1_PreLoad()

	-- 队员邀请某人加入队伍请你同意.
	this:RegisterEvent("TEAM_MEMBER_INVITE");
	
end

function TeamMessageBox1_OnLoad()
	
	-- 对话框
	g_Frame[1] = TeamMessageBox1_Frame;
	g_Frame[2] = TeamMessageBox2_Frame;
	g_Frame[3] = TeamMessageBox3_Frame;
	g_Frame[4] = TeamMessageBox4_Frame;
	g_Frame[5] = TeamMessageBox5_Frame;
	
	-- 显示文字
	g_ShowText[1] = TeamMessageBox1_Text;
	g_ShowText[2] = TeamMessageBox2_Text;
	g_ShowText[3] = TeamMessageBox3_Text;
	g_ShowText[4] = TeamMessageBox4_Text;
	g_ShowText[5] = TeamMessageBox5_Text;
	
	this:Show();
	
	
end

--===============================================
-- OnEvent()
--===============================================
function TeamMessageBox1_OnEvent(event)

	-- 队员邀请某人加入队伍请你同意
	if ( event == "TEAM_MEMBER_INVITE" ) then
		TeamMessageBox_Show_Message(arg0, arg1, arg2, arg3, arg4);
	end;	
	
	TeamMessageBox1_UpdateFrame();

end

--===============================================
-- UpdateFrame
--===============================================
function TeamMessageBox1_UpdateFrame()
	

end

--===============================================
-- 点击确定（IDOK）
--===============================================
function TeamMessageBox1_OK_Clicked()
	
	Player:SendAgreeJoinTeam_TeamMemberInvite(1);
	g_Frame[1]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox1_Cancel_Clicked()
	
	--处理有人邀请你加入队伍
		Player:SendRejectJoinTeam_TeamMemberInvite(1);
	g_Frame[1]:Hide();
	
end



--===============================================
-- 点击确定（IDOK）
--===============================================
function TeamMessageBox2_OK_Clicked()
	
	Player:SendAgreeJoinTeam_TeamMemberInvite(2);
	g_Frame[2]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox2_Cancel_Clicked()
	
	--处理有人邀请你加入队伍
		Player:SendRejectJoinTeam_TeamMemberInvite(2);
	g_Frame[2]:Hide();
	
	
end




--===============================================
-- 点击确定（IDOK）
--===============================================
function TeamMessageBox3_OK_Clicked()
	
	Player:SendAgreeJoinTeam_TeamMemberInvite(3);
	g_Frame[3]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox3_Cancel_Clicked()
	
	--处理有人邀请你加入队伍
		Player:SendRejectJoinTeam_TeamMemberInvite(3);
	g_Frame[3]:Hide();
	
	
end





--===============================================
-- 点击确定（IDOK）
--===============================================
function TeamMessageBox4_OK_Clicked()
	
	Player:SendAgreeJoinTeam_TeamMemberInvite(4);
	g_Frame[4]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox4_Cancel_Clicked()
	
	--处理有人邀请你加入队伍
		Player:SendRejectJoinTeam_TeamMemberInvite(4);
	g_Frame[4]:Hide();
	
	
end






--===============================================
-- 点击确定（IDOK）
--===============================================
function TeamMessageBox5_OK_Clicked()
	
	Player:SendAgreeJoinTeam_TeamMemberInvite(5);
	g_Frame[5]:Hide();
end

--===============================================
-- (IDCONCEL)
--===============================================
function TeamMessageBox5_Cancel_Clicked()
	
	--处理有人邀请你加入队伍
		Player:SendRejectJoinTeam_TeamMemberInvite(5);
	g_Frame[5]:Hide();
	
	
end


function TeamMessageBox_Show_Message(strInviter, strDesName, strDesLevel,strDestMenpai,strPos)

	local menpai = tonumber(strDestMenpai);
	local indexMess = tonumber(strPos);
	local strMenPai
	
	if(0 == menpai) then
		strMenPai = "少林";
			
		elseif(1 == menpai) then
			strMenPai = "明教";
			
		elseif(2 == menpai) then
			strMenPai = "丐帮";
			
		elseif(3 == menpai) then
			strMenPai = "武当";
		
		elseif(4 == menpai) then
			strMenPai = "峨嵋";
		
		elseif(5 == menpai) then
			strMenPai = "星宿";
		
		elseif(6 == menpai) then
			strMenPai = "天龙";
		
		elseif(7 == menpai) then
			strMenPai = "天山";
		
		elseif(8 == menpai) then
			strMenPai = "逍遥";
		
	else
		strMenPai = "无门派";
	end	
	
	
	if(-1 == indexMess) then
		return;
	end;
	
	indexMess = indexMess+ 1;
	this:Show();
	g_Frame[indexMess]:Show();
	
	local strShowInfo ="";
	strShowInfo ="#R" ..strInviter.. "#cfff263邀请#R" .. strDesName .. "#G["..strDesLevel.."级"..strMenPai.."]#cfff263加入队伍，同意吗？";
	g_ShowText[indexMess]:SetText(strShowInfo);
end
