-- ProcDoc.lua

------------------------------------------------------------
-- 0) GLOBALS
------------------------------------------------------------

-- 1) CREATE A FRAME TO INITIALIZE DB
local initFrame = CreateFrame("Frame", "ProcDocDBInitFrame", UIParent)
initFrame:RegisterEvent("ADDON_LOADED")

initFrame:SetScript("OnEvent", function()
    local e   = event 
    local a1  = arg1

    if e == "ADDON_LOADED" and a1 == "ProcDoc" then
        if not ProcDocDB then
            ProcDocDB = {}
        end
        if not ProcDocDB.globalVars then
            ProcDocDB.globalVars = {}
        end

        local gv = ProcDocDB.globalVars
        
        minAlpha   = gv.minAlpha   or 0.6
        maxAlpha   = gv.maxAlpha   or 1.0
        minScale   = gv.minScale   or 0.8
        maxScale   = gv.maxScale   or 1.0
        alphaStep  = gv.alphaStep  or 0.01
        pulseSpeed = gv.pulseSpeed or 1.0
        topOffset  = gv.topOffset  or 150
        sideOffset = gv.sideOffset or 150
        

        initFrame:UnregisterEvent("ADDON_LOADED")
    end
end)
------------------------------------------------------------
-- 1) MAIN ADDON FRAME
------------------------------------------------------------
local addonName = "ProcDoc"
local ProcDoc   = CreateFrame("Frame", "ProcDocAlertFrame", UIParent)
local ProcDoc   = CreateFrame("Frame", "ProcDocAlertFrame", UIParent)

------------------------------------------------------------
-- 2) TABLE OF PROCS
-- 2) TABLE OF PROCS
------------------------------------------------------------
local PROC_DATA = {
    ["WARLOCK"] = {
        {
            buffName         = "Shadow Trance",
            texture          = "Interface\\Icons\\Spell_Shadow_Twilight",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\WarlockShadowTrance.tga",
        },
    },
    ["MAGE"] = {
        {
            buffName         = "Clearcasting",
            texture          = "Interface\\Icons\\Spell_Shadow_ManaBurn",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\MageClearcasting.tga",
            alertStyle       = "TOP",
            alertStyle       = "TOP",
        },
        {
            buffName         = "Temporal Convergence",
            texture          = "Interface\\Icons\\Spell_Nature_StormReach",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\MageTemporalConvergence.tga",
        },
        {
            buffName         = "Flash Freeze",
            texture          = "Interface\\Icons\\Spell_Fire_FrostResistanceTotem",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\MageFlashFreeze.tga",
        },
    },
    ["DRUID"] = {
        {
            buffName         = "Clearcasting",
            texture          = "Interface\\Icons\\Spell_Shadow_ManaBurn",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\DruidClearcasting.tga",
            alertStyle       = "TOP",
        },
        {
            buffName         = "Nature's Grace",
            texture          = "Interface\\Icons\\Spell_Nature_NaturesBlessing",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\DruidNaturesGrace.tga",
        }
    },
    ["SHAMAN"] = {
        {
            buffName         = "Clearcasting",
            texture          = "Interface\\Icons\\Spell_Shadow_ManaBurn",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\ShamanClearcasting.tga",
            alertStyle       = "TOP",
        },
    },
    ["HUNTER"] = {
        {
            buffName         = "Quick Shots",
            texture          = "Interface\\Icons\\Ability_Warrior_InnerRage",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\HunterQuickShots.tga",
        },
    },
    ["WARRIOR"] = {
        {
            buffName         = "Enrage",
            texture          = "Interface\\Icons\\Spell_Shadow_UnholyFrenzy",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\WarriorEnrage.tga",
        },
    },
    ["PRIEST"] = {
    ["PRIEST"] = {
        {
            buffName         = "Resurgence",
            texture          = "Interface\\Icons\\Spell_Holy_MindVision",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\PriestResurgence.tga",
        },
        {
            buffName         = "Enlightened",
            texture          = "Interface\\Icons\\Spell_Holy_PowerInfusion",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\PriestEnlightened.tga",
            alertStyle       = "TOP",
        },
        {
            buffName         = "Searing Light",
            texture          = "Interface\\Icons\\Spell_Holy_SearingLightPriest",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\PriestSearingLight.tga",
        },
        },
    },
    ["PALADIN"] = {},
    ["ROGUE"] = {
    ["ROGUE"] = {
        {
            buffName         = "Remorseless",
            texture          = "Interface\\Icons\\Ability_FiegnDead",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\RogueRemorseless.tga",
        },
    },
}
}
local ACTION_PROCS = {
    ["ROGUE"] = {
        {
            buffName        = "Riposte", 
            texture         = "Interface\\Icons\\Ability_Warrior_Challange",
            alertTexturePath= "Interface\\AddOns\\ProcDoc\\img\\RogueRiposte.tga",
            alertStyle      = "SIDES",
            spellName       = "Riposte"
        },
    },
    ["WARRIOR"] = {
        {
            buffName        = "Overpower", 
            texture         = "Interface\\Icons\\Ability_MeleeDamage",
            alertTexturePath= "Interface\\AddOns\\ProcDoc\\img\\WarriorOverpower.tga",
            alertStyle      = "TOP",
            spellName       = "Overpower"
        },
    },
    ["MAGE"] = {
        {
            buffName        = "Arcane Surge", 
            texture         = "Interface\\Icons\\INV_Enchant_EssenceMysticalLarge",
            alertTexturePath= "Interface\\AddOns\\ProcDoc\\img\\MageArcaneSurge.tga",
            alertStyle      = "TOP",
            spellName       = "Arcane Surge"
        },
    },    
}

