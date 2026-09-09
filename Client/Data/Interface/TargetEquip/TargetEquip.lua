-- 数据池中定义的装备数据.
--HEQUIP_WEAPON		=0,		//武器	WEAPON
--HEQUIP_CAP			=1,		//帽子	DEFENCE
--HEQUIP_ARMOR		=2,		//衣服	DEFENCE
--HEQUIP_CUFF			=3,		//手套	DEFENCE
--HEQUIP_BOOT			=4,		//鞋	DEFENCE
--HEQUIP_SASH			=5,		//腰带	ADORN
--HEQUIP_RING			=6,		//戒子	ADORN
--HEQUIP_NECKLACE	=7,		//项链	ADORN
--HEQUIP_DARK		=8,		//骑乘----已修改为暗器by houzhifang
--HEQUIP_BAG			=9,		//行囊                            护符
--HEQUIP_BOX			=10,	//箱格
--HEQUIP_RING_2		=11,	//第二个戒指	ADORN
--HEQUIP_CHARM		=12,	//护符	            ADORN
--HEQUIP_CHARM_2		=13,	//第二个护符	    ADORN
--HEQUIP_WRIST		=14,	//护腕	DEFENCE
--HEQUIP_SHOULDER		=15,	//护肩	DEFENCE
--HEQUIP_DRESS		=16,	//时装


--------------------------------------------------------------------------------
-- 装备按钮数据定义
--
local  g_WEAPON;		--武器
local  g_ARMOR;			--衣服
local  g_CAP;			--帽子
local  g_CUFF;			--护腕
local  g_BOOT;			--鞋
local  g_RING;			--戒子
local  g_SASH;			--腰带
local  g_NECKLACE;		--项链
local  g_Dark;			--坐骑---已修改为暗器
local  g_Charm;			-- 护符
local  g_Charm2;		-- 护符2
local  g_Shoulder;		-- 护肩
local  g_Glove;			-- 手套
local  g_Ring2;			-- 戒指2
local  g_FashionDress;	-- 时装

local g_Cur_Name = "";
local g_objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;

local TARGETEQUIP_TAB_TEXT = {};

function TargetEquip_PreLoad()

	-- 打开界面
	this:RegisterEvent("MAINTARGET_CHANGED");
	this:RegisterEvent("OTHERPLAYER_UPDATE_EQUIP");
	this:RegisterEvent("PLAYER_LEAVE_WORLD");
	this:RegisterEvent("CLOSE_TARGET_EQUIP");
	this:RegisterEvent("OBJECT_CARED_EVENT");

end

function TargetEquip_OnLoad()

	-- action buttion 按钮
	g_WEAPON		= TargetEquip_Equip11;		--武器
	g_ARMOR			= TargetEquip_Equip12;		--衣服
	g_CAP			= TargetEquip_Equip1;		--帽子
	g_CUFF			= TargetEquip_Equip8;		--护腕
	g_BOOT			= TargetEquip_Equip4;		--鞋
	g_RING			= TargetEquip_Equip6;		--戒子
	g_SASH			= TargetEquip_Equip7;		--腰带
	g_NECKLACE		= TargetEquip_Equip13;		--项链
	g_Dark			= TargetEquip_Equip14;		--坐骑
	g_Charm			= TargetEquip_Equip9;		-- 护符
	g_Charm2		= TargetEquip_Equip10;		-- 护符2
	g_Shoulder		= TargetEquip_Equip3;		-- 护肩
	g_Glove			= TargetEquip_Equip2;		-- 手套
	g_Ring2			= TargetEquip_Equip5;		-- 戒指2
	g_FashionDress	= TargetEquip_Equip15;		-- 时装

	TARGETEQUIP_TAB_TEXT = {
		[0] = "装备",
		"资料",
		"博客",
		"珍兽",
		"骑乘",
	};
