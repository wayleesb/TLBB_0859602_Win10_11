
--分页信息
local g_CurPage=0
local g_PageNum=0
local g_NumPerPage=13

--===============================================
-- OnLoad()
--===============================================
function GuildLeagueApply_PreLoad()
	this:RegisterEvent("GUILD_LEAGUE_APPLY_LIST")
	this:RegisterEvent("UPDATE_GUILD_LEAGUE_APPLY_LIST")
end

function GuildLeagueApply_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function GuildLeagueApply_OnEvent( event )
	if event == "GUILD_LEAGUE_APPLY_LIST"	then
		this:Show()
		GuildLeagueApply_DoReset()
		GuildLeague:RequestApplyList()
	elseif event == "UPDATE_GUILD_LEAGUE_APPLY_LIST" then
		this:Show()
		GuildLeagueApply_DoUpdatePageNum()
		GuildLeagueApply_DoFirstPage()
	end
end

function GuildLeagueApply_DoUpdatePageNum()	
	local ct=GuildLeague:GetApplyGuildCount()
	local pageNum=math.floor(ct/g_NumPerPage)
	if math.mod(ct,g_NumPerPage) > 0 then
		pageNum=pageNum+1
	end
	g_PageNum=pageNum
end

function GuildLeagueApply_DoUpdatePageButton()	
	if g_CurPage==0 then
		GuildLeagueApply_PageUp:Disable()
	else
		GuildLeagueApply_PageUp:Enable()
	end
	
	--PushDebugMessage("g_CurPage:"..tostring(g_CurPage)..",g_PageNum:"..tostring(g_PageNum))
	
	if g_CurPage<g_PageNum-1 then
		GuildLeagueApply_PageDown:Enable()
	else
		GuildLeagueApply_PageDown:Disable()
	end
end

function GuildLeagueApply_DoFirstPage()	
	g_CurPage=0
	GuildLeagueApply_DoUpdatePageButton()	
	GuildLeagueApply_DoUpdate()
end

function GuildLeagueApply_DoPageUp()	
	if g_CurPage>0 then
		g_CurPage=g_CurPage-1
		GuildLeagueApply_DoUpdatePageButton()		
		GuildLeagueApply_DoUpdate()	
	end
end

function GuildLeagueApply_DoPageDown()
	if g_CurPage<g_PageNum-1 then
		g_CurPage=g_CurPage+1
		GuildLeagueApply_DoUpdatePageButton()		
		GuildLeagueApply_DoUpdate()	
	end
end

function GuildLeagueApply_DoUpdate()	
	GuildLeagueApply_List:RemoveAllItem()
	
	local info=""
	local ct=GuildLeague:GetApplyGuildCount()
	
	local startIndex=g_CurPage*g_NumPerPage
	local endIndex=startIndex+g_NumPerPage-1
	if endIndex>=ct then
	endIndex=ct-1
	end
	
	for i=startIndex,endIndex do
		GuildLeagueApply_List:AddNewItem(tostring(GuildLeague:GetApplyGuildID(i)),0,i-startIndex)
		GuildLeagueApply_List:AddNewItem(GuildLeague:GetApplyGuildName(i),1,i-startIndex)
	end
end

function GuildLeagueApply_DoReset()
	g_CurPage=0
	GuildLeagueApply_List:RemoveAllItem()

	GuildLeagueApply_Name:SetText("#{TM_20080318_12}")
	GuildLeagueApply_ID:SetText("#{TM_20080318_13}")
	GuildLeagueApply_Chieftain:SetText("#{INTERFACE_XML_747}")
	GuildLeagueApply_Time:SetText("#{INTERFACE_XML_179}")
	GuildLeagueApply_City:SetText("#{TM_20080318_14}")
	GuildLeagueApply_Level:SetText("#{TM_20080318_15}")
	GuildLeagueApply_UserCount:SetText("#{TM_20080318_16}")
	GuildLeagueApply_Tenet:SetText("")	
end

function GuildLeagueApply_DoSelected()	
	local index=GuildLeagueApply_List:GetSelectItem()
	if index==-1 then
		return
	end
	
	index=index+g_CurPage*g_NumPerPage

	GuildLeagueApply_Name:SetText("#{TM_20080318_12}"..GuildLeague:GetApplyGuildName(index))
	GuildLeagueApply_ID:SetText("#{TM_20080318_13}"..tostring(GuildLeague:GetApplyGuildID(index)))
	GuildLeagueApply_Chieftain:SetText("#{INTERFACE_XML_747}"..GuildLeague:GetApplyGuildChieftain(index))
	GuildLeagueApply_Time:SetText("#{INTERFACE_XML_179}"..GuildLeague:GetApplyGuildCreateTime(index))
	GuildLeagueApply_City:SetText("#{TM_20080318_14}"..GuildLeague:GetApplyGuildCity(index))
	GuildLeagueApply_Level:SetText("#{TM_20080318_15}"..tostring(GuildLeague:GetApplyGuildLevel(index)))
	GuildLeagueApply_UserCount:SetText("#{TM_20080318_16}"..tostring(GuildLeague:GetApplyGuildUserCount(index)))
	GuildLeagueApply_Tenet:SetText(GuildLeague:GetApplyGuildDescription(index))
end

function GuildLeagueApply_DoAnswer(answer)
	local index=GuildLeagueApply_List:GetSelectItem()
	if index==-1 then
		PushDebugMessage("请先选择一个帮会同盟！")
		return
	end
	
	index=index+g_CurPage*g_NumPerPage
	
	GuildLeague:AnswerEnter(GuildLeague:GetApplyGuildID(index),answer)

	GuildLeagueApply_DoReset()
	GuildLeague:RequestApplyList()
end

function GuildLeagueApply_OnHidden()
	
end