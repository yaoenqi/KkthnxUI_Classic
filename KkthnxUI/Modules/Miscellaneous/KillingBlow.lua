local K, C = unpack(select(2, ...))
local Module = K:GetModule("Miscellaneous")

-- Sourced: ElvUI Shadow & Light (Darth_Predator, Repooc)

local _G = _G

local gflags = bit.bor(
COMBATLOG_OBJECT_AFFILIATION_MINE,
COMBATLOG_OBJECT_REACTION_FRIENDLY,
COMBATLOG_OBJECT_CONTROL_PLAYER,
COMBATLOG_OBJECT_TYPE_GUARDIAN
)

function Module.COMBAT_LOG_EVENT_UNFILTERED()
	local _, eventType, _, sourceGUID, _, sourceFlags, _, destGUID = CombatLogGetCurrentEventInfo()
	if (sourceGUID == UnitGUID("player") and destGUID ~= UnitGUID("player")) or (sourceGUID == UnitGUID("pet") and (sourceFlags == gflags)) then
		if eventType == "PARTY_KILL" then
			local destGUID, tname = select(8, CombatLogGetCurrentEventInfo())
			local classIndex = select(2, GetPlayerInfoByGUID(destGUID))
			local color = classIndex and RAID_CLASS_COLORS[classIndex] or {r = 0.2, g = 1, b = 0.2}
			UIErrorsFrame:AddMessage("|cff33FF33"..ACTION_PARTY_KILL..": |r"..tname, color.r, color.g, color.b)
		end
	end
end

function Module:CreateKillingBlow()
	if C["Misc"].KillingBlow ~= true then
		return
	end

	K:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", self.COMBAT_LOG_EVENT_UNFILTERED)
end