local xx = nil;
function Denaturalization_PreLoad()
	this:RegisterEvent("UI_COMMAND");
	
	this:RegisterEvent("UNIT_DEF_COLD");				--防御属性
	this:RegisterEvent("UNIT_DEF_FIRE");
	this:RegisterEvent("UNIT_DEF_LIGHT");
	this:RegisterEvent("UNIT_DEF_POSION");

	this:RegisterEvent("UNIT_RESISTOTHER_COLD");			--减抗属性
	this:RegisterEvent("UNIT_RESISTOTHER_FIRE");
	this:RegisterEvent("UNIT_RESISTOTHER_LIGHT");
	this:RegisterEvent("UNIT_RESISTOTHER_POSION");
		
	this:RegisterEvent("UNIT_ATT_COLD");				--攻击属性
	this:RegisterEvent("UNIT_ATT_FIRE");
	this:RegisterEvent("UNIT_ATT_LIGHT");
	this:RegisterEvent("UNIT_ATT_POSION");
end

function Denaturalization_OnLoad()
	Denaturalization_CleanData();
end

function Denaturalization_OnEvent(event)
	if ( event == "UI_COMMAND" ) then
		if(tonumber(arg0) == 0147000) then
			Denaturalization_OnShow();
			this : Show();
			xx =  Get_XParam_INT(0)
			objCared = DataPool : GetNPCIDByServerID(xx);
			this:CareObject(objCared, 1, "Denaturalization");
			
		elseif (tonumber(arg0) == 0147005) then
			DoDenaturalization()
		end
		
	elseif(event == "UNIT_DEF_COLD" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_DEF_FIRE" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_DEF_LIGHT" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_DEF_POSION" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_COLD" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_FIRE" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_LIGHT" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	elseif(event == "UNIT_RESISTOTHER_POSION" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
		
	--冰攻击
	elseif(event == "UNIT_ATT_COLD" and arg0 == "player") then
		Denaturalization_SetStateTooltip();	
	--火攻击
	elseif(event == "UNIT_ATT_FIRE" and arg0 == "player") then
		Denaturalization_SetStateTooltip();
	--电攻击
	elseif(event == "UNIT_ATT_LIGHT" and arg0 == "player") then
		Denaturalization_SetStateTooltip();
	--毒攻击
	elseif(event == "UNIT_ATT_POSION" and arg0 == "player") then
		Denaturalization_SetStateTooltip();
		
	end
end

---------------------------------------------------------------------------------
--
-- 设置状态tooltip
--
function Denaturalization_SetStateTooltip()

	-- 得到状态属性
	local iIceDefine  		= Player:GetData( "DEFENCECOLD" );
	local iFireDefine 		= Player:GetData( "DEFENCEFIRE" );
	local iThunderDefine	= Player:GetData( "DEFENCELIGHT" );
	local iPoisonDefine		= Player:GetData( "DEFENCEPOISON" );
	
	local iIceAttack  		= Player:GetData( "ATTACKCOLD" );
	local iFireAttack 		= Player:GetData( "ATTACKFIRE" );
	local iThunderAttack	= Player:GetData( "ATTACKLIGHT" );
	local iPoisonAttack		= Player:GetData( "ATTACKPOISON" );
	
	local iIceResistOther	= Player:GetData( "RESISTOTHERCOLD" );
	local iFireResistOther= Player:GetData( "RESISTOTHERFIRE" );
	local iThunderResistOther	= Player:GetData( "RESISTOTHERLIGHT" );
	local iPoisonResistOther= Player:GetData( "RESISTOTHERPOISON" );
	
	Denaturalization_IceFastness:SetToolTip("冰攻:"..tostring(iIceAttack).."#r冰抗:"..tostring(iIceDefine).."#r减冰抗:"..tostring(iIceResistOther) );
	Denaturalization_FireFastness:SetToolTip("火攻:"..tostring(iFireAttack).."#r火抗:"..tostring(iFireDefine).."#r减火抗:"..tostring(iFireResistOther) );
	Denaturalization_ThunderFastness:SetToolTip("玄攻:"..tostring(iThunderAttack).."#r玄抗:"..tostring(iThunderDefine).."#r减玄抗:"..tostring(iThunderResistOther) );
	Denaturalization_PoisonFastness:SetToolTip("毒攻:"..tostring(iPoisonAttack).."#r毒抗:"..tostring(iPoisonDefine).."#r减毒抗:"..tostring(iPoisonResistOther) );
		
end

---------------------------------------------------------------------------------
--清空数据
--
function Denaturalization_CleanData()
	Denaturalization_FakeObject:SetFakeObject("");	

	Denaturalization_IceFastness:SetToolTip("");
	Denaturalization_FireFastness:SetToolTip("" );
	Denaturalization_ThunderFastness:SetToolTip("");
	Denaturalization_PoisonFastness:SetToolTip("");
end

---------------------------------------------------------------------------------
--OnShow
--
function Denaturalization_OnShow()
	Player : CreateDenaObj();
	Denaturalization_FakeObject:SetFakeObject("Denaturalization_MySelf");	
	
	Denaturalization_SetStateTooltip();

	local nNumber = Player:GetData( "LEVEL" );
	Denaturalization_Level : SetText(nNumber.."级")
end

----------------------------------------------------------------------------------
--
-- 选装玩家模型（向左)
--
function Denaturalization_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Denaturalization_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		Denaturalization_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- 选装玩家模型（向右)
--
function Denaturalization_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		Denaturalization_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		Denaturalization_FakeObject:RotateEnd();
	end
