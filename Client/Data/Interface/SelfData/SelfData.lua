
local CTRL_NUM = 11
local CTRL = {};

local SELF_PAGE  = 0;
local OTHER_PAGE = 1;
local g_Current_Page;
local SELFDATA_TAB_TEXT = {};

local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

--===============================================
-- OnLoad()
--===============================================
function SelfData_PreLoad()
	this:RegisterEvent("OPEN_PRIVATE_INFO");
	this:RegisterEvent("UPDATE_PRIVATE_INFO");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	
end

function SelfData_OnLoad()
	--生肖
	SelfData_YearAnimal:ComboBoxAddItem("-",0);
	SelfData_YearAnimal:ComboBoxAddItem("鼠",1); 
	SelfData_YearAnimal:ComboBoxAddItem("牛",2); 
	SelfData_YearAnimal:ComboBoxAddItem("虎",3); 
	SelfData_YearAnimal:ComboBoxAddItem("兔",4); 
	SelfData_YearAnimal:ComboBoxAddItem("龙",5); 
	SelfData_YearAnimal:ComboBoxAddItem("蛇",6); 
	SelfData_YearAnimal:ComboBoxAddItem("马",7); 
	SelfData_YearAnimal:ComboBoxAddItem("羊",8); 
	SelfData_YearAnimal:ComboBoxAddItem("猴",9);
	SelfData_YearAnimal:ComboBoxAddItem("鸡",10);
	SelfData_YearAnimal:ComboBoxAddItem("狗",11);
	SelfData_YearAnimal:ComboBoxAddItem("猪",12);
	
	--省份
	SelfData_Province:ComboBoxAddItem("-",		 0);
	SelfData_Province:ComboBoxAddItem("北京",  1); 
	SelfData_Province:ComboBoxAddItem("天津",  2); 
	SelfData_Province:ComboBoxAddItem("上海",  3); 
	SelfData_Province:ComboBoxAddItem("重庆",  4); 
	SelfData_Province:ComboBoxAddItem("河北",  5); 
	SelfData_Province:ComboBoxAddItem("辽宁",  6); 
	SelfData_Province:ComboBoxAddItem("山东",  7); 
	SelfData_Province:ComboBoxAddItem("黑龙江",8); 
	SelfData_Province:ComboBoxAddItem("山西",  9); 
	SelfData_Province:ComboBoxAddItem("吉林",  10);
	SelfData_Province:ComboBoxAddItem("陕西",  11);
	SelfData_Province:ComboBoxAddItem("河南",  12);
	SelfData_Province:ComboBoxAddItem("安徽",  13);
	SelfData_Province:ComboBoxAddItem("江苏",  14);
	SelfData_Province:ComboBoxAddItem("湖北",  15);
	SelfData_Province:ComboBoxAddItem("浙江",  16);
	SelfData_Province:ComboBoxAddItem("湖南",  17);
	SelfData_Province:ComboBoxAddItem("江西",  18);
	SelfData_Province:ComboBoxAddItem("福建",  19);
	SelfData_Province:ComboBoxAddItem("台湾",  20);
	SelfData_Province:ComboBoxAddItem("内蒙古",21);
	SelfData_Province:ComboBoxAddItem("甘肃",  22);
	SelfData_Province:ComboBoxAddItem("宁夏",  23);
	SelfData_Province:ComboBoxAddItem("四川",  24);
	SelfData_Province:ComboBoxAddItem("贵州",  25);
	SelfData_Province:ComboBoxAddItem("云南",  26);
	SelfData_Province:ComboBoxAddItem("广西",  27);
	SelfData_Province:ComboBoxAddItem("广东",  28);
	SelfData_Province:ComboBoxAddItem("海南",  29);
	SelfData_Province:ComboBoxAddItem("新疆",  30);
	SelfData_Province:ComboBoxAddItem("青海",  31);
	SelfData_Province:ComboBoxAddItem("西藏",  32);
	SelfData_Province:ComboBoxAddItem("澳门",  33);
	SelfData_Province:ComboBoxAddItem("香港",  34);
	SelfData_Province:ComboBoxAddItem("其他",  35);
	
	 --澳门  香港 和其他
	                                          
	--性别
	SelfData_Sex:ComboBoxAddItem("-",0);
	SelfData_Sex:ComboBoxAddItem("男",1);
	SelfData_Sex:ComboBoxAddItem("女",2);

	--血型
	SelfData_BloodType:ComboBoxAddItem("-",0);
	SelfData_BloodType:ComboBoxAddItem("A",1);
	SelfData_BloodType:ComboBoxAddItem("B",2);
	SelfData_BloodType:ComboBoxAddItem("AB",3);
	SelfData_BloodType:ComboBoxAddItem("O",4);


	--星座
	SelfData_Constellation:ComboBoxAddItem("-",0); 
	SelfData_Constellation:ComboBoxAddItem("魔羯座",1);
	SelfData_Constellation:ComboBoxAddItem("水瓶座",2); 
	SelfData_Constellation:ComboBoxAddItem("双鱼座",3); 
	SelfData_Constellation:ComboBoxAddItem("白羊座",4); 
	SelfData_Constellation:ComboBoxAddItem("金牛座",5); 
	SelfData_Constellation:ComboBoxAddItem("双子座",6); 
	SelfData_Constellation:ComboBoxAddItem("巨蟹座",7); 
	SelfData_Constellation:ComboBoxAddItem("狮子座",8); 
	SelfData_Constellation:ComboBoxAddItem("处女座",9); 
	SelfData_Constellation:ComboBoxAddItem("天秤座",10);
	SelfData_Constellation:ComboBoxAddItem("天蝎座",11);
	SelfData_Constellation:ComboBoxAddItem("射手座",12);
	
	CTRL[1] = SelfData_Age;
	CTRL[2] = SelfData_Sex;
	CTRL[3] = SelfData_Job;
	CTRL[4] = SelfData_School;
	CTRL[5] = SelfData_BloodType;
	CTRL[6] = SelfData_YearAnimal;
	CTRL[7] = SelfData_Constellation;
	CTRL[8] = SelfData_Province;
	CTRL[9] = SelfData_City;
	CTRL[10] = SelfData_EMail;
	CTRL[11] = SelfData_MessageBoard;
	
	SELFDATA_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"珍兽",
		"骑乘",
		"其他",
	};	
