-- 任务跟踪   author：houzhifang

local g_strWndName = "MissionTrack";

local g_dlgctrls = {}; --控件集合
local MissionPucker = {};
local g_nNowCheck = 0;   --0:初始化，1:已接任务，2：可接任务
local g_LockState = 0;   --0:未锁定，1：已锁定
local LEVEL_TO_MY_LEVEL = 10000;
local g_Temp_Mylevel = 1;

local g_DiFu_Scene_Id = 77; --地府场景ID 
--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理,需要特殊处理的任务脚本号列表：
local SpecialMissionList = {200006,200031}

-- 沿用主参考 QuestLog 的等级排序，避免依赖其他窗口的加载顺序。
local function CompareTable(table_a, table_b)
	return table_a[4] < table_b[4];
end

function MissionTrack_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("OPEN_MISSION_TRACK");
	this:RegisterEvent("UPDATE_MISSION_TRACK");
	this:RegisterEvent("UPDATE_WILLGET_MISSION_TRACK");

	this:RegisterEvent("TRACK_ALPHA_ACTION");
	this:RegisterEvent("UNIT_LEVEL"); --玩家升级的时候更新可接列表
end

function MissionTrack_OnLoad()
	local i=1;
	for i=1,200 do
		MissionPucker[i] = 1;
	end;
	MissionTrack_Lock:Show();
	MissionTrack_UnLock:Hide();
	MissionTrack_ShowORHideFunc(0);
end

function MissionTrack_OnEvent(event)
	if(event == "OPEN_WINDOW") then
		if( arg0 == "MissionTrack") then
			this:Show();
			MissionTrack_ShowORHideFunc(0);
			MissionTrack_UpdateHaveGetMission(-1);
			DataPool:UpdateTrackStateButton(0);
		end
	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "MissionTrack") then
			this:Hide();
		end	
	elseif (event == "PACKAGE_ITEM_CHANGED") then
		if not this:IsVisible() then
			return;
		end
		if (g_nNowCheck == 1) then
			MissionTrack_UpdateHaveGetMission(-1);
		end
	elseif (event == "OPEN_MISSION_TRACK") then
		--local nMissionTrackShow = DataPool:IsTrackFuncShow(1);
		--if (nMissionTrackShow > 0) then
		--	AxTrace(0, 0, "11111111111111111");
			local nType = tonumber(arg0);
			if (nType == 1) then
				this:Show();
				MissionTrack_ShowORHideFunc(0);
				MissionTrack_UpdateHaveGetMission(-1);
				DataPool:UpdateTrackStateButton(0);
			end
		--end
	elseif (event == "UPDATE_MISSION_TRACK") then
		if not this:IsVisible() then
			return;
		end
		if (g_nNowCheck == 1) then
			local nSelect = tonumber(arg0)
			MissionTrack_UpdateHaveGetMission(nSelect);
		end
	elseif (event == "UPDATE_WILLGET_MISSION_TRACK" or event == "UNIT_LEVEL") then	
		if not this:IsVisible() then
			return;
		end
		if (g_nNowCheck == 2) then
			MissionTrack_UpdateWillGet();
		end
	elseif (event == "TRACK_ALPHA_ACTION") then	
		MissionTrack_SetAlpha(arg0)
	end
end

