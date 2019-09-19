local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("DataBars")

local _G = _G
local math_floor = math.floor
local pairs = pairs
local string_format = string.format
local select = select

local backupColor = _G.FACTION_BAR_COLORS[1]
local CreateFrame = _G.CreateFrame
local FACTION_BAR_COLORS = _G.FACTION_BAR_COLORS
local FactionStandingLabelUnknown = _G.UNKNOWN
local GameTooltip = _G.GameTooltip
local GetExpansionLevel = _G.GetExpansionLevel
local GetFactionInfo = _G.GetFactionInfo
local GetNumFactions = _G.GetNumFactions
local GetPetExperience = _G.GetPetExperience
local GetRestrictedAccountData = _G.GetRestrictedAccountData
local GetWatchedFactionInfo = _G.GetWatchedFactionInfo
local GetXPExhaustion = _G.GetXPExhaustion
local LEVEL = _G.LEVEL
local MAX_PLAYER_LEVEL_TABLE = _G.MAX_PLAYER_LEVEL_TABLE
local REPUTATION = _G.REPUTATION
local STANDING = _G.STANDING
local UnitHonor = _G.UnitHonor
local UnitHonorMax = _G.UnitHonorMax
local UnitIsPVP = _G.UnitIsPVP
local UnitLevel = _G.UnitLevel
local UnitXP = _G.UnitXP
local UnitXPMax = _G.UnitXPMax

local function GetUnitXP(unit)
	if (unit == "pet") then
		return GetPetExperience()
	else
		return UnitXP(unit), UnitXPMax(unit)
	end
end

local function IsPlayerMaxLevel()
	local maxLevel = GetRestrictedAccountData()
	if (maxLevel == 0) then
		maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
	end

	return maxLevel == UnitLevel("player")
end

function Module:SetupExperience()
	local expbar = CreateFrame("StatusBar", "KkthnxUI_ExperienceBar", self.Container)
	expbar:SetStatusBarTexture(self.DatabaseTexture)
	expbar:SetStatusBarColor(C["DataBars"].ExperienceColor[1], C["DataBars"].ExperienceColor[2], C["DataBars"].ExperienceColor[3], C["DataBars"].ExperienceColor[4])
	expbar:SetSize(C["DataBars"].Width, C["DataBars"].Height)
	expbar:CreateBorder()

	local restbar = CreateFrame("StatusBar", "KkthnxUI_RestBar", self.Container)
	restbar:SetStatusBarTexture(self.DatabaseTexture)
	restbar:SetStatusBarColor(C["DataBars"].RestedColor[1], C["DataBars"].RestedColor[2], C["DataBars"].RestedColor[3], C["DataBars"].RestedColor[4])
	restbar:SetFrameLevel(3)
	restbar:SetSize(C["DataBars"].Width, C["DataBars"].Height)
	restbar:SetAlpha(0.5)
	restbar:SetAllPoints(expbar)

	local espark = expbar:CreateTexture(nil, "OVERLAY")
	espark:SetTexture(C["Media"].Spark_16)
	espark:SetHeight(C["DataBars"].Height)
	espark:SetBlendMode("ADD")
	espark:SetPoint("CENTER", expbar:GetStatusBarTexture(), "RIGHT", 0, 0)

	local etext = expbar:CreateFontString(nil, "OVERLAY")
	etext:SetFontObject(self.DatabaseFont)
	etext:SetFont(select(1, etext:GetFont()), 11, select(3, etext:GetFont()))
	etext:SetPoint("CENTER")

	self.Bars.Experience = expbar
	expbar.RestBar = restbar
	expbar.Spark = espark
	expbar.Text = etext
end

function Module:SetupReputation()
	local reputation = CreateFrame("StatusBar", "KkthnxUI_ReputationBar", self.Container)
	reputation:SetStatusBarTexture(self.DatabaseTexture)
	reputation:SetStatusBarColor(1, 1, 1)
	reputation:SetSize(C["DataBars"].Width, C["DataBars"].Height)
	reputation:CreateBorder()

	local rspark = reputation:CreateTexture(nil, "OVERLAY")
	rspark:SetTexture(C["Media"].Spark_16)
	rspark:SetHeight(C["DataBars"].Height)
	rspark:SetBlendMode("ADD")
	rspark:SetPoint("CENTER", reputation:GetStatusBarTexture(), "RIGHT", 0, 0)

	local rtext = reputation:CreateFontString(nil, "OVERLAY")
	rtext:SetFontObject(self.DatabaseFont)
	rtext:SetFont(select(1, rtext:GetFont()), 11, select(3, rtext:GetFont()))
	rtext:SetWidth(C["DataBars"].Width - 6)
	rtext:SetWordWrap(false)
	rtext:SetPoint("CENTER")

	self.Bars.Reputation = reputation
	reputation.Spark = rspark
	reputation.Text = rtext
