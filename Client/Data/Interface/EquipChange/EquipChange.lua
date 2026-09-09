local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_Object = -1;
local Change_Item1 = -1
local Change_Item2 = -1
local Original_Visual_ID = -1
local List_String = {}

function EquipChange_PreLoad()

	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OBJECT_CARED_EVENT")
	this:RegisterEvent("UPDATE_EQUIPCHANGE")
	this:RegisterEvent("RESUME_ENCHASE_GEM")
	this:RegisterEvent("PACKAGE_ITEM_CHANGED")
	this:RegisterEvent("SEX_CHANGED");
end

function EquipChange_OnLoad()

	List_String[1]  = "可变外形一"
	List_String[2]  = "可变外形二"
	List_String[3]  = "可变外形三"
	List_String[4]  = "可变外形四"
	List_String[5]  = "可变外形五"

	List_String[6]  = "可变外形六"
	List_String[7]  = "可变外形七"
	List_String[8]  = "可变外形八"
	List_String[9]  = "可变外形九"
	List_String[10] = "可变外形十"
	
end

function EquipChange_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
			if tonumber(arg0) == 1010 then
				if this:IsVisible() then
					EquipChange_Close();
					return
				end
				this:Show();
				EquipChange_FakeObject:SetFakeObject("");	
				EquipChange_FakeObject:SetFakeObject("EquipChange_Player");	
				objCared = -1
				local xx = Get_XParam_INT(0);
				objCared = DataPool : GetNPCIDByServerID(xx);
				AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
				if objCared == -1 then
						PushDebugMessage("server传过来的数据有问题。");
						return;
				end
				BeginCareObject_EquipChange(objCared)
			end
	elseif  ( event == "UPDATE_EQUIPCHANGE" ) then
		AxTrace(5,5,"Change arg0="..arg0.." arg1 =="..arg1)
		if arg0~= nil then
			EquipChange_Update(arg0,arg1)
		end
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			EquipChange_Resume_Gem(tonumber(arg0));
		end
	elseif (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			EquipChange_Close()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then

		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end

		if( arg0~= nil ) then
			if (Change_Item1 == tonumber(arg0) ) then
				EquipChange_Resume_Gem(23)			
			end
			if (Change_Item2 == tonumber(arg0) ) then
				EquipChange_Resume_Gem(24)			
			end
		end
		
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			EquipChange_FakeObject : Hide();
			EquipChange_FakeObject : Show();
			EquipChange_FakeObject:SetFakeObject("EquipChange_Player");
	end
end

function EquipChange_OnShown()
	EquipChange_Clear();
end

function EquipChange_Clear()
	if Change_Item1 ~= -1 then
		LifeAbility : Update_Equip_VisualID()
		EquipChange_CurrentEquip:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Change_Item1,0);
		Change_Item1 = -1
	end

	if Change_Item2 ~= -1 then
		EquipChange_NeedObject:SetActionItem(-1);
		LifeAbility : Lock_Packet_Item(Change_Item2,0);
		Change_Item2 = -1
	end
	EquipChange_EquiptShapeList : ClearListBox()
	EquipChange_NeedMoney : SetProperty("MoneyNumber",0)
end

