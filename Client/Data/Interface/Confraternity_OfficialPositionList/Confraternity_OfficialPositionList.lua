-------------------------------------------------------
--"官员列表"界面脚本
--create by xindefeng
-------------------------------------------------------

local g_OfficialCtls = nil		--官员列表界面控件结构
local g_ListIdx2IDTbl = nil		--List控件上序列号与成员ID号对应表

local g_positionInfo = {
	"待批准　",
	"帮众　　",
	"精英　　",
	"商人　　",
	"弘化使　",
	"工务使　",
	"内务使　",
	"副帮主　",
	"帮主　　",
};

local g_menpaiInfo = {
	"少林",
	"明教",
	"丐帮",
	"武当",
	"峨嵋",
	"星宿",
	"天龙",
	"天山",
	"逍遥",
	"无门派",
}


--事件注册
function Confraternity_OfficialPositionList_PreLoad()
	this:RegisterEvent("GUILD_SHOW_OFFICIALLIST")
	this:RegisterEvent("GUILD_ANY_SORTDATE")
	this:RegisterEvent("GUILD_FORCE_CLOSE")	
end

function Confraternity_OfficialPositionList_OnLoad()
end

--事件响应
function Confraternity_OfficialPositionList_OnEvent(event)
	Confraternity_OfficialPositionList_SetCtl()--先设置一下控件
	
	if(event == "GUILD_SHOW_OFFICIALLIST") then
		Confraternity_OfficialPositionList_Close()
		Confraternity_OfficialPositionList_Clear()
		Confraternity_OfficialPositionList_Update()
		Confraternity_OfficialPositionList_Show()
	elseif(event == "GUILD_ANY_SORTDATE") then	--来新数据之前转发通知C代码排一下序
		Guild:SortAnyGuildMembersByPosition()
	elseif(event == "GUILD_FORCE_CLOSE") then
		Confraternity_OfficialPositionList_Close()	
	end	
end

--将所有的显示信息的控件放入结构中,便于操纵
function Confraternity_OfficialPositionList_SetCtl()
	g_OfficialCtls = {
										list = Confraternity_OfficialPositionList_MemberList,	--官员列表
										officalname = Confraternity_OfficialPositionList_Info1_Text,--官员名字
										info_menpai = {txt = Confraternity_OfficialPositionList_Info2_Text, msg = Confraternity_OfficialPositionList_Info2},--门派
										info_level = {txt = Confraternity_OfficialPositionList_Info3_Text, msg = Confraternity_OfficialPositionList_Info3},	--等级
										info_gongxiandu = {txt = Confraternity_OfficialPositionList_Info4_Text, msg = Confraternity_OfficialPositionList_Info4},--贡献度
										info_benzhougongxiandu = {txt = Confraternity_OfficialPositionList_Info7_Text, msg = Confraternity_OfficialPositionList_Info7},--本周贡献度
										info_rubangdate =	{txt = Confraternity_OfficialPositionList_Info5_Text, msg = Confraternity_OfficialPositionList_Info5},--入帮时间
										info_lixiandate =	{txt = Confraternity_OfficialPositionList_Info6_Text, msg = Confraternity_OfficialPositionList_Info6},--离线时间
										desc = Confraternity_OfficialPositionList_Tenet,			--帮会宗旨
										edit = Confraternity_OfficialPositionList_EditTenet		--帮会宗旨的内容
								 	 }	
end

--清空界面
function Confraternity_OfficialPositionList_Clear()
	--清空官员列表
	g_OfficialCtls.list:ClearListBox()
	
	--清空官员名字
	g_OfficialCtls.officalname:SetText("")
		
	--清空所有info控件
	g_OfficialCtls.info_menpai.txt:SetText("")
	g_OfficialCtls.info_level.txt:SetText("")
	g_OfficialCtls.info_gongxiandu.txt:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("")
	g_OfficialCtls.info_rubangdate.txt:SetText("")
	g_OfficialCtls.info_lixiandate.txt:SetText("")
		
	g_OfficialCtls.info_menpai.msg:SetText("")
	g_OfficialCtls.info_level.msg:SetText("")
	g_OfficialCtls.info_gongxiandu.msg:SetText("")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText("")
	g_OfficialCtls.info_rubangdate.msg:SetText("")
	g_OfficialCtls.info_lixiandate.msg:SetText("")		
	
	--清空帮会宗旨	
	g_OfficialCtls.desc:SetText("")
	g_OfficialCtls.desc:Show()
		
	g_OfficialCtls.edit:SetText("")
	g_OfficialCtls.edit:SetProperty("CaratIndex", 1024)
	g_OfficialCtls.edit:Hide()
	
	--清空索引ID对应表
	g_ListIdx2IDTbl = nil
end

