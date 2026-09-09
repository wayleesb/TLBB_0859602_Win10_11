--===============================================
-- OnLoad()
--===============================================
function GuildLeagueInfo_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_LEAGUE_INFO")
	this:RegisterEvent("UPDATE_GUILD_LEAGUE_INFO")
end

function GuildLeagueInfo_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function GuildLeagueInfo_OnEvent( event )
	if event == "GUILD_LEAGUE_INFO" or 
		(event == "UI_COMMAND" and tonumber(arg0)==1208) then
		GuildLeagueInfo_Desc_Edit:Disable()
		GuildLeagueInfo_ApplyList:Disable()
		GuildLeagueInfo_Quit:Disable()
		GuildLeagueInfo_Change:Disable()
		GuildLeagueInfo_Out:Disable()
		GuildLeagueInfo_DoReset()
		this:Show()
		GuildLeague:RequestInfo()
	elseif event == "UPDATE_GUILD_LEAGUE_INFO" then 
		this:Show()
		GuildLeagueInfo_DoUpdate()
	end

end

function GuildLeagueInfo_DoUpdate()	
	GuildLeagueInfo_Name:SetText(GuildLeague:GetName())
	GuildLeagueInfo_Desc:SetText(GuildLeague:GetDescription())	
	GuildLeagueInfo_Desc_Edit:SetText(GuildLeague:GetDescription())
	GuildLeagueInfo_Desc_Edit:Enable()
	GuildLeagueInfo_Master:SetText(GuildLeague:GetChieftain())
	GuildLeagueInfo_Create:SetText(GuildLeague:GetCreator())
	GuildLeagueInfo_CreateTime:SetText(GuildLeague:GetCreateTime())
	GuildLeagueInfo_ID:SetText(tostring(GuildLeague:GetID()))
	local ct=GuildLeague:GetUserCount()
	GuildLeagueInfo_UserCount:SetText(tostring(ct))
	
	local isGuildChieftain=0
	
	GuildLeagueInfo_Member_List:RemoveAllItem()
	for i=0,GuildLeague:GetMemberCount()-1 do		
		GuildLeagueInfo_Member_List:AddNewItem( GuildLeague:GetMemberName(i), 0, i )
		GuildLeagueInfo_Member_List:AddNewItem( GuildLeague:GetMemberChieftain(i), 1, i )
		GuildLeagueInfo_Member_List:AddNewItem( tostring(GuildLeague:GetMemberUserCount(i)), 2, i )
		GuildLeagueInfo_Member_List:AddNewItem( GuildLeague:GetMemberEnterTime(i), 3, i )
		
		if GuildLeague:GetMemberChieftainGUID(i)==Player:GetGUID() then
			isGuildChieftain=1
		end
	end

	--PushDebugMessage(tostring(GuildLeague:GetChieftainGUID()).." --- "..tostring(Player:GetGUID()))
	
	if GuildLeague:GetChieftainGUID()==Player:GetGUID() then		
		GuildLeagueInfo_ApplyList:Enable()
		GuildLeagueInfo_Quit:Enable()
		GuildLeagueInfo_Change:Enable()
		GuildLeagueInfo_Out:Enable()
	end
	
	if isGuildChieftain>0 then
		GuildLeagueInfo_Quit:Enable()
	end	
end

function GuildLeagueInfo_DoReset()
	GuildLeagueInfo_Desc_Edit:Hide()
	GuildLeagueInfo_Desc:Show()

	GuildLeagueInfo_Name:SetText("")
	GuildLeagueInfo_Desc:SetText("")
	GuildLeagueInfo_Master:SetText("")
	GuildLeagueInfo_Create:SetText("")
	GuildLeagueInfo_CreateTime:SetText("")
	GuildLeagueInfo_ID:SetText("")
	GuildLeagueInfo_UserCount:SetText("")
	
	GuildLeagueInfo_Member_List:RemoveAllItem()
end

function GuildLeagueInfo_DoApplyList()
	GuildLeague:ShowApplyListWindow()
end

function GuildLeagueInfo_DoQuit()
	GuildLeague:ShowQuitConfirmWindow()
	this:Hide()
end

function GuildLeagueInfo_DoChange()
	if GuildLeagueInfo_Desc:IsVisible() then				
		--local txt=GuildLeagueInfo_Desc:GetText()
		--此处必须从程序存储的内容读取，这样才不会丢失字符转义
		local txt=GuildLeague:GetDescription()
		GuildLeagueInfo_Desc_Edit:SetText(txt)
		
		GuildLeagueInfo_Desc:Hide()
		GuildLeagueInfo_Desc_Edit:Show()
		
		GuildLeagueInfo_Change:SetText("#{TM_20080331_04}")
	else
		local txt=GuildLeagueInfo_Desc_Edit:GetText()
		GuildLeagueInfo_Desc:SetText(txt)
				
		if txt==nil or txt=="" then
			PushDebugMessage("您没有输入同盟宣言")
			return
		end
		
		local r=GuildLeague:ChangeDescription(txt)
		if r==-1 then			
			PushDebugMessage("#{TM_20080311_07}")	
			return
		end
		
		GuildLeagueInfo_Desc_Edit:Hide()
		GuildLeagueInfo_Desc:Show()
		
		GuildLeagueInfo_Desc_Edit:Disable()
		GuildLeagueInfo_Change:Disable()
		GuildLeague:RequestInfo()
		
		GuildLeagueInfo_Change:SetText("#{TM_20080318_10}")
	end
end

function GuildLeagueInfo_Member_List_OnMouseRClick()	
	local index=GuildLeagueInfo_Member_List:GetSelectItem()
	if index==-1 then
		PushDebugMessage("请先选择一个同盟成员！")
		return
	end
	
	GuildLeague:ShowMemberMenu(GuildLeague:GetMemberID(index))	
end

function GuildLeagueInfo_Fire()	
	local index=GuildLeagueInfo_Member_List:GetSelectItem()
	if index==-1 then
		PushDebugMessage("请先选择一个同盟成员！")
		return
	end
	
	GuildLeague:FireGuild( GuildLeague:GetID(), GuildLeague:GetMemberID(index) )	
end

function GuildLeagueInfo_OnHidden()
	
end