--UI COMMAND ID 19823 by hukai 39440~39446

local PETSKILL_BUTTONS_NUM = 12;
local PETSKILL_BUTTONS = {};

local g_clientNpcId = -1;
local g_selectindex = -1;
local g_selectskill = -1;
local g_selectgood = -1;
local g_ConsumeGoodsID = -1;
local g_ConsumeMoney = -1;

function PetLevelup_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("PETSKILLLEVELUP");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	
end

function PetLevelup_OnLoad()

	PETSKILL_BUTTONS[1] = PetLevelup_Skill1;
	PETSKILL_BUTTONS[2] = PetLevelup_Skill2;
	PETSKILL_BUTTONS[3] = PetLevelup_Skill3;
	PETSKILL_BUTTONS[4] = PetLevelup_Skill4;
	PETSKILL_BUTTONS[5] = PetLevelup_Skill5;
	PETSKILL_BUTTONS[6] = PetLevelup_Skill6;
	PETSKILL_BUTTONS[7] = PetLevelup_Skill7;
	PETSKILL_BUTTONS[8] = PetLevelup_Skill8;
	PETSKILL_BUTTONS[9] = PetLevelup_Skill9;
	PETSKILL_BUTTONS[10] = PetLevelup_Skill10;
	PETSKILL_BUTTONS[11] = PetLevelup_Skill11;
	PETSKILL_BUTTONS[12] = PetLevelup_Skill12;
	
end

function PetLevelup_OnEvent(event)

	if(event == "UI_COMMAND" and tonumber(arg0) == 19823) then
		if this : IsVisible() then									-- 如果界面开着，则不处理
			return
		end
		PetLevelup_Clear()
		
		this : Show()
		Pet:ShowPetList(1)

		local npcObjId = Get_XParam_INT(0)
		g_clientNpcId = DataPool : GetNPCIDByServerID(npcObjId)
		if g_clientNpcId == -1 then
			PushDebugMessage("未发现 NPC")
			PetLevelup_Hide()
			return
		end
		
		this : CareObject( g_clientNpcId, 1, "PetLevelup" )
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		PetLevelup_Selected(tonumber(arg0))
	elseif ( event == "OBJECT_CARED_EVENT" ) then
		if(tonumber(arg0) ~= g_clientNpcId) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if arg1 == "distance" and tonumber(arg2) > MAX_OBJ_DISTANCE or arg1=="destroy" then
			PetLevelup_Hide()
		end
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
		
		if( arg0 ~= nil and -1 == tonumber(arg0)) then
			return;
		end
		
		if g_selectgood == tonumber(arg0) then --已选中物品并且更新的物品是当前选中的物品
			--PushDebugMessage("PACKAGE_ITEM_CHANGED in if  "..tonumber(arg0))
			PetLevelup_UpdateGoods(tonumber(arg0))
		end
	elseif ( event == "PETSKILLLEVELUP" and this:IsVisible() ) then
		if( arg0 == nil or arg1 == nil ) then
			return;
		end
		
		local type = tonumber(arg0)
		if type == 1 then --拖动到物品栏
			PetLevelup_UpdateGoods(tonumber(arg1))
		elseif type == 2 then --拖动到技能栏，不使用PetLevelup_Skill_Clicked是因为索引计算方式不一样
			PetLevelup_Skill_Drag(tonumber(arg1))
		end
		
	elseif ( event == "DELETE_PET" and this:IsVisible() ) then
		PetLevelup_Hide()
		
	elseif ( event == "UPDATE_PET_PAGE" and this:IsVisible() ) then
		PetLevelup_Clear()
		
		this : Show()
		Pet:ShowPetList(1)
	end
	
end

function PetLevelup_CancelGoods()
	g_ConsumeGoodsID = -1 --选物品的时候设置了这两个值，所以取消物品的时候清空这两个值
	g_ConsumeMoney = -1
	
	PetLevelup_Skill01:SetActionItem(-1);
	if g_selectgood ~= -1 then
		LifeAbility : Lock_Packet_Item(g_selectgood,0);
	end
	g_selectgood = -1;
	PetLevelup_Money:SetProperty("MoneyNumber", "")
end

function PetLevelup_CancelSkill()
	PetLevelup_Skill02:SetActionItem(-1);
	g_selectskill = -1;
end

function PetLevelup_Clear()
	
	g_selectindex = -1

	for i=1, PETSKILL_BUTTONS_NUM do
		PETSKILL_BUTTONS[i]:SetActionItem(-1);
	end
	
	PetLevelup_CancelSkill()
	PetLevelup_CancelGoods()
	PetLevelup_Money:SetProperty("MoneyNumber", "")
	PetLevelup_PetModel:SetFakeObject("")
	
end

function PetLevelup_Hide()
	g_clientNpcId = -1
	this:CareObject(g_clientNpcId, 0, "PetLevelup")
	this:Hide()
	Pet:ShowPetList(-1)
	PetLevelup_Clear()
end

function PetLevelup_Frame_OnHiden()
	PetLevelup_Hide()
end

function PetLevelup_Selected(selectindex)
	if( -1 == selectindex ) then
		return;
	end
	
