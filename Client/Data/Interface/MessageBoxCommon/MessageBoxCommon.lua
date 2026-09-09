-- 通用MessageBoxCommon added by dun.liu 2008.9.14

local g_EnvName = "";
local g_ScriptStringOK = "";
local g_ScriptStringCancel = "";

function MessageBoxCommon_PreLoad()
	this:RegisterEvent("MESSAGEBOX_COMMON");
	this:RegisterEvent("MESSAGEBOX_COMMON_CLOSE");
end

function MessageBoxCommon_OnLoad()
	this:Hide();
end


-- ("Title") ("InfoText") ("EnvName") (OK_FUN) (CANCEL_FUN)
function MessageBoxCommon_OnEvent(event)
	if ( event == "MESSAGEBOX_COMMON" ) then
		this:Hide();
		MessageBoxCommon_OK_Button:Hide();
		MessageBoxCommon_Cancel_Button:Hide();
		MessageBoxCommon_Info_Button:Hide();
		
		MessageBoxCommon_DragTitle:SetText(arg0);
		MessageBoxCommon_Text:SetText(arg1);
		g_EnvName = arg2;
		g_ScriptStringOK = arg3;
		g_ScriptStringCancel = arg4;
		
		MessageBoxCommon_OK_Button:SetText("确定");
		MessageBoxCommon_OK_Button:Show();
		
		MessageBoxCommon_Cancel_Button:SetText("取消");
		MessageBoxCommon_Cancel_Button:Show();
		
		MessageBoxCommon_UpdateRect();
		
		this:Show();
	elseif ( event == "MESSAGEBOX_COMMON_CLOSE" ) then
		g_EnvName = "";
		g_ScriptStringOK = "";
		g_ScriptStringCancel = "";
		this:Hide();
	end

end

function MessageBoxCommon_Ok_Clicked()
	this:Hide();
	CallScriptString(g_EnvName, g_ScriptStringOK);
	--在这里已经改变了ScriptEnv，不要再继续调用MessageBox内部函数了
end

function MessageBoxCommon_Cancel_Clicked()
	this:Hide();
	CallScriptString(g_EnvName, g_ScriptStringCancel);
	--在这里已经改变了ScriptEnv，不要再继续调用MessageBox内部函数了
end

function MessageBoxCommon_Info_Clicked()
end

function  MessageBoxCommon_UpdateRect()
	local nWidth, nHeight = MessageBoxCommon_Text:GetWindowSize();
	local nTitleHeight = 36;
	local nBottomHeight = 75;
	nWindowHeight = nTitleHeight + nBottomHeight + nHeight;
	MessageBoxCommon_Frame:SetProperty( "AbsoluteHeight", tostring( nWindowHeight ) );
end