end
function TargetEquip_SetTabColor(idx)

	local i = 0;
	local selColor = "#e010101#Y";
	local noselColor = "#e010101";
	local tab = {
								[0] = TargetEquip_SelfEquip,
								TargetEquip_TargetData,								
								TargetEquip_Blog,
								TargetEquip_Pet,
								TargetEquip_Ride,
							};
	
	while i < 5 do
		if(i == idx) then
			tab[i]:SetText(selColor..TARGETEQUIP_TAB_TEXT[i]);
		else
			tab[i]:SetText(noselColor..TARGETEQUIP_TAB_TEXT[i]);
		end
		i = i + 1;
	end
end

-- OnEvent
function TargetEquip_OnEvent(event)

	if ( event == "MAINTARGET_CHANGED" and tonumber(arg0) == -1) then

		return;
	end

	if( "PLAYER_LEAVE_WORLD" == event) then
		this : Hide();
		return;
	end

	-- 装备变化时刷新装备.
	if("OTHERPLAYER_UPDATE_EQUIP" == event) then

		if (not CachedTarget:IsPresent(1)) then
			return;
		end

		if (not CachedTarget:CanGetTargetEquip()) then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end
		
		g_objCared = CachedTarget:GetData("NPCID", 1)
		if (type(g_objCared) ~="number") then
			PushDebugMessage ("#{JSCK_90507_1}")				-- 距离该玩家太远，无法查看资料。
			return
		end

		local otherUnionPos = Variable:GetVariable("OtherUnionPos");
		if(otherUnionPos ~= nil) then
			TargetEquip_Frame:SetProperty("UnifiedPosition", otherUnionPos);
		end
		TargetEquip_SetTabColor(0);
		TargetEquip_SelfEquip:SetCheck(1);
		TargetEquip_TargetData:SetCheck(0);

		TargetEquip_FakeObject:SetFakeObject("");
		CachedTarget:TargetEquip_ChangeModel();
		TargetEquip_FakeObject:SetFakeObject("Target");

		-- 开始关心OBJ
		TargetEquip_BeginCareObject(g_objCared);
		TargetEquip_OnUpdateShow();
		TargetEquip_RefreshEquip();

		this:Show();
		return;
	end

	if( "CLOSE_TARGET_EQUIP" == event ) then

		TargetEquip_CloseUI();
		return;
	elseif (event == "OBJECT_CARED_EVENT") then
		if(tonumber(arg0) ~= g_objCared) then
			return;
		end

		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if( arg1=="destroy") then
			TargetEquip_CloseUI();
			return;
		end

	end

end

-- 更新主角基本信息
function TargetEquip_OnUpdateShow()

	local nNumber = 0;
	local nMaxnumber = 0;
	local strName = "";

	-- 得到名字
  strName = CachedTarget:GetData("NAME", 1);
  g_Cur_Name = strName;
  TargetEquip_PageHeader:SetText("#gFF0FA0" .. strName );

	-- 得到称号
	strName = CachedTarget:GetData("TITLE", 1)
	TargetEquip_Agname:SetText( ""..strName );
	
	-- 得到帮派
	strName = CachedTarget:GetData("GUILD", 1)
	TargetEquip_Confraternity:SetText( ""..strName );
	
	-- 得到等级
	nNumber = CachedTarget:GetData("LEVEL", 1);
	TargetEquip_Level:SetText("等级:" .. tostring( nNumber ));

	-- 得到配偶信息
	local szConsort = SystemSetup:GetPrivateInfo("other","Consort");
	TargetEquip_Spouse:SetText(szConsort);

	-- 门派
	local menpai = CachedTarget:GetData("MEMPAI",1);
	local strMenpai = "";

	-- 得到门派名称.
	if(0 == menpai) then
		strMenpai = "少林";

	elseif(1 == menpai) then
		strMenpai = "明教";

	elseif(2 == menpai) then
		strMenpai = "丐帮";

	elseif(3 == menpai) then
		strMenpai = "武当";

	elseif(4 == menpai) then
		strMenpai = "峨嵋";

	elseif(5 == menpai) then
		strMenpai = "星宿";

	elseif(6 == menpai) then
		strMenpai = "天龙";

	elseif(7 == menpai) then
		strMenpai = "天山";

	elseif(8 == menpai) then
		strMenpai = "逍遥";

	elseif(9 == menpai) then
		strMenpai = "无门派";
	end

	-- 设置显示的门派.
	TargetEquip_MenPai:SetText("门派:" .. strMenpai);

	-- 个人说明
	local szLuck = SystemSetup:GetPrivateInfo("other","luck");
	TargetEquip_Message:SetText(szLuck);

