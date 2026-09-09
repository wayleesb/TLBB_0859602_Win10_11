

--===============================================
-- OnLoad()
--===============================================
function SystemNotice_PreLoad()
    this:RegisterEvent("SHOWWINDOW_SYSTEMNOTICE");
end

--===============================================
-- OnLoad()
--===============================================
function SystemNotice_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function SystemNotice_OnEvent(event)    
	
	if ( event == "SHOWWINDOW_SYSTEMNOTICE" ) then
	    local MsgText = tostring( arg0 )
	    SystemNotice_InputTenet:SetText( MsgText )
	    this:Show();
	end
	
end


--===============================================
-- UpdateFrame
--===============================================
function SystemNotice_UpdateFrame()
end


--===============================================
-- µã»÷È·¶¨£¨IDOK£©
--===============================================
function SystemNotice_OK_Clicked()
    this:Hide();
end


function SystemNotice_Cancel_Clicked(bClick)    
	this:Hide();
end

function SystemNotice_OnHide() 
end

function SystemNotice_Next()
    PopSystemNotice()
end