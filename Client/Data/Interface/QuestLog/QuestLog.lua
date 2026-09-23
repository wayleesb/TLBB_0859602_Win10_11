local bBeingRadio = 0;
local MissionType = {};
local MissionPucker = {};
local Current_Select;
local First_Open = 1;
local MissionParam_Index = 0;
local k
local LEVEL_TO_MY_LEVEL = 10000;

local MissionOutlineDeploy = {}
local CurList      -- 1为任务列表,2为任务索引

local Current_Clicked = -1;
--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理,需要特殊处理的任务脚本号列表：
local SpecialMissionList = {200006,200031}

function QuestLog_PreLoad()
	this:RegisterEvent("TOGLE_MISSION");
	this:RegisterEvent("UPDATE_MISSION");
	this:RegisterEvent("PACKAGE_ITEM_CHANGED");
	this:RegisterEvent("UPDATE_DOUBLE_EXP");
	this:RegisterEvent("UPDATE_QUESTTIME");
	this:RegisterEvent("NEW_MISSION");
	this:RegisterEvent("DELETE_MISSION");
	this:RegisterEvent("TOGLE_MISSION_OUTLINE");
	this:RegisterEvent("UI_COMMAND")
	this:RegisterEvent("OPEN_FROM_MISSIONTRACK");
	this:RegisterEvent("UPDATE_QUESTLOG_BY_TRACK");
	this:RegisterEvent("UPDATE_TRACK_STATE_BUTTON");
end

function QuestLog_OnLoad()

	local i=1;
	for i=1,200 do
		MissionPucker[i] = 1;
	end;
	
	for i=1,200 do
	    MissionOutlineDeploy[ i ] = 1  --任务索引默认都为展开
	end
	
	First_Open = 1;
	CurList = 1
end

function QuestLog_OnEvent(event)
--	if(this:IsVisible()) then
--		QuestLog_OnShown();
--		return;
--	end

	if(event == "UI_COMMAND" and tonumber(arg0) == 831020) then
			QuestLog_UpdateListbox();
			QuestLog_UpdateMissionOutline();
			QuestLog_ShowWindow();
  end
	
	if(event == "TOGLE_MISSION" ) then
			QuestLog_UpdateListbox();
			QuestLog_ShowWindow();
	elseif(event == "TOGLE_MISSION_OUTLINE" ) then
			QuestLog_UpdateMissionOutline();
			QuestLog_ShowWindow();
	elseif(event == "UPDATE_MISSION" ) then
			if not this:IsVisible() then
				return;
			end
			QuestLog_UpdateListbox();
	elseif(event == "PACKAGE_ITEM_CHANGED" ) then
			if not this:IsVisible() then
				return;
			end
			if CurList == 1 then
				QuestLog_UpdateListbox();
			end
	elseif(event == "UPDATE_DOUBLE_EXP" ) then
			local DT = SystemSetup : GetDoubleExp("remaintime");
			QuestLog_Watch:SetProperty("Timer",DT);
	elseif(event == "UPDATE_QUESTTIME") then
			if not this:IsVisible() then
				return;
			end
			
			if( 2 == CurList ) then
			    return    --这个消息是用来更新任务计时的,当当前选中项为任务索引时,则不应该进行更新.
			end
						
		if arg0 ~= nil and tonumber(arg0) <= 20 and tonumber(arg0) >= 0 then
			if tonumber(arg0) == Current_Select then
				QuestLog_ListBox_SelectChanged()
			end
		end
	elseif(event == "NEW_MISSION" ) then
		Current_Select = tonumber(arg0)
		if not this:IsVisible() then
			return;
		else
			QuestLog_UpdateListbox();
		end
	elseif(event == "DELETE_MISSION") then
		if Current_Select == tonumber(arg0) then
			DataPool:GetPlayerMission_DelActivePos(Current_Select);
			return;
		end
	elseif (event == "OPEN_FROM_MISSIONTRACK") then
		
		Current_Select = tonumber(arg0)
		if not this:IsVisible() then
			First_Open = 0;
			
			--全部展开
			for i=1,200 do
				MissionPucker[i] = 1;
			end;
			
			QuestLog_UpdateListbox();
			QuestLog_ShowWindow();
		else
			--QuestLog_UpdateListbox();
			this:Hide();
		end
	elseif (event == "UPDATE_QUESTLOG_BY_TRACK") then
		if this:IsVisible() then
			QuestLog_UpdateListbox();
		end
	elseif (event == "UPDATE_TRACK_STATE_BUTTON") then
		local nType = tonumber(arg0);
		if not this:IsVisible() then
			return;
		end
		
		if (nType == 0) then  -- MissionTrack State Changed
			if (DataPool:IsTrackFuncShow(1) > 0) then
				QuestLog_Mode1:SetCheck(1);
			else
				QuestLog_Mode1:SetCheck(0);
			end
		elseif (nType == 1) then  -- CampaignTrack StateChanged
			if (DataPool:IsTrackFuncShow(2) > 0) then
				QuestLog_Mode2:SetCheck(1);
			else
				QuestLog_Mode2:SetCheck(0);
			end
		end
	end
