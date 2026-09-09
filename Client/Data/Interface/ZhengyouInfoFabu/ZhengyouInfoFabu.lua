-- 征友平台 : 发布信息，管理信息，撤销信息等的选择界面 cuiyinjie 2008.10.23

local g_strWndName = "ZhengyouInfoFabu";

local g_dlgctrls = {}; --控件集合

-- 对话框选项
local dlgoptions = { "fabu",  "chexiao", "guanli",};

-- 对话框标题
local strDlgCaptions = {"#{ZYPT_081103_056}", "#{ZYPT_081103_067}", "#{ZYPT_081103_072}"}; --{"发布信息", "撤销信息", "管理信息",};

-- 对话框提示文本
local strDlgText = {
	"#{ZYPT_081103_057}", --"请选择你要发布的类型：                （注意：同一类型的信息在同一时间内只能发布一条。）",
	"#{ZYPT_081103_102}",--"请选择您要撤销的信息类型：",
	"#{ZYPT_081103_103}",--"请选择您要管理的信息类型：",
};

-- 当前操作状态
local g_OperationStatus = 4;     -- 参见PlayerZhengyouPT.lua里关于查询，管理等的定义

-- 当前选择的类型
local g_curSelType = 1;

function ZhengyouInfoFabu_PreLoad()
	this:RegisterEvent("OPEN_WINDOW");
	this:RegisterEvent("CLOSE_WINDOW");
end

function ZhengyouInfoFabu_OnLoad()
   Initg_dlgctrls();
   g_dlgctrls.OptBtns[1]:SetCheck(1);
   --<Property Name="AlwaysOnTop" Value="True" />
   ZhengyouInfoFabu_Frame:SetProperty("AlwaysOnTop","True");
end

function Initg_dlgctrls()
   g_dlgctrls = {
		Caption = ZhengyouInfoFabu_DragTitle,
		DlgText = ZhengyouInfoFabuTishi,
		OptBtns = {
		                ZhengyouInfoFabu_BtnCheck_Type1,
		                ZhengyouInfoFabu_BtnCheck_Type2,
		                ZhengyouInfoFabu_BtnCheck_Type3,
		                ZhengyouInfoFabu_BtnCheck_Type4,
				  },
   };
end

function ZhengyouInfoFabu_OnEvent(event)

	if(event == "OPEN_WINDOW") then
		ZhengyouInfoFabu_OnOpen( arg0 );

	elseif(event == "CLOSE_WINDOW") then
		if( arg0 == "ZhengyouInfoFabu") then
			this:Hide();
		end	
	end

end

function ZhengyouInfoFabu_GetSelectFriendType()
  local i = 1;
  for i = 1, 4 do
    if ( 1 == g_dlgctrls.OptBtns[i]:GetCheck() ) then
      return i;
		end
  end
  return 0;
end

function ZhengyouInfoFabu_Choose_Click()
 
	-- 发送具体查询请求
	local curSel = ZhengyouInfoFabu_GetSelectFriendType();
	if ( 0 == curSel ) then
	   PushDebugMessage("#{ZYPT_081103_104}"); --("请选择征友类型");
	   return;
	end
    g_curSelType = curSel;

	-- 发布，管理，撤销都要经服务器验证
	FindFriendQuery(g_OperationStatus, g_curSelType);
	
	this:Hide();
end

-- 注意： 只有窗口名符合的才是这个窗口，所以默认选中第一项放循环里了，放外边会导致打开别的窗口时此窗口也选择第一项 
function ZhengyouInfoFabu_OnOpen(strOpt)
	local i = 1;

  for i = 1, 3 do
     if( strOpt == g_strWndName .. "_" .. dlgoptions[i] ) then
     	 CloseWindow("ZhengyouSearch");
     	 CloseWindow("ZhengyouYaoqiu");
     	 CloseWindow("VotedPlayer");
        this:Show();
        g_dlgctrls.Caption:SetText(strDlgCaptions[i]);
        g_dlgctrls.DlgText:SetText(strDlgText[i]);
        g_OperationStatus = i + 3;
        
       -- 默认选中第一项
  		 for i = 1, 4 do
       	if (1 == i) then
  				g_dlgctrls.OptBtns[i]:SetCheck(1);
		else
	    	g_dlgctrls.OptBtns[i]:SetCheck(0);
		end
  		 end
  		--      
        break;
     end
  end
end


function ZhengyouInfoFabu_Close_Click()
   this:Hide();
end

function ZhengyouInfoFabu_BtnCheck_OnClicked(iType)
   local i = 1;
   for i = 1, 4 do
        if (iType == i) then
   			g_dlgctrls.OptBtns[i]:SetCheck(1);
		else
		    g_dlgctrls.OptBtns[i]:SetCheck(0);
		end
   end
end