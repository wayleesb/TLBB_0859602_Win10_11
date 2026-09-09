local GEM_BUTTONS_FOUR = {};
local GEM_QUALITY_FOUR = {};
local GEM_EFFECT_FOUR = {};
local INVALID_ID =-1;
local objCared = -1;
local MAX_OBJ_DISTANCE = 3.0;
local LastBaoshi = -1;
local LastZhuangbei = -1;
local LastCharm = -1;            --最后一次镶嵌符
local LastOdds = -1;             --最后一次几率之珠
local SuccRate = 25;						 --镶嵌的成功率


local g_Object = -1;

local Enchase_Four_Cost = {}
local EquipGemTable = {}

x701614_GemEmbed_four_ID = {
														50113004,50213004,50313004,50413004,50513004,50613004,50713004,50813004,50913004,50113006,
														50213006,50313006,50413006,50513006,50613006,50713006,50813006,50913006
													}
																
function Enchase_Four_PreLoad()

	this:RegisterEvent("UI_COMMAND");
	this:RegisterEvent("OBJECT_CARED_EVENT");
	this:RegisterEvent("UPDATE_COMPOSE_GEM");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UNIT_MONEY");
	
	--this:RegisterEvent("DISABLE_ENCHASE_ALL_GEM");
	this:RegisterEvent("RESUME_ENCHASE_GEM");
	this:RegisterEvent("CLOSE_SYNTHESIZE_ENCHASE");
	this:RegisterEvent("MONEYJZ_CHANGE")		--交子普及 Vega

end

function Enchase_Four_OnLoad()
	GEM_BUTTONS_FOUR[1] = Enchase_Four_Item;
	GEM_BUTTONS_FOUR[2] = Enchase_Four_Gem1;
	GEM_BUTTONS_FOUR[3] = Enchase_Four_Gem2;
	GEM_BUTTONS_FOUR[4] = Enchase_Four_Gem3;
	GEM_QUALITY_FOUR[1] = -1;
	GEM_QUALITY_FOUR[2] = -1;
	GEM_QUALITY_FOUR[3] = -1;
	GEM_QUALITY_FOUR[4] = -1;
	GEM_EFFECT_FOUR[1] = Enchase_Four_Effect1;
	GEM_EFFECT_FOUR[2] = Enchase_Four_Effect2;
	GEM_EFFECT_FOUR[3] = Enchase_Four_Effect3;
	GEM_EFFECT_FOUR[4] = Enchase_Four_Effect4;
	
	Enchase_Four_Cost[1] = 5000
	Enchase_Four_Cost[2] = 6000
	Enchase_Four_Cost[3] = 7000
	Enchase_Four_Cost[4] = 8000
	Enchase_Four_Cost[5] = 9000
	Enchase_Four_Cost[6] = 10000
	Enchase_Four_Cost[7] = 11000
	Enchase_Four_Cost[8] = 12000
	Enchase_Four_Cost[9] = 13000
	
	EquipGemTable[0] = { 1, 2, 3, 4, 21 }
	EquipGemTable[1] = { 11, 12, 13, 14 }
	EquipGemTable[2] = { 11, 12, 13, 14 }
	EquipGemTable[3] = { 11, 12, 13, 14 }
	EquipGemTable[4] = { 11, 12, 13, 14 }
	EquipGemTable[5] = { 11, 12, 13, 14 }
	EquipGemTable[6] = { 1, 2, 3, 4, 21 }
	EquipGemTable[7] = { 1, 2, 3, 4, 11, 12, 13, 14, 21 }
	EquipGemTable[11] = { 1, 2, 3, 4, 21 }
	EquipGemTable[12] = { 1, 2, 3, 4, 21 }
	EquipGemTable[13] = { 1, 2, 3, 4, 21 }
	EquipGemTable[14] = { 1, 2, 3, 4, 21 }
	EquipGemTable[15] = { 11, 12, 13, 14 }
	EquipGemTable[17] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21 }

end

function Enchase_Four_Closed()
	LifeAbility : Enchase_CloseMsgBox();
end