local DEFAULT_ALERT_TEXTURE = "Interface\\AddOns\\ProcDoc\\img\\ProcDocAlert.tga"

----------------------------------------------------------------
-- 3) ALERT FRAME POOL
----------------------------------------------------------------

local alertFrames = {}

local function CreateAlertFrame(style)
    local alertObj = {}
    alertObj.isActive      = false
    alertObj.isActionBased = false    
    alertObj.style         = style
    alertObj.textures      = {}
    alertObj.pulseAlpha    = minAlpha
    alertObj.pulseDir      = alphaStep

    -- Decide frame size based on style
    if style == "TOP" then
        alertObj.baseWidth  = 256
        alertObj.baseHeight = 128

        local tex = ProcDoc:CreateTexture(nil, "OVERLAY")
        tex:SetPoint("CENTER", UIParent, "CENTER", 0, topOffset)
        tex:SetPoint("CENTER", UIParent, "CENTER", 0, topOffset)
        tex:SetWidth(alertObj.baseWidth)
        tex:SetHeight(alertObj.baseHeight)
        tex:SetAlpha(0)
        tex:Hide()
        table.insert(alertObj.textures, tex)
    else
        alertObj.baseWidth  = 128
        alertObj.baseHeight = 256

        local left = ProcDoc:CreateTexture(nil, "OVERLAY")
        left:SetPoint("CENTER", UIParent, "CENTER", -sideOffset, topOffset - 150)
        left:SetPoint("CENTER", UIParent, "CENTER", -sideOffset, topOffset - 150)
        left:SetWidth(alertObj.baseWidth)
        left:SetHeight(alertObj.baseHeight)
        left:SetAlpha(0)
        left:Hide()

        local right = ProcDoc:CreateTexture(nil, "OVERLAY")
        right:SetPoint("CENTER", UIParent, "CENTER", sideOffset, topOffset - 150)
        right:SetPoint("CENTER", UIParent, "CENTER", sideOffset, topOffset - 150)
        right:SetWidth(alertObj.baseWidth)
        right:SetHeight(alertObj.baseHeight)
        right:SetTexCoord(1,0,0,1)
        right:SetTexCoord(1,0,0,1)
        right:SetAlpha(0)
        right:Hide()

        table.insert(alertObj.textures, left)
        table.insert(alertObj.textures, right)
    end

    return alertObj
end

-- Acquire a frame for either buff-based OR action-based usage
local function AcquireAlertFrame(style, isActionBased)
-- Acquire a frame for either buff-based OR action-based usage
local function AcquireAlertFrame(style, isActionBased)
    for _, alertObj in ipairs(alertFrames) do
        if (not alertObj.isActive)
           and (alertObj.style == style)
           and (alertObj.isActionBased == isActionBased)
        then
        if (not alertObj.isActive)
           and (alertObj.style == style)
           and (alertObj.isActionBased == isActionBased)
        then
            return alertObj
        end
    end
    local newAlert = CreateAlertFrame(style)
    newAlert.isActionBased = isActionBased
    newAlert.isActionBased = isActionBased
    table.insert(alertFrames, newAlert)
    return newAlert
end

----------------------------------------------------------------
-- 4) ONUPDATE PULSE
----------------------------------------------------------------
local function OnUpdateHandler()
    if maxAlpha <= minAlpha then
        maxAlpha = minAlpha + 0.01
    end
    if maxScale <= minScale then
        maxScale = minScale + 0.01
    end

----------------------------------------------------------------
-- 4) ONUPDATE PULSE
----------------------------------------------------------------
local function OnUpdateHandler()
    if maxAlpha <= minAlpha then
        maxAlpha = minAlpha + 0.01
    end
    if maxScale <= minScale then
        maxScale = minScale + 0.01
    end

    for _, alertObj in ipairs(alertFrames) do
        if alertObj.isActive then
            alertObj.pulseAlpha = alertObj.pulseAlpha + (alertObj.pulseDir * pulseSpeed)

            alertObj.pulseAlpha = alertObj.pulseAlpha + (alertObj.pulseDir * pulseSpeed)

            if alertObj.pulseAlpha < minAlpha then
                alertObj.pulseAlpha = minAlpha
                alertObj.pulseAlpha = minAlpha
                alertObj.pulseDir   = alphaStep
            elseif alertObj.pulseAlpha > maxAlpha then
                alertObj.pulseAlpha = maxAlpha
                alertObj.pulseAlpha = maxAlpha
                alertObj.pulseDir   = -alphaStep
            end

            local aRange = maxAlpha - minAlpha
            local scale  = 1.0
            if aRange > 0 then
                local fraction = (alertObj.pulseAlpha - minAlpha) / aRange
                scale = minScale + fraction * (maxScale - minScale)
            end
            end

            local aRange = maxAlpha - minAlpha
            local scale  = 1.0
            if aRange > 0 then
                local fraction = (alertObj.pulseAlpha - minAlpha) / aRange
                scale = minScale + fraction * (maxScale - minScale)
            end

            for _, tex in ipairs(alertObj.textures) do
                tex:SetAlpha(alertObj.pulseAlpha)
                tex:SetWidth(alertObj.baseWidth * scale)
                tex:SetHeight(alertObj.baseHeight * scale)
            end
        end
    end
end

