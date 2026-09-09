
-- 当前的页数
local g_CurPage = -1;

-- 全部的页数
local g_AllPage;

-- 每页显示的数量
local MESSAGE_EACH_PAGE = 10;

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local g_szMseeageType = "";


--===============================================
-- PreLoad()
--===============================================
function PS_Message_PreLoad()

	this:RegisterEvent("PS_OPEN_MESSAGE");
	this:RegisterEvent("PS_UPDATE_MESSAGE");

end

--===============================================
-- OnLoad()
--===============================================
function PS_Message_OnLoad()
	
end

--===============================================
-- OnEvent()
--===============================================
function PS_Message_OnEvent(event)

	if ( event == "PS_OPEN_MESSAGE" )      then
		this:Show();
		objCared = PlayerShop:GetNpcId();
		this:CareObject(objCared, 1, "PS_Message");
		
		g_CurPage = tonumber(arg0);
		PS_Message_UpdateFrame();
		
	elseif ( event == "PS_UPDATE_MESSAGE" )  then
	
		g_CurPage = tonumber(arg0);
		PS_Message_UpdateFrame();
	

	elseif( event == "OBJECT_CARED_EVENT" )  then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "PS_Message");
		end	


	end	
end

--===============================================
-- UpdateFrame
--===============================================
function PS_Message_UpdateFrame()
	
	g_szMseeageType = PlayerShop:GetMessageType();
	
	
	if( szType == "exchange") then
		PS_Message_DragTitle:SetText("交易记录");
		g_AllPage = math.floor((PlayerShop:GetMessageNum("exchange")-1)/MESSAGE_EACH_PAGE)+1;
	else
		PS_Message_DragTitle:SetText("管理记录");
		g_AllPage = math.floor((PlayerShop:GetMessageNum("manage")-1)/MESSAGE_EACH_PAGE)+1;
	end
	
	PS_Message_List:ClearAllElement();
	
	local nMessageNum = PlayerShop:GetCurPageMessageNum("exchange");
	
	--  每一页显示最多10个
	local szInfo;
	for i=0, nMessageNum-1 do
		szInfo = PlayerShop:EnumMessage(i);
		PS_Message_List:AddTextElement(szInfo);
	end
	
	PS_Message_Pre:Enable();
	PS_Message_Next:Enable();
	
	if( g_CurPage == 0 )  then
		PS_Message_Pre:Disable();
	end
	
	if( g_CurPage == g_AllPage-1 ) then
		PS_Message_Next:Disable();
	end
	
end

--===============================================
-- 上一页
--===============================================
function PS_Message_Pre_Clicked()
	
	if(g_szMseeageType == "exchange")  then
		PlayerShop:OpenMessage("exchange",g_CurPage - 1);
	else
		PlayerShop:OpenMessage("manager",g_CurPage - 1);
	end
end

--===============================================
-- 下一页
--===============================================
function PS_Message_Next_Clicked()

	if(g_szMseeageType == "exchange")  then
		PlayerShop:OpenMessage("exchange",g_CurPage + 1);
	else
		PlayerShop:OpenMessage("manager",g_CurPage + 1);
	end
end

--===============================================
-- 关闭
--===============================================
function PS_Message_Close1_Clicked()

	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "PS_Message");

end

--===============================================
-- OnClose
--===============================================
function PS_Message_Close_Clicked()
	
end