function Enchase_Four_OnEvent(event)
	
	if (event == "OBJECT_CARED_EVENT" and this:IsVisible()) then
		if(tonumber(arg0) ~= objCared) then
			return;
		end
		
		--如果和NPC的距离大于一定距离或者被删除，自动关闭
		if(arg1 == "distance" and tonumber(arg2)>MAX_OBJ_DISTANCE or arg1=="destroy") then
			
			--取消关心
			Enchase_Four_Cancel_Clicked()
		end

	elseif ( event == "UI_COMMAND" and tonumber(arg0)== 751107 ) then

	
		this:Show();

		Enchase_Four_Effect1:Hide();
		Enchase_Four_Effect2:Hide();
		Enchase_Four_Effect3:Hide();

		objCared = -1;
		local xx = Get_XParam_INT(0);
		objCared = DataPool : GetNPCIDByServerID(xx);
		AxTrace(0,1,"xx="..xx .. " objCared="..objCared)
		if objCared == -1 then
				PushDebugMessage("server传过来的数据有问题。");
				return;
		end
		BeginCareObject_Enchase_Four(objCared)
		return

	elseif ( event == "UPDATE_COMPOSE_GEM" and this:IsVisible() ) then
		Enchase_Four_Update(arg0,arg1);
	elseif ( event == "PACKAGE_ITEM_CHANGED" and this:IsVisible() ) then
    --有任何东西改变都要重置
    LastZhuangbei = -1;
	  LastBaoshi = -1;
	  LastCharm = -1;
	  LastOdds = -1;
	
		if( arg0~= nil and -1 == tonumber(arg0)) then
			return;
		end
		
		
		if( arg0~= nil ) then
			local cancleMsgBox = 1;
			if (GEM_QUALITY_FOUR[1] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(25)
			elseif ( GEM_QUALITY_FOUR[2] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(26)
			elseif ( GEM_QUALITY_FOUR[3] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(27)
			elseif ( GEM_QUALITY_FOUR[4] == tonumber(arg0) ) then
				Enchase_Four_Resume_Gem(28)	
			else
				cancleMsgBox = 0;
			end
			if(cancleMsgBox == 1)then
				Enchase_Four_Closed();
			end
		end
	elseif ( event == "CLOSE_SYNTHESIZE_ENCHASE" ) then
		Enchase_Four_Close();
		return;
	--elseif ( event == "DISABLE_ENCHASE_ALL_GEM" ) then
		--DisableAllGem();
		--Enchase_Four_Closed();
		--return;
	elseif ( event == "RESUME_ENCHASE_GEM" ) then
		if arg0 ~= nil then
			Enchase_Four_Resume_Gem(tonumber(arg0));
			Enchase_Four_Closed();
		end
	elseif (event == "UNIT_MONEY" and this:IsVisible()) then
		Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	elseif (event == "MONEYJZ_CHANGE" and this:IsVisible()) then
		Enchase_Four_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));   --交子普及 Vega
	end

end

function Enchase_Four_OnShown()
	Enchase_Four_Clear();
	Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_Four_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));
end

function Enchase_Four_Clear()

	for i=1,4 do 
		if GEM_QUALITY_FOUR[i] ~= -1 then
			GEM_BUTTONS_FOUR[i]:SetActionItem(-1);
			LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[i],0);
			GEM_QUALITY_FOUR[i] = -1
		end
	end
	
	for i = 1,4 do
		GEM_EFFECT_FOUR[i] : Hide();
	end
	Enchase_Four_DemandMoney : SetProperty("MoneyNumber", 0);
	Enchase_Four_Explain : SetText("")
	Update_Four_Rate()
	
	LastZhuangbei = -1;
	LastBaoshi = -1;
	LastCharm = -1;
	LastOdds = -1;

end