end

function QuestLog_OnShown()
	QuestLog_UpdateListbox();
end


function QuestLog_HitRiCheng()
	OpenTodayCampaignList();
end

function QuestLog_UpdateMissionType( iMissionType )
	local strOutlineName = ""
	if( 1 == MissionOutlineDeploy[ iMissionType ] ) then
	    strOutlineName = "#gFE7E82- " .. DataPool:GetMissionInfo_Kind( iMissionType )
	else
	    strOutlineName = "#gFE7E82+ " .. DataPool:GetMissionInfo_Kind( iMissionType )
	end
	
	if( strOutlineName ~= "" or strOutlineName ~= 0 ) then
	    local iStart = iMissionType*10000;
	    local DeployNum = GetMissionOutlineNum( iMissionType )

	    if( DeployNum > 0 ) then
	        QuestLog_Listbox:AddItem( strOutlineName, iStart )
	        if( 1 == MissionOutlineDeploy[ iMissionType ] ) then
	            local nMyLevel = Player:GetData( "LEVEL" )
				for i=1, DeployNum do
				    local color= ""
					local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName = GetMissionOutlineInfo( iMissionType, i )
					
					if( MissionLevel - nMyLevel < -11 ) then
						color = "FFB9B9B9"; --灰色
					elseif( MissionLevel - nMyLevel <=-6 ) then
						color = "FF0A9605";	--绿色
					elseif( MissionLevel - nMyLevel <= 5 ) then
						color = "FFD9F80A";	--黄色
					elseif( MissionLevel - nMyLevel <= 10 ) then
						color = "FFF8A10A";	--橙色
					else
						color = "FFFA0A0A"; --红色
					end					
					
					QuestLog_Listbox:AddItem( "    "..MissionLevel.." "..strMissionName, (iStart+i), color )
				end
	        end
	    end
	    
	end
end

function QuestLog_UpdateMissionOutline()
    
    if( 1 == CurList ) then
        CurList = 2
	QuestLog_AcceptMission:SetCheck(1);
        QuestLog_Stop:Hide()
        QuestLog_AcceptMission_Button:Hide()
        QuestLog_TargetMission : SetText( "" );
    end

    local FirstItem = QuestLog_Listbox : GetCurrentFirstItem();
    --AxTrace( 0, 0, Current_Clicked )

    CollectMissionOutline()
    QuestLog_Listbox:ClearListBox()
    QuestLog_Desc:ClearAllElement();
    
	for i=1,200 do             --现任务类型一共200种
	    QuestLog_UpdateMissionType( i )
	end
	
    --QuestLog_Listbox : EnsureItemIsVisable( Current_Clicked );
    QuestLog_Listbox : SetCurrentFirstItem( FirstItem );
	QuestLog_TrackButtonState();
    --AxTrace( 0, 0, Current_Clicked )
	
end

function QuestLog_MissionOutlineClicked()
    local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
    
    local iMod = math.mod( nSelIndex, 10000 )
    local iFloor = math.floor( nSelIndex / 10000 );
    if( 0 == iMod ) then
        if( 0 == MissionOutlineDeploy[ iFloor ] ) then
            MissionOutlineDeploy[ iFloor ] = 1
        else
            MissionOutlineDeploy[ iFloor ] = 0
        end
        
        QuestLog_UpdateMissionOutline()
        QuestLog_Desc:ClearAllElement();
        return
        --QuestLog_Listbox:SetItemSelectByItemID( nSelIndex )
    end
    
    QuestLog_Desc:ClearAllElement();
    local MissionLevel, MinLevel, MaxLevel, strNpcName, strNpcPos, strScene, strMissionName, PosX, PosY, SceneID = GetMissionOutlineInfo( iFloor, iMod )
    QuestLog_Desc:AddTextElement("#Y"..strMissionName.."#W")
    
    strNpcPos = "#{_INFOAIM"..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."}"
    --strNpcPos = "[["..(PosX)..","..(PosY)..","..(SceneID)..","..(strNpcName).."]]"
    --strNpcPos = "（"..PosX.."，"..PosY.."）"

    if strScene and strScene ~= "" then
			QuestLog_Desc:AddTextElement("任务所在地："..strScene.."  "..strNpcPos )
    end
    QuestLog_Desc:AddTextElement("任务发布人："..strNpcName )
    QuestLog_Desc:AddTextElement("任务等级："..tostring(MissionLevel) )
    
    
