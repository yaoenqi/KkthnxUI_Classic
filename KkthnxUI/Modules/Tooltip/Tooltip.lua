local K, C, L = unpack(select(2, ...))
local Module = K:NewModule("Tooltip", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")

local _G = _G
local string_find = _G.string.find
local string_format = _G.string.format
local string_upper = _G.string.upper
local unpack = _G.unpack
local string_len = _G.string.len

local AFK = _G.AFK
local BAG_ITEM_QUALITY_COLORS = _G.BAG_ITEM_QUALITY_COLORS
local BOSS = _G.BOSS
local CreateFrame = _G.CreateFrame
local DEAD = _G.DEAD
local DND = _G.DND
local FACTION_ALLIANCE = _G.FACTION_ALLIANCE
local FACTION_HORDE = _G.FACTION_HORDE
local FOREIGN_SERVER_LABEL = _G.FOREIGN_SERVER_LABEL or "(*)"
local GetCreatureDifficultyColor = _G.GetCreatureDifficultyColor
local GetGuildInfo = _G.GetGuildInfo
local GetItemInfo = _G.GetItemInfo
local GetMouseFocus = _G.GetMouseFocus
local GetRaidTargetIndex = _G.GetRaidTargetIndex
local ICON_LIST = _G.ICON_LIST
local INTERACTIVE_SERVER_LABEL = _G.INTERACTIVE_SERVER_LABEL or "(#)"
local ITEM_QUALITY3_DESC = _G.ITEM_QUALITY3_DESC
local InCombatLockdown = _G.InCombatLockdown
local IsAddOnLoaded = _G.IsAddOnLoaded
local IsInGuild = _G.IsInGuild
local IsShiftKeyDown = _G.IsShiftKeyDown
local LEVEL = _G.LEVEL
local LE_REALM_RELATION_COALESCED = _G.LE_REALM_RELATION_COALESCED or 2
local LE_REALM_RELATION_VIRTUAL = _G.LE_REALM_RELATION_VIRTUAL or 3
local PLAYER_OFFLINE = _G.PLAYER_OFFLINE
local PVP = _G.PVP
local TARGET = _G.TARGET
local UIDROPDOWNMENU_MAXLEVELS = _G.UIDROPDOWNMENU_MAXLEVELS or 2
local UIParent = _G.UIParent
local UnitClass = _G.UnitClass
local UnitClassification = _G.UnitClassification
local UnitCreatureType = _G.UnitCreatureType
local UnitExists = _G.UnitExists
local UnitFactionGroup = _G.UnitFactionGroup
-- local UnitGroupRolesAssigned = _G.UnitGroupRolesAssigned
local UnitIsAFK = _G.UnitIsAFK
local UnitIsConnected = _G.UnitIsConnected
local UnitIsDND = _G.UnitIsDND
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local UnitIsPVP = _G.UnitIsPVP
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsUnit = _G.UnitIsUnit
local UnitLevel = _G.UnitLevel
local UnitName = _G.UnitName
local UnitPVPName = _G.UnitPVPName
local UnitRace = _G.UnitRace
local UnitRealmRelationship = _G.UnitRealmRelationship
local YOU = _G.YOU
local hooksecurefunc = _G.hooksecurefunc

local tooltipTexture = K.GetTexture(C["UITextures"].TooltipTextures)
local tooltipFont = K.GetFont(C["UIFonts"].TooltipFonts)

local classification = {
	worldboss = string_format("|cffFF0000 %s|r", BOSS),
	rareelite = string_format("|cffFF0000+ %s|r", ITEM_QUALITY3_DESC),
	elite = "|cffFF8040+|r",
	rare = string_format("|cffFF8040 %s|r", ITEM_QUALITY3_DESC)
}

function Module:GetUnit()
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))) or "mouseover"
	end

	return unit
end

function Module:HideLines()
    for i = 3, self:NumLines() do
        local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext then
			if linetext == PVP then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif linetext == FACTION_HORDE then
				if C["Tooltip"].FactionIcon then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040"..linetext.."|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if C["Tooltip"].FactionIcon then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff"..linetext.."|r")
				end
			end
		end
    end
end

function Module:GetLevelLine()
	for i = 2, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext and string_find(linetext, LEVEL) then
			return tiptext
		end
	end
end

function Module:GetTarget(unit)
	if UnitIsUnit(unit, "player") then
		return string_format("|cffff0000%s|r", ">"..string_upper(YOU).."<")
	else
		return K.RGBToHex(K.UnitColor(unit))..UnitName(unit).."|r"
	end
