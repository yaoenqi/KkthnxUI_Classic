local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Blizzard")

local _G = _G
local string_find = _G.string.find

local UIParent = _G.UIParent
local CreateFrame = _G.CreateFrame
local CUSTOM_CLASS_COLORS = _G.CUSTOM_CLASS_COLORS
local DoReadyCheck = _G.DoReadyCheck
local InCombatLockdown = _G.InCombatLockdown
local IsInGroup = _G.IsInGroup
local IsInRaid = _G.IsInRaid
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
local ToggleFriendsFrame = _G.ToggleFriendsFrame
local UnitIsGroupAssistant = _G.UnitIsGroupAssistant
local UnitIsGroupLeader = _G.UnitIsGroupLeader
local GetInstanceInfo = _G.GetInstanceInfo

K["RaidUtility"] = Module

local PANEL_HEIGHT = 100
local CLASS_COLOR =
K.Class == "PRIEST" and K.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[K.Class] or RAID_CLASS_COLORS[K.Class])

-- Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local _, instanceType = GetInstanceInfo()
	if ((IsInGroup() and not IsInRaid()) or UnitIsGroupLeader('player') or UnitIsGroupAssistant("player")) and not (instanceType == "pvp") then
		return true
	else
		return false
	end
end

local function ButtonEnter(self)
	if not C["General"].ColorTextures then -- Fix a rare nil error
		self:SetBackdropBorderColor(CLASS_COLOR.r, CLASS_COLOR.g, CLASS_COLOR.b, 1)
	end

	self.Backgrounds:SetColorTexture(CLASS_COLOR.r * .15, CLASS_COLOR.g * .15, CLASS_COLOR.b * .15, C["Media"].BackdropColor[4])
end

local function ButtonLeave(self)
	if not C["General"].ColorTextures then -- Fix a rare nil error
		self:SetBackdropBorderColor()
	end

	self.Backgrounds:SetColorTexture(C["Media"].BackdropColor[1], C["Media"].BackdropColor[2], C["Media"].BackdropColor[3], C["Media"].BackdropColor[4])
end

-- Function to create buttons in this module
function Module:CreateUtilButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text, texture)
	local b = CreateFrame("Button", name, parent, template)
	b:SetWidth(width)
	b:SetHeight(height)
	b:SetPoint(point, relativeto, point2, xOfs, yOfs)
	b:HookScript("OnEnter", ButtonEnter)
	b:HookScript("OnLeave", ButtonLeave)

	if text then
		local t = b:CreateFontString(nil, "OVERLAY", b)
		t:FontTemplate()
		t:SetPoint("CENTER", b, "CENTER", 0, -1)
		t:SetJustifyH("CENTER")
		t:SetText(text)
		b:SetFontString(t)
	elseif texture then
		local t = b:CreateTexture(nil, "OVERLAY", nil)
		t:SetTexture(texture)
		t:SetPoint("TOPLEFT", b, "TOPLEFT", K.Mult, -K.Mult)
		t:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -K.Mult, K.Mult)
	end
end

function Module.ToggleRaidUtil(event)
	if InCombatLockdown() then
		K:RegisterEvent("PLAYER_REGEN_ENABLED", Module.ToggleRaidUtil)
		return
	end

	if CheckRaidStatus() then
		if RaidUtilityPanel.toggled == true then
			RaidUtility_ShowButton:Hide()
			RaidUtilityPanel:Show()
		else
			RaidUtility_ShowButton:Show()
			RaidUtilityPanel:Hide()
		end
	else
		RaidUtility_ShowButton:Hide()
		RaidUtilityPanel:Hide()
	end

	if event == "PLAYER_REGEN_ENABLED" then
		K:UnregisterEvent("PLAYER_REGEN_ENABLED", Module.ToggleRaidUtil)
	end
end

