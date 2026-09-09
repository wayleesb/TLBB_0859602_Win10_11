local MySelf_Pet = ""
local Other_Pet = ""
local bIsSelfLock = 0
local bIsOtherLock = 0
local bIsConfirm = 0
local objCared = -1
local MAX_OBJ_DISTANCE = 15.0;
function PetProcreate_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("PETPROCREATE_MYSELF");	
	this:RegisterEvent("PETPROCREATE_OTHER");
	this:RegisterEvent("PETPROCREATE_OTHER_LOCK");	
	this:RegisterEvent("PETPROCREATE_OTHER_OK");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PETPROCREATE_KEY_STATE");
	
end

function PetProcreate_OnLoad()
end

function PetProcreate_OnEvent(event)
	
	if ( event == "UI_COMMAND" and tonumber(arg0) == 26) then
		AxTrace(0,1,"tonumber(arg0)="..tonumber(arg0));
		--第0个是金钱
		local xx = Get_XParam_INT(1);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		BeginCareObject_PetProcreate(objCared)
		Pet : PetProcreate_Clear();
		PetProcreate_OnUICommand();
		
	elseif  ( event == "PETPROCREATE_MYSELF" ) then
		MySelf_Pet=tostring(arg0);
		PetProcreate_Self_Pet : SetText(MySelf_Pet);
		PetProcreate_Self_PetModel : SetFakeObject( "" );
		Pet:SetProcreate_Self_Model();
		PetProcreate_Self_PetModel : SetFakeObject( "My_PetProcreateSelf" );
		PetProcreate_ViewDesc_Self : Enable();
		PetProcreate_Self_Lock:Enable();
		PetProcreate_Self_Lock:SetCheck(0);
		bIsSelfLock = 0
		bIsConfirm = 0
		PetProcreate_Accept:Disable();
		
	elseif  ( event == "PETPROCREATE_OTHER" ) then
		Other_Pet = tostring(arg0);
		PetProcreate_Other_Pet : SetText(Other_Pet);
		PetProcreate_Other_PetModel : SetFakeObject( "" );
		Pet:SetProcreate_Other_Model();
		PetProcreate_Other_PetModel : SetFakeObject( "My_PetProcreateOther" );
		PetProcreate_Other_Lock : SetCheck(0)
		bIsOtherLock = 0
		PetProcreate_Refresh_Confirm()	
	
	elseif  ( event == "PETPROCREATE_OTHER_LOCK" ) then
		if tonumber(arg0) == 1 then
			PetProcreate_Other_Lock : SetCheck(1)
			bIsOtherLock = 1
			PetProcreate_Refresh_Confirm()	
		else
			PetProcreate_Other_Lock : SetCheck(0)
			bIsOtherLock = 0
			if bIsSelfLock == 1 then
				PetProcreate_Lock_Clicked();
			end
			PetProcreate_Refresh_Confirm()	
		end
	
	elseif  ( event == "PETPROCREATE_OTHER_OK" ) then
		if tonumber(arg0) == 1 then
			PushDebugMessage("对方确认了繁殖。")
			PetProcreate_Refresh_Confirm_Ok()
		else
			PushDebugMessage("对方取消了繁殖。")
			PetProcreate_Close2(1)
		end
	elseif ( event == "PETPROCREATE_KEY_STATE")then
		PetProcreate_Refresh_BtnOK(tonumber(arg0));
	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			--取消关心
			PetProcreate_OK_Clicked(0)
		end
	end
	
	return
end

function PetProcreate_OnUICommand()
	g_Money = Get_XParam_INT(0)
	--PetProcreate_Consume : SetText("#{_MONEY".. g_Money .."}")
	PetProcreate_Consume:SetProperty( "MoneyNumber", tostring(g_Money) );

	PetProcreate_Show();		
end

