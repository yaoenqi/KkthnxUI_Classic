local K, C = unpack(select(2, ...))
if C["DataText"].System ~= true then
	return
end

local _G = _G
local string_format = _G.string.format
local unpack = _G.unpack

local COMBAT_ZONE = _G.COMBAT_ZONE
local CONTESTED_TERRITORY = _G.CONTESTED_TERRITORY
local FACTION_CONTROLLED_TERRITORY = _G.FACTION_CONTROLLED_TERRITORY
local FACTION_STANDING_LABEL4 = _G.FACTION_STANDING_LABEL4
local FREE_FOR_ALL_TERRITORY = _G.FREE_FOR_ALL_TERRITORY
local GetSubZoneText = _G.GetSubZoneText
local GetZonePVPInfo = _G.GetZonePVPInfo
local GetZoneText = _G.GetZoneText
local InCombatLockdown = _G.InCombatLockdown
local IsInInstance = _G.IsInInstance
local SANCTUARY_TERRITORY = _G.SANCTUARY_TERRITORY

local module = K:GetModule("Infobar")
local info = module:RegisterInfobar("KkthnxUILocation", {"TOP", Minimap, "TOP", 0, -4})

local zoneInfo = {
	sanctuary = {SANCTUARY_TERRITORY, {0.035, 0.58, 0.84}},
	arena = {FREE_FOR_ALL_TERRITORY, {0.84, 0.03, 0.03}},
	friendly = {FACTION_CONTROLLED_TERRITORY, {0.05, 0.85, 0.03}},
	hostile = {FACTION_CONTROLLED_TERRITORY, {0.84, 0.03, 0.03}},
	contested = {CONTESTED_TERRITORY, {0.9, 0.85, 0.05}},
	combat = {COMBAT_ZONE, {0.84, 0.03, 0.03}},
	neutral = {string_format(FACTION_CONTROLLED_TERRITORY, FACTION_STANDING_LABEL4), {0.9, 0.85, 0.05}}
}

local subzone, zone, pvpType, faction

info.eventList = {
	"ZONE_CHANGED",
	"ZONE_CHANGED_INDOORS",
	"ZONE_CHANGED_NEW_AREA",
	"PLAYER_ENTERING_WORLD",
}

info.onEvent = function(self)
	subzone = GetSubZoneText()
	zone = GetZoneText()
	pvpType, _, faction = GetZonePVPInfo()
	pvpType = pvpType or "neutral"

	local r, g, b = unpack(zoneInfo[pvpType][2])
	self.text:SetText((subzone ~= "") and subzone or zone)
	self.text:SetTextColor(r, g, b)
	self.text:SetJustifyH("CENTER")
	self.text:SetJustifyV("MIDDLE")
end

info.onEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(K.GetAnchors(self))
	GameTooltip:ClearLines()

	if pvpType and not IsInInstance() then
		local r, g, b = unpack(zoneInfo[pvpType][2])
		if subzone and subzone ~= zone then
			GameTooltip:AddLine(subzone, r, g, b)
		end
		GameTooltip:AddLine(string_format(zoneInfo[pvpType][1], faction or ""), r, g, b)
	end

	GameTooltip:Show()
end

info.onLeave = function()
	GameTooltip:Hide()
end

info.onMouseUp = function(_, btn)
	if btn == "LeftButton" then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(K.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleFrame(WorldMapFrame)
	end
end