end

function Module:UpdateReputation()
	local ID, standingLabel
	local isCapped
	local name, reaction, min, max, value = GetWatchedFactionInfo()

	if reaction == _G.MAX_REPUTATION_REACTION then
		-- max rank, make it look like a full bar
		min, max, value = 0, 1, 1
		isCapped = true
	end

	local numFactions = GetNumFactions()
	if not name then
		self.Bars.Reputation:Hide()
	elseif name then
		self.Bars.Reputation:Show()

		local text
		local color = FACTION_BAR_COLORS[reaction] or backupColor
		self.Bars.Reputation:SetStatusBarColor(color.r, color.g, color.b)
		self.Bars.Reputation:SetMinMaxValues(min, max)
		self.Bars.Reputation:SetValue(value)

		for i=1, numFactions do
			local factionName, _, standingID = GetFactionInfo(i)
			if factionName == name then
				ID = standingID
			end
		end

		if ID then
			standingLabel = K.ShortenString(_G["FACTION_STANDING_LABEL" .. ID], 1, false) -- F = Friendly, N = Neutral and so on.
		else
			standingLabel = FactionStandingLabelUnknown
		end

		local maxMinDiff = max - min
		if (maxMinDiff == 0) then
			maxMinDiff = 1
		end

		if C["DataBars"].Text then
			if isCapped then
				text = string_format("%s: [%s]", name, standingLabel)
			else
				text = string_format("%s: %s - %d%% [%s]", name, K.ShortValue(value - min), ((value - min) / (maxMinDiff) * 100), standingLabel)
			end

			self.Bars.Reputation.Text:SetText(text)
		end
	end
end

function Module:UpdateExperience()
	local hideXP = ((UnitLevel("player") == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]))

	if hideXP then
		self.Bars.Experience:Hide()
	elseif not hideXP then
		self.Bars.Experience:Show()

		local cur, max = GetUnitXP("player")
		local rested = GetXPExhaustion()

		if max <= 0 then
			max = 1
		end

		self.Bars.Experience:SetMinMaxValues(0, max)
		self.Bars.Experience:SetValue(cur - 1 >= 0 and cur - 1 or 0)
		self.Bars.Experience:SetValue(cur)

		if rested and rested > 0 then
			self.Bars.Experience.RestBar:SetMinMaxValues(0, max)
			self.Bars.Experience.RestBar:SetValue(min(cur + rested, max))

			if C["DataBars"].Text then
				self.Bars.Experience.Text:SetText(string_format("%s - %d%% R:%s [%d%%]", K.ShortValue(cur), cur / max * 100, K.ShortValue(rested), rested / max * 100))
			end
		else
			self.Bars.Experience.RestBar:SetMinMaxValues(0, 1)
			self.Bars.Experience.RestBar:SetValue(0)

			if C["DataBars"].Text then
				self.Bars.Experience.Text:SetText(string_format("%s - %d%%", K.ShortValue(cur), cur / max * 100))
			end
		end
	end
end