function MissionTrack_UpdateHaveGetMission(nSelectMissionID)
	local i = 1;
	local nMyLevel = Player:GetData( "LEVEL" );
	local nNowFirstItem;
	nNowFirstItem = MissionTrack_ListBoxTransparent:GetCurrentFirstItem();
		
	MissionTrack_HaveGet:SetCheck(1);
	MissionTrack_WillGet:SetCheck(0);
	g_nNowCheck = 1;
	
	MissionTrack_ListBoxTransparent:ClearListBoxEx();
	
	local nMissionNum = 20
	local color;
	
	for i=1,nMissionNum do
		if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
			DataPool:GetPlayerMission_Description(i-1);
		end
	end;
	
	local k = 0;
	local Sequence_OnefoldGenre = {}
	local Sequence_Assemble = {}
	local Constitutes = {};
	local MissionTitles = {};
	
	for j=1, 200 do
		local bHave = 0;
		for i=1, nMissionNum do
			if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
				local MissionKind = DataPool:GetPlayerMission_Kind(i-1);
				if(MissionKind == j) then
				local nThisKindHaveMission = DataPool:HaveMisstionTrackThisType(MissionKind);
					if (nThisKindHaveMission == 1 ) then
						--AxTrace(0,0,"j = ".. j .. " i-1 ="..(i-1));
	
						if ( MissionPucker[j] > 0 ) then 
							local strInfo = DataPool:GetPlayerMission_Memo(i-1);
							local nMissionLevel = DataPool:GetPlayerMission_Level(i-1);
						
							if nMissionLevel == LEVEL_TO_MY_LEVEL then
								nMissionLevel =  Player:GetData( "LEVEL" );
								if (nMissionLevel > 0) then   --进入擂台后得到是0，只是显示问题，不想改服务器逻辑，所以用这么一种很弱智的方法
									g_Temp_Mylevel = nMissionLevel;
								else
									nMissionLevel = g_Temp_Mylevel;
								end
							end
						
							if(bHave == 0) then
								local str= "#cff9900" .. DataPool:GetMissionInfo_Kind(j);   --title
								Constitutes = {str,100+j,"",0}
								table.insert(MissionTitles, str);
								table.insert(Sequence_OnefoldGenre,Constitutes)
								bHave = 1;
							end
	--------------------------------------------------
							local strOKFail = "";
							local nFinished = 0;
						--显示任务是否已完成或已失败
							local Mission_Variable = DataPool:GetPlayerMission_Variable(i-1,0);
							--TT53675对于所有没有用missionparam第0位表示任务是否完成的任务，使用IsMissionSuccess判断任务是否完成
                      		local IsSpecial = 0
	                 		local nScriptId = DataPool:GetPlayerMission_Display(i-1,7)
	                 		for i, findId in SpecialMissionList do
		                  		if nScriptId == findId then
			                     	IsSpecial = 1
			                    	break
		                      end
	                  		end
	                  		if nScriptId >= 1020000 and nScriptId <= 1029999 then --所有的探索配表任务都需要特殊处理
	   	                  		IsSpecial = 1
	                  		end
	                   	if IsSpecial == 1 then
		                    	Mission_Variable = IsMissionSuccess(i-1)
		               	end
							if(Mission_Variable >0) then
								if(Mission_Variable == 1) then
									strOKFail = "完成";
									nFinished = 1
								elseif(Mission_Variable == 2) then
									strOKFail = "失败";
								end
							end

							color = "FFF8A10A";	--橙色
							local nChange, strMissionName = DataPool:GetMissionShortName(strInfo);--string.sub(strInfo, -6);
							if (nChange > 0) then
								strMissionName = strMissionName .. "...";
							end
							if (nFinished == 1) then   --已完成
								Constitutes = {"  #Y(" .. nMissionLevel ..") " .. strMissionName .. " #G" .. strOKFail,i-1,color,nMissionLevel,nFinished};
							else
								Constitutes = {"  #Y(" .. nMissionLevel ..") " .. strMissionName .. " " .. strOKFail,i-1,color,nMissionLevel,nFinished};
							end
							table.insert(Sequence_OnefoldGenre,Constitutes)
						else
							if(bHave == 0) then
								local str= "#gFE7E82" .. DataPool:GetMissionInfo_Kind(j);
								Constitutes = {str,100+j,"",0}
								table.insert(Sequence_OnefoldGenre,Constitutes)
								table.insert(MissionTitles, str);
								bHave = 1;
							end
						end
						k=k+1;
					end
				end
			end
		end
		----
		table.sort(Sequence_OnefoldGenre,CompareTable)
		
		for i,n in ipairs(Sequence_OnefoldGenre) do 
			table.insert(Sequence_Assemble,n) 
		end
		Sequence_OnefoldGenre = {};
		----
	end
	local Per_Segment,xxxx,i,j;
	for i,Per_Segment in ipairs(Sequence_Assemble) do
		local nMissionTrackType = DataPool:GetPlayerMissionTrackType(Per_Segment[2]);		
		if (Per_Segment[3] ~= "" and nMissionTrackType > 0) then
			local nIsMissionTrackOpen = DataPool:IsMissionTrackOpen(Per_Segment[2]);
			if (nIsMissionTrackOpen > 0) then
				MissionTrack_ListBoxTransparent:AddItemExWithoutLayout(Per_Segment[1],Per_Segment[2], 3, Per_Segment[3],4)
				MissionTrack_AddMissionTrackInfo(Per_Segment[2], nMissionTrackType, Per_Segment[5]);
			end
		elseif (tonumber(Per_Segment[4]) == 0) then		
				MissionTrack_ListBoxTransparent:AddItemExWithoutLayout(Per_Segment[1],Per_Segment[2], 0);
		end
	end
	MissionTrack_ListBoxTransparent:RequestLayout();
	
	if (nSelectMissionID ~= -1) then
		local itemNum = MissionTrack_ListBoxTransparent:GetItemNumByMissionId(nSelectMissionID);
		if( itemNum ~= -1) then
			MissionTrack_ListBoxTransparent:SetCurrentFirstItem(itemNum);
		else
			MissionTrack_ListBoxTransparent:SetCurrentFirstItem(nNowFirstItem);
		end
		MissionTrack_ListBoxTransparent:SetItemSelectByItemID(nSelectMissionID);
	else
		MissionTrack_ListBoxTransparent:SetCurrentFirstItem(nNowFirstItem);
	end

	--QuestLog_Amount : SetText( k .. "/" .. nMissionNum);
