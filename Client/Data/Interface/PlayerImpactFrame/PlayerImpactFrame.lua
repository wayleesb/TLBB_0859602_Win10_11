local IMPACT_NUM = 128;
local IMPACT_BUTTONS = {};
local IMPACT_TIMERS = {};
local IMPACT_SN = {};
local IMPACT_COLUMNS = 13;

function PlayerImpactFrame_PreLoad()
    this:RegisterEvent("PLAYER_ENTERING_WORLD");
    this:RegisterEvent("VIEW_RESOLUTION_CHANGED");
    this:RegisterEvent("IMPACT_SELF_UPDATE");
    this:RegisterEvent("IMPACT_SELF_UPDATE_TIME");
end

function PlayerImpactFrame_Layout()
    local width, height = GetCurClientSize();
    if not width or not height or width <= 0 or height <= 0 then return; end
    local rows = math.max(1, math.floor((height - 120) / 46));
    IMPACT_COLUMNS = math.max(4, math.ceil(IMPACT_NUM / rows));
    local frameWidth = IMPACT_COLUMNS * 36;
    PlayerImpact_Frame:SetProperty("UnifiedPosition", "{{1.0,"..tostring(-202-frameWidth).."},{0.0,20}}");
    for slot = 1, IMPACT_NUM do
        local column = IMPACT_COLUMNS - 1 - math.mod(slot-1, IMPACT_COLUMNS);
        local row = math.floor((slot-1) / IMPACT_COLUMNS);
        IMPACT_BUTTONS[slot]:SetProperty("AbsolutePosition", "x:"..tostring(column*36+4).." y:"..tostring(row*46+2));
        IMPACT_TIMERS[slot]:SetProperty("AbsolutePosition", "x:"..tostring(column*36).." y:"..tostring(row*46+32));
    end
end

function PlayerImpactFrame_OnLoad()
    for slot = 1, IMPACT_NUM do
        IMPACT_BUTTONS[slot] = _G["PlayerImpact_Image"..tostring(slot)];
        IMPACT_TIMERS[slot] = _G["PlayerImpact_Text"..tostring(slot)];
        IMPACT_SN[slot] = -1;
        IMPACT_BUTTONS[slot]:Hide();
        IMPACT_TIMERS[slot]:Hide();
    end
    PlayerImpactFrame_Layout();
    PlayerImpactFrame_Update(1, 1);
end

function PlayerImpactFrame_OnEvent(event)
    if event == "PLAYER_ENTERING_WORLD" or event == "VIEW_RESOLUTION_CHANGED" then
        PlayerImpactFrame_Layout();
        PlayerImpactFrame_Update(1, 1);
    elseif event == "IMPACT_SELF_UPDATE" then
        PlayerImpactFrame_Update(1, 1);
    elseif event == "IMPACT_SELF_UPDATE_TIME" then
        PlayerImpactFrame_Update(0, 1);
    end
end

function PlayerImpactFrame_Update(updateImage, updateTime)
    local count = math.min(IMPACT_NUM, math.max(0, Player:GetBuffNumber()));
    if updateImage > 0 then
        for slot = 1, IMPACT_NUM do
            if slot <= count then
                local index = slot-1;
                IMPACT_SN[slot] = Player:GetBuffSNByIndex(index);
                IMPACT_BUTTONS[slot]:SetProperty("ShortImage", Player:GetBuffIconNameByIndex(index) or "");
                IMPACT_BUTTONS[slot]:SetToolTip(Player:GetBuffToolTipsByIndex(index) or "");
                IMPACT_BUTTONS[slot]:SetProperty("MouseHollow", "False");
                IMPACT_BUTTONS[slot]:Show();
            else
                IMPACT_SN[slot] = -1;
                IMPACT_BUTTONS[slot]:SetProperty("MouseHollow", "True");
                IMPACT_BUTTONS[slot]:SetToolTip("");
                IMPACT_BUTTONS[slot]:Hide();
                IMPACT_TIMERS[slot]:SetProperty("Timer", "-2");
                IMPACT_TIMERS[slot]:Hide();
            end
        end
        PlayerImpact_Frame:SetProperty("AbsoluteSize", "w:"..tostring(IMPACT_COLUMNS*36).." h:"..tostring(math.max(1,math.ceil(count/IMPACT_COLUMNS))*46));
    end
    if count == 0 then this:Hide(); return; end
    this:Show();
    if updateTime > 0 then
        for slot = 1, count do
            local index = slot-1;
            if IMPACT_SN[slot] ~= Player:GetBuffSNByIndex(index) then
                PlayerImpactFrame_Update(1, 1);
                return;
            end
            IMPACT_TIMERS[slot]:SetProperty("Timer", tostring(Player:GetBuffTimeTextByIndex(index)));
            IMPACT_TIMERS[slot]:Show();
        end
    end
end

function PlayerImpactFrame_OnClick(slot)
    local sn = IMPACT_SN[slot];
    if sn and sn ~= -1 then Player:DispelBuffBySN(sn); end
end
