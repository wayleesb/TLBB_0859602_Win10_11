local g_CurMap = "Minimap";
local TimeDot = {}

--OnLoad
--  0 Animy
--  1 ExpNPC
--  2 Teamate
--  3 OtherPlayer
--  4 ExpObj
function MiniMap_PreLoad()

	
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UPDATE_MAP");
	this:RegisterEvent("OPEN_MINIMAP" );
	this:RegisterEvent("ACCELERATE_KEYSEND");
	this:RegisterEvent("UPDATE_NETSTATUS");
	this:RegisterEvent("PKMODE_CHANGE");
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("SHOW_NEEDREPAIR")
	this:RegisterEvent("LEFTPROTECTTIME_CHANGE")

	this:RegisterEvent("OPEN_MINIMAPEXP");

	this:RegisterEvent("FLAH_MINIMAP");
	
	this:RegisterEvent("STOP_FLAH_MINIMAP");
	
	--add by fangyuan
		this:RegisterEvent("SHOW_ACCOUNT_SAFE_ICON");

	this:RegisterEvent("SHOW_SHIMINGRENZHENG_ANIMATA");

	this:RegisterEvent("MINIMAP_SHOW_SHIMINGRENZHENG_BTN");

	this:RegisterEvent("PLAYERASK_INGAME");

	this:RegisterEvent("MINMAP_PLAYERLIST_SHOW");
	
end

function MiniMap_PK_Mode_Show_Menu_Func()
	
	 Player:PVP_ShowMenu();
end;

function MiniMap_OnLoad()
	TimeDot[1] = MiniMap_TimeDot1
	TimeDot[2] = MiniMap_TimeDot2
	TimeDot[3] = MiniMap_TimeDot3
	TimeDot[4] = MiniMap_TimeDot4
	TimeDot[5] = MiniMap_TimeDot5
	TimeDot[6] = MiniMap_TimeDot6
	TimeDot[7] = MiniMap_TimeDot7
	TimeDot[8] = MiniMap_TimeDot8
	TimeDot[9] = MiniMap_TimeDot9
	TimeDot[10] = MiniMap_TimeDot10
	TimeDot[11] = MiniMap_TimeDot11
	TimeDot[12] = MiniMap_TimeDot12
	MiniMap_EquipEndurance:Hide();
	AxTrace(12,12,"MiniMap_OnLoad is called begin");
	MiniMap_AccountSafeBack:Hide();
	
	Minimap_Max();
	MiniMap_Yuanbao:SetToolTip("元宝商店");
	MiniMap_AutoSearch:SetToolTip("#{INTERFACE_XML_983}");
	MiniMap_NetStatus_Flash:Play( false );

	MiniMap_Fangchengmi_Btn	: Hide()
	MiniMap_Fangchengmi_Flash : Hide();
end
function MiniMap_UpdateSceneName()
	local scenename;
	scenename = GetCurrentSceneName();
	local len = UTF8Length(scenename);
	if( len < 10 ) then	
		MiniMap_Placename:SetProperty( "Font", "YouYuan9.75" );
	else
		MiniMap_Placename:SetProperty( "Font", "SongTiBmp12" );
	end
	MiniMap_Placename:SetText("#gFF0FA0".. scenename );
end

