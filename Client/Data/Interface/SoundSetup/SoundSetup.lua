
--===============================================
-- OnLoad()
--===============================================
function SoundSetup_PreLoad()

	this:RegisterEvent("TOGLE_SOUNDSETUP");

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_GAMESETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");

end

function SoundSetup_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function SoundSetup_OnEvent(event)
	
	if ( event == "TOGLE_SOUNDSETUP" ) then
		this:Show();
		
		SoundSetup_UpdateFrame();
		
	elseif(event == "TOGLE_GAMESETUP" ) then
		this:Hide();
	elseif(event == "TOGLE_SYSTEMFRAME" ) then
		this:Hide();
	elseif(event == "TOGLE_VIEWSETUP" ) then
		this:Hide();

	end

end


--===============================================
-- UpdateFrame()
--===============================================
function SoundSetup_UpdateFrame()
	
	local bDisableAllSound = Variable:GetVariable("DisableAllSound") == "1";
	local bEnableBG = Variable:GetVariable("EnableBGSound") == "1";
	local bEnable3D = Variable:GetVariable("Enable3DSound") == "1";
	local bEnableSK = Variable:GetVariable("EnableSKSound") == "1";
	local bEnableUI = Variable:GetVariable("EnableUISound") == "1";
	
	local fVolumeBG = tonumber(Variable:GetVariable("VOLUME_BG"));
	local fVolume3D = tonumber(Variable:GetVariable("VOLUME_3D"));
	local fVolumeSK = tonumber(Variable:GetVariable("VOLUME_SK"));
	local fVolumeUI = tonumber(Variable:GetVariable("VOLUME_UI"));
	if( bDisableAllSound ) then
		SoundSetup_Item1:SetCheck( 1 );
	else
		SoundSetup_Item1:SetCheck( 0 );
	end
	if( bEnableBG ) then
		SoundSetup_Item2:SetCheck( 1 );
	else
		SoundSetup_Item2:SetCheck( 0 );
	end

	if( bEnable3D ) then
		SoundSetup_Item3:SetCheck( 1 );
	else
		SoundSetup_Item3:SetCheck( 0 );
	end

	if( bEnableSK ) then
		SoundSetup_Item4:SetCheck( 1 );
	else
		SoundSetup_Item4:SetCheck( 0 );
	end

	if( bEnableUI ) then
		SoundSetup_Item5:SetCheck( 1 );
	else
		SoundSetup_Item5:SetCheck( 0 );
	end

	SoundSetup_Item2_Control:SetPosition(fVolumeBG);	
	SoundSetup_Item3_Control:SetPosition(fVolume3D);	
	SoundSetup_Item4_Control:SetPosition(fVolumeSK);	
	SoundSetup_Item5_Control:SetPosition(fVolumeUI);	

end

function SoundSetup_UpdateToGame(theControl, varName)
	local bEnable = theControl:GetProperty("Selected")=="True";

	Variable:SetVariable(varName, (bEnable and "1") or "0", 0);
end


--===============================================
-- SoundSetup_Check_Clicked
--===============================================
function SoundSetup_Check_Clicked(nIndex)
	
	if(nIndex == 1)   then
		SoundSetup_Item1:SetCheck( 1 );
		local bEnable = SoundSetup_Item1:GetCheck();
		if(bEnable == 1 )  then
			SoundSetup_Item2:SetCheck( 0 );
			SoundSetup_Item3:SetCheck( 0 );
			SoundSetup_Item4:SetCheck( 0 );
			SoundSetup_Item5:SetCheck( 0 );
		end
		
	else
		SoundSetup_Item1:SetCheck( 0 );
	end
	
end

--===============================================
-- 背景
--===============================================
function SoundSetup_BackgroundMusic_Clicked()
end

--===============================================
-- 环境
--===============================================
function SoundSetup_EnvironmentalSound_Clicked()
end


--===============================================
-- 技能
--===============================================
function SoundSetup_SkillsSound_Clicked()
end


--===============================================
-- UI事件
--===============================================
function SoundSetup_ThingSound_Clicked()
end

--===============================================
-- 确定
--===============================================
function SoundSetup_IDOK_Clicked()

	-- 需要保存数据
	SoundSetup_UpdateToGame(SoundSetup_Item1, 	"DisableAllSound");
	SoundSetup_UpdateToGame(SoundSetup_Item2, 	"EnableBGSound");
	SoundSetup_UpdateToGame(SoundSetup_Item3, 	"Enable3DSound");
	SoundSetup_UpdateToGame(SoundSetup_Item4, 	"EnableSKSound");
	SoundSetup_UpdateToGame(SoundSetup_Item5, 	"EnableUISound");
			
	local fVolumeBG = SoundSetup_Item2_Control:GetPosition();
	local fVolume3D = SoundSetup_Item3_Control:GetPosition();
	local fVolumeSK = SoundSetup_Item4_Control:GetPosition();
	local fVolumeUI = SoundSetup_Item5_Control:GetPosition();

	Variable:SetVariable("VOLUME_BG", fVolumeBG, 0);
	Variable:SetVariable("VOLUME_3D", fVolume3D, 0);
	Variable:SetVariable("VOLUME_SK", fVolumeSK, 0);
	Variable:SetVariable("VOLUME_UI", fVolumeUI, 0);
	
	this:Hide();
end

--===============================================
-- 取消
--===============================================
function SoundSetup_IDCANCEL_Clicked()
	this:Hide();
end

--恢复默认选项
function SoundSetup_Default_Clicked()

	Variable:SetVariable("DisableAllSound", "0", 0);
	Variable:SetVariable("EnableBGSound", "1", 0);
	Variable:SetVariable("Enable3DSound", "1", 0);
	Variable:SetVariable("EnableSKSound", "1", 0);
	Variable:SetVariable("EnableUISound", "1", 0);
	
	
	Variable:SetVariable("VOLUME_BG", 1.0, 0);
	Variable:SetVariable("VOLUME_3D", 1.0, 0);
	Variable:SetVariable("VOLUME_SK", 1.0, 0);
	Variable:SetVariable("VOLUME_UI", 1.0, 0);
	
	SoundSetup_UpdateFrame()
	
end


