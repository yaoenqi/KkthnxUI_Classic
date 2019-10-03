local K, C, L = unpack(select(2, ...))
local oUF = oUF or K.oUF

if not oUF then
	K.Print("Could not find a vaild instance of oUF. Tags.lua code!")
	return
end

local _G = _G
local math_floor = _G.math.floor
local string_format = _G.string.format

local ALTERNATE_POWER_INDEX = _G.ALTERNATE_POWER_INDEX
local CHAT_MSG_AFK = _G.CHAT_MSG_AFK
local DEAD = _G.DEAD
local DND = _G.DND
local GetCreatureDifficultyColor = _G.GetCreatureDifficultyColor
local GetPetHappiness = _G.GetPetHappiness
local HasPetUI = _G.HasPetUI
local PLAYER_OFFLINE = _G.PLAYER_OFFLINE
local UnitClass = _G.UnitClass
local UnitClassification = _G.UnitClassification
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitIsAFK = _G.UnitIsAFK
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDND = _G.UnitIsDND
local UnitIsDead = _G.UnitIsDead
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitIsGhost = _G.UnitIsGhost
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsTapDenied = _G.UnitIsTapDenied
local UnitLevel = _G.UnitLevel
local UnitName = _G.UnitName
local UnitPlayerControlled = _G.UnitPlayerControlled
local UnitPower = _G.UnitPower
local UnitPowerMax = _G.UnitPowerMax
local UnitPowerType = _G.UnitPowerType
local UnitReaction = _G.UnitReaction

local function GetRealHealth(unit)
	if _G.RealMobHealth and unit and not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) then
		local c, m, _, _ = _G.RealMobHealth.GetUnitHealth(unit);
		return c, m
	elseif _G.MobHealthFrame and unit and not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) then
		local name, level = UnitName(unit), UnitLevel(unit)
		local cur, full = _G.MI2_GetMobData(name, level, unit).healthCur, _G.MI2_GetMobData(name, level, unit).healthMax
		return cur, full
	else
		return UnitHealth(unit), UnitHealthMax(unit)
	end
end

local function ColorPercent(value)
	local r, g, b
	if value < 20 then
		r, g, b = 1, .1, .1
	elseif value < 35 then
		r, g, b = 1, .5, 0
	elseif value < 80 then
		r, g, b = 1, .9, .3
	else
		r, g, b = 1, 1, 1
	end

	return K.RGBToHex(r, g, b)..value
end

local function ValueAndPercent(cur, per)
	if per < 100 then
		return K.ShortValue(cur).." - "..ColorPercent(per)
	else
		return K.ShortValue(cur)
	end
end

oUF.Tags.Methods["hp"] = function(unit)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["DDG"](unit)
	else
		local per = oUF.Tags.Methods["perhp"](unit) or 0
		local cur = GetRealHealth(unit)
		if unit == "player" or unit == "target" then
			return ValueAndPercent(cur, per)
		else
			return ColorPercent(per)
		end
	end
