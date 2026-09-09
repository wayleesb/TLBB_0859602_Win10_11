--===============================================
-- OnLoad()
--===============================================
function Operation_PreLoad()

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_GAMESETUP");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");
	this:RegisterEvent("RELIVE_SHOW");
	this:RegisterEvent("RELIVE_HIDE");
	this:RegisterEvent("TOGLE_INPUTSETUP");

end
function Operation_Ret2SelServer_Clicked()
	EnterQuitWait(1);
	--AskRet2SelServer();
end;
function Operation_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function Operation_OnEvent(event)
	
	if ( event == "TOGLE_SYSTEMFRAME" ) then
		if( this:IsVisible()  ) then
			Operation_Close();
		else
			Operation_Open();
		end
	elseif(event == "TOGLE_GAMESETUP" ) then
		
		Operation_Close();
	elseif(event == "TOGLE_SOUNDSETUP" ) then
		
		Operation_Close();
	elseif(event == "TOGLE_VIEWSETUP" ) then
		
		Operation_Close();
	elseif(event == "TOGLE_INPUTSETUP" ) then
		
		Operation_Close();
	elseif(event == "RELIVE_SHOW") then
		Operation_Help:Disable();
		Operation_View:Disable();
		Operation_Sound:Disable();
		Operation_Geme:Disable();
		Operation_2Menu:Disable();
		Operation_Acce_Custom:Disable();
	elseif(event == "RELIVE_HIDE") then
		Operation_Help:Enable();
		Operation_View:Enable();
		Operation_Sound:Enable();
		Operation_Geme:Enable();
		Operation_2Menu:Enable();
		Operation_Acce_Custom:Enable();
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function Operation_UpdateFrame()

end



--===============================================
-- 视频设置
--===============================================
function Operation_View_Clicked()
	SystemSetup:ViewSetup();
end
--===============================================
-- 声音设置
--===============================================
function Operation_Sound_Clicked()
	SystemSetup:SoundSetup();
end
--===============================================
-- 界面设置
--===============================================
function Operation_UI_Clicked()
	SystemSetup:UISetup();
end
--===============================================
-- 按键设置
--===============================================
function Operation_Input_Clicked()
	SystemSetup:InputSetup();
end

--===============================================
-- 游戏性设置
--===============================================
function Operation_Game_Clicked()
	SystemSetup:GameSetup();
end

--===============================================
-- 按键设置
--===============================================
function Operation_Help_Clicked()
--	Helper:GotoHelper("");
end

--===============================================
-- 退出游戏
--===============================================
function Operation_QuitGame_Clicked()
	QuitApplication("quest");
end

--===============================================
-- 返回游戏
--===============================================
function Operation_BackGame_Clicked()
	SystemSetup:BackGame();
	
	Operation_Close();
end

function Operation_Close()
	this:Hide();
end

function Operation_Open()
	this:Show();
end

