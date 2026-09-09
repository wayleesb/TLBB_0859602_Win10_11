
local g_strTargetSceneName;

function SceneTrans_PreLoad()
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
end

function SceneTrans_OnLoad()
end
	
function SceneTrans_OnEvent(event)
	if ( event == "PLAYER_LEAVE_WORLD" ) then
		g_strTargetSceneName = arg0;
		SceneTrans_TargetScene:SetText("Ç°Íù" .. g_strTargetSceneName);
		this:Show();
	elseif( event == "ON_SCENE_TRANSING") then
		if(this:IsVisible()) then
			SceneTrans_TargetScene:SetText("Ç°Íù" .. g_strTargetSceneName .. "[" .. tostring(arg0) .. "]");
		end
	elseif ( event == "SCENE_TRANSED" ) then
		this:Hide();
	end
end
