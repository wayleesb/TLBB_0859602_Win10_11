--摆摊信息

--（摊主）发送新帖还是回复帖子
local NEW_MESSAGE   = 0;
local REPLY_MESSAGE = 1;
local g_NewOrReply  = NEW_MESSAGE;

--摊主或者买家的标志	=1表示摊主  =0表示买家
local SALESMAN = 1;
local BUYER  = 0;
local g_nSalesman = -1;

-- 修改广告语按钮的两种状态“发布”，“更改”
local AD_ISSUE		=0  
local AD_REJIGGER =1  
local g_AdState		= AD_REJIGGER;

--回复按钮对应的信息ID
local g_nMessageId = -1;

--===============================================
-- OnLoad()
--===============================================
function StallMessage_PreLoad()

	this:RegisterEvent("OPEN_STALL_MESSAGE");
	this:RegisterEvent("CLOSE_STALL_MESSAGE");
	
end

function StallMessage_OnLoad()
end

--===============================================
-- OnEvent()
--===============================================
function StallMessage_OnEvent(event)

	if(event == "OPEN_STALL_MESSAGE") then
		
		--摊主打开的BBS
		if(arg0 == "sale") then
			g_nSalesman = SALESMAN;
			
			StallMessage_Checkbox_Locked:Disable();
			StallMessage_Checkbox_Locked:SetCheck(0);
			
			if(g_AdState == AD_ISSUE) then
				StallMessage_Ad:SetText("发布");
				StallMessage_EditText:Show();
				StallMessage_StaticText:Hide();
			else
				StallMessage_Ad:SetText("更改");
				StallMessage_EditText:Hide();
				StallMessage_StaticText:Show();
				StallMessage_StaticText:SetText("#c9CCF00".. StallSale:GetAdvertise());
				StallMessage_EditText:SetText(StallSale:GetAdvertise()); --modify by dengxx
				--AxTrace(0, 0, "#B"..StallSale:GetAdvertise());
			
			end
			
			--只要是摊主打开，始终需要显示这个按钮			
			StallMessage_Ad:Show();
			StallMessage_ClearMessage:Show()

		elseif(arg0 == "buy") then
			g_nSalesman = BUYER;
			StallMessage_Ad:Hide();
			StallMessage_ClearMessage:Hide()
		end
		
		this:Show();
		g_nMessageId = -1;
		StallMessage_UpdateFrame();
		
	elseif(event == "CLOSE_STALL_MESSAGE") then
		this:Hide();
	end

end

--===============================================
-- OnEvent()
--===============================================
--给AddChatBoardElement函数加个参数，传入index表示是第几条消息，
--自己的摆摊中index为 -2 到 -21 ， 别人的摆摊中index为 -22 到 -41
--在上面点击右键时能通过这个ID得到发言内容，用于举报。
--by wangdw 2008.05.22
function StallMessage_UpdateFrame(event)

	StallMessage_Desc:ClearAllElement();
		
	local nMsgId;
	local szAuthorName;
	local szTime;
	local szMessage;
	local bReply;
	local szReplyMsg;
	
	--对于摊主
	if(g_nSalesman == SALESMAN) then
	
		StallMessage_EditText:Hide();
		StallMessage_StaticText:Show();
		
		g_AdState = AD_REJIGGER;
		StallMessage_Ad:SetText("更改");

		local nMessageNum = StallBbs:GetMessageNum("sale");
		for i=1, nMessageNum do
			
			nMsgId,szAuthorName,szTime,szMessage,bReply,szReplyMsg = StallBbs:EnumMessage(i-1,"sale");
			
			--1、对比名字和ID组合，如果是自己，
			if(szAuthorName == "#{_INFOUSR"..Player:GetName().."}("..StallSale:GetGuid()..")" )then
				StallMessage_Desc:AddChatBoardElement(szAuthorName);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				
			elseif(szAuthorName == "_SYSTEM")  then
				StallMessage_Desc:AddChatBoardElement("购买记录:"..szTime);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement("#R"..szMessage,i-1);
			
			--2、如果不是自己
			else
				StallMessage_Desc:AddChatBoardElement(szAuthorName,i-1);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				--如果已经有回复信息
				if(bReply == true) then
					StallMessage_Desc:AddChatBoardElement("  摊主回复："..szReplyMsg);
				else
					--回复按钮
					--StallMessage_Desc:AddOptionElement("回复" .. tostring(nMsgId));
					StallMessage_Desc:AddOptionElement("回复&".. nMsgId ..",0$-1");
				end
			
			end
		end
	
	--对于买家
	elseif(g_nSalesman == BUYER) then
		StallMessage_StaticText:SetText("#c9CCF00"..StallBuy:GetAdvertise());

		nMessageNum = StallBbs:GetMessageNum("buy");
		
		--不能回复
		StallMessage_Checkbox_Locked:SetCheck(0);
		StallMessage_Checkbox_Locked:Disable();

		
		for i=1, nMessageNum do
			
			nMsgId,szAuthorName,szTime,szMessage,bReply,szReplyMsg = StallBbs:EnumMessage(i-1,"buy");
			
			if(szAuthorName == "_SYSTEM")  then
				
				StallMessage_Desc:AddChatBoardElement("购买记录:"..szTime);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement("#R"..szMessage,i-1+20);

			else
				StallMessage_Desc:AddChatBoardElement(szAuthorName,i-1+20);
				--StallMessage_Desc:AddChatBoardElement(szTime);
				StallMessage_Desc:AddChatBoardElement(szTime..":#c9CCF00"..szMessage);
				if(bReply == true) then
					StallMessage_Desc:AddChatBoardElement("  摊主回复："..szReplyMsg);
				end
			
			end
			
		end
	end
	StallMessage_Desc:PageEnd();
