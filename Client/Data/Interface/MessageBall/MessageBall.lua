
--最多显示的效果数量
local MESSAGE_BALL_GUIDS = {0,0,0,0,0,0,0,0,0,0,0,0};
local MESSAGE_BALL_BUTTONS = {};

function MessageBall_PreLoad()
	this:RegisterEvent("MSG_BALL_UPDATE");
end

function MessageBall_OnLoad()

	MESSAGE_BALL_BUTTONS[1] = MessageBall_Animate1;
	MESSAGE_BALL_BUTTONS[2] = MessageBall_Animate2;
	MESSAGE_BALL_BUTTONS[3] = MessageBall_Animate3;
	MESSAGE_BALL_BUTTONS[4] = MessageBall_Animate4;
	MESSAGE_BALL_BUTTONS[5] = MessageBall_Animate5;
	MESSAGE_BALL_BUTTONS[6] = MessageBall_Animate6;

end

function MessageBall_OnEvent(event)

	if ( event == "MSG_BALL_UPDATE" ) then
		MsgBallUpadate();
	end
end

function MsgBallUpadate()		

		this:Show();
		
		local szIconName = ""
		local szToolTips = "";
		local i = 0;
		local Rt = 0;
		local RtUint = 0;
		local RtStr = "";
	
		for i=0,5 do
			Rt, szIconName = MsgBall("GetStrAttrByIdx", i, "ICON");
			Rt, szToolTips = MsgBall("GetStrAttrByIdx", i, "TOOLTIP");
			Rt, MESSAGE_BALL_GUIDS[i+1] = MsgBall("GetNumAttrByIdx", i, "GUID");
			if(Rt == 1) then
				MESSAGE_BALL_BUTTONS[i+1]:SetProperty("Animate", szIconName)
				MESSAGE_BALL_BUTTONS[i+1]:SetProperty("MouseHollow","False");
				MESSAGE_BALL_BUTTONS[i+1]:SetToolTip(szToolTips);
				MESSAGE_BALL_BUTTONS[i+1]:Show();			
			else
				MESSAGE_BALL_BUTTONS[i+1]:Hide();
			end

		end
end

function MessageBall_Image1_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[1]);
end

function MessageBall_Image2_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[2]);
end

function MessageBall_Image3_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[3]);
end

function MessageBall_Image4_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[4]);
end

function MessageBall_Image5_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[5]);
end

function MessageBall_Image6_Click()
	MsgBall("OnEventByGuid", MESSAGE_BALL_GUIDS[6]);
end