end


--===============================================
-- OnEvent()
--===============================================
function SelfData_OnEvent(event)
	if ( event == "OPEN_PRIVATE_INFO" ) then
		local LocArg = arg0;
		SelfData_SetTabColor(1);
		 
		if(LocArg ~= "self")     then
			return;
		end
		
		this:Show();
		objCared = SystemSetup:GetCaredObjId();
		this:CareObject(objCared, 1, "SelfData");

		SelfData_SelfEquip:SetCheck(0);
		SelfData_SelfData:SetCheck(1);
		SelfData_Pet:SetCheck(0);

		if(LocArg == "self")     then
			local selfUnionPos = Variable:GetVariable("SelfUnionPos");
			if(selfUnionPos ~= nil) then
				SelfData_Frame:SetProperty("UnifiedPosition", selfUnionPos);
			end
			
			g_Current_Page = SELF_PAGE;
			SelfData_UpdateFrame("self");
			for i=1 ,CTRL_NUM  do
				CTRL[i]:Enable();
			end
			SelfData_DataShareMode:Show();
			SelfData_Accept:Show();
			SelfData_DataShareMode_Text:Show()
			SelfData_Pet:Show();
		else
			local otherUnionPos = Variable:GetVariable("OtherUnionPos");
			if(otherUnionPos ~= nil) then
				SelfData_Frame:SetProperty("UnifiedPosition", otherUnionPos);
			end
		
			g_Current_Page = OTHER_PAGE;
			SelfData_UpdateFrame("other");
			for i=1 ,CTRL_NUM  do
				CTRL[i]:Disable();
			end
			SelfData_DataShareMode:Hide();
			SelfData_Accept:Hide();
			SelfData_DataShareMode_Text:Hide();
			SelfData_Pet:Hide();
			SelfData_Ride: Hide();
			SelfData_OtherInfo:Hide();
		end
		
	elseif (event == "OBJECT_CARED_EVENT") then
		AxTrace(0, 0, "arg0"..arg0.." arg1"..arg1.." arg2"..arg2);
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1=="destroy") then
			g_InitiativeClose = 1;
			this:Hide();

			--取消关心
			this:CareObject(objCared, 0, "SelfData");
		end
		
	end
end