end

-- 刷新装备
function TargetEquip_RefreshEquip()

	--  清空按钮显示图标
	g_WEAPON:SetActionItem(-1);			--武器
	g_CAP:SetActionItem(-1);				--帽子
	g_ARMOR:SetActionItem(-1);			--盔甲
	g_CUFF:SetActionItem(-1);				--护腕
	g_BOOT:SetActionItem(-1);				--鞋
	g_SASH:SetActionItem(-1);				--腰带
	g_RING:SetActionItem(-1);				--戒子
	g_NECKLACE:SetActionItem(-1);		--项链
	g_Dark:SetActionItem(-1);				--坐骑
	g_Charm:SetActionItem(-1);			-- 护符
	g_Charm2:SetActionItem(-1);			-- 护符2
	g_Shoulder:SetActionItem(-1);		-- 护肩
	g_Glove:SetActionItem(-1);			-- 手套
	g_Ring2:SetActionItem(-1);			-- 戒指2
	g_FashionDress:SetActionItem(-1);		-- 时装

	local ActionWeapon 		= EnumAction(0, "targetequip");
	local ActionCap    		= EnumAction(1, "targetequip");
	local ActionArmor  		= EnumAction(2, "targetequip");
	local ActionGlove		= EnumAction(3, "targetequip");
	local ActionBoot   		= EnumAction(4, "targetequip");
	local ActionSash   		= EnumAction(5, "targetequip");
	local ActionRing    	= EnumAction(6, "targetequip");
	local ActionNecklace	= EnumAction(7, "targetequip");
	local ActionDark		= EnumAction(17, "targetequip");    --修改为暗器  by houzhifang
	local ActionRing2		= EnumAction(11, "targetequip");
	local ActionCharm		= EnumAction(12, "targetequip");
	local ActionCharm2		= EnumAction(13, "targetequip");
	local ActionCuff  		= EnumAction(14, "targetequip");
	local ActionShoulder	= EnumAction(15, "targetequip");
	local ActionDress		= EnumAction(16, "targetequip");

	-- 显示人身上的武器装备
	g_WEAPON:SetActionItem(ActionWeapon:GetID());			--武器
	g_CAP:SetActionItem(ActionCap:GetID());						--帽子
	g_ARMOR:SetActionItem(ActionArmor:GetID());				--盔甲
	g_CUFF:SetActionItem(ActionCuff:GetID());					--护腕
	g_BOOT:SetActionItem(ActionBoot:GetID());					--鞋
	g_SASH:SetActionItem(ActionSash:GetID());					--腰带
	g_RING:SetActionItem(ActionRing:GetID());					--戒子
	g_NECKLACE:SetActionItem(ActionNecklace:GetID());	--项链
	g_Dark:SetActionItem(ActionDark:GetID());					--坐骑
	g_Charm:SetActionItem(ActionCharm:GetID());				-- 护符
	g_Charm2:SetActionItem(ActionCharm2:GetID());			-- 护符2
	g_Shoulder:SetActionItem(ActionShoulder:GetID());	-- 护肩
	g_Glove:SetActionItem(ActionGlove:GetID());				-- 手套
	g_Ring2:SetActionItem(ActionRing2:GetID());				-- 戒指2
	g_FashionDress:SetActionItem(ActionDress:GetID());-- 时装

end

----------------------------------------------------------------------------------
--
-- 旋转玩家模型（向左)
--
function TargetEquip_Modle_TurnLeft(start)
	--向左旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(-0.3);
	--向左旋转结束
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------
--
-- 旋转玩家模型（向右)
--
function TargetEquip_Modle_TurnRight(start)
	--向右旋转开始
	if(start == 1 and CEArg:GetValue("MouseButton")=="LeftButton") then
		TargetEquip_FakeObject:RotateBegin(0.3);
	--向右旋转结束
	else
		TargetEquip_FakeObject:RotateEnd();
	end
