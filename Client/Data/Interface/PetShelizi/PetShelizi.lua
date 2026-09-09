--  PetShelizi
--  炼制珍兽舍利子

local Guid_Pet_H = -1
local Guid_Pet_L = -1
local Index_Pet = -1
local UITYPE_SHELIZI = 8050191
local UITYPE_SHELIZI_NOTIFY = 8050192
local CareNpcID = -1
local minLevel=30
local Pet_DBName=""
local slzExp = 0
local needmoney = 0

function PetShelizi_PreLoad()
	this : RegisterEvent( "UI_COMMAND" )
	this : RegisterEvent( "REPLY_MISSION_PET" )						-- 玩家从列表选定一只珍兽
	this : RegisterEvent( "UPDATE_PET_PAGE" )						-- 玩家身上的珍兽数据发生变化，包括增加一只珍兽
	this : RegisterEvent( "DELETE_PET" )							-- 玩家身上减少一只珍兽
	this : RegisterEvent( "OBJECT_CARED_EVENT" )						-- 关心 NPC 的存在和范围
	this : RegisterEvent("UNIT_MONEY");
	this:RegisterEvent("MONEYJZ_CHANGE")		
end




function PetShelizi_OnLoad()
	PetShelizi_FormReset()
end

function PetShelizi_OnEvent(event)
	if event == "UI_COMMAND" then
		
		local CommandType = tonumber( arg0 )
		if UITYPE_SHELIZI == CommandType then
			local npcObjId = Get_XParam_INT( 0 )
			PetShelizi_OnUICommand( CommandType, tonumber( npcObjId ) )
		end
		
		if UITYPE_SHELIZI_NOTIFY == CommandType then
			slzExp = Get_XParam_INT( 0 )
			needmoney = math.floor(slzExp /100)
			if needmoney < 1 then
				needmoney = 1
			end
			PetShelizi_Demand_Money:SetProperty("MoneyNumber", needmoney)
			
			Guid_Pet_H, Guid_Pet_L = Pet : GetGUID( Index_Pet )
			PetShelizi_Pet1_Text : SetText(tostring(Pet_DBName))
			
			Pet : SetPetLocation( Index_Pet, 3 )
			PetShelizi_OK:Enable()
		end
	elseif (event == "UNIT_MONEY") then
		PetShelizi_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		
	elseif (event == "MONEYJZ_CHANGE") then
		PetShelizi_Currently_Jiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
	elseif event == "REPLY_MISSION_PET" and this : IsVisible() then
		
		PetShelizi_OnSelectPet( tonumber( arg0 ) )

	elseif event == "OBJECT_CARED_EVENT" and this : IsVisible() then	-- 关心 NPC 的存在和范围
		Pet : ShowPetList( 0 )
		if tonumber( arg0 ) ~= CareNpcID then
			return
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		local MAX_OBJ_DISTANCE = 3.0
		if arg1 == "distance" and tonumber( arg2 ) > MAX_OBJ_DISTANCE or arg1 == "destroy" then
			

			PetShelizi_Cancel_Clicked()
		end
				
	end
end

function PetShelizi_OnUICommand( CommandType, NpcObjID )
	local Type = tonumber( CommandType )
	if Type == UITYPE_SHELIZI then
		PetShelizi_FormReset()
		PetShelizi_BeginCareObject( NpcObjID )
		PetShelizi_Currently_Money:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
		PetShelizi_Demand_Money:SetProperty("MoneyNumber", 0);
		this:Show()
		Pet : ShowPetList( 1 )
	end

end


function PetShelizi_SelectPet_Clicked()

	Pet : ShowPetList( 0 )
	Pet : ShowPetList( 1 )
end

function PetShelizi_OnSelectPet( PetIndex )
	if PetIndex < 0 then
		return
	end
	
	PetShelizi_FormReset()

	Index_Pet = PetIndex
	local petGen , petDBName = Pet:GetPetTypeName(Index_Pet)
	local strName , strName2 = Pet:GetName(Index_Pet)
	
	if petGen == 1 then
		strName2 = "二代"..petDBName;
	end

	Pet_DBName = strName2	

	local guidPetH, guidPetL = Pet : GetGUID( PetIndex )
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetShelizi" )
		Set_XSCRIPT_ScriptID( 805019 )
		Set_XSCRIPT_Parameter( 0, guidPetH )
		Set_XSCRIPT_Parameter( 1, guidPetL )
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()
end

function PetShelizi_OnHidden()
	if Index_Pet > 0 then
		Pet : SetPetLocation( Index_Pet, -1 )
	end
	
	Pet : ShowPetList( 0 )
	Pet : ClearSheliziPet();
end

function PetShelizi_FormReset()
	Guid_Pet_H = -1
	Guid_Pet_L = -1
	Index_Pet  = -1
	Pet_DBName = ""
	slzExp = 0
	needmoney =0
	PetShelizi_Demand_Money:SetProperty("MoneyNumber", needmoney)
	PetShelizi_Pet1_Text : SetText( Pet_DBName )
	PetShelizi_OK:Disable()
end



--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function PetShelizi_BeginCareObject( objCaredId )
	CareNpcID = DataPool : GetNPCIDByServerID( objCaredId )
	if CareNpcID == -1 then
		this : Hide()
		return
	end

	this : CareObject( CareNpcID, 1, "PetShelizi" )
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function PetShelizi_StopCareObject()
	this : CareObject( CareNpcID, 0, "PetShelizi" )
	Pet : ShowPetList( 0 )
	CareNpcID = -1
end


function PetShelizi_Cancel_Clicked()
	PetShelizi_FormReset()
	PetShelizi_StopCareObject()
	this:Hide()
end

function PetShelizi_OK_Clicked()
	PetShelizi_Check()
end

function PetShelizi_Check()
	
	if Guid_Pet_H == -1 or Guid_Pet_L == -1 then
		return
	end
--	放开等级限制
	-- 判定珍兽的等级是否大于等于30
--	local Level = Pet : GetLevel( Index_Pet )
--	if Level < minLevel then
--		PushDebugMessage("#{ZSKSSJ_081113_08}")
--		return
--	end
	--是否在安全时间 
	if tonumber(DataPool:GetLeftProtectTime()) > 0 then
		PushDebugMessage("#{OR_PILFER_LOCK_FLAG}")
		return
	end
	local selfMoney = Player : GetData( "MONEY" ) + Player : GetData( "MONEY_JZ" )
	if needmoney > selfMoney then
		PushDebugMessage("#{no_money}")
		return
	end

	PetShelizi_Notify(slzExp)

end

function PetShelizi_Notify(AllExp)
	

	local isNotify = Pet:PetToShelizi(Index_Pet , AllExp)
	if isNotify == 0 then
		return
	end
	
	
	Clear_XSCRIPT()
		Set_XSCRIPT_Function_Name( "PetShelizi_Done" )
		Set_XSCRIPT_ScriptID( 805019 )
		Set_XSCRIPT_Parameter( 0, Guid_Pet_H )
		Set_XSCRIPT_Parameter( 1, Guid_Pet_L )
		Set_XSCRIPT_ParamCount( 2 )
	Send_XSCRIPT()

	PetShelizi_Cancel_Clicked()
end