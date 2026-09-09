local g_Type =0;
--===============================================
-- OnLoad
--===============================================
function Recycle_InputBox_PreLoad()
	this:RegisterEvent("RECYCLE_AD_SET");
	this:RegisterEvent( "CLOSE_RECYCLESHOP_MSG" );
end

function Recycle_InputBox_OnLoad()
end

--===============================================
-- OnEvent
--===============================================
function Recycle_InputBox_OnEvent(event)
	if ( event == "RECYCLE_AD_SET" ) then
		g_Type = tonumber(arg0);
		this:Show();
		Recycle_InputBox_Input:SetProperty("DefaultEditBox", "True");
		local desc = PlayerShop:RecycleShop_GetShopDesc(tonumber(g_Type));
		Recycle_InputBox_Input:SetText(desc);
	end
	if(event == "CLOSE_RECYCLESHOP_MSG" ) then
		if(this:IsVisible()) then
			this:Hide();
			return;
		end	
	end
end

--===============================================
-- 确定
--===============================================
function Recycle_InputBox_EventOK()
	if g_Type <=0 or g_Type>2 then
		return;
	end
	local strMood = Recycle_InputBox_Input:GetText();
	if( strMood == "" ) then 
		PushDebugMessage("广告词不能为空！");
		return;
	end
	PlayerShop:SendSetRecycleShopADMsg(g_Type, strMood );
	this:Hide();
end

--===============================================
-- 取消
--===============================================
function Recycle_InputBox_EventCancel()
	this:Hide();
end

--===============================================
-- 关闭自动执行
--===============================================
function Recycle_InputBox_OnHiden()
	Recycle_InputBox_Input:SetProperty("DefaultEditBox", "False");
end