---
	--QuestLog_ListBox_SelectChanged();
	
	--if Current_Clicked ~= -1 then
	--	--QuestLog_Listbox : EnsureItemIsVisable(Current_Clicked);
	--	QuestLog_Listbox : SetCurrentFirstItem(Current_Clicked);
	--	Current_Clicked = -1
	--end
end

function MissionTrack_AddMissionTrackInfo(nMissionIndex, nMissionTrackType, nFinished)
	local nNewIndex = nMissionIndex+200;
	local color = "FFCCCCCC";
	local MissionParam_Index = 0;
	local strTarget = "";
	
	local strFinishNPC, strFinishSceneName, nFinishSceneID, nFinishX, nFinishY = DataPool:GetMissionFinishInfo(nMissionIndex);
	--PushDebugMessage(strFinishNPC);
	--PushDebugMessage(nFinished);
	if (nFinished == 1 and strFinishNPC ~= "") then       --已完成的任务
		--if (strFinishNPC ~= "") then
			--local strTemp = string.format("   #W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}#W", strFinishSceneName, strFinishNPC, nFinishX, nFinishY, nFinishSceneID, strFinishNPC);
			local strTemp = "";
			local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex,7)--czf modify,2009.08.26
			if nIndex == 1018870 then
				strTemp = string.format("   #W去#G%s#W找#R%s#W", strFinishSceneName, strFinishNPC);
			else
				strTemp = string.format("   #W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strFinishSceneName, strFinishNPC, nFinishX, nFinishY, nFinishSceneID, strFinishNPC);
			end
			strTarget = strTemp;
		--end
	else    --未完成的任务
		--local nRound = DataPool:GetPlayerMission_Display(nMissionIndex,3);
		--if( nRound >= 0 ) then
		--	Mission_Variable = DataPool:GetPlayerMission_DataRound(nRound);
		--	if(Mission_Variable >= 0) then
		--		strTarget = "任务当前环数：#W"..tostring(Mission_Variable);
		--	end
		--end	
			--显示任务银票数量
		--if( DataPool:GetPlayerMission_Display(nMissionIndex,4) > 0 ) then
		--	Mission_Variable = DataPool:GetPlayerMission_Variable(nMissionIndex,MissionParam_Index);
		--	MissionParam_Index = MissionParam_Index + 1;
			
		--	if(Mission_Variable >0) then
		--		silverdesc = DataPool:GetPlayerMission_BillName(nMissionIndex);
		--		strTarget = "需要得到金钱：#W"..tostring(Mission_Variable);
		--	end
		--end	
		
		local strAppend = "";
		local Mission_Variable = 0;
		--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理  
		local IsSpecial = 0
	    local nScriptId1 = DataPool:GetPlayerMission_Display(nMissionIndex,7)
	    for i, findId in SpecialMissionList do
		    if nScriptId1 == findId then
			     IsSpecial = 1
			     break
		    end
	   end
	   if nScriptId1>=1020000 and nScriptId1<=1029999 then --所有的探索配表任务都需要特殊处理
	   	    IsSpecial = 1
	   end
	   if IsSpecial==0 then
		    MissionParam_Index = MissionParam_Index + 1;
		end
		--任务需要杀的npc
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nMissionIndex);
		if( nDemandKillNum > 0 ) then
			strAppend = "   #W已杀死：";
			for i=1, nDemandKillNum do
				--    需要的NPC，需要NPC ID，需要多少个
				local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nMissionIndex);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nMissionIndex,MissionParam_Index,Kill_Random_Type,i-1);
				MissionParam_Index = MissionParam_Index + 1;
				if (i == 1 and nDemandKillNum > 1) then
					strAppend = strAppend.."#W"..nNPCName.."："..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
				elseif (i == 1 and nDemandKillNum == 1) then
					strAppend = strAppend.."#W"..nNPCName.."："..tostring(Mission_Variable).."/"..tostring(nNum);
				elseif( i == nDemandKillNum) then
					strAppend = strAppend.."#W            "..nNPCName.."："..tostring(Mission_Variable).."/"..tostring(nNum);
				else
					strAppend = strAppend.."#W            "..nNPCName.."："..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
				end
				nNewIndex = nNewIndex + 1;
			end
		end	
		
	--任务需要的物品
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nMissionIndex);
		if( nDemandNum > 0 ) then
			if(Item_Random_Type == -100) then
				strAppend = "   #W已提交：";
				nNewIndex = nNewIndex + 1;
				Item_Random_Type = 0
			else
				strAppend = "   #W已得到：";
				nNewIndex = nNewIndex + 1;
			end
		end	
	
		for i=1, nDemandNum do
			--    需要的类型，需要物品ID，需要多少个
			local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nMissionIndex);
			Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
			
			if Mission_Variable > nNum then
				Mission_Variable = nNum
			end
			

			local Mission_Variable2 = DataPool:GetPlayerMission_Variable(nMissionIndex,0);
			if Mission_Variable2 > 0 then
				Mission_Variable = nNum
			end

			if (i == 1 and nDemandNum > 1) then
				strAppend = strAppend.."#W"..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
			elseif(i == 1 and nDemandNum == 1) then
				strAppend = strAppend.."#W"..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum);
			elseif(i == nDemandNum) then
				strAppend = strAppend.."#W            "..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum);
			else
				strAppend = strAppend.."#W            "..szName..":"..tostring(Mission_Variable).."/"..tostring(nNum).."#r";
			end
		end
		
		--任务自定义的物品
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nMissionIndex);
		for i=1, nCustomNum do
			--    需要的NPC，需要NPC ID，需要多少个
			local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
			Mission_Variable = DataPool:GetPlayerMission_Variable(nMissionIndex,MissionParam_Index);
			AxTrace(0, 0, strCustom..tostring(Mission_Variable));
			MissionParam_Index = MissionParam_Index + 1;
			
			local strDot = "";
			if (i < nCustomNum) then
				strDot = "#r";
			end
			
			if nNum == 0 then
				strAppend = strAppend.."   " .. strCustom..strDot;
			else
				strAppend = strAppend.."   " .. strCustom .. " ： ".. Mission_Variable .. "/" .. nNum..strDot;
				
			end
		end	
		
		--任务自定义的随机物品 zz添加
		local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nMissionIndex);
		for i=1,nRandomCustomNum do
			local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nMissionIndex);
			
			local strDot = "";
			if (i < nCustomNum) then
				strDot = "#r";
			end
			
			if nNeedNum == 0 then
				strAppend = strAppend..strCustom..strDot;
			else
				strAppend = strAppend..strCustom .. " ： ".. nCompleteNum .. "/" .. nNeedNum..strDot;
			end
		end
		
		
		local strTemp = "";
		strTarget = "";
		if (nMissionTrackType == 1) then   --脚本任务，直接读取任务跟踪信息
			strTarget = DataPool:GetLuaMissionTrackInfo(nMissionIndex);
			if (strAppend ~= "") then
				strTarget = "   #W" .. strTarget.."#r#W"..strAppend;
			else
				strTarget = "   #W" .. strTarget;
			end
		elseif(nMissionTrackType == 2) then   --表格送物任务，根据不同类型进行文字匹配
			local strNPCName, strSceneName, nTargetScene, nPosX, nPosY = DataPool:GetDeliveryMissionTrackInfo(nMissionIndex);
			if (strNPCName ~= "") then
				-- 英雄任务对应 场景为-1
				local strTemp = "";
				if(nTargetScene ~= -1) then
					--strTemp = string.format("   #W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}#W", strSceneName, strNPCName, nPosX, nPosY, nTargetScene, strNPCName);
					local nIndex = DataPool:GetPlayerMission_Display(nMissionIndex,7)--czf modify,2009.08.26
					if nIndex == 1018870 then
						strTemp = string.format("   #W去#G%s#W找#R%s#W", strSceneName, strNPCName);
					else
						strTemp = string.format("   #W去#G%s#W找#R%s#{_INFOAIM%d,%d,%d,%s}", strSceneName, strNPCName, nPosX, nPosY, nTargetScene, strNPCName);
					end
				else
					strTemp = string.format("   #W去#G%s#W找#R%s#W", strSceneName, strNPCName);
				end
				strTarget = strTarget .. strTemp .. "#r";
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		elseif(nMissionTrackType == 3) then   --表格配置杀怪任务
			local nMonsterNum = DataPool:GetKillMonsterMissionTrackInfo_num(nMissionIndex);
			if (nMonsterNum > 0) then
				for nn = 1, nMonsterNum do
					local strMonsterName, strSceneName, nSceneId, nCount, nXpos, nYpos = DataPool:GetKillMonsterMissionTrackInfo_MonsterInfo(nMissionIndex, nn-1);
					if(strMonsterName ~= "") then
						local strTemp = "";
						if(nSceneId ~= -1) then
							 strTemp = string.format("   #W去#G%s#W杀#R%s#{_INFOAIM%d,%d,%d,%s}#W", tostring(strSceneName),tostring(strMonsterName), tonumber(nXpos), tonumber(nYpos), tonumber(nSceneId), tostring(strMonsterName));
						else
							 strTemp = string.format("   #W去#G%s#W杀#R%s#W", tostring(strSceneName),tostring(strMonsterName));
						end
						strTarget = strTarget .. strTemp;
						strTarget = strTarget .. "#r";
					end	
				end
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		elseif(nMissionTrackType == 4) then
			local nLootItemNum = DataPool:GetLootItemMissionTrackInfo_num(nMissionIndex);
			if(nLootItemNum > 0) then
				for nn = 1, nLootItemNum do
					local strMonsterName, strSceneName, strItemName, nSceneID, nItemNum, xPos, yPos = DataPool:GetLootItemMissionTrackInfo_ItemInfo(nMissionIndex, nn-1);
					if (strMonsterName ~= "") then
						local strTemp = "";
						if(nSceneID ~= -1) then
							 strTemp = string.format("   #W去#G%s#W杀#R%s#{_INFOAIM%d,%d,%d,%s}#W", strSceneName, strMonsterName, xPos, yPos, nSceneID, strMonsterName);
						else
							 strTemp = string.format("   #W去#G%s#W杀#R%s#W", strSceneName, strMonsterName);
						end
						strTarget = strTarget .. strTemp;
						strTarget = strTarget .. "#r";
					end
				end
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		elseif (nMissionTrackType == 6) then
			local strObjName, strTargetNPC, strTargetScene, nTargetScene, xPos, yPos = DataPool:GetHusongMissionTrackInfo(nMissionIndex);
			if (strObjName ~= "") then
				local strTemp = "";
				if(nTargetScene ~= -1) then
					strTemp = string.format("   #W到%s找#R%s#{_INFOAIM%d,%d,%d,%s}#W#r",strTargetScene, strTargetNPC, xPos, yPos, nTargetScene, strTargetNPC);
				else
					strTemp = string.format("   #W到%s找#R%s#W",strTargetScene, strTargetNPC);
				end
				strTarget = strTarget .. strTemp;
			end
			if (strAppend ~= "") then
				strTarget = strTarget .. strAppend;
			end
		end
	end

	MissionTrack_ListBoxTransparent:AddItemExWithoutLayout(strTarget, nMissionIndex, 0, color, 4);