function Module:CreateRaidUtility()
	if C["Raid"].RaidUtility == false then
		return
	end

	-- Create main frame
	local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", UIParent, "SecureHandlerBaseTemplate")
	RaidUtilityPanel:SetWidth(230)
	RaidUtilityPanel:SetHeight(PANEL_HEIGHT)
	RaidUtilityPanel:SetPoint("TOP", UIParent, "TOP", -400, 1)
	RaidUtilityPanel:SetFrameLevel(3)
	RaidUtilityPanel.toggled = false
	RaidUtilityPanel:SetFrameStrata("HIGH")
	RaidUtilityPanel:CreateBorder()

	-- Show Button
	self:CreateUtilButton("RaidUtility_ShowButton", UIParent, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", 136, 18, "TOP", UIParent, "TOP", -400, 4, RAID_CONTROL, nil )
	RaidUtility_ShowButton:SetFrameRef("RaidUtilityPanel", RaidUtilityPanel)
	RaidUtility_ShowButton:SetAttribute("_onclick", ([=[
	local raidUtil = self:GetFrameRef("RaidUtilityPanel")
	local closeButton = raidUtil:GetFrameRef("RaidUtility_CloseButton")

	self:Hide()
	raidUtil:Show()

	local point = self:GetPoint()
	local raidUtilPoint, closeButtonPoint, yOffset

	if string.find(point, "BOTTOM") then
		raidUtilPoint = "BOTTOM"
		closeButtonPoint = "TOP"
		yOffset = 1
	else
		raidUtilPoint = "TOP"
		closeButtonPoint = "BOTTOM"
		yOffset = -1
	end

	yOffset = yOffset * (tonumber(%d))

	raidUtil:ClearAllPoints()
	closeButton:ClearAllPoints()
	raidUtil:SetPoint(raidUtilPoint, self, raidUtilPoint)
	closeButton:SetPoint(raidUtilPoint, raidUtil, closeButtonPoint, 0, yOffset)
	]=]):format(-6 + 4 * 3))

	RaidUtility_ShowButton:SetScript("OnMouseUp", function()
		RaidUtilityPanel.toggled = true
	end)

	RaidUtility_ShowButton:SetMovable(true)
	RaidUtility_ShowButton:SetClampedToScreen(true)
	RaidUtility_ShowButton:SetClampRectInsets(0, 0, -1, 1)
	RaidUtility_ShowButton:RegisterForDrag("RightButton")
	RaidUtility_ShowButton:SetFrameStrata("HIGH")
	RaidUtility_ShowButton:SetScript("OnDragStart", function(sb)
		sb:StartMoving()
	end)

	RaidUtility_ShowButton:SetScript("OnDragStop", function(sb)
		sb:StopMovingOrSizing()
		local point = sb:GetPoint()
		local xOffset = sb:GetCenter()
		local screenWidth = UIParent:GetWidth() / 2
		xOffset = xOffset - screenWidth
		sb:ClearAllPoints()
		if string_find(point, "BOTTOM") then
			sb:SetPoint("BOTTOM", UIParent, "BOTTOM", xOffset, -1)
		else
			sb:SetPoint("TOP", UIParent, "TOP", xOffset, 1)
		end
	end)

	-- Close Button
	self:CreateUtilButton("RaidUtility_CloseButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", 136, 18, "TOP", RaidUtilityPanel, "BOTTOM", 0, -1, CLOSE, nil )
	RaidUtility_CloseButton:SetFrameRef("RaidUtility_ShowButton", RaidUtility_ShowButton)
	RaidUtility_CloseButton:SetAttribute("_onclick", [=[self:GetParent():Hide() self:GetFrameRef("RaidUtility_ShowButton"):Show()]=] )
	RaidUtility_CloseButton:SetScript("OnMouseUp", function()
		RaidUtilityPanel.toggled = false
	end)
	RaidUtilityPanel:SetFrameRef("RaidUtility_CloseButton", RaidUtility_CloseButton)

	-- Disband Raid button
	self:CreateUtilButton("DisbandRaidButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOP", RaidUtilityPanel, "TOP", 0, -5, L["Disband Group"], nil )
	DisbandRaidButton:SetScript("OnMouseUp", function()
		if CheckRaidStatus() then
			K.StaticPopup_Show("DISBAND_RAID")
		end
	end)

	-- MainTank Button
	self:CreateUtilButton("MainTankButton", RaidUtilityPanel, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DisbandRaidButton:GetWidth() / 2) - 2, 18, "TOPLEFT", DisbandRaidButton, "BOTTOMLEFT", 0, -5, MAINTANK, nil)
	MainTankButton:SetAttribute("type", "maintank")
	MainTankButton:SetAttribute("unit", "target")
	MainTankButton:SetAttribute("action", "toggle")

	-- MainAssist Button
	self:CreateUtilButton("MainAssistButton", RaidUtilityPanel, "SecureActionButtonTemplate, UIMenuButtonStretchTemplate", (DisbandRaidButton:GetWidth() / 2) - 2, 18, "TOPRIGHT", DisbandRaidButton, "BOTTOMRIGHT", 0, -5, MAINASSIST, nil)
	MainAssistButton:SetAttribute("type", "mainassist")
	MainAssistButton:SetAttribute("unit", "target")
	MainAssistButton:SetAttribute("action", "toggle")

	-- Ready Check button
	self:CreateUtilButton("ReadyCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOP", DisbandRaidButton, "BOTTOM", 0, -28, READY_CHECK, nil )
	ReadyCheckButton:SetScript("OnMouseUp", function()
		if CheckRaidStatus() then
			DoReadyCheck()
		end
	end)

	-- Raid Control Panel
	self:CreateUtilButton("RaidControlButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOP", ReadyCheckButton, "BOTTOM", 0, -6, L["Raid Menu"], nil )
	RaidControlButton:SetScript("OnMouseUp", function()
		ToggleFriendsFrame(3)
	end)

	local buttons = {
		"DisbandRaidButton",
		"ReadyCheckButton",
		"MainTankButton",
		"MainAssistButton",
		"RaidControlButton",
		"RaidUtility_ShowButton",
		"RaidUtility_CloseButton"
	}

	if CompactRaidFrameManager then
		-- Put other stuff back
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLockedModeToggle, "TOPLEFT", 0, 1)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 1)
	else
		K.StaticPopup_Show("WARNING_BLIZZARD_ADDONS")
	end

	-- Reskin Stuff
	for _, button in pairs(buttons) do
		local f = _G[button]
		f.BottomLeft:SetAlpha(0)
		f.BottomRight:SetAlpha(0)
		f.BottomMiddle:SetAlpha(0)
		f.TopMiddle:SetAlpha(0)
		f.TopLeft:SetAlpha(0)
		f.TopRight:SetAlpha(0)
		f.MiddleLeft:SetAlpha(0)
		f.MiddleRight:SetAlpha(0)
		f.MiddleMiddle:SetAlpha(0)

		f:SetHighlightTexture("")
		f:SetDisabledTexture("")
		f:HookScript("OnEnter", ButtonEnter)
		f:HookScript("OnLeave", ButtonLeave)

		f:CreateBorder()
	end

	-- Automatically show/hide the frame if we have RaidLeader or RaidOfficer
	K:RegisterEvent("GROUP_ROSTER_UPDATE", self.ToggleRaidUtil)
	K:RegisterEvent("PLAYER_ENTERING_WORLD", self.ToggleRaidUtil)
end