end

function QuestLog_UpdateListbox()

    if( 2 == CurList ) then
        CurList = 1
	QuestLog_CurrentMission:SetCheck(1);
        QuestLog_Stop:Show()
        QuestLog_AcceptMission_Button:Hide()
    end
        
    QuestLog_CurrentMission:SetCheck( 1 )
    QuestLog_AcceptMission:SetCheck( 0 )
        
--	local nMissionNum = DataPool:GetPlayerMission_Num();
	local i;
	local nMyLevel = Player:GetData( "LEVEL" );

	QuestLog_Listbox:ClearListBox();
	
	local nMissionNum = 20
	k = 0
	local color;
	
	for i=1,nMissionNum do
		if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
			DataPool:GetPlayerMission_Description(i-1);
		end
	end;
	
	local Sequence_OnefoldGenre = {}
	local Sequence_Assemble = {}
	local Constitutes = {};
	
	for j=1, 200 do
		local bHave = 0;
		for i=1, nMissionNum do
			if (DataPool:GetPlayerMission_InUse(i-1) == 1) then
				local MissionKind = DataPool:GetPlayerMission_Kind(i-1);
				
				if(MissionKind == j) then
					AxTrace(0,0,"j = ".. j .. " i-1 ="..(i-1));

					if ( MissionPucker[j] > 0 ) then 
						local strInfo = DataPool:GetPlayerMission_Memo(i-1);
						local nMissionLevel = DataPool:GetPlayerMission_Level(i-1);
					
						if nMissionLevel == LEVEL_TO_MY_LEVEL then
							nMissionLevel =  Player:GetData( "LEVEL" );
						end
					
						if(bHave == 0) then
							local str= "#gFE7E82- " .. DataPool:GetMissionInfo_Kind(j);
		--fix					QuestLog_Listbox:AddItem(str,100+j);
							Constitutes = {str,100+j,"",0}
--							Sequence_OnefoldGenre = {}
							table.insert(Sequence_OnefoldGenre,Constitutes)
							local xx;
							for i,xx in ipairs(Constitutes) do 
								AxTrace(3,1,"Constitutes["..i.."]="..xx)
							end
							AxTrace(0,0,"100+j = ".. (100+j) .. " name = " ..DataPool:GetMissionInfo_Kind(j));
							bHave = 1;
						end
--------------------------------------------------
						local strOKFail = "";
					--显示任务是否已完成或已失败
						local Mission_Variable = DataPool:GetPlayerMission_Variable(i-1,0);
--						local Mission_WhetherComplete = DataPool:GetMission_WhetherComplete(i-1);
--						if( Mission_WhetherComplete > 0 ) then
--							strOKFail = "完成";
--						end
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
							elseif(Mission_Variable == 2) then
								strOKFail = "失败";
							end
						end


----------------------------------------------------
						if(nMissionLevel - nMyLevel < -11) then
							color = "FFB9B9B9"; --灰色
						elseif(nMissionLevel - nMyLevel <=-6) then
							color = "FF0A9605";	--绿色
						elseif(nMissionLevel - nMyLevel <= 5) then
							color = "FFD9F80A";	--黄色
						elseif(nMissionLevel - nMyLevel <= 10) then
							color = "FFF8A10A";	--橙色
						else
							color = "FFFA0A0A"; --红色
						end

						if(First_Open == 1) then
								First_Open = 0;
								Current_Select = i-1;
								AxTrace(0,0,"First_Open =".. First_Open .." Current_Select =".. Current_Select);
						end
--						AxTrace(0,0,"First Current_Select =".. Current_Select);
		--fix				QuestLog_Listbox:AddItem("    " .. nMissionLevel .." " .. strInfo .. " " .. strOKFail, i-1 , color);

						local nMissionTrackType = DataPool:GetPlayerMissionTrackType(i-1);
						local nIsMissionTrackOpen = DataPool:IsMissionTrackOpen(i-1);
						if (nIsMissionTrackOpen > 0 and nMissionTrackType > 0) then
							Constitutes = {"   √" .. nMissionLevel .." " .. strInfo .. " " .. strOKFail,i-1,color,nMissionLevel}
						else
							Constitutes = {"     " .. nMissionLevel .." " .. strInfo .. " " .. strOKFail,i-1,color,nMissionLevel}
						end
						table.insert(Sequence_OnefoldGenre,Constitutes)
--						local xx;
--						for i,xx in ipairs(Constitutes) do 
--							AxTrace(3,1,"Constitutes["..i.."]="..xx)
--						end
						if(Current_Select == i-1) then
							QuestLog_Listbox : SetItemSelectByItemID(Current_Select);
						end
