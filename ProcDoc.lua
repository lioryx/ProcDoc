-- ProcDoc.lua
local addonName = "ProcDoc"
local ProcDoc = CreateFrame("Frame", "ProcDocAlertFrame", UIParent)

------------------------------------------------------------
-- 1) TABLE OF PROCS (with alertStyle)
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
            alertStyle       = "TOP",  -- single texture above the player
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
    ["PRIEST"]  = {
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
        }
    },
    ["PALADIN"] = {},
    ["ROGUE"]   = {
        {
            buffName         = "Remorseless Attacks",
            texture          = "Interface\\Icons\\Ability_FiegnDead",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\RogueRemorseless.tga",
        },
    },
}

local DEFAULT_ALERT_TEXTURE = "Interface\\AddOns\\ProcDoc\\img\\ProcDocAlert.tga"

------------------------------------------------------------
-- 2) GLOBAL ANIMATION PARAMS
------------------------------------------------------------
local minScale, maxScale = 0.8, 1.0
local minAlpha, maxAlpha = 0.6, 1.0
local alphaStep = 0.01

------------------------------------------------------------
-- 3) FRAME POOL
------------------------------------------------------------
local alertFrames = {}

local function CreateAlertFrame(style)
    local alertObj = {}
    alertObj.pulseAlpha = minAlpha
    alertObj.pulseDir   = alphaStep
    alertObj.isActive   = false
    alertObj.style      = style
    alertObj.textures   = {}

    if style == "TOP" then
        alertObj.baseWidth  = 256
        alertObj.baseHeight = 128

        local tex = ProcDoc:CreateTexture(nil, "OVERLAY")
        tex:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
        tex:SetWidth(alertObj.baseWidth)
        tex:SetHeight(alertObj.baseHeight)
        tex:SetAlpha(0)
        tex:Hide()
        table.insert(alertObj.textures, tex)

    else
        alertObj.baseWidth  = 128
        alertObj.baseHeight = 256

        local left = ProcDoc:CreateTexture(nil, "OVERLAY")
        left:SetPoint("CENTER", UIParent, "CENTER", -150, 0)
        left:SetWidth(alertObj.baseWidth)
        left:SetHeight(alertObj.baseHeight)
        left:SetAlpha(0)
        left:Hide()

        local right = ProcDoc:CreateTexture(nil, "OVERLAY")
        right:SetPoint("CENTER", UIParent, "CENTER", 150, 0)
        right:SetWidth(alertObj.baseWidth)
        right:SetHeight(alertObj.baseHeight)
        right:SetTexCoord(1, 0, 0, 1)
        right:SetAlpha(0)
        right:Hide()

        table.insert(alertObj.textures, left)
        table.insert(alertObj.textures, right)
    end

    return alertObj
end

local function AcquireAlertFrame(style)
    for _, alertObj in ipairs(alertFrames) do
        if not alertObj.isActive and alertObj.style == style then
            return alertObj
        end
    end
    local newAlert = CreateAlertFrame(style)
    table.insert(alertFrames, newAlert)
    return newAlert
end

------------------------------------------------------------
-- 4) ONUPDATE: Pulse all active alerts
------------------------------------------------------------
local function OnUpdateHandler(self, elapsed)
    for _, alertObj in ipairs(alertFrames) do
        if alertObj.isActive then
            alertObj.pulseAlpha = alertObj.pulseAlpha + alertObj.pulseDir
            if alertObj.pulseAlpha < minAlpha then
                alertObj.pulseDir   = alphaStep
                alertObj.pulseAlpha = minAlpha
            elseif alertObj.pulseAlpha > maxAlpha then
                alertObj.pulseDir   = -alphaStep
                alertObj.pulseAlpha = maxAlpha
            end

            local scale = minScale + (alertObj.pulseAlpha - minAlpha) 
                                  / (maxAlpha - minAlpha) 
                                  * (maxScale - minScale)

            for _, tex in ipairs(alertObj.textures) do
                tex:SetAlpha(alertObj.pulseAlpha)
                tex:SetWidth(alertObj.baseWidth * scale)
                tex:SetHeight(alertObj.baseHeight * scale)
            end
        end
    end
end

ProcDoc:SetScript("OnUpdate", OnUpdateHandler)
ProcDoc:SetHeight(1)
ProcDoc:SetWidth(1)
ProcDoc:SetPoint("CENTER", UIParent, "CENTER")

------------------------------------------------------------
-- 5) DETECT BUFFS AND DISPLAY ALERTS
------------------------------------------------------------
local _, playerClass = UnitClass("player")
local classProcs = PROC_DATA[playerClass] or {}

local function CheckProcs()
    -- Hide all first
    for _, alertObj in ipairs(alertFrames) do
        alertObj.isActive = false
        for _, tex in ipairs(alertObj.textures) do
            tex:Hide()
        end
    end

    local activeProcList = {}
    for i = 0, 31 do
        local buffTexture = GetPlayerBuffTexture(i)
        if buffTexture then
            for _, procInfo in ipairs(classProcs) do
                if buffTexture == procInfo.texture then
                    table.insert(activeProcList, procInfo)
                end
            end
        end
    end

    for _, procInfo in ipairs(activeProcList) do
        local style = procInfo.alertStyle or "SIDES"
        local alertObj = AcquireAlertFrame(style)
        alertObj.isActive   = true
        alertObj.pulseAlpha = minAlpha
        alertObj.pulseDir   = alphaStep

        local alertPath = procInfo.alertTexturePath or DEFAULT_ALERT_TEXTURE
        for _, tex in ipairs(alertObj.textures) do
            tex:SetTexture(alertPath)
            tex:Show()
        end
    end