end

--===============================================
-- OnEvent()
--===============================================
function StallMessage_FrameUpdate()
	
end

--===============================================
-- 发布 & 回复，有两个状态（只有在摊主界面上有效）
--     状态1。“发布”
--     状态2。“回复”
--===============================================
function StallMessage_SendMessage_Clicked()

	--对于摊主
	if(g_nSalesman == SALESMAN) then
		--AxTrace(0, 0, "sale");
		if(g_NewOrReply == NEW_MESSAGE) then
			--发新信息
			--AxTrace(0, 0, "AddMsg");
			StallBbs:AddMessage(StallMessage_EditInfoText:GetText(),"sale");
			
		else
			--回复
			StallBbs:ReplyMessage(g_nMessageId+0,StallMessage_EditInfoText:GetText());
			
			g_NewOrReply = NEW_MESSAGE;
			StallMessage_Checkbox_Text:SetText("");
					
		end
		
	-- 对于买家	（没有回复状态）
	elseif(g_nSalesman == BUYER)  then
			StallBbs:AddMessage(StallMessage_EditInfoText:GetText(),"buy");
		
	end
	
	
	StallMessage_EditInfoText:SetText("");

end


--===============================================
-- 清除留言
--===============================================
function StallMessage_ClearMessage_Clicked()

	local nMessageNum = StallBbs:GetMessageNum("sale");
	if(nMessageNum <= 0) then
	   return
	end
	
	StallMessage_Desc:ClearAllElement();
	StallBbs:DeleteMessageByID(-1)
	StallMessage_Desc:PageEnd();

end

--===============================================
-- 广告确定按钮，有两个状态（只有在摊主界面上有效）
--     状态1。“发布”
--     状态2。“更改”
--===============================================
function StallMessage_Ad_Clicked()

	if(g_AdState == AD_ISSUE) then
	
		if( 0 == StallSale:ApplyAd(StallMessage_EditText:GetText()) )  then
			--更改失败
			return;
		end
				
		StallMessage_StaticText:SetText("#B"..StallMessage_EditText:GetText());
		StallMessage_EditText:Hide();
		StallMessage_StaticText:Show();
		
		g_AdState = AD_REJIGGER;
		StallMessage_Ad:SetText("更改");
		
		
		StallMessage_EditText:SetProperty("DefaultEditBox", "False");
	
	else
--		local str = string.sub(StallMessage_StaticText:GetText(),2); --modify by dengxx
--		if str == "欢迎你来到本摊位" then
--		  StallMessage_EditText:SetText(str);
--	  end
		StallMessage_EditText:Show();
		StallMessage_StaticText:Hide();
		g_AdState = AD_ISSUE;
		StallMessage_Ad:SetText("发布");
		StallMessage_EditText:SetProperty("DefaultEditBox", "True");
	
	end

end

--===============================================
-- 点击一个回复按钮的操作 
--===============================================
function StallMessageOption_Clicked()

	pos1,pos2 = string.find(arg0,"#");
	pos3,pos4 = string.find(arg0,",");
	
	AxTrace(0,0, pos1 .. pos2 .. pos3 .. pos4 );
	
	-- 记录点击的消息的ID	
	g_nMessageId = string.sub(arg0, pos2+1,pos3-1 );
	
	-- 相应的界面变动
	StallMessage_Checkbox_Locked:SetCheck(1);
	StallMessage_Checkbox_Locked:Enable();
	
	StallMessage_Checkbox_Text:SetText("回复留言");
	
	StallMessage_EditInfoText:SetProperty("DefaultEditBox", "True");
	
	g_NewOrReply = REPLY_MESSAGE;

end

--===============================================
-- （点击CheckBox）取消回复状态 
--===============================================
function StallMessage_ReplyCheck_Clicked()

	-- 相应的界面变动
	StallMessage_Checkbox_Locked:SetCheck(0);
	StallMessage_Checkbox_Locked:Disable();
	StallMessage_Checkbox_Text:SetText("");
	
	g_NewOrReply = NEW_MESSAGE;

end

function StallMessage_Frame_OnHiden()
	StallMessage_EditInfoText:SetProperty("DefaultEditBox", "False");
	StallMessage_EditText:SetProperty("DefaultEditBox", "False");
end