end

function Module:InsertFactionFrame(faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", 0, -4)
		f:SetBlendMode("ADD")
		f:SetSize(32, 32)
		self.factionFrame = f
	end

	self.factionFrame:SetTexture("Interface\\Timer\\"..faction.."-Logo")
	self.factionFrame:SetAlpha(0.3)
end

function Module:OnTooltipCleared()
	if self.factionFrame and self.factionFrame:GetAlpha() ~= 0 then
		self.factionFrame:SetAlpha(0)
	end
end

function Module:OnTooltipSetUnit()
	if self:IsForbidden() then
		return
	end

	if C["Tooltip"].CombatHide and InCombatLockdown() then
		self:Hide()
		return
	end

	Module.HideLines(self)

	local unit = Module.GetUnit(self)
	local isShiftKeyDown = IsShiftKeyDown()
	if UnitExists(unit) then
		local hexColor = K.RGBToHex(K.UnitColor(unit))
		local ricon = GetRaidTargetIndex(unit)
		local text = GameTooltipTextLeft1:GetText()
		if ricon and ricon > 8 then
			ricon = nil
		end

		if ricon and text then
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."18|t", text)
		end

		local isPlayer = UnitIsPlayer(unit)
		if isPlayer then
			local name, realm = UnitName(unit)
			local pvpName = UnitPVPName(unit)
			local relationship = UnitRealmRelationship(unit)
			if not C["Tooltip"].HideTitle and pvpName then
				name = pvpName
			end
			if realm and realm ~= "" then
				if isShiftKeyDown or not C["Tooltip"].HideRealm then
					name = name.."-"..realm
				elseif relationship == LE_REALM_RELATION_COALESCED then
					name = name..FOREIGN_SERVER_LABEL
				elseif relationship == LE_REALM_RELATION_VIRTUAL then
					name = name..INTERACTIVE_SERVER_LABEL
				end
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				status = string_format(" |cffffcc00[%s]|r", status)
			end
			GameTooltipTextLeft1:SetFormattedText("%s", name..(status or ""))

			if C["Tooltip"].FactionIcon then
				local faction = UnitFactionGroup(unit)
				if faction and faction ~= "Neutral" then
					Module.InsertFactionFrame(self, faction)
				end
			end

			-- if C["Tooltip"].LFDRole then
			-- 	local role = UnitGroupRolesAssigned(unit)
			-- 	if IsInGroup() and (UnitInParty(unit) or UnitInRaid(unit)) and (role ~= "NONE") then
			-- 		if role == "HEALER" then
			-- 			role = "|CFF00FF96"..HEALER.."|r"
			-- 		elseif role == "TANK" then
			-- 			role = "|CFF294F9C"..TANK.."|r"
			-- 		elseif role == "DAMAGER" then
			-- 			role = "|CFFC41F3D"..DAMAGE.."|r"
			-- 		end

			-- 		GameTooltip:AddLine(string_format("%s: %s", _G.ROLE, role))
			-- 	end
			-- end

			local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
			local hasText = GameTooltipTextLeft2:GetText()
			if guildName and hasText then
				local myGuild, _, _, myGuildRealm = GetGuildInfo("player")
				if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
					GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
				else
					GameTooltipTextLeft2:SetTextColor(.6, .8, 1)
				end

				rankIndex = rankIndex + 1
				if C["Tooltip"].HideRank then
					rank = ""
				end

				if guildRealm and isShiftKeyDown then
					guildName = guildName.."-"..guildRealm
				end

				if C["Tooltip"].HideJunkGuild and not isShiftKeyDown then
					if string_len(guildName) > 31 then
						guildName = "..."
					end
				end
				GameTooltipTextLeft2:SetText("<"..guildName.."> "..rank.."("..rankIndex..")")
			end
		end

		local line1 = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText("%s", hexColor..line1)

		local alive = not UnitIsDeadOrGhost(unit)
		local level = UnitLevel(unit)
		if level then
			local boss
			if level == -1 then
				boss = "|cffff0000??|r"
			end

			local diff = GetCreatureDifficultyColor(level)
			local classify = UnitClassification(unit)
			local textLevel = string_format("%s%s%s|r", K.RGBToHex(diff), boss or string_format("%d", level), classification[classify] or "")
			local tiptextLevel = Module.GetLevelLine(self)
			if tiptextLevel then
				local pvpFlag = isPlayer and UnitIsPVP(unit) and string_format(" |cffff0000%s|r", PVP) or ""
				local unitClass = isPlayer and string_format("%s %s", UnitRace(unit) or "", hexColor..(UnitClass(unit) or "").."|r") or UnitCreatureType(unit) or ""
				tiptextLevel:SetFormattedText(("%s%s %s %s"), textLevel, pvpFlag, unitClass, (not alive and "|cffCCCCCC"..DEAD.."|r" or ""))
			end
		end

		if UnitExists(unit.."target") then
			local tarRicon = GetRaidTargetIndex(unit.."target")
			if tarRicon and tarRicon > 8 then
				tarRicon = nil
			end

			local tar = string_format("%s%s", (tarRicon and ICON_LIST[tarRicon].."10|t") or "", Module:GetTarget(unit.."target"))
			self:AddLine(TARGET..": "..tar)
		end

		if alive then
			GameTooltipStatusBar:SetStatusBarColor(K.UnitColor(unit))
		else
			GameTooltipStatusBar:Hide()
		end
	else
		GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
	end

	Module.InspectUnitSpecAndLevel(self)
