local K = unpack(select(2, ...))
local ThreatLib = LibStub:GetLibrary("ThreatClassic-1.0")

local _G = _G

local GetTalentTabInfo = _G.GetTalentTabInfo
local GetBonusBarOffset = _G.GetBonusBarOffset
local UnitStat = _G.UnitStat
local UnitAttackPower = _G.UnitAttackPower
local GetSpellInfo = _G.GetSpellInfo

-- Message for BG Queues (temporary)
local hasShown = false

local PvPMessage = CreateFrame("Frame")
PvPMessage:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
PvPMessage:SetScript("OnEvent", function()
	if not hasShown and StaticPopup_Visible("CONFIRM_BATTLEFIELD_ENTRY") then
		hasShown = true
		print("|cffffff00".."There is an issue with entering BGs from the StaticPopupDialog. Please enter by right clicking the minimap icon.".."|r")
	else
		hasShown = false
	end
end)

-- NOOP / Pass Functions not found in Classic
UnitInVehicle = _G.UnitInVehicle or K.Noop

-- Specialization Functions
function K.GetSpecialization(...)
	local current = {}
	local primaryTree = 1
	for i = 1, 3 do
		_, _, current[i] = GetTalentTabInfo(i, "player", nil)
		if current[i] > current[primaryTree] then
			primaryTree = i
		end
	end
	return primaryTree
end

function K.GetSpecializationRole()
	local tree = K.GetSpecialization()
	local role
	if ((K.Class == "PALADIN" and tree == 2) or (K.Class == "WARRIOR" and tree == 3)) or (K.Class == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		role = "TANK"
	elseif ((K.Class == "PALADIN" and tree == 1) or (K.Class == "DRUID" and tree == 3) or (K.Class == "SHAMAN" and tree == 3) or (K.Class == "PRIEST" and tree ~= 3)) then
		role = "HEALER"
	else
		local int = select(2, UnitStat("player", 4))
		local agi = select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player")
		local ap = base + posBuff + negBuff

		if (((ap > int) or (agi > int)) and not (K.Class == "SHAMAN" and tree ~= 1 and tree ~= 3) and not AuraUtil.FindAuraByName(GetSpellInfo(24858), "player")) or K.Class == "ROGUE" or K.Class == "HUNTER" or (K.Class == "SHAMAN" and tree == 2) then
			role = "MELEE" -- ordinarily "DAMAGER"
		else
			role = "CASTER" -- ordinarily "DAMAGER"
		end
	end

	return role
end

UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned or function(unit) -- Needs work
	if unit == "player" then
		local role = K.GetSpecializationRole()
		if role == "MELEE" or role == "CASTER" then
			role = "DAMAGER"
		else
			role = role or ""
		end

		return role
	end
end

-- Threat Functions
if ThreatLib then
	local ThreatFrame = CreateFrame("Frame")

	ThreatLib.RegisterCallback(ThreatFrame, "Activate", K.Noop)
	ThreatLib.RegisterCallback(ThreatFrame, "Deactivate", K.Noop)
	ThreatLib:RequestActiveOnSolo(true)

	GetThreatStatusColor = _G.GetThreatStatusColor or function(statusIndex)
		return ThreatLib:GetThreatStatusColor(statusIndex)
	end

	UnitDetailedThreatSituation = _G.UnitDetailedThreatSituation or function(unit, target)
		return ThreatLib:UnitDetailedThreatSituation(unit, target)
	end

	UnitThreatSituation = _G.UnitThreatSituation or function(unit, target)
		return ThreatLib:UnitThreatSituation(unit, target)
	end
end