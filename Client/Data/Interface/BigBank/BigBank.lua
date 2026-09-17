-- 八箱仓库视图；只刷新可见窗口，关闭时清理物品 Action 和 NPC 关注。
local GRID_BUTTONS = {};
local PACK_BUTTONS = {};
local GRID_SETS = {};
local CLOSED_SETS = {};
local g_Active = false;
local g_ObjCared = -1;
local g_CurrentRentBox = 0;
local g_DefaultPosition;

function BigBank_PreLoad()
    this:RegisterEvent("TOGLE_BIGBANK");
    this:RegisterEvent("UPDATE_BANK");
    this:RegisterEvent("PACKAGE_ITEM_CHANGED");
    this:RegisterEvent("OBJECT_CARED_EVENT");
    this:RegisterEvent("PLAYER_LEAVE_WORLD");
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("ON_SCENE_TRANS");
    this:RegisterEvent("ON_SERVER_TRANS");
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
end

function BigBank_OnLoad()
    GRID_BUTTONS[1] = BigBank_Item1_1;
    GRID_BUTTONS[2] = BigBank_Item1_2;
    GRID_BUTTONS[3] = BigBank_Item1_3;
    GRID_BUTTONS[4] = BigBank_Item1_4;
    GRID_BUTTONS[5] = BigBank_Item1_5;
    GRID_BUTTONS[6] = BigBank_Item1_6;
    GRID_BUTTONS[7] = BigBank_Item1_7;
    GRID_BUTTONS[8] = BigBank_Item1_8;
    GRID_BUTTONS[9] = BigBank_Item1_9;
    GRID_BUTTONS[10] = BigBank_Item1_10;
    GRID_BUTTONS[11] = BigBank_Item1_11;
    GRID_BUTTONS[12] = BigBank_Item1_12;
    GRID_BUTTONS[13] = BigBank_Item1_13;
    GRID_BUTTONS[14] = BigBank_Item1_14;
    GRID_BUTTONS[15] = BigBank_Item1_15;
    GRID_BUTTONS[16] = BigBank_Item1_16;
    GRID_BUTTONS[17] = BigBank_Item1_17;
    GRID_BUTTONS[18] = BigBank_Item1_18;
    GRID_BUTTONS[19] = BigBank_Item1_19;
    GRID_BUTTONS[20] = BigBank_Item1_20;
    GRID_BUTTONS[21] = BigBank_Item2_1;
    GRID_BUTTONS[22] = BigBank_Item2_2;
    GRID_BUTTONS[23] = BigBank_Item2_3;
    GRID_BUTTONS[24] = BigBank_Item2_4;
    GRID_BUTTONS[25] = BigBank_Item2_5;
    GRID_BUTTONS[26] = BigBank_Item2_6;
    GRID_BUTTONS[27] = BigBank_Item2_7;
    GRID_BUTTONS[28] = BigBank_Item2_8;
    GRID_BUTTONS[29] = BigBank_Item2_9;
    GRID_BUTTONS[30] = BigBank_Item2_10;
    GRID_BUTTONS[31] = BigBank_Item2_11;
    GRID_BUTTONS[32] = BigBank_Item2_12;
    GRID_BUTTONS[33] = BigBank_Item2_13;
    GRID_BUTTONS[34] = BigBank_Item2_14;
    GRID_BUTTONS[35] = BigBank_Item2_15;
    GRID_BUTTONS[36] = BigBank_Item2_16;
    GRID_BUTTONS[37] = BigBank_Item2_17;
    GRID_BUTTONS[38] = BigBank_Item2_18;
    GRID_BUTTONS[39] = BigBank_Item2_19;
    GRID_BUTTONS[40] = BigBank_Item2_20;
    GRID_BUTTONS[41] = BigBank_Item3_1;
    GRID_BUTTONS[42] = BigBank_Item3_2;
    GRID_BUTTONS[43] = BigBank_Item3_3;
    GRID_BUTTONS[44] = BigBank_Item3_4;
    GRID_BUTTONS[45] = BigBank_Item3_5;
    GRID_BUTTONS[46] = BigBank_Item3_6;
    GRID_BUTTONS[47] = BigBank_Item3_7;
    GRID_BUTTONS[48] = BigBank_Item3_8;
    GRID_BUTTONS[49] = BigBank_Item3_9;
    GRID_BUTTONS[50] = BigBank_Item3_10;
    GRID_BUTTONS[51] = BigBank_Item3_11;
    GRID_BUTTONS[52] = BigBank_Item3_12;
    GRID_BUTTONS[53] = BigBank_Item3_13;
    GRID_BUTTONS[54] = BigBank_Item3_14;
    GRID_BUTTONS[55] = BigBank_Item3_15;
    GRID_BUTTONS[56] = BigBank_Item3_16;
    GRID_BUTTONS[57] = BigBank_Item3_17;
    GRID_BUTTONS[58] = BigBank_Item3_18;
    GRID_BUTTONS[59] = BigBank_Item3_19;
    GRID_BUTTONS[60] = BigBank_Item3_20;
    GRID_BUTTONS[61] = BigBank_Item4_1;
    GRID_BUTTONS[62] = BigBank_Item4_2;
    GRID_BUTTONS[63] = BigBank_Item4_3;
    GRID_BUTTONS[64] = BigBank_Item4_4;
    GRID_BUTTONS[65] = BigBank_Item4_5;
    GRID_BUTTONS[66] = BigBank_Item4_6;
    GRID_BUTTONS[67] = BigBank_Item4_7;
    GRID_BUTTONS[68] = BigBank_Item4_8;
    GRID_BUTTONS[69] = BigBank_Item4_9;
    GRID_BUTTONS[70] = BigBank_Item4_10;
    GRID_BUTTONS[71] = BigBank_Item4_11;
    GRID_BUTTONS[72] = BigBank_Item4_12;
    GRID_BUTTONS[73] = BigBank_Item4_13;
    GRID_BUTTONS[74] = BigBank_Item4_14;
    GRID_BUTTONS[75] = BigBank_Item4_15;
    GRID_BUTTONS[76] = BigBank_Item4_16;
    GRID_BUTTONS[77] = BigBank_Item4_17;
    GRID_BUTTONS[78] = BigBank_Item4_18;
    GRID_BUTTONS[79] = BigBank_Item4_19;
    GRID_BUTTONS[80] = BigBank_Item4_20;
    GRID_BUTTONS[81] = BigBank_Item5_1;
    GRID_BUTTONS[82] = BigBank_Item5_2;
    GRID_BUTTONS[83] = BigBank_Item5_3;
    GRID_BUTTONS[84] = BigBank_Item5_4;
    GRID_BUTTONS[85] = BigBank_Item5_5;
    GRID_BUTTONS[86] = BigBank_Item5_6;
    GRID_BUTTONS[87] = BigBank_Item5_7;
    GRID_BUTTONS[88] = BigBank_Item5_8;
    GRID_BUTTONS[89] = BigBank_Item5_9;
    GRID_BUTTONS[90] = BigBank_Item5_10;
    GRID_BUTTONS[91] = BigBank_Item5_11;
    GRID_BUTTONS[92] = BigBank_Item5_12;
    GRID_BUTTONS[93] = BigBank_Item5_13;
    GRID_BUTTONS[94] = BigBank_Item5_14;
    GRID_BUTTONS[95] = BigBank_Item5_15;
    GRID_BUTTONS[96] = BigBank_Item5_16;
    GRID_BUTTONS[97] = BigBank_Item5_17;
    GRID_BUTTONS[98] = BigBank_Item5_18;
    GRID_BUTTONS[99] = BigBank_Item5_19;
    GRID_BUTTONS[100] = BigBank_Item5_20;
    GRID_BUTTONS[101] = BigBank_Item6_1;
    GRID_BUTTONS[102] = BigBank_Item6_2;
    GRID_BUTTONS[103] = BigBank_Item6_3;
    GRID_BUTTONS[104] = BigBank_Item6_4;
    GRID_BUTTONS[105] = BigBank_Item6_5;
    GRID_BUTTONS[106] = BigBank_Item6_6;
    GRID_BUTTONS[107] = BigBank_Item6_7;
    GRID_BUTTONS[108] = BigBank_Item6_8;
    GRID_BUTTONS[109] = BigBank_Item6_9;
    GRID_BUTTONS[110] = BigBank_Item6_10;
    GRID_BUTTONS[111] = BigBank_Item6_11;
    GRID_BUTTONS[112] = BigBank_Item6_12;
    GRID_BUTTONS[113] = BigBank_Item6_13;
    GRID_BUTTONS[114] = BigBank_Item6_14;
    GRID_BUTTONS[115] = BigBank_Item6_15;
    GRID_BUTTONS[116] = BigBank_Item6_16;
    GRID_BUTTONS[117] = BigBank_Item6_17;
    GRID_BUTTONS[118] = BigBank_Item6_18;
    GRID_BUTTONS[119] = BigBank_Item6_19;
    GRID_BUTTONS[120] = BigBank_Item6_20;
    GRID_BUTTONS[121] = BigBank_Item7_1;
    GRID_BUTTONS[122] = BigBank_Item7_2;
    GRID_BUTTONS[123] = BigBank_Item7_3;
    GRID_BUTTONS[124] = BigBank_Item7_4;
    GRID_BUTTONS[125] = BigBank_Item7_5;
    GRID_BUTTONS[126] = BigBank_Item7_6;
    GRID_BUTTONS[127] = BigBank_Item7_7;
    GRID_BUTTONS[128] = BigBank_Item7_8;
    GRID_BUTTONS[129] = BigBank_Item7_9;
    GRID_BUTTONS[130] = BigBank_Item7_10;
    GRID_BUTTONS[131] = BigBank_Item7_11;
    GRID_BUTTONS[132] = BigBank_Item7_12;
    GRID_BUTTONS[133] = BigBank_Item7_13;
    GRID_BUTTONS[134] = BigBank_Item7_14;
    GRID_BUTTONS[135] = BigBank_Item7_15;
    GRID_BUTTONS[136] = BigBank_Item7_16;
    GRID_BUTTONS[137] = BigBank_Item7_17;
    GRID_BUTTONS[138] = BigBank_Item7_18;
    GRID_BUTTONS[139] = BigBank_Item7_19;
    GRID_BUTTONS[140] = BigBank_Item7_20;
    GRID_BUTTONS[141] = BigBank_Item8_1;
    GRID_BUTTONS[142] = BigBank_Item8_2;
    GRID_BUTTONS[143] = BigBank_Item8_3;
    GRID_BUTTONS[144] = BigBank_Item8_4;
    GRID_BUTTONS[145] = BigBank_Item8_5;
    GRID_BUTTONS[146] = BigBank_Item8_6;
    GRID_BUTTONS[147] = BigBank_Item8_7;
    GRID_BUTTONS[148] = BigBank_Item8_8;
    GRID_BUTTONS[149] = BigBank_Item8_9;
    GRID_BUTTONS[150] = BigBank_Item8_10;
    GRID_BUTTONS[151] = BigBank_Item8_11;
    GRID_BUTTONS[152] = BigBank_Item8_12;
    GRID_BUTTONS[153] = BigBank_Item8_13;
    GRID_BUTTONS[154] = BigBank_Item8_14;
    GRID_BUTTONS[155] = BigBank_Item8_15;
    GRID_BUTTONS[156] = BigBank_Item8_16;
    GRID_BUTTONS[157] = BigBank_Item8_17;
    GRID_BUTTONS[158] = BigBank_Item8_18;
    GRID_BUTTONS[159] = BigBank_Item8_19;
    GRID_BUTTONS[160] = BigBank_Item8_20;
    GRID_SETS[1] = BigBank_Item1_Set;
    CLOSED_SETS[1] = BigBank_Item1_Close;
    GRID_SETS[2] = BigBank_Item2_Set;
    CLOSED_SETS[2] = BigBank_Item2_Close;
    GRID_SETS[3] = BigBank_Item3_Set;
    CLOSED_SETS[3] = BigBank_Item3_Close;
    GRID_SETS[4] = BigBank_Item4_Set;
    CLOSED_SETS[4] = BigBank_Item4_Close;
    GRID_SETS[5] = BigBank_Item5_Set;
    CLOSED_SETS[5] = BigBank_Item5_Close;
    GRID_SETS[6] = BigBank_Item6_Set;
    CLOSED_SETS[6] = BigBank_Item6_Close;
    GRID_SETS[7] = BigBank_Item7_Set;
    CLOSED_SETS[7] = BigBank_Item7_Close;
    GRID_SETS[8] = BigBank_Item8_Set;
    CLOSED_SETS[8] = BigBank_Item8_Close;
    g_DefaultPosition = BigBank_Frame:GetProperty("UnifiedPosition");
    BigBank_ClearActions();
