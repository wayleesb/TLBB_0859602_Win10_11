

------------------------------------------------------------------------------------------------------
--
-- 全局变量区
--
--
local g_iYesNoType = -1;	-- yes-no 对话框类型
													-- -1 -- 普通信息提示
													-- 0 - 退出游戏
													-- 1 - 删除角色
													-- 2 - 更换帐号
													-- 3 - 断开网络
													-- 4 - 确认是否删除10级以上玩家
													-- 5 - 7天内提醒删除10级以上玩家
													-- 6 - 7天后，14天内提醒删除10级以上玩家
													-- 7 - 是否删除10级以下玩家
													-- 8 删除玩家
													-- 9 是否注册
local g_strMessageData;

local g_bagIndex = -1
-- 注册onLoad事件
function LoginSelectServerQuest_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO");
	
	-- 关闭界面
	this:RegisterEvent("GAMELOGIN_CLOSE_SYSTEM_INFO");
	
	
	-- 点击确定按钮关闭网络
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET");   

	-- 显示不带按钮的信息
	this:RegisterEvent("GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON");   
	-- 显示yes-no信息
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_YESNO");   
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_OK");   
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CANCEL"); 
	this:RegisterEvent("GAMELOGIN_SYSTEM_INFO_CLOSE"); 
	this:RegisterEvent("UI_COMMAND");

end

function LoginSelectServerQuest_OnLoad()
	
	-- 设置总是在最上层显示
	SelectServerQuest_Frame_sub:SetProperty("AlwaysOnTop", "True");
	
	-- 
	

end
function LoginSelectUpdateRect()
	local nWidth, nHeight = SelectServerQuest_InfoWindow:GetWindowSize();
	local nTitleHeight = 23;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	SelectServerQuest_Frame_sub:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
	AxTrace( 0,0, "LastWindowSize ="..tostring( nWindowWidth )..","..tostring(nWindowHeight) );
	--SelectServerQuest_Frame_sub:SetWindowSize( nWindowWidth, nWindowHeight );
end