end

function MissionTrack_UpdateWillGet()

	MissionTrack_HaveGet:SetCheck(0);
	MissionTrack_WillGet:SetCheck(1);
	g_nNowCheck = 2;
	
	local nMyLevel = Player:GetData( "LEVEL" )
	MissionTrack_ListBoxTransparent:ClearListBoxEx();
	
	CollectMissionOutline();	
	
	for iMissionType=1,200 do             --现任务类型一共200种
	    local strOutlineName = "#cff9900" .. DataPool:GetMissionInfo_Kind( iMissionType );  --#gFE7E82
	
		if( strOutlineName ~= "" or strOutlineName ~= 0) then   
	   		local iStart = iMissionType*10000;
	    	local DeployNum = GetMissionOutlineNum( iMissionType )
	   		if( DeployNum > 0 and iMissionType ~= 50) then       --帮会城市任务，这里不要了
	        	local OutLineMission_Seq = {};
	        	local i = 1;
				for i=1, DeployNum do
				    local color= "";
					local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName, PosX, PosY, SceneID = GetMissionOutlineInfo( iMissionType, i );
					if( MissionLevel - nMyLevel <= 5 and MissionLevel >= nMyLevel -3) then
						local strInfo = "";
						strInfo = " #Y("..MissionLevel..")"..strMissionName;   --任务名
						table.insert(OutLineMission_Seq,strInfo)
						--MissionTrack_ListBoxTransparent:AddItemExWithoutLayout( strInfo, (iStart+i), 0);
						strInfo = "";
	    				strNpcPos = "#{_INFOAIM"..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."}";
	    				if strScene and strScene ~= "" then
	    					strInfo = strInfo.."   #G"..strScene.."  #R"..strNpcName..strNpcPos;
	    				else
	    					strInfo = strInfo.."   #R"..strNpcName..strNpcPos
	    				end
						table.insert(OutLineMission_Seq,strInfo)        --任务追踪信息
					end
				end
				
				if (table.getn(OutLineMission_Seq) > 0) then
					MissionTrack_ListBoxTransparent:AddItemExWithoutLayout( strOutlineName, iStart, 0 )
					local nn = 1;
					color = "FFD9F80A";	--黄色
					for nn,Per_Seq in ipairs(OutLineMission_Seq) do
						MissionTrack_ListBoxTransparent:AddItemExWithoutLayout( Per_Seq, (iStart+nn), 0, color, 4);	
					end
				end
	    	end
		end
	end
	MissionTrack_ListBoxTransparent:RequestLayout();
