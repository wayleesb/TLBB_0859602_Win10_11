
local MAIN_3_BUTTONS = {};
local MAIN_3_BUTTON_NUM = 2;

local MAIN_3_ANIMATES = {};
local MAIN_3_ANIMATE_NUM = 2;

local gWidth = 356;
function MainMenuBar_3_PreLoad()
	this:RegisterEvent("CHANGE_PETSKILL_BAR");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end

function MainMenuBar_3_OnLoad()
	MAIN_3_BUTTONS[1] = MainMenuBar_3_Button_Action1
	MAIN_3_BUTTONS[2] = MainMenuBar_3_Button_Action2
	
	MAIN_3_ANIMATES[1] = MainMenuBar_3_Button_Action1_Mask
	MAIN_3_ANIMATES[2] = MainMenuBar_3_Button_Action2_Mask
end


-- OnEvent
function MainMenuBar_3_OnEvent(event)
	if ( event == "CHANGE_PETSKILL_BAR" ) then
		local count =Pet:GetPetSkillBarItemCount();
		this:Hide();
		if(count <=0)then
			--
		else
			if(count >MAIN_3_BUTTON_NUM)then
				count = MAIN_3_BUTTON_NUM
			end
			local idx = 1;
			for i=0,count-1 do
				local act = Pet:EnumPetSkillBarItem(tonumber(i));
				if act:GetID() ~= 0 then
					MAIN_3_BUTTONS[idx]:SetActionItem(act:GetID());
					idx = idx +1;
					if(idx>MAIN_3_BUTTON_NUM)then
						break;
					end
				end
			end
			if(idx>1)then
				this:Show()
				MainMenuBar_3_ShowItems(idx-1);
				MainMenuBar_3_PlayAnimate(idx-1);				
			end
		end
	elseif (event == "CHAT_ADJUST_MOVE_CTL") then
		-- MainMenuBar_3_AdjustMoveCtl(arg0, arg1);
	end
	
end

function MainMenuBar_3_AdjustMoveCtl( screenWidth, screenHeight )
	if(tonumber(screenWidth) < 1080) then
		MainMenuBar_3_Frame:SetProperty("UnifiedXPosition", "{0.5," .. (tonumber(gWidth)/2+4) .. "}");
	else
		MainMenuBar_3_Frame:SetProperty("UnifiedXPosition", "{0.0,"..(tonumber(gWidth)+4+546).."}"); --297+207+356+4
	end
end

function MainMenuBar_3_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		MAIN_3_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("你不能这么做。")
		return;
	end
end

function MainMenuBar_3_PlayAnimate(idx)
	for j=1,MAIN_3_ANIMATE_NUM do
		if(j<=idx)then
			MAIN_3_ANIMATES[j]:Show();
			MAIN_3_ANIMATES[j]:Play(true);
		else
			MAIN_3_ANIMATES[j]:Hide();
		end
	end
end

function MainMenuBar_3_ShowItems(idx)
	for j=1,MAIN_3_BUTTON_NUM do
		if(j<=idx)then
			MAIN_3_BUTTONS[j]:Show();
		else
			MAIN_3_BUTTONS[j]:Hide();
		end
	end
end