function MiniMap_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 1238 ) then
			local sceneId = Get_XParam_INT(0)
			return
	end
	
	if ( event == "SCENE_TRANSED" ) then
		MiniMap_Update( arg0 );
		MiniMap_UpdateSceneName();
		UpdateMinimapState();

	elseif ( event == "UPDATE_MAP" ) then
		if( tonumber( arg0 ) == 1 ) then
			MiniMap_UpdateSceneName();
		end
		MiniMap_PosModify();
		Minimap_CoordinateUpdate();
	elseif( event == "OPEN_MINIMAP" ) then
		Variable:SetVariable( "MinimapState","mini", 1 );
		UpdateMinimapState();	
	elseif( event == "ACCELERATE_KEYSEND" ) then
		MiniMap_HandleAccKey(arg0);
	elseif( event =="UPDATE_NETSTATUS") then
	  local strNetState = ""
	  local strOnlineTime = ""
		if tonumber(arg0) < 250 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState1")
			strNetState = "点击可查看今日活动列表#r网络状况:空闲".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 500 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState2")
			--MiniMap_MiniMap_NetStatus : SetToolTip("网络状况:正常".."("..tostring(arg0).."ms)")
			strNetState = "点击可查看今日活动列表#r网络状况:正常".."("..tostring(arg0).."ms)"
		elseif tonumber(arg0) < 1000 then
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState3")
			--MiniMap_MiniMap_NetStatus : SetToolTip("网络状况:拥挤".."("..tostring(arg0).."ms)")
			strNetState = "点击可查看今日活动列表#r网络状况:拥挤".."("..tostring(arg0).."ms)"
		else
			MiniMap_MiniMap_NetStatus : SetProperty("SetCurrentImage","NetState4")
			--MiniMap_MiniMap_NetStatus : SetToolTip("网络状况：堵塞".."("..tostring(arg0).."ms)")
			strNetState = "点击可查看今日活动列表#r网络状况:堵塞".."("..tostring(arg0).."ms)"
		end
		
		local nFatigueState = tonumber( arg1 )
		local IsNeedFatigue = tonumber( arg2 );
		local OnlineTime = tonumber( arg3 ) 
		local strOnlineState = "(健康)"
		
		if( IsNeedFatigue == 1 ) then --如果需要计算防沉迷
			if( nFatigueState == 1 ) then
				strOnlineState = "(疲劳)"
			elseif( nFatigueState == 2 ) then
				strOnlineState = "(不健康)"
			end
			strOnlineTime = "#r累计在线时间:"..tostring( OnlineTime ).."小时"..strOnlineState
		else
			strOnlineState = "";
		end
		
		MiniMap_MiniMap_NetStatus : SetToolTip( strNetState..strOnlineTime )
	elseif( event =="SHOW_NEEDREPAIR") then
		if tonumber(arg0) == 1 then
			MiniMap_EquipEndurance:Show();
			MiniMap_EquipEndurance:SetToolTip("#{ZBXL_081009_01}");
		else
			MiniMap_EquipEndurance:Hide();
		end;
		
	elseif( event == "PKMODE_CHANGE" ) then
		Minimap_UpdatePKMode();
	elseif(event == "LEFTPROTECTTIME_CHANGE")then
		
		local DT = math.floor( tonumber(arg0)/1000);
		if(DT>0)then
			MiniMap_SafeTime_Frame:Show();
			MiniMap_SafeTimeAnimate:Show();
			MiniMap_SafeTime_StopWatch:SetProperty("Timer",tostring(DT));
		else
			MiniMap_SafeTime_Frame:Hide();
			MiniMap_SafeTimeAnimate:Hide();
			CloseFangDaohao();--关闭疑似被盗提示窗口
		end
	elseif( event == "OPEN_MINIMAPEXP" ) then
		MiniMap_UpdateLockFlag();
	elseif( event == "FLAH_MINIMAP" ) then
		MiniMap_FlashHuodong();
	elseif( event == "STOP_FLAH_MINIMAP" ) then
		MiniMap_StopFlashHuodong();	
	elseif( event == "SHOW_ACCOUNT_SAFE_ICON") then
		MiniMap_AccountSafeBack:Show();
		MiniMap_AccountSafe:SetProperty( "SetCurrentImage","red" );
		MiniMap_AccountSafeState:SetProperty( "SetCurrentImage","SafeIcon" );
		SetTimer("MiniMap","MiniMap_TimerProc()",60000);		--设置定时器一分钟后关闭窗口
		MiniMap_AccountSafeFlash : Show();		--确保会闪烁
		
	end

	if( event == "SHOW_SHIMINGRENZHENG_ANIMATA" ) then
		if((not this:IsVisible())) then
			return;
		end

		if(tonumber(arg0) == 1)then
		  if(Variable:GetVariable("System_Region") ~= "1258") then
				MiniMap_Fangchengmi_Flash : Show();
			end
			MiniMap_Fangchengmi_Flash1 : Hide()
			MiniMap_Fangchengmi_Flash1 :SetProperty( "AlwaysOnTop","False" );
			MiniMap_Fangchengmi_Flash : SetProperty( "AlwaysOnTop","True" );
		elseif(tonumber(arg0) == 2)then
		  if(Variable:GetVariable("System_Region") ~= "1258") then
				MiniMap_Fangchengmi_Flash1 : Show();
			end
			MiniMap_Fangchengmi_Flash : Hide();
			MiniMap_Fangchengmi_Flash :SetProperty( "AlwaysOnTop","False" );
			MiniMap_Fangchengmi_Flash1 : SetProperty( "AlwaysOnTop","True" );
		else
			MiniMap_Fangchengmi_Flash1 : Hide();
			MiniMap_Fangchengmi_Flash : Hide();	
		end
	end
	if( event == "MINIMAP_SHOW_SHIMINGRENZHENG_BTN" ) then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) == 1)then
		  if(Variable:GetVariable("System_Region") ~= "1258") then
				MiniMap_Fangchengmi_Btn : Show();
			end
		else
			MiniMap_Fangchengmi_Btn : Hide();
		end
	end

	if (event == "PLAYERASK_INGAME" )  then
		MiniMap_SuperHelp2:Hide();
		MiniMap_PlayerAsk_Bn:Show();
		MiniMap_PlayerAsk:Show();
	end

	if (event == "MINMAP_PLAYERLIST_SHOW") then
		MiniMap_LiebiaoFunc();
	end
	