end

function MissionTrack_CloseFunc()
	this:Hide();
	DataPool:SetTrackFuncShow(1, 0);
	DataPool:UpdateTrackStateButton(0);
end

function MissionTrack_HaveGetFunc()
	MissionTrack_HaveGet:SetCheck(1);
	MissionTrack_WillGet:SetCheck(0);
	if(g_nNowCheck ~= 1) then
		MissionTrack_UpdateHaveGetMission(-1);
	end
end

function MissionTrack_WillGetFunc()
	MissionTrack_HaveGet:SetCheck(0);
	MissionTrack_WillGet:SetCheck(1);
	if(g_nNowCheck ~= 2) then
		MissionTrack_UpdateWillGet();	
	end
end

function MissionTrack_ItemContextClickedForEye()
	local curSceneID = GetSceneID();
	if (curSceneID == g_DiFu_Scene_Id) then
			return
	end
	
	local nClickedItemInx = MissionTrack_ListBoxTransparent:GetClickedButtonItem();
	DataPool:MissionTrackGotoQuestLog(nClickedItemInx);	
end

function MissionTrack_ItemContextClickedForClose()
	local nClickedItemInx = MissionTrack_ListBoxTransparent:GetClickedButtonItem();
	DataPool:SetMissionTrackOpen(nClickedItemInx, 0);
	MissionTrack_UpdateHaveGetMission(-1);		
	DataPool:UpdateQuestLogByTrack();
