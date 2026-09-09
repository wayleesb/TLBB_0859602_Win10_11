local Style_Index = {};
local Current = 0;
local Max_Style = 1;
local Original_Style = 0;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local g_Object = -1;
local g_HaveChange = 0;
local HairStyle_Icon = {}
local HairStyle_Frame = {}
local Current_Page = 0
local STYLE_BUTTON = 12
function SelectHairstyle_PreLoad()
	this:RegisterEvent("UI_COMMAND");	
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("SEX_CHANGED");	
end

function SelectHairstyle_OnLoad()
	HairStyle_Icon[1] = SelectHairstyle_Skill1_BKG
	HairStyle_Icon[2] = SelectHairstyle_Skill2_BKG
	HairStyle_Icon[3] = SelectHairstyle_Skill3_BKG
	HairStyle_Icon[4] = SelectHairstyle_Skill4_BKG
	HairStyle_Icon[5] = SelectHairstyle_Skill5_BKG
	HairStyle_Icon[6] = SelectHairstyle_Skill6_BKG
	HairStyle_Icon[7] = SelectHairstyle_Skill7_BKG
	HairStyle_Icon[8] = SelectHairstyle_Skill8_BKG
	HairStyle_Icon[9] = SelectHairstyle_Skill9_BKG
	HairStyle_Icon[10] = SelectHairstyle_Skill10_BKG
	HairStyle_Icon[11] = SelectHairstyle_Skill11_BKG
	HairStyle_Icon[12] = SelectHairstyle_Skill12_BKG
	
end

function SelectHairstyle_OnEvent(event)
	if ( event == "UI_COMMAND" and tonumber(arg0) == 21) then

			local xx = Get_XParam_INT(0);
			objCared = DataPool : GetNPCIDByServerID(xx);
			AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
			if objCared == -1 then
					PushDebugMessage("server传过来的数据有问题。");
					return;
			end

			if(IsWindowShow("SelectHairColor")) then
				CloseWindow("SelectHairColor", true);
			end
			
			if(IsWindowShow("SelectFacestyle")) then
				CloseWindow("SelectFacestyle", true);
			end
			
			if(this:IsVisible() and tonumber(Original_Style)) then
				DataPool : Change_MyHairStyle(Original_Style);
			end
			BeginCareObject_SelectHairstyle(objCared)
			SelectHairstyle_OnShown();
	elseif (event == "OBJECT_CARED_EVENT") then

		if(not this:IsVisible() ) then
			return;
		end
	
		if(tonumber(arg0) ~= objCared) then
			Close_HairStyle()
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			SelectHairstyle_Cancel_Clicked()
		end
	end

	if event == "SEX_CHANGED" and  this:IsVisible() then
			SelectHairstyle_Model : Hide();
			SelectHairstyle_Model : Show();
			SelectHairstyle_Model:SetFakeObject("Player_Head");
	end
end


function SelectHairstyle_OnShown()
	for i,eachstyle in HairStyle_Icon do
		eachstyle : SetPushed(0)
	end
	Original_Style = DataPool : Get_MyHairStyle();
--	AxTrace(0,1,"Original_Style="..Original_Style)
	SelectHairstyle_Update();
	this:Show();
end

function SelectHairstyle_Update()
	local i,RaceID,ItemID,ItemCount,SelectType,k,IconFile;
	k = 1;
	Current = 1
	
	for i,eachstyle in HairStyle_Icon do
		eachstyle : SetPushed(0)
		eachstyle : SetProperty("NormalImage","")
		eachstyle : SetProperty("HoverImage","")
		eachstyle : SetToolTip("")
	end
	
	for i=0, 200 do
		ItemID,ItemCount,SelectType,IconFile,CostMoney,StyleName = DataPool : Change_MyHairStyle_Item(i);
		
		if(ItemID ~= -1 and SelectType >= 2) then
--			if( DataPool:GetPlayerMission_ItemCountNow(ItemID) >= ItemCount) then
--				AxTrace(0,1,"ItemID="..ItemID.." i="..i);
			if k > STYLE_BUTTON * (Current_Page) and k <= STYLE_BUTTON * (Current_Page+1) then
				local m = k - STYLE_BUTTON * (Current_Page);
				Style_Index[m] = i;
				IconFile = GetIconFullName(IconFile)
				HairStyle_Icon[m]:SetProperty("NormalImage",IconFile)
				HairStyle_Icon[m]:SetProperty("HoverImage",IconFile)
--				HairStyle_Icon[m]:SetProperty("PushedImage",IconFile)
				HairStyle_Icon[m]:SetToolTip(StyleName)
				
				if Original_Style == i then
--					Max_Style = k + 1
					SelectHairstyle_Clicked(m)
				end
			end
			Max_Style = k
			k = k+1;