end

function MiniMap_TimerProc()
	KillTimer("MiniMap_TimerProc()");		--关闭定时器
	--MiniMap_AccountSafeBack:Hide();
	MiniMap_AccountSafeFlash :Hide();

end

function MiniMap_FlashHuodong()
	--AxTrace( 8,3,"init minimap" );
	MiniMap_NetStatus_Flash:Play( true );
end

function MiniMap_StopFlashHuodong()
	MiniMap_NetStatus_Flash:Play( false );
end

function MiniMap_UpdateLockFlag()
	local level = Player:GetData( "LEVEL" );
	if( Player:IsHavePassword() == 0 ) then --如果有没有密码呢，就闪烁
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","red" );
		MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Unlock" );
		MiniMap_SafeLockFlash:Show();
	else
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","green" );
		MiniMap_SafeLockFlash:Hide();
	
		--没有锁定就显示开开的锁的图片
		if ( Player:IsLocked() == 0 ) then 
			MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Lock" );
		else 
			MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Unlock" );
		end
	end
	--蒙子控制
	if( tonumber( level ) <= 15 ) then
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","gray" );
		MiniMap_SafeLockState:SetProperty( "SetCurrentImage","Unlock" );
		MiniMap_SafeLockFlash:Hide();
	end
	
	if( tonumber( IsInStall() ) == 1 ) then
		MiniMap_SafeLock:SetProperty( "SetCurrentImage","gray" );
		MiniMap_SafeLockFlash:Hide();
	end
end


