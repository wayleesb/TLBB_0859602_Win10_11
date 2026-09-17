
--===============================================
-- OnLoad()
--===============================================
function FangChenMiRefuse_PreLoad()

	this:RegisterEvent("OPEN_NO_REALNAME_DLG");
end

function FangChenMiRefuse_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function FangChenMiRefuse_OnEvent( event )
	
	if ( event == "OPEN_NO_REALNAME_DLG" ) then	
		this:Show();
	end

end

--===============================================
-- OnHide()
--===============================================
function FangChenMiRefuse_Frame_OnHiden()
	this:Hide();
end

--===============================================
-- Bn2Click()
--===============================================
function FangChenMiRefuse_Bn2Click()
	
	if(Variable:GetVariable("System_Region") == "1258") then
		--do nothing
	else
		GameProduceLogin:OpenURL( "http://sde.game.sohu.com/fangchenmi/submitlogin.jsp" )
	end
	GameProduceLogin:ReturnToAccountDlg();
	this:Hide();		
end








