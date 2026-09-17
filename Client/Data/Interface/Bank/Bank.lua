-- 八箱仓库视图；只刷新可见窗口，关闭时清理物品 Action 和 NPC 关注。
local GRID_BUTTONS = {};
local PACK_BUTTONS = {};
local GRID_SETS = {};
local CLOSED_SETS = {};
local g_Active = false;
local g_ObjCared = -1;
local g_CurrentRentBox = 1;
local g_DefaultPosition;

function Bank_PreLoad()
    this:RegisterEvent("TOGLE_BANK");
    this:RegisterEvent("UPDATE_BANK");
    this:RegisterEvent("PACKAGE_ITEM_CHANGED");
    this:RegisterEvent("OBJECT_CARED_EVENT");
    this:RegisterEvent("PLAYER_LEAVE_WORLD");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("ON_SCENE_TRANS");
    this:RegisterEvent("ON_SERVER_TRANS");
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function Bank_OnLoad()
    GRID_BUTTONS[1] = Bank_Item1;
    GRID_BUTTONS[2] = Bank_Item2;
    GRID_BUTTONS[3] = Bank_Item3;
    GRID_BUTTONS[4] = Bank_Item4;
    GRID_BUTTONS[5] = Bank_Item5;
    GRID_BUTTONS[6] = Bank_Item6;
    GRID_BUTTONS[7] = Bank_Item7;
    GRID_BUTTONS[8] = Bank_Item8;
    GRID_BUTTONS[9] = Bank_Item9;
    GRID_BUTTONS[10] = Bank_Item10;
    GRID_BUTTONS[11] = Bank_Item11;
    GRID_BUTTONS[12] = Bank_Item12;
    GRID_BUTTONS[13] = Bank_Item13;
    GRID_BUTTONS[14] = Bank_Item14;
    GRID_BUTTONS[15] = Bank_Item15;
    GRID_BUTTONS[16] = Bank_Item16;
    GRID_BUTTONS[17] = Bank_Item17;
    GRID_BUTTONS[18] = Bank_Item18;
    GRID_BUTTONS[19] = Bank_Item19;
    GRID_BUTTONS[20] = Bank_Item20;
    PACK_BUTTONS[1] = Bank_patulousBox_1;
    PACK_BUTTONS[2] = Bank_patulousBox_2;
    PACK_BUTTONS[3] = Bank_patulousBox_3;
    PACK_BUTTONS[4] = Bank_patulousBox_4;
    PACK_BUTTONS[5] = Bank_patulousBox_5;
    PACK_BUTTONS[6] = Bank_patulousBox_6;
    PACK_BUTTONS[7] = Bank_patulousBox_7;
    PACK_BUTTONS[8] = Bank_patulousBox_8;
    g_DefaultPosition = Bank_Frame:GetProperty("UnifiedPosition");
    Bank_ClearActions();
end

function Bank_ClearActions()
    for i = 1, 20 do
        GRID_BUTTONS[i]:SetActionItem(-1);
        GRID_BUTTONS[i]:SetPushed(0);
        GRID_BUTTONS[i]:SetProperty("DragAcceptName", "");
        GRID_BUTTONS[i]:Disable();
    end
    for i = 1, 8 do
        PACK_BUTTONS[i]:SetPushed(0);
        PACK_BUTTONS[i]:SetProperty("DragAcceptName", "");
        PACK_BUTTONS[i]:Disable();
    end
end

function Bank_OnEvent(event)
    if event == "TOGLE_BANK" then
        if IsWindowShow("BigBank") then
            CloseWindow("BigBank", true);
        end
        if g_Active then
            Bank_Close_Clicked();
        end
        this:Show();
        g_Active = true;
        g_ObjCared = Bank:GetNpcId();
        this:CareObject(g_ObjCared, 1, "Bank");
        Bank:SetOpenWhichBank(0);
        g_CurrentRentBox = 1;
        Bank_UpdateFrame(g_CurrentRentBox);
    elseif event == "UPDATE_BANK" or event == "PACKAGE_ITEM_CHANGED" then
        if g_Active and this:IsVisible() then
            Bank_UpdateFrame(g_CurrentRentBox);
        end
    elseif event == "OBJECT_CARED_EVENT" then
        if g_Active and tonumber(arg0) == g_ObjCared and
            ((arg1 == "distance" and tonumber(arg2) > 3.0) or arg1 == "destroy") then
            Bank_Close_Clicked();
        end
    elseif event == "PLAYER_LEAVE_WORLD" or event == "PLAYER_ENTERING_WORLD" or
        event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" then
        Bank_Close_Clicked();
    elseif event == "VIEW_RESOLUTION_CHANGED" then
        Bank_Frame:SetProperty("UnifiedPosition", g_DefaultPosition);
    end
end

function Bank_UpdateFrame(nIndex)
    if not g_Active or not this:IsVisible() then return end
    Bank_ClearActions();
    local nRentNum = Bank:GetRentBoxNum();
    if nIndex < 1 or nIndex > nRentNum then nIndex = 1 end
    g_CurrentRentBox = nIndex;
    for i = 1, 8 do
        if i <= nRentNum then
            PACK_BUTTONS[i]:Show();
            PACK_BUTTONS[i]:Enable();
            PACK_BUTTONS[i]:SetProperty("DragAcceptName", "R"..i);
            if i == nIndex then PACK_BUTTONS[i]:SetPushed(1) end
        else
            PACK_BUTTONS[i]:Hide();
        end
    end
    Bank:SetCurRentIndex(nIndex);
    local nMoney = Bank:GetBankMoney();
    Bank_Money:SetProperty("MoneyNumber", tostring(nMoney));
    local nBeginIndex, nGridNum = Bank:GetRentBoxInfo(nIndex);
    for i = 1, 20 do
        if i <= nGridNum then
            GRID_BUTTONS[i]:Show();
            GRID_BUTTONS[i]:Enable();
            GRID_BUTTONS[i]:SetProperty("DragAcceptName", string.format("B%02d", i - 1));
            local theAction, bLocked = Bank:EnumItem(nBeginIndex + i - 1);
            if theAction:GetID() ~= 0 then
                GRID_BUTTONS[i]:SetActionItem(theAction:GetID());
                if bLocked then
                    GRID_BUTTONS[i]:SetProperty("DragAcceptName", "");
                    GRID_BUTTONS[i]:Disable();
                end
            end
        else
            GRID_BUTTONS[i]:Hide();
        end
    end
end

function Bank_Close_Clicked()
    -- Hidden 回调可能再次进入，先复位状态以免重复关闭金额输入框。
    local wasActive = g_Active;
    g_Active = false;
    if g_ObjCared ~= -1 then
        this:CareObject(g_ObjCared, 0, "Bank");
        g_ObjCared = -1;
    end
    Bank_ClearActions();
    if this:IsVisible() then this:Hide() end
    if wasActive then Bank:Close() end
end

function Bank_ShowAll_Clicked()
    if not g_Active then return end
    Bank:SetOpenWhichBank(1);
    Bank_Close_Clicked();
    PushEvent("TOGLE_BIGBANK", Bank:GetNpcId());
end

function Bank_Save_Clicked()
    if g_Active then Bank:OpenSaveFrame() end
end

function Bank_Get_Clicked()
    if g_Active then Bank:OpenGetFrame() end
end

function Bank_SuperPassword_Clicked()
    Player:SetSupperPassword();
end

function Bank_patulousBox_Clicked(nIndex)
    if not g_Active or nIndex < 1 or nIndex > Bank:GetRentBoxNum() then return end
    g_CurrentRentBox = nIndex;
    Bank_UpdateFrame(nIndex);
end