--						AxTrace(0,0,"i-1 ="..(i-1).."]  in" );
					else
						if(bHave == 0) then
							local str= "#gFE7E82+ " .. DataPool:GetMissionInfo_Kind(j);
--							QuestLog_Listbox:AddItem(str,100+j);

							Constitutes = {str,100+j,"",0}
							table.insert(Sequence_OnefoldGenre,Constitutes)
							
--							AxTrace(0,0,"100+j = ".. (100+j) .. " name = " ..DataPool:GetMissionInfo_Kind(j));
							bHave = 1;
						end
--						AxTrace(0,0,"i-1 ="..(i-1).."] = out" );
					end
					k=k+1;
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
		if Per_Segment[3] ~= "" then
			QuestLog_Listbox:AddItem(Per_Segment[1],Per_Segment[2],Per_Segment[3])
		else
			QuestLog_Listbox:AddItem(Per_Segment[1],Per_Segment[2])
		end

--		for j,xxxx in ipairs(xxx) do
--			AxTrace(3,0,"xxx["..j.."]="..xxxx)
--		end
	end
	
	if(k<1) then
		QuestLog_Listbox:AddItem("没有任何任务。",0);
	end
	QuestLog_Listbox : SetItemSelectByItemID(Current_Select);
	QuestLog_Amount : SetText( k .. "/" .. nMissionNum);
---
	QuestLog_ListBox_SelectChanged();
	
	if Current_Clicked ~= -1 then
		--QuestLog_Listbox : EnsureItemIsVisable(Current_Clicked);
		QuestLog_Listbox : SetCurrentFirstItem(Current_Clicked);
		Current_Clicked = -1
	end
	QuestLog_TrackButtonState();
--
end

function MissionType_Insert(str)
--排序算法在上面已经实现了，理论上讲这个不会被调用到。chris
--		for i=1,table.getn(MissionType) do
		for i,Per_Segment in ipairs(MissionType) do
			if(MissionType[i] == str) then
				return;
			elseif( MissionType[i] > str ) then
					table.insert(MissionType,i,str);
--					AxTrace(0,0,"MissionType [" ..i.."] =".. MissionType[i]);
					return;
			end
		end
		table.insert(MissionType,str);
		return;
end

function QuestLog_ListBox_SelectChanged()

if( 2 == CurList ) then
    QuestLog_MissionOutlineClicked()
    return
end
		
		local MissionParam_Index = 0;
		local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
		local Mission_Variable;
		if(k<1) then
			QuestLog_Desc:ClearAllElement();
			QuestLog_TargetMission : SetText("");
			return;
		end
		if nSelIndex == -1 then
			if Current_Select == -1 then
				QuestLog_Desc:ClearAllElement();
				QuestLog_TargetMission : SetText("");
				return;
			else
				nSelIndex = Current_Select;
			end
		end
--		AxTrace(0,0,"选中项为 =" .. nSelIndex);
		if nSelIndex > 20 then

			if MissionPucker[nSelIndex-100] == 1 then
				MissionPucker[nSelIndex-100] = 0;
--				AxTrace(0,0,"==1");
			else
				MissionPucker[nSelIndex-100] = 1;
--				AxTrace(0,0,"==0");
			end
			Current_Clicked = QuestLog_Listbox : GetCurrentFirstItem();
			QuestLog_UpdateListbox();
			
			return;
		end;
		if (DataPool:GetPlayerMission_InUse(nSelIndex) ~= 1) then
			QuestLog_Desc:ClearAllElement();
			QuestLog_TargetMission : SetText("");
			return;
		end
		QuestLog_Desc:ClearAllElement();
		QuestLog_TargetMission : SetText("");
		
		local desc = DataPool:GetPlayerMission_Description(nSelIndex)
		DataPool:GetPlayerMission_DelActivePos(Current_Select)
		Current_Select = nSelIndex;
		
		local strInfo,strDesc = DataPool:GetPlayerMission_Memo(nSelIndex);
		local i = 0
		local m = 0
		local nBegin = DataPool:GetPlayerMission_ForePart(nSelIndex);
		AxTrace(5,1,"nBegin="..nBegin)
		AxTrace(5,1,"strDesc="..strDesc)
		local strReplace = ""
		local strOriginal = ""
		while 1 do
			i = string.find(strDesc,"%%s")
			if i == nil then break end
			local strIndex =  DataPool:GetPlayerMission_VariableByByte(nSelIndex,nBegin,m)
			local strTemp = DataPool : GetPlayerMission_StrList(strIndex)
			AxTrace(5,1,"strIndex="..strIndex.." strTemp="..strTemp.." strDesc="..strDesc)
