--UI Command 150
local g_MembersCtl = {};
local g_SynPet = {};
local g_clientNpcId = -1;
local MAX_OBJ_DISTANCE = 3.0;

function PetSynthesize_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("REPLY_MISSION_PET");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("DELETE_PET");
	this:RegisterEvent("UPDATE_PET_PAGE");
	this:RegisterEvent("PET_SYNC_OPEN");
end

function PetSynthesize_OnLoad()
	g_SynPet[0] = nil;
	g_SynPet[1] = nil;
end

function PetSynthesize_OnEvent(event)
	PetSynthesize_SetCtl();
	if(event == "UI_COMMAND") then
		PetSynthesize_OnUICommand(arg0);
	elseif(event == "PET_SYNC_OPEN" and arg0 == "close") then
		PetSynthesize_Hide();
	elseif(event == "REPLY_MISSION_PET" and this:IsVisible()) then
		PetSynthesize_SetPet(tonumber(arg0));
	elseif(event == "DELETE_PET" and this:IsVisible()) then
		PetSynthesize_Hide();
	elseif(event == "UPDATE_PET_PAGE" and this:IsVisible()) then
		PetSynthesize_UpdatePet();
	elseif ( event == "OBJECT_CARED_EVENT") then
		PetSynthesize_CareEventHandle(arg0,arg1,arg2);
	end
end

function PetSynthesize_SetCtl()
	g_MembersCtl[0] =	{
											--控件
											name 	= PetSynthesize_Other_Pet,
											model	=	PetSynthesize_Other_PetModel,
											left	= PetSynthesize_OtherModel_TurnLeft,
											right	=	PetSynthesize_OtherModel_TurnRight,
											cancel = PetSynthesize_ViewDesc_Other,
											--对应list中的索引
											idx = g_SynPet[0],
											--Fake系统中的名字
											strFake = "My_PetSynLeft",
										};

	g_MembersCtl[1] =	{
											--控件
											name 	= PetSynthesize_Self_Pet,
											model	=	PetSynthesize_Self_PetModel,
											left	= PetSynthesize_SelfModel_TurnLeft,
											right	=	PetSynthesize_SelfModel_TurnRight,
											cancel = PetSynthesize_ViewDesc_Self,
											--对应list中的索引
											idx = g_SynPet[1];
											--Fake系统中的名字
											strFake = "My_PetSynRight",
										};

	g_MembersCtl.confirm = PetSynthesize_Accept;
end

function PetSynthesize_OnUICommand(arg0)
	local op = tonumber(arg0);
	if(op == 150) then
		g_clientNpcId = Get_XParam_INT(0);
		g_clientNpcId = Target:GetServerId2ClientId(g_clientNpcId);
		this:CareObject(g_clientNpcId, 1, "PetSynthesize");
		
		PetSynthesize_ClearAll();
		Pet:ShowPetList(1);
		this:Show();
	end
end

function PetSynthesize_ClearPos(id)
	local pos = tonumber(id);
	if(pos == 0 or pos == 1) then
		g_MembersCtl[pos].name:SetText("");
		g_MembersCtl[pos].model:SetFakeObject("");
		g_MembersCtl[pos].left:Disable();
		g_MembersCtl[pos].right:Disable();
		g_MembersCtl[pos].cancel:Disable();
		g_MembersCtl[pos].idx = nil;
		g_SynPet[pos] = nil;
		
		g_MembersCtl.confirm:Disable();
	end
end

function PetSynthesize_ClearAll()
	PetSynthesize_ClearPos(0);
	PetSynthesize_ClearPos(1);
end

function PetSynthesize_UpdatePet()
	for pos = 0, 1 do
		if(g_MembersCtl[pos].idx) then
			--清除旧的信息
			g_MembersCtl[pos].name:SetText("");
			g_MembersCtl[pos].model:SetFakeObject("");
			--更新新的信息
			g_MembersCtl[pos].name:SetText(Pet:GetName(g_MembersCtl[pos].idx));
			Pet:SetSynModel(g_MembersCtl[pos].idx, pos);
			g_MembersCtl[pos].model:SetFakeObject(g_MembersCtl[pos].strFake);
		end
	end
