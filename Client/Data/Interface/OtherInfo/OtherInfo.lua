--------------------------------------------------------------------------------
-- 装备按钮数据定义
--
local  g_BAG;			--行囊
local  g_BOX;			--格箱

--师德相关ToolTip内容	--add by xindefeng
local g_ShiDeTbl = {
											[0] = {"无#r", "0#r", 0},
											[1] = {"初级师傅#r", "2#r", 30},
											[2] = {"中级师傅#r", "3#r", 35},
											[3] = {"高级师傅#r", "5#r", 50},
											[4] = {"一代名师#r", "8#r", 70}
										}

function OtherInfo_PreLoad()
	
	-- 打开界面
	this:RegisterEvent("OPEN_OTHER_INFO");
	
	--离开场景，自动关闭
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("UPDATE_DOUBLE_EXP");
	
	--更新装备
	this:RegisterEvent("REFRESH_EQUIP1");
	
	-- 任务数据发生变化
	this:RegisterEvent("UPDATE_MISSION_DATA");
		
	--玩家使用兽栏--add by xindefeng
	this:RegisterEvent("UPDATE_PET_EXTRANUM");
	
end

function OtherInfo_OnLoad()

	g_BAG = OtherInfo_Packet1_Skill1; --行囊
	g_BOX = OtherInfo_Packet2_Skill1; --行囊
	
	OTHERINFO_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		"骑乘",
		"其他",
	};
end

-- OnEvent
function OtherInfo_OnEvent(event)
OtherInfo_SetTabColor(4);
	if ( event == "OPEN_OTHER_INFO" ) then
	
		if(this:IsVisible()) then
			
			this:Hide();
			return;
		end
		
		-- 执行服务器脚本，请求更新打劫数据
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("UpdataDacoityData");
			Set_XSCRIPT_ScriptID(311012);
			Set_XSCRIPT_ParamCount(0);
		Send_XSCRIPT();

		OtherInfo_OnShow();
		this:Show();
	end
	
	if( event == "PLAYER_LEAVE_WORLD") then
		this:Hide();
		return;
	end
	
	if( event == "UPDATE_DOUBLE_EXP") then
		local str = SystemSetup:GetDoubleExp( "count" )
		OtherInfo_6 : SetText(str.."小时")	
		local str1 = SystemSetup:GetDoubleExp( "juqing" )
		OtherInfo_7 : SetText(str1 .. "")	
		return;
	end

	if( event == "REFRESH_EQUIP1") then
		Equip_RefreshEquip1();
	end
	
	if(event == "UPDATE_MISSION_DATA")  then
		OtherInfo_OnShow();
	end
	
	--处理兽栏事件--add by xindefeng
	if(event == "UPDATE_PET_EXTRANUM") then
		if(this:IsVisible()) then			
			OtherInfo_OnShow()			
		end	
	end
	
	return;		
end

function Equip_RefreshEquip1()
	--  清空按钮显示图标
	g_BAG:SetActionItem(-1);			--行囊
	g_BOX:SetActionItem(-1);			--格箱
	
	local ActionBag 		= EnumAction(9 , "equip");
	local ActionBox 		= EnumAction(10, "equip");
	
	-- 显示人身上的武器装备
	g_BAG:SetActionItem(ActionBag:GetID());			--行囊
	g_BOX:SetActionItem(ActionBox:GetID());			--格箱 
end

-- 行囊点击事件
function SelfEquip_Bag_Click()
	g_BAG:DoSubAction();	--行囊
end

-- 格箱点击事件
function SelfEquip_Box_Click()
	g_BOX:DoSubAction();	--格箱
end

