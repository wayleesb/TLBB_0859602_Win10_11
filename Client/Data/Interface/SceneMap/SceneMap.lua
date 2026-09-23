
function SceneMap_PreLoad()
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("TOGLE_SCENE_MAP");
	this:RegisterEvent("UPDATE_MAP");
	
end

function SceneMap_OnLoad()
end

function SceneMap_GM_GotoPos()
	local coordinatex,coordinatey;
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos();
	local str;
	str = "goto ="..tostring( coordinatex )..","..tostring( coordinatey );
	SendGMCommand( str );
end	

function SceneMap_GotoDirectly()
	local coordinatex,coordinatey;
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos();
	AutoRunToTarget(coordinatex, coordinatey);
end

function SceneMap_OnEvent(event)

	if ( event == "TOGLE_SCENE_MAP" ) then
		if( arg1 == "2" ) then
				if( this:IsVisible() ) then
					SceneMap_Close();
					ToggleAutoSearch(0) --likun
				else
					AxTrace( 0,0,"current scene file name = "..arg0 );
					SceneMap_Show( arg0 );
					ToggleAutoSearch(1) --likun
				end
		elseif ( arg1 == "1" ) then
			SceneMap_Show( arg0 );
			ToggleAutoSearch(1) --likun
		else
			SceneMap_Close();
			ToggleAutoSearch(0) --likun
		end
	elseif ( event == "UPDATE_MAP" ) then
		SceneMap_Update();
	elseif( event == "SCENE_TRANSED" ) then
		SceneMap_Close();
	end
end

function SceneMap_Close()
	SceneMap_Board:CloseSceneMap();
	this:Hide()
	ToggleAutoSearch(0) --likun
end

function SceneMap_Show( filename )
	local sceneX, sceneY;
	sceneX,sceneY = GetSceneSize();
	SceneMap_Board:SetSceneFileName( sceneX,sceneY,filename );
	
	local scenename;
	scenename = GetCurrentSceneName();
	SceneMap_SceneName:SetText("#gFF0FA0".. scenename );
	SceneMap_Board:UpdateViewRect();
	ToggleLargeMap(0);
	this:Show();
end

function SceneMap_Update()
	if( this:IsVisible() ) then
		SceneMap_Board:UpdateFlag();
	end
end
	
function SceneMap_UpdateInfo()
	local coordinatex,coordinatey;
	coordinatex, coordinatey = SceneMap_Board:GetMouseScenePos();
	SceneMap_Crood:SetText( tostring( coordinatex ).."    "..tostring( coordinatey ) );
end

function SceneMap_ZoomMode( zoom )
	SceneMap_Board:SetSceneZoomMode( zoom );
	SceneMap_Board:UpdateViewRect();
end

function ScemeMap_Qiehuan_Clicked()
	ToggleLargeMap( 1 )
end