function Enchase_Four_Update(UI_index,Item_index)
	local i_index = tonumber(Item_index)
	local u_index = tonumber(UI_index)
	local theAction = EnumAction(i_index, "packageitem");

	Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
	Enchase_Four_CurrentlyJiaozi:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY_JZ")));       --交子普及 Vega
	
	if theAction:GetID() ~= 0 then
						
			if u_index == 1 then
			
			
				local EquipPoint = LifeAbility : Get_Equip_Point(i_index)
				if EquipPoint == -1 or EquipPoint == 8 or EquipPoint == 9 or EquipPoint == 10 or EquipPoint == 16 then
					if EquipPoint ~= -1 then
						PushDebugMessage("不能放入这种装备。")
					end
					return
				end
				
				local hole_count = LifeAbility : GetEquip_HoleCount(i_index);
					
				if hole_count < 0 then
					return
				end
					
				if hole_count < 4 then
					PushDebugMessage("#{XQC_20080509_10}")
					return
				end
				
				local gem_count = LifeAbility : GetEquip_GemCount(i_index);

								
				if gem_count > 3 then
					PushDebugMessage("#{XQC_20080509_11}")
					return
				end
					
				if gem_count < 3 then
					PushDebugMessage("#{XQC_20080509_12}")
					return
				end
				
				local hole_count = LifeAbility : GetEquip_HoleCount(i_index);
					
				if hole_count < 0 then
					return
				end
					
				if hole_count < 4 then
					PushDebugMessage("#{XQC_20080509_10}")
					return
				end
					
				if GEM_QUALITY_FOUR[2] ~= -1 then
				
					local gem_count = LifeAbility : GetEquip_GemCount(i_index);
										
					local gem_level = LifeAbility : Get_Gem_Level(GEM_QUALITY_FOUR[2],1);
					local gem_type  = LifeAbility : Get_Gem_Level(GEM_QUALITY_FOUR[2],2);
					if gem_count < 0 then
						return
					end
					if gem_level <= 0 then
						Enchase_Four_Resume_Gem(26)
						return
					end
					if not EquipGemTable[EquipPoint] then
						PushDebugMessage("此装备无法镶嵌。")
						return
					end
				
					local passFlag = 0
					for i, gt in EquipGemTable[EquipPoint] do
						if gt == gem_type then
							passFlag = 1
							break
						end
					end
					
					if passFlag == 0 then
						PushDebugMessage("此种宝石不能镶嵌在这类装备上。")
						return
					end
								
					if gem_count == 4 then
						Enchase_Four_DemandMoney : SetProperty("MoneyNumber",0)
					else
						Enchase_Four_DemandMoney : SetProperty("MoneyNumber", Enchase_Four_Cost[gem_level]*(gem_count+1));
					end
								
				end
				
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
						
				
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index
				
				for i=1,4 do
					szIconName = LifeAbility : GetEquip_Gem(GEM_QUALITY_FOUR[1], i-1);
					if szIconName and szIconName ~= "" then
						GEM_EFFECT_FOUR[i] : SetProperty("ShortImage", szIconName);
						GEM_EFFECT_FOUR[i] : Show();
					else
						GEM_EFFECT_FOUR[i] : Hide();
					end
				end
				
			elseif u_index == 2 then
				local gem_level = LifeAbility : Get_Gem_Level(i_index,1);
				if gem_level <= 0 then
					return
				end
				local gem_type  = LifeAbility : Get_Gem_Level(i_index,2);
				local EquipPoint = LifeAbility : Get_Equip_Point(GEM_QUALITY_FOUR[1])
				if(tonumber(EquipPoint)== INVALID_ID) then
					PushDebugMessage("请先放入要镶嵌的装备！")
					Enchase_Four_Resume_Gem(25)
					return;
				end
				if not EquipGemTable[EquipPoint] then
					PushDebugMessage("此装备无法镶嵌。")
					Enchase_Four_Resume_Gem(25)
					return
				end
				
				local passFlag = 0
				for i, gt in EquipGemTable[EquipPoint] do
					if gt == gem_type then
						passFlag = 1
						break
					end
				end
					
				if passFlag == 0 then
					PushDebugMessage("此种宝石不能镶嵌在这类装备上。")
					return
				end
			
			 local fourgemid = PlayerPackage : GetItemTableIndex( i_index )
			 local IsRedGem = 0	
			 
			 for i, v in x701614_GemEmbed_four_ID do
		     if fourgemid == v then
			     IsRedGem = 1;
			     break
		     end
	     end
	    
	     if IsRedGem == 1 then
	    	PushDebugMessage("#{XQC_20080509_14}")
				return
	     end
	    
				if GEM_QUALITY_FOUR[1] ~= -1 then
					local gem_count = LifeAbility : GetEquip_GemCount( GEM_QUALITY_FOUR[1]);
					if gem_count < 0 then
						Enchase_Four_Resume_Gem(25)
						return
					end
					if gem_count == 4 then

						Enchase_Four_DemandMoney : SetProperty("MoneyNumber",0)
					else
						Enchase_Four_DemandMoney : SetProperty("MoneyNumber", Enchase_Four_Cost[gem_level]*(gem_count+1));
					end
				end
				
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index
			elseif u_index == 3 then
				if PlayerPackage : GetItemTableIndex( i_index ) == 30900009 then
					Enchase_Four_Explain : SetText("#cFF0000成功率:50%")
				elseif PlayerPackage : GetItemTableIndex( i_index ) == 30900010 then
					Enchase_Four_Explain : SetText("#cFF0000成功率:75%")
				else
					PushDebugMessage("这里必须放入#{_ITEM30900009}或者#{_ITEM30900010}。")
					return
				end
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index
			elseif u_index == 4 then
				if PlayerPackage : GetItemTableIndex( i_index ) ~= 30900011 then
					PushDebugMessage("这里必须放入#{_ITEM30900011}。")
					return
				end
				if GEM_QUALITY_FOUR[u_index] ~= -1 then
					LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);
				end
				GEM_BUTTONS_FOUR[u_index]:SetActionItem(theAction:GetID());
				LifeAbility : Lock_Packet_Item(i_index,1);
				GEM_QUALITY_FOUR[u_index] = i_index				
				
			end
	else
			if i_index == 1 then
				GEM_EFFECT_FOUR[i] : Hide();
			end
			GEM_BUTTONS_FOUR[u_index]:SetActionItem(-1);			
			LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[u_index],0);		
			GEM_QUALITY_FOUR[u_index] = -1;
	end
	Update_Four_Rate()
	Enchase_Four_Closed();
