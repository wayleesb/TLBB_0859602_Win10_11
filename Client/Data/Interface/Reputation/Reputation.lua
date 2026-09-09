


local Reputation_Progress1={};
local Reputation_Progress2={};
local Reputation_Progress3={};
local Reputation_CurLevel = {};
local Reputation_Text		= {};
local Reputation_Name = {};
local Reputation_TextName ={};
local Reputation_Back ={};
local Reputation_RelationType ={};

local Reputation_Page = 0;

function Reputation_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	
end


function Reputation_OnLoad()

	Reputation_TextName = { "少林",
							"明教",
							"丐帮",
							"武当",
							"峨嵋",
							"星宿",
							"天龙",
							"天山",
							"逍遥",
							"大宋朝廷",
							"大宋端王府",
							"大宋民间",
							"大辽朝廷",
							"大辽民间",
							"大理",
							"西夏",
							"番邦",
							"莽盖",
							"遗民",
							"流放者",
							"白苗",
							"黑苗",
							"修罗",
							"山越女祭司",
							"山越男护法",
							"鳄鱼帮",
							"野兽",
							"绿林",
							"妖魔",};


	Reputation_Progress1[ 1 ] = Reputation_Value_Menpai1_Value_Pic1;
	Reputation_Progress1[ 2 ] = Reputation_Value_Menpai2_Value_Pic1;
	Reputation_Progress1[ 3 ] = Reputation_Value_Menpai3_Value_Pic1;
	Reputation_Progress1[ 4 ] = Reputation_Value_Menpai4_Value_Pic1;
	Reputation_Progress1[ 5 ] = Reputation_Value_Menpai5_Value_Pic1;
	Reputation_Progress1[ 6 ] = Reputation_Value_Menpai6_Value_Pic1;
	Reputation_Progress1[ 7 ] = Reputation_Value_Menpai7_Value_Pic1;
	Reputation_Progress1[ 8 ] = Reputation_Value_Menpai8_Value_Pic1;
	Reputation_Progress1[ 9 ] = Reputation_Value_Menpai9_Value_Pic1;
	Reputation_Progress2[ 1 ] = Reputation_Value_Menpai1_Value_Pic2;
	Reputation_Progress2[ 2 ] = Reputation_Value_Menpai2_Value_Pic2;
	Reputation_Progress2[ 3 ] = Reputation_Value_Menpai3_Value_Pic2;
	Reputation_Progress2[ 4 ] = Reputation_Value_Menpai4_Value_Pic2;
	Reputation_Progress2[ 5 ] = Reputation_Value_Menpai5_Value_Pic2;
	Reputation_Progress2[ 6 ] = Reputation_Value_Menpai6_Value_Pic2;
	Reputation_Progress2[ 7 ] = Reputation_Value_Menpai7_Value_Pic2;
	Reputation_Progress2[ 8 ] = Reputation_Value_Menpai8_Value_Pic2;
	Reputation_Progress2[ 9 ] = Reputation_Value_Menpai9_Value_Pic2;
	Reputation_Progress3[ 1 ] = Reputation_Value_Menpai1_Value_Pic3;
	Reputation_Progress3[ 2 ] = Reputation_Value_Menpai2_Value_Pic3;
	Reputation_Progress3[ 3 ] = Reputation_Value_Menpai3_Value_Pic3;
	Reputation_Progress3[ 4 ] = Reputation_Value_Menpai4_Value_Pic3;
	Reputation_Progress3[ 5 ] = Reputation_Value_Menpai5_Value_Pic3;
	Reputation_Progress3[ 6 ] = Reputation_Value_Menpai6_Value_Pic3;
	Reputation_Progress3[ 7 ] = Reputation_Value_Menpai7_Value_Pic3;
	Reputation_Progress3[ 8 ] = Reputation_Value_Menpai8_Value_Pic3;
	Reputation_Progress3[ 9 ] = Reputation_Value_Menpai9_Value_Pic3;

	Reputation_CurLevel[ 1 ] = Reputation_Value_Menpai1_CurrentLevel;
	Reputation_CurLevel[ 2 ] = Reputation_Value_Menpai2_CurrentLevel;
	Reputation_CurLevel[ 3 ] = Reputation_Value_Menpai3_CurrentLevel;
	Reputation_CurLevel[ 4 ] = Reputation_Value_Menpai4_CurrentLevel;
	Reputation_CurLevel[ 5 ] = Reputation_Value_Menpai5_CurrentLevel;
	Reputation_CurLevel[ 6 ] = Reputation_Value_Menpai6_CurrentLevel;
	Reputation_CurLevel[ 7 ] = Reputation_Value_Menpai7_CurrentLevel;
	Reputation_CurLevel[ 8 ] = Reputation_Value_Menpai8_CurrentLevel;
	Reputation_CurLevel[ 9 ] = Reputation_Value_Menpai9_CurrentLevel;

	Reputation_Text[ 1 ] = Reputation_Value_Menpai1_Value_Number; 
	Reputation_Text[ 2 ] = Reputation_Value_Menpai2_Value_Number;
	Reputation_Text[ 3 ] = Reputation_Value_Menpai3_Value_Number;
	Reputation_Text[ 4 ] = Reputation_Value_Menpai4_Value_Number;
	Reputation_Text[ 5 ] = Reputation_Value_Menpai5_Value_Number;
	Reputation_Text[ 6 ] = Reputation_Value_Menpai6_Value_Number;
	Reputation_Text[ 7 ] = Reputation_Value_Menpai7_Value_Number;
	Reputation_Text[ 8 ] = Reputation_Value_Menpai8_Value_Number;
	Reputation_Text[ 9 ] = Reputation_Value_Menpai9_Value_Number;

	Reputation_Name[ 1 ] = Reputation_Value_Menpai1_Name;
	Reputation_Name[ 2 ] = Reputation_Value_Menpai2_Name;
	Reputation_Name[ 3 ] = Reputation_Value_Menpai3_Name;
	Reputation_Name[ 4 ] = Reputation_Value_Menpai4_Name;
	Reputation_Name[ 5 ] = Reputation_Value_Menpai5_Name;
	Reputation_Name[ 6 ] = Reputation_Value_Menpai6_Name;
	Reputation_Name[ 7 ] = Reputation_Value_Menpai7_Name;
	Reputation_Name[ 8 ] = Reputation_Value_Menpai8_Name;
	Reputation_Name[ 9 ] = Reputation_Value_Menpai9_Name;

	Reputation_Back[ 1 ] = Reputation_Value_Menpai1_Back;
	Reputation_Back[ 2 ] = Reputation_Value_Menpai2_Back;
	Reputation_Back[ 3 ] = Reputation_Value_Menpai3_Back;
	Reputation_Back[ 4 ] = Reputation_Value_Menpai4_Back;
	Reputation_Back[ 5 ] = Reputation_Value_Menpai5_Back
	Reputation_Back[ 6 ] = Reputation_Value_Menpai6_Back;
	Reputation_Back[ 7 ] = Reputation_Value_Menpai7_Back;
	Reputation_Back[ 8 ] = Reputation_Value_Menpai8_Back;
	Reputation_Back[ 9 ] = Reputation_Value_Menpai9_Back;
	
	Reputation_RelationType[ 1 ] = Reputation_Value_Menpai1_Relation;
	Reputation_RelationType[ 2 ] = Reputation_Value_Menpai2_Relation;
	Reputation_RelationType[ 3 ] = Reputation_Value_Menpai3_Relation;
	Reputation_RelationType[ 4 ] = Reputation_Value_Menpai4_Relation;
	Reputation_RelationType[ 5 ] = Reputation_Value_Menpai5_Relation
	Reputation_RelationType[ 6 ] = Reputation_Value_Menpai6_Relation;
	Reputation_RelationType[ 7 ] = Reputation_Value_Menpai7_Relation;
	Reputation_RelationType[ 8 ] = Reputation_Value_Menpai8_Relation;
	Reputation_RelationType[ 9 ] = Reputation_Value_Menpai9_Relation;
