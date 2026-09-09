
--===============================================
-- OnLoad
--===============================================
function Revenge_PreLoad()
	
	this:RegisterEvent("UI_COMMAND");				
	
end

function Revenge_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function Revenge_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 29) then
			this:Show();
	end
end

function Revenge_OnAcceptByID()
	RevengeAccept( tostring( Revenge_ID:GetText() ), 1 );
	this:Hide();
end

function Revenge_OnAcceptByName()
	RevengeAccept( tostring( Revenge_Name:GetText() ), 0 );
	this:Hide();
end

function Revenge_OnClose()
	this:Hide();
end