end

function Enchase_Four_Buttons_Clicked()
--local LastBaoshi = -1;
--local LastZhuangbei = -1;
	local Notify = 0;

	if(LastZhuangbei ~= GEM_QUALITY_FOUR[1] or LastBaoshi ~=	GEM_QUALITY_FOUR[2]
	    or LastCharm ~= GEM_QUALITY_FOUR[3] or LastOdds ~= GEM_QUALITY_FOUR[4]) then
	--装备 宝石 镶嵌符 几率之珠 变了
	  LastZhuangbei = GEM_QUALITY_FOUR[1];
	  LastBaoshi = GEM_QUALITY_FOUR[2];
	  LastCharm = GEM_QUALITY_FOUR[3];
	  LastOdds = GEM_QUALITY_FOUR[4];		
		Notify = 1;		
	end
	
	if(Notify == 1) then
	  local ZhuangbeiBind = 0
	  local BaoshiBind = 0
	  local CharmBind = 0
	  local OddsBind = 0
	  
	  if(GEM_QUALITY_FOUR[1] ~= -1) then
	    ZhuangbeiBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[1])
	  end
	  if(GEM_QUALITY_FOUR[2] ~= -1) then
	    BaoshiBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[2])
	  end
	  if(GEM_QUALITY_FOUR[3] ~= -1) then
	    CharmBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[3])
	  end
	  if(GEM_QUALITY_FOUR[4] ~= -1) then
	    OddsBind = Enchase_Four_IsBind(GEM_QUALITY_FOUR[4])
	  end
	  
		local equipTableIndex = PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[1] )
		-- 褚少微，2008.7.1。重楼戒、重楼玉的机制修改：1、可以打孔；2、可以镶嵌宝石，但只能镶嵌不绑定的宝石
		if(BaoshiBind == 1) then
	  	if(equipTableIndex == 10422016 or equipTableIndex == 10423024) then
	  		PushDebugMessage("这件装备不能镶嵌已经绑定的宝石。");
				return
	  	end
		end

		if(BaoshiBind == 1 or CharmBind == 1 or OddsBind ==1) then
		--如果 宝石 镶嵌符 几率之珠 任意一项是绑定的
			
			if(ZhuangbeiBind == 1) then
			--如果装备是绑定的
			
				ShowSystemInfo("GEM_ENCHASE_001");
					return;
			elseif(ZhuangbeiBind == 0) then
			--如果装备是不绑定的
			 		ShowSystemInfo("GEM_ENCHASE_002");
					return;
			end
			
		end
		
	end
		
	if GEM_QUALITY_FOUR[1] == -1 then
		PushDebugMessage("请放入要镶嵌宝石的装备。")
		return
	end
	
	if GEM_QUALITY_FOUR[2] == -1 then
		PushDebugMessage("请放入要镶嵌的宝石。")
		return
	end
	
	local Item_3=-1
	local Item_4=-1
	if GEM_QUALITY_FOUR[3] ~= -1 then 
		Item_3 = PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[3] )
	else
		PushDebugMessage("请放入宝石镶嵌符。")
		return
	end
	
	if GEM_QUALITY_FOUR[4] ~= -1 then 
	 Item_4 = PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[4] )
	end
	
	if (Item_3 ~= 30900009 and Item_3 ~= 30900010 ) or 
			(Item_4 ~= 30900011) then
			if SuccRate ~= 100 then
				LifeAbility:Enchase_Four_Confirm(GEM_QUALITY_FOUR[1],GEM_QUALITY_FOUR[2],GEM_QUALITY_FOUR[3],GEM_QUALITY_FOUR[4]);
				return
			end
	end
	LifeAbility : Do_Enchase_Four(GEM_QUALITY_FOUR[1],GEM_QUALITY_FOUR[2],GEM_QUALITY_FOUR[3],GEM_QUALITY_FOUR[4]);
	Enchase_Four_Close()
