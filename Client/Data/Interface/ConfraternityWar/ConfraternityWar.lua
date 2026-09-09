--帮派战争界面

function ConfraternityWar_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
end

function ConfraternityWar_OnLoad()

end

function ConfraternityWar_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 20081010 ) then
		this:Show()
	end
end

function ConfraternityWar_XuanZhan_Click()
	City:AskEnemyList(0);
	this:Hide();
	Guild:CloseKickGuildBox();
end

function ConfraternityWar_Zhnegtao_Click()
	City:AskBattleList(0);
	this:Hide();
	Guild:CloseKickGuildBox();
end