end

function Denaturalization_Cancel_Click()
	this : Hide();
end

function DoDenaturalization()
	if(this : IsVisible()) then
		PushDebugMessage("操作异常！");
		this:Hide();
		return;
	end
	

	local isCan = Player : CheckIfCanDena(30900048);
	if(isCan == -1) then
		PushDebugMessage("操作异常！");
		return;
	end
	
	--弹出确认框
	
	
	if(isCan == 5)then
		PushDebugMessage("您缺少物品转性丹，或者您的转性丹已加锁。")
		return;
	end
	if(isCan == 1)then
		PushDebugMessage("骑乘状态下不能进行转性操作！")
		return;
	end
	if(isCan == 2)then
		PushDebugMessage("摆摊状态下不能进行转性操作！")
		return;
	end
	if(isCan == 3)then
		PushDebugMessage("试穿，试骑状态下不能进行转性操作！")
		return;
	end

	if(isCan == 4)then
		PushDebugMessage("组队状态下不能进行转性操作！")
		return;
	end
	--取得变性数据
	local sex,hairColor,hairModle,faceModle,nFaceId = Player : GetDenaAttr();
	--调函数去也
	Clear_XSCRIPT();
		Set_XSCRIPT_Function_Name("OnZhuanXingConfirm");
		Set_XSCRIPT_ScriptID(0147);
		Set_XSCRIPT_Parameter(0,tonumber(xx));
		Set_XSCRIPT_Parameter(1,tonumber(sex));
		Set_XSCRIPT_Parameter(2,tonumber(hairColor));
		Set_XSCRIPT_Parameter(3,tonumber(hairModle));
		Set_XSCRIPT_Parameter(4,tonumber(faceModle));
		Set_XSCRIPT_Parameter(5,tonumber(nFaceId));
		Set_XSCRIPT_ParamCount(6);
	Send_XSCRIPT();
end

function Denaturalization_OK_Click()
	--请求确认界面
	Clear_XSCRIPT();
		Set_XSCRIPT_ScriptID(0147);
		Set_XSCRIPT_Function_Name("OnZhuanXingRequest");
		Set_XSCRIPT_Parameter(0,tonumber(xx));
		Set_XSCRIPT_ParamCount(1);
	Send_XSCRIPT();
	--保存变性数据
	Player : SaveDenaAttr();
	this:Hide();
end

function Denaturalization_OnHide()
	Denaturalization_CleanData();
end