--			string.format(strDesc,strTemp)
			AxTrace(5,1,"strIndex="..strIndex.." strTemp="..strTemp.." strDesc="..strDesc)
			strReplace = strReplace .. string.sub(strDesc,1,i-1) .. strTemp
			AxTrace(5,1,"strReplace="..strReplace)
			AxTrace(5,1,"i="..i)
			strDesc = string.sub(strDesc,i+2)
			m = m + 1;
			AxTrace(5,1,"m="..m)
		end
		strReplace = strReplace .. strDesc
		strDesc = strReplace
		QuestLog_TargetMission : SetText("#gFF0FA0" ..strInfo);
		QuestLog_Desc:AddTextElement("#Y任务目标：#W")
		QuestLog_Desc:AddTextElement("" .. strDesc);
--		QuestLog_Desc:AddTextElement("" .. strReplace);
		DataPool:GetPlayerMission_ActivePos(nSelIndex);

--显示是否双倍时间
		local nDoubleExp = DataPool:GetPlayerMission_Display(nSelIndex,6)

		local DoubleExp_Text = "";
		if nDoubleExp > 0 then
			local IsDouble = DataPool:GetPlayerMission_DataRound(nDoubleExp);

			if IsDouble > 0 then
				DoubleExp_Text = "#B多倍奖励"
				QuestLog_Desc:AddTextElement(DoubleExp_Text);
			end
		end
		
--		AxTrace(0, 0, "strInfo= " .. strInfo );
	--前面是否有一位显示任务是否已完成,第一位为完成信息
		--TT53675对所有不符合规范，没有将missionparam第0位做为任务完成标志的任务脚本做特殊处理  
		local IsSpecial = 0
	    local nScriptId1 = DataPool:GetPlayerMission_Display(nSelIndex,7)
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

--		for i =0,7 do
--			AxTrace(0,0, "variable [" .. i .."] = " .. DataPool:GetPlayerMission_Variable(nSelIndex,i) );
--		end
--显示任务剩余时间
		local nTotalTime = DataPool:GetPlayerMission_Display(nSelIndex,2);
		AxTrace(1,1,"nTotalTime="..nTotalTime)
		if( nTotalTime > 0 ) then
			local nRemainTime = DataPool:GetPlayerMission_RemainTime(nSelIndex);
			AxTrace(1,1,"nRemainTime="..nRemainTime)
			if(nTotalTime >0) then
--				QuestLog_Desc:AddTextElement(" ");
				local strRemainTime,strTotalTime,nSecond,nMinute,nHour; --Dengxx
				
				if(nTotalTime >= 60000*60) then
					nHour = math.floor(nTotalTime/60000/60) 
					nMinute = math.floor((math.mod(nTotalTime,60000*60))/60000)
					nSecond = math.floor((math.mod(nTotalTime,60000))/1000)
					strTotalTime = nHour .. "小时"..nMinute.."分"..nSecond.."秒"
				elseif(nTotalTime >= 60000) then
					nMinute = nTotalTime/60000;
					strTotalTime = nMinute .. "分"
					nSecond = (nTotalTime - nMinute * 60000)/1000;
					strTotalTime = strTotalTime .. nSecond .."秒"
				elseif(nTotalTime >= 1000) then
					strTotalTime = nTotalTime/1000 .."秒"
				end
        
        if(nRemainTime >= 60000*60) then
					nHour = math.floor(nRemainTime/60000/60)
					nMinute = math.floor((math.mod(nRemainTime,60000*60))/60000)
					nSecond = math.floor((math.mod(nRemainTime,60000))/1000)
					strRemainTime = nHour .. "小时"..nMinute.."分"..nSecond.."秒"
				elseif(nRemainTime >= 60000) then
					nMinute = math.floor(nRemainTime/60000);
					strRemainTime = nMinute .. "分"
					nSecond = math.floor((nRemainTime - nMinute * 60000)/1000);
					strRemainTime = strRemainTime .. nSecond .."秒"
				elseif(nRemainTime >= 1000) then
					strRemainTime = math.floor(nRemainTime/1000) .."秒"
				else
					strRemainTime = "0秒"
				end

--				QuestLog_Desc:AddTextElement("剩余时间： " .. strRemainTime .."/".. strTotalTime);
				QuestLog_Desc:AddTextElement("剩余时间： " .. strRemainTime );
