
local g_Selectindex = -1;
local g_nShopIndex = {};
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local OpenType =0; --0:商店列表 1:收购商店列表
local g_LastSelect_NormalShop =""
local g_LastSelect_RecycleShop =""
--===============================================
-- OnLoad
--===============================================
function PS_ShopList_PreLoad()
	this:RegisterEvent("PS_OPEN_SHOPLIST");						-- 打开所有商店的列表
	this:RegisterEvent("PS_UPDATE_SEARCH_SHOPLIST");	-- 打开分类招招后的列表
	this:RegisterEvent("PS_OPEN_RECYCLESHOPLIST");	-- 打开分类招招后的列表
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("PS_UPDATE_SEARCH_RECYCLESHOPLIST");
	
end

function PS_ShopList_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function PS_ShopList_OnEvent(event)
	if ( event == "PS_OPEN_SHOPLIST" ) then
		OpenType = 0;
		this:Show();
		--objCared = tonumber(arg0);
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Shoplist");
	
		g_Selectindex = -1;

		PS_ShopList_Search_UpdateFrame();
		
	elseif( event == "PS_UPDATE_SEARCH_SHOPLIST" )  then
		g_Selectindex = -1;
		OpenType = 0;
		PS_ShopList_Search_UpdateFrame();
		
	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_Shoplist");
		end	
	elseif(event == "PS_UPDATE_SEARCH_RECYCLESHOPLIST")then
		OpenType = 1;
		g_Selectindex = -1;
		PS_ShopList_Search_UpdateFrame();
	end

end

--===============================================
-- UpdateFrame()   已经没有使用这个函数了
--===============================================
function PS_ShopList_UpdateFrame()
	
	--商业指数
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("商业指数;" .. szTemp);
	
	PS_ShopList_ShopList:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("all");
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		--	    名字,     总数量, 开张数, 类型
		local szShopName,OpenNum,SaleNum,szType = PlayerShop:EnumShop(i);
		local szState = SaleNum.."/"..OpenNum;
		PS_ShopList_ShopList:AddNewItem(szShopName, 0, i);
		PS_ShopList_ShopList:AddNewItem(szState, 1, i);
		PS_ShopList_ShopList:AddNewItem(szType, 2, i);	
		
		g_nShopIndex[i] = i;
	end
	
	UpdateShopInfo();	
	
end