--				if k > STYLE_BUTTON then
--					break
--				end
--			end
		end
	end
	


	if(Max_Style <= 0) then
		SelectHairstyle_Require:SetText("没有可更改的发型。");
		SelectHairstyle_CurrentlyPage:SetText("1/1");
		SelectHairstyle_Model : SetFakeObject( "" );
		SelectHairstyle_Model : SetFakeObject( "Player_Head" );
		SelectHairstyle_PageUp : Disable();
		SelectHairstyle_PageDown : Disable();
		SelectHairstyle_Accept : Disable();
		return;
	end
	SelectHairstyle_Require: SetText("");
	ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("需要"..name.." : "..ItemCount.."#r需要金钱: #{_EXCHG"..CostMoney.."}#r请在画面左上方选择发型，然后点击“确定”。");

	SelectHairstyle_Model : SetFakeObject( "Player_Head" );
	if Max_Style > STYLE_BUTTON then
		SelectHairstyle_PageUp : Enable();
		SelectHairstyle_PageDown : Enable();
	else
		SelectHairstyle_PageUp : Disable();
		SelectHairstyle_PageDown : Disable();
	end
	
	if Current_Page == 0 then
		SelectHairstyle_PageUp : Disable();
	else
		SelectHairstyle_PageUp : Enable();
	end
	
	if (Current_Page+1)*STYLE_BUTTON <= Max_Style then
		SelectHairstyle_PageDown : Enable();
	else
		SelectHairstyle_PageDown : Disable();
	end
	
	SelectHairstyle_Accept : Enable();
	SelectHairstyle_Clicked(Current)
end


function SelectHairstyle_Add_Clicked()

	if(Current >= Max_Style) then
		Current = 1;
	else
		Current = Current + 1;
	end
	
	local ItemID,ItemCount,SelectType,IconFile,CostMoney  = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("需要"..name.." : "..ItemCount.."#r需要金钱: #{_EXCHG"..CostMoney.."}#r请在画面左上方选择发型，然后点击“确定”。");
	SelectHairstyle_CurrentlyPage : SetText(Current .."/".. Max_Style);
	DataPool : Change_MyHairStyle(Style_Index[Current]);
	g_HaveChange = 1;
end

function SelectHairstyle_Minus_Clicked()
	if(Current <= 1) then
		Current = Max_Style;
	else
		Current = Current - 1;
	end
	
	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("需要"..name.." : "..ItemCount.."#r需要金钱: #{_EXCHG"..CostMoney.."}#r请在画面左上方选择发型，然后点击“确定”。");
	SelectHairstyle_CurrentlyPage : SetText(Current .."/".. Max_Style);
	DataPool : Change_MyHairStyle(Style_Index[Current]);
	g_HaveChange = 1;
end

--==================================
--确认
--==================================
function SelectHairstyle_OK_Clicked()

	-- 得到选择的发型信息
	ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[Current]);

	-- 得到选择的发型信息
	if(ItemID ~= -1 and SelectType >= 2) then
		if( DataPool:GetPlayerMission_ItemCountNow(ItemID) < ItemCount) then
			PushDebugMessage("缺少所需的发型图");
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
	
	-- 调试信息，当前选择的发型ID
	--PushDebugMessage ("StyleId = "..Style_Index[Current])
	-- 如果选择的发型和当前发型不同
	if Style_Index[Current] ~= Original_Style then
		
		Clear_XSCRIPT();
			Set_XSCRIPT_Function_Name("FinishAdjust");
			Set_XSCRIPT_ScriptID(801010);
			Set_XSCRIPT_Parameter(0,Style_Index[Current]);
			Set_XSCRIPT_ParamCount(1);
		Send_XSCRIPT();
		Close_HairStyle();

	else
		PushDebugMessage("请选择一种和你当前不同的发型。");
	end
	
end

function SelectHairstyle_Cancel_Clicked()

	DataPool : Change_MyHairStyle(Original_Style);
	Close_HairStyle()
end

----------------------------------------------------------------------------------
--
-- 旋转人物头像模型（向左)
--
function Player_Head_Modle_TurnLeft(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向左旋转开始
		if(start == 1) then
			SelectHairstyle_Model:RotateBegin(-0.3);
		--向左旋转结束
		else
			SelectHairstyle_Model:RotateEnd();
		end
	end
end

----------------------------------------------------------------------------------
--
--旋转人物头像模型（向右)
--
function Player_Head_Modle_TurnRight(start)
	local mouse_button = CEArg:GetValue("MouseButton");
	if(mouse_button == "LeftButton") then
		--向右旋转开始
		if(start == 1) then
			SelectHairstyle_Model:RotateBegin(0.3);
		--向右旋转结束
		else
			SelectHairstyle_Model:RotateEnd();
		end
	end
end

function Close_HairStyle()
	g_HaveChange = 0;
	SelectHairstyle_Model : SetFakeObject( "" );
	StopCareObject_SelectHairstyle(objCared)
	this:Hide();
		
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_SelectHairstyle(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "SelectHairstyle");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_SelectHairstyle(objCaredId)
	this:CareObject(objCaredId, 0, "SelectHairstyle");
	g_Object = -1;

end

function SelectHairstyle_Clicked(nIndex)

	if( nIndex < 0 or nIndex + STYLE_BUTTON * (Current_Page) > Max_Style ) then
		return
	end

	HairStyle_Icon[Current] : SetPushed(0);
	Current = nIndex
	HairStyle_Icon[Current] : SetPushed(1);

	local ItemID,ItemCount,SelectType,IconFile,CostMoney = DataPool : Change_MyHairStyle_Item(Style_Index[nIndex]);
	local name,icon = LifeAbility : GetPrescr_Material(ItemID);
	
	SelectHairstyle_WarningText : SetText("需要"..name.." : "..ItemCount.."#r需要金钱: #{_EXCHG"..CostMoney.."}#r请在画面左上方选择发型，然后点击“确定”。");

	DataPool : Change_MyHairStyle(Style_Index[nIndex]);
	g_HaveChange = 1;
end

function SelectHairstyle_Page(nPage)
	
	Current_Page = Current_Page + nPage;

	SelectHairstyle_Update();

end
