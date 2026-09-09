--OnLoad

function PlayerZhengyou_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
end

function PlayerZhengyou_OnLoad()
    PlayerZhengyou_DragTitle:SetText("#{ZYPT_081103_099}");
end

function PlayerZhengyou_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "ZhengyouWindow") then
			--如果已经显示就应该关掉
			if ( this:IsVisible() ) then
			   this:Hide();
			   return;
			end
			this:Show();
		end
	
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouWindow") then
			this:Hide();
		end	
	end
end

function OnPlayerZhengyouClicked()
    CloseWindow("Show_Pet_Friends");
	OpenWindow("PlayerZhengyouPTWindow");
end

function OnPetZhengyouClicked()
    CloseWindow("PlayerZhengyouPTWindow");
	OpenWindow("Show_Pet_Friends");
end