--				AxTrace(0,0, "时间 [" .. nSelIndex .."] = " .. strRemainTime .. " param_index = "..MissionParam_Index);
			end
		end	

		--显示任务当前环数，misInfo的第三号参数为环数，通过mission data显示
		--yanghui，设置标志，通过mission data显示环数还是mission param显示环数
		local bShowByMD = 0;
		local nRound = DataPool:GetPlayerMission_Display(nSelIndex,3);
		if( nRound >= 0 ) then
			Mission_Variable = DataPool:GetPlayerMission_DataRound(nRound);
			
			if(Mission_Variable >= 0) then
				QuestLog_Desc:AddTextElement("#r#Y任务当前环数：#W"..Mission_Variable);
				bShowByMD = 1;
			end
		end
		
		--yanghui，千寻任务使用mission param增加环数显示
		if (bShowByMD == 0) then
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex, 2);
			if (Mission_Variable == 229024) then
				Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex, 5);
				if(Mission_Variable >= 0) then
					QuestLog_Desc:AddTextElement("#r#Y任务当前环数：#W"..Mission_Variable);
				end
			end
		end


--显示任务银票数量
		if( DataPool:GetPlayerMission_Display(nSelIndex,4) > 0 ) then
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
			MissionParam_Index = MissionParam_Index + 1;
			
			if(Mission_Variable >0) then
--				QuestLog_Desc:AddTextElement(" ");
				silverdesc = DataPool:GetPlayerMission_BillName(nSelIndex);
				QuestLog_Desc:AddTextElement(silverdesc .. ":");
				QuestLog_Desc:AddMoneyElement(Mission_Variable);
				AxTrace(0,0, "银票 [" .. nSelIndex .."] =" ..MissionParam_Index );
			end
		end	
		QuestLog_Desc:AddTextElement(" ");
		if( DataPool:GetPlayerMission_Display(nSelIndex,5) <= 0 ) then
			QuestLog_Desc:AddTextElement("#Y完成情况：#W")
		end
		
--任务需要杀的npc		
		local nDemandKillNum,Kill_Random_Type = DataPool:GetPlayerMissionDemandKill_Num(nSelIndex);
		if( nDemandKillNum > 0 ) then
--			QuestLog_Desc:AddTextElement(" ");
			QuestLog_Desc:AddTextElement("已杀死：");
		end	
	
		for i=1, nDemandKillNum do
			--    需要的NPC，需要NPC ID，需要多少个
			local nNPCName, nNum = DataPool:GetPlayerMissionDemand_NPC(i-1,Kill_Random_Type,nSelIndex);
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index,Kill_Random_Type,i-1);
			MissionParam_Index = MissionParam_Index + 1;
			AxTrace(0, 0, "nNPCName:" .. nNPCName);
			AxTrace(0, 0, "num:" .. nNum);
			
			QuestLog_Desc:AddTextElement(nNPCName .. " ： "..Mission_Variable.. " / " .. nNum);
			AxTrace(0,0, "NPC [" .. nSelIndex .."] =" ..MissionParam_Index );
		end

--任务需要的物品
		local nDemandNum,Item_Random_Type= DataPool:GetPlayerMissionDemand_Num(nSelIndex);
		if( nDemandNum > 0 ) then
--			QuestLog_Desc:AddTextElement(" ");
			if(Item_Random_Type == -100) then
				QuestLog_Desc:AddTextElement("已提交：");
				Item_Random_Type = 0
			else
				QuestLog_Desc:AddTextElement("已得到：");
			end
		end	
	
		for i=1, nDemandNum do
			--    需要的类型，需要物品ID，需要多少个
			local szName,nItemID, nNum = DataPool:GetPlayerMissionDemand_Item(i-1,Item_Random_Type,nSelIndex);
--			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
--			MissionParam_Index = MissionParam_Index + 1
			Mission_Variable = DataPool : GetPlayerMission_ItemCountNow(nItemID)
			AxTrace(0, 0, "itemid:" .. nItemID)
			AxTrace(0, 0, "szName:" .. szName)
			AxTrace(0, 0, "num:" .. nNum)
			
			if Mission_Variable > nNum then
				Mission_Variable = nNum
			end
			
			
--			QuestLog_Desc:AddItemElement(nItemID, nNum, 0);
			local Mission_Variable2 = DataPool:GetPlayerMission_Variable(nSelIndex,0);
			if Mission_Variable2 > 0 then
				Mission_Variable = nNum
			end
			QuestLog_Desc:AddTextElement(szName .. " ： " .. Mission_Variable .. " / " .. nNum);
		end

-----------------------------------------------------------------------------------
--任务自定义的物品
		local nCustomNum = DataPool:GetPlayerMissionCustom_Num(nSelIndex);
		if( nCustomNum > 0 ) then
			QuestLog_Desc:AddTextElement(" ");
		end	
	
		for i=1, nCustomNum do
			--    需要的NPC，需要NPC ID，需要多少个
			local strCustom, nNum = DataPool:GetPlayerMissionCustom(i-1);
			Mission_Variable = DataPool:GetPlayerMission_Variable(nSelIndex,MissionParam_Index);
			MissionParam_Index = MissionParam_Index + 1;
			AxTrace(0, 0, "strCustom = " .. strCustom);
			AxTrace(0, 0, "nNum = " .. nNum);
			
			if nNum == 0 then
				QuestLog_Desc:AddTextElement(strCustom);
			else
				QuestLog_Desc:AddTextElement(strCustom .. " ： ".. Mission_Variable .. " / " .. nNum);
			end
		end

