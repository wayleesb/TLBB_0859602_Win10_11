
--当前场景类型....不用的场景类型所需显示的Tab页不同....
-- -1 无效
--  0 城市   --全部，功能，商店，任务
--  1 门派   --全部，功能
--  2 玄武岛 --全部，人物，家兽，猛兽
--  3 其它   --全部，怪物，人物
g_CurSceneType = -1

--城市场景的ID列表....
g_CitySceneIDList = { 0, 1, 2, 242, 246, 260 }
--门派场景的ID列表....
g_MenpaiSceneIDList = { 9, 10, 11, 12, 13, 14, 15, 16, 17 }
--宠物场景的ID列表....
g_PetSceneIDList = { 112, 201 }

--当前选择的Tab页....
g_CurSelectTabIndex = 1;

--不同场景类型下各个Tab按钮所对应的分类类型....
--界面上一共有5个Tab....
--分类类型 无效=-1，全=0，怪=1，人=2，兽=3，猛=4，功=5，店=6，任=7，无分类标签=99
g_TableTabIndex2TabType = {
	{	0,	5,	6,	7,	-1,	},
	{	0,	5,	-1,	-1,	-1,	},
	{	0,	2,	3,	4,	-1,	},
	{	0,	1,	2,	-1,	-1,	},
}

--上次更新本窗口时玩家所在场景ID....
g_LastUpdateSceneID = -1;

--各个Tab页的自动寻路数据....换场景的时候才重新计算....
g_TabListData = {};
g_TabListData[1] = {};
g_TabListData[2] = {};
g_TabListData[3] = {};
g_TabListData[4] = {};
g_TabListData[5] = {};


function AutoSearch_PreLoad()
	this:RegisterEvent("OPEN_AUTOSEARCH");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("UI_COMMAND");
end


function AutoSearch_OnLoad()

	--窗口加载时动态的插入列....直接在xml里配置列的话无法引用字典....
	AutoSearch_List:AddColumn( "名称", 0, 0.6 );
	AutoSearch_List:AddColumn( "简述", 1, 0.4 );

	--*****************************************
	--CEGUI有一处写的不合理的地方(Bug?)....导致多列列表设置属性时会出现一些错误....
	--具体为：
	--在XML中给多列列表配置了ColumnsSizable=True....就会设置该控件的ColumnsSizable=True....还会设置其所有列的ColumnsSizable=True....
	--有些多列列表如本窗口的需要在脚本中动态的插入列....这时XML中配置的ColumnsSizable=True只会设置该控件的ColumnsSizable=True....不会设置列的ColumnsSizable=True(因为当时一个列都没有)....
	--因此在脚本中动态插入列后列的ColumnsSizable因为没被设置过就不是True....
	--如果想在动态插入列后在脚本里再重新给多列列表设置ColumnsSizable=True也不行....
	--因为设置该属性的值时会判断是否与当前该属性的值一样....如果一样就直接返回....而该控件的ColumnsSizable在初始化XML的时候被设成True了所以会直接返回....也就不会给它的列设置该属性....
	--因此如果想动态插入列就需要在动态插入后再设置和列有关的属性....同时在XML中不能对和列有关的属性进行设置....
	--*****************************************
	AutoSearch_List:SetProperty( "ColumnsSizable", "False" );
	AutoSearch_List:SetProperty( "ColumnsAdjust", "True" );
	AutoSearch_List:SetProperty( "ColumnsMovable", "False" );

end

-- OnEvent
function AutoSearch_OnEvent(event)

	if ( event == "OPEN_AUTOSEARCH" ) then
	
		if( this:IsVisible() ) then
			this:Hide();
		else
			AutoSearch_Open();
		end

	elseif ( event == "SCENE_TRANSED" ) then
	
		--切换场景时关闭本窗口	
		this:Hide();
		local curSceneID = GetSceneID();
		if (curSceneID == 112) then
			AutoSearch_Open();
		end
  elseif(event == "UI_COMMAND" and tonumber(arg0)==831021) then
    if( this:IsVisible() ) then
			return;
		else
			AutoSearch_Open();
		end
	end
	
	

