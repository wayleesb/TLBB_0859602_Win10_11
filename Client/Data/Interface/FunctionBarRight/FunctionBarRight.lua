
local RIGHTBAR_BUTTONS = {};
local RIGHTBAR_BUTTON_NUM = 9;


function FunctionBarRight_PreLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");
	this:RegisterEvent("CHANGE_BAR");
	this:RegisterEvent("ACTION_UPDATE");

end

function FunctionBarRight_OnLoad()
	RIGHTBAR_BUTTONS[41] = FunctionBarRight_Button_Action1;
	RIGHTBAR_BUTTONS[42] = FunctionBarRight_Button_Action2;
	RIGHTBAR_BUTTONS[43] = FunctionBarRight_Button_Action3;
	RIGHTBAR_BUTTONS[44] = FunctionBarRight_Button_Action4;
	RIGHTBAR_BUTTONS[45] = FunctionBarRight_Button_Action5;
	RIGHTBAR_BUTTONS[46] = FunctionBarRight_Button_Action6;
	RIGHTBAR_BUTTONS[47] = FunctionBarRight_Button_Action7;
	RIGHTBAR_BUTTONS[48] = FunctionBarRight_Button_Action8;
	RIGHTBAR_BUTTONS[49] = FunctionBarRight_Button_Action9;
end


-- OnEvent
function FunctionBarRight_OnEvent(event)
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		this:Show();
		-- 显示经验
	elseif( event == "CHANGE_BAR" and arg0 == "main") then
		if( tonumber(arg1) > 40 and tonumber(arg1) <50 )  then
			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			local nIndex = tonumber(arg1) ;

			--AxTrace(0,0,"arg1= ".. arg1 .. "arg2 =" .. arg2)
			RIGHTBAR_BUTTONS[nIndex]:SetActionItem(tonumber(arg2));
			RIGHTBAR_BUTTONS[nIndex] : Bright();
			
			if arg3~=nil then
				
				local pet_num = tonumber(arg3);
				
				if pet_num >= 0 and pet_num < 6 then
					AxTrace(0,1,"nIndex="..nIndex .." pet_num="..pet_num)
					if Pet : IsPresent(pet_num) and Pet : GetIsFighting(pet_num) then
							RIGHTBAR_BUTTONS[nIndex] : Bright();
					else
							RIGHTBAR_BUTTONS[nIndex] : Gloom();
					end
						
				end
				
			end
			
		end
	elseif( event == "ACTION_UPDATE" ) then
		FunctionBarRight_ActionUpdate();
	end
	
	end
function FunctionBarRight_ActionUpdate()
	for j=1,9 do
		RIGHTBAR_BUTTONS[j+40]:SetNewFlash();
	end
end

function FunctionBarRight_Clicked(nIndex)
	if DataPool:IsCanDoAction() then
		
		RIGHTBAR_BUTTONS[nIndex]:DoAction();
	else
		PushDebugMessage("你不能这么做。")
		return;
	end
end