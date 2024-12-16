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
            -- By default "SIDES" since alertStyle not set
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
            buffName         = "Termporal Convergance",
            texture          = "Interface\\Icons\\Spell_Nature_Stormreach",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\MageTermporalConvergance.tga",
        },
    },
    ["DRUID"] = {
        {
            buffName         = "Clearcasting",
            texture          = "Interface\\Icons\\Spell_Shadow_ManaBurn",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\DruidClearcasting.tga",
        },
    },
    ["SHAMAN"] = {
        {
            buffName         = "Clearcasting",
            texture          = "Interface\\Icons\\Spell_Shadow_ManaBurn",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\ShamanClearcasting.tga",
            alertStyle       = "TOP",  -- single texture above the player
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
            -- Sides default
        },
        {
            buffName         = "Flurry",
            texture          = "Interface\\Icons\\Ability_GhoulFrenzy",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\WarriorFlurry.tga",
            alertStyle       = "TOP",  -- single texture above the player
        },
    },
    ["PRIEST"]  = {},
    ["PALADIN"] = {},
    ["ROGUE"]   = {
        {
            buffName         = "Remorseless Attacks",
            texture          = "Interface\\Icons\\Ability_FiegnDead",
            alertTexturePath = "Interface\\AddOns\\ProcDoc\\img\\RogueRemorseless.tga",
            -- Sides default
        },
    },
}

local DEFAULT_ALERT_TEXTURE = "Interface\\AddOns\\ProcDoc\\img\\ProcDocAlert.tga"

------------------------------------------------------------
-- 2) GLOBAL ANIMATION PARAMS
------------------------------------------------------------
local minScale, maxScale = 0.8, 1.0
local minAlpha, maxAlpha = 0.3, 0.8
local alphaStep = 0.01

------------------------------------------------------------
-- 3) FRAME POOL
------------------------------------------------------------
-- Each "alertObj" in the pool has:
-- {
--   textures   = {},   -- list of Texture objects
--   baseWidth  = ?,    -- style-specific width
--   baseHeight = ?,    -- style-specific height
--   pulseAlpha = float,
--   pulseDir   = +/- alphaStep,
--   isActive   = bool,
--   style      = "SIDES" or "TOP",
-- }
local alertFrames = {}

------------------------------------------------------------
-- 3a) Create a new alert frame
------------------------------------------------------------
local function CreateAlertFrame(style)
    local alertObj = {}
    alertObj.pulseAlpha = minAlpha
    alertObj.pulseDir   = alphaStep
    alertObj.isActive   = false
    alertObj.style      = style
    alertObj.textures   = {}

    if style == "TOP" then
        -- Single texture anchored above player, and 256 wide x 128 tall
        alertObj.baseWidth  = 256
        alertObj.baseHeight = 128

        local tex = ProcDoc:CreateTexture(nil, "OVERLAY")
        -- Position it above player's center (adjust offset to your preference)
        tex:SetPoint("CENTER", UIParent, "CENTER", 0, 150)
        tex:SetWidth(alertObj.baseWidth)
        tex:SetHeight(alertObj.baseHeight)
        tex:SetAlpha(0)
        tex:Hide()
        table.insert(alertObj.textures, tex)

    else
        -- Default: SIDES style, 128 wide x 256 tall
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
        right:SetTexCoord(1, 0, 0, 1)  -- mirrored
        right:SetAlpha(0)
        right:Hide()

        table.insert(alertObj.textures, left)
        table.insert(alertObj.textures, right)
    end

    return alertObj
end

------------------------------------------------------------
-- 3b) Acquire from pool or create new
------------------------------------------------------------
local function AcquireAlertFrame(style)
    for _, alertObj in ipairs(alertFrames) do
        if not alertObj.isActive and alertObj.style == style then
            return alertObj
        end
    end
    -- None are free, so create a new one
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
            -- update alpha for pulse
            alertObj.pulseAlpha = alertObj.pulseAlpha + alertObj.pulseDir
            if alertObj.pulseAlpha < minAlpha then
                alertObj.pulseDir   = alphaStep
                alertObj.pulseAlpha = minAlpha
            elseif alertObj.pulseAlpha > maxAlpha then
                alertObj.pulseDir   = -alphaStep
                alertObj.pulseAlpha = maxAlpha
            end

            -- scale factor
            local scale = minScale + (alertObj.pulseAlpha - minAlpha) 
                                  / (maxAlpha - minAlpha) 
                                  * (maxScale - minScale)

            -- apply alpha & scaled size to the alertObj's textures
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
    -- 1) Mark all frames inactive & hide
    for _, alertObj in ipairs(alertFrames) do
        alertObj.isActive = false
        for _, tex in ipairs(alertObj.textures) do
            tex:Hide()
        end
    end

    -- 2) Gather active procs
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

    -- 3) For each active proc, get or create an alert frame
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
