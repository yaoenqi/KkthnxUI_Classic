local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("Test")

local _G = _G
local fast_random = _G.fastrandom
local string_split = _G.string.split

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local EMOTE123_TOKEN = _G.EMOTE123_TOKEN
local EMOTE21_TOKEN = _G.EMOTE21_TOKEN
local EMOTE36_TOKEN = _G.EMOTE36_TOKEN
local EMOTE54_TOKEN = _G.EMOTE54_TOKEN
local EMOTE98_TOKEN = _G.EMOTE98_TOKEN
local UnitInParty = _G.UnitInParty
local UnitInRaid = _G.UnitInRaid

-- Build Spell list (this ignores ranks)
local buffThanksList = {
    [1255] = true, -- Power Word: Fortitude
    [1459] = true, -- Arcane Intellect
    [19742] = true, -- Blessing Of Wisdom
    [19834] = true, -- Blessing Of Might
    [20217] = true, -- Blessing Of Kings
    [467] = true, -- Thorns
    [5231] = true, -- Mark of the Wild
    [5697] = true -- Unending Breath
}

local randomEmoteList = {
    EMOTE123_TOKEN, -- "PRAISE"
    EMOTE21_TOKEN, -- "CHEER"
    EMOTE36_TOKEN, -- "DRINK"
    EMOTE54_TOKEN, -- "HAIL"
    EMOTE98_TOKEN -- "THANK"
}

local emoteCounts = #randomEmoteList
function Module:SetupBuffThanks()
    local _, subevent, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()

    if subevent == "SPELL_AURA_APPLIED" then
        -- Make sure its cast on us from another source and they are not in our raidgroup / party
        -- do not consider source-less buffs, sourceGUID ~= playerGUID is not enough because nil ~= playerGUID == true
        if (destGUID and sourceGUID) and (destGUID == K.GUID) and (sourceGUID ~= destGUID) and not (UnitInParty(sourceName) or UnitInRaid(sourceName)) then
            if buffThanksList[spellName] then
                local srcType = string_split("-", sourceGUID) -- `type` is a reserved word for a Lua function
                -- Make sure the other source is a player
                if srcType == "Player" then
                    local id = fast_random(1, emoteCounts)
                    C_Timer_After(0.5, function() -- Give this more time to say thanks.
                        if not UnitIsDeadOrGhost("player") then
                            DoEmote(randomEmoteList[id], sourceName)
                        end
                    end)
                end
            end
        end
    end
end

function Module:CreateBuffThanks()
	Module:SetupBuffThanks()
end

function Module:OnEnable()
	K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", self.CreateBuffThanks)
end