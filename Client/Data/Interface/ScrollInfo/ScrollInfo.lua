
--===============================================
-- OnLoad()
--===============================================
function ScrollInfo_PreLoad()

	--this:RegisterEvent("GAMELOGIN_OPEN_COUNT_INPUT");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("SET_SCROLLINFO");

end

function ScrollInfo_OnLoad()
	ScrollInfo_FrameBak1:Show();
	ScrollInfo_Background_RedLine1:Show();
	ScrollInfo_Background_RedLine2:Show();
end

--===============================================
-- OnEvent()
--===============================================
function ScrollInfo_OnEvent(event)
	
	if ( event == "SET_SCROLLINFO" ) then
		--AxTrace( 0,0,"SetScrollInfo = "..arg0 );
		ScrollInfo_Frame:SetScrollInfo( arg0,arg1 );
	elseif( event == "PLAYER_ENTERING_WORLD" ) then
		--AxTrace( 0,0,"Show ScrollInfo" );
		--this:Show();
	elseif( event =="GAMELOGIN_OPEN_COUNT_INPUT" ) then
		--AxTrace( 0,0,"Show ScrollInfo" );
		--this:Show();
	end

end
