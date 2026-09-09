--帮战积分
g_ConfraternityCounttabId = 0;
g_ConfraternityCountTankName ={"无战车","#{INTERFACE_XML_1239}","#{INTERFACE_XML_1240}","#{INTERFACE_XML_1241}","#{INTERFACE_XML_1242}","#{INTERFACE_XML_1243}"};
function ConfraternityCount_PreLoad()
	this:RegisterEvent("OPEN_GUILDBATTLE_SCORE");	
end

function ConfraternityCount_OnLoad()
	ConfraternityCount_SelectTab(0);
	ConfraternityCount_Update(0);
end

function ConfraternityCount_OnEvent(event)
	if ( event == "OPEN_GUILDBATTLE_SCORE") then
		if(arg0 == "hide") then
			this:Hide();
		elseif(arg0 == "show")then
			this:Show();
			ConfraternityCount_SelectTab(g_ConfraternityCounttabId);
		end
	end
end

function ConfraternityCount_SelectTab( idx )
	if(idx == nil or idx < 0 or idx > 2) then
		return;
	end	
	g_ConfraternityCounttabId = idx;
	if(idx == 0) then
		ConfraternityCount_Zhanche_Text1	: Hide();
		ConfraternityCount_Zhanche_Text2	: Hide();
		ConfraternityCount_Zhanche_Text3	: Hide();
		ConfraternityCount_Zhanche_Text4	: Hide();
			
		ConfraternityCount_Current 	: SetText("#{INTERFACE_XML_1215}");	
		ConfraternityCount_Text1		: SetText("#{INTERFACE_XML_1217}");
		ConfraternityCount_Text2		: SetText("#{INTERFACE_XML_1218}");
		ConfraternityCount_Text3		: SetText("#{INTERFACE_XML_1219}");
		ConfraternityCount_Text4		: SetText("#{INTERFACE_XML_1220}");
		ConfraternityCount_Text5		: SetText("#{INTERFACE_XML_1221}");
		
		ConfraternityCount_Max 			: SetText("#{INTERFACE_XML_1216}");
		ConfraternityCount_Text6		: SetText("#{INTERFACE_XML_1222}");
		ConfraternityCount_Text7		: SetText("#{INTERFACE_XML_1223}");
		ConfraternityCount_Text8		: SetText("#{INTERFACE_XML_1224}");
		ConfraternityCount_Text9		: SetText("#{INTERFACE_XML_1225}");
		ConfraternityCount_Text10		: SetText("#{INTERFACE_XML_1226}");
			
		ConfraternityCount_Text1		: Show();
		ConfraternityCount_Text2		: Show();
		ConfraternityCount_Text3		: Show();
		ConfraternityCount_Text4		: Show();
		ConfraternityCount_Text5		: Show();
		ConfraternityCount_Text6		: Show();
		ConfraternityCount_Text7		: Show();
		ConfraternityCount_Text8		: Show();
		ConfraternityCount_Text9		: Show();
		ConfraternityCount_Text10		: Show();
		ConfraternityCount_PersonScore		: Show();
		ConfraternityCount_PersonKill			: Show();
		ConfraternityCount_PersonRes			: Show();
		ConfraternityCount_PersonBuilding	: Show();
		ConfraternityCount_PersonFlag			: Show();
		ConfraternityCount_MaxScore				: Show();
		ConfraternityCount_MaxKill				: Show();
		ConfraternityCount_MaxRes					: Show();
		ConfraternityCount_MaxBuilding		: Show();
		ConfraternityCount_MaxFlag				: Show();
	elseif(idx == 1) then
		ConfraternityCount_Zhanche_Text1	: Hide();
		ConfraternityCount_Zhanche_Text2	: Hide();
		ConfraternityCount_Zhanche_Text3	: Hide();
		ConfraternityCount_Zhanche_Text4	: Hide();
		
		ConfraternityCount_Current : SetText("#{INTERFACE_XML_1227}");
		ConfraternityCount_Text1		: SetText("#{INTERFACE_XML_1228}");
		ConfraternityCount_Text2		: SetText("#{INTERFACE_XML_1229}");
		ConfraternityCount_Text3		: SetText("#{INTERFACE_XML_1230}");
		ConfraternityCount_Text4		: SetText("#{INTERFACE_XML_1231}");
		ConfraternityCount_Text5		: SetText("#{INTERFACE_XML_1232}");
		
		ConfraternityCount_Max 			: SetText("#{INTERFACE_XML_1233}");
		ConfraternityCount_Text6		: SetText("#{INTERFACE_XML_1234}");
		ConfraternityCount_Text7		: SetText("#{INTERFACE_XML_1235}");
		ConfraternityCount_Text8		: SetText("#{INTERFACE_XML_1236}");
		ConfraternityCount_Text9		: SetText("#{INTERFACE_XML_1237}");
		ConfraternityCount_Text10		: SetText("#{INTERFACE_XML_1238}");
			
		ConfraternityCount_Text1		: Show();
		ConfraternityCount_Text2		: Show();
		ConfraternityCount_Text3		: Show();
		ConfraternityCount_Text4		: Show();
		ConfraternityCount_Text5		: Show();
		ConfraternityCount_Text6		: Show();
		ConfraternityCount_Text7		: Show();
		ConfraternityCount_Text8		: Show();
		ConfraternityCount_Text9		: Show();
		ConfraternityCount_Text10		: Show();
		ConfraternityCount_PersonScore		: Show();
		ConfraternityCount_PersonKill			: Show();
		ConfraternityCount_PersonRes			: Show();
		ConfraternityCount_PersonBuilding	: Show();
		ConfraternityCount_PersonFlag			: Show();
		ConfraternityCount_MaxScore				: Show();
		ConfraternityCount_MaxKill				: Show();
		ConfraternityCount_MaxRes					: Show();
		ConfraternityCount_MaxBuilding		: Show();
		ConfraternityCount_MaxFlag				: Show();
	elseif(idx == 2) then
		ConfraternityCount_Current : SetText("#{INTERFACE_XML_1227}");
		ConfraternityCount_Text1		: Hide();
		ConfraternityCount_Text2		: Hide();
		ConfraternityCount_Text3		: Hide();
		ConfraternityCount_Text4		: Hide();
		ConfraternityCount_Text5		: Hide();
		
		ConfraternityCount_Max 			: SetText("#{INTERFACE_XML_1233}");
		ConfraternityCount_Text6		: Hide();
		ConfraternityCount_Text7		: Hide();
		ConfraternityCount_Text8		: Hide();
		ConfraternityCount_Text9		: Hide();
		ConfraternityCount_Text10		: Hide();
			
		ConfraternityCount_PersonScore		: Hide();
		ConfraternityCount_PersonKill			: Hide();
		ConfraternityCount_PersonRes			: Hide();
		ConfraternityCount_PersonBuilding	: Hide();
		ConfraternityCount_PersonFlag			: Hide();
		ConfraternityCount_MaxScore				: Hide();
		ConfraternityCount_MaxKill				: Hide();
		ConfraternityCount_MaxRes					: Hide();
		ConfraternityCount_MaxBuilding		: Hide();
		ConfraternityCount_MaxFlag				: Hide();
			
		ConfraternityCount_Zhanche_Text1	: Show();
		ConfraternityCount_Zhanche_Text2	: Show();
		ConfraternityCount_Zhanche_Text3	: Show();
		ConfraternityCount_Zhanche_Text4	: Show();
	end
	ConfraternityCount_Update(idx);