--===============================================
-- UpdateFrame()
--===============================================
function SelfData_UpdateFrame(whose)
	
	--标题显示玩家的名字
	local szName = SystemSetup:GetPrivateInfo(whose,"name");
 	SelfData_PageHeader:SetText("#gFF0FA0"..szName);
	
	local nType = SystemSetup:GetPrivateInfo(whose,"type");	
	if nType == 0      then
		SelfData_Mode1:SetCheck(1);
		SelfData_Mode2:SetCheck(0);
		SelfData_Mode3:SetCheck(0);
		
	elseif nType == 1  then
		SelfData_Mode1:SetCheck(0);
		SelfData_Mode2:SetCheck(1);
		SelfData_Mode3:SetCheck(0);
		
	elseif nType == 2  then
		SelfData_Mode1:SetCheck(0);
		SelfData_Mode2:SetCheck(0);
		SelfData_Mode3:SetCheck(1);
		
	end
	
	local szGuid = SystemSetup:GetPrivateInfo(whose,"guid");
	SelfData_ID:SetText("ID:".. szGuid);
	
	local nAge = SystemSetup:GetPrivateInfo(whose,"age");
	SelfData_Age:SetText(tostring(nAge));
	AxTrace(0,0,"SelfData_Age =" .. nAge);
	
	local nSex = SystemSetup:GetPrivateInfo(whose,"sex");
--	AxTrace(0,0,"nSex =" .. nSex);
	SelfData_Sex:SetCurrentSelect(nSex);
	
	local szJob = SystemSetup:GetPrivateInfo(whose,"job");
	SelfData_Job:SetText(szJob);
	AxTrace(0,0,"SelfData_Job =" .. szJob);
	
	local szSchool = SystemSetup:GetPrivateInfo(whose,"school");
	SelfData_School:SetText(szSchool);
	
	local nBlood = SystemSetup:GetPrivateInfo(whose,"blood");
--	AxTrace(0,0,"nBlood =" .. nBlood);
	SelfData_BloodType:SetCurrentSelect(nBlood);
	
	local nAnimal = SystemSetup:GetPrivateInfo(whose,"animal");
--	AxTrace(0,0,"nAnimal =" .. nAnimal);
	SelfData_YearAnimal:SetCurrentSelect(nAnimal);
	
	local nConsella = SystemSetup:GetPrivateInfo(whose,"Consella");
--	AxTrace(0,0,"nConsella =" .. nConsella);
	SelfData_Constellation:SetCurrentSelect(nConsella);
	
	local nProvince = SystemSetup:GetPrivateInfo(whose,"Province");
--	AxTrace(0,0,"nProvince =" .. nProvince);
	SelfData_Province:SetCurrentSelect(nProvince);
		
	local szCity = SystemSetup:GetPrivateInfo(whose,"city");
	SelfData_City:SetText(szCity);
	AxTrace(0,0,"SelfData_City =" .. szCity);
	
	local szEmail = SystemSetup:GetPrivateInfo(whose,"email");
	SelfData_EMail:SetText(szEmail);
	AxTrace(0,0,"SelfData_EMail =" .. szEmail);

	local szLuck = SystemSetup:GetPrivateInfo(whose,"luck");
	SelfData_MessageBoard:SetText(szLuck);
	AxTrace(0,0,"SelfData_MessageBoard =" .. szLuck);

end

