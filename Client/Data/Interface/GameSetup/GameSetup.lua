local g_PreAlpha = "0.8";
--===============================================
-- PreLoad()
--===============================================
function GameSetup_PreLoad()

	this:RegisterEvent("TOGLE_GAMESETUP");

	this:RegisterEvent("TOGLE_SYSTEMFRAME");
	this:RegisterEvent("TOGLE_SOUNDSETUP");
	this:RegisterEvent("TOGLE_VIEWSETUP");

end

--===============================================
-- OnLoad()
--===============================================
function GameSetup_OnLoad()
	GameSetup_ChatBkg_Slider:SetProperty( "DocumentSize","1" );
	GameSetup_ChatBkg_Slider:SetProperty( "PageSize","0.1" );
	GameSetup_ChatBkg_Slider:SetProperty( "StepSize","0.1" );
end

--===============================================
-- OnEvent()
--===============================================
function GameSetup_OnEvent(event)
	
	if ( event == "TOGLE_GAMESETUP" ) then
		this:Show();
		local old = {SystemSetup:GameGetData()};
		g_PreAlpha = tostring(old[10]);
		GameSetup_UpdateFrame();

	elseif(event == "TOGLE_VIEWSETUP" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();

	elseif(event == "TOGLE_SYSTEMFRAME" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();

	elseif(event == "TOGLE_SOUNDSETUP" and this:IsVisible()) then
		GameSetup_Cancel_Clicked();
	end

end


--===============================================
-- UpdateFrame()
--===============================================
function GameSetup_UpdateFrame()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();
	
	GameSetup_Item1						:SetCheck(n1);					-- 拒绝所有信件
	GameSetup_Item2						:SetCheck(n2);					-- 拒绝加我好友
	GameSetup_Item3						:SetCheck(n3);					-- 拒绝默认生信件
	GameSetup_Item4						:SetCheck(n4);					-- 拒绝交易
	GameSetup_Item5						:SetCheck(n5);					-- 拒绝队伍邀请
	GameSetup_Item6						:SetCheck(n6);					-- 关闭当前泡泡框
	GameSetup_Item7						:SetCheck(n7);					-- 拒绝查看配偶
	GameSetup_Item8						:SetCheck(n8);					-- 角色显示帽子
	GameSetup_Item9						:SetCheck(n9);					-- 非聊天模式
	GameSetup_ChatBkg_Slider	:SetPosition(f10);			-- 聊天背景透明度
	GameSetup_Item11					:SetCheck(n11);					-- 关闭快捷栏提示
	GameSetup_Lock						:SetCheck(n12);					-- 锁定快捷栏
	GameSetup_Scene						:SetCheck(n13);					-- 快速切换场景
	GameSetup_ChatItem				:SetCheck(n15);					-- 快捷键查看链接

end

--===============================================
-- GameSetup_Accept
-- 确定
--===============================================
function GameSetup_Accept_Clicked()

	local n1,n2,n3,n4,n5,n6,n7,n8,n9,f10,n11,n12,n13,n14,n15 = SystemSetup:GameGetData();

	n1 = GameSetup_Item1:GetCheck();									-- 拒绝所有信件
	n2 = GameSetup_Item2:GetCheck();                  -- 拒绝加我好友       
	n3 = GameSetup_Item3:GetCheck();                  -- 拒绝默认生信件     
	n4 = GameSetup_Item4:GetCheck();                  -- 拒绝交易           
	n5 = GameSetup_Item5:GetCheck();                  -- 拒绝队伍邀请       
	n6 = GameSetup_Item6:GetCheck();                  -- 关闭当前泡泡框     
	n7 = GameSetup_Item7:GetCheck();                  -- 拒绝查看配偶       
	n8 = GameSetup_Item8:GetCheck();                  -- 角色显示帽子       
	n9 = GameSetup_Item9:GetCheck();                  -- 非聊天模式
	f10 = GameSetup_ChatBkg_Slider:GetPosition();     -- 聊天背景透明度
	n11 = GameSetup_Item11:GetCheck();                -- 关闭快捷栏提示  
	n12 = GameSetup_Lock:GetCheck();                  -- 锁定快捷栏         
	n13 = GameSetup_Scene:GetCheck();                 -- 快速切换场景       
	n15 = GameSetup_ChatItem:GetCheck();              -- 快捷键查看链接     

	SystemSetup:SaveGameSetup ( n1,n2,n3,n4,n5,n6,n7,n8,n9,tonumber(f10),n11,n12,n13,n14,n15 );
	
	g_PreAlpha = f10;
	
	this:Hide();
end

--===============================================
-- GameSetup_Cancel
-- 取消
--===============================================
function GameSetup_Cancel_Clicked()

	GameSetup_ChatBkg_Slider:SetPosition(g_PreAlpha);
	Talk:HandleMainBarAction("chatbkg",g_PreAlpha);
	this:Hide();

end

--===============================================
-- GameSetup_DefaultSetting
-- 恢复默认
--===============================================
function GameSetup_Default_Clicked()

	GameSetup_Item1						:SetCheck(0);							-- 拒绝所有信件
	GameSetup_Item2						:SetCheck(0);             -- 拒绝加我好友
	GameSetup_Item3						:SetCheck(0);             -- 拒绝默认生信件
	GameSetup_Item4						:SetCheck(0);             -- 拒绝交易
	GameSetup_Item5						:SetCheck(0);             -- 拒绝队伍邀请
	GameSetup_Item6						:SetCheck(0);             -- 关闭当前泡泡框
	GameSetup_Item7						:SetCheck(0);             -- 拒绝查看配偶
	GameSetup_Item8						:SetCheck(0);             -- 角色显示帽子
	GameSetup_Item9						:SetCheck(0);             -- 非聊天模式
	GameSetup_ChatBkg_Slider	:SetPosition(1);       		-- 聊天背景透明度
	GameSetup_Item11					:SetCheck(1);							-- 关闭快捷栏提示
	GameSetup_Lock						:SetCheck(0);             -- 锁定快捷栏
	GameSetup_Scene						:SetCheck(1);             -- 快速切换场景
	GameSetup_ChatItem				:SetCheck(0);             -- 快捷键查看链接

end

--===============================================
-- GameSetup_ChatBkg_Slider
-- 设置聊天背景透明度
--===============================================
function GameSetup_ChatBkg_Change()
	local pos = GameSetup_ChatBkg_Slider:GetPosition();

	Talk:HandleMainBarAction("chatbkg",pos);
end