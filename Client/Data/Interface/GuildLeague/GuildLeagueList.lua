--与NPC的距离
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

--分页信息
local g_CurPage=0
local g_PageNum=0
local g_NumPerPage=13

--===============================================
-- OnLoad()
--===============================================
function GuildLeagueList_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_LEAGUE_LIST")
	this:RegisterEvent("UPDATE_GUILD_LEAGUE_LIST")
	this:RegisterEvent("OBJECT_CARED_EVENT");
end

function GuildLeagueList_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function GuildLeagueList_OnEvent( event )
	if event == "GUILD_LEAGUE_LIST" or 
		(event == "UI_COMMAND" and tonumber(arg0)==1206) then
		this:Show()
		GuildLeagueList_DoReset()
		GuildLeague:RequestList()
		g_clientNpcId = Get_XParam_INT(0)
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId)
		this:CareObject(g_clientNpcId, 1, "GuildLeagueList")
	elseif event == "UPDATE_GUILD_LEAGUE_LIST" then
		this:Show()
		GuildLeagueList_DoUpdatePageNum()
		GuildLeagueList_DoFirstPage()
	elseif ( event == "OBJECT_CARED_EVENT") then
		GuildLeagueList_CareEventHandle(arg0,arg1,arg2)
	end

end

function GuildLeagueList_DoUpdatePageNum()	
	local ct=GuildLeague:GetLeagueCount()
	local pageNum=math.floor(ct/g_NumPerPage)
	if math.mod(ct,g_NumPerPage) > 0 then
		pageNum=pageNum+1
	end
	g_PageNum=pageNum
end

function GuildLeagueList_DoUpdatePageButton()	
	if g_CurPage==0 then
		GuildLeagueList_PageUp:Disable()
	else
		GuildLeagueList_PageUp:Enable()
	end
	
	--PushDebugMessage("g_CurPage:"..tostring(g_CurPage)..",g_PageNum:"..tostring(g_PageNum))
	
	if g_CurPage<g_PageNum-1 then
		GuildLeagueList_PageDown:Enable()
	else
		GuildLeagueList_PageDown:Disable()
	end
end

function GuildLeagueList_DoFirstPage()	
	g_CurPage=0
	GuildLeagueList_DoUpdatePageButton()	
	GuildLeagueList_DoUpdate()
end

function GuildLeagueList_DoPageUp()	
	if g_CurPage>0 then
		g_CurPage=g_CurPage-1
		GuildLeagueList_DoUpdatePageButton()		
		GuildLeagueList_DoUpdate()	
	end
end

function GuildLeagueList_DoPageDown()
	if g_CurPage<g_PageNum-1 then
		g_CurPage=g_CurPage+1
		GuildLeagueList_DoUpdatePageButton()		
		GuildLeagueList_DoUpdate()	
	end
end

function GuildLeagueList_DoUpdate()
	GuildLeagueList_List:RemoveAllItem()
	
	local info=""
	local ct=GuildLeague:GetLeagueCount();	
	local startIndex=g_CurPage*g_NumPerPage
	local endIndex=startIndex+g_NumPerPage-1
	if endIndex>=ct then
	endIndex=ct-1
	end
	
	for i=startIndex,endIndex do
		GuildLeagueList_List:AddNewItem(tostring(GuildLeague:GetLeagueID(i)),0,i-startIndex)
		GuildLeagueList_List:AddNewItem(GuildLeague:GetLeagueName(i),1,i-startIndex)
	end
end

function GuildLeagueList_DoReset()
	g_CurPage=0
	GuildLeagueList_List:RemoveAllItem()

	GuildLeagueList_Name:SetText("#{TM_20080318_25}")
	GuildLeagueList_Time:SetText("#{TM_20080318_28}")
	GuildLeagueList_Chieftain:SetText("#{TM_20080318_27}")
	GuildLeagueList_Member:SetText("#{TM_20080318_26}")
	GuildLeagueList_Tenet:SetText("")
end

function GuildLeagueList_DoSelected()
	local index=GuildLeagueList_List:GetSelectItem()
	if index==-1 then
		return
	end
	
	index=index+g_CurPage*g_NumPerPage
	
	GuildLeagueList_Name:SetText("#{TM_20080318_25}"..GuildLeague:GetLeagueName(index))
	GuildLeagueList_Time:SetText("#{TM_20080318_28}"..GuildLeague:GetLeagueCreateTime(index))
	GuildLeagueList_Chieftain:SetText("#{TM_20080318_27}"..GuildLeague:GetLeagueChieftain(index))
	GuildLeagueList_Member:SetText("#{TM_20080318_26}"..tostring(GuildLeague:GetLeagueMemberCount(index)).."/3")
	GuildLeagueList_Tenet:SetText(GuildLeague:GetLeagueDescription(index))
end

function GuildLeagueList_DoApply()
	local index=GuildLeagueList_List:GetSelectItem()
	if index==-1 then
		PushDebugMessage("请先选择一个帮会同盟！")
		return
	end
	
	index=index+g_CurPage*g_NumPerPage
	
	GuildLeague:AskEnter(GuildLeague:GetLeagueID(index))
	this:Hide()
end

function GuildLeagueList_OnHidden()
	
end

function GuildLeagueList_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			this:Hide();
		end
end