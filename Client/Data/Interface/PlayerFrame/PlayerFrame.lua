
local FlashPoint = 1/5;
local PlayerHP = 0;
local PlayerMaxHP = 0;

local PlayerMP = 0;
local PlayerMaxMP = 0;

local PlayerRage = 0;
local PlayerMaxRage = 100;

local StrikePoint = 0;

local iMouseInPos = 0;	-- 0 :空白处
												-- 1 : 在血条处
												-- 2 : 在法力条处
                        -- 3 : 在怒气条处
local DoubleHit = {}

local PetFlashTime = 10*1000			--珍兽按钮闪烁时间10秒钟，单位是毫秒，所以乘以1000转换为秒
local HuoDongTime  = 30*1000      --活动按钮闪烁时间30秒钟


local LEVEL_LIMIT = 10;						--10级以下无法打开

--OnLoad

function PlayerFrame_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("UNIT_NAME");
	this:RegisterEvent("UNIT_HP");
	this:RegisterEvent("UNIT_MANA");
	this:RegisterEvent("UNIT_HP_PERCENT");
	this:RegisterEvent("UNIT_MP_PERCENT");
	this:RegisterEvent("UNIT_RAGE");			-- 注册怒气
	
	this:RegisterEvent("UNIT_MAX_HP");
	this:RegisterEvent("UNIT_MP");
	this:RegisterEvent("UNIT_MAX_MP");
	
	this:RegisterEvent("UNIT_STRIKEPOINT");
	this:RegisterEvent("UNIT_FACE_IMAGE");

	this:RegisterEvent("TEAM_REFRESH_MEMBER");
	this:RegisterEvent("TEAM_NOTIFY_APPLY");
	this:RegisterEvent("UPDATE_PETINVITEFRIEND");
	this:RegisterEvent("FLAH_MINIMAP");
	
	this:RegisterEvent("STOP_FLAH_MINIMAP");
	this:RegisterEvent("UPDATE_BTN_FLASH");	--zchw
	this:RegisterEvent("SHOW_UPDATE_UI");	--zchw
		
end

function PlayerFrame_OnLoad()
	DoubleHit[1] = PlayerFrame_DoubleHit1;
	DoubleHit[2] = PlayerFrame_DoubleHit2;
	DoubleHit[3] = PlayerFrame_DoubleHit3;
	DoubleHit[4] = PlayerFrame_DoubleHit4;
	DoubleHit[5] = PlayerFrame_DoubleHit5;
	DoubleHit[6] = PlayerFrame_DoubleHit6;
	DoubleHit[7] = PlayerFrame_DoubleHit7;
	DoubleHit[8] = PlayerFrame_DoubleHit8;
	DoubleHit[9] = PlayerFrame_DoubleHit9;
	
	PlayerFrame_Captain:Hide();
	PlayerFrame_ZhengShouZhenYouFlash:Hide();
	PlayerFrame_UpdateBtnFlash:Hide();
	--应该策划写到字典和xml布局文件里 PlayerFrame_ZhenShouZhengYou:SetToolTip("打开征友交互界面");
	PlayerFrame_ZhenShouZhengYou:SetToolTip("#{ZYPT_081103_001}");
	
end

