
local ExchangeSafe_BoxName = {"第一格", "第二格", "第三格", "第四格", "第五格", "第六格", "第七格", "第八格", "第九格", "第十格", "第十一格", };
local ExchangeSafe_Box_Maxnum = 100;            --最多显示100条
local ExchangeSafe_Box_NowNum = 0;
--===============================================
-- OnLoad()
--===============================================
function ExchangeSafe_PreLoad()
	this:RegisterEvent("OPEN_EXCHANGE_FRAME");
	this:RegisterEvent("CLOSE_EXCHAGE_INFO");
	this:RegisterEvent("EXCHANGE_ADDITEM_BYOTHER");
	this:RegisterEvent("EXCHANGE_REMOVEITEM_BYOTHER");
	this:RegisterEvent("EXCHANGE_ADDPET_BYOTHER");
	this:RegisterEvent("EXCHANGE_REMOVEPET_BYOTHER");
	this:RegisterEvent("EXCHANGE_LOCK_BYOTHER");
	this:RegisterEvent("EXCHANGE_UNLOCK_BYOTHER");
	this:RegisterEvent("EXCHANGE_EDITMONEY_BYOTHER");
	this:RegisterEvent("EXCHANGE_CONFIRM_BYOTHER");
	this:RegisterEvent("EXCHANGE_UNLOCK_BYSELF");
end

--===============================================
--OnLoad()
--===============================================
function ExchangeSafe_OnLoad()

end

--===============================================
-- OnEvent()
--===============================================
function ExchangeSafe_OnEvent(event)

	if(event == "OPEN_EXCHANGE_FRAME") then
		ExchangeSafe_List:ClearAllElement();
		ExchangeSafe_Frame:SetProperty("UnifiedPosition", "{{0.0,320},{0.12,0}}");
		this:Show();
		--ExchangeSafe_Time:SetProperty("Text", "#{JYTX_090302_9}:");
		ExchangeSafe_Time:Hide();
		ExchangeSafe_Box_NowNum = 0;
	elseif (event == "CLOSE_EXCHAGE_INFO") then
		this:Hide();
	elseif (event == "EXCHANGE_ADDITEM_BYOTHER") then
		ExchangeSafe_AddItem(arg0, arg1, arg2, arg3);		
	elseif (event == "EXCHANGE_REMOVEITEM_BYOTHER") then
		ExchangeSafe_RemoveItem(arg0, arg1, arg2, arg3);
	elseif (event == "EXCHANGE_ADDPET_BYOTHER") then	
		ExchangeSafe_AddPet(arg0, arg1);
	elseif (event == "EXCHANGE_REMOVEPET_BYOTHER") then		
		ExchangeSafe_RemovePet(arg0, arg1);
	elseif (event == "EXCHANGE_LOCK_BYOTHER") then
		ExchangeSafe_Lock(arg0, 1);	
	elseif (event == "EXCHANGE_UNLOCK_BYOTHER") then
		ExchangeSafe_Lock(arg0, 0);	
	elseif (event == "EXCHANGE_EDITMONEY_BYOTHER") then
		ExchangeSafe_EditMoney(arg0, arg2, arg3);	
	elseif (event == "EXCHANGE_CONFIRM_BYOTHER") then
		ExchangeSafe_Confirm(arg0);		
	elseif (event == "EXCHANGE_UNLOCK_BYSELF") then
		ExchangeSafe_LockBySelf();
	end

end


function ExchangeSafe_AddItem(strItemName, strTime, nItemNum, nToPos)

	local strOtherName = Exchange:GetOthersName();
	local strBoxName = ExchangeSafe_BoxName[nToPos+1];
	local strItemNameN = strItemName;
	
	ExchangeSafe_UpdateTopElement();
	--local strTips = "";
	--strTips = string.format("%s %s #G修改金币金额为：#{_MONEY%d}", strTime, strOtherName, nMoneyThis);
	ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090302_1}".."#Y"..strBoxName.."#W".."#{JYTX_090302_2}".."["..strItemNameN.."]X"..tostring(nItemNum));
	ExchangeSafe_List:PageEnd();
	
end


function ExchangeSafe_RemoveItem(strItemName, strTime, nItemNum, nFromPos)
	local strOtherName = Exchange:GetOthersName();
	local strBoxName = ExchangeSafe_BoxName[nFromPos+1];
	local strItemNameN = strItemName;

	ExchangeSafe_UpdateTopElement();
	ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090302_1}".."#Y"..strBoxName.."#W".."#{JYTX_090302_3}".."["..strItemNameN.."]X"..tostring(nItemNum));
	ExchangeSafe_List:PageEnd();
end

function ExchangeSafe_AddPet(strPetName, strTime)
	local strOtherName = Exchange:GetOthersName();
	local strPetNameN = strPetName;
	
	ExchangeSafe_UpdateTopElement();
	ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090302_4}".."["..strPetNameN.."]");
	ExchangeSafe_List:PageEnd();
end

function ExchangeSafe_RemovePet(strPetName, strTime)
	local strOtherName = Exchange:GetOthersName();
	local strPetNameN = strPetName;
	
	ExchangeSafe_UpdateTopElement();
	ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090302_5}".."["..strPetNameN.."]");
	ExchangeSafe_List:PageEnd();
end

function ExchangeSafe_Lock(strTime, nType)
	local strOtherName = Exchange:GetOthersName();
	
	ExchangeSafe_UpdateTopElement();

	if (nType == 1) then
		ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090302_7}");
	elseif (nType == 0) then
		ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090302_8}");
	end
	ExchangeSafe_List:PageEnd();
end

function ExchangeSafe_EditMoney(strTime, nMoneyGold, nMoneyOther)
	local strOtherName = Exchange:GetOthersName();
	
	--local strTips = string.format("%s %s #G修改金币金额为：#{_MONEY%d}", strTime, strOtherName, nMoneySet);
	local strTips = "";
	local nGold = tonumber(nMoneyGold);
	local nOther = tonumber(nMoneyOther);
	local nSiller = math.floor(nOther/100);
	local nCopper = nOther - nSiller*100;
	
	strTips = string.format("%s#{JYTX_090302_6}%d#-02%d#-03%d#-04", strTime, nGold, nSiller, nCopper);		
	--if (nMoneyThis > 0) then
	--	strTips = string.format("%s#{JYTX_090302_6}#{_MONEY%d}", strTime, nMoneyThis);
	--else
	--	strTips = string.format("%s#{JYTX_090302_6}%d#-04", strTime, nMoneyThis);		
	--end
	
	ExchangeSafe_UpdateTopElement();

	ExchangeSafe_List:AddChatBoardElement(strTips);
	ExchangeSafe_List:PageEnd();
end

function ExchangeSafe_Confirm(strTime)
	local strOtherName = Exchange:GetOthersName();
	
	ExchangeSafe_UpdateTopElement();
	ExchangeSafe_List:AddChatBoardElement(strTime.."#{JYTX_090303_2}");
	ExchangeSafe_List:PageEnd();
end

function ExchangeSafe_LockBySelf()
	ExchangeSafe_Time:Show();
	ExchangeSafe_Watch:SetProperty("Timer",10);
end

function ExchangeSafe_TimeReach1()
	ExchangeSafe_Time:Hide();
end

function ExchangeSafe_UpdateTopElement()
	if (ExchangeSafe_Box_NowNum >= ExchangeSafe_Box_Maxnum) then
		ExchangeSafe_List:RemoveTopElement();
	end
	
	ExchangeSafe_Box_NowNum = ExchangeSafe_Box_NowNum + 1;
end