end

----------------------------------------------------------------------------------------
--
-- 关闭界面
--

function TargetEquip_CloseUI()

	this:Hide();

	-- 取消关心OBJ
	TargetEquip_StopCareObject(g_objCared);
	
	-- 清空FakeModel窗口
	TargetEquip_FakeObject:SetFakeObject("");
	CachedTarget:TargetEquip_DestroyUIModel();
	
	-- 清空角色信息和装备图标
	TargetEquip_ClearPlayerInfo();
	TargetEquip_ClearEquipItem();

end

----------------------------------------------------------------------------------------
--
-- 清空装备界面中的角色信息
--
function TargetEquip_ClearPlayerInfo()
	
	TargetEquip_PageHeader:SetText("");
	TargetEquip_Agname:SetText("");
	TargetEquip_Confraternity:SetText("");
	TargetEquip_Level:SetText("等级:");	
	TargetEquip_Spouse:SetText("");
	TargetEquip_MenPai:SetText("门派:");
	TargetEquip_Message:SetText("");

end

----------------------------------------------------------------------------------------
--
--  清空装备界面中的装备图标
--
function TargetEquip_ClearEquipItem()

	--  清空按钮显示图标
	g_WEAPON:SetActionItem(-1);			--武器
	g_CAP:SetActionItem(-1);				--帽子
	g_ARMOR:SetActionItem(-1);			--盔甲
	g_CUFF:SetActionItem(-1);				--护腕
	g_BOOT:SetActionItem(-1);				--鞋
	g_SASH:SetActionItem(-1);				--腰带
	g_RING:SetActionItem(-1);				--戒子
	g_NECKLACE:SetActionItem(-1);		--项链
	g_Dark:SetActionItem(-1);			--坐骑
	g_Charm:SetActionItem(-1);		-- 护符
	g_Charm2:SetActionItem(-1);		-- 护符2
	g_Shoulder:SetActionItem(-1);		-- 护肩
	g_Glove:SetActionItem(-1);		-- 手套
	g_Ring2:SetActionItem(-1);		-- 戒指2
	g_FashionDress:SetActionItem(-1);		-- 时装

end

----------------------------------------------------------------------------------------
--
-- 打开玩家信息界面
--
-- 资料
--
function TargetEquip_TargetData_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPrivatePage("other")
end
--
-- 博客
--
function TargetEquip_TargetBlog_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);

	local strCharName =  CachedTarget:GetData("NAME");
	local strAccount =  CachedTarget:GetData("ACCOUNTNAME")
	Blog:OpenBlogPage(strAccount,strCharName,false);
end
--
-- 珍兽
--
function TargetEquip_OtherPet_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenPetFrame("other");
end
--
-- 骑乘
--
function TargetEquip_OtherRide_Down()
	Variable:SetVariable("OtherUnionPos", TargetEquip_Frame:GetProperty("UnifiedPosition"), 1);
	SystemSetup:OpenRidePage("other");
end

----------------------------------------------------------------------------------------
--
-- “私聊”按钮的响应函数
--
function Set_To_Private()

	CachedTarget:Set_To_Private(g_Cur_Name);

end

----------------------------------------------------------------------------------------
--
-- “加为好友”按钮的响应函数
--
function Set_To_Friend()

	DataPool:AddFriend( Friend:GetCurrentTeam(),g_Cur_Name );
	
end

--=========================================================
--开始关心OBJ
--在开始关心之前需要先确定这个界面是不是已经有“关心”的OBJ，
--如果有的话，先取消已经有的“关心”
--=========================================================
function TargetEquip_BeginCareObject(objCaredId)

	if (type(objCaredId) == "number") then
		g_objCared = objCaredId;
		this:CareObject(g_objCared, 1, "TargetEquip");
	else
		return;
	end

end

--=========================================================
--停止对某OBJ的关心
--=========================================================
function TargetEquip_StopCareObject(objCaredId)
	
	if (type(objCaredId) == "number") then
		this:CareObject(objCaredId, 0, "TargetEquip");
		g_objCared = -1;		
	else
		return;
	end

end