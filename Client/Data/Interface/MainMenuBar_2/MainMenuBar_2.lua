
local MAIN_2_BUTTONS = {};
local MAIN_2_BUTTON_NUM = 10;

local MAIN_2_ANIMATES = {};
local MAIN_2_ANIMATE_NUM = 10;

function MainMenuBar_2_PreLoad()
	this:RegisterEvent("OPEN_MENUBAR_2");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
	this:RegisterEvent("ACTION_UPDATE");
end

function MainMenuBar_2_OnLoad()
	MAIN_2_BUTTONS[31] = MainMenuBar_2_Button_Action1
	MAIN_2_BUTTONS[32] = MainMenuBar_2_Button_Action2
	MAIN_2_BUTTONS[33] = MainMenuBar_2_Button_Action3
	MAIN_2_BUTTONS[34] = MainMenuBar_2_Button_Action4
	MAIN_2_BUTTONS[35] = MainMenuBar_2_Button_Action5
	MAIN_2_BUTTONS[36] = MainMenuBar_2_Button_Action6
	MAIN_2_BUTTONS[37] = MainMenuBar_2_Button_Action7
	MAIN_2_BUTTONS[38] = MainMenuBar_2_Button_Action8
	MAIN_2_BUTTONS[39] = MainMenuBar_2_Button_Action9
	MAIN_2_BUTTONS[40] = MainMenuBar_2_Button_Action10
	
	MAIN_2_ANIMATES[31] = MainMenuBar_2_Button_Action1_Mask
	MAIN_2_ANIMATES[32] = MainMenuBar_2_Button_Action2_Mask
	MAIN_2_ANIMATES[33] = MainMenuBar_2_Button_Action3_Mask
	MAIN_2_ANIMATES[34] = MainMenuBar_2_Button_Action4_Mask
	MAIN_2_ANIMATES[35] = MainMenuBar_2_Button_Action5_Mask
	MAIN_2_ANIMATES[36] = MainMenuBar_2_Button_Action6_Mask
	MAIN_2_ANIMATES[37] = MainMenuBar_2_Button_Action7_Mask
	MAIN_2_ANIMATES[38] = MainMenuBar_2_Button_Action8_Mask
	MAIN_2_ANIMATES[39] = MainMenuBar_2_Button_Action9_Mask
	MAIN_2_ANIMATES[40] = MainMenuBar_2_Button_Action10_Mask
end


-- OnEvent
function MainMenuBar_2_OnEvent(event)
	if ( event == "OPEN_MENUBAR_2" ) then
		
		AxTrace(0,0,"OPEN_MENUBAR_2" .. arg0)
			
		if arg0 == "1" then
			this:Show()
			MainMenuBar_2_PlayAnimate()
		else
			this:Hide()
		end
		-- 显示经验
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		
		AxTrace(0,0,"arg1 =" .. tostring(arg1))
	
		if( tonumber(arg1) >= 31 and tonumber(arg1) <41 )  then
			local nIndex = tonumber(arg1) ;

			MAIN_2_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			MAIN_2_BUTTONS[nIndex]:Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
				
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
				
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							MAIN_2_BUTTONS[nIndex]:Bright();
					else
							MAIN_2_BUTTONS[nIndex]:Gloom();
					end
				end
			end
		end
		
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		-- MainMenuBar_2_AdjustMoveCtl(arg0, arg1);
	elseif( event == "ACTION_UPDATE" ) then
		MainMenuBar_2_NewSkillStudy();
	end
	
end

function MainMenuBar_2_NewSkillStudy()
	for j=1,10 do
		MAIN_2_BUTTONS[j+30]:SetNewFlash();
	end
end

function MainMenuBar_2_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		MAIN_2_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("你不能这么做。")
		return;
	end
end

function MainMenuBar_2_AdjustMoveCtl( screenWidth, screenHeight )
	local currWidth = MainMenuBar_2_Frame:GetProperty("AbsoluteWidth");
	if(tonumber(screenWidth) < 1080) then
		MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.5,-" .. tonumber(currWidth)/2 .. "}");
	else
		MainMenuBar_2_Frame:SetProperty("UnifiedXPosition", "{0.0,546}"); --297+207
	end
end

function MainMenuBar_2_PlayAnimate()
	for j=1,10 do
		MAIN_2_ANIMATES[j+30]:Show();
		MAIN_2_ANIMATES[j+30]:Play(true);
	end
end