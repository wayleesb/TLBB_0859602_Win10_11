local g_Facestyle_Icon = {}
local MAX_OBJ_DISTANCE = 3.0;
local g_nCurPage = 0
local g_nCurSelect = 0
local g_Style_Index = {}
local g_Style_Count = 0
local g_Original_Style = 0


--==================================
-- SelectFacestyle_PreLoad
--==================================
function SelectFacestyle_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");	
end

--==================================
-- SelectFacestyle_OnLoad
--==================================
function SelectFacestyle_OnLoad()
	g_Facestyle_Icon[1]		= SelectFacestyle_Skill1_BKG
	g_Facestyle_Icon[2] 	= SelectFacestyle_Skill2_BKG
	g_Facestyle_Icon[3] 	= SelectFacestyle_Skill3_BKG
	g_Facestyle_Icon[4] 	= SelectFacestyle_Skill4_BKG
	g_Facestyle_Icon[5] 	= SelectFacestyle_Skill5_BKG
	g_Facestyle_Icon[6] 	= SelectFacestyle_Skill6_BKG
	g_Facestyle_Icon[7] 	= SelectFacestyle_Skill7_BKG
	g_Facestyle_Icon[8] 	= SelectFacestyle_Skill8_BKG
	g_Facestyle_Icon[9] 	= SelectFacestyle_Skill9_BKG
	g_Facestyle_Icon[10]	= SelectFacestyle_Skill10_BKG
	g_Facestyle_Icon[11]	= SelectFacestyle_Skill11_BKG
	g_Facestyle_Icon[12]	= SelectFacestyle_Skill12_BKG
	
	for i=1, 12  do
		g_Style_Index[i] = -1
	end	

end

--==================================
-- SelectFacestyle_OnEvent
--==================================
function SelectFacestyle_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 928) then
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end

		if(IsWindowShow("SelectHairstyle")) then
			CloseWindow("SelectHairstyle", true);
		end

		if(IsWindowShow("SelectHairColor")) then
			CloseWindow("SelectHairColor", true);
		end
		
		if(this:IsVisible() and tonumber(g_Original_Style)) then
			DataPool : Change_MyFaceStyle(g_Original_Style);
		end
		SelectFacestyle_OnShown()
		BeginCareObject_SelectFacestyle(objCared)

	elseif (event == "OBJECT_CARED_EVENT") then
		if(not this:IsVisible() ) then
			return;
		end
		if(tonumber(arg0) ~= objCared) then
			Close_Facestyle()
			return;
		end
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Close_Facestyle()
		end
	end
	if event == "SEX_CHANGED" and  this:IsVisible() then
			SelectFacestyle_Model : Hide();
			SelectFacestyle_Model : Show();
			SelectFacestyle_Model:SetFakeObject("Player_Head");
	end

end

--==================================
-- SelectFacestyle_OnShown
--==================================
function SelectFacestyle_OnShown()
	for i,eachstyle in g_Facestyle_Icon do
		eachstyle : SetPushed(0)
	end
	
	g_Original_Style = DataPool : Get_MyFaceStyle();

	SelectFacestyle_Update();
	this:Show();
end

--==================================
-- SelectFacestyle_Update
--==================================
function SelectFacestyle_Update()

	local i,RaceID,ItemID,ItemCount,SelectType,k,IconFile;
	k = 1;
	Current = 1
	local m = 1
	
	for i,eachstyle in g_Facestyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end
	
	for i=0, 200 do
		ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyFaceStyle_Item(i);
		
		if(ItemID ~= -1) then
			IconFile = GetIconFullName(IconFile)
			g_Facestyle_Icon[m]:SetProperty("NormalImage",IconFile)
			g_Facestyle_Icon[m]:SetProperty("HoverImage",IconFile)
			g_Facestyle_Icon[m]:SetToolTip(StyleName)
			g_Style_Index[m] = i
			m = m + 1
		end
	end
	g_Style_Count = m-1
	
	if(g_Style_Count <= 0) then
		SelectFacestyle_Require:SetText("没有可更改的脸型。");
		SelectFacestyle_CurrentlyPage:SetText("1/1");
		SelectFacestyle_Model : SetFakeObject( "" );
		SelectFacestyle_Model : SetFakeObject( "Player_Head" );
		SelectFacestyle_PageUp : Disable();
		SelectFacestyle_PageDown : Disable();
		SelectFacestyle_Accept : Disable();
		return;
	end
	
	SelectFacestyle_Model : SetFakeObject( "Player_Head" )

	g_nCurSelect = 0;
	SelectFacestyle_WarningText : SetText("请在画面右上方选择脸型，然后点击“确定”");