ProcDoc:SetScript("OnUpdate", OnUpdateHandler)
ProcDoc:SetWidth(1)
ProcDoc:SetWidth(1)
ProcDoc:SetHeight(1)
ProcDoc:SetPoint("CENTER", UIParent, "CENTER")

----------------------------------------------------------------
-- 5) MERGE “BUFF” & “ACTION” PROCS FOR THIS CLASS
----------------------------------------------------------------
----------------------------------------------------------------
-- 5) MERGE “BUFF” & “ACTION” PROCS FOR THIS CLASS
----------------------------------------------------------------
local _, playerClass = UnitClass("player")

local normalProcs  = PROC_DATA[playerClass] or {}
local actionProcs  = ACTION_PROCS[playerClass] or {}  

-- Merge them into one big “classProcs” table
local classProcs = {}
for _, p in ipairs(normalProcs) do
    table.insert(classProcs, p)
end
for _, q in ipairs(actionProcs) do
    table.insert(classProcs, q)
end

----------------------------------------------------------------
-- 5) BUFF-BASED DETECTION
----------------------------------------------------------------
local function CheckProcs()
    -- Hide only the normal (buff-based) frames first
    -- i.e. only frames that are `not isActionBased`.
    -- Hide only the normal (buff-based) frames first
    -- i.e. only frames that are `not isActionBased`.
    for _, alertObj in ipairs(alertFrames) do
        if (not alertObj.isActionBased) then
            alertObj.isActive = false
            for _, tex in ipairs(alertObj.textures) do
                tex:Hide()
            end
        if (not alertObj.isActionBased) then
            alertObj.isActive = false
            for _, tex in ipairs(alertObj.textures) do
                tex:Hide()
            end
        end
    end

    local activeBuffProcs = {}
    local activeBuffProcs = {}
    for i = 0, 31 do
        local buffTexture = GetPlayerBuffTexture(i)
        if buffTexture then
            GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
            GameTooltip:SetPlayerBuff(i)
            local buffName = (GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText()) or ""
            local buffName = (GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText()) or ""
            GameTooltip:Hide()

            for _, procInfo in ipairs(normalProcs) do
                if (buffTexture == procInfo.texture)
                   and (buffName == procInfo.buffName)
            for _, procInfo in ipairs(normalProcs) do
                if (buffTexture == procInfo.texture)
                   and (buffName == procInfo.buffName)
                then
                    table.insert(activeBuffProcs, procInfo)
                    table.insert(activeBuffProcs, procInfo)
                end
            end
        end
    end

    for _, procInfo in ipairs(activeBuffProcs) do
    for _, procInfo in ipairs(activeBuffProcs) do
        local style = procInfo.alertStyle or "SIDES"
        local alertObj = AcquireAlertFrame(style, false)  -- not isActionBased
        local alertObj = AcquireAlertFrame(style, false)  -- not isActionBased
        alertObj.isActive   = true
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep

        local path = procInfo.alertTexturePath or DEFAULT_ALERT_TEXTURE
        local path = procInfo.alertTexturePath or DEFAULT_ALERT_TEXTURE
        for _, tex in ipairs(alertObj.textures) do
            tex:SetTexture(path)
            tex:SetTexture(path)
            tex:Show()
        end
    end
end


----------------------------------------------------------------
-- 6) ACTION-BASED DETECTION (Multiple)
----------------------------------------------------------------
-- track states per ability
local actionProcStates = {}

local function ShowActionProcAlert(actionProc)
    local spellName  = actionProc.spellName or "UnknownSpell"
    local state      = actionProcStates[spellName] or {}
    actionProcStates[spellName] = state

    local alertObj   = state.alertObj
    if alertObj and alertObj.isActive then
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep
    else
        -- Acquire a new alert frame for isActionBased = true
        alertObj = AcquireAlertFrame(actionProc.alertStyle or "SIDES", true)
        alertObj.isActive   = true
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep

        local path = actionProc.alertTexturePath or actionProc.texture or DEFAULT_ALERT_TEXTURE
        for _, tex in ipairs(alertObj.textures) do
            tex:SetTexture(path)
            tex:SetAlpha(minAlpha)
            tex:SetWidth(alertObj.baseWidth * minScale)
            tex:SetHeight(alertObj.baseHeight * minScale)
            tex:Show()
        end

        state.alertObj = alertObj
    end
    state.isActive = true
----------------------------------------------------------------
-- 6) ACTION-BASED DETECTION (Multiple)
----------------------------------------------------------------
-- track states per ability
local actionProcStates = {}

local function ShowActionProcAlert(actionProc)
    local spellName  = actionProc.spellName or "UnknownSpell"
    local state      = actionProcStates[spellName] or {}
    actionProcStates[spellName] = state

    local alertObj   = state.alertObj
    if alertObj and alertObj.isActive then
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep
    else
        -- Acquire a new alert frame for isActionBased = true
        alertObj = AcquireAlertFrame(actionProc.alertStyle or "SIDES", true)
        alertObj.isActive   = true
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep

        local path = actionProc.alertTexturePath or actionProc.texture or DEFAULT_ALERT_TEXTURE
        for _, tex in ipairs(alertObj.textures) do
            tex:SetTexture(path)
            tex:SetAlpha(minAlpha)
            tex:SetWidth(alertObj.baseWidth * minScale)
            tex:SetHeight(alertObj.baseHeight * minScale)
            tex:Show()
        end

        state.alertObj = alertObj
    end
    state.isActive = true
end