end

function PetSynthesize_SetPet(idx)
	local nIdx = tonumber(idx);  --自己的第几只宠物
	if( -1 == nIdx or nil == nIdx) then
		return;
	end
	--检查是否重复
	for i = 0, 1 do
		--AxTrace(0,0,"PetSynthesize_SetPet nIdx:"..tostring(nIdx).." g_MembersCtl["..tostring(i).."].idx:"..
		--						tostring(g_MembersCtl[i].idx));
		if(g_MembersCtl[i].idx and g_MembersCtl[i].idx == nIdx) then return; end
	end
	--查找空间
	local nEmptyIdx = 0;	--如果占满了从第一个换
	for i = 0, 1 do
		if(nil == g_MembersCtl[i].idx) then 
			nEmptyIdx = i;
			break;
		end
	end
	--设置对应位置的对应宠物
	--AxTrace(0,0,"PetSynthesize_SetPos nEmptyIdx:"..tostring(nEmptyIdx).." nIdx:"..tostring(nIdx));
	PetSynthesize_SetPos(nEmptyIdx, nIdx);
end

function PetSynthesize_SetPos(id, petIdx)
	local pos = tonumber(id);
	local nPetIdx = tonumber(petIdx);
	if( -1 == nPetIdx or nil == nPetIdx) then
		return;
	end

	if(pos == 0 or pos == 1) then
		--清除旧数据
		PetSynthesize_ClearPos(pos);
		--设置新数据
		g_MembersCtl[pos].name:SetText(Pet:GetName(nPetIdx));
		Pet:SetSynModel(nPetIdx, pos);
		g_MembersCtl[pos].model:SetFakeObject(g_MembersCtl[pos].strFake);
		g_MembersCtl[pos].left:Enable();
		g_MembersCtl[pos].right:Enable();
		g_MembersCtl[pos].cancel:Enable();
		g_MembersCtl[pos].idx = nPetIdx;
		g_SynPet[pos] = nPetIdx;
		--AxTrace(0,0,"PetSynthesize_SetPos g_MembersCtl["..tostring(pos).."].idx:"..tostring(g_MembersCtl[pos].idx).." nPetIdx:"..tostring(nPetIdx));
		--设置确认按钮状态
		PetSynthesize_SetConfirm();
	end
end

function PetSynthesize_SetConfirm()
	local bConfirm = 1;
	for i = 0, 1 do
		if(nil == g_MembersCtl[i].idx) then
			bConfirm = nil;
			break;
		end
	end
	
	if(bConfirm) then g_MembersCtl.confirm:Enable(); end
end

function PetSynthesize_Clicked()
	for i = 0, 1 do
		if(nil == g_MembersCtl[i].idx) then return; end
	end
	
	Pet:Syn_Confirm(g_MembersCtl[0].idx, g_MembersCtl[1].idx);
	--PetSynthesize_Hide();
end

function PetSynthesize_CareEventHandle(careId, op, distance)
		if(nil == careId or nil == op or nil == distance) then
			return;
		end
		
		if(tonumber(careId) ~= g_clientNpcId) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(op == "distance" and tonumber(distance)>MAX_OBJ_DISTANCE or op=="destroy") then
			PetSynthesize_Hide();
		end
end

function PetSynthesize_Hide()
	this:Hide();
	Pet:ShowPetList(-1);
end

function PetSynthesize_Modle_TurnLeft(id,start)
	local pos = tonumber(id);
	if(pos == 0 or pos == 1) then
		--向左旋转开始
		if(start == 1) then
			g_MembersCtl[pos].model:RotateBegin(-0.3);
		--向左旋转结束
		else
			g_MembersCtl[pos].model:RotateEnd();
		end
	end
end

function PetSynthesize_Modle_TurnRight(id,start)
	local pos = tonumber(id);
	if(pos == 0 or pos == 1) then
		--向右旋转开始
		if(start == 1) then
			g_MembersCtl[pos].model:RotateBegin(0.3);
		--向右旋转结束
		else
			g_MembersCtl[pos].model:RotateEnd();
		end
	end
end