end

-- OnEvent

function Reputation_OnEvent(event)
	if( event =="OPEN_WINDOW" ) then
		AxTrace( 0,0, "OPEN_WINDOW   "..arg0 )	
		if( arg0 == "Reputation" ) then
			AxTrace( 0,0, "Reputation_Update   " );
			Reputation_UpdateData();
			this:Show();
		end
	end
end

function Reputation_UpdateData()
	AxTrace( 0,0, "Reputation_Update   " )
	local i = 1;	
	for i = 1, 9 do
		Reputation_Back[ i ]:Hide();
	end
	if( Reputation_Page == 0 ) then 
		for i = 1, 9 do
			Reputation_Update( i, i );
		end
	elseif( Reputation_Page == 1 ) then
		Reputation_Update( 1, 10 );
		Reputation_Update( 2, 13 );
		Reputation_Update( 3, 15 );
		Reputation_Update( 4, 16 );
		Reputation_Update( 5, 17 );
	elseif( Reputation_Page == 2 ) then
		Reputation_Update( 1, 19 );
		Reputation_Update( 2, 20 );
		Reputation_Update( 3, 26 );
	end
end

function Reputation_Update( nIndex, nTragetID )
	local nReputation = Player:GetReputation( nTragetID );
	local nCurrentNumber;		--这一级的当前值
	local nCurrentMaxNumber;--这一级的最大值
	local strTypeMax;
	local nType = 1;
	if( nReputation < -550000 ) then 
		nCurrentNumber = -550000 - nReputation ;
		nCurrentMaxNumber = 450000;
		strTypeMax = "痛恨";
	elseif( nReputation < -320000 ) then
		nCurrentNumber = -320000 - nReputation ;
		nCurrentMaxNumber = 230000;
		strTypeMax = "憎恶";
	elseif( nReputation < -160000 ) then
		nCurrentNumber = -160000 - nReputation ;
		nCurrentMaxNumber = 160000;
		strTypeMax = "对立";
	elseif( nReputation < -60000 ) then
		nCurrentNumber = -60000 - nReputation ;
		nCurrentMaxNumber = 100000;
		strTypeMax = "敌意";
		nType = 2;
	elseif( nReputation < 0 ) then
		nCurrentNumber = -nReputation;
		nCurrentMaxNumber = 60000;
		strTypeMax = "反感";
		nType = 2;
	elseif( nReputation < 60000 ) then
		nCurrentNumber = nReputation;
		nCurrentMaxNumber = 60000;
		strTypeMax = "漠视";
		nType = 2;
	elseif( nReputation < 160000 ) then
		nCurrentNumber = nReputation - 60000;
		nCurrentMaxNumber = 100000;
		strTypeMax = "好意";
		nType = 2;
	elseif( nReputation < 320000 ) then
		nCurrentNumber = nReputation - 160000;
		nCurrentMaxNumber = 160000;
		strTypeMax = "友善";
		nType = 2;
	elseif( nReputation < 550000 ) then
		nCurrentNumber = nReputation - 320000;
		nCurrentMaxNumber = 230000;
		strTypeMax = "尊敬";
		nType = 3;
	elseif( nReputation < 1000000 ) then
		nCurrentNumber = nReputation - 550000;
		nCurrentMaxNumber = 450000;
		strTypeMax = "信赖";
		nType = 3;
	else
		nCurrentNumber = 0;
		nCurrentMaxNumber = 0;
		strTypeMax = "敬爱";
		nType = 3;
	end
	Reputation_Back[ nIndex ]:Show();
	AxTrace( 0,8,"nReputation ="..tonumber(nReputation).." nType="..tonumber( nType ) );
	Reputation_Progress1[ nIndex ]:Hide();
	Reputation_Progress2[ nIndex ]:Hide();
	Reputation_Progress3[ nIndex ]:Hide();
	Reputation_CurLevel[ nIndex ]:SetText( "当前声望：".. strTypeMax );
	Reputation_Text[ nIndex ]:SetText( tostring( nCurrentNumber ).."/"..tostring( nCurrentMaxNumber ) );
	Reputation_Name[ nIndex ]:SetText( Reputation_TextName[ nTragetID ] );
	
	if( nType == 1 ) then
		Reputation_RelationType[ nIndex ]:SetProperty( "SetCurrentImage", "Enemy" );
		Reputation_Progress1[ nIndex ]:SetProgress( nCurrentNumber, nCurrentMaxNumber );
		Reputation_Progress1[ nIndex ]:Show();
	elseif( nType == 2 ) then
		Reputation_RelationType[ nIndex ]:SetProperty( "SetCurrentImage", "Normal" );
		Reputation_Progress2[ nIndex ]:SetProgress( nCurrentNumber, nCurrentMaxNumber );
		Reputation_Progress2[ nIndex ]:Show();
	elseif( nType == 3 ) then
		Reputation_RelationType[ nIndex ]:SetProperty( "SetCurrentImage", "Friend" );
		Reputation_Progress3[ nIndex ]:SetProgress( nCurrentNumber, nCurrentMaxNumber );
		Reputation_Progress3[ nIndex ]:Show();
	end
	
end

function Reputation_OnPageClick( nIndex )
	Reputation_Page = nIndex;
	Reputation_UpdateData();
end