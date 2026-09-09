--帮派征讨接受挑战界面

function ConfraternityTiaozhan_PreLoad()
	this:RegisterEvent("GUILD_SHOW_TIAOZHAN");	
end

function ConfraternityTiaozhan_OnLoad()
end

function ConfraternityTiaozhan_OnEvent(event)
	if ( event == "GUILD_SHOW_TIAOZHAN") then
		local guildName = City : GetAttackGuildName();
		if(guildName == nil) then
			return;
		end
		ConfraternityTiaozhan_Text : SetText(guildName.."#{BHXZ_081103_09}");
		this:Show()
	end
end

function ConfraternityTiaozhan_InitDlg()
	
end

function ConfraternityTiaozhan_Help()
	
end

function ConfraternityTiaozhan_Accept_Click()
	City:ReponseGuildBattle(1);	
	this:Hide();
end

function ConfraternityTiaozhan_Refuse_Click()
	City:ReponseGuildBattle(0);
	this:Hide();
end