--刷新显示其他数据
function Confraternity_OfficialPositionList_Flush(selected)
	local str = nil
	local selectedID = g_ListIdx2IDTbl[selected]
	
	if  selectedID == nil then		
		return
	end
	
	--官员名称
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Name")--默认选中列表里的第一个人
	local guid = ""
	_, guid = Guild:GetAnyGuildMembersInfo(selectedID, "GUID")--获取guid十六进制字符串	
	g_OfficialCtls.officalname:SetText(str.."("..guid..")")
		
	--门派
	str = Guild:GetAnyGuildMembersInfo(selectedID, "MenPai")
	g_OfficialCtls.info_menpai.txt:SetText("门派:")
	g_OfficialCtls.info_menpai.msg:SetText(g_menpaiInfo[str+1])
		
	--等级
	str = Guild:GetAnyGuildMembersInfo(selectedID, "Level")
	g_OfficialCtls.info_level.txt:SetText("等级:")
	g_OfficialCtls.info_level.msg:SetText(str)
		
	--贡献度
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "CurCon").."/"..Guild:GetAnyGuildMembersInfo(selectedID, "MaxCon")
	g_OfficialCtls.info_gongxiandu.txt:SetText("贡献度:")
	g_OfficialCtls.info_gongxiandu.msg:SetText(szMsg)
		
	--本周贡献度
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "ContriPerWeek")
	g_OfficialCtls.info_benzhougongxiandu.txt:SetText("本周贡献度:")
	g_OfficialCtls.info_benzhougongxiandu.msg:SetText(szMsg)
	
	--入帮时间
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "JoinTime");
	g_OfficialCtls.info_rubangdate.txt:SetText("入帮时间:")
	g_OfficialCtls.info_rubangdate.msg:SetText(szMsg)
		
	--离线时间
	szMsg = Guild:GetAnyGuildMembersInfo(selectedID, "LogOutTime")
	g_OfficialCtls.info_lixiandate.txt:SetText("离线时间:")
	g_OfficialCtls.info_lixiandate.msg:SetText(szMsg)	
end

--刷新显示"官员列表"List
function Confraternity_OfficialPositionList_ShowList()
	--List Ctl
	local OfficialsCount = 0			--官员数量
	local UnSortIdx = 0						--未排序前索引号
	local Color = nil							--显示颜色
	local Position = nil					--职位(号)
	local Name = nil							--名字
		
	local listidx = 0	--list中显示索引号
	local i = 0
	
	g_ListIdx2IDTbl = nil	--先清空
	
	OfficialsCount = Guild:GetAnyGuildMembersInfo(0, "OfficialsNum")	--获取官员数量(首参无效)
	while i < OfficialsCount do
		--获取未排序前索引号
		UnSortIdx = Guild:Sort2UnSortIndex(i)
		
		--获取数据
		Color = Guild:GetAnyGuildMembersInfo(UnSortIdx, "ShowColor") 	--获取显示颜色
		Position = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Position")--职位
		Name = Guild:GetAnyGuildMembersInfo(UnSortIdx, "Name")				--获取成员名字	
				
		--给控件加一项
		g_OfficialCtls.list:AddItem(Color..g_positionInfo[Position]..Name, listidx);
			
		--维护表
		g_ListIdx2IDTbl[listidx] = UnSortIdx
			
		listidx = listidx + 1
		
		i = i + 1
	end
	
	g_OfficialCtls.list:SetItemSelectByItemID(0)	--默认选中列表里的第一个人
	
	
end

--显示数据
function Confraternity_OfficialPositionList_Update()
	--title
	Confraternity_OfficialPositionList_DragTitle:SetText("#gFF0FA0官员列表")
		
	--刷新显示"官员列表"List
	Confraternity_OfficialPositionList_ShowList()
	
	--刷新显示其他数据
	Confraternity_OfficialPositionList_Selected()
		
	--帮会宗旨
	local str = Guild:GetAnyGuildMembersInfo(0, "Desc")--首参无效
	g_OfficialCtls.desc:SetText(str)
end

--用户选择发生改变,刷新一下
function Confraternity_OfficialPositionList_Selected()	
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--得到选中项索引号
	if (idx == -1) then
		return
	end	
	
	Confraternity_OfficialPositionList_Flush(idx)--刷新
end

--显示右键菜单
function Confraternity_OfficialPositionList_PopMenu()
	local idx = g_OfficialCtls.list:GetFirstSelectItem()	--得到选中项索引号
	if( idx == -1 ) then
		return
	end
	
	Guild:Show_OfficialPopMenu(tonumber(g_ListIdx2IDTbl[idx])) --通知C代码要显示右键菜单
end

--显示界面
function Confraternity_OfficialPositionList_Show()
	this:Show()
end

--关闭界面
function Confraternity_OfficialPositionList_Close()
	this:Hide()
end