--===============================================
-- Accept()
--===============================================
function SelfData_Accept_Clicked()
	
	local nType;
	if SelfData_Mode1:GetCheck() == 1     	then
		nType = 0;
	elseif SelfData_Mode2:GetCheck() == 1   then
		nType = 1;
	elseif SelfData_Mode3:GetCheck() == 1   then
		nType = 2;
	end
	
	local bCanUse=1;
	
	bCanUse = SystemSetup:SetPrivateInfo("self", "type", 		nType);
	--SystemSetup:SetPrivateInfo("self", "guid", 		2);
	
	if(bCanUse == 0)  then
		return;
	end
	
	local nAge = SelfData_Age:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "age", 		nAge);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSex,nSex = SelfData_Sex:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "sex", 		nSex);
	if(bCanUse == 0)  then
		return;
	end
	
	local szJob = SelfData_Job:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "job", 		szJob);
	if(bCanUse == 0)  then
		return;
	end
	
	local szSchool = SelfData_School:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "school",	szSchool);
	if(bCanUse == 0)  then
		return;
	end
	
	local szBlood,nBlood = SelfData_BloodType:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "blood", 	nBlood);
	if(bCanUse == 0)  then
		return;
	end
	
	local szAnimal,nAnimal = SelfData_YearAnimal:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "animal",	nAnimal);
	if(bCanUse == 0)  then
		return;
	end
	
	local szConsella,nConsella = SelfData_Constellation:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Consella",nConsella);
	if(bCanUse == 0)  then
		return;
	end
	
	local szProvince,nProvince = SelfData_Province:GetCurrentSelect();
	bCanUse = SystemSetup:SetPrivateInfo("self", "Province",nProvince);
	if(bCanUse == 0)  then
		return;
	end
	
	local szCity = SelfData_City:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "city", 		szCity);
	if(bCanUse == 0)  then
		return;
	end
	
	local szEmail = SelfData_EMail:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "email", 	szEmail);
	if(bCanUse == 0)  then
		return;
	end
	
	local szLuck = SelfData_MessageBoard:GetText();
	bCanUse = SystemSetup:SetPrivateInfo("self", "luck", 		szLuck);
	if(bCanUse == 0)  then
		return;
	end
	
	--提交
	SystemSetup:ApplyPrivateInfo();
	
	this:Hide();
	--取消关心
	this:CareObject(objCared, 0, "SelfData");

end

--===============================================
-- 打开
--===============================================
function SelfData_SelfEquip_Down()
	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("self");
	else
		Variable:SetVariable("OtherUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenEquipFrame("other");
	end
			
	--取消关心
	this:CareObject(objCared, 0, "SelfData");
end

--===============================================
-- 打开
--===============================================
function SelfData_Pet_Down()

	if( g_Current_Page == SELF_PAGE )     then
		Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenPetFrame("self");
		--取消关心
		this:CareObject(objCared, 0, "SelfData");
		
	else
		Variable:SetVariable("OtherUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
		SystemSetup:OpenPetFrame("other");
	end
			
	
end

--===============================================
-- OnHiden
--===============================================
function SelfData_Frame_OnHiden()
	SelfData_Job:SetProperty("DefaultEditBox", "False");
	SelfData_School:SetProperty("DefaultEditBox", "False");
	SelfData_City:SetProperty("DefaultEditBox", "False");
	SelfData_EMail:SetProperty("DefaultEditBox", "False");
	
	SelfData_Age:SetProperty("DefaultEditBox", "False");
	SelfData_MessageBoard:SetProperty("DefaultEditBox", "False");
end

--===============================================
-- SetTabColor
--===============================================
function SelfData_SetTabColor(idx)
	if(idx == nil or idx < 0 or idx > 4) then
		return;
	end	
	
	--AxTrace(0,0,tostring(idx));
	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = SelfData_SelfEquip,
								SelfData_SelfData,
								SelfData_Pet,
								SelfData_Ride,
								SelfData_OtherInfo,
							};
	
	while i < 5 do
		if(i == idx) then
			tab[i]:SetText(selColor..SELFDATA_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..SELFDATA_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

function SelfData_Ride_Switch()
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
	OpenRidePage();
	SelfData_SelfEquip : SetCheck(0);
	SelfData_SelfData : SetCheck(1);
	SelfData_Pet : SetCheck(0);
	SelfData_Ride : SetCheck(0);
	SelfData_OtherInfo : SetCheck(0);
	SelfData_SetTabColor(1);
end

function SelfData_Other_Info_Page_Switch()
	Variable:SetVariable("SelfUnionPos", SelfData_Frame:GetProperty("UnifiedPosition"), 1);
	OtherInfoPage();
	SelfData_SelfEquip : SetCheck(0);
	SelfData_SelfData : SetCheck(1);
	SelfData_Pet : SetCheck(0);
	SelfData_Ride : SetCheck(0);
	SelfData_OtherInfo : SetCheck(0);
	SelfData_SetTabColor(1);
end

function Load_Blog_Infomation()
	local strCharName =  Player:GetName();
	local strAccount =  Player:GetData("ACCOUNTNAME")
	Blog:OpenBlogPage(strAccount,strCharName,true);
--	local Blog_Present = SystemSetup:LoadSelfBlog()

--	if Blog_Present > 0 then
--		SystemSetup:OpenSelfBlog()
--	end
end