--	if PlayerPackage:IsPetLock(selectindex) == 1 then
--		PushDebugMessage("珍兽已加锁")
--		return
--	end
	
	PetLevelup_Clear()
	
	PetLevelup_PetModel:SetFakeObject("");
	Pet:SetSkillLevelupModel(selectindex);
	--Pet:SetPetLocation(selectindex,2);
	PetLevelup_PetModel:SetFakeObject( "My_PetLevelup" );
	
	local i=1;
	local k=1;
	
	while i <= PETSKILL_BUTTONS_NUM do
		local theSkillAction = Pet:EnumPetSkill( selectindex, i-1, "petskill");
		i = i + 1;
		if theSkillAction:GetID() ~= 0 then
			PETSKILL_BUTTONS[k]:SetActionItem(theSkillAction:GetID());
			k = k+1;
		end
	end
	
	g_selectindex = selectindex
end

function PetLevelup_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetLevelup_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetLevelup_PetModel:RotateEnd();
	end
end

function PetLevelup_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetLevelup_PetModel:RotateBegin(0.3);
	--向右旋转结束
	else
		PetLevelup_PetModel:RotateEnd();
	end
end

function PetLevelup_Skill_Clicked(nSkillIndex)

	if( -1 == selectindex ) then
		return;
	end
	
	local i=1;
	local k=1;

	while i <= PETSKILL_BUTTONS_NUM do --中间可能有空的技能，而显示的时候是往前塞的，所以要找到显示的技能对应的实际位置
		local theSkillAction = Pet:EnumPetSkill( g_selectindex, i-1, "petskill");
		if theSkillAction:GetID() ~= 0 then
			if k == nSkillIndex then
				g_selectskill = i-1
				PetLevelup_Skill02:SetActionItem(theSkillAction:GetID());
				
				break;
			end
			
			k = k+1;
		end
		
		i = i + 1;
	end

end

--这个函数跟前面不一样的地方是技能索引是玩家身上实际索引，而不是图标索引，所以需要新写一个函数
function PetLevelup_Skill_Drag(nSkillIndex)

	if( -1 == selectindex ) then
		return;
	end
	
	local theSkillAction = Pet:EnumPetSkill( g_selectindex, nSkillIndex, "petskill");
	if theSkillAction:GetID() ~= 0 then
		g_selectskill = nSkillIndex
		PetLevelup_Skill02:SetActionItem(theSkillAction:GetID());
	end
end

function PetLevelup_UpdateGoods(nGoodsIndex)
	local theAction = EnumAction(nGoodsIndex, "packageitem");
	
	if theAction:GetID() ~= 0 then
		local goodsID = PlayerPackage : GetItemTableIndex( nGoodsIndex )
		
		--是否加锁....
		if PlayerPackage:IsLock(nGoodsIndex) == 1 then
			PushDebugMessage("#{Item_Locked}")
			return
		end
		
		--是否选技能
		if g_selectskill == -1 then
			PushDebugMessage("#{JNHC_81015_06}")
			return
		end
		
		local skillID = Pet:GetSkillIDbyIndex(g_selectindex,g_selectskill)
		local WantGoodsID,WantMoney = Pet:GetPetSkillLevelupInfo(skillID)
		
		--技能是否可以升级
		if WantGoodsID == -1 or WantMoney == -1 then
			PushDebugMessage("#{JNHC_81015_03}")
			return
		end
		
		if goodsID ~= WantGoodsID then
			PushDebugMessage("#{JNHC_81015_04}")
			return
		end
		
		g_ConsumeGoodsID = WantGoodsID
		g_ConsumeMoney = WantMoney
		PetLevelup_Money:SetProperty("MoneyNumber", tostring(g_ConsumeMoney))
		
		--如果前面选了物品，则让之前的东西变亮
		if g_selectgood ~= -1 then
			LifeAbility : Lock_Packet_Item(g_selectgood,0);
		end
		
		PetLevelup_Skill01:SetActionItem(theAction:GetID());
		g_selectgood = nGoodsIndex;
		LifeAbility : Lock_Packet_Item(g_selectgood,1);
	else
		PetLevelup_CancelGoods()
	end
	
end

function PetLevelup_Btn_Click(nIndex)
	if nIndex == 1 then --取消物品
		PetLevelup_CancelGoods()
	elseif nIndex == 2 then	--取消技能
		PetLevelup_CancelSkill()
	end
end

function PetLevelup_Do()
	--是否选珍兽
	if g_selectindex == -1 then
		PushDebugMessage("#{JNHC_81015_05}")
		return
	end
	
	--是否选技能
	if g_selectskill == -1 then
		PushDebugMessage("#{JNHC_81015_06}")
		return
	end
	
	--是否选灵兽丹物品
	if g_selectgood == -1 or g_ConsumeGoodsID == -1 or g_ConsumeMoney == -1 or g_ConsumeGoodsID ~= PlayerPackage:GetItemTableIndex(g_selectgood) then
		PushDebugMessage("#{JNHC_81015_07}")
		return
	end
	
	--是否金钱足够
	if Player:GetData("MONEY")+Player:GetData("MONEY_JZ") < g_ConsumeMoney then
		PushDebugMessage("#{JNHC_81015_08}")
		return
	end
	
	local hid,lid = Pet:GetGUID(g_selectindex)
	
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("PetSkillLevelup");
		Set_XSCRIPT_ScriptID(311112);
		Set_XSCRIPT_Parameter(0,hid);
		Set_XSCRIPT_Parameter(1,lid);
		Set_XSCRIPT_Parameter(2,g_selectskill);
		Set_XSCRIPT_Parameter(3,g_selectgood);
		Set_XSCRIPT_ParamCount(4);
	Send_XSCRIPT();
	
	PetLevelup_Hide()
end