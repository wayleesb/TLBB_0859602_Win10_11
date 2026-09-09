
--===============================================
-- OnLoad
--===============================================
function InputMood_PreLoad()
	this:RegisterEvent("MOOD_SET");
end

function InputMood_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function InputMood_OnEvent(event)
	if ( event == "MOOD_SET" ) then
		InputMood_Input:SetText( "" );
		this:Show();
		InputMood_Input:SetProperty("DefaultEditBox", "True");
		InputMood_Input:SetText(DataPool:GetMood());
		InputMood_Input:SetSelected( 0, -1 );
	end
end

--===============================================
-- 确定
--===============================================
function InputMood_EventOK()
	local strMood = InputMood_Input:GetText();
	if( strMood == "" ) then 
		PushDebugMessage("心情不能为空");
		return;
	end
	DataPool:SetMood( strMood );
	this:Hide();
end

--===============================================
-- 取消
--===============================================
function InputMood_EventCancel()
	this:Hide();
end

--===============================================
-- 关闭自动执行
--===============================================
function InputMood_OnHiden()
	InputMood_Input:SetProperty("DefaultEditBox", "False");
end