function Minimap_UpdatePKMode()
	local nPKMode = Player:GetPKMode();
	if( tonumber( nPKMode ) == 0 ) then
		MiniMap_PK_Mode:SetProperty( "SetCurrentImage", "Peace" );
	else
		MiniMap_PK_Mode:SetProperty( "SetCurrentImage", "War" );
	end
	
	local strPKMode = ""
	if( tonumber( nPKMode ) == 0 ) then
		--MiniMap_PK_Mode:SetToolTip( "和平" );
		strPKMode = "和平\n此模式下只能反击攻击自己的玩家，不能主动攻击其他玩家。"
	elseif( tonumber( nPKMode ) == 1 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_ALL" );
		strPKMode = "个人混战"
		
	elseif( tonumber( nPKMode ) == 2 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_MORAL" );
		strPKMode = "善恶模式\n此模式下可以攻击杀气大于0的玩家。"
		
	elseif( tonumber( nPKMode ) == 3 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_TEAM" );
		strPKMode = "组队混战"
		
	elseif( tonumber( nPKMode ) == 4 ) then
		--MiniMap_PK_Mode:SetToolTip( "PK_FREE_FOR_GUILD" );
		strPKMode = "帮派同盟混战"
	end
	
	local strTime = ""
	local iTime = Player:GetTimeToPeace()

	if( -1 ~= iTime ) then
	    iTime = math.floor( iTime / 1000 )
	    local iSec = math.mod( iTime, 60 )
	    local iMin = math.floor( iTime / 60 )
	    
	    --strTime = "#r("..( tonumber(iTime) ).."秒后切换到和平或善恶模式)"
	    if( iMin > 0 ) then
	        strTime = "#r"..(iMin).."分"..( tonumber(iSec) ).."秒后切换到和平或善恶模式"
	    else
	        strTime = "#r"..( tonumber(iSec) ).."秒后切换到和平或善恶模式"
	    end
	    
	end

	MiniMap_PK_Mode:SetToolTip( strPKMode..strTime )

	
end
			--IMAGE_TYPE_Animy	= 0, // 敌人
			--IMAGE_TYPE_ExpNpc	= 1, // 特殊npc
			--IMAGE_TYPE_Team		= 2, // 队友
			--IMAGE_TYPE_Player	= 3, // 别的玩家
			--IMAGE_TYPE_ExpObj	= 4, // 生长点
			--IMAGE_TYPE_Active	= 5, // 激活方向点
			--IMAGE_TYPE_ScenePos = 6, // 场景跳转点
			--IMAGE_TYPE_Flash	= 7, // 闪光点
			--IMAGE_TYPE_Pet		= 8, // 宠物
			--IMAGE_TYPE_Direction = 9,// 方向箭头	
function UpdateMinimapState()
		
		this:Show();
		MiniMap_PosModify();
		Minimap_CoordinateUpdate();
		Minimap_UpdatePKMode();	
end

function MiniMap_Update( filename )
	--AxTrace( 0,0,"init minimap" );
	local sceneX, sceneY;
	sceneX,sceneY = GetSceneSize();
	MiniMap_MapArea:SetSceneFileName( sceneX,sceneY,filename );
	MiniMap_Frame:SetForce();
end

function MiniMap_PosModify()
	if( this:IsVisible() ) then
		MiniMap_MapArea:UpdateFlag();
	end
end

function  MiniMap_OpenMinimapExp()
	
	OpenMinimap( "MinimapExp" );
	this:Hide();
	

end

function Minimap_Max()
	MiniMap_CloseButtons:Show()
	MiniMap_OpenButtons:Hide()
	MiniMap_Background_Frame:Show();
end

function Minimap_Min()
	MiniMap_CloseButtons:Hide()
	MiniMap_OpenButtons:Show()
	MiniMap_Background_Frame:Hide();
end

function Minimap_CoordinateUpdate()

	local coordinatex,coordinatey,direct;
	coordinatex, coordinatey = MiniMap_MapArea:GetMouseScenePos();
	MiniMap_Coordinate:SetText( "#cFDFF73"..tostring( coordinatex ).."  "..tostring( coordinatey ) );

	for i=1,12 do
		TimeDot[i]:Hide()
	end
	local hour = GetCurrentTime() + 1;
	MiniMap_ChineseTime:SetProperty("SetCurrentImage", "Time"..tostring( hour ) );
	--AxTrace( 8,0,"当前时间"..tostring( hour ) );
	TimeDot[ hour ]:Show();
	
end

function MiniMap_HandleAccKey( op )
	if(op == "acc_zoommap" and this:IsVisible()) then
		MiniMap_OpenMinimapExp();
	elseif(op == "acc_resetcamera") then
		ResetCamera();
	elseif(op == "acc_worldmap") then
		ToggleLargeMap();
	end
end

function Do_OpenAutoSearch()
	OpenAutoSearch();
end

function MiniMap_YuanBaoFunc()
	ToggleYuanbaoShop()
end

function MiniMap_OpenSafeTimeDlg()
	OpenDlg4ProtectTime();
end

function MiniMap_LockFunc()
	--AxTrace( 9,0,"IsIdleLogic = "..tostring( IsIdleLogic() ) );
	if( tonumber( IsInStall() ) == 0 ) then
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("OnDefaultEvent");
			Set_XSCRIPT_ScriptID(808007);
			Set_XSCRIPT_Parameter(0,808007);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
	end
end

function MiniMap_GotoDirectly()
	local coordinatex,coordinatey;
	coordinatex, coordinatey = MiniMap_MapArea:GetMouseScenePos();
	AutoRunToTarget(coordinatex, coordinatey);
end

function MiniMap_NetStatus_MouseEnter()
end

function MiniMap_NetStatus_MouseLeave()
	
end

function MiniMap_NetStatus_MouseLButtonDown()
	OpenTodayCampaignList();
	MiniMap_NetStatus_Flash:Play( false );
end

function MiniMap_AccountSafeFunc()
	--MiniMap_AccountSafeBack:Hide();
	MiniMap_AccountSafeFlash : Hide();
	OpenWordrefence("AccountSafe");
end

function MiniMap_Fangchengmi_Click()
	OpenShimingrenzhengDlg();
end

function MiniMap_PlayerAsk_Bn_Clicked()
	local menpai = Player:GetData("MEMPAI");
	local strName = "";
	
	-- 得到门派名称.
	if(0 == menpai) then
		strName = "少林";
		
	elseif(1 == menpai) then
		strName = "明教";
		
	elseif(2 == menpai) then
		strName = "丐帮";
		
	elseif(3 == menpai) then
		strName = "武当";
	
	elseif(4 == menpai) then
		strName = "峨嵋";
	
	elseif(5 == menpai) then
		strName = "星宿";
	
	elseif(6 == menpai) then
		strName = "天龙";
	
	elseif(7 == menpai) then
		strName = "天山";
	
	elseif(8 == menpai) then
		strName = "逍遥";
	
	elseif(9 == menpai) then
		strName = "无门派";
	end
	
	local urlStr = "cn="..Player:GetData("ACCOUNTNAME")
	urlStr = urlStr.."&v="..Player:GetAccMD5String()
	
	local idWorld = Variable:GetVariable("Login_World")
	if idWorld == nil then
		urlStr = urlStr.."&serverid="
	else
		urlStr = urlStr.."&serverid="..idWorld
	end

	urlStr = urlStr.."&level="..Player:GetData("LEVEL")
	urlStr = urlStr.."&roleName="..Player:GetName()
	urlStr = urlStr.."&clan="..strName
	urlStr = ConvertStringToURLCoding(urlStr)
	GameProduceLogin:OpenURL( "http://sde.game.sohu.com/survey/commGame.jsp?"..urlStr );
	MiniMap_PlayerAsk_Bn:Hide();
	MiniMap_PlayerAsk:Hide();
	MiniMap_SuperHelp2:Show();
end

function MiniMap_LiebiaoFunc()
	Guild:AskGuildNameList();
end