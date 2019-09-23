local K, C, L = unpack(select(2, ...))

if K.Realm ~= "Incendius" and K.Name ~= "Kkthnx" then
	return
end

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
local Module = CreateFrame("Frame")

-- short/simple non-namespaced global function names are bad, other addons may end up overwriting ours or ours overwrites theirs, let's make it local.
local function Set(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end

	return set
end

Module:SetScript("OnEvent", function(self, event)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		self:OnCombatEvent(event, CombatLogGetCurrentEventInfo())
	else
		return self[event] and self[event](self)
	end
end)

-- Build Spell list (this ignores ranks)
local buffThanksList = Set{
	(GetSpellInfo(5231)), -- Mark of the Wild
	(GetSpellInfo(467)), -- Thorns
	(GetSpellInfo(1459)), -- Arcane Intellect
	(GetSpellInfo(19834)), -- Blessing Of Might
	(GetSpellInfo(20217)), -- Blessing Of Kings
	(GetSpellInfo(19742)), -- Blessing Of Wisdom
	(GetSpellInfo(1255)), -- Power Word: Fortitude
	(GetSpellInfo(5697)), -- Unending Breath
}

-- we will conditionally register our combat parser to avoid emoting for already applied buffs after loading screens
Module:RegisterEvent("PLAYER_ENTERING_WORLD")
Module:RegisterEvent("PLAYER_LEAVING_WORLD")

-- we're about to enter a loading screen (instance or mage portal, boat, zeppelin or tram, summon etc), unregister our combat parser
function Module:PLAYER_LEAVING_WORLD()
	Module:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end
-- we're exiting the loading screen, start monitoring for new buffs again
function Module:PLAYER_ENTERING_WORLD()
	Module:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Module._enter = GetTime()
end

function Module:OnCombatEvent(_, ...)
	local _, subevent, _, sourceGUID, sourceName, _, _, destGUID = ...
	local spellName = select(13, ...)

	local now = GetTime()
	if Module._enter and now - Module._enter < 2 then
		return
	end

	if subevent == "SPELL_AURA_APPLIED" then
		-- Make sure its cast on us from another source and they are not in our raidgroup / party
		-- do not consider source-less buffs, sourceGUID ~= playerGUID is not enough because nil ~= playerGUID == true
		if (destGUID and sourceGUID) and (destGUID == playerGUID) and (sourceGUID ~= destGUID) and not (UnitInParty(sourceName) or UnitInRaid(sourceName)) then
			if buffThanksList[spellName] then
				local srcType = string_split("-", sourceGUID) -- `type` is a reserved word for a Lua function
				-- Make sure the other source is a player
				if srcType == "Player" then
					C_Timer_After(0.6, function() -- Give this more time to say thanks.
						DoEmote(EMOTE98_TOKEN, sourceName)
					end)
				end
			end
		end
	end
end