--===============================================
-- 显示分类查询结果
--===============================================
function PS_ShopList_Search_UpdateFrame()
	PS_ShopList_Check_Item:Show();
	PS_ShopList_Check_Item2:Show();
	local ListCtr ;
	if(OpenType == 0) then
		PS_ShopList_Check_Item2:SetCheck(1);
		PS_ShopList_Check_Item:SetCheck(0);
		PS_ShopList_RecycleShopList:Hide();
		PS_ShopList_ShopList:Show();
		PS_ShopList_Button_Accept:SetProperty("Text", "购物");
		ListCtr = PS_ShopList_ShopList;
		PS_ShopList_Find:Show();
		PS_ShopList_Button_Remove:Show();
		PS_ShopList_Button_Manage:Show();
	else
		PS_ShopList_Check_Item2:SetCheck(0);
		PS_ShopList_Check_Item:SetCheck(1);
		PS_ShopList_RecycleShopList:Show();
		PS_ShopList_ShopList:Hide();
		PS_ShopList_Button_Accept:SetProperty("Text", "出售");
		ListCtr = PS_ShopList_RecycleShopList;
		PS_ShopList_Find:Hide();
		PS_ShopList_Button_Manage:Show();
		PS_ShopList_Button_Remove:Hide();
	end


	

	PS_ShopList_DragTitle:SetText("#gFF0FA0商会店铺");

	local szType = PlayerShop:GetShopListType();
	if(szType == "panchu" and OpenType==0)  then
		PS_ShopList_Find:Hide()
		PS_ShopList_Check_Item:Hide();
		PS_ShopList_Check_Item2:Hide();
		PS_ShopList_Button_Remove:Hide();
		PS_ShopList_Button_Manage:Hide();
		PS_ShopList_Button_Accept:SetText("查看");
		PS_ShopList_DragTitle:SetText("#gFF0FA0准备盘出的店铺");

	end


	--清空说明内容
	PS_ShopList_Since:SetText("");				-- 开店时间
	PS_ShopList_ShopOwner:SetText("");		-- 店主名字
	PS_ShopList_ShopOwnerID:SetText("");	-- 店主ID
	PS_ShopList_ShopInfo:SetText("");			-- 介绍

	g_Selectindex = -1;

	--商业指数
	local szTemp = PlayerShop:GetCommercialFactor();
	PS_ShopList_Commerce:SetText("商业指数:" .. szTemp);
	ListCtr:RemoveAllItem();
	
	local nNum = PlayerShop:GetShopNum("search");
	
	for i=0 , nNum-1 do
		g_nShopIndex[i] = -1;
		local nIndex = PlayerShop:EnumSearchShopIndex(i);
		
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(nIndex);
		local szState = SaleNum.."/"..OpenNum;

		if OpenType ==0 and szShopName == g_LastSelect_NormalShop then
			g_Selectindex = i;
		end
		
		if OpenType ==1 and szShopName == g_LastSelect_RecycleShop then
			g_Selectindex = i;
		end

		if nFrezeType == 1 then
			szShopName = "#cCCCCCC" .. szShopName
			szState    = "#cCCCCCC" .. szState
			szType     = "#cCCCCCC" .. szType
			nRecItemnum =  "#cCCCCCC" .. nRecItemnum
		elseif nIsFavor == 1 then
			szShopName = "#B" .. szShopName;
			szState    = "#B" .. szState;
			szType     = "#B" .. szType;
			nRecItemnum =  "#B" .. nRecItemnum;
		end

		if(OpenType == 0) then
			ListCtr:AddNewItem(szShopName, 0, i);
			ListCtr:AddNewItem(szState, 1, i);
			ListCtr:AddNewItem(szType, 2, i);
		else
			ListCtr:AddNewItem(szShopName, 0, i);
			ListCtr:AddNewItem(nRecItemnum, 1, i);
		end
		
		g_nShopIndex[i] = nIndex;
		
	end

	if (g_Selectindex >= 0) then
		ListCtr:SetSelectItem(g_Selectindex)
		ListCtr:SetVertScollPosition(g_Selectindex)
	end
end

--===============================================
-- Refuse
--===============================================
function PS_ShopListRefuse_Clicked()
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Shoplist");

end

--===============================================
-- Accept
--===============================================
function PS_ShopListAccept_Clicked(szType)
	--去打开选中的列表
	if( g_Selectindex >= 0 )      then
		if OpenType ==1 then
			--收购商店,购物
			PlayerShop:OpenRecycleShopDLG2(g_nShopIndex[g_Selectindex],szType);
			return
		else
			if( szType == "buy" )    then
				PlayerShop:AskOpenShop("buy",g_nShopIndex[g_Selectindex]);
			else
				PlayerShop:AskOpenShop("manage",g_nShopIndex[g_Selectindex]);
			end
		end
	else 
		PushDebugMessage("请选择一个商店");
		return;
	end
	
--	this:Hide();
	--取消关心
--	this:CareObject(objCared, 0, "PS_Shoplist");
	
end

--===============================================
-- 点击列表
--===============================================
function PS_ShopList_SelectChanged()
	
	local nIndex = PS_ShopList_ShopList:GetSelectItem();
	
	g_Selectindex = nIndex;
	
	if(g_Selectindex == -1)  then
		return;
	end
	PlayerShop:SetCurSelShopIdx(g_nShopIndex[nIndex]);
	
	local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[nIndex]);
	
	g_LastSelect_NormalShop = szShopName;
	
	--更新显示的信息
	UpdateShopInfo()
	
end