end


--**********************************
--打开自动寻路窗口....
--**********************************
function AutoSearch_Open()

	--打开窗口时默认是Tab1....
	if ( true == AutoSearch_UpdateFrame(1) ) then
		--设置Tab1按钮为选中状态....
		AutoSearch_Tab1:SetCheck(1);
		this:Show();
	else
		--如果没有任何可寻路的位置，则显示"当前的场景没有可寻路的目标。"
		PushDebugMessage("当前的场景没有可寻路的目标。");
	end

end

--**********************************
--更新自动寻路窗口....
--如当前场景没有可寻路的位置则返回false....
--**********************************
function AutoSearch_UpdateFrame( tabIndex )

	g_CurSelectTabIndex = tabIndex;

	--更新玩家当前所在场景的场景类型....
	UpdateCurrentSceneType();

	--根据当前的场景类型更新Tab按钮....
	UpdateTabButton();

	--更新自动寻路列表....
	return UpdateList( tabIndex );

end

--**********************************
--更新玩家当前所在场景的场景类型....
--**********************************
function UpdateCurrentSceneType()

	local curSceneID = GetSceneID();

	--城市
	for i, sceneId in g_CitySceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 0;
			return;
		end
	end

	--门派
	for i, sceneId in g_MenpaiSceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 1;
			return;
		end
	end

	--宠物
	for i, sceneId in g_PetSceneIDList do
		if curSceneID == sceneId then
			g_CurSceneType = 2;
			return;
		end
	end

	--其它场景
	g_CurSceneType = 3;

end

--**********************************
--根据当前的场景类型更新Tab按钮....
--**********************************
function UpdateTabButton()

	--城市
	if g_CurSceneType == 0 then
	
		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Show();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("全");
		AutoSearch_Tab2:SetText("功");
		AutoSearch_Tab3:SetText("店");
		AutoSearch_Tab4:SetText("任");
	
	--门派
	elseif g_CurSceneType == 1 then
	
		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Hide();
		AutoSearch_Tab4:Hide();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("全");
		AutoSearch_Tab2:SetText("功");
	
	--宠物
	elseif g_CurSceneType == 2 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Show();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("全");
		AutoSearch_Tab2:SetText("人");
		AutoSearch_Tab3:SetText("兽");
		AutoSearch_Tab4:SetText("猛");

	--其它
	elseif g_CurSceneType == 3 then

		AutoSearch_Tab1:Show();
		AutoSearch_Tab2:Show();
		AutoSearch_Tab3:Show();
		AutoSearch_Tab4:Hide();
		AutoSearch_Tab5:Hide();
		AutoSearch_Tab1:SetText("全");
		AutoSearch_Tab2:SetText("怪");
		AutoSearch_Tab3:SetText("人");

	end

end