end

function BigBank_ClearActions()
    for i = 1, 160 do
        GRID_BUTTONS[i]:SetActionItem(-1);
        GRID_BUTTONS[i]:SetPushed(0);
        GRID_BUTTONS[i]:SetProperty("DragAcceptName", "");
        GRID_BUTTONS[i]:Disable();
    end

end

function BigBank_OnEvent(event)
    if event == "TOGLE_BIGBANK" then
        if IsWindowShow("Bank") then
            CloseWindow("Bank", true);
        end
        if g_Active then
            BigBank_Close_Clicked();
        end
        this:Show();
        g_Active = true;
        g_ObjCared = Bank:GetNpcId();
        this:CareObject(g_ObjCared, 1, "BigBank");
        Bank:SetOpenWhichBank(1);
        g_CurrentRentBox = 0;
        BigBank_UpdateFrame(g_CurrentRentBox);
    elseif event == "UPDATE_BANK" or event == "PACKAGE_ITEM_CHANGED" then
        if g_Active and this:IsVisible() then
            BigBank_UpdateFrame(g_CurrentRentBox);
        end
    elseif event == "OBJECT_CARED_EVENT" then
        if g_Active and tonumber(arg0) == g_ObjCared and
            ((arg1 == "distance" and tonumber(arg2) > 3.0) or arg1 == "destroy") then
            BigBank_Close_Clicked();
        end
    elseif event == "PLAYER_LEAVE_WORLD" or event == "PLAYER_ENTERING_WORLD" or
        event == "ON_SCENE_TRANS" or event == "ON_SERVER_TRANS" then
        BigBank_Close_Clicked();
    elseif event == "VIEW_RESOLUTION_CHANGED" then
        BigBank_Frame:SetProperty("UnifiedPosition", g_DefaultPosition);
    end