function PlayerFrame_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
	
	
		----AxTrace( 0,0, "enter word!");
		this:Show();
		
		--PlayerFrame_HP_Text:SetClippedByParent(0);
		--PlayerFrame_MP_Text:SetClippedByParent(0);
		--PlayerFrame_SP_Text:SetClippedByParent(0);
		
		PlayerFrame_Update();
		-- 更新头像信息.
		
		--AxTrace( 0,0, "enter word!");
		--AxTrace( 0,0, "更新头像");
		PlayerFrame_Update_Image();
		return;
	end

	--AxTrace( 0,0, tostring(event));
	if( (event == "UNIT_NAME") and (arg0 == "player")) then
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_MAX_MP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MAX_MP");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_MAX_HP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MAX_HP");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_MP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MP");
		PlayerFrame_Update();
		return;
	end
	if( (event == "UNIT_HP") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_HP");
		PlayerFrame_Update();
		return;
	end

	if( (event == "UNIT_MANA") and (arg0 == "player")) then
	
		----AxTrace( 0,0, "UNIT_MANA");
		PlayerFrame_Update();
		return;
	end
	
	if( (event == "UNIT_MP_PERCENT") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_MP_PERCENT");
		PlayerFrame_Update();
		return;
	end
	
	if( (event == "UNIT_RAGE") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_RAGE");
		PlayerFrame_Update();
		return;
	end

	if( (event == "UNIT_HP_PERCENT") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_HP_PERCENT");
		PlayerFrame_Update();
		return;
	end

	if( (event == "UNIT_STRIKEPOINT") and (arg0 == "player") ) then
	
		----AxTrace( 0,0, "UNIT_STRIKEPOINT");
		PlayerFrame_Update();
		return;
	end
	
	--AxTrace( 0,0, "开始得到头像");
	-- 头像信息改变
	if( (event == "UNIT_FACE_IMAGE") and (arg0 == "player") ) then
	
		--AxTrace( 0,0, "UNIT_FACE_IMAGE");
		PlayerFrame_Update_Image();
		return;
	end

	if( event == "TEAM_REFRESH_MEMBER" ) then
		PlayerFrame_Update();
	end
	if( event == "TEAM_NOTIFY_APPLY" ) then
		PlayerFrame_Update();
	end
	if( event == "UPDATE_PETINVITEFRIEND" ) then
		if( arg0 == "notifynew" ) then
			PlayerFrame_Flash_PetFriend(0);
			SetTimer( "PlayerFrame", "PlayerFrame_Flash_PetFriend(1)",PetFlashTime);
		end
	end
	
	if (event == "UPDATE_BTN_FLASH") then
		PlayerFrame_UpdateBtnFlash:Show();		
	end
	
	if (event == "SHOW_UPDATE_UI") then
		Helper:GotoRecUpdate();
	end
	
end

function PlayerFrame_UpdateBtnOnClicked()
	PlayerFrame_UpdateBtnFlash:Hide();
	Player:ClearUpdateBtnFlashFlag();
	Helper:GotoRecUpdate();		
end

function PlayerFrame_Flash_PetFriend( who )
	--who == 0 开始闪烁 ，否则停止闪烁
	if( who == 0 ) then
		PlayerFrame_ZhengShouZhenYouFlash:Show();
	else
		PlayerFrame_ZhengShouZhenYouFlash:Hide();
		KillTimer("PlayerFrame_Flash_PetFriend(1)");
	end
end

function PlayerFrame_Update()

	--AxTrace( 0,0, "1");
	if( tonumber( Player:IsLeader() ) == 1 ) then
		PlayerFrame_Captain:Show();
	else
		PlayerFrame_Captain:Hide();
	end
	PlayerHP= Player:GetData( "HP" );
	PlayerMaxHP = Player:GetData("MAXHP");
	if(0 == PlayerMaxHP) then
	
		PlayerMaxHP = 1;
	end;
	PlayerFrame_HP:SetProgress(PlayerMaxHP > 0 and math.min(1, math.max(0, PlayerHP / PlayerMaxHP)) or 0, 1);
	if( PlayerHP / PlayerMaxHP > FlashPoint ) then
		PlayerFrame_Mask:Hide();
		PlayerFrame_HP_Flash:Play( false );
	else
		local Width ,Height= PlayerFrame_HP:GetWindowSize();
		Width =Width * PlayerHP / PlayerMaxHP;
		PlayerFrame_HP_Flash:SetWindowSize(Width,Height)
		PlayerFrame_HP_Flash:Play( true );
		PlayerFrame_Mask:Show();
	end

	PlayerMP = Player:GetData( "MP" );
	PlayerMaxMP = Player:GetData("MAXMP");
	if(0 == PlayerMaxMP) then
	
		PlayerMaxMP = 1;
	end;	
	PlayerFrame_MP:SetProgress(PlayerMaxMP > 0 and math.min(1, math.max(0, PlayerMP / PlayerMaxMP)) or 0, 1);
	
	--AxTrace( 0,0, "显示怒气"..tostring(PlayerRage));
	-- 显示怒气
	PlayerRage = Player:GetData( "RAGE" );
  PlayerMaxRage = Player:GetData( "MAXRAGE" );
  if(0 == PlayerMaxRage) then
  
  	PlayerMaxRage = 1;
  end;
 	PlayerFrame_SP:SetProgress(PlayerRage, PlayerMaxRage);
	
	--AxTrace( 0,0, "4");
	-- 显示名字
	local strName = Player:GetName();
	
	strName = "#cDED784"..strName;
	PlayerFrame_Name:SetText( strName );
	
	--AxTrace( 0,0, "5");
	strName = Player:GetData("STRIKEPOINT");
	StrikePoint = tonumber(strName);
	
--	----AxTrace(0,1,"StrikePoint="..StrikePoint);
	
	--AxTrace( 0,0, "6");
	for	i=1, 9 do
		if i <= StrikePoint then
--			DoubleHit[i] : SetImageColor("FF00FF00");	
			DoubleHit[i] : Show();
		else
--			DoubleHit[i] : SetImageColor("FFFFFFFF");	
			DoubleHit[i] : Hide();
		end
	end
	
	
	--AxTrace( 0,0, "7");
	--显示等级
	local nNumber = Player:GetData( "LEVEL" );
	PlayerFrame_Level:SetText("#cDED784"..tostring(nNumber));
	
	
	
end

--用户单击了征友平台的按钮 modified by dun.liu
function PlayerFrame_HitZhengShou()
	local level = Player:GetData("LEVEL");
	if level < LEVEL_LIMIT then
		PushDebugMessage("#{ZYPT_081103_002}");
		return;
	end
	OpenWindow("ZhengyouWindow")
	RequestServerNoteLog(0);      --向server发送请求，记录一条日志
end

function PlayerFrame_HP_Text_MouseEnter()
	PlayerFrame_HP_Text:SetText( string.format("%.0f", PlayerHP) .. "/" .. string.format("%.0f", PlayerMaxHP) );
	iMouseInPos = 1;
end

function PlayerFrame_HP_Text_MouseLeave()
	PlayerFrame_HP_Text:SetText("");
	iMouseInPos = 0;
end

function PlayerFrame_MP_Text_MouseEnter()
	
	PlayerFrame_MP_Text:SetText( string.format("%.0f", PlayerMP) .. "/" .. string.format("%.0f", PlayerMaxMP) );
	iMouseInPos = 2;
end

function PlayerFrame_MP_Text_MouseLeave()
	PlayerFrame_MP_Text:SetText("");
	iMouseInPos = 0;
end


function PlayerFrame_SP_Text_MouseEnter()
	PlayerFrame_SP_Text:SetText( tostring( PlayerRage ) .. "/" .. tostring( 1000) );
	iMouseInPos = 3;
end

function PlayerFrame_SP_Text_MouseLeave()
	PlayerFrame_SP_Text:SetText("");
	iMouseInPos = 0;
end


function PlayerFrame_Update_Image()

	local strFaceImage = Player:GetData( "PORTRAIT" );
	
	--AxTrace( 0,0, "头像信息!" .. tostring(strFaceImage));
	-- 设置头像信息
	PlayerFrame_Icon:SetProperty("Image", tostring(strFaceImage));
	PlayerFrame_Icon_Action:SetProperty("NormalImage", tostring(strFaceImage));
	PlayerFrame_Icon_Action:SetProperty("HoverImage", tostring(strFaceImage));
	PlayerFrame_Icon_Action:SetProperty("PushedImage", tostring(strFaceImage));
end

-- 右键菜单
function PlayerFrame_Show_Menu_Func()

	--AxTrace( 0,0, "Player 右键菜单!");
	--OpenTargetMenu();
	Player:ShowMySelfContexMenu();
end

-- 左键选中自己
function PlayerFrame_SelectMyselfAsTarget()
	Player:SelectMyselfAsTarget();
	
end
function PlayerFrame_ShowTooltip( type )
	local strTooltip = "血:"..string.format("%.0f", PlayerHP) .. "/" .. string.format("%.0f", PlayerMaxHP).."#r".."气:"..string.format("%.0f", PlayerMP) .. "/" .. string.format("%.0f", PlayerMaxMP).."#r".."怒:"..tostring( PlayerRage ) .. "/" .. tostring( 1000);
	if( type == 1 )	then
		PlayerFrame_HP:SetToolTip( strTooltip );
	elseif( type == 2 ) then
		PlayerFrame_MP:SetToolTip( strTooltip );
	else
		PlayerFrame_SP:SetToolTip( strTooltip );
	end

end

function PlayerFrame_HideTooltip()
	
end