local function HideActionProcAlert(actionProc)
    local spellName = actionProc.spellName or "UnknownSpell"
    local state     = actionProcStates[spellName]
    if not state or not state.isActive then
local function HideActionProcAlert(actionProc)
    local spellName = actionProc.spellName or "UnknownSpell"
    local state     = actionProcStates[spellName]
    if not state or not state.isActive then
        return
    end

    local alertObj = state.alertObj
    if alertObj and alertObj.isActive then
        alertObj.isActive = false
        for _, tex in ipairs(alertObj.textures) do

    local alertObj = state.alertObj
    if alertObj and alertObj.isActive then
        alertObj.isActive = false
        for _, tex in ipairs(alertObj.textures) do
            tex:Hide()
        end
    end
    state.isActive = false
end

local function FindActionSlotAndCheck(actionProc)
    local spellName = actionProc.spellName or "UnknownSpell"
    local texPath   = actionProc.texture or ""
    if texPath == "" then
        return
    end

    -- find slot
    local foundSlot = nil
    for slot = 1, 120 do
    end
    state.isActive = false
end

local function FindActionSlotAndCheck(actionProc)
    local spellName = actionProc.spellName or "UnknownSpell"
    local texPath   = actionProc.texture or ""
    if texPath == "" then
        return
    end

    -- find slot
    local foundSlot = nil
    for slot = 1, 120 do
        local actionTex = GetActionTexture(slot)
        if actionTex then
            local lowerActionTex = string.lower(actionTex)
            local lowerWanted    = string.lower(texPath)
            if lowerActionTex == lowerWanted then
                foundSlot = slot
                break
            end
        if actionTex then
            local lowerActionTex = string.lower(actionTex)
            local lowerWanted    = string.lower(texPath)
            if lowerActionTex == lowerWanted then
                foundSlot = slot
                break
            end
        end
    end

    local state = actionProcStates[spellName] or {}
    actionProcStates[spellName] = state

    state.slot = foundSlot
    if not foundSlot then
        -- if previously active, hide
        if state.isActive then
            HideActionProcAlert(actionProc)
        end
    local state = actionProcStates[spellName] or {}
    actionProcStates[spellName] = state

    state.slot = foundSlot
    if not foundSlot then
        -- if previously active, hide
        if state.isActive then
            HideActionProcAlert(actionProc)
        end
        return
    end

    local usable = IsUsableAction(foundSlot)
    local usable = IsUsableAction(foundSlot)
    if usable then
        if not state.isActive then
            ShowActionProcAlert(actionProc)
        if not state.isActive then
            ShowActionProcAlert(actionProc)
        end
    else
        if state.isActive then
            HideActionProcAlert(actionProc)
        if state.isActive then
            HideActionProcAlert(actionProc)
        end
    end
end

local function CheckAllActionProcs()
    for _, actionProc in ipairs(actionProcs) do
        FindActionSlotAndCheck(actionProc)
    end
end

local function OnSpellcastSucceeded(arg1, arg2)
    print("|cffffff00[DEBUG]|r OnSpellcastSucceeded => "..tostring(arg1).." => "..tostring(arg2))
    for _, actionProc in ipairs(actionProcs) do
        if arg1 == "player" and (arg2 == actionProc.spellName) then
            print("|cffffff00[DEBUG]|r  => Hiding after cast for "..arg2)
            HideActionProcAlert(actionProc)
        end
    end
end

------------------------------------------------------------
--7) The event frame for action-based procs
------------------------------------------------------------

-- If your older client needs the old style event usage, do the "global event" trick:
local actionFrame = CreateFrame("Frame", "ProcDocActionFrame", UIParent)
actionFrame:RegisterEvent("PLAYER_LOGIN")
actionFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
actionFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
actionFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
actionFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
actionFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
actionFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
local function CheckAllActionProcs()
    for _, actionProc in ipairs(actionProcs) do
        FindActionSlotAndCheck(actionProc)
    end
end

local function OnSpellcastSucceeded(arg1, arg2)
    print("|cffffff00[DEBUG]|r OnSpellcastSucceeded => "..tostring(arg1).." => "..tostring(arg2))
    for _, actionProc in ipairs(actionProcs) do
        if arg1 == "player" and (arg2 == actionProc.spellName) then
            print("|cffffff00[DEBUG]|r  => Hiding after cast for "..arg2)
            HideActionProcAlert(actionProc)
        end
    end
end

------------------------------------------------------------
--7) The event frame for action-based procs
------------------------------------------------------------

-- If your older client needs the old style event usage, do the "global event" trick:
local actionFrame = CreateFrame("Frame", "ProcDocActionFrame", UIParent)
actionFrame:RegisterEvent("PLAYER_LOGIN")
actionFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
actionFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
actionFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
actionFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
actionFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
actionFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

actionFrame:SetScript("OnEvent", function()
    local e   = event
    local a1  = arg1
    local a2  = arg2
    local a3  = arg3

    if e == "PLAYER_LOGIN" then
        CheckAllActionProcs()
        CheckProcs()  -- run buff-based as well
    elseif e == "ACTIONBAR_PAGE_CHANGED"
        or e == "UPDATE_BONUS_ACTIONBAR"
        or e == "UPDATE_SHAPESHIFT_FORM"
        or e == "PLAYER_TARGET_CHANGED"
        or e == "ACTIONBAR_UPDATE_USABLE"
    then
        CheckAllActionProcs()
    elseif e == "UNIT_SPELLCAST_SUCCEEDED" then
        -- if we just cast Overpower / Riposte / Arcane Surge, hide them
        for _, actionProc in ipairs(actionProcs) do
            if a1 == "player" and (a2 == actionProc.spellName) then
                HideActionProcAlert(actionProc)
            end
        end
        CheckAllActionProcs()
    end
end)