end

local auraFrame = CreateFrame("Frame")
auraFrame:RegisterEvent("PLAYER_AURAS_CHANGED")
auraFrame:SetScript("OnEvent", CheckProcs)

DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00ProcDoc|r Loaded. Tracking instant procs for "..(UnitClass("player"))..".")

------------------------------------------------------------
-- ACTION-BASED PROCS: HIDE ON SPELL USE
------------------------------------------------------------
local ACTION_PROCS = {
    ["ROGUE"] = {
        texture = "Interface\\Icons\\Ability_Warrior_Challange",
        alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\RogueRiposte.tga",
        alertStyle = "SIDES",
        spellName = "Riposte"
    },
    ["WARRIOR"] = {
        texture = "Interface\\Icons\\Ability_MeleeDamage",
        alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\WarriorOverpower.tga",
        alertStyle = "TOP",
        spellName = "Overpower"
    },
    ["MAGE"] = {
        texture = "Interface\\Icons\\INV_Enchant_EssenceMysticalLarge",
        alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\MageArcaneSurge.tga",
        alertStyle = "TOP",
        spellName = "Arcane Surge"
    },
}

local actionProcInfo = ACTION_PROCS[playerClass]
local actionProcSlot = nil
local actionProcActive = false
-- Declare a global reference to the current action-based alert frame
local actionProcAlertObj = nil

local function ShowActionProcAlert(texturePath, style)
    if not actionProcInfo then return end
    local alertObj2 = AcquireAlertFrame(style)
    alertObj2.isActive = true
    alertObj2.pulseAlpha = minAlpha
    alertObj2.pulseDir = alphaStep
    
    for _, tex in ipairs(alertObj2.textures) do
        tex:SetTexture(texturePath)
        tex:Show()
    end
    
    -- Store a reference to this alertObj for later
    actionProcAlertObj = alertObj2
end

local function HideActionProcAlert()
    if not actionProcInfo or not actionProcInfo.alertTexturePath then
        return
    end
    
    
    if actionProcAlertObj and actionProcAlertObj.isActive then
        -- Directly reference the known alert object
        actionProcAlertObj.isActive = false
        for _, tex in ipairs(actionProcAlertObj.textures) do
            tex:Hide()
        end
        actionProcAlertObj = nil
    else
        -- If for some reason the reference is missing, fallback to the old search
        for _, alertObj2 in ipairs(alertFrames) do
            if alertObj2.isActive then
                local firstTex = alertObj2.textures[1]
                if firstTex and (firstTex:GetTexture() == actionProcInfo.alertTexturePath) then
                    alertObj2.isActive = false
                    for _, tx in ipairs(alertObj2.textures) do
                        tx:Hide()
                    end
                end
            end
        end
    end
end

local function FindActionSlotByTexture(tex)
    if not tex then
        return nil
    end

    for slot = 1,120 do
        local actionTex = GetActionTexture(slot)
        if actionTex and string.lower(actionTex) == string.lower(tex) then
            actionProcSlot = slot

            local usable = IsUsableAction(slot)
            if usable then
                if not actionProcActive then
                    ShowActionProcAlert(actionProcInfo.alertTexturePath, actionProcInfo.alertStyle)
                    actionProcActive = true
                end
            else
                if actionProcActive then
                    HideActionProcAlert()
                    actionProcActive = false
                end
            end

            return slot
        end
    end

    return nil
end

function CheckAbilityUsable()
    if not actionProcInfo then return end
    if not actionProcSlot then
        FindActionSlotByTexture(actionProcInfo.texture)
        return
    end

    local usable = IsUsableAction(actionProcSlot)
    if usable then
        if not actionProcActive then
            ShowActionProcAlert(actionProcInfo.alertTexturePath, actionProcInfo.alertStyle)
            actionProcActive = true
        end
    else
        if actionProcActive then
            HideActionProcAlert()
            actionProcActive = false
        end
    end
end

local function RescanAbilitySlot()
    if not actionProcInfo then
        return
    end
    actionProcSlot = FindActionSlotByTexture(actionProcInfo.texture)
    actionProcActive = false
    CheckAbilityUsable()
end


local abilityFrame = CreateFrame("Frame")
abilityFrame:RegisterEvent("PLAYER_LOGIN")
abilityFrame:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
abilityFrame:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
abilityFrame:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
abilityFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
abilityFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
abilityFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

abilityFrame:SetScript("OnEvent", function(self, event, arg1, arg2, arg3)
    if event == "PLAYER_LOGIN" then
        RescanAbilitySlot()
        if CheckProcs then
            CheckProcs()
        end
    elseif event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" then
        RescanAbilitySlot()
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
        if arg1 == "player" and actionProcActive and actionProcInfo and arg2 == actionProcInfo.spellName then
            HideActionProcAlert()
            actionProcActive = false
        else
            CheckAbilityUsable()
        end
    else
        CheckAbilityUsable()
    end
end)