end

function MissionTrack_On_Height_Add()
	local nHeightOld = MissionTrack_Frame:GetProperty("AbsoluteHeight");
	local nListTopOld = MissionTrack__Frame:GetProperty("AbsoluteYPosition");
	local nHeightOld2 = MissionTrack__Frame:GetProperty("AbsoluteHeight");
	local nFunctionTopOld = MissionTrack_Function_Frame:GetProperty("AbsoluteYPosition");
	if (tonumber(nHeightOld) < 379) then
		MissionTrack_Frame:SetProperty("AbsoluteHeight", nHeightOld+17);	
		MissionTrack__Frame:SetProperty("AbsoluteHeight", nHeightOld2+17);
		MissionTrack__Frame:SetProperty("AbsoluteYPosition", nListTopOld);	
		MissionTrack_Function_Frame:SetProperty("AbsoluteYPosition", nFunctionTopOld);	
	end
end

function MissionTrack_On_Height_Reduce()
	local nHeightOld = MissionTrack_Frame:GetProperty("AbsoluteHeight");
	local nListTopOld = MissionTrack__Frame:GetProperty("AbsoluteYPosition");
	local nHeightOld2 = MissionTrack__Frame:GetProperty("AbsoluteHeight");
	local nFunctionTopOld = MissionTrack_Function_Frame:GetProperty("AbsoluteYPosition");
	if (tonumber(nHeightOld) > 158) then
		MissionTrack_Frame:SetProperty("AbsoluteHeight", nHeightOld-17);	
		MissionTrack__Frame:SetProperty("AbsoluteYPosition", nListTopOld);	
		MissionTrack__Frame:SetProperty("AbsoluteHeight", nHeightOld2-17);	
		MissionTrack_Function_Frame:SetProperty("AbsoluteYPosition", nFunctionTopOld);	
	end
end

