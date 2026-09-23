-- ConfraternityInfo_Amount   帮会id
-- ConfraternityInfo_CreateTime 创建时间
-- ConfraternityInfo_Create	创建人
-- ConfraternityInfo_Master	现任帮主
-- ConfraternityInfo_City	城市
-- ConfraternityInfo_Locus	所在地
--	ConfraternityInfo_CBD		商区
-- ConfraternityInfo_Specialty	当前研究
-- ConfraternityInfo_CityBuilding 当前建设
-- ConfraternityInfo_Level	规模
-- ConfraternityInfo_Info1	人数
-- ConfraternityInfo_Info4	工业度
-- ConfraternityInfo_Info5	农业度
-- ConfraternityInfo_Info6	商业度
-- ConfraternityInfo_Info7	国防度
-- ConfraternityInfo_Info8	科技度
-- ConfraternityInfo_Info9	扩张度
-- ConfraternityInfo_Info3	国家资金
-- ConfraternityInfo_Shangpiao 全帮商票剩余次数/每日上限


function ConfraternityInfo_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("GUILD_SHOW_DETAILINFO");
	this:RegisterEvent("GUILD_FORCE_CLOSE");
	this:RegisterEvent("GUILD_SELFEQUIP_CLICK");
end

function ConfraternityInfo_OnLoad()
end

function ConfraternityInfo_OnEvent(event)
	if(event == "UI_COMMAND") then
		if(tonumber(arg0) == 30 and this:IsVisible()) then
			Guild_Info_Close();
		elseif(tonumber(arg0) == 31) then
			Guild:AskGuildDetailInfo();
		end
	elseif(event == "GUILD_SHOW_DETAILINFO") then
		Guild_Info_Clear();
		Guild_Info_Update();
		Guild_Info_Close();
		Guild_Info_Show();
	elseif(event == "GUILD_FORCE_CLOSE") then
		Guild_Info_Close();
	elseif(event == "GUILD_SELFEQUIP_CLICK") then
		if(this:IsVisible()) then
			Guild_Info_Close();
		end
	end 
end

function Guild_Info_Clear()
	ConfraternityInfo_DragTitle:SetText("");
	--ConfraternityInfo_TitleInfo:SetText("");
	
	-- ConfraternityInfo_Specialty_Text:Hide();
	--ConfraternityInfo_Specialty:Hide();
end

function Guild_Info_Update()
	--local szMsg = Guild:GetMyGuildInfo("Name");
	--ConfraternityInfo_DragTitle:SetText(szMsg.."帮会详细信息");
	--2006-9-7 16:04按策划要求修改为固定页眉
	ConfraternityInfo_DragTitle:SetText("#gFF0FA0帮会详细信息");
	
	--2006-12-7 19:43 TODO:
  --szMsg = "贡献度:"..Guild:GetMyGuildDetailInfo("Con");
  --ConfraternityInfo_TitleInfo:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Name");
	ConfraternityInfo_ConfraternityName:SetText(szMsg);
	
	local leagueName = Guild:GetMyGuildDetailInfo("LeagueName");
	ConfraternityInfo_GuildLeagueName:SetText(leagueName);
	
	--MainInfo
	szMsg = Guild:GetMyGuildDetailInfo("ID");
	ConfraternityInfo_Amount:SetText(szMsg);
		
	szMsg = Guild:GetMyGuildDetailInfo("FoundedTime");
	ConfraternityInfo_CreateTime:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Level");
	ConfraternityInfo_Level:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Creator");
	ConfraternityInfo_Create:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("ChiefName");
	ConfraternityInfo_Master:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CityName");
	if(szMsg == "-1") then
		szMsg = "没有城市";
	end
	ConfraternityInfo_City:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("CurBuilding");
	ConfraternityInfo_CityBuilding:SetText(szMsg);

	
	szMsg = Guild:GetMyGuildDetailInfo("Scene");
	if(szMsg == "-1") then
		szMsg = "没有所在";
	end
	ConfraternityInfo_Locus:SetText(szMsg);
	szMsg = Guild:GetMyGuildDetailInfo("Comm");
	ConfraternityInfo_CBD:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("CurResearch");
	if(szMsg == "")then
		szMsg = "无当前研究";
	end;
	ConfraternityInfo_Specialty:SetText(szMsg);
	
	--TargetInfo
	szMsg = Guild:GetMyGuildDetailInfo("MemNum");
	ConfraternityInfo_Info1:SetText(szMsg);
	
	--szMsg = Guild:GetMyGuildDetailInfo("Honor");
	--ConfraternityInfo_Info2:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("FMoney");
	ConfraternityInfo_Info3:SetProperty("MoneyNumber", tostring(szMsg));
	
	szMsg = Guild:GetMyGuildDetailInfo("Ind");
	ConfraternityInfo_Info4:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("Agr");
	ConfraternityInfo_Info5:SetText(szMsg);

	szMsg = Guild:GetMyGuildDetailInfo("Com");
	ConfraternityInfo_Info6:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Def");
	ConfraternityInfo_Info7:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Tech");
	ConfraternityInfo_Info8:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Ambi");
	ConfraternityInfo_Info9:SetText(szMsg);
	
	szMsg = Guild:GetMyGuildDetailInfo("Boom");
	ConfraternityInfo_Info10:SetText( GetColorBoomValueStr(szMsg) );
		
	local bldprog = Guild:GetMyGuildDetailInfo("BldProg");
	local bldmaxprog = Guild:GetMyGuildDetailInfo("BldMaxProg");
	local resprog = Guild:GetMyGuildDetailInfo("ResProg");
	local resmaxprog = Guild:GetMyGuildDetailInfo("ResMaxProg");
	szMsg = "("..bldprog.."/"..bldmaxprog..")";
	ConfraternityInfo_CityBuilding_JinDu : SetText(szMsg);
	szMsg = "("..resprog.."/"..resmaxprog..")";
	ConfraternityInfo_Specialty_JinDu:SetText(szMsg);
	
	
		  
	local taken = Guild:GetMyGuildDetailInfo("TicketTaken");
	local limit = Guild:GetMyGuildDetailInfo("TicketLimit");
	if taken >= 0 and limit >= 0 then
		local remaining = limit - taken;
		if remaining < 0 then
			remaining = 0;
		end
		ConfraternityInfo_Shangpiao:SetText(remaining.."/"..limit);
	else
		ConfraternityInfo_Shangpiao:SetText("暂不可用");
	end
end

function Guild_Info_CheckMembers()
	Guild:AskGuildMembersInfo();
end

function Guild_Info_Quit()
	Guild:QuitGuild();
end

function Guild_Info_Show()
	this:Show();
end

function Guild_Info_Close()
	this:Hide();
end