--有多少个场景
function LargeMap_PreLoad()
	this:RegisterEvent("TOGLE_LARGEMAP");
	this:RegisterEvent("TEAM_CHANGE_WORLD");
	--每一个场景得数据
end

function LargeMap_OnLoad()
end
	
function LargeMap_OnEvent(event)
	if ( event == "TOGLE_LARGEMAP" ) then
		if( arg0 == "2" ) then
			if( this:IsVisible() ) then
				LargeMap_Close();
			else
				LargeMap_Show();
			end
		elseif ( arg0 == "1" ) then
			LargeMap_Show()
		else
			LargeMap_Close();
		end
	elseif ( event == "TEAM_CHANGE_WORLD" ) then
			if( LargeMap_Frondground:IsVisible() ) then
				LargeMap_Frondground:UpdateWorldMap();
			end
	end
end

function LargeMap_Close()
	this:Hide()
	local nCurrentSelectScene = LargeMap_Frondground:GetCurrentSelectScene(); --得到当前选中的场景
	AxTrace( 0, 0, "current select ="..tostring(nCurrentSelectScene ).." current scene = "..tostring( GetSceneID()) );
	if( nCurrentSelectScene == GetSceneID() ) then
		ToggleSceneMap( 1 );
	end
end

function LargeMap_Show()
	ToggleSceneMap( 0 );--关闭场景地图
	
	LargeMap_Frondground:InitWorldMap();
	this:Show();
end

function LargeMap_Qiehuan_Clicked()
	ToggleSceneMap( 1 )
end