function PS_RecycleShopList_SelectChanged()
	
	local nIndex = PS_ShopList_RecycleShopList:GetSelectItem();
	
	g_Selectindex = nIndex;
	
	if(g_Selectindex == -1)  then
		return;
	end
	PlayerShop:SetCurSelShopIdx(g_nShopIndex[nIndex]);
	
	local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[nIndex]);
	
	g_LastSelect_RecycleShop = szShopName;
	
	--更新显示的信息
	UpdateShopInfo()
	
end

--===============================================
-- 更新商店的信息
--===============================================
function UpdateShopInfo()

	if g_Selectindex == -1    then
		return;
	end
	
	--更新信息
	-- 开店时间
	local szSince = PlayerShop:EnumShopInfo("since",g_nShopIndex[g_Selectindex]);
	PS_ShopList_Since:SetText("创建时间:".. szSince);
	
	-- 店主名字 --改为超链接 by wangdw
	local szName = PlayerShop:EnumShopInfo("ownername",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwner:SetChatString("#Y店主:#{_INFOUSR".. szName .. "}");
	
	-- 店主ID
	local szID = PlayerShop:EnumShopInfo("ownerid",g_nShopIndex[g_Selectindex]);
	PS_ShopList_ShopOwnerID:SetText("ID:".. szID);
	
	-- 介绍
	local szInfo = "";
	if(OpenType == 0)then
		 szInfo = PlayerShop:EnumShopInfo("desc",g_nShopIndex[g_Selectindex]);
	else
		 szInfo = PlayerShop:EnumShopInfo("recdesc",g_nShopIndex[g_Selectindex]);
	end
		
	PS_ShopList_ShopInfo:SetText(szInfo);
	
	-- 加入/去除 名店
	if( g_Selectindex == -1 )   then 
		return;
	end
	local szShopName,OpenNum,SaleNum,szType,nIsFavor = PlayerShop:EnumShop(g_nShopIndex[g_Selectindex]);
	if(nIsFavor == 1)   then
		PS_ShopList_Button_Remove:SetText("去除名店");
	else
		PS_ShopList_Button_Remove:SetText("#{INTERFACE_XML_353}");
	end
	
end


--===============================================
-- Close
--===============================================
function PS_CreateShopClose_Clicked()
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Shoplist");
end

--===============================================
-- 查找
--===============================================
function PS_ShopList_Find_Clicked()
	PlayerShop:OpenFindShop();
end

--===============================================
-- 加入/去除 名店
--===============================================
function PS_ShopList_Favor_Clicked()
	local selectIndex = PS_ShopList_ShopList:GetSelectItem();
	if(selectIndex < 0)     then
		return;
	end
	PlayerShop:AddFavor(g_nShopIndex[selectIndex]);
	
	local totalCount = PS_ShopList_ShopList:GetItemCount();
	
	--加入名店后，自动选中下一个店，如果已经是最后一个店了，则选中前一个，如果只有一个店，则选中自己
	if(selectIndex + 1 < totalCount) then
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex + 1]);
		g_LastSelect_NormalShop = szShopName;
	elseif(selectIndex - 1 >= 0) then
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex - 1]);
		g_LastSelect_NormalShop = szShopName;
	else
		local szShopName,OpenNum,SaleNum,szType,nIsFavor,nRecItemnum, nFrezeType = PlayerShop:EnumShop(g_nShopIndex[selectIndex]);
		g_LastSelect_NormalShop = szShopName;
	end
end

--===============================================
-- OnHiden
--===============================================
function PS_ShopList_Frame_OnHiden()
	PlayerShop:CloseSearchFrame();

end

function PS_ShopList_ChangeTabIndex(idx)
	
	if(idx==0)then
		if(PS_ShopList_Check_Item2:GetCheck()~=1)then
			PlayerShop:FindShop("all",0);
		end
	else
		if(PS_ShopList_Check_Item:GetCheck()~=1)then
			PlayerShop:FindShop("recycleshop",0);
		end
	end
end