-----------------------------------------------------------------------------------	

--任务自定义的随机物品 zz添加

	local nRandomCustomNum = DataPool:GetPlayerMissionRandomCustom_Num(nSelIndex);
	if( nRandomCustomNum > 0 ) then
			QuestLog_Desc:AddTextElement(" ");
	end
	for i=1,nRandomCustomNum do
		local strCustom, nNeedNum,nCompleteNum = DataPool:GetPlayerMissionRandomCustom(i-1,nSelIndex);
		if nNeedNum == 0 then
			QuestLog_Desc:AddTextElement(strCustom);
		else
			QuestLog_Desc:AddTextElement(strCustom .. " ： ".. nCompleteNum .. " / " .. nNeedNum);
		end
	end
----------------------------------------------------------------------------------

		QuestLog_Desc:AddTextElement(" ");
		local nBonusNum = DataPool:GetPlayerMissionBonus_Num();
		
		if( nBonusNum > 0 ) then
			QuestLog_Desc:AddTextElement("#Y奖励：#W");
		end
		local nRadio = 1;
		local nRand = 1;

		for i=1, nBonusNum do
			--奖励的类型，奖励物品ID，奖励多少个
			local strType, nItemID, nNum = DataPool:GetPlayerMissionBonus_Item(i-1);
			if(strType == "money") then
--				QuestLog_Desc:AddTextElement("奖励金钱：");
				--这里有对剧情循环任务的特殊处理
				local nScriptId = DataPool:GetPlayerMission_Display(nSelIndex,7)
				if (nScriptId >= 890000 and nScriptId <= 890005) then
					--PushDebugMessage("叫交子控件")
					QuestLog_Desc:AddJiaoZiElement(nNum)
				else
					if (nScriptId >= 1010243 and nScriptId <= 1010250) or
					 (nScriptId >= 1010402 and nScriptId <= 1010409) or
					 (nScriptId >= 1018000 and nScriptId <= 1018033) or
					 (nScriptId >= 1018050 and nScriptId <= 1018084) or
					 (nScriptId >= 1018100 and nScriptId <= 1018155) or
					 (nScriptId >= 1018200 and nScriptId <= 1018235) or
					 (nScriptId >= 1018300 and nScriptId <= 1018311) or
					 (nScriptId >= 1018350 and nScriptId <= 1018352) or
					 (nScriptId >= 1018360 and nScriptId <= 1018367) or
					 (nScriptId >= 1018400 and nScriptId <= 1018455) or
					 (nScriptId >= 1018500 and nScriptId <= 1018504) or
					 (nScriptId >= 1018530 and nScriptId <= 1018541) or
					 (nScriptId >= 1018560 and nScriptId <= 1018566) or
					 (nScriptId >= 1038000 and nScriptId <= 1038040) or
					 (nScriptId >= 1038110 and nScriptId <= 1038114) or
					 (nScriptId >= 1039000 and nScriptId <= 1039011) or
					 (nScriptId >= 1039020 and nScriptId <= 1039024) or
					 (nScriptId >= 1039100 and nScriptId <= 1039104) or
					 (nScriptId >= 1038100 and nScriptId <= 1038104) or
					 (nScriptId >= 1039110 and nScriptId <= 1039126) or
					 (nScriptId >= 1039200 and nScriptId <= 1039211) or
					 (nScriptId >= 1039250 and nScriptId <= 1039259) or
					 (nScriptId >= 1039300 and nScriptId <= 1039312) or
					 (nScriptId >= 1039350 and nScriptId <= 1039357) or
					 (nScriptId >= 1039400 and nScriptId <= 1039412) or
					 (nScriptId >= 1039450 and nScriptId <= 1039462) or
					 (nScriptId >= 1039500 and nScriptId <= 1039511) or
					 (nScriptId >= 1039550 and nScriptId <= 1039554) or
					 (nScriptId >= 1039600 and nScriptId <= 1039612) or
					 (nScriptId >= 1009000 and nScriptId <= 1009027) or
					 (nScriptId >= 1009100 and nScriptId <= 1009103) then
		
						-- 使用玩家自己的等级来计算得到的奖励
						nNum = tonumber(Player:GetData("LEVEL") * 18 -101)
					end
	
					QuestLog_Desc:AddMoneyElement(nNum);
				end
			elseif(strType == "exp") then
			QuestLog_Desc:AddTextElement("经验：" .. string.format("%.0f", nNum));
		elseif(strType == "item") then