end
oUF.Tags.Events["hp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["power"] = function(unit)
	local cur = UnitPower(unit)
	local per = oUF.Tags.Methods["perpp"](unit) or 0
	if unit == "player" or unit == "target" then
		if UnitPower(unit, UnitPowerType(unit)) == 0 then
			return ""
		elseif per < 100 and UnitPowerType(unit) == 0 then
			return K.ShortValue(cur).." - "..per
		else
			return K.ShortValue(cur)
		end
	else
		return per
    end
end
oUF.Tags.Events["power"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER"

oUF.Tags.Methods["color"] = function(unit)
	local class = select(2, UnitClass(unit))
	local reaction = UnitReaction(unit, "player")

	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return "|cffA0A0A0"
	elseif UnitIsTapDenied(unit) then
		return K.RGBToHex(oUF.colors.tapped)
	elseif UnitIsPlayer(unit) then
		return K.RGBToHex(K.Colors.class[class])
	elseif reaction then
		return K.RGBToHex(K.Colors.reaction[reaction])
	else
		return K.RGBToHex(1, 1, 1)
	end
end
oUF.Tags.Events["color"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_FACTION UNIT_CONNECTION PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["afkdnd"] = function(unit)
	if UnitIsAFK(unit) then
		return "|cffCFCFCF <"..CHAT_MSG_AFK..">|r"
	elseif UnitIsDND(unit) then
		return "|cffCFCFCF <"..DND..">|r"
	else
		return ""
	end
end
oUF.Tags.Events["afkdnd"] = "PLAYER_FLAGS_CHANGED"

oUF.Tags.Methods["DDG"] = function(unit)
	if UnitIsDead(unit) then
		return "|cffCFCFCF"..DEAD.."|r"
	elseif UnitIsGhost(unit) then
		return "|cffCFCFCF"..L["Ghost"].."|r"
	elseif not UnitIsConnected(unit) then
		return "|cffCFCFCF"..PLAYER_OFFLINE.."|r"
	end
end
oUF.Tags.Events["DDG"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"

-- Level tags
oUF.Tags.Methods["fulllevel"] = function(unit)
	local level = UnitLevel(unit)
	local color = K.RGBToHex(GetCreatureDifficultyColor(level))
	if level > 0 then
		level = color..level.."|r"
	else
		level = "|cffff0000??|r"
	end
	local str = level

	local class = UnitClassification(unit)
	if not UnitIsConnected(unit) then
		str = "??"
	elseif class == "worldboss" then
		str = string_format("|cffFF0000 %s|r", BOSS)
	elseif class == "rareelite" then
		str = level..string_format("|cffFF0000+ %s|r", ITEM_QUALITY3_DESC)
	elseif class == "elite" then
		str = level.."|cffFF8040+|r"
	elseif class == "rare" then
		str = level..string_format("|cffFF8040 %s|r", ITEM_QUALITY3_DESC)
	end

	return str
end
oUF.Tags.Events["fulllevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

-- RaidFrame tags
oUF.Tags.Methods["raidhp"] = function(unit)
	if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
		return oUF.Tags.Methods["DDG"](unit)
	elseif C["Raid"].HealthFormat.Value == 2 then
		local per = oUF.Tags.Methods["perhp"](unit) or 0
		return ColorPercent(per)
	elseif C["Raid"].HealthFormat.Value == 3 then
		local cur = UnitHealth(unit)
		return K.ShortValue(cur)
	elseif C["Raid"].HealthFormat.Value == 4 then
		local loss = UnitHealthMax(unit) - UnitHealth(unit)
		if loss == 0 then return end
		return K.ShortValue(loss)
	end
end
oUF.Tags.Events["raidhp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_NAME_UPDATE UNIT_CONNECTION PLAYER_FLAGS_CHANGED"

-- Nameplate tags
oUF.Tags.Methods["nphp"] = function(unit)
	local per = oUF.Tags.Methods["perhp"](unit) or 0
	if C["Nameplates"].ShowFullHealth then
		local cur = GetRealHealth(unit)
		return ValueAndPercent(cur, per)
	elseif per < 100 then
		return ColorPercent(per)
	end
end
oUF.Tags.Events["nphp"] = "UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_CONNECTION"

oUF.Tags.Methods["nppp"] = function(unit)
	local per = oUF.Tags.Methods["perpp"](unit)
	local color
	if per > 85 then
		color = K.RGBToHex(1, .1, .1)
	elseif per > 50 then
		color = K.RGBToHex(1, 1, .1)
	else
		color = K.RGBToHex(.8, .8, 1)
	end
	per = color..per.."|r"

	return per
end
oUF.Tags.Events["nppp"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER"

oUF.Tags.Methods["nplevel"] = function(unit)
	local level = UnitLevel(unit)
	if level and level ~= UnitLevel("player") then
		if level > 0 then
			level = K.RGBToHex(GetCreatureDifficultyColor(level))..level.."|r "
		else
			level = "|cffff0000??|r "
		end
	else
		level = ""
	end

	return level
end
oUF.Tags.Events["nplevel"] = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"

oUF.Tags.Methods["pppower"] = function(unit)
	local cur = UnitPower(unit)
	local per = oUF.Tags.Methods["perpp"](unit) or 0
	if UnitPowerType(unit) == 0 then
		return per
	else
		return cur
	end
end
oUF.Tags.Events["pppower"] = "UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER"

-- AltPower value tag
oUF.Tags.Methods["altpower"] = function(unit)
	local cur = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return string_format("%s%%", math_floor(cur / max*100 + .5))
	end
end
oUF.Tags.Events["altpower"] = "UNIT_POWER_UPDATE"

oUF.Tags.Methods["pethappiness"] = function(unit)
	local hasPetUI, isHunterPet = HasPetUI()
	if (unit == "pet" and hasPetUI and isHunterPet) then
		local left, right, top, bottom
		local happiness = GetPetHappiness()

		if (happiness == 1) then
			left, right, top, bottom = 0.375, 0.5625, 0, 0.359375
		elseif (happiness == 2) then
			left, right, top, bottom = 0.1875, 0.375, 0, 0.359375
		elseif (happiness == 3) then
			left, right, top, bottom = 0, 0.1875, 0, 0.359375
		end

		return CreateTextureMarkup([[Interface\PetPaperDollFrame\UI-PetHappiness]], 128, 64, 18, 16, left, right, top, bottom, 0, 0)
	end
end
oUF.Tags.Events["pethappiness"] = "UNIT_HAPPINESS PET_UI_UPDATE"

oUF.Tags.Events["leadassist"] = "UNIT_NAME_UPDATE PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"
oUF.Tags.Methods["leadassist"] = function(unit)
	local IsLeader = UnitIsGroupLeader(unit)
	local IsAssistant = UnitIsGroupAssistant(unit) or UnitIsRaidOfficer(unit)
	local Assist, Lead = IsAssistant and "|cffffd100[A]|r " or "", IsLeader and "|cffffd100[L]|r " or ""

	return (Lead..Assist)
end

