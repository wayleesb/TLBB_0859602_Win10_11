local Current_Ride_Index = -1;
local INVALID_ID =-1;
local RIDE_TAB_TEXT = {};
local OtherRide_g_Ride;			--骑乘对象
local OtherRide_g_EquipMask;

function OtherRide_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("TOGLE_OTHERRIDE_PAGE");
	
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD");

	
end

function OtherRide_OnLoad()
	
	RIDE_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"博客",
		"珍兽",
		"骑乘",
	};
	
	OtherRide_g_Ride = OtherRide_Equip;
	OtherRide_g_EquipMask = OtherRide_Equip_Mask;
end

-- OnEvent
function OtherRide_OnEvent(event)
	if ( event == "TOGLE_OTHERRIDE_PAGE" ) then
	
		if(this:IsVisible()) then
			
			this:Hide();
			return;
		end

		OtherRide_OnShow();
		this:Show();
	end
	
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
		return;
	end	
	return;		
end
function OtherRide_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherRide_TargetEquip,
								OtherRide_TargetData,
								OtherRide_Blog,
								OtherRide_Pet,
								OtherRide_Ride,
							};
	
	while i < 5 do
		if(i == idx) then
			tab[i]:SetText(selColor..RIDE_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..RIDE_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end
function OtherRide_OnShow()
	OtherRide_SetTabColor(4);
	OtherRide_Ride:SetCheck(1);
	local selfUnionPos = Variable:GetVariable("OtherUnionPos");
	if(selfUnionPos ~= nil) then
		OtherRide_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end

	OtherRide_List : ClearListBox();
	OtherRide_FakeObject : SetFakeObject( "" );
	local nRideIndex = LifeAbility : Get_OtherPlayerEquip_VisualID(8)
	if(INVALID_ID~=nRideIndex)then
		CachedTarget : SetHorseModel(nRideIndex);
		OtherRide_FakeObject : SetFakeObject( "Other_Horse" );
	end;
	
	OtherRide_Equip_Update();   --显示对方骑乘
	
	--nRideIndex = -1
	--while nRideIndex < 50 do
	--	nRideIndex = nRideIndex + 1;
		--StrName = Target : GetMyHorse(nRideIndex);
		
	--	if StrName ~= "-1" then
	--		OtherRide_List : AddItem(StrName, nRideIndex);
	--	end
	
	--end

end

----------------------------------------------------------------------------------
--
-- 选装玩家模型（向左)
--
function OtherRide_Model_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			OtherRide_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			OtherRide_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
-- 选装玩家模型（向右)
--
function OtherRide_Model_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			OtherRide_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			OtherRide_FakeObject:RotateEnd();
		end
	end
end



--===============================================
-- 打开玩家装备UI
--===============================================
function OtherRide_TargetEquip_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenEquipFrame("other");
end

--===============================================
-- 打开玩家资料UI
--===============================================
function OtherRide_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
--===============================================
-- 打开玩家博客UI
--===============================================
function OtherRide_TargetBlog_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);

	local strCharName =  CachedTarget:GetData("NAME");
	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
	Blog:OpenBlogPage(strAccount,strCharName,false);
end

function OtherRide_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", OtherRide_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end


function OtherRide_Equip_Click( buttonIn )
	local button = tonumber( buttonIn );
	if( button == 1 ) then
		OtherRide_g_Ride:DoAction();	--骑乘
	else
		OtherRide_g_Ride:DoSubAction();	--骑乘
	end
end


function OtherRide_Equip_Update()
	OtherRide_g_Ride:SetActionItem(-1);
	local ActionMount = EnumAction(8, "targetequip");
	OtherRide_g_Ride:SetActionItem(ActionMount:GetID());	
	
	if( ActionMount:GetEquipDur() < 0.1 ) then
		OtherRide_g_EquipMask:Show();
	else
		OtherRide_g_EquipMask:Hide();
	end
end