local TimerArg = "";
local g_QuitType = 0;
local g_bIsQuitMsgBox = 0;
-- OnEvent
function LoginSelectServerQuest_OnEvent(event)
		g_bIsQuitMsgBox = 0;
    SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.500000,-118.000000}}" )

	--AxTrace( 0,0, "get event");
	SelectServerQuest_Button2:Hide();
	SelectServerQuest_Button1:Hide();
	SelectServerQuest_Time_Text : Hide();
	SelectServerQuest_InfoWindow:Show();
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO" ) then
	
		g_iYesNoType = -1;
		--AxTrace( 0,0, "显示系统信息");
		if( arg1 ~= "WAITFORQUIT" ) then
			SelectServerQuest_InfoWindow:SetText(arg0);
			LoginSelectUpdateRect();
		end
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		SelectServerQuest_Button1:Enable()
		
		if( arg1 == "USERONLINE" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif(arg1 == "USERFROMMAINPRO") then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(20));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Hide();
		    SelectServerQuest_Button2:Hide();
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "MIBAOERROR" ) then
		    SelectServerQuest_Time_Text : SetProperty("Timer",tostring(60));
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:Disable()
		    TimerArg = arg1;
		    arg1 = nil;
		elseif( arg1 == "WAITFORQUIT" ) then
		    if(arg3~=nil and tonumber(arg3)~=nil)then
			if(tonumber(arg3)>0)then
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(10));
				SelectServerQuest_InfoWindow:SetText("10秒后退出游戏！");
				LoginSelectUpdateRect();
				
			else
				SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
				SelectServerQuest_InfoWindow:SetText("3秒后退出游戏！");
				LoginSelectUpdateRect();
			end
		    else
			 SelectServerQuest_Time_Text : SetProperty("Timer",tostring(3));
			 SelectServerQuest_InfoWindow:SetText("3秒后退出游戏！");
			LoginSelectUpdateRect();
		    end
		    SelectServerQuest_Time_Text : Show()
		    SelectServerQuest_Button1:SetText("取消");
		    SelectServerQuest_Button1:Show();
		    SelectServerQuest_Button1:Enable()
		    TimerArg = arg1;
		    g_QuitType = tonumber(arg2);
		    g_bIsQuitMsgBox = 1;
		    arg1 = nil;
		else
		    TimerArg = nil;
		    arg1 = nil;
		    SelectServerQuest_Time_Text : Hide()    
		end
				
		this:Show();
		return;
	end
	
	
	
	
	if( event == "GAMELOGIN_CLOSE_SYSTEM_INFO") then
		
		g_iYesNoType = -1;
		this:Hide();
		return;
	end
	
	--AxTrace( 0,0, "event yes no");
	if( event == "GAMELOGIN_SYSTEM_INFO_YESNO") then
		
		--AxTrace( 0,0, "显示yes no");
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		g_iYesNoType = tonumber(arg1);
		
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		return;
	end
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_NO_BUTTON" ) then
	
	    if( nil ~= arg1 ) then
	        local strArg = tostring( arg1 )
			if( strArg == "CharSel_EnterGame" ) then
			--if( strArg == "CharSel_EnterGam" ) then
				SelectServerQuest_Frame_sub:SetProperty( "UnifiedPosition", "{{0.500000,-173.000000},{0.900000,-118.000000}}" )
			end
		arg1 = nil;
	    end
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		this:Show();
		SelectServerQuest_Button1:Hide();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_OK" ) then
		AxTrace( 0,0,"GAMELOGIN_SYSTEM_INFO_OK" );
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		if g_iYesNoType == 0 then
			SelectServerQuest_Button1:SetText("关闭");
		else
			SelectServerQuest_Button1:SetText("确定");
		end
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CANCEL" ) then
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("取消");
		this:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	if( event == "GAMELOGIN_SYSTEM_INFO_CLOSE" ) then
	
		g_iYesNoType = tonumber(arg1);
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("关闭");
		this:Show();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button2:Hide();
		return;
	end
	
	
	
	if( event == "GAMELOGIN_SHOW_SYSTEM_INFO_CLOSE_NET") then
		
		--AxTrace( 0,0, "需要关闭网络.");
		g_iYesNoType = 3;
		SelectServerQuest_InfoWindow:SetText(arg0);
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		this:Show();
		return;
	end
	
	-- 血浴神兵——神器铸造
	if ( event == "UI_COMMAND" and tonumber(arg0) == 13906) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263#{XYSB_080925_001}");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		SelectServerQuest_Button1:Enable()
		
		this:Show();
	end
	
	-- 血浴神兵——神器重铸
	if ( event == "UI_COMMAND" and tonumber(arg0) == 12032203) then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#cFFF263重新冶炼后神器将被销毁，附于神器的强化与宝石也会随之消失。");
		LoginSelectUpdateRect();

		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:SetText("关闭");
		SelectServerQuest_Button1:Enable()
		
		this:Show();
	end

	if( event == "UI_COMMAND" and tonumber(arg0) == 300077) then
		g_iYesNoType = 12;
		local slzExp = Get_XParam_INT( 0 )
		local levelCanUp = Get_XParam_INT( 1 )
		local petLevel = Get_XParam_INT( 2 )
		local toMaxLevel = Get_XParam_INT( 3 )
		local PetGuidH = Get_XParam_INT( 4 )
		local PetGuidL = Get_XParam_INT( 5 )
		g_bagIndex = Get_XParam_INT( 6 )
		local petClass = Pet:GetPetDBCName(PetGuidH,PetGuidL)

		if levelCanUp == 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_21}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,toMaxLevel)	
			SelectServerQuest_InfoWindow:SetText( strText );
		elseif levelCanUp > 0 then
			local strText = string.format("#{ZSKSSJ_081113_19}%s#{ZSKSSJ_081113_20}%d#{ZSKSSJ_081113_28}%d#{ZSKSSJ_081113_29}%d#{ZSKSSJ_081113_30}%d#{ZSKSSJ_081113_22}",petClass,slzExp ,petLevel ,petLevel + levelCanUp ,toMaxLevel)
			SelectServerQuest_InfoWindow:SetText( strText );
		end
		
		LoginSelectUpdateRect();
		
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		
	end
	
	--天元金丹 hzp
	if( event == "UI_COMMAND" and tonumber(arg0) == 332004) then
		g_iYesNoType = 13;
		g_bagIndex = Get_XParam_INT( 0 )
		SelectServerQuest_InfoWindow:SetText("#{TSXF_090408_03}");
		
		LoginSelectUpdateRect();
		
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button2:SetText("取消");
		SelectServerQuest_Button2:Show();
		SelectServerQuest_Button1:Show();
		this:Show();
		
	end
	
	
	-- 暗器锻造说明沿用源端 260001 指令，不在说明框按钮中重复发送锻造请求。
	if event == "UI_COMMAND" and tonumber(arg0) == 260001 then
		g_iYesNoType = -1;
		SelectServerQuest_InfoWindow:SetText("#{AQSJ_090709_10}");
		LoginSelectUpdateRect();
		SelectServerQuest_Button1:SetText("确定");
		SelectServerQuest_Button1:Show();
		SelectServerQuest_Button1:Enable();
		SelectServerQuest_Button2:Hide();
		this:Show();
	end