----------------------------------------------------------------
-- 8) AURA FRAME
----------------------------------------------------------------
-- Also old-style event usage if needed:
local auraFrame = CreateFrame("Frame", "ProcDocAuraFrame", UIParent)
auraFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
auraFrame:SetScript("OnEvent", function()
    CheckProcs()
end)

DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00ProcDoc|r Loaded. Tracking procs for "..(UnitClass("player"))..". Use /procdoc to show options.")

------------------------------------------------------------
-- 9) TEST PROC + OPTIONS FRAME
------------------------------------------------------------
local testProcActive = false
local testProcAlertObj = nil
local testProcAlerts = {}  

local function RefreshTestProc()
    for buffName, alertObj in pairs(testProcAlerts) do
        if alertObj.isActive then
            if alertObj.style == "TOP" then
                local tex = alertObj.textures[1]
                tex:ClearAllPoints()
                tex:SetPoint("CENTER", UIParent, "CENTER", 0, topOffset)
            else
                local left = alertObj.textures[1]
                local right= alertObj.textures[2]
                left:ClearAllPoints()
                left:SetPoint("CENTER", UIParent, "CENTER", -sideOffset, topOffset - 150)
                right:ClearAllPoints()
                right:SetPoint("CENTER", UIParent, "CENTER",  sideOffset, topOffset - 150)
            end
        end
    end
    if testProcActive and testProcAlertObj then
        -- Update base alpha/scale
        if not minAlpha then minAlpha=0.6 end
        if not maxAlpha then maxAlpha=1.0 end
        if not minScale then minScale=0.8 end
        if not maxScale then maxScale=1.0 end

        -- Actually move the frames for the test proc
        -- Because we only anchored them once at creation.
        if testProcAlertObj.style == "TOP" then
            -- We only have 1 texture in TOP style
            local tex = testProcAlertObj.textures[1]
            tex:ClearAllPoints()
            tex:SetPoint("CENTER", UIParent, "CENTER", 0, topOffset)
        else
            -- We have 2 textures for SIDES style
            local left  = testProcAlertObj.textures[1]
            local right = testProcAlertObj.textures[2]

            left:ClearAllPoints()
            left:SetPoint("CENTER", UIParent, "CENTER", -sideOffset, topOffset - 150)

            right:ClearAllPoints()
            right:SetPoint("CENTER", UIParent, "CENTER", sideOffset, topOffset - 150)
        end

        -- Now apply alpha & size
        for _, tex in ipairs(testProcAlertObj.textures) do
            tex:SetAlpha(minAlpha)
            tex:SetWidth(testProcAlertObj.baseWidth * minScale)
            tex:SetHeight(testProcAlertObj.baseHeight * minScale)
            tex:Show()
        end

        -- Reset the pulse animation
        testProcAlertObj.pulseAlpha = minAlpha
        testProcAlertObj.pulseDir   = alphaStep

        DEFAULT_CHAT_FRAME:AddMessage("|cFF00FFFF[ProcDoc]|r Test proc refreshed with updated offsets.")
    end
end


------------------------------------------------------------
-- 10) MULTI-TEST ALERTS
------------------------------------------------------------

local function ShowTestBuffAlert(procInfo)
    local style = procInfo.alertStyle or "SIDES"

    -- If this buff's alert is already active, reuse it:
    local alertObj = testProcAlerts[procInfo.buffName]
    if alertObj and alertObj.isActive then
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep
    else
        -- Otherwise, acquire a new alert frame
        alertObj = AcquireAlertFrame(style)
        alertObj.isActive   = true
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep

        -- Assign textures
        local alertPath = procInfo.alertTexturePath or DEFAULT_ALERT_TEXTURE
        for _, tex in ipairs(alertObj.textures) do
            tex:SetTexture(alertPath)
            tex:SetAlpha(minAlpha)
            tex:SetWidth(alertObj.baseWidth * minScale)
            tex:SetHeight(alertObj.baseHeight * minScale)
            tex:Show()
        end

        -- Store it so we can hide/update later
        testProcAlerts[procInfo.buffName] = alertObj
    end

    -- Now ALWAYS re-anchor them using the current topOffset/sideOffset
    if style == "TOP" then
        local tex = alertObj.textures[1]
        tex:ClearAllPoints()
        tex:SetPoint("CENTER", UIParent, "CENTER", 0, topOffset)
    else
        local left  = alertObj.textures[1]
        local right = alertObj.textures[2]

        left:ClearAllPoints()
        left:SetPoint("CENTER", UIParent, "CENTER", -sideOffset, topOffset - 150)

        right:ClearAllPoints()
        right:SetPoint("CENTER", UIParent, "CENTER",  sideOffset, topOffset - 150)
    end
end


local function HideTestBuffAlert(procInfo)
    local alertObj = testProcAlerts[procInfo.buffName]
    if alertObj and alertObj.isActive then
        alertObj.isActive = false
        for _, tex in ipairs(alertObj.textures) do
            tex:Hide()
        end
        testProcAlerts[procInfo.buffName] = nil
    end
end

