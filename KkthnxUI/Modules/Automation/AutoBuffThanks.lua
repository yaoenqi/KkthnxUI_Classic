local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G
local string_split = _G.string.split

local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local EMOTE98_TOKEN = _G.EMOTE98_TOKEN
local UnitInParty = _G.UnitInParty
local UnitInRaid = _G.UnitInRaid
local GetTime = _G.GetTime
local UnitGUID = _G.UnitGUID
local CreateFrame = _G.CreateFrame
local GetSpellInfo = _G.GetSpellInfo

local playerGUID = UnitGUID("player")

-- Build Spell list (this ignores ranks)
local AutoBuffThanksList = {
	(GetSpellInfo(1255)), -- Power Word: Fortitude
	(GetSpellInfo(1459)), -- Arcane Intellect
	(GetSpellInfo(19742)), -- Blessing Of Wisdom
	(GetSpellInfo(19834)), -- Blessing Of Might
	(GetSpellInfo(20217)), -- Blessing Of Kings
	(GetSpellInfo(467)), -- Thorns
	(GetSpellInfo(5231)), -- Mark of the Wild
	(GetSpellInfo(5697)), -- Unending Breath
}

function Module:SetupAutoBuffThanksAnnounce()
	local _, event, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, _, spellName = CombatLogGetCurrentEventInfo()

	if not (event == "SPELL_AURA_APPLIED") then
		return
	end

	-- Make sure its cast on us from another source and they are not in our raidgroup / party
	-- do not consider source-less buffs, sourceGUID ~= playerGUID is not enough because nil ~= playerGUID == true
	if (destGUID and sourceGUID) and (destGUID == playerGUID) and (sourceGUID ~= destGUID) and not (UnitInParty(sourceName) or UnitInRaid(sourceName)) then
		if AutoBuffThanksList[spellName] then
			local sourceType = string_split("-", sourceGUID) -- `type` is a reserved word for a Lua function
			-- Make sure the other source is a player
			if sourceType == "player" then
				K.Delay(1.0, function() -- Give this more time to say thanks, so we do not look like we are bots.
					DoEmote(EMOTE98_TOKEN, sourceName)
				end)
			end
		end
	end
end

function Module:CreateAutoBuffThanksAnnounce()
	if IsAddOnLoaded("TFTB") or C["Automation"].BuffThanks ~= true then
		return
	end

	K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", self.SetupAutoBuffThanksAnnounce)
end