end

function BigBank_UpdateFrame(nIndex)
    if not g_Active or not this:IsVisible() then return end
    BigBank_ClearActions();
    local nRentNum = Bank:GetRentBoxNum();
    for i = 1, 8 do
        if i <= nRentNum then
            CLOSED_SETS[i]:Hide();
            GRID_SETS[i]:Show();
        else
            CLOSED_SETS[i]:Show();
            GRID_SETS[i]:Hide();
        end
    end
    Bank:SetCurRentIndex(nIndex);
    local nMoney = Bank:GetBankMoney();
    BigBank_Money:SetProperty("MoneyNumber", tostring(nMoney));
    local nBeginIndex, nGridNum = Bank:GetRentBoxInfo(nIndex);
    for i = 1, 160 do
        if i <= nGridNum then
            GRID_BUTTONS[i]:Show();
            GRID_BUTTONS[i]:Enable();
            GRID_BUTTONS[i]:SetProperty("DragAcceptName", string.format("B%03d", i - 1));
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

function BigBank_Close_Clicked()
    -- Hidden 回调可能再次进入，先复位状态以免重复关闭金额输入框。
    local wasActive = g_Active;
    g_Active = false;
    if g_ObjCared ~= -1 then
        this:CareObject(g_ObjCared, 0, "BigBank");
        g_ObjCared = -1;
    end
    BigBank_ClearActions();
    if this:IsVisible() then this:Hide() end
    if wasActive then Bank:Close() end
end

function BigBank_ShowAllOff_Clicked()
    if not g_Active then return end
    Bank:SetOpenWhichBank(0);
    BigBank_Close_Clicked();
    PushEvent("TOGLE_BANK", Bank:GetNpcId());
end

function BigBank_Save_Clicked()
    if g_Active then Bank:OpenSaveFrame() end
end

function BigBank_Get_Clicked()
    if g_Active then Bank:OpenGetFrame() end
end

function BigBank_SuperPassword_Clicked()
    Player:SetSupperPassword();
end

