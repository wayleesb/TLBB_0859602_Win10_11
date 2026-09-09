function SafeTime_PreLoad()
	this:RegisterEvent("OPENDLG_FOR_SETPROTECTTIME");
	
	this:RegisterEvent("LEFTPROTECTTIME_CHANGE");

	this:RegisterEvent("DBLEFTPROTECTTIME_CHANGE");
end

function SafeTime_OnLoad()
end

function SafeTime_OnEvent( event )
	if ( event == "OPENDLG_FOR_SETPROTECTTIME" ) then
		if( this:IsVisible() ) then
			SafeTime_Close();
		else
			SafeTime_Open();
		end
	elseif(event == "LEFTPROTECTTIME_CHANGE")then
		if( this:IsVisible() ) then
			SafeTime_UpdateLeftSafeTime(tonumber(arg0));
		end
	elseif(event == "DBLEFTPROTECTTIME_CHANGE")then
		if( this:IsVisible() ) then
			SafeTime_DBUpdateLeftSafeTime(tonumber(arg0));
		end
	end
end

function SafeTime_DBUpdateLeftSafeTime(time)
	    if (tonumber(time) <= 0) then
		SafeTime_CurrentTime:SetText("#{FDH_090227_4}");
		return
	    end
	    local iTime = math.floor( time / 1000 )
	    local iHor = math.floor( iTime / 3600 )
	    iTime = math.mod( iTime ,3600 )
	    local iMin = math.floor( iTime / 60 )
	    local strTime="";
	    if(iHor>0)then
		strTime = strTime..iHor.."小时";
	    end
	    if(iMin>0)then
		strTime = strTime..iMin.."分钟";
	    end

	    SafeTime_CurrentTime:SetText("#{FDH_090112_06}#cFFFF00"..strTime);
end

function SafeTime_UpdateLeftSafeTime(time)
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
	    SafeTime_StopWatch_Text:SetText("#{FDH_090112_07}#c00FF00"..strHor..":"..strMin..":"..strSec);	   
end

function SafeTime_Close()
	Variable:SetVariable("SafeTimePos", SafeTime_Frame:GetProperty("UnifiedPosition"), 1);
	this:Hide();
end

function SafeTime_Open()
	CloseWindow("ErjimimaShezhi", true)
	CloseWindow("ErjimimaXiugai", true)
	CloseWindow("ErjimimaJiesuo", true)
	CloseWindow("Fangdao", true)
	SafeTime_InitDlg();
	this:Show();
end

function SafeTime_InitDlg()
	--SafeTime_SetHour:SetText(0);
	SafeTime_SetMin:SetText(10);
	SafeTime_SetMin:SetProperty("DefaultEditBox", "True");
	SafeTime_SetMin:SetSelected( 0, -1 );
	local dblefttime = DataPool:GetDBLeftProtectTime();
	if(tonumber(dblefttime) <= 0) then
		SafeTime_CurrentTime:SetText("#{FDH_090227_4}");
		SafeTime_StopWatch_Text:SetText("");
	else
		SafeTime_DBUpdateLeftSafeTime(tonumber(dblefttime));
		dblefttime =DataPool:GetLeftProtectTime();
		SafeTime_UpdateLeftSafeTime(tonumber(dblefttime));
	end

	local safeTimePos = Variable:GetVariable("SafeTimePos");
	if(safeTimePos ~= nil) then
		SafeTime_Frame:SetProperty("UnifiedPosition", safeTimePos);
	end

	SafeTime_AQtime:SetCheck(1)
	SafeTime_Erjimima:SetCheck(0)
end

function CheckIfOK()
	local Min = SafeTime_SetMin:GetText();
	if(Min~=nil and tonumber(Min)~=nil) then 
		if(tonumber(Min)>60) then
			PushDebugMessage("您输入的分钟数不能大于60分钟，请重新输入。")
			SafeTime_SetMin:SetText("3")
		elseif (tonumber(Min)<1) then
			PushDebugMessage("安全时间最少为1分钟，请重新输入。")
			SafeTime_SetMin:SetText("10")
		end
	end
end

function SafeTime_ResetSelect(idx)
	if(idx==0) then
		--SafeTime_SetHour:SetSelected( 0, -1 );
	else
		SafeTime_SetMin:SetSelected( 0, -1 );
	end
end

function SafeTime_OK_Click()
	local Min = SafeTime_SetMin:GetText();
	--local Hor = SafeTime_SetHour:GetText();
	local dblefttime =DataPool:GetLeftProtectTime();
	if(tonumber(dblefttime)>0)then
		PushDebugMessage("安全时间内不允许重设安全时间！")
		return
	end
	
	if( Min~=nil and tonumber(Min)~=nil)then
		Lua_SetProtectTime(0,tonumber(Min));
	else
		PushDebugMessage("设置不成功！安全时间不能为空！")
	end
        this:Hide();
end

function SafeTime_gotoWeb()
	GameProduceLogin:OpenURL( "http://sde.game.sohu.com/lndex.jsp" )
end

function SafeTime_Erjimima_Clicked()
	SafeTime_Close();
	OpenMinorPassword();
end

function SafeTime_OnHide()
	Variable:SetVariable("SafeTimePos", SafeTime_Frame:GetProperty("UnifiedPosition"), 1);
end