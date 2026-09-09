
function Evaluate_PreLoad()
    this:RegisterEvent("OPEN_EVALUATE")
end

function Evaluate_OnLoad()
end

--=========================================================
-- 事件处理
--=========================================================
function Evaluate_OnEvent(event)
    
    --Player:GetData( "LEVEL" )
    
    local strMasterName = GetMasterName()
--WorldReference_PageHeader:SetText("#{INTERFACE_XML_39}")
    Evaluate_DragTitle:SetText( "#{UI_EVALUATE_TEXT000}" )
    Evaluate_WarningText:SetText( "#{UI_EVALUATE_TEXT001}".."#G"..strMasterName.."#Y#{UI_EVALUATE_TEXT002}" )
    Evaluate_Answer1:SetText( "#{UI_EVALUATE_TEXT003}" )
    Evaluate_Answer2:SetText( "#{UI_EVALUATE_TEXT004}" )
    Evaluate_Answer3:SetText( "#{UI_EVALUATE_TEXT005}" )
    
    if 	"OPEN_EVALUATE" == event then
        this:Show()
    end
    
end

--=========================================================
-- 关闭相应
--=========================================================
function Evaluate_Close()
end

--=========================================================
-- 显示任务列表
--=========================================================
function Evaluate_EventListUpdate()
end

--=========================================================
-- 显示任务信息
--=========================================================
function Evaluate_EvaluateInfoUpdate()
end

--=========================================================
--Continue任务的对话框
--=========================================================
function Evaluate_MissionContinueUpdate(bDone)
end

--=========================================================
--收取奖励物品的对话框
--=========================================================
function Evaluate_MissionRewardUpdate()
end

--=========================================================
-- 选择一个任务
--=========================================================
function EvaluateOption_Clicked()
end

--=========================================================
--开始关心NPC，
--在开始关心之前需要先确定这个界面是不是已经有“关心”的NPC，
--如果有的话，先取消已经有的“关心”
--=========================================================
function BeginCareObject_Evaluate(objCaredId)
end

--=========================================================
--停止对某NPC的关心
--=========================================================
function StopCareObject_Evaluate(objCaredId)
end

function Evaluate_Answer1_OnClicked()
    AskLevelUp( 1 )
    this:Hide()
end
function Evaluate_Answer2_OnClicked()
    AskLevelUp( 2 )
    this:Hide()
end
function Evaluate_Answer3_OnClicked()
    AskLevelUp( 3 )
    this:Hide()
end
