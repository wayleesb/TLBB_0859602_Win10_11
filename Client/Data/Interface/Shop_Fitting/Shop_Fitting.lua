local g_ItemMax = 0;
local g_ItemIdx = -1;

local CU_MONEY			= 1	-- 钱

local objCared = -1;

g_MountXueYuID = 39;   --座骑雪羽的id
g_MountMingYuID = 44;	--座骑冥羽的id
g_CameraHeight = 1;     --摄影机高度
g_CameraDistance = 2;   --摄影机距离
g_CameraPitch = 3;      --摄影机角度





function Shop_Fitting_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("OPEN_SHOP_FITTING");
	this:RegisterEvent("CLOSE_SHOP_FITTING");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");
end

function Shop_Fitting_OnLoad()
end


function ShopFitting_OnHiden()
	SetDefaultMouse();
	RestoreShopFitting();
	this:Hide();
end

function Shop_Fitting_OnEvent(event)

--AxTrace(0,0,event);

	if ( event == "PLAYER_ENTERING_WORLD" ) then
		Shop_Fitting_Booth_Close();
		
		-- 显示经验
	end
	if(event == "OPEN_SHOP_FITTING") then
		this:Show();
		
		objCared = NpcShop:GetNpcId();
		this:CareObject(objCared, 1, "Shop_Fitting");
	
		Shop_Fitting_FakeObject:SetFakeObject("");	
		Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");
		
		local nMountID = GetMountID();
		if nMountID == g_MountXueYuID or g_MountMingYuID == nMountID  then   --雪羽的试骑比较特殊，单独设置摄像机的位置
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end
		
	elseif(event == "CLOSE_SHOP_FITTING") then
		
		RestoreShopFitting();
		this:Hide();
		
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和商人的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			RestoreShopFitting();
			this:CareObject(objCared, 0, "Shop_Fitting");
			this:Hide();			
		end
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			Shop_Fitting_FakeObject : Hide();
			Shop_Fitting_FakeObject : Show();
			Shop_Fitting_FakeObject:SetFakeObject("EquipChange_Player");
					local nMountID = GetMountID();
		if nMountID == g_MountXueYuID or g_MountMingYuID == nMountID then   --雪羽的试骑比较特殊，单独设置摄像机的位置
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);
		  FakeObj_SetCamera( "EquipChange_Player", g_CameraHeight,2);
		elseif nMountID > 0 then
			FakeObj_SetCamera( "EquipChange_Player", g_CameraDistance,12);	
		end
	end
end

function Shop_Fitting_Booth_Close()
	
	--取消关心
	this:CareObject(objCared, 0, "Shop_Fitting");
	RestoreShopFitting();
	CloseShopFitting();
	this:Hide();
end


function Shop_Fitting_Accept_Clicked()

	this:Hide();
end

function Shop_Fitting_TextChanged()

	
end


----------------------------------------------------------------------------------
--
-- 旋转人物头像模型（向左)
--
function Shop_Fitting_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
	AxTrace( 0,0, "Shop_Fitting_TurnLeft   " )
		--向左旋转开始
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(-0.3);
		--向左旋转结束
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function Shop_Fitting_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
	AxTrace( 0,0, "Shop_Fitting_TurnRight   " )
		--向右旋转开始
		if(start == 1) then
			Shop_Fitting_FakeObject:RotateBegin(0.3);
		--向右旋转结束
		else
			Shop_Fitting_FakeObject:RotateEnd();
		end
	end
end