------------------------------------------------------------
-- 11) CREATE OPTIONS UI
------------------------------------------------------------
local function CreateProcDocOptionsFrame()
    
    if not ProcDocOptionsFrame then
        local f = CreateFrame("Frame", "ProcDocOptionsFrame", UIParent)
        f:SetWidth(340)
        f:SetHeight(700)
        f:SetPoint("CENTER", UIParent, "CENTER", -360, 0)
        f:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile     = true,
            tileSize = 16,
            edgeSize = 16,
            insets   = { left=4, right=4, top=4, bottom=4 },
        })
        f:SetBackdropColor(0, 0, 0, 0.8)
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function() f:StartMoving() end)
        f:SetScript("OnDragStop", function() f:StopMovingOrSizing() end)

        

        table.insert(UISpecialFrames, "ProcDocOptionsFrame")

        -----------------------------------------------------
        -- TITLE
        -----------------------------------------------------
        local titleFrame = CreateFrame("Frame", nil, f)
        titleFrame:SetPoint("TOP", f, "TOP", 0, 12)
        titleFrame:SetWidth(256)
        titleFrame:SetHeight(64)

        local titleTex = titleFrame:CreateTexture(nil, "OVERLAY")
        titleTex:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
        titleTex:SetAllPoints()

        local title = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        title:SetText("|cFF00FFFF[ProcDoc]|r Options")
        title:SetPoint("TOP", 0, -14)


        -----------------------------------------------------
        -- MIN TRANSPARENCY SLIDER
        -----------------------------------------------------
        local sliderLabel1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sliderLabel1:SetPoint("TOPLEFT", 20, -40)
        sliderLabel1:SetText("Min Transparency:")

        local minTransSlider = CreateFrame("Slider", "ProcDocMinTransSlider", f, "OptionsSliderTemplate")
        minTransSlider:SetPoint("TOPLEFT", 20, -60)
        minTransSlider:SetWidth(300)
        minTransSlider:SetMinMaxValues(0, 1)
        minTransSlider:SetValueStep(0.05)
        minTransSlider:SetValue(minAlpha)

        local low1  = getglobal(minTransSlider:GetName().."Low")
        local high1 = getglobal(minTransSlider:GetName().."High")
        local txt1  = getglobal(minTransSlider:GetName().."Text")

        if low1  then low1:SetText("0") end
        if high1 then high1:SetText("1") end
        if txt1  then txt1:SetText(string.format("%.2f", minAlpha)) end

        minTransSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()

            if not minAlpha then minAlpha = 0.6 end
            if not maxAlpha then maxAlpha = 1.0 end

            if value >= maxAlpha then
                value = maxAlpha - 0.01
                if value < 0 then value = 0 end
            end
            minAlpha = value

            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.minAlpha = minAlpha
            end

            local localText = getglobal(slider:GetName().."Text")
            if localText then
                localText:SetText(string.format("%.2f", value))
            end

            RefreshTestProc()
        end)

        -----------------------------------------------------
        -- MAX TRANSPARENCY SLIDER
        -----------------------------------------------------
        local sliderLabel2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sliderLabel2:SetPoint("TOPLEFT", 20, -100)
        sliderLabel2:SetText("Max Transparency:")

        local maxTransSlider = CreateFrame("Slider", "ProcDocMaxTransSlider", f, "OptionsSliderTemplate")
        maxTransSlider:SetPoint("TOPLEFT", 20, -120)
        maxTransSlider:SetWidth(300)
        maxTransSlider:SetMinMaxValues(0, 1)
        maxTransSlider:SetValueStep(0.05)
        maxTransSlider:SetValue(maxAlpha)

        local low2  = getglobal(maxTransSlider:GetName().."Low")
        local high2 = getglobal(maxTransSlider:GetName().."High")
        local txt2  = getglobal(maxTransSlider:GetName().."Text")

        if low2  then low2:SetText("0") end
        if high2 then high2:SetText("1") end
        if txt2  then txt2:SetText(string.format("%.2f", maxAlpha)) end

        maxTransSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()

            if not minAlpha then minAlpha = 0.6 end

            if value <= minAlpha then
                value = minAlpha + 0.01
                if value > 1 then value = 1 end
            end
            maxAlpha = value
            
            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.maxAlpha = maxAlpha
            end

            local localText = getglobal(slider:GetName().."Text")
            if localText then
                localText:SetText(string.format("%.2f", value))
            end

            RefreshTestProc()
        end)

        -----------------------------------------------------
        -- MIN SIZE SLIDER
        -----------------------------------------------------
        local sizeLabel1 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sizeLabel1:SetPoint("TOPLEFT", 20, -160)
        sizeLabel1:SetText("Min Size:")

        local minSizeSlider = CreateFrame("Slider", "ProcDocMinSizeSlider", f, "OptionsSliderTemplate")
        minSizeSlider:SetPoint("TOPLEFT", 20, -180)
        minSizeSlider:SetWidth(300)
        minSizeSlider:SetMinMaxValues(0.5, 2)
        minSizeSlider:SetValueStep(0.05)
        minSizeSlider:SetValue(minScale)

        local low3  = getglobal(minSizeSlider:GetName().."Low")
        local high3 = getglobal(minSizeSlider:GetName().."High")
        local txt3  = getglobal(minSizeSlider:GetName().."Text")

        if low3  then low3:SetText("0.5") end
        if high3 then high3:SetText("2.0") end
        if txt3  then txt3:SetText(string.format("%.2f", minScale)) end

        minSizeSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()

            if not maxScale then maxScale = 1.0 end

            if value >= maxScale then
                value = maxScale - 0.01
                if value < 0.5 then value = 0.5 end
            end
            minScale = value

            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.minScale = minScale
            end

            local localText = getglobal(slider:GetName().."Text")
            if localText then
                localText:SetText(string.format("%.2f", value))
            end

            RefreshTestProc()
        end)

        -----------------------------------------------------
        -- MAX SIZE SLIDER
        -----------------------------------------------------
        local sizeLabel2 = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sizeLabel2:SetPoint("TOPLEFT", 20, -220)
        sizeLabel2:SetText("Max Size:")

        local maxSizeSlider = CreateFrame("Slider", "ProcDocMaxSizeSlider", f, "OptionsSliderTemplate")
        maxSizeSlider:SetPoint("TOPLEFT", 20, -240)
        maxSizeSlider:SetWidth(300)
        maxSizeSlider:SetMinMaxValues(0.5, 2)
        maxSizeSlider:SetValueStep(0.05)
        maxSizeSlider:SetValue(maxScale)

        local low4  = getglobal(maxSizeSlider:GetName().."Low")
        local high4 = getglobal(maxSizeSlider:GetName().."High")
        local txt4  = getglobal(maxSizeSlider:GetName().."Text")

        if low4  then low4:SetText("0.5") end
        if high4 then high4:SetText("2.0") end
        if txt4  then txt4:SetText(string.format("%.2f", maxScale)) end

        maxSizeSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()

            if not minScale then minScale = 0.8 end

            if value <= minScale then
                value = minScale + 0.01
                if value > 2 then value = 2 end
            end
            maxScale = value

            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.maxScale = maxScale
            end

            local localText = getglobal(slider:GetName().."Text")
            if localText then
                localText:SetText(string.format("%.2f", value))
            end

            RefreshTestProc()
        end)

        -----------------------------------------------------
        -- Pulse Speed Slider
        -----------------------------------------------------

        local speedLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        speedLabel:SetPoint("TOPLEFT", 20, -280)
        speedLabel:SetText("Pulse Speed:")

        local pulseSpeedSlider = CreateFrame("Slider", "ProcDocPulseSpeedSlider", f, "OptionsSliderTemplate")
        pulseSpeedSlider:SetPoint("TOPLEFT", 20, -300)
        pulseSpeedSlider:SetWidth(300)
        pulseSpeedSlider:SetMinMaxValues(0.1, 5.0)
        pulseSpeedSlider:SetValueStep(0.1)
        pulseSpeedSlider:SetValue(pulseSpeed)

        local lowSpeed  = getglobal(pulseSpeedSlider:GetName().."Low")
        local highSpeed = getglobal(pulseSpeedSlider:GetName().."High")
        local txtSpeed  = getglobal(pulseSpeedSlider:GetName().."Text")
        if lowSpeed  then lowSpeed:SetText("0.1") end
        if highSpeed then highSpeed:SetText("5.0") end
        if txtSpeed  then txtSpeed:SetText(string.format("%.2f", pulseSpeed)) end

        pulseSpeedSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()

            pulseSpeed = value  -- store globally

            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.pulseSpeed = pulseSpeed
            end
        
            -- Update label
            local labelObj = getglobal(slider:GetName().."Text")
            if labelObj then
                labelObj:SetText(string.format("%.2f", value))
            end
        end)

        local function ReanchorAllLiveProcs()
            for _, alertObj in ipairs(alertFrames) do
                if alertObj.isActive and not alertObj.isTest then
                    if alertObj.style == "TOP" then
                        local tex = alertObj.textures[1]
                        tex:ClearAllPoints()
                        tex:SetPoint("CENTER", UIParent, "CENTER", 0, topOffset)
                    else
                        local left  = alertObj.textures[1]
                        local right = alertObj.textures[2]
        
                        left:ClearAllPoints()
                        left:SetPoint("CENTER", UIParent, "CENTER", -sideOffset, topOffset - 150)
                        right:ClearAllPoints()
                        right:SetPoint("CENTER", UIParent, "CENTER",  sideOffset, topOffset - 150)
                    end
                end
            end
        end
        

        ------------------------------------
        -- Top Offset Slider
        ------------------------------------
        local topLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        topLabel:SetPoint("TOPLEFT", 20, -340)
        topLabel:SetText("Top Offset (Vertical):")

        local topOffsetSlider = CreateFrame("Slider", "ProcDocTopOffsetSlider", f, "OptionsSliderTemplate")
        topOffsetSlider:SetPoint("TOPLEFT", 20, -360)
        topOffsetSlider:SetWidth(300)
        topOffsetSlider:SetMinMaxValues(0, 300)    -- e.g. range 0 -> 300
        topOffsetSlider:SetValueStep(10)
        topOffsetSlider:SetValue(topOffset)        -- current global

        local lowT  = getglobal(topOffsetSlider:GetName().."Low")
        local highT = getglobal(topOffsetSlider:GetName().."High")
        local txtT  = getglobal(topOffsetSlider:GetName().."Text")
        if lowT  then lowT:SetText("0")   end
        if highT then highT:SetText("300") end
        if txtT  then txtT:SetText(tostring(topOffset)) end

        topOffsetSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()
            topOffset = value
            if txtT then
                txtT:SetText(tostring(value))
            end

            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.topOffset = topOffset
            end
            -- If test proc is active, refresh to see new offset
            RefreshTestProc()
            ReanchorAllLiveProcs()
        end)

        ------------------------------------
        -- Side Offset Slider
        ------------------------------------
        local sideLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        sideLabel:SetPoint("TOPLEFT", 20, -400)
        sideLabel:SetText("Side Offset (Horizontal):")

        local sideOffsetSlider = CreateFrame("Slider", "ProcDocSideOffsetSlider", f, "OptionsSliderTemplate")
        sideOffsetSlider:SetPoint("TOPLEFT", 20, -420)
        sideOffsetSlider:SetWidth(300)
        sideOffsetSlider:SetMinMaxValues(0, 300)    -- e.g. range 0 -> 300
        sideOffsetSlider:SetValueStep(10)
        sideOffsetSlider:SetValue(sideOffset)

        local lowS  = getglobal(sideOffsetSlider:GetName().."Low")
        local highS = getglobal(sideOffsetSlider:GetName().."High")
        local txtS  = getglobal(sideOffsetSlider:GetName().."Text")
        if lowS  then lowS:SetText("0")   end
        if highS then highS:SetText("300") end
        if txtS  then txtS:SetText(tostring(sideOffset)) end

        sideOffsetSlider:SetScript("OnValueChanged", function()
            local slider = this
            local value  = slider:GetValue()
            sideOffset = value
            if txtS then
                txtS:SetText(tostring(value))
            end
            
            -- SAVE to DB:
            if ProcDocDB and ProcDocDB.globalVars then
                ProcDocDB.globalVars.sideOffset = sideOffset
            end

            -- If test proc is active, refresh to see new offset
            RefreshTestProc()
            ReanchorAllLiveProcs()
        end)

        -----------------------------------------------------
        -- PER-BUFF CHECKBOXES
        -----------------------------------------------------
        local testLabel = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        testLabel:SetPoint("TOPLEFT", 20, -455)
        testLabel:SetText("|cff00ff00Test Buffs for " .. (UnitClass("player")) .. "|r")

        local yOffset = -480
        -------------------------------------------------------------
        -- A table to hold references to each buff's checkbox
        -------------------------------------------------------------
        local checkBoxes = {}  -- e.g. checkBoxes[buffName] = that checkbox

        -------------------------------------------------------------
        -- In your for-loop that creates checkboxes, store them:
        -------------------------------------------------------------
        for _, procInfo in ipairs(classProcs) do
            local check = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
            check:SetPoint("TOPLEFT", 20, yOffset)
            check:SetHeight(24)
            check:SetWidth(24)
        
            local label = check:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            label:SetPoint("LEFT", check, "RIGHT", 4, 0)
            label:SetText(procInfo.buffName)
        
            -- Save this checkbox for later access
            checkBoxes[procInfo.buffName] = check
        
            -- If you want immediate toggling on click, do that here, or do nothing.
            check:SetScript("OnClick", function()
                -- optional immediate logic, or do nothing
            end)
        
            yOffset = yOffset - 28
        end

        -------------------------------------------------------------
        -- Modify your existing "Test Proc" button:
        -------------------------------------------------------------
        local testButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        testButton:SetPoint("BOTTOM", 0, 10)
        testButton:SetWidth(120)
        testButton:SetHeight(25)
        testButton:SetText("Test Proc")

        -- Replace old logic with:
        testButton:SetScript("OnClick", function()
            -- For each proc in classProcs:
            for _, procInfo in ipairs(classProcs) do
                local c = checkBoxes[procInfo.buffName]
                if c and c:GetChecked() then
                    -- Show this buff's test alert (spawn logic)
                    ShowTestBuffAlert(procInfo)
                else
                    -- Hide it if not checked
                    HideTestBuffAlert(procInfo)
                end
            end
        end)

        -----------------------------------------------------
        -- HIDE ALL
        -----------------------------------------------------
        local hideAllBtn = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        hideAllBtn:SetPoint("BOTTOMLEFT", 20, 40)
        hideAllBtn:SetWidth(120)
        hideAllBtn:SetHeight(25)
        hideAllBtn:SetText("Hide All")
        hideAllBtn:SetScript("OnClick", function()
            -- Hide all the multi-buff test alerts
            for buffName, alertObj in pairs(testProcAlerts) do
                if alertObj.isActive then
                    alertObj.isActive = false
                    for _, tex in ipairs(alertObj.textures) do
                        tex:Hide()
                    end
                end
            end

            -- Also hide the single testProcAlertObj
            if testProcAlertObj and testProcAlertObj.isActive then
                testProcAlertObj.isActive = false
                for _, t in ipairs(testProcAlertObj.textures) do
                    t:Hide()
                end
                testProcAlertObj = nil
                testProcActive   = false
            end

            DEFAULT_CHAT_FRAME:AddMessage("|cFF00FFFF[ProcDoc]|r All test buff alerts hidden.")
        end)

        -----------------------------------------------------
        -- CLOSE BUTTON
        -----------------------------------------------------
        local closeButton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        closeButton:SetPoint("BOTTOMRIGHT", -20, 40)
        closeButton:SetWidth(120)
        closeButton:SetHeight(25)
        closeButton:SetText("Close")
        closeButton:SetScript("OnClick", function()
            for buffName, alertObj in pairs(testProcAlerts) do
                if alertObj.isActive then
                    alertObj.isActive = false
                    for _, tex in ipairs(alertObj.textures) do
                        tex:Hide()
                    end
                end
            end
            f:Hide()

        end)
    end

    ProcDocOptionsFrame:Show()
    
    
end

------------------------------------------------------------
-- 12) SLASH COMMAND
------------------------------------------------------------
SLASH_PROCDOC1 = "/procdoc"
SlashCmdList["PROCDOC"] = function()
    CreateProcDocOptionsFrame()
end