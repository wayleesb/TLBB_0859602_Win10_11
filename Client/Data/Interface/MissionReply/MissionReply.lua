local MISSION_BUTTONS_NUM =3;
local Pet_Index = -1;
local objCared = -1;
local MISSION_ITEM_BUTTONS = {};
local MISSION_ITEM_TEXT ={};
local MAX_OBJ_DISTANCE = 3.0;
local	Accept_Clicked_Num = 0;				-- 是否已按过一次“确定”											add by WTT	20090112
local	scriptId = -1;								-- “血浴神兵”任务时，调用该界面的脚本ID			add by WTT	20090112							

--任务提交界面

--===============================================
-- OnLoad
--===============================================
function MissionReply_PreLoad()

	this:RegisterEvent("REPLY_MISSION");						-- 提交任务界面
	this:RegisterEvent("QUEST_AFTER_CONTINUE");			-- 点击“继续”之后，奖品选择界面
	this:RegisterEvent("REPLY_MISSION_PET");				-- 珍兽刷新
	this:RegisterEvent("UPDATE_REPLY_MISSION");			-- 刷新提交任务界面
	this:RegisterEvent("OBJECT_CARED_EVENT");				-- 某逻辑对象的某些发生改变
	
end

function MissionReply_OnLoad()
	MISSION_ITEM_BUTTONS[1] = MissionReply_NeedItem1;
	MISSION_ITEM_BUTTONS[2] = MissionReply_NeedItem2;
	MISSION_ITEM_BUTTONS[3] = MissionReply_NeedItem3;
	
	MISSION_ITEM_TEXT[1] = MissionReply_NeedItem1_Info;
	MISSION_ITEM_TEXT[2] = MissionReply_NeedItem2_Info;
	MISSION_ITEM_TEXT[3] = MissionReply_NeedItem3_Info;
	
end

--===============================================
-- OnEvent
--===============================================
function MissionReply_OnEvent(event)
	
	-- 提交任务界面
	if ( event == "REPLY_MISSION" ) then		
		if (arg0~=nil) then
			objCared = tonumber(arg0);
			BeginCareObject_MissionReply(tonumber(arg0));
		end
		
		-- “血浴神兵”任务时，得到调用该界面的 scriptId
		-- add by WTT	20090112
		if (arg1~=nil) then
			scriptId = tonumber(arg1);			
		end
		
		MissionReplyFrameUpdate();
		this:Show();
	
	-- 刷新提交任务界面
	elseif( event == "UPDATE_REPLY_MISSION" )  then
		MissionReplyFrameUpdate();
	
	-- 点击“继续”之后，奖品选择界面
	elseif ( event == "QUEST_AFTER_CONTINUE" and this:IsVisible() ) then
		StopCareObject_MissionReply(objCared)
		this:Hide();
	
	-- 珍兽刷新
	elseif ( event == "REPLY_MISSION_PET" and this:IsVisible() ) then
		Pet_Index = tonumber(arg0);
		MissionReply_NeedPet_Info : SetText(Pet:GetName(Pet_Index));	

	-- 某逻辑对象的某些发生改变
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			
			--取消关心
			StopCareObject_MissionReply(objCared);
		end
		
	end

end

--===============================================
-- 更新显示界面数据
--===============================================
function MissionReplyFrameUpdate()
	
	--任务信息，（需求、奖励、描述等
	--进入前先清除原有信息
	MissionReply_Desc:ClearAllElement();
	MissionReply_NeedPet_Info: SetText("");
	if Pet_Index ~= -1 then
		MissionReply_NeedPet_Info : SetText(Pet:GetName(Pet_Index));	
	end
	
	
	--显示NPC名字
	if( Target:IsPresent()) then
		MissionReply_PageHeader_Name:SetText("#gFF0FA0"..Target:GetDialogNpcName());--get npc的name
	end
	local nTextNum, nBonusNum = DataPool:GetMissionDemand_Num();

	for i=1, nTextNum do
		local strInfo = DataPool:GetMissionDemand_Text(i-1);
		MissionReply_Desc:AddTextElement(strInfo);
	end
	
	if( nBonusNum>1 ) then
		MissionReply_Desc:AddTextElement("需要物品");
	end
	
	for i=1, nBonusNum do
		--    需要的类型，需要物品ID，需要多少个
		local nItemID, nNum = DataPool:GetMissionDemand_Item(i-1);
		MissionReply_Desc:AddItemElement(nItemID, nNum, 0);
	end
	
	
	--任务需要的物品栏（玩家自己拖放）
	local i=1;
	while i<=MISSION_BUTTONS_NUM do
		local theAction = MissionReply:EnumItem(i-1);

		if theAction:GetID() ~= 0 then
			MISSION_ITEM_BUTTONS[i]:SetActionItem(theAction:GetID());
			MISSION_ITEM_TEXT[i] : SetText(theAction:GetName());
		else
			MISSION_ITEM_BUTTONS[i]:SetActionItem(-1);
			MISSION_ITEM_TEXT[i] : SetText("");
		end

		i = i+1;
	end

	
	--任务需要的宠物栏（玩家自己拖放）
	
end

--===============================================
-- 宠物 (暂时不能完成)
--===============================================
function MissionReply_Pet_Clicked()
	MissionReply:OpenPetFrame();
end

--===============================================
-- 确定
--===============================================
function MissionReply_Accept_Clicked()
		
	-- 如果是“血浴神兵”中的“神器铸造”或“神器重铸”任务调用的该界面
	if ( scriptId == 500503 ) or ( scriptId == 500504 ) then

		if (Accept_Clicked_Num == 0) then
			MissionReply:OpenSecondConfirmFrame(scriptId);		-- 根据调用该界面的scriptId，打开对应的二次确认页面
			Accept_Clicked_Num = 1;

		else 	 
			MissionReply:OnContinue(Pet_Index);
			StopCareObject_MissionReply(objCared)
			Pet_Index = -1;
			Accept_Clicked_Num = 0; 													-- 第2次点击“确定”后，恢复 Accept_Clicked_Num 为未按过“确定”按钮。
			this:Hide();
		end
		
	else
		MissionReply:OnContinue(Pet_Index);
		StopCareObject_MissionReply(objCared)
		Pet_Index = -1;
		this:Hide();	
	end
	
end

--===============================================
-- 取消
--===============================================
function MissionReply_Cancel_Clicked()

	-- 如果是“血浴神兵”中的“神器铸造”或“神器重铸”任务调用的该界面
	if ( scriptId == 500503 ) or ( scriptId == 500504 ) then
		Accept_Clicked_Num = 0; 														-- 点击“取消”后，恢复 Accept_Clicked_Num 为未按过“确定”按钮。
	end
	
	StopCareObject_MissionReply(objCared)
	Pet_Index = -1;
	this:Hide();
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_MissionReply(objCaredId)

	AxTrace(0,0,"objCaredId =" .. objCaredId )
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "MissionReply");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_MissionReply(objCaredId)
	this:CareObject(objCaredId, 0, "MissionReply");
	g_Object = -1;

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function MissionReply_OnClose()
	DataPool:CloseMissionFrame();
	Pet : ShowPetList(0);
	MissionReply_Cancel_Clicked();

end

function MissionReply_ToggleShowPetList()
	DataPool : ToggleShowPetList();
end

--=========================================================
-- 点击图标
--=========================================================
function MissionReply_NeedItem_Click(nIndex)
	MissionReply:DoAction(nIndex);
end

