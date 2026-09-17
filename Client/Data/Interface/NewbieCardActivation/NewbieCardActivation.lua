local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_uicmd = 0;

function NewbieCardActivation_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("NewUserCard_Check_Result");
end

function NewbieCardActivation_OnLoad()
end

function NewbieCardActivation_OnEvent(event)
	if(event == "UI_COMMAND" and not this:IsVisible()) then
		if(tonumber(arg0) == 2004 or tonumber(arg0) == 20080819 or tonumber(arg0) == 2005 or tonumber(arg0) == 2006 or
		   tonumber(arg0) == 2007 or tonumber(arg0) == 2008 or tonumber(arg0) == 2007950) then
			objCared = Get_XParam_INT(0);
			objCared = Target:GetServerId2ClientId(objCared);
			NewUserCard_SetText(tonumber(arg0));
			this:CareObject(objCared, 1, "NewUserCard");
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			this:Show();
			g_uicmd = tonumber(arg0);
		end
	elseif(event == "OBJECT_CARED_EVENT") then
		--AxTrace(0, 0, "arg0:"..arg0.." arg1:"..arg1.." arg2:"..arg2.." objCared:"..objCared);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			Guild_Create_Close();
		end
	
	elseif(event == "NewUserCard_Check_Result")then
		local result = tonumber(arg0)
		if(tonumber(arg0)== 0) then
			NewUserCard_Close();
			return;
		end
		if(tonumber(arg0)== 1 or tonumber(arg0)== 2) then
			NewbieCardActivation_Input:SetProperty("DefaultEditBox", "True");
			NewbieCardActivation_Input:SetSelected( 0, -1 );
			return;
		end
	end

end

function NewUserCard_Open_Click()
	local cardNum = NewbieCardActivation_Input:GetText();
	if(0 == string.len(cardNum)) then return; end
	
	--'k' 财富卡
--	if(string.byte(cardNum) == 116 and g_uicmd == 2004) then
--		NewUserCard(cardNum);
	--'t' 体育卡
--	elseif(string.byte(cardNum) == 107 and g_uicmd == 2005) then
--		NewUserCard(cardNum);
	--'s' 网聚卡
--	elseif(string.byte(cardNum) == 115 and g_uicmd == 2006) then
--		NewUserCard(cardNum);
	--'w' 温州推广卡
--	elseif(string.byte(cardNum) == 119 and g_uicmd == 2007) then
--		NewUserCard(cardNum);
	--'q' 麒麟蛋卡
--	elseif(string.byte(cardNum) == 113 and g_uicmd == 2008) then
--		NewUserCard(cardNum);
  --'q' 台湾卡
--	elseif(string.byte(cardNum) == 113 and g_uicmd == 2007950) then
--		NewUserCard(cardNum);
--	else
--		PushDebugMessage("卡号不正确，请检查");
--	end
	--NewUserCard_Close();
	

	
	--判断新手卡558和666的输入是否有效
	local firstbyte = string.byte(cardNum)
	--PushDebugMessage(firstbyte..111111);
	if (g_uicmd == 2006 and (firstbyte == 116 or firstbyte == 99 or firstbyte ==67 or firstbyte ==83 or firstbyte == 84  or firstbyte == 115 or firstbyte == 68 or firstbyte == 100 )) then
		PushDebugMessage("#{CFK_081027_2}");
		return;
	end 
	
	if (g_uicmd == 2004 and (firstbyte ==83 or firstbyte == 84)) then
		PushDebugMessage("#{CFK_081027_1}");
		return;
	end 
	
	if (g_uicmd == 20080819 and (firstbyte == 67 or firstbyte == 68)) then
		PushDebugMessage("#{CFK_081027_1}");
		return;
	end
	
	if(g_uicmd == 2004 and firstbyte ~= 116 and firstbyte ~= 115 ) then     --588财富卡't','s''T','S'
		PushDebugMessage("#{CFK_081027_2}");
		return;
	elseif(g_uicmd == 20080819 and firstbyte ~= 99 and firstbyte ~= 100 ) then --666财富卡'c','C','d'
		PushDebugMessage("#{CFK_081027_2}");
		return;
	end
		
	NewUserCard(cardNum);
end

function NewUserCard_Close()
	this:Hide();
	this:CareObject(objCared, 0, "NewUserCard");
	g_uicmd = 0;
end

function NewUserCard_SetText(uicmd)
	if uicmd == 2004 then
		NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
		NewbieCardActivation_Text:SetText("#{INTERFACE_XML_536}");
	elseif uicmd == 20080819 then--666财富卡
		NewbieCardActivation_DragTitle:SetText("#{INTERFACE_XML_73}");
		NewbieCardActivation_Text:SetText("#{INTERFACE_XML_536}");
	elseif uicmd == 2005 then
		NewbieCardActivation_DragTitle:SetText("激活");
		NewbieCardActivation_Text:SetText("请在下面的输入框内输入您获得的CD-Key");
	elseif uicmd == 2006 then
		NewbieCardActivation_DragTitle:SetText("#{CJ_20080321_01}");
		NewbieCardActivation_Text:SetText("#{CJ_20080321_02}");
	elseif uicmd == 2007 then
		NewbieCardActivation_DragTitle:SetText("激活");
		NewbieCardActivation_Text:SetText("请在下面的输入框内输入您获得的CD-Key");
	elseif uicmd == 2008 then
		NewbieCardActivation_DragTitle:SetText("激活");
		NewbieCardActivation_Text:SetText("请在下面的输入框内输入您获得的CD-Key");
	elseif uicmd == 2007950 then
		NewbieCardActivation_DragTitle:SetText("#{CB_XUBAO_LINGQU_2}");
		NewbieCardActivation_Text:SetText("#{CB_XUBAO_LINGQU_3}");
	end
	NewbieCardActivation_Input:SetText("");
end