function EquipChange_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");
	local Exterior_id
	
	if u_index == 1 then
		if theAction:GetID() ~= 0 then
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 then
					if EquipPoint ~= -1 then
						PushDebugMessage("不能放入这种装备。")
					end
					return
				end
				Original_Visual_ID = LifeAbility : Get_Equip_VisualID(i_index);

				if Original_Visual_ID < 10000 then
					PushDebugMessage("这件装备不能改变外形。")
					EquipChange_Resume_Gem(23)
					return

				end
				if Change_Item1 ~= -1 then
					LifeAbility : Lock_Packet_Item(Change_Item1,0);
				end
				EquipChange_CurrentEquip:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Change_Item1 = i_index
		
				local Equip_Level = LifeAbility : Get_Equip_Level(i_index);
				EquipChange_NeedMoney : SetProperty("MoneyNumber", Equip_Level * 20000)
				
				EquipChange_EquiptShapeList : ClearListBox()
				
				for i = 1,10 do
					Exterior_id = LifeAbility : Get_Equip_Exterior(i_index,i-1);
					if Exterior_id ~= -1 then
						EquipChange_EquiptShapeList:AddItem(List_String[i],i-1);
					end
				end
			
		else
				EquipChange_Resume_Gem(23)
		end
	elseif u_index == 2 then
		if theAction:GetID() ~= 0 then
		
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900004 then
					PushDebugMessage("只能放入变形符。")
					return
				end

				if Change_Item2 ~= -1 then
					LifeAbility : Lock_Packet_Item(Change_Item2,0);
				end
				EquipChange_NeedObject:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				Change_Item2 = i_index
		else
				EquipChange_NeedObject:SetActionItem(-1);			
				LifeAbility : Lock_Packet_Item(Change_Item2,0);		
				Change_Item2 = -1;
		end
	end
	EquipChange_FakeObject:SetFakeObject("");	
	EquipChange_FakeObject:SetFakeObject("EquipChange_Player");	
end

function EquipChange_ListBox_Selected()
	local nSelIndex = EquipChange_EquiptShapeList:GetFirstSelectItem();
	
	if nSelIndex == -1 then
		return
	end
	
	EquipChange_FakeObject:SetFakeObject("");	
	EquipChange_FakeObject:SetFakeObject("EquipChange_Player");	
	--让人穿上
	local Visual_ID = LifeAbility : Get_Equip_Exterior(Change_Item1,nSelIndex);
	LifeAbility : Wear_Equip_VisualID(Change_Item1,Visual_ID)
end

function EquipChange_Buttons_Clicked()
	local nSelIndex = EquipChange_EquiptShapeList:GetFirstSelectItem();
	
	if Change_Item1 == -1 then
		PushDebugMessage("请放入要改变外形的装备。")
		return
	end
	
	if Change_Item2 == -1 then
		PushDebugMessage("请放入变形符。")
		return
	end
	
	if nSelIndex== -1 then
		PushDebugMessage("请选择一种外形。")
		return
	end
	
	local Visual_ID = LifeAbility : Get_Equip_Exterior(Change_Item1,nSelIndex);

	if Visual_ID == -1 then
		return
	end

	if Visual_ID ~= Original_Visual_ID then
	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("ChangeVisual");
			Set_XSCRIPT_ScriptID(809264);
			Set_XSCRIPT_Parameter(0,Change_Item1);
			Set_XSCRIPT_Parameter(1,Change_Item2);
			Set_XSCRIPT_Parameter(2,nSelIndex);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();

	end

end

function EquipChange_Close()
	EquipChange_FakeObject:SetFakeObject("");	
	this:Hide()
end

function EquipChange_Cancel_Clicked()
	EquipChange_Close();
	return;
end

function EquipChange_OnHidden()
	EquipChange_FakeObject:SetFakeObject("");
	StopCareObject_EquipChange(objCared)
	EquipChange_Clear()
	return
end
--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_EquipChange(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "EquipChange");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_EquipChange(objCaredId)
	this:CareObject(objCaredId, 0, "EquipChange");
	g_Object = -1;

end

function EquipChange_Resume_Gem(nIndex)
	if nIndex < 23 or nIndex > 24 then
		return
	end

	nIndex = nIndex - 22
	if( this:IsVisible() ) then
		if nIndex == 1 then
			if Change_Item1 ~= -1 then
				LifeAbility : Update_Equip_VisualID()
				EquipChange_CurrentEquip:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Change_Item1,0);
				Change_Item1 = -1
				EquipChange_NeedMoney : SetProperty("MoneyNumber", 0)
				EquipChange_EquiptShapeList : ClearListBox()
			end
		else
			if Change_Item2 ~= -1 then
				EquipChange_NeedObject:SetActionItem(-1)			
				LifeAbility : Lock_Packet_Item(Change_Item2,0);
				Change_Item2 = -1
			end
		end
	end
	
end