end


-------------------------------------------------------------
--
-- 按钮1 点击事件
--
function SelectServerQuest_Bn1Click()
-- 0 - 退出游戏
-- 4 - 确认是否删除10级以上玩家
-- 5 - 7天内提醒删除10级以上玩家
-- 6 - 7天后，14天内提醒删除10级以上玩家
-- 7 - 是否删除10级以下玩家
-- 8 - 大于10级得提示
	if( -1 == g_iYesNoType and 1 == g_bIsQuitMsgBox) then
		CancelQuitWait(); --取消退出
	end
	if(0 == g_iYesNoType) then		
		QuitApplication("quit");
	elseif(1 == g_iYesNoType) then		
	elseif(2==g_iYesNoType) then
		GameProduceLogin:ChangeToAccountInputDlgFromSelectRole();
	elseif( 3 == g_iYesNoType ) then
		GameProduceLogin:CloseNetConnect();
	elseif( 4 == g_iYesNoType ) then
			local strInfo;
		  strInfo ="您的角色不能马上删除，请在3天以后14天以内登录游戏，到洛阳（268，46）找到关汉寿或者到大理（80，136）找到周仓确认，即可永久删除。确认删除时角色不能处于有帮会、结婚、结拜、师徒、开店状态，否则删除将被取消。超过14天没有再次删除则删除操作无效。"
			GameProduceLogin:ShowMessageBox( strInfo, "OK", "8" );
	elseif( 5 == g_iYesNoType ) then
	elseif( 6 == g_iYesNoType ) then
	elseif( 7 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 8 == g_iYesNoType ) then
		GameProduceLogin:DelSelRole();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:LoginPlayer( 1 );
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "是否激活_点击了OK");
	elseif(11 == g_iYesNoType) then
		GameProduceLogin:CheckAccountNoMibao();
	elseif(12 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseShelizi" )
			Set_XSCRIPT_ScriptID( 300077 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	elseif(13 == g_iYesNoType) then
		Clear_XSCRIPT()
			Set_XSCRIPT_Function_Name( "UseTianYuanJinDan" )
			Set_XSCRIPT_ScriptID( 332004 )
			Set_XSCRIPT_Parameter( 0, g_bagIndex )
			Set_XSCRIPT_ParamCount(1)
		Send_XSCRIPT()
	end;
	
	this:Hide();
end


-------------------------------------------------------------
--
-- 按钮2 点击事件
--
function SelectServerQuest_Bn2Click()

	if(3 == g_iYesNoType) then
		GameProduceLogin:CloseNetConnect();
	elseif( 9 == g_iYesNoType ) then
		GameProduceLogin:PassportButNotReg();
	elseif( 10 == g_iYesNoType ) then
		AxTrace( 0,0, "是否激活_点击了NO");	
	end
	
	this:Hide();
end

function SelectServerQuest_TimeOut()
  if( TimerArg == "USERONLINE" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "MIBAOERROR" ) then
    SelectServerQuest_Button1:Enable()
    TimerArg = nil
  elseif(TimerArg == "USERFROMMAINPRO") then
	this:Hide();
	TimerArg = nil
  elseif(TimerArg == "WAITFORQUIT") then
	if(tonumber(g_QuitType)==0)then
		QuitApplication("quit");
	else
		AskRet2SelServer();
	end
	this:Hide();
	TimerArg = nil
	g_QuitType = nil
   end
end

function SelectServerQuest_Frame_OnHiden()
	DataPool:SetCanUseHotKey(1);
end