end

function Module:StatusBar_OnValueChanged(value)
	if self:IsForbidden() or not value then return end

	local unit = select(2, self:GetParent():GetUnit())
	if(not unit) then
		local GMF = GetMouseFocus()
		if(GMF and GMF.GetAttribute and GMF:GetAttribute("unit")) then
			unit = GMF:GetAttribute("unit")
		end
	end

	local _, max = self:GetMinMaxValues()

	if not self.text then
		self.text = K.CreateFontString(self, 11, "")
	end

	if (value > 0 and max == 1) then
		self.text:SetFormattedText("%d%%", math.floor(value * 100))
		self:SetStatusBarColor(0.6, 0.6, 0.6)
	elseif (value == 0 or (unit and UnitIsDeadOrGhost(unit))) then
		self.text:SetText(_G.DEAD)
	else
		if unit and not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) and RealMobHealth then
			local c, m, _, _ = RealMobHealth.GetUnitHealth(unit);
			self.text:SetText(c.." / "..m)
		else
			self.text:SetText(value.." / "..max)
		end
	end
end

function Module:ReskinStatusBar()
	GameTooltipStatusBar:ClearAllPoints()
	GameTooltipStatusBar:SetPoint("BOTTOMLEFT", GameTooltip, "TOPLEFT", 2, 4)
	GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -2, 4)
	GameTooltipStatusBar:SetStatusBarTexture(tooltipTexture)
	GameTooltipStatusBar:SetHeight(10)
	GameTooltipStatusBar:CreateBorder()
end

function Module:GameTooltip_ShowStatusBar()
	if self.statusBarPool then
		local bar = self.statusBarPool:Acquire()
		if bar and not bar.styled then
			local tex = select(3, bar:GetRegions())
			tex:SetTexture(tooltipTexture)
			bar:CreateBorder(nil, nil, nil, true)

			bar.styled = true
		end
	end
end

function Module:GameTooltip_ShowProgressBar()
	if self.progressBarPool then
		local bar = self.progressBarPool:Acquire()
		if bar and not bar.styled then
			bar.Bar:SetStatusBarTexture(tooltipTexture)
			bar.Bar:CreateBorder(nil, nil, nil, true)

			bar.styled = true
		end
	end
end

-- Anchor and mover
local mover
function Module:GameTooltip_SetDefaultAnchor(parent)
	if C["Tooltip"].Cursor then
		self:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
	else
		if not mover then
			mover = K.Mover(self, "Tooltip", "GameTooltip", {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -182, 36}, 240, 120)
		end

		self:SetOwner(parent, "ANCHOR_NONE")
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", mover)
	end
end

-- Tooltip skin
local function getBackdrop(self)
	return self.bg:GetBackdrop()
end

local function getBackdropColor()
	return 0.04, 0.04, 0.04, 0.9
end

local function getBackdropBorderColor()
	return 1, 1, 1
end

