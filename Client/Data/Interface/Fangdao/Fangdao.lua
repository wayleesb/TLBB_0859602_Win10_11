function Fangdao_PreLoad()
	this:RegisterEvent("OPEN_FANGDAO");
	this:RegisterEvent("LEFTPROTECTTIME_CHANGE");
	this:RegisterEvent("DBLEFTPROTECTTIME_CHANGE");
end


function Fangdao_OnLoad()


end

function Fangdao_OnEvent( event )
	if ( event == "OPEN_FANGDAO" ) then
		if( this:IsVisible() ) then
			Fangdao_Close();
		else
			Fangdao_Open();
		end
	elseif(event == "LEFTPROTECTTIME_CHANGE")then
		if( this:IsVisible() ) then
			Fangdao_UpdateLeftSafeTime(tonumber(arg0));
		end
	elseif(event == "DBLEFTPROTECTTIME_CHANGE")then
		if( this:IsVisible() ) then
			Fangdao_DBUpdateLeftSafeTime(tonumber(arg0));
		end
	end
end

function Fangdao_DBUpdateLeftSafeTime(time)
	    if (tonumber(time) <= 0) then
		Fangdao_CurrentTime:SetText("#{FDH_090227_4}");
		return
	    end
	    local iTime = math.floor( time / 1000 )
	    local iHor = math.floor( iTime / 3600 )
	    iTime = math.mod( iTime, 3600 )
	    local iMin = math.floor( iTime / 60 )
	    local iSec = math.mod( iTime, 60 )
	    local strTime = "";
	    if(iHor > 0)then
		strTime = strTime..iHor.."小时";
	    end
	    if(iMin > 0)then
		strTime = strTime..iMin.."分钟";
	    end
	    if(iSec > 0)then
		strTime = strTime..iSec.."秒";
	    end
	    Fangdao_CurrentTime:SetText("#{FDH_090112_06}#cFFFF00"..strTime);
end

function Fangdao_UpdateLeftSafeTime(time)
	    local iTime = math.floor( time / 1000 )
	    local iHor = math.floor( iTime / 3600 )
	    iTime = math.mod( iTime, 3600 )
	    local iSec = math.mod( iTime, 60 )
	    local iMin = math.floor( iTime / 60 )
	    local strHor ,strMin,strSec;
	    if(iHor<10)then
		strHor="0"..iHor;
	    else
		strHor=""..iHor;
	    end
	    if(iMin<10)then
		strMin="0"..iMin;
	    else
		strMin=""..iMin;
	    end
	    if(iSec<10)then
		strSec ="0"..iSec;
	    else
		strSec = ""..iSec;
	    end
	    Fangdao_StopWatch_Text:SetText("#{FDH_090112_07}#c00FF00"..strHor..":"..strMin..":"..strSec);	   
end

function Fangdao_InitDlg()

	local dblefttime = DataPool:GetDBLeftProtectTime();
	if(tonumber(dblefttime) <= 0) then
		Fangdao_CurrentTime:SetText("#{FDH_090227_4}");
		Fangdao_StopWatch_Text:SetText("");
	else
		Fangdao_DBUpdateLeftSafeTime(tonumber(dblefttime));
		dblefttime =DataPool:GetLeftProtectTime();
		Fangdao_UpdateLeftSafeTime(tonumber(dblefttime));
	end
	
	local isSetMinorPwd = IsMinorPwdSetup();
	if(tonumber(isSetMinorPwd) == 1) then
		Fangdao_ErjimimaShezhi:SetText("已设置")
		Fangdao_ErjimimaShezhi:Disable()
	else
		Fangdao_ErjimimaShezhi:SetText("未设置")
		Fangdao_ErjimimaShezhi:Enable()
	end

	local safeTimePos = Variable:GetVariable("SafeTimePos");
	if(safeTimePos ~= nil) then
		Fangdao_Frame:SetProperty("UnifiedPosition", safeTimePos);
	end
end

function Fangdao_Open()
	CloseWindow("SafeTime" , true)
	CloseWindow("ErjimimaXiugai", true)
	CloseWindow("ErjimimaShezhi", true)
	CloseWindow("ErjimimaJiesuo", true)

	local safeTimePos = Variable:GetVariable("SafeTimePos");
	if(safeTimePos ~= nil) then
		Fangdao_Frame:SetProperty("UnifiedPosition", safeTimePos);
	end

	Fangdao_InitDlg();
	this:Show();

	Fangdao_AQtime:SetCheck(0);
	Fangdao_Erjimima:SetCheck(0);
end


function Fangdao_Close()
	Variable:SetVariable("SafeTimePos", Fangdao_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function Fangdao_OnHide()
	Variable:SetVariable("SafeTimePos", Fangdao_Frame:GetProperty("UnifiedPosition"), 1);
end

function Fangdao_OK_Click()
	Variable:SetVariable("SafeTimePos", Fangdao_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end


function Fangdao_AQtime_Clicked()
	Fangdao_Close();
	OpenDlg4ProtectTime();
end

function Fangdao_Erjimima_Clicked()
	Fangdao_Close();
	OpenMinorPassword();
end

function Fangdao_gotoWeb()
	GameProduceLogin:OpenURL( "http://sde.game.sohu.com/lndex.jsp" )
end

function Fangdao_ErjimimaShezhi_Clicked()
	Fangdao_Close();
	OpenMinorPassword();
end