end

function ConfraternityCount_Update(idx)
	if(idx == nil or idx < 0 or idx > 2) then
		return;
	end
	
	if(idx == 0) then
		ConfraternityCount_PersonScore 		: SetText(tostring(City : GetGuildBattleScore("PersonScore")));
		ConfraternityCount_PersonKill 		: SetText(tostring(City : GetGuildBattleScore("PersonKill")));
		ConfraternityCount_PersonRes 			: SetText(tostring(City : GetGuildBattleScore("PersonRes")));
		ConfraternityCount_PersonBuilding : SetText(tostring(City : GetGuildBattleScore("PersonBuilding")));
		ConfraternityCount_PersonFlag 		: SetText(tostring(City : GetGuildBattleScore("PersonFlag")));
		ConfraternityCount_MaxScore 			: SetText(tostring(City : GetGuildBattleScore("MaxScore")));
		ConfraternityCount_MaxKill 				: SetText(tostring(City : GetGuildBattleScore("MaxKill")));
		ConfraternityCount_MaxRes 				: SetText(tostring(City : GetGuildBattleScore("MaxRes")));
		ConfraternityCount_MaxBuilding 		: SetText(tostring(City : GetGuildBattleScore("MaxBuilding")));
		ConfraternityCount_MaxFlag 				: SetText(tostring(City : GetGuildBattleScore("MaxFlag")));
	elseif(idx ==1) then
		ConfraternityCount_PersonScore 		: SetText(tostring(City : GetGuildBattleScore("GuildScore")));
		ConfraternityCount_PersonKill 		: SetText(tostring(City : GetGuildBattleScore("GuildKill")));
		ConfraternityCount_PersonRes 			: SetText(tostring(City : GetGuildBattleScore("GuildRes")));
		ConfraternityCount_PersonBuilding : SetText(tostring(City : GetGuildBattleScore("GuildBuilding")));
		ConfraternityCount_PersonFlag 		: SetText(tostring(City : GetGuildBattleScore("GuildFlag")));
		ConfraternityCount_MaxScore 			: SetText(tostring(City : GetGuildBattleScore("EnemyScore")));
		ConfraternityCount_MaxKill 				: SetText(tostring(City : GetGuildBattleScore("EnemyKill")));
		ConfraternityCount_MaxRes 				: SetText(tostring(City : GetGuildBattleScore("EnemyRes")));
		ConfraternityCount_MaxBuilding 		: SetText(tostring(City : GetGuildBattleScore("EnemyBuilding")));
		ConfraternityCount_MaxFlag 				: SetText(tostring(City : GetGuildBattleScore("EnemyFlag")));
	elseif(idx == 2) then
		local nTankType1 = City : GetGuildBattleScore("TankType1"); 
		if(nTankType1 >= 0 and nTankType1 < 6 ) then
			ConfraternityCount_Zhanche_Text1	: SetText(g_ConfraternityCountTankName[nTankType1 + 1]);
		else
			ConfraternityCount_Zhanche_Text1	: SetText(g_ConfraternityCountTankName[1]);
		end
		
		local nTankType2 = City : GetGuildBattleScore("TankType2"); 
		if(nTankType2 >= 0 and nTankType2 < 6 ) then
			ConfraternityCount_Zhanche_Text2	: SetText(g_ConfraternityCountTankName[nTankType2 + 1]);
		else
			ConfraternityCount_Zhanche_Text2	: SetText(g_ConfraternityCountTankName[1]);
		end
		
		local nTankType3 = City : GetGuildBattleScore("TankType3"); 
		if(nTankType3 >= 0 and nTankType3 < 6 ) then
			ConfraternityCount_Zhanche_Text3	: SetText(g_ConfraternityCountTankName[nTankType3 + 1]);
		else
			ConfraternityCount_Zhanche_Text3	: SetText(g_ConfraternityCountTankName[1]);
		end
		
		local nTankType4 = City : GetGuildBattleScore("TankType4"); 
		if(nTankType4 >= 0 and nTankType4 < 6 ) then
			ConfraternityCount_Zhanche_Text4	: SetText(g_ConfraternityCountTankName[nTankType4 + 1]);
		else
			ConfraternityCount_Zhanche_Text4	: SetText(g_ConfraternityCountTankName[1]);
		end
	end
end