function Module:ReskinTooltip()
	if not self then
		print("Unknown tooltip spotted. Tell Kkthnx!")
		return
	end

	if self:IsForbidden() then
		return
	end

	if not self.tipStyled then
		self:SetBackdrop(nil)
		self:DisableDrawLayer("BACKGROUND")

		if self:GetObjectType() == "Texture" then
			self = self:GetParent()
		end

		local lvl = self:GetFrameLevel()
		local bg = CreateFrame("Frame", nil, self)
		bg:SetPoint("TOPLEFT", self, 2, -2) -- Might need to be 0
		bg:SetPoint("BOTTOMRIGHT", self, -2, 2) -- Might need to be 0
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
		bg:CreateBorder()
		self.bg = bg

		-- other gametooltip-like support
		self.GetBackdrop = getBackdrop
		self.GetBackdropColor = getBackdropColor
		self.GetBackdropBorderColor = getBackdropBorderColor

		self.tipStyled = true
	end
	self.bg:SetBackdropBorderColor()

	if C["Tooltip"].ClassColor and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			if color then
				self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end

	if self.NumLines and self:NumLines() > 0 then
		for index = 1, self:NumLines() do
			if index == 1 then
				_G[self:GetName().."TextLeft"..index]:SetFontObject(tooltipFont)
				_G[self:GetName().."TextLeft"..index]:SetFont(select(1, _G[self:GetName().."TextLeft"..index]:GetFont()), 13, select(3, _G[self:GetName().."TextLeft"..index]:GetFont()))
			else
				_G[self:GetName().."TextLeft"..index]:SetFontObject(tooltipFont)
				_G[self:GetName().."TextLeft"..index]:SetFont(select(1, _G[self:GetName().."TextLeft"..index]:GetFont()), 12, select(3, _G[self:GetName().."TextLeft"..index]:GetFont()))
			end
			_G[self:GetName().."TextRight"..index]:SetFontObject(tooltipFont)
			_G[self:GetName().."TextRight"..index]:SetFont(select(1, _G[self:GetName().."TextLeft"..index]:GetFont()), 12, select(3, _G[self:GetName().."TextLeft"..index]:GetFont()))
		end
	end
end

function Module:GameTooltip_SetBackdropStyle()
	if not self.tipStyled then
		return
	end

	self:SetBackdrop(nil)
end

function Module:OnEnable()
	self:ReskinStatusBar()
	_G.GameTooltip:HookScript("OnTooltipCleared", self.OnTooltipCleared)
	_G.GameTooltip:HookScript("OnTooltipSetUnit", self.OnTooltipSetUnit)
	_G.GameTooltipStatusBar:SetScript("OnValueChanged", self.StatusBar_OnValueChanged)
	hooksecurefunc("GameTooltip_ShowStatusBar", self.GameTooltip_ShowStatusBar)
	hooksecurefunc("GameTooltip_ShowProgressBar", self.GameTooltip_ShowProgressBar)
	hooksecurefunc("GameTooltip_SetDefaultAnchor", self.GameTooltip_SetDefaultAnchor)
	hooksecurefunc("GameTooltip_SetBackdropStyle", self.GameTooltip_SetBackdropStyle)

	-- Elements
	self:CreateTargetedInfo()
	self:CreateTooltipID()
	self:CreateTooltipIcons()
end

-- Tooltip Skin Registration
local tipTable = {}
function Module:RegisterTooltips(addon, func)
	tipTable[addon] = func
end

local function addonStyled(_, addon)
	if tipTable[addon] then
		tipTable[addon]()
		tipTable[addon] = nil
	end
end
K:RegisterEvent("ADDON_LOADED", addonStyled)

