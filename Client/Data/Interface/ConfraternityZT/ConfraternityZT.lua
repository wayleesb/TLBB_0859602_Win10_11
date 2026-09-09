local g_ZTListType = 0;

function ConfraternityZT_PreLoad()
	this:RegisterEvent("GUILD_SHOW_GUILDBATTLE");	
	--this:RegisterEvent("GUILD_UPDATE_ENEMYLIST");	
end

function ConfraternityZT_OnLoad()

end

function ConfraternityZT_OnEvent(event)
	if ( event == "GUILD_SHOW_GUILDBATTLE") then
		g_ZTListType = tonumber(arg0);
		ConfraternityZT_InitDlg();
		ConfraternityZT_UpdateDlg();
		this:Show()
	end
end

function ConfraternityZT_InitDlg()
	if(g_ZTListType == 0) then
		ConfraternityZT_DragTitle:SetText("#{BHXZ_081205_01}")
		ConfraternityZT_LookupButton:SetText("#{ConfraternityPK_XML_4}"); 
		ConfraternityZT_List_Text:SetText("#{ConfraternityPK_XML_2}");
		ConfraternityZT_StartBtn:Show();
		ConfraternityZT_JiezhanButton:Hide();
	else
		ConfraternityZT_DragTitle:SetText("#{BHXZ_081205_02}")
		ConfraternityZT_LookupButton:SetText("#{ConfraternityPK_XML_5}")
		ConfraternityZT_List_Text:SetText("#{ConfraternityPK_XML_11}");
		ConfraternityZT_StartBtn:Hide();
		ConfraternityZT_JiezhanButton:Show();
	end
end

function ConfraternityZT_UpdateDlg()
	ConfraternityZT_List:RemoveAllItem();
	local nNum = City:GetBattleNum(g_ZTListType);
	for i = 0 , nNum - 1 do
		local nGulidid 		= City:EnumBattleGuild(g_ZTListType,i,"guildid");
		local szGuildName = City:EnumBattleGuild(g_ZTListType,i,"name");
		local szLeftTime 	= City:EnumBattleGuild(g_ZTListType,i,"lefttime");
		ConfraternityZT_List:AddNewItem(nGulidid, 		0, i);
		ConfraternityZT_List:AddNewItem(szGuildName, 	1, i);
		ConfraternityZT_List:AddNewItem(szLeftTime, 	2, i);			
	end
end

function ConfraternityZT_StartBtn_Click()
	if(g_ZTListType == 0) then
		City:OpenAddBattleDlg();
	end
end

function ConfraternityZT_LookupButton_Click()
	if(g_ZTListType==nil)then
		return;
	end
	City:AskBattleList(1-g_ZTListType);
end

function ConfraternityZT_JiezhanButton_Click()
	local nSelected = ConfraternityZT_List:GetSelectItem();
	if(nSelected >= 0) then
		City:SelectGuildBattle(nSelected);
	end
end