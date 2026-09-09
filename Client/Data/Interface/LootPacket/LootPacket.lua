local ITEMBOX_SLOTS_NUM = 4;
local ITEMBOX_SLOTS = {};
local ITEMBOX_SLOTS_DESCS = {};
local nPageNum = 1;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_LootSlod		= false;

local g_nTotalNum=0;
local g_nTotalPage=0;

--===============================================
-- OnLoad()
--===============================================
function LootPacket_PreLoad()
	this:RegisterEvent("LOOT_OPENED");
	this:RegisterEvent("LOOT_SLOT_CLEARED");
	this:RegisterEvent("LOOT_CLOSED");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PROGRESSBAR_SHOW");
	this:RegisterEvent("RELIVE_SHOW");

end

function LootPacket_OnLoad()

	ITEMBOX_SLOTS[1] = LootPacket_Item1;
	ITEMBOX_SLOTS[2] = LootPacket_Item2;
	ITEMBOX_SLOTS[3] = LootPacket_Item3;
	ITEMBOX_SLOTS[4] = LootPacket_Item4;
	
	ITEMBOX_SLOTS_DESCS[1] = LootPacket_Item1_Text;
	ITEMBOX_SLOTS_DESCS[2] = LootPacket_Item2_Text;
	ITEMBOX_SLOTS_DESCS[3] = LootPacket_Item3_Text;
	ITEMBOX_SLOTS_DESCS[4] = LootPacket_Item4_Text;

end

--===============================================
-- OnEvent()
--===============================================
function LootPacket_OnEvent(event)

	if(event == "LOOT_OPENED") then
		objCared = tonumber(arg0);
		this:Show();
		--关心掉包着
		this:CareObject(objCared, 1, "ItemBox");
		--更新
		LootPacket_Update(1, 1);
		
	elseif(event == "LOOT_SLOT_CLEARED") then
		g_LootSlod  = true;
		LootPacket_Update(nPageNum, 0);
		
	elseif(event == "LOOT_CLOSED") then
		this:Hide();
		--取消关心
		this:CareObject(objCared, 0, "ItemBox");

	elseif (event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();
			
			--取消关心
			this:CareObject(objCared, 0, "ItemBox");
		end
		
	--打开进度条的时候，关闭this
	elseif(event == "PROGRESSBAR_SHOW") then
		this:Hide();
		--取消关心
		this:CareObject(objCared, 0, "ItemBox");
		
	--角色死亡的时候，关闭this
	elseif(event == "RELIVE_SHOW") then
		this:Hide();
		
		--取消关心
		this:CareObject(objCared, 0, "ItemBox");

	end
end

--===============================================
-- Update()
--===============================================
function LootPacket_Update(thePage,bOpen)
	local i=1;
	local nActIndex = 0;
	
	if( bOpen == 1 ) then
		g_nTotalPage = 0;
		g_nTotalNum = GetActionNum("lootitem");
		
		if( g_nTotalNum > 0 ) then
			g_nTotalPage = math.floor((g_nTotalNum-1)/ITEMBOX_SLOTS_NUM)+1;
		end		
		if(thePage < 1) then 
			this:Hide();
			return;	
		end

	end

	local bCurPageHaveItem = false;

	nPageNum = thePage;
	local nStartIndex = (thePage-1)*ITEMBOX_SLOTS_NUM;

	local nActIndex = nStartIndex;
	local i=1;
	while i<=ITEMBOX_SLOTS_NUM do
		local theAction
		local theAction = EnumAction(nActIndex, "lootitem");
		nActIndex = nActIndex+1;

		if theAction:GetID() ~= 0 then
			ITEMBOX_SLOTS[i]:SetActionItem(theAction:GetID());
			ITEMBOX_SLOTS[i]:Show();
			ITEMBOX_SLOTS_DESCS[i]:SetText(theAction:GetName());
			ITEMBOX_SLOTS_DESCS[i]:Show();
			bCurPageHaveItem = true;
		else
			ITEMBOX_SLOTS[i]:SetActionItem(-1);
			ITEMBOX_SLOTS[i]:Hide();
			ITEMBOX_SLOTS_DESCS[i]:Hide();
		end
		i = i+1;
	end
	
	LootPacket_CurrentlyPage:SetText( tostring(nPageNum) .. "/" .. tostring(g_nTotalPage));

	--如果当前页已经没有物品，那么翻到下一页
	--如果已经没有下一页就往前翻页
	if( bCurPageHaveItem == false ) then
		if( g_LootSlod  == true )	then
			if( thePage+1 <= g_nTotalPage ) then 
				LootPacket_Update(thePage + 1, 0);
			end
		end
	end
	g_LootSlod = false;


	if( g_nTotalPage <= 1 )   then
		LootPacket_PageUp:Hide();
		LootPacket_PageDown:Hide();
		LootPacket_CurrentlyPage:Hide();
	else
		LootPacket_PageUp:Show();
		LootPacket_PageDown:Show();
		LootPacket_CurrentlyPage:Show();

		if( nPageNum > 1) then
			LootPacket_PageUp:Enable();
		else
			LootPacket_PageUp:Disable();
		end
	
		if( nPageNum < g_nTotalPage) then
			LootPacket_PageDown:Enable();
		else
			LootPacket_PageDown:Disable();
		end
		
	end
		
end

--===============================================
-- 点击物品
--===============================================
function LootPacket_Clicked(nIndex)
	if(nIndex < 1 or nIndex > ITEMBOX_SLOTS_NUM) then 
		return;
	end

	--AxTrace(0,0,"LootPacket_Clicked:DoAction");

	ITEMBOX_SLOTS[nIndex]:DoAction();
end

--===============================================
-- 上翻页
--===============================================
function LootPacket_Prev_Clicked()
	LootPacket_Update(nPageNum-1, 0);
end

--===============================================
-- 下翻页
--===============================================
function LootPacket_Next_Clicked()
	LootPacket_Update(nPageNum+1, 0);
end

--===============================================
-- 关闭窗口
--===============================================
function LootPacket_Button_Close()

	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "ItemBox");
	
end

--===============================================
-- 全部拾取
--===============================================
function LootPacket_Collect_Clicked()
	PlayerPackage:PickAllItem();

end