--===============================================
-- OnLoad()
--===============================================
function PKWarning_PreLoad()
    this:RegisterEvent("OPENWND_PKWARNING")
    this:RegisterEvent("CLOSEWND_PKWARNING")
end

--===============================================
-- OnLoad()
--===============================================
function PKWarning_OnLoad()    
end

--===============================================
-- OnEvent()
--===============================================
function PKWarning_OnEvent(event)

	AxTrace( 0, 0, event )

    if ( event == "OPENWND_PKWARNING" ) then
		this:Show()
	end
    
    if ( event == "CLOSEWND_PKWARNING" ) then
       this:Hide()
    end
         
end