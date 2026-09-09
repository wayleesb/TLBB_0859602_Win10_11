
-- 1-正在退出游戏...
-- 2-和服务器的连接被断开，是否尝试重新链接? 
-- 3-正在重新连接服务器...
-- 4-连接成功，正在重新进入场景...
-- 5-连接失败
local QuitRelative_Status = 0;


--===============================================
-- OnLoad()
--===============================================
function QuitRelative_PreLoad()
	this:RegisterEvent("QUIT_RELATIVE");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
end

function QuitRelative_OnLoad()

end


--===============================================
-- OnEvent()
--===============================================
function QuitRelative_OnEvent(event)
	if(event == "QUIT_RELATIVE") then
		if(arg0 == "QuitGaming...") then
			
			this:Show();
			QuitRelative_OK_Button:Hide();
			QuitRelative_Cancel_Button:Hide();
			QuitRelative_Text:SetText("正在退出游戏...");
			QuitRelativeSelectUpdateRect();
			QuitRelative_Status=1;
		elseif(arg0 == "AskReconnect") then
			this:Show();
			QuitRelative_OK_Button:Show();
			QuitRelative_OK_Button:Enable();
			QuitRelative_Cancel_Button:Enable();
			QuitRelative_Text:SetText("和服务器的连接被断开，是否尝试重新链接? ");
			QuitRelativeSelectUpdateRect();
			QuitRelative_Status=2;
		elseif(arg0 == "EnterScene") then
			if(this:IsVisible()) then
				QuitRelative_Text:SetText("连接成功，正在重新进入场景...");
				QuitRelative_Status=4;
			end
		elseif(arg0 == "ConnFailed") then
			this:Show();
			QuitRelative_OK_Button:Disable();
			QuitRelative_Cancel_Button:Enable();
			QuitRelative_Text:SetText("连接失败，错误原因:#r" .. arg1);
			QuitRelative_Status=5;
		end
		
	elseif(event == "PLAYER_ENTERING_WORLD") then
		this:Hide();
	end
end

function QuitRelative_OK_Clicked()
	if(QuitRelative_Status == 2) then
		--进入断线重连
		QuitRelative_OK_Button:Hide();
		QuitRelative_Cancel_Button:Enable();
		QuitRelative_Text:SetText("正在重新连接服务器...");
		QuitRelativeSelectUpdateRect();
		QuitRelative_Status=3;
		EnterReconnect(true);
	end
end

function QuitRelative_Cancel_Clicked()
	--正在询问是否重连或者正在重连
	if(QuitRelative_Status == 2 or QuitRelative_Status == 3) then
		--放弃重连，直接退出
		EnterReconnect(false);
	elseif(QuitRelative_Status == 5) then
		QuitApplication("quit");
	end
end


function QuitRelativeSelectUpdateRect()
	local nWidth, nHeight = QuitRelative_Text:GetWindowSize();
	local nTitleHeight = 0;
	local nBottomHeight = 25;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	QuitRelative_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end