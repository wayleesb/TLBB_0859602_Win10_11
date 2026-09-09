--MissionObjDel.lua
--销毁任务物品对话框

local	g_btnItem				--物品栏
local	g_txtItem				--物品描述
local	g_posItem	= -1	--物品在背包中的位置

local	MAX_OBJ_DISTANCE	= 3.0
local	g_objCared 				= -1

function MissionObjDel_PreLoad()
	this:RegisterEvent( "UI_COMMAND" )
	this:RegisterEvent( "UPDATE_MISOBJDEL" )
	
	this:RegisterEvent( "OBJECT_CARED_EVENT" )
	this:RegisterEvent( "PACKAGE_ITEM_CHANGED" )
end

function MissionObjDel_OnLoad()
	g_btnItem	= MissionObjDel_Item
	g_txtItem	= MissionObjDel_Item_Explain
end

function MissionObjDel_OnEvent( event )
	--打开界面
	if( event == "UI_COMMAND" and tonumber(arg0) == 42 ) then
		MissionObjDel_OnOpen()
		
		local	xx		= Get_XParam_INT( 0 )
		g_objCared	= DataPool : GetNPCIDByServerID( xx )
		AxTrace( 0, 1, "xx="..xx .. " objCared="..g_objCared )
		if g_objCared == -1 then
				PushDebugMessage( "Server传过来的数据有问题。" )
				return
		end

		BeginCareObject_MisObjDel( g_objCared )
		return
	end

	--物品拖拽到栏内
	if( event == "UPDATE_MISOBJDEL" ) then
		AxTrace( 0, 1, "arg0="..arg0 )
		if arg0 ~= nil then
			MissionObjDel_Clear()
			MissionObjDel_Update( tonumber(arg0) )
		end
		return
	end
	
	--关心NPC
	if( event == "OBJECT_CARED_EVENT" and this:IsVisible() ) then
		if( tonumber(arg0) ~= g_objCared ) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if( arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1 == "destroy" ) then
			MissionObjDel_OnClose()
		end
		return
	end
	
	--背包里的物品发生变化
	if( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		if( arg0 ~= nil and -1 == tonumber(arg0) ) then
			return
		end

		if( arg0 ~= nil and g_posItem == tonumber(arg0) ) then
				MissionObjDel_Clear()
				MissionObjDel_Update( tonumber(arg0) )
		end
		return
	end
end

--打开界面
function MissionObjDel_OnOpen()
	this:Show()
end

--关闭界面
function MissionObjDel_OnClose()
	this:Hide()
	
	StopCareObject_MisObjDel( g_objCared )
	g_objCared	= -1
end

--销毁按钮
function MissionObjDel_OnDestroy()
	if g_posItem ~= -1 then
		Clear_XSCRIPT()
			Set_XSCRIPT_ScriptID( 124 )
			Set_XSCRIPT_Function_Name( "OnDestroy" )
			Set_XSCRIPT_Parameter( 0, g_posItem )
			Set_XSCRIPT_ParamCount( 1 )
		Send_XSCRIPT()
	else
		PushDebugMessage( "请把要销毁的任务物品拖动到物品框中" )
	end
end

--取消按钮
function MissionObjDel_OnCancel()
	MissionObjDel_OnClose()
end

--清理物品
function MissionObjDel_Clear()
	g_btnItem : SetActionItem( -1 );
	g_txtItem : SetText( "需要销毁的任务物品" )
	LifeAbility : Lock_Packet_Item( g_posItem, 0 )
	g_posItem	= -1
end

--刷新物品
function MissionObjDel_Update( pos_taskitem )
	local	pos	= tonumber( pos_taskitem )
	local	theAction	= EnumAction( pos, "packageitem" )
	
	if theAction:GetID() ~= 0 then
		if LifeAbility : GetItem_Class( pos ) ~= 4 then
			PushDebugMessage( "只能销毁任务物品" )
			return
		end

		g_btnItem : SetActionItem( theAction:GetID() )
		g_txtItem : SetText( theAction:GetName() )
		if g_posItem ~= -1 then
			LifeAbility : Lock_Packet_Item( g_posItem, 0 )
		end

		--在背包中锁住这个物品
		g_posItem	= pos
		LifeAbility : Lock_Packet_Item( g_posItem, 1 )

	else
		MissionObjDel_Clear()
		return
	end

end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_MisObjDel( objCaredId )
	this:CareObject( objCaredId, 1, "MissionObjDel" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_MisObjDel( objCaredId )
	this:CareObject( objCaredId, 0, "MissionObjDel" )
end

function MissionObjDel_OnHide()
	MissionObjDel_Clear();
end