end

function Enchase_Four_Close()
	this:Hide()
end

function Enchase_Four_Cancel_Clicked()
	Enchase_Four_Close();
	return;
end

function Enchase_Four_OnHidden()
	StopCareObject_Enchase_Four(objCared)
	Enchase_Four_Clear()
	Enchase_Four_Closed()
	return
end
--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Enchase_Four(objCaredId)

	g_Object = objCaredId;
	AxTrace(0,0,"LUA___CareObject g_Object =" .. g_Object );
	this:CareObject(g_Object, 1, "Enchase_Four");

end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Enchase_Four(objCaredId)
	this:CareObject(objCaredId, 0, "Enchase_Four");
	g_Object = -1;

end

function Enchase_Four_Resume_Gem(nIndex)
	if nIndex < 25 or nIndex > 28 then
		return
	end

	nIndex = nIndex - 24
	if( this:IsVisible() ) then
		if GEM_QUALITY_FOUR[nIndex]~=nil and GEM_QUALITY_FOUR[nIndex] ~= -1 then
			GEM_BUTTONS_FOUR[nIndex]:SetActionItem(-1)			
			LifeAbility : Lock_Packet_Item(GEM_QUALITY_FOUR[nIndex],0);
			GEM_QUALITY_FOUR[nIndex] = -1
			if nIndex == 1 then
				for i = 1,4 do
					GEM_EFFECT_FOUR[i] : Hide();
				end
				Enchase_Four_DemandMoney : SetProperty("MoneyNumber", 0);
			elseif nIndex == 2 then
				Enchase_Four_DemandMoney : SetProperty("MoneyNumber", 0);
			end
		end
	end
	Update_Four_Rate()
end

function Update_Four_Rate()
	Enchase_Four_Explain : SetText("#cFF0000成功率:25%")
	SuccRate = 25;
	if GEM_QUALITY_FOUR[3] ~= -1 then
		if PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[3] ) == 30900009 then
			Enchase_Four_Explain : SetText("#cFF0000成功率:50%")
			SuccRate = 50;
		elseif PlayerPackage : GetItemTableIndex( GEM_QUALITY_FOUR[3] ) == 30900010 then
			Enchase_Four_Explain : SetText("#cFF0000成功率:100%")
			SuccRate = 100;
		end
	end
	Enchase_Four_CurrentlyMoney:SetProperty("MoneyNumber", tostring(Player:GetData("MONEY")));
end

function Enchase_Four_IsBind( ItemID )

	if(GetItemBindStatus(ItemID) == 1) then
		
		return 1;
		
	else
	
		return 0;
		
	end
	
end