function Module:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()

	if C["DataBars"].MouseOver then
		K.UIFrameFadeIn(self.Container, 0.25, self.Container:GetAlpha(), 1)
	end

	if (not IsPlayerMaxLevel()) then
		local cur, max = GetUnitXP("player")
		local rested = GetXPExhaustion()

		GameTooltip:AddDoubleLine(L["Experience"], PLAYER.." "..LEVEL.." ("..K.Level..")", nil, nil, nil, 0.90, 0.80, 0.50)
		GameTooltip:AddDoubleLine(L["XP"], string_format("%s / %s (%d%%)", K.ShortValue(cur), K.ShortValue(max), math_floor(cur / max * 100)), 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Remaining"], string_format("%s (%s%% - %s "..L["Bars"]..")", K.ShortValue(max - cur), math_floor((max - cur) / max * 100), math_floor(20 * (max - cur) / max)), 1, 1, 1)

		if rested then
			GameTooltip:AddDoubleLine(L["Rested"], string_format("+%s (%s%%)", K.ShortValue(rested), math_floor(rested / max * 100)), 1, 1, 1)
		end
		GameTooltip:AddDoubleLine("|TInterface\\TutorialFrame\\UI-TUTORIAL-FRAME:16:12:0:0:512:512:1:76:118:218|t "..L["Middle Click"], L["Share Your Experience"], 1, 1, 1)
	end

	if GetWatchedFactionInfo() then
		if (not IsPlayerMaxLevel()) then
			GameTooltip:AddLine(" ")
		end

		local name, reaction, min, max, value = GetWatchedFactionInfo()
		if name then
			GameTooltip:AddLine(name)

			GameTooltip:AddDoubleLine(STANDING..':', _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
			if reaction ~= _G.MAX_REPUTATION_REACTION then
				GameTooltip:AddDoubleLine(REPUTATION..':', string_format("%d / %d (%d%%)", value - min, max - min, (value - min) / ((max - min == 0) and max or (max - min)) * 100), 1, 1, 1)
			end
			GameTooltip:AddDoubleLine("|TInterface\\TutorialFrame\\UI-TUTORIAL-FRAME:16:12:0:0:512:512:1:76:218:318|t "..L["Left Click"], L["Toggle Reputation"], 1, 1, 1)
		end
	end

	GameTooltip:Show()
end

function Module:OnLeave()
	if C["DataBars"].MouseOver then
		K.UIFrameFadeOut(self.Container, 1, self.Container:GetAlpha(), 0.25)
	end

	GameTooltip:Hide()
end

function Module:OnClick(_, clicked)
	if K.CodeDebug then
		K.Print("|cFFFF0000DEBUG:|r |cFF808080Line 430 - KkthnxUI|Modules|DataBars|Core -|r |cFFFFFF00" .. clicked .. " Clicked|r")
	end

	if clicked == "LeftButton" then
		if GetWatchedFactionInfo() then
			ToggleCharacter("ReputationFrame")
		end
	elseif clicked == "RightButton" then
		if C["DataBars"].TrackHonor then
			if IsPlayerMaxLevel() and UnitIsPVP("player") then
				TogglePVPUI()
			end
		end
	elseif clicked == "MiddleButton" then
		if not IsPlayerMaxLevel() then
			local cur, max = GetUnitXP("player")

			if IsInGroup(LE_PARTY_CATEGORY_HOME) then
				SendChatMessage(L["XP"] .." ".. string_format("%s / %s (%d%%)", K.ShortValue(cur), K.ShortValue(max), math.floor(cur / max * 100)), "PARTY")
				SendChatMessage(L["Remaining"] .." ".. string_format("%s (%s%% - %s "..L["Bars"]..")", K.ShortValue(max - cur), math.floor((max - cur) / max * 100), math.floor(20 * (max - cur) / max)), "PARTY")
			end
		end
	end
end

function Module.OnUpdate()
	Module:UpdateExperience()
	Module:UpdateReputation()

	if C["DataBars"].MouseOver then
		Module.Container:SetAlpha(0.25)
	else
		Module.Container:SetAlpha(1)
	end

	local num_bars = 0
	local prev
	for _, bar in pairs(Module.Bars) do
		if bar:IsShown() then
			num_bars = num_bars + 1

			bar:ClearAllPoints()
			if prev then
				bar:SetPoint("TOP", prev, "BOTTOM", 0, -6)
			else
				bar:SetPoint("TOP", Module.Container)
			end
			prev = bar
		end
	end

	Module.Container:SetHeight(num_bars * (C["DataBars"].Height + 6) - 6)
end

function Module:OnEnable()
	self.DatabaseTexture = K.GetTexture(C["UITextures"].DataBarsTexture)
	self.DatabaseFont = K.GetFont(C["UIFonts"].DataBarsFonts)

	if C["DataBars"].Enable ~= true then
		return
    end

    Module.Bars = {}

	self.Container = CreateFrame("button", "KkthnxUI_Databars", K.PetBattleHider)
	self.Container:SetWidth(C["DataBars"].Width)
	self.Container:SetPoint("TOP", "Minimap", "BOTTOM", 0, -6)
	self.Container:RegisterForClicks("RightButtonUp", "LeftButtonUp", "MiddleButtonUp")

	self.Container:HookScript("OnEnter", self.OnEnter)
	self.Container:HookScript("OnLeave", self.OnLeave)
    self.Container:HookScript("OnClick", self.OnClick)

	self:SetupExperience()
	self:SetupReputation()
	self:OnUpdate()

	K:RegisterEvent("PLAYER_ENTERING_WORLD", self.OnUpdate)
	K:RegisterEvent("PLAYER_LEVEL_UP", self.OnUpdate)
	K:RegisterEvent("PLAYER_XP_UPDATE", self.OnUpdate)
	K:RegisterEvent("UPDATE_EXHAUSTION", self.OnUpdate)
	K:RegisterEvent("DISABLE_XP_GAIN", self.OnUpdate)
	K:RegisterEvent("ENABLE_XP_GAIN", self.OnUpdate)
	K:RegisterEvent("UPDATE_FACTION", self.OnUpdate)
	K:RegisterEvent("UNIT_INVENTORY_CHANGED", self.OnUpdate)
	K:RegisterEvent("PLAYER_FLAGS_CHANGED", self.OnUpdate)

	K.Mover(self.Container, "DataBars", "DataBars", {"TOP", "Minimap", "BOTTOM", 0, -6}, C["DataBars"].Width, self.Container:GetHeight())
end