function PetProcreate_Show()
	Pet:ShowPetList(1);
	this:Show();
	PetProcreate_Accept:Disable();
	PetProcreate_Self_Pet:SetText("")
	PetProcreate_Other_Pet:SetText("")
	
	PetProcreate_Other_Lock : SetCheck(0);
	PetProcreate_Other_Lock : Disable();
	PetProcreate_Self_Lock:SetCheck(0);
	PetProcreate_Self_Lock:Disable();
	
	PetProcreate_ViewDesc_Self:Disable();
	PetProcreate_ViewDesc_Other:Disable();
	bIsSelfLock = 0
	bIsOtherLock = 0
	PetProcreate_Self_PetModel : SetFakeObject( "" )
	PetProcreate_Other_PetModel : SetFakeObject( "" )
	
end

function PetProcreate_Lock_Clicked()
	Pet:LockPetProcreate()
	if bIsSelfLock == 0 then
		bIsSelfLock = 1
	else
		bIsSelfLock = 0
	end
	PetProcreate_Self_Lock:SetCheck(bIsSelfLock);
	PetProcreate_Refresh_Confirm()
end

function PetProcreate_OK_Clicked(IsOK)

	if IsOK == 1 then
		PetProcreate_Accept:Disable();
		bIsConfirm  = IsOK
	else
		--PetProcreate_Close()
	end
	
	--Pet:ConfirmPetProcreate(IsOK);
	-- zchw
	if IsOK == 1 then
		--PushEvent(549); -- GE_PET_PROCREATE_PROMPT
		PushEvent("PET_PROCREATE_PROMPT"); 
	else
		Pet:ConfirmPetProcreate(IsOK);
	end
end

function PetProcreate_Close()
	StopCareObject_Carriage(objCared);
	Pet : ShowPetList(0);
end

--===============================================
-- 右键点击(查看对方的珍兽资料)
--===============================================
function PetProcreate_Other_PetList_RClick()
	if PetProcreate_Other_Pet:GetText() ~= "" then
		Pet:ViewPetDetailData("other");
	end
end

--===============================================
-- 右键点击(查看自己的珍兽资料)
--===============================================
function PetProcreate_Self_PetList_RClick()
	if PetProcreate_Self_Pet:GetText() ~= "" then
		Pet:ViewPetDetailData("self");
	end
end

----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function PetProcreate_Self_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetProcreate_Self_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetProcreate_Self_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetProcreate_Self_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetProcreate_Self_PetModel:RotateBegin(0.3);
	--向右旋转结束
	else
		PetProcreate_Self_PetModel:RotateEnd();
	end
end


----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function PetProcreate_Other_TurnLeft(start)
	--向左旋转开始
	if(start == 1) then
		PetProcreate_Other_PetModel:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetProcreate_Other_PetModel:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetProcreate_Other_TurnRight(start)
	--向右旋转开始
	if(start == 1) then
		PetProcreate_Other_PetModel:RotateBegin(0.3);
	--向右旋转结束
	else
		PetProcreate_Other_PetModel:RotateEnd();
	end
end

function PetProcreate_PetList_Show()
	DataPool : ToggleShowPetList();
end

function PetProcreate_Refresh_BtnOK(isEnable)
	if(isEnable > 0) then
		PetProcreate_Accept:Enable()
	else
		PetProcreate_Accept:Disable()
	end
end

function PetProcreate_Refresh_Confirm()
	if bIsSelfLock == 1 and bIsOtherLock == 1 then
		--do nothing (PetProcreate_Accept:Enable())
	else
		PetProcreate_Accept:Disable()
	end
	
end

function PetProcreate_Refresh_Confirm_Ok()
	if bIsConfirm == 1  then
		PetProcreate_Close2(0)
	end
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_PetProcreate(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "PetProcreate");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_PetProcreate(objCaredId)
	this:CareObject(objCaredId, 0, "PetProcreate");
	g_Object = -1;

end


function PetProcreate_Frame_OnHide()
	--关掉相关界面
	PetProcreate_Close();
	--发取消消息
	Pet:ConfirmPetProcreate(0);
end

function PetProcreate_Close2(var)
	--设置变量
	Pet:SetCanFanzhiPet(tonumber(var))
	this:Hide();
end