Module:RegisterTooltips("KkthnxUI", function()
	local tooltips = {
		_G.AutoCompleteBox,
		_G.BattlePetTooltip,
		_G.ChatMenu,
		_G.EmbeddedItemTooltip,
		_G.EmoteMenu,
		_G.FloatingBattlePetTooltip,
		_G.FloatingGarrisonFollowerAbilityTooltip,
		_G.FloatingGarrisonFollowerTooltip,
		_G.FloatingGarrisonMissionTooltip,
		_G.FloatingGarrisonShipyardFollowerTooltip,
		_G.FloatingPetBattleAbilityTooltip,
		_G.FriendsTooltip,
		_G.GameTooltip,
		_G.GarrisonFollowerAbilityTooltip,
		_G.GarrisonFollowerTooltip,
		_G.GarrisonShipyardFollowerTooltip,
		_G.GeneralDockManagerOverflowButtonList,
		_G.IMECandidatesFrame,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ItemRefTooltip,
		_G.LanguageMenu,
		_G.NamePlateTooltip,
		_G.QueueStatusFrame,
		_G.ReputationParagonTooltip,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
		_G.VoiceMacroMenu,
		_G.WorldMapCompareTooltip1,
		_G.WorldMapCompareTooltip2,
		_G.WorldMapCompareTooltip3,
		_G.WorldMapTooltip,
	}
	for _, f in pairs(tooltips) do
		f:HookScript("OnShow", Module.ReskinTooltip)
	end

	_G.ItemRefCloseButton:SkinCloseButton()

	-- DropdownMenu
	local function reskinDropdown()
		for _, name in pairs({"DropDownList", "L_DropDownList", "Lib_DropDownList"}) do
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G[name..i.."MenuBackdrop"]
				if menu and not menu.styled then
					menu:HookScript("OnShow", Module.ReskinTooltip)
					menu.styled = true
				end

				local menu2 = _G[name..i.."Backdrop"]
				if menu2 and not menu2.styled then
					menu2:HookScript("OnShow", Module.ReskinTooltip)
					menu2.styled = true
				end
			end
		end
	end
	hooksecurefunc("UIDropDownMenu_CreateFrames", reskinDropdown)

	-- IME
	local r, g, b = K.r, K.g, K.b
	IMECandidatesFrame.selection:SetVertexColor(r, g, b)

	-- Others
	K.Delay(5, function()
		-- Lib minimap icon
		if LibDBIconTooltip then
			Module.ReskinTooltip(LibDBIconTooltip)
		end
		-- TomTom
		if TomTomTooltip then
			Module.ReskinTooltip(TomTomTooltip)
		end
		-- RareScanner
		if RSMapItemToolTip then
			Module.ReskinTooltip(RSMapItemToolTip)
		end

		if LootBarToolTip then
			Module.ReskinTooltip(LootBarToolTip)
		end
	end)

	if IsAddOnLoaded("BattlePetBreedID") then
		hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
			if parent == FloatingBattlePetTooltip then
				Module.ReskinTooltip(BPBID_BreedTooltip2)
			else
				Module.ReskinTooltip(BPBID_BreedTooltip)
			end
		end)
	end

	if IsAddOnLoaded("MethodDungeonTools") then
		local styledMDT
		hooksecurefunc(MethodDungeonTools, "ShowInterface", function()
			if not styledMDT then
				Module.ReskinTooltip(MethodDungeonTools.tooltip)
				Module.ReskinTooltip(MethodDungeonTools.pullTooltip)
				styledMDT = true
			end
		end)
	end
end)

Module:RegisterTooltips("Blizzard_DebugTools", function()
	Module.ReskinTooltip(FrameStackTooltip)
	Module.ReskinTooltip(EventTraceTooltip)
	FrameStackTooltip:SetScale(UIParent:GetScale())
	EventTraceTooltip:SetParent(UIParent)
	EventTraceTooltip:SetFrameStrata("TOOLTIP")
end)

Module:RegisterTooltips("Blizzard_Collections", function()
	PetJournalPrimaryAbilityTooltip:HookScript("OnShow", Module.ReskinTooltip)
	PetJournalSecondaryAbilityTooltip:HookScript("OnShow", Module.ReskinTooltip)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
end)

Module:RegisterTooltips("Blizzard_GarrisonUI", function()
	local gt = {
		GarrisonMissionMechanicTooltip,
		GarrisonMissionMechanicFollowerCounterTooltip,
		GarrisonShipyardMapMissionTooltip,
		GarrisonBonusAreaTooltip,
		GarrisonBuildingFrame.BuildingLevelTooltip,
		GarrisonFollowerAbilityWithoutCountersTooltip,
		GarrisonFollowerMissionAbilityWithoutCountersTooltip
	}
	for _, f in pairs(gt) do
		f:HookScript("OnShow", Module.ReskinTooltip)
	end
end)

Module:RegisterTooltips("Blizzard_PVPUI", function()
	ConquestTooltip:HookScript("OnShow", Module.ReskinTooltip)
end)

Module:RegisterTooltips("Blizzard_Contribution", function()
	ContributionBuffTooltip:HookScript("OnShow", Module.ReskinTooltip)
	ContributionBuffTooltip.Icon:SetTexCoord(unpack(K.TexCoords))
	ContributionBuffTooltip.Border:SetAlpha(0)
end)

Module:RegisterTooltips("Blizzard_EncounterJournal", function()
	EncounterJournalTooltip:HookScript("OnShow", Module.ReskinTooltip)
	EncounterJournalTooltip.Item1.icon:SetTexCoord(unpack(K.TexCoords))
	EncounterJournalTooltip.Item1.IconBorder:SetAlpha(0)
	EncounterJournalTooltip.Item2.icon:SetTexCoord(unpack(K.TexCoords))
	EncounterJournalTooltip.Item2.IconBorder:SetAlpha(0)
end)

Module:RegisterTooltips("Blizzard_Calendar", function()
	CalendarContextMenu:HookScript("OnShow", Module.ReskinTooltip)
	CalendarInviteStatusContextMenu:HookScript("OnShow", Module.ReskinTooltip)
end)