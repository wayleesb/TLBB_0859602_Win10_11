local g_AllAnimate = {};

function ChatFaceFrame_PreLoad()
	this:RegisterEvent("CHAT_FACEMOTION_SELECT");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end

function ChatFaceFrame_OnLoad()
	g_AllAnimate = {
		Face_1,	Face_2,	Face_3,	Face_4,	Face_5,	Face_6,	Face_7,	Face_8,
		Face_9,	Face_10,Face_11,Face_12,Face_13,Face_14,Face_15,Face_16,
		Face_17,Face_18,Face_19,Face_20,Face_21,Face_22,Face_23,Face_24,
		Face_25,Face_26,Face_27,Face_28,Face_29,Face_30,Face_31,Face_32,
		Face_33,Face_34,Face_35,Face_36,Face_37,Face_38,Face_39,Face_40,
		Face_41,Face_42,Face_43,Face_44,Face_45,Face_46,Face_47,Face_48,
		Face_49,Face_50,Face_51,Face_52,Face_53,Face_54,Face_55,Face_56,
		Face_57,Face_58,Face_59,Face_60,Face2_1,Face2_2,Face2_3,Face2_4,
                Face2_5,Face2_6,Face2_7,Face2_8,Face2_9,Face2_10,Face2_11,Face2_12,
                Face2_13,Face2_14,Face2_15,Face2_16,Face2_17,Face2_18,Face2_19,Face2_20,
		Face2_21,Face2_22,Face2_23,Face2_24,Face2_25,Face2_26,Face2_27,Face2_28,
		Face2_29,Face2_30,Face2_31,Face2_32,Face2_33,Face2_34,Face2_35,Face2_36,
		Face2_37,Face2_38,Face2_39,Face2_40
	};
	
	for i = 1, table.getn(g_AllAnimate) do
		g_AllAnimate[i]:SetToolTip("##"..tostring(i));
	end
end

function ChatFaceFrame_OnEvent( event )
	if( event == "CHAT_FACEMOTION_SELECT" and arg0 == "select") then
		if(this:IsVisible() or this:ClickHide())then
			this:Hide();
		else
			this:Show();
			Chat_FaceFrame_ChangePosition(arg1,arg2);		
		end
	elseif (event == "CHAT_ADJUST_MOVE_CTL" and this:IsVisible()) then
		Chat_FaceFrame_AdjustMoveCtl();
	end
end

function Chat_FaceFrame_SelectMotion(nIndex)
	--AxTrace(0, 0, "click Chat_FaceFrame_SelectMotion");
	if(1 > nIndex) then
		return;
	end
	
	local strResult = "#" .. tostring(nIndex);
	Talk:SelectFaceMotion("sucess", strResult);
end

function Chat_FaceFrame_AdjustMoveCtl()
	this:Hide();
end

function Chat_FaceFrame_ChangePosition(pos1,pos2)


	if(tonumber(pos1)~=0) then
		Face_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos1.."}");
	end;
	if(tonumber(pos2)~=0) then
		Face_Frame:SetProperty("UnifiedYPosition", "{0.0,"..pos2.."}");
	end;
end