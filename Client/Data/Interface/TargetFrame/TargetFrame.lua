
local strMenPaiName ={
						"少林",
						"明教",	
						"丐帮",	
						"武当",	
						"峨嵋",	
						"星宿",	
						"天龙",	
						"天山",	
						"逍遥",
						"新手",	
						"大宋",
						"大宋",
						"大宋",
						"大辽",
						"大辽",
						"大理",	
						"西夏",	
						"番邦",	
						"莽盖",	
						"遗民",	
						"狼人",	
						"白苗",	
						"黑苗",	
						"修罗",	
						"越女",
						"越男",
						"鳄神",	
						"野兽",	
						"绿林",	
						"妖魔",};


function TargetFrame_PreLoad()
	this:RegisterEvent("MAINTARGET_CHANGED")
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_RAGE");
	this:RegisterEvent("UNIT_LEVEL");
	this:RegisterEvent("UNIT_RELATIVE");
	this:RegisterEvent("MAINTARGET_OPEN")
end

function TargetFrame_OnLoad()

end

function TargetFrame_OnEvent(event)

	if ( event == "MAINTARGET_OPEN" ) then
	
		--AxTrace(0,0,"打开main target");
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_Update_Name_Team();
		TargetFrame_Update_HP_Team();
		TargetFrame_Update_MP_Team();
		TargetFrame_Update_Rage_Team();
		TargetFrame_Update_Level_Team();
		this:Show();
		return;
	end;
	
	if ( event == "MAINTARGET_CHANGED" ) then
	
		AxTrace(0,0,"id === "..tostring(arg0));
	  if(-1 == tonumber(arg0)) then
	  
	  	this:Hide();
	  	return;
	  end;
	  
		if( Target:IsPresent()) then
			this:Show();
			TargetFrame_Update_Name();
			TargetFrame_Update_HP();
			TargetFrame_Update_MP();
			TargetFrame_Update_Rage();
			TargetFrame_Update_Level();
		else
		
			if(Target:IsTargetTeamMember()) then
			
				this:Show();
				TargetFrame_DataBack:Show();
				TargetFrame_DataBack2:Hide();
			else
				this:Hide();
			end;
				
		end
		return;
	end
	
	
	
	if( (event == "UNIT_MP") and Target:IsPresent()) then
		TargetFrame_Update_MP();
		return;
	end

	if( (event == "UNIT_HP") and Target:IsPresent()) then
		TargetFrame_Update_HP();
		return;
	end

	if( (event == "UNIT_RAGE") and Target:IsPresent()) then
		TargetFrame_Update_Rage();
		return;
	end

	if( (event == "UNIT_LEVEL") and Target:IsPresent()) then
		TargetFrame_Update_Level();
		return;
	end

	if( (event == "UNIT_RELATIVE") and Target:IsPresent()) then
		TargetFrame_Update_Name();
		return;
	end
	
	
	
	
	-------------------------------------------------------------------------------------------------
	--
	-- 当target是自己的时候无法刷新。
	--
	
	--if( (event == "UNIT_MP") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_MP();
	--	return;
	--end

	--if( (event == "UNIT_HP") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_HP();
	--	return;
	--end

	--if( (event == "UNIT_RAGE") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Rage();
	--	return;
	--end

	--if( (event == "UNIT_LEVEL") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Level();
	--	return;
	--end

	--if( (event == "UNIT_RELATIVE") and (arg0 == "target") and Target:IsPresent()) then
	--	TargetFrame_Update_Name();
	--	return;
	--end
end

function TargetFrame_Update_Name()
	local txtColor="#cFFFFFF";
--or Target:GetData("ISNPC") == 0
--以前玩家统一显示为白色，根据阮枚5月27日文档更改，玩家和NPC走同一规则。
	if Target:GetData( "RELATIVE" ) == 2  then 
		txtColor = "#W"
	else
		txtColor = "#R"
	end
	TargetFrame_NameBar : Show();
	local occupation = Target:GetData("OCCUPATION")
	
	AxTrace(0,1,"OCCUPATION="..occupation)
	if(occupation == -1) then
		TargetFrame_NameBar : SetImageColor("FF00FF00")
	elseif(occupation == 0) then
		TargetFrame_NameBar : SetImageColor("FFFFFFFF")
	elseif(occupation == 1) then
		TargetFrame_NameBar : SetImageColor("FFFF0000")
	end

	TargetFrame_Name:SetText( txtColor..Target:GetName());
	TargetFrame_Name:Show();
	AxTrace( 8,0,txtColor..Target:GetName() );
	local szIcon = Target : GetData("PORTRAIT");
	TargetFrame_Icon:SetProperty("Image", szIcon);
--添加判断目标属性的设计
	--“宠”“人”“傀”“兽”“莽”“修”“妖”
	local nNpcType = Target:GetData( "TYPE" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName"..tostring( nNpcType ) );
	
	--1.友好
	--2.中立
	--3.珍兽
	--4.普通敌人
	--5.精英敌人
	--6.敌方boss	
	local nNpcRelation = Target:GetData( "RELATION" );
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame"..tostring( nNpcRelation ) );
	
	--跟新门派
	local nNpcReputation = Target:GetData( "MEMPAI" );
	if( nNpcReputation == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nNpcReputation ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nNpcReputation + 1 ] );
	end
	
end

function TargetFrame_Update_HP()
	local nNpcRelation = Target:GetData( "RELATION" );
	if( tonumber( nNpcRelation ) == 6 ) then
		TargetFrame_DataBack:Hide();
		TargetFrame_DataBack2:Show();
		local hp = Target:GetHPPercent();
		TargetFrame_HP_Boss1:SetProgress( hp * 3, 1 );
		TargetFrame_HP_Boss2:SetProgress( ( hp - 0.33333 ) * 3, 1 );
		TargetFrame_HP_Boss3:SetProgress( ( hp - 0.66666 ) * 3, 1 );
	else
		TargetFrame_DataBack:Show();
		TargetFrame_DataBack2:Hide();
		TargetFrame_HP:SetProgress(Target:GetHPPercent(), 1);
		TargetFrame_Update_Name();
	end
end

function TargetFrame_Update_MP()
	TargetFrame_MP:SetProgress(Target:GetMPPercent(), 1);
end

function TargetFrame_Update_Rage()
	TargetFrame_SP:SetProgress(Target:GetRagePercent(), 1);
end

function TargetFrame_Update_Level()

	local txtColor="#cFFFFFF";
	local level =  Target:GetData( "LEVEL" ) - Player:GetData( "LEVEL" );
	
	AxTrace( 0,0, "等级差为"..tostring( level ) );
--根据阮枚5月27日策划文档修改
--	if( level > 12 ) then
--		txtColor = "#R";
--	elseif( level > 4 ) then
--		txtColor = "#cff9000";
--		--以前是c9ccf00，根据杨耀提供的.jpg修改
--	elseif( level > -4 ) then
--		txtColor="#Y";
--	elseif( level > -12 ) then
--		txtColor="#G"
--	else
--		txtColor="#c4b4b4b";
--根据杨耀口述修改
--		txtColor="#c240c0c";
--	end

--根据阮枚5月27日策划文档修改如下
	if( level > 5 ) then
		txtColor = "#R";
	elseif( level > 2 ) then
		txtColor = "#cff9000";
		--以前是c9ccf00，根据杨耀提供的.jpg修改
	elseif( level >= -2 ) then
		txtColor="#Y";
	elseif( level >= -5 ) then
		txtColor="#W"
	else
--		txtColor="#c4b4b4b";
--根据杨耀口述修改
		txtColor="#W";
	end
	

	if( tonumber( Target:GetData( "LEVEL" ) ) >= 200 ) then
		TargetFrame_LevelText:SetText(txtColor .."?");
	else
		TargetFrame_LevelText:SetText(txtColor .. tostring(Target:GetData( "LEVEL" )));
	end
end

function TargetFrame_ArtLayout_Click()
	ShowContexMenu("other_player");
end

-- 显示右键菜单
function TargetFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Target 右键菜单!");
	OpenTargetMenu();
end


function	TargetFrame_Update_Name_Team()

	local strName = Target:TargetFrame_Update_Name_Team();
	local nMenpai = Target:TargetFrame_Update_Menpai_Team();
	TargetFrame_Name:SetText(strName);
	if( tonumber(nMenpai) == -1 ) then
		TargetFrame_CampFrame1:Hide();
	else
		TargetFrame_CampFrame1:Show();
		TargetFrame_CampFrame:SetProperty( "SetCurrentImage", "Reputation"..tostring( nMenpai ) );
		TargetFrame_CampFrame:SetToolTip( strMenPaiName[ nMenpai + 1 ] );
	end
	local strIcon = Target:TargetFrame_Update_Icon_Team();
	TargetFrame_Icon:SetProperty("Image", strIcon);
	TargetFrame_TypeFrame:SetProperty( "SetCurrentImage", "TypeFrame1" );
	TargetFrame_TypeIcon:SetProperty( "SetCurrentImage", "TypeName2" );
end;

function 	TargetFrame_Update_HP_Team()

	local TeamHP = Target:TargetFrame_Update_HP_Team();
	TargetFrame_HP:SetProgress(TeamHP, 1);
end;
	
function	TargetFrame_Update_MP_Team()
	
	local TeamMp = Target:TargetFrame_Update_MP_Team();
	TargetFrame_MP:SetProgress(TeamMp, 1);
end;

function	TargetFrame_Update_Rage_Team()

	local TeamRange = Target:TargetFrame_Update_Rage_Team();
	TargetFrame_SP:SetProgress(TeamRange, 1000);
end;

function	TargetFrame_Update_Level_Team()

	local TeamLevel = Target:TargetFrame_Update_Level_Team();
	TargetFrame_LevelText:SetText(tostring(TeamLevel));
end;