function MissionTrack_On_Width_Add()
	--MissionTrack_Frame_Context:SetProperty("Alpha", "10");

	local nWidthOld = MissionTrack_Frame:GetProperty("AbsoluteWidth");
	local nFrameLeftOld = MissionTrack_Frame:GetProperty("AbsoluteXPosition");
	local nCheckBoxX = MissionTrack_CheckBox_Frame:GetProperty("AbsoluteXPosition");
	local nDragX = MissionTrack_DragTitle:GetProperty("AbsoluteXPosition");
	local nCloseX = MissionTrack_Close:GetProperty("AbsoluteXPosition");
	local nWidthOld2 = MissionTrack__Frame:GetProperty("AbsoluteWidth");
	local nFuncLeft = MissionTrack_Function_Frame:GetProperty("AbsoluteXPosition");
	local nLockX = MissionTrack_Lock:GetProperty("AbsoluteXPosition");
	if (tonumber(nWidthOld) < 310) then
		MissionTrack_Frame:SetProperty("AbsoluteWidth", nWidthOld + 10);
		MissionTrack_Frame:SetProperty("AbsoluteXPosition", nFrameLeftOld-10);
		MissionTrack_CheckBox_Frame:SetProperty("AbsoluteXPosition", nCheckBoxX + 10);
		MissionTrack_DragTitle:SetProperty("AbsoluteXPosition", nDragX + 10);
		MissionTrack_Close:SetProperty("AbsoluteXPosition", nCloseX + 10);
		MissionTrack__Frame:SetProperty("AbsoluteWidth", nWidthOld2 + 10);
		MissionTrack_Function_Frame:SetProperty("AbsoluteXPosition", nFuncLeft + 10);
		MissionTrack_Lock:SetProperty("AbsoluteXPosition", nLockX + 10);
		MissionTrack_UnLock:SetProperty("AbsoluteXPosition", nLockX + 10);
	end
end

function MissionTrack_On_Width_Reduce()
	local nWidthOld = MissionTrack_Frame:GetProperty("AbsoluteWidth");
	local nFrameLeftOld = MissionTrack_Frame:GetProperty("AbsoluteXPosition");
	local nCheckBoxX = MissionTrack_CheckBox_Frame:GetProperty("AbsoluteXPosition");
	local nDragX = MissionTrack_DragTitle:GetProperty("AbsoluteXPosition");
	local nCloseX = MissionTrack_Close:GetProperty("AbsoluteXPosition");
	local nWidthOld2 = MissionTrack__Frame:GetProperty("AbsoluteWidth");
	local nFuncLeft = MissionTrack_Function_Frame:GetProperty("AbsoluteXPosition");
	local nLockX = MissionTrack_Lock:GetProperty("AbsoluteXPosition");
	if (tonumber(nWidthOld) > 230) then
		MissionTrack_Frame:SetProperty("AbsoluteWidth", nWidthOld - 10);
		MissionTrack_Frame:SetProperty("AbsoluteXPosition", nFrameLeftOld+10);
		MissionTrack_CheckBox_Frame:SetProperty("AbsoluteXPosition", nCheckBoxX - 10);
		MissionTrack_DragTitle:SetProperty("AbsoluteXPosition", nDragX - 10);
		MissionTrack_Close:SetProperty("AbsoluteXPosition", nCloseX - 10);
		MissionTrack__Frame:SetProperty("AbsoluteWidth", nWidthOld2 - 10);
		MissionTrack_Function_Frame:SetProperty("AbsoluteXPosition", nFuncLeft - 10);
		MissionTrack_Lock:SetProperty("AbsoluteXPosition", nLockX - 10);
		MissionTrack_UnLock:SetProperty("AbsoluteXPosition", nLockX - 10);
	end
end

function MissionTrack_On_Lock()
        
	if (g_LockState == 0) then   --准备锁定
		g_LockState = 1;
		MissionTrack_UnLock:Show();
		MissionTrack_Lock:Hide();
		MissionTrack_HaveGet:SetProperty("MouseHollow", "True");
		MissionTrack_WillGet:SetProperty("MouseHollow", "True");
		MissionTrack_Close:SetProperty("MouseHollow", "True");
		MissionTrack_Frame:SetProperty("MouseHollow", "True");
		MissionTrack_DragTitle:SetProperty("MouseHollow", "True");
		MissionTrack_Function_Frame:SetProperty("MouseHollow", "True");
		MissionTrack_Height_Add:SetProperty("MouseHollow", "True");
		MissionTrack_Height_Reduce:SetProperty("MouseHollow", "True");
		MissionTrack_Width_Add:SetProperty("MouseHollow", "True");
		MissionTrack_Width_Reduce:SetProperty("MouseHollow", "True");
		MissionTrack_Reset:SetProperty("MouseHollow", "True");
	else               --解锁
		g_LockState = 0;
		MissionTrack_Lock:Show();
		MissionTrack_UnLock:Hide();
		MissionTrack_HaveGet:SetProperty("MouseHollow", "False");
		MissionTrack_WillGet:SetProperty("MouseHollow", "False");
		MissionTrack_Close:SetProperty("MouseHollow", "False");
		MissionTrack_Frame:SetProperty("MouseHollow", "False");
		MissionTrack_DragTitle:SetProperty("MouseHollow", "False");
		MissionTrack_Function_Frame:SetProperty("MouseHollow", "False");
		MissionTrack_Height_Add:SetProperty("MouseHollow", "False");
		MissionTrack_Height_Reduce:SetProperty("MouseHollow", "False");
		MissionTrack_Width_Add:SetProperty("MouseHollow", "False");
		MissionTrack_Width_Reduce:SetProperty("MouseHollow", "False");
		MissionTrack_Reset:SetProperty("MouseHollow", "False");
	end
	MissionTrack_ShowORHideFunc(0);
	