--				QuestLog_Desc:AddTextElement("固定奖励物品：");
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
			elseif(strType == "itemrand") then
				if (nRand == 1) then
					nRand = 0;
					QuestLog_Desc:AddTextElement("随机奖励物品：");
					local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
					QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
				end
--				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
--				QuestLog_Desc:AddActionElement(ActionID, nNum, 0);
--				QuestLog_Desc:AddItemElement(-1, nNum, 0);
			elseif(strType == "itemradio") then
				bBeingRadio = 1;
				if (nRadio == 1) then
					nRadio = 0;
					QuestLog_Desc:AddTextElement("在下列物品中选择一项作为奖励");
				end
				AxTrace(0, 0, "nItemID:" .. nItemID);
				local ActionID = DataPool:EnumPlayerMission_ItemAction(nItemID);
				AxTrace(0, 0, "ActionID:" .. ActionID);
				QuestLog_Desc:AddActionElement(ActionID,nNum, 0 ,0);
--				QuestLog_Desc:AddItemElement(nItemID, nNum, 1 ,1);
			end
		end
		QuestLog_TrackButtonState();
end

function Abnegate_Quest()
	if(k<1 or QuestLog_Listbox:GetFirstSelectItem() < 0) then
		return;
	end
	if(Current_Select < 100) then
		DataPool : Mission_Abnegate_Popup( Current_Select, DataPool:GetPlayerMission_Memo(Current_Select));
	end
end

function CompareTable(table_a,table_b)
	if table_a[4] < table_b[4] then
		return true
	else
		return false
	end
end

function QuestLog_MissionTrack_Clicked()
	local nCheck = QuestLog_Mode1:GetCheck();  --为点击后的状态
	if (nCheck > 0) then
		OpenWindow("MissionTrack");
		DataPool:SetTrackFuncShow(1, 1);
	else
		CloseWindow("MissionTrack");
		DataPool:SetTrackFuncShow(1, 0);
	end
end

function QuestLog_CampaignTrack_Clicked()
	local nCheck = QuestLog_Mode2:GetCheck();  --为点击后的状态
	if (nCheck > 0) then
		OpenWindow("CampaignTrack");
		DataPool:SetTrackFuncShow(2, 1);
	else
		CloseWindow("CampaignTrack");
		DataPool:SetTrackFuncShow(2, 0);
	end
end

function QuestLog_ShowWindow()
	this:TogleShow();
	local nMissionTrackShow = DataPool:IsTrackFuncShow(1);
	local nCampaignTrackShow = DataPool:IsTrackFuncShow(2);
	if (nMissionTrackShow > 0) then
		QuestLog_Mode1:SetCheck(1);
	else
		QuestLog_Mode1:SetCheck(0);
	end
	if (nCampaignTrackShow > 0) then
		QuestLog_Mode2:SetCheck(1);
	else
		QuestLog_Mode2:SetCheck(0);
	end
end

function QuestLog_TrackButtonState()
	if( 1 ~= CurList ) then
		QuestLog_Refuse:SetText("#{INTERFACE_XML_301}");
		QuestLog_Refuse:Enable();
    	return
	end
	
	local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
	local nCanTrack = DataPool:GetPlayerMissionTrackType(nSelIndex);
	local MissionKind = DataPool:GetPlayerMission_Kind(nSelIndex);
	--关系任务不可追踪
	if (nCanTrack > 0 and MissionKind ~= 10) then
		local nTrackOpen = DataPool:IsMissionTrackOpen(nSelIndex);
		if (nTrackOpen > 0) then	
			QuestLog_Refuse:SetText("取消追踪");
		else
			QuestLog_Refuse:SetText("开始追踪");
		end
		QuestLog_Refuse:Enable();
	else
		QuestLog_Refuse:SetText("不可追踪");
		QuestLog_Refuse:Disable();
	end
end

function QuestLog_TrackCancelOrOpen()
	if( 1 ~= CurList ) then
			--可接任务关闭
			this:Hide();
    	return
	end
	
	local nSelIndex = QuestLog_Listbox:GetFirstSelectItem();
	local nCanTrack = DataPool:GetPlayerMissionTrackType(nSelIndex);
	if (nCanTrack > 0) then
		local nTrackOpen = DataPool:IsMissionTrackOpen(nSelIndex);
		if (nTrackOpen > 0) then	
			DataPool:SetMissionTrackOpen(nSelIndex, 0);
		else
			if (DataPool:IsTrackFuncShow(1) == 0) then
				OpenWindow("MissionTrack");
				DataPool:SetTrackFuncShow(1, 1);
			end
			DataPool:SetMissionTrackOpen(nSelIndex, 1);
		end
		QuestLog_UpdateListbox();
		DataPool:UpdateMissionTrack();
	end
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