--**********************************
--更新自动寻路列表....
--如果当前场景没有可寻路的位置则返回false....
--**********************************
function UpdateList( tabIndex )

	--清空List控件中的内容....
	AutoSearch_List:RemoveAllItem();

	--如果从上次更新数据之后场景改变了....则清空上次计算好的各Tab页的自动寻路数据....
	local curSceneID = GetSceneID();
	if g_LastUpdateSceneID ~= curSceneID then
		g_TabListData[1] = nil;
		g_TabListData[2] = nil;
		g_TabListData[3] = nil;
		g_TabListData[4] = nil;
		g_TabListData[5] = nil;
		g_LastUpdateSceneID = curSceneID;
	end

	--获取配置文件中....本场景自动寻路数据的起始与结束位置....
	local nStart, nEnd = DataPool:GetAutoSearchSceneStartEnd( GetSceneID() )

	--如果本场景没有可寻路的位置则返回false....
	if nStart == -1 then
		return false;
	end

	--如果没有本Tab页的自动寻路数据则重新计算....
	local g_TabListDataTablePtr = g_TabListData[tabIndex];

	if not g_TabListDataTablePtr then

		----PushDebugMessage("本tab页的数据还没有，得重算")
		g_TabListData[tabIndex] = {};
		g_TabListDataTablePtr = g_TabListData[tabIndex];

		--填充本场景自动寻路数据的ID和优先级到表格....
		local tblPriority = {};
		local nCount = nEnd - nStart + 1;
		local k = 1;
		for i=nStart, nEnd do
			tblPriority[k] = {};
			tblPriority[k].id = i;
			tblPriority[k].pri = DataPool:GetAutoSearchPriority(i);
			k = k + 1;
		end

		--按优先级对表格进行排序....
		--算法有点不好理解....策划要求权值相同的排序后相对位置不能改变....就先这么写了....
		local temp1,temp2;
		for m=nCount, 1, -1 do
			for n=m-1, 1, -1 do
				if tblPriority[m].pri >= tblPriority[n].pri then
					temp1 = tblPriority[m].id;
					temp2 = tblPriority[m].pri;
					tblPriority[m].id = tblPriority[n].id;
					tblPriority[m].pri = tblPriority[n].pri;
					tblPriority[n].id = temp1;
					tblPriority[n].pri = temp2;
				end
			end
		end

		--按排序后的ID顺序将自动寻路的数据加到本Tab页的自动寻路数据表中....
		local curTabType = TabIndex2TabType(tabIndex);
		local x, y, name, tooltips, info, tabtype; 
		k = 1;
		for i=1, nCount do
			x, y, name, tooltips, info, tabtype = DataPool:GetAutoSearch( tblPriority[nCount-i+1].id );
			if 0 == curTabType or curTabType == tabtype then
				g_TabListDataTablePtr[k] = {};
				g_TabListDataTablePtr[k].ID = tblPriority[nCount-i+1].id;
				g_TabListDataTablePtr[k].nPosX = x;
				g_TabListDataTablePtr[k].nPosY = y;
				g_TabListDataTablePtr[k].strName = name;
				g_TabListDataTablePtr[k].strToolTips = tooltips;
				g_TabListDataTablePtr[k].strInfo = info;
				--g_TabListDataTablePtr[k].strInfo = tostring(tblPriority[nCount-i+1].pri).."，"..tostring(tblPriority[nCount-i+1].id);
				k = k + 1;
			end
		end

	end --end of (if not g_TabListDataTablePtr then)

	--填充本页的自动寻路数据到List中....
	local nTabListCount = table.getn( g_TabListDataTablePtr );
	----PushDebugMessage("count ="..tostring(nTabListCount) )
	for i=1, nTabListCount do
		AutoSearch_List:AddNewItem( g_TabListDataTablePtr[i].strName, 0, i-1 );
		AutoSearch_List:AddNewItem( g_TabListDataTablePtr[i].strInfo, 1, i-1 );
		AutoSearch_List:SetRowTooltip( i-1, g_TabListDataTablePtr[i].strToolTips );
	end

	return true;

end

--**********************************
--获取在当前场景下指定Tab按钮所对应的分类类型....
--**********************************
function TabIndex2TabType( tabIndex )

	if g_CurSceneType ~= -1 and tabIndex >= 1 and tabIndex <= 5 then
		return g_TableTabIndex2TabType[g_CurSceneType+1][tabIndex];
	else
		return -1;
	end

end

--**********************************
--自动寻路到指定坐标....
--**********************************
function AutoMoveTo()

	--获取当前Tab页的自动寻路数据....
	g_TabListDataTablePtr = g_TabListData[g_CurSelectTabIndex];
	if not g_TabListDataTablePtr then
		return;
	end

	--选中了第几项....
	local nSelIndex = AutoSearch_List:GetSelectItem();
	if nSelIndex < 0 then
		return;
	end

	nSelIndex = nSelIndex + 1;

	--自动移动到指定位置
	AutoRunToTarget( g_TabListDataTablePtr[nSelIndex].nPosX, g_TabListDataTablePtr[nSelIndex].nPosY );

	--设置目标NPC的名字，到达该NPC处后会自动与其对话
	SetAutoRunTargetNPCName( g_TabListDataTablePtr[nSelIndex].strName );

end