end

function MissionTrack_On_Reset()
	
	MissionTrack_Frame:SetProperty("UnifiedSize", "{{0,230},{0.0,158}}");
	MissionTrack_Frame:SetProperty("UnifiedXPosition", "{1.0,-266}");
	MissionTrack_Frame:SetProperty("UnifiedYPosition", "{0.0,228}");
	
	MissionTrack__Frame:SetProperty("AbsolutePosition", "x:0.000000 y:17.000000");
	MissionTrack__Frame:SetProperty("AbsoluteSize", "w:212.000000 h:139.000000");
	
	MissionTrack_Function_Frame:SetProperty("AbsolutePosition", "x:211.0 y:17.0");
	
	MissionTrack_DragTitle:SetProperty("AbsolutePosition", "x:80.000000 y:0.000000");
	MissionTrack_Close:SetProperty("AbsolutePosition", "x:196.000000 y:0.000000");
	MissionTrack_CheckBox_Frame:SetProperty("AbsolutePosition", "x:0.0 y:0.0");
	MissionTrack_Lock:SetProperty("AbsolutePosition", "x:180.000000 y:0.000000");
	MissionTrack_UnLock:SetProperty("AbsolutePosition", "x:180.000000 y:0.000000");
end

function MissionTrack_Func_MouseEnter()
	MissionTrack_ShowORHideFunc(1);
end

function MissionTrack_Func_MouseLeave()
	MissionTrack_ShowORHideFunc(0);
end

function MissionTrack_ShowORHideFunc( nShow )

	if (nShow >= 1 and g_LockState == 0) then
		MissionTrack_Height_Add:Show();
		MissionTrack_Height_Reduce:Show();
		MissionTrack_Width_Add:Show();
		MissionTrack_Width_Reduce:Show();	
		MissionTrack_Reset:Show();
	else
		MissionTrack_Height_Add:Hide();
		MissionTrack_Height_Reduce:Hide();
		MissionTrack_Width_Add:Hide();
		MissionTrack_Width_Reduce:Hide();
		MissionTrack_Reset:Hide();
	end
end


function MissionTrack_SetAlpha(val)
	local bNum = val
	if tonumber(bNum) < 0.3 then 
		MissionTrack_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_Function_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_ListBoxTransparent:SetVScrollbarAlpha("0.3");
	elseif tonumber(bNum) < 0.5 then
		MissionTrack_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_Function_Frame:SetProperty( "Alpha", "0.5" );
		MissionTrack_ListBoxTransparent:SetVScrollbarAlpha(val);
	else
		MissionTrack_Frame:SetProperty( "Alpha", val );
		MissionTrack_Function_Frame:SetProperty( "Alpha", val );
		MissionTrack_ListBoxTransparent:SetVScrollbarAlpha(val);
	end
	MissionTrack_Frame_Context:SetProperty( "Alpha", val );
end

--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理，判断任务是否完成
function IsMissionSuccess(nSelIndex)
       local MissionParam_Index = 0
       local Mission_Variable = 0
--任务需要杀的npc		
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
		if( nDemandKillNum > 0 ) then
			for i=1, nDemandKillNum do
				--    需要的NPC，需要NPC ID，需要多少个
				local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
				MissionParam_Index = MissionParam_Index + 1;
				if Mission_Variable < nNum then
					return 0
				end
			end
		end

--任务需要的物品
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nSelIndex);
		if( nDemandNum > 0 ) then
			for i=1, nDemandNum do
				--    需要的类型，需要物品ID，需要多少个
				local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
				Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
				 if Mission_Variable < nNum then
					return 0
				 end
			 end
		 end

-----------------------------------------------------------------------------------
--任务自定义的物品
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
		if( nCustomNum > 0 ) then
			for i=1, nCustomNum do
				--    需要的NPC，需要NPC ID，需要多少个
				local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
				MissionParam_Index = MissionParam_Index + 1;
				if Mission_Variable < nNum then
				    return 0
				end
			end
		end

-----------------------------------------------------------------------------------	

--任务自定义的随机物品 zz添加

	local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
	if( nRandomCustomNum > 0 ) then
		for i=1,nRandomCustomNum do
			local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
			if nCompleteNum < nNeedNum then
				return 0
			end
		end	
	end
	
	return 1
end