function OtherInfo_OnShow()
	OtherInfo_OtherInfo : SetCheck(1);
	local str;
	local selfUnionPos = Variable:GetVariable("SelfUnionPos");
	if(selfUnionPos ~= nil) then
		OtherInfo_Frame:SetProperty("UnifiedPosition", selfUnionPos);
	end
	
	str = Player : GetData("GOODBADVALUE");
	OtherInfo_1 : SetText(str)
	SetOtherInfo_1_Tooltip()	--设置其ToolTips	-- add by xindefeng	

	str = Player : GetData("PKVALUE");
	OtherInfo_2 : SetText(str)
		
	local prenticeNum = Player : GetData("PRENTICCOUNT");
	local masterLvl = Player : GetData("MASTERLEVEL");
	local availRecruitNum = 0;
	if masterLvl == 1 then
		availRecruitNum = 2;
	elseif masterLvl == 2 then
		availRecruitNum = 3;
	elseif masterLvl == 3 then
		availRecruitNum = 5;
	elseif masterLvl == 4 then
		availRecruitNum = 8;
	end
	OtherInfo_9_Text:SetText("收徒数量:");
	OtherInfo_9:SetText(prenticeNum.."/"..availRecruitNum);
--	str = Player : GetData("MORALPOINT");
--	OtherInfo_3 : SetText(str)
	
	str = Player : GetData("MENPAIPOINT");
	OtherInfo_4 : SetText(str)
	
	str = SystemSetup:GetDoubleExp( "count" )
	OtherInfo_6 : SetText(str.."小时")	
	str = Guild:GetGuildContri();
	OtherInfo_5 : SetText(str);
	
	local nCount = DataPool:GetPlayerMission_DataRound(150)
	OtherInfo_3:SetText(tostring(nCount))
		
	OtherInfo_8:SetText(tonumber(Player:GetData("PET_EXTRANUM")))	--显示兽栏空间--add by xindefeng
		
	OtherInfo_10 : SetText(Player : GetData("HONOR"));
end


function OtherInfo_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = OtherInfo_SelfEquip,
								OtherInfo_SelfData,
								OtherInfo_Pet,
								OtherInfo_Ride,
								OtherInfo_OtherInfo,
							};
	
	while i < 5 do
		if(i == idx) then
			tab[i]:SetText(selColor..OTHERINFO_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..OTHERINFO_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function OtherInfo_SelfEquip_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	OpenEquip(1);
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0)
	OtherInfo_Ride : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

--打开自己的资料页面
function OtherInfo_SelfData_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("self");
	this:Hide();
end

function OtherInfo_Pet_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	TogglePetPage();
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0);
	OtherInfo_Ride : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end

function OtherInfo_Ride_Page_Switch()
	Variable:SetVariable("SelfUnionPos", OtherInfo_Frame:GetProperty("UnifiedPosition"), 1);

	OpenRidePage();
	this:Hide();
	OtherInfo_SelfEquip : SetCheck(0);
	OtherInfo_SelfData : SetCheck(0);
	OtherInfo_Pet : SetCheck(0);
	OtherInfo_Ride : SetCheck(0);
	OtherInfo_OtherInfo : SetCheck(1);
	OtherInfo_SetTabColor(4);
end


function OnOtherInfo_OpenReputationClick()
	
	OpenWindow( "Reputation" );
	AxTrace( 0,0, "Open Window Reputation" );
end

function OtherInfo_OnOpenGruidClick()
	Guild:ToggleGuildDetailInfo();
end

-- 打开关系界面
function OtherInfo_OpenGuanXi_Click()
	OpenWindow( "Relation" );
	AxTrace( 0,0, "Open Window Relation" );
end

--设置otherinfo_1的tooltip	--add by xindefeng
function SetOtherInfo_1_Tooltip()
	local MasterLevel = Player:GetData("MASTERLEVEL")	--获取师德等级	
	if(MasterLevel < 0)then
		return
	end
	
	local ShanEValue = Player:GetData("GOODBADVALUE")						--获取善恶值	
	local TuDiCount = Player:GetData("PRENTICCOUNT")						--获取徒弟数量
	local TuDiSupplyExp = Player:GetData("PRENTICSUPPLYEXP")		--获取当前徒弟贡献的经验值
	local ShanEExp = ShanEValue * (g_ShiDeTbl[MasterLevel][3])	--计算与善恶值挂钩可以领取的经验值
	local TrueExp = ((TuDiSupplyExp < ShanEExp) and TuDiSupplyExp) or ShanEExp	--获取二者最小值	
	
	local str =	"师傅等级："..g_ShiDeTbl[MasterLevel][1].."弟子数目："..TuDiCount.."/"..g_ShiDeTbl[MasterLevel][2].."可兑换经验："..TrueExp
	
	OtherInfo_1:SetToolTip(str)
end
