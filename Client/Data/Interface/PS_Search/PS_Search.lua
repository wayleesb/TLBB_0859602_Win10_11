--PS_Search.lua

local PAGE_ITEM = 0;
local PAGE_PET  = 1;

local g_CurPage;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- PreLoad
--===============================================
function PS_Search_PreLoad()
	this:RegisterEvent("OPEN_FIND_SHOP");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_CLOSE_FIND_SHOP");

end

--===============================================
-- OnLoad
--===============================================
function PS_Search_OnLoad()
	g_CurPage = PAGE_ITEM;
end

--===============================================
-- OnEvent
--===============================================
function PS_Search_OnEvent(event)

	if(event == "OPEN_FIND_SHOP")  then
		this:Show();
		PS_Search_UpdateFrame(g_CurPage)
		
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Search");
	
	elseif(event == "OBJECT_CARED_EVENT")   then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_Search");
		end	
	
	elseif ( event == "PS_CLOSE_FIND_SHOP" )    then
		this:Hide();
		
		--取消关心
		this:CareObject(objCared, 0, "PS_Search");

	end
	
end

--===============================================
-- 点击选择列表
--===============================================
function PS_Search_List_Selected()
	
	local nSelect = PS_Search_List:GetFirstSelectItem();
	if( nSelect == -1 )   then
		return;
	end
	
	if(g_CurPage == PAGE_ITEM)    then			--物品页
		PlayerShop:FindShop("item",nSelect+1);
	
	elseif(g_CurPage == PAGE_PET) then			--珍兽页
		PlayerShop:FindShop("pet",nSelect+1);
		
	end

end

--===============================================
-- UpdateFrame
--===============================================
function PS_Search_UpdateFrame(nPage)
	
	PS_Search_SetTabColor(nPage);
	PS_Search_List:ClearListBox();
	if(nPage == PAGE_ITEM)    then					--物品页
		PS_Search_List:AddItem("物品店",0)
		PS_Search_List:AddItem("宝石店",1)
		PS_Search_List:AddItem("武器店",2)
		PS_Search_List:AddItem("护甲店",3)
		PS_Search_List:AddItem("材料店",4)
		
		PS_Search_All:SetText("全部物品类");

	elseif(nPage == PAGE_PET) then 					--珍兽页
		PS_Search_List:AddItem("珍兽店",0)

		PS_Search_All:SetText("全部珍兽类");
		
	end
end

--===============================================
-- ChangeTabIndex
--===============================================
function PS_Search_ChangeTabIndex(nPage)
	g_CurPage = nPage;
	PS_Search_UpdateFrame(nPage)
end

--===============================================
-- 选一类
--===============================================
function PS_Search_All_Clicked()
	
	if(g_CurPage == PAGE_ITEM)    then			--物品页
		PlayerShop:FindShop("item", -1);
	
	elseif(g_CurPage == PAGE_PET) then			--珍兽页
		PlayerShop:FindShop("pet", -1);
		
	end
	
end

--===============================================
-- Tab上的字体颜色
--===============================================
function PS_Search_SetTabColor(nPage)

	local   selColor = "#e010101#Y";
	local noselColor = "#e010101";

	if( nPage == PAGE_ITEM )		then
		PS_Search_Check_Item:SetText(selColor.. "物品");
		PS_Search_Check_Pet:SetText(noselColor.. "珍兽");
	elseif( nPage == PAGE_PET )	then
		PS_Search_Check_Item:SetText(noselColor.. "物品");
		PS_Search_Check_Pet:SetText(selColor.. "珍兽");
	end

end

--===============================================
-- Close
--===============================================
function PS_Search_Close_Clicked()
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Search");
	
end