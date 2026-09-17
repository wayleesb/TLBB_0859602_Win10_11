local g_petNum = 0;
local g_CurSel = -1;
local g_Icon = "";

local Max_BtnNum = 10;
local PetNames = {
	"成年珍兽",
	"珍兽宝宝",
	"1级变异",
	"2级变异",
	"3级变异",
	"4级变异",
	"5级变异",
	"6级变异",
	"7级变异",
	"8级变异",
};
function PetJian_PreLoad()
	this:RegisterEvent("OPEN_PETJIAN_DLG");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
end

function PetJian_OnLoad()
end

function PetJian_OnEvent(event)
	if ( event == "OPEN_PETJIAN_DLG" ) then
		PetJian_Init()
		this:Show();
	end
	if ( event == "PLAYER_LEAVE_WORLD" ) then
		this:Hide();
		g_petNum = 0;
		g_CurSel = -1;
		g_Icon = "";
	end
end

function PetJian_Init()
	PetJian_List : ClearListBox();
	g_petNum = DataPool:GetPetsOneTypeNum();
	g_CurSel = -1;
	if(Max_BtnNum <  g_petNum) then
		g_petNum = Max_BtnNum;
	end
	--------------------------------------------------
	--Buttons
	for i = 1 , g_petNum do
		PetJian_List : AddItem(PetNames[i], i-1);
	end
	--默认选中最后一个
	PetJian_List : SetItemSelectByItemID(g_petNum - 1);
	PetJian_SelectOneType(g_petNum);
end

function PetJian_Onshow()
	---------------------------------------------------------
	--DisableSomeThing
	PetJian_FakeObject : SetFakeObject( "" );
	PetJianFood_Type   : Hide();
	PetJianAttack_Type : Hide();
	PetJian_NeedLevel  : Hide();
	PetJian_Model_TurnLeft : Disable();
	PetJian_Model_TurnRight: Disable();

	if(g_CurSel < 0 or g_petNum <= 0)then
		return;
	end
	PetJian_FakeObject : SetFakeObject( "" );
	DataPool : PetsOneType_SetModel(g_CurSel);
	---------------------------------------------------------------------
	-- fake obj
	PetJian_FakeObject : SetFakeObject("PetOneType_Pet");
	PetJian_Model_TurnLeft : Enable();
	PetJian_Model_TurnRight: Enable();
	PetJian_NeedLevel      : Show();
	---------------------------------------------------
	--get TakeLevel
	local nTakeLevel = DataPool : PetsOneType_GetAttr(g_CurSel,"takelevel");
	local strNeedLevelColor = "";
	if( nTakeLevel > Player:GetData( "LEVEL" ) )then
		strNeedLevelColor ="#cFF0000";
	else
		strNeedLevelColor ="#c00FF00";
	end
	local strNeedLevel = strNeedLevelColor..tostring( nTakeLevel ).."级#W可携带";
	PetJian_NeedLevel:SetText( strNeedLevel );
	-----------------------------------------------------
	--get AttackTrait (暂缺)
	strName,strIcon = DataPool : PetsOneType_GetAttr(g_CurSel,"attacktype");
	if strIcon ~= "" then
		PetJianAttack_Type : SetProperty( "Image", "set:Button6 image:"..strIcon )
		PetJianAttack_Type : SetToolTip(strName)
		PetJianAttack_Type : Show();
	end
	-----------------------------------------------------
	--get FoodType 
	local food = DataPool : PetsOneType_GetAttr(g_CurSel,"food");
	strName = "";
	if(food >= 1000) then
		strName = strName .. "肉";
		food = food - 1000;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 100) then
		strName = strName .. "草";
		food = food - 100;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	if(food >= 10) then
		strName = strName .. "虫";
		food = food - 10;
		if food > 0 then
			strName = strName .. ",";
		end
	end
	
	if(food >= 1) then
		strName = strName .. "谷";
	end
	PetJianFood_Type : Show();
	PetJianFood_Type : SetToolTip( strName );
end

function PetJian_SelectOneType(typeIdx)
	if(g_CurSel + 1 == typeIdx or typeIdx < 1 or typeIdx > g_petNum) then
		return;
	end
	g_CurSel = typeIdx - 1;
	PetJian_Onshow();
end

function PetJian_List_Click()
	local typeIdx =  PetJian_List : GetFirstSelectItem();
	PetJian_SelectOneType(typeIdx + 1);
end

----------------------------------------------------------------------------------
--
-- 旋转珍兽模型（向左)
--
function PetJian_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		PetJian_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
--旋转珍兽模型（向右)
--
function PetJian_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		PetJian_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		PetJian_FakeObject:RotateEnd();
	end
end

function PetJian_OnHiden()
	-- do nothing
end