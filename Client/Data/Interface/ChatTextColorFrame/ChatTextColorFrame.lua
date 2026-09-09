local g_AllColor = {};
local g_AllWindow = {};
function ChatTextColorFrame_PreLoad()
	this:RegisterEvent("CHAT_TEXTCOLOR_SELECT");
	this:RegisterEvent("CHAT_ADJUST_MOVE_CTL");
end
	
function ChatTextColorFrame_OnLoad()
	g_AllColor = {
		"K",		"cFF0000",	"G",		"c0000FF",	"Y",		"W",		"ccccccc",	"cff99cc",
		"cffcccc",	"cffcc00",	"cffcc88",	"c33ffcc",	"c66ffff",	"c66ccff",	"cff99ff",	"c00ffff",
		"c6699ff",	"c993366",	"cff6633",	"c33ff99",	"c33cc99",	"c66cccc",	"c0066ff",	"ccc33cc",
		"c993333",	"cff9900",	"cff9966",	"c999933",	"c009933",	"c009966",	"c9966cc",	"c996666",
		"c666600",	"c333366",	"c330066",	"c333399",	"cff66cc",	"ccccc66",	"c0000cc",	"ccc6699",
	};
	 g_AllWindow = { 
		Color_1,  Color_2,  Color_3, Color_4, Color_5,  Color_6, Color_7, Color_8,
		Color_9,  Color_10, Color_11,Color_12,Color_13, Color_14,Color_15,Color_16,
		Color_17, Color_18, Color_19,Color_20,Color_21, Color_22,Color_23,Color_24,
		Color_25, Color_26, Color_27,Color_28,Color_29, Color_30,Color_31,Color_32,
		Color_33, Color_34, Color_35,Color_36,Color_37, Color_38,Color_39,Color_40,
		}
	
	for i = 1, 40 do
		
		g_AllWindow[i]:SetToolTip("##"..tostring( g_AllColor[ i ] ) );
	end
end

function ChatTextColorFrame_OnEvent( event )
	if( event == "CHAT_TEXTCOLOR_SELECT" and arg0 == "select") then
		if(this:IsVisible() or this:ClickHide()) then
			this:Hide();
		else
			this:Show();
			local x;
			local y;
			ChatTextColorFrame_ChangePosition(arg1,arg2);
		end
	elseif (event == "CHAT_ADJUST_MOVE_CTL" and this:IsVisible()) then
		ChatTextColorFrame_AdjustMoveCtl();
	end
end

function ChatTextColorFrame_SelectColor(nIndex)
	
	local strResult = "#" .. g_AllColor[ nIndex ];
	
	if("#nil" == strResult) then
		strResult = "#W";
	end
	Talk:SelectTextColor("sucess", strResult);
end

function ChatTextColorFrame_AdjustMoveCtl()
	this:Hide();
end

function ChatTextColorFrame_ChangePosition(pos1,pos2)
	if(tonumber(pos1)~=0) then
		TextEditor_Frame:SetProperty("UnifiedXPosition", "{0.0,"..pos1.."}");
	end;
	if(tonumber(pos2)~=0) then
		TextEditor_Frame:SetProperty("UnifiedYPosition", "{0.0,"..pos2.."}");
	end;
end