end

--==================================
-- Player_Head_Modle_TurnLeft
--==================================
function SelectFacestyle_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(-0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
-- Player_Head_Modle_TurnRight
--==================================
function SelectFacestyle_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		if(start == 1) then
			SelectFacestyle_Model:RotateBegin(0.3);
		else
			SelectFacestyle_Model:RotateEnd();
		end
	end
end

--==================================
-- Close_Facestyle
--==================================
function Close_Facestyle()
	g_HaveChange = 0;
	SelectFacestyle_Model : SetFakeObject( "" );
	StopCareObject_SelectFacestyle(objCared)
	this:Hide();	
end

--==================================
--开始关心NPC，
--==================================
function BeginCareObject_SelectFacestyle(objCaredId)
	g_Object = objCaredId;
	this:CareObject(g_Object, 1, "SelectFacestyle");
end

--==================================
--停止对某NPC的关心
--==================================
function StopCareObject_SelectFacestyle(objCaredId)
	this:CareObject(objCaredId, 0, "SelectFacestyle");
	g_Object = -1;

end

--==================================
--关闭
--==================================
function SelectFacestyle_Cancel_Clicked()
	DataPool : Change_MyFaceStyle(g_Original_Style);
	Close_Facestyle()
end

--==================================
--确认
--==================================
function SelectFacestyle_OK_Clicked()
	-- 没有选择脸型
	if(g_nCurSelect == 0 )then
		PushDebugMessage("请选定一款脸型。");
		return;
	end

	local ItemID
	local ItemCount
	local SelectType
	local IconFile
	local CostMoney
	
	-- 得到选择的脸型信息
	ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyFaceStyle_Item(g_Style_Index[g_nCurSelect]);

	-- 检查道具
	if(ItemID ~= -1 and SelectType >= 2) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemID) < ItemCount) then
			PushDebugMessage("缺少所需的定颜珠");
			return;
		end
	end
	
	-- 得到玩家的金币和交子数目
	local nMoney = Player:GetData("MONEY")
	local nMoneyJZ = Player:GetData("MONEY_JZ")
	
	if (nMoney + nMoneyJZ) < CostMoney then
		PushDebugMessage("金钱不足");
		return
	end
	
	-- 调试信息，当前选择的脸型ID
	--PushDebugMessage ("StyleId = "..g_Style_Index[g_nCurSelect])
	-- 如果选择的脸型和当前脸型不同
	if g_Style_Index[g_nCurSelect] ~= g_Original_Style then

		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(805029);
			Set_XSCRIPT_Parameter(0,g_Style_Index[g_nCurSelect]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_Facestyle();
		
	else

		PushDebugMessage("请选择一种和你当前不同的脸型。");

	end
	
end

--==================================
--选中一个图标
--==================================
function SelectFacestyle_Clicked(nIndex)
	
	if nIndex > g_Style_Count  then
		return
	end
	if(g_nCurSelect > 0 )then
		g_Facestyle_Icon[g_nCurSelect]:SetPushed(0);
	end
	g_nCurSelect = nIndex
	g_Facestyle_Icon[g_nCurSelect]:SetPushed(1);

	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyFaceStyle_Item(g_Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);

	SelectFacestyle_WarningText : SetText("需要道具：#G"..name.."#r#W需要金钱：#Y#{_EXCHG"..CostMoney.."}#W#r请在画面右上方选择脸型，然后点击“确定”。");
	DataPool : Change_MyFaceStyle(g_Style_Index[nIndex])
	g_HaveChange = 1

end

