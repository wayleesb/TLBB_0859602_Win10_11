
-- hongyu
-- 土遁珠专用界面，请不要用于其他功能，
-- 

local g_SERVER_CONTROL_1 = 1008
local g_SERVER_CONTROL_2 = 1009
local g_SERVER_CONTROL_3 = 112235	--土灵珠使用界面

local Server_Script_Function = "";
local Server_Script_ID = 0;
local Server_Return_1 = 0;
local Server_Return_2 = 0;
local Server_Return_3 = 0;
local Server_Str = ""

local Client_ItemIndex = 0;

local g_Type	-- "use"使用土遁珠
							-- "call"队友使用土遁珠
							-- "useTLZ"使用土灵珠

--===============================================
-- PreLoad()
--===============================================
function Item_TuDunZhu_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("SCENE_TRANSED");
	this:RegisterEvent("ON_SCENE_TRANSING");
end

--===============================================
-- OnLoad()
--===============================================
function Item_TuDunZhu_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function Item_TuDunZhu_OnEvent(event)

	if ( event == "UI_COMMAND" ) then
		if tonumber(arg0) == g_SERVER_CONTROL_1 then
			Item_TuDunZhu_Show("use")
			g_Type = "use"
		elseif tonumber(arg0) == g_SERVER_CONTROL_2 then
			-- 检测如果这个窗口开着，就不处理
			if( this:IsVisible() ) then
				return
			else
				Item_TuDunZhu_Show("call")
				g_Type = "call"
			end
		elseif tonumber(arg0) == g_SERVER_CONTROL_3 then	--土灵珠
			Item_TuDunZhu_Show("useTLZ")
			g_Type = "useTLZ"
		else
			return
		end
	elseif event == "PLAYER_LEAVE_WORLD"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "SCENE_TRANSED"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	elseif event == "ON_SCENE_TRANSING"  then
		if( this:IsVisible() ) then
			this:Hide()
		end
	end
end

--===============================================
-- Show()
--===============================================
function Item_TuDunZhu_Show(event)
	if event == "use"  then
		
		Client_ItemIndex = tonumber(arg1)
		
--		Server_Script_Function = Get_XParam_STR(0)
--		Server_Script_ID = Get_XParam_INT(0);
--		Server_Return_1 = Get_XParam_INT(1);
--		
		Item_TuDunZhu_OK_Button:SetText("#{INTERFACE_XML_975}")	--定位
		Item_TuDunZhu_Cancel_Button:SetText("#{INTERFACE_XML_976}")	--传送
		Item_TuDunZhu_DragTitle:SetText("#{INTERFACE_XML_977}")	--土遁珠
		Item_TuDunZhu_Text:SetText("#{Item_TuDunZhu_Show_001}")	--土遁珠介绍
		this:Show()

		-- 关闭倒计时功能
		--Item_TuDunZhu_StopWatch : SetProperty("Timer",tostring(2000000));
		Item_TuDunZhu_StopWatch:Hide()

	elseif event == "call"  then
		Server_Script_Function = Get_XParam_STR(0)
		Server_Script_ID = Get_XParam_INT(0);
		Server_Return_1 = Get_XParam_INT(1);
		Server_Return_2 = Get_XParam_INT(2);
		Server_Str = Get_XParam_STR(1)

		Item_TuDunZhu_OK_Button:SetText("#{INTERFACE_XML_976}")	--传送
		Item_TuDunZhu_Cancel_Button:SetText("#{INTERFACE_XML_539}")	--取消
		Item_TuDunZhu_DragTitle:SetText("#{INTERFACE_XML_977}")	--土遁珠
		Item_TuDunZhu_Text:SetText(Server_Str)
		
		-- 添加倒计时
		Item_TuDunZhu_StopWatch : SetProperty("Timer",tostring(20));
		Item_TuDunZhu_StopWatch:Show()
		this:Show()
		
	elseif event == "useTLZ"  then
	
		Client_ItemIndex = tonumber(arg1)
		Item_TuDunZhu_OK_Button:SetText("#{INTERFACE_XML_975}")	--定位
		Item_TuDunZhu_Cancel_Button:SetText("#{INTERFACE_XML_976}")	--传送
		Item_TuDunZhu_DragTitle:SetText("#{INTERFACE_XML_978}")	--土灵珠
		Item_TuDunZhu_Text:SetText("#{INTERFACE_XML_979}")	--土灵珠介绍
		this:Show()

		-- 关闭倒计时功能
		--Item_TuDunZhu_StopWatch : SetProperty("Timer",tostring(2000000));
		Item_TuDunZhu_StopWatch:Hide()
		
	else
		return
	end

end

function Item_TuDunZhu_TimeOut()
	this:Hide()
end

--===============================================
-- OK
--===============================================
function Item_TuDunZhu_OK_Clicked()

	if g_Type == "use"  then
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("UseItem");
			Set_XSCRIPT_ScriptID(300056);
			Set_XSCRIPT_Parameter(0, 0);
			Set_XSCRIPT_Parameter(1, Client_ItemIndex);
			Set_XSCRIPT_ParamCount(2);
		Send_XSCRIPT();
		
	elseif g_Type == "call"  then
	
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name(Server_Script_Function);
			Set_XSCRIPT_ScriptID(Server_Script_ID);
			Set_XSCRIPT_Parameter(0, 1);
			Set_XSCRIPT_Parameter(1, Server_Return_1);
			Set_XSCRIPT_Parameter(2, Server_Return_2);
			Set_XSCRIPT_ParamCount(3);
		Send_XSCRIPT();

	elseif g_Type == "useTLZ"  then
	
		PlayerPackage:UseTulingzhuSetpos(Client_ItemIndex);
	
			--直接调用土灵珠脚本里的函数进行土灵珠的定位....
		--Clear_XSCRIPT();
		--	Set_XSCRIPT_Function_Name("SetPosition");
		--	Set_XSCRIPT_ScriptID(330001);
		--	Set_XSCRIPT_Parameter(0, Client_ItemIndex);
		--	Set_XSCRIPT_ParamCount(1);
		--Send_XSCRIPT();
	

				
	end
	
	this:Hide()
	
end

--===============================================
-- Cancel
--===============================================
function Item_TuDunZhu_Cancel_Clicked()

	if g_Type == "use"  then

		PlayerPackage:UseItem(Client_ItemIndex)

	elseif g_Type == "call"  then
		-- 
	elseif g_Type == "useTLZ"  then
	
		PlayerPackage:UseItem(Client_ItemIndex)	--土灵珠的默认使用逻辑为传送....
		
	end

	this:Hide()
	
end

--===============================================
-- 定位/取消
--===============================================
function Item_TuDunZhu_Help()
	
end
