local K, C = unpack(select(2, ...))
local Module = K:GetModule("ActionBar")

local _G = _G
local assert = assert

local CharacterMicroButton = _G.CharacterMicroButton
local CreateFrame = _G.CreateFrame
local InCombatLockdown = _G.InCombatLockdown
local MICRO_BUTTONS = _G.MICRO_BUTTONS
local MainMenuBarPerformanceBar = _G.MainMenuBarPerformanceBar
local MainMenuMicroButton = _G.MainMenuMicroButton
local MicroButtonPortrait = _G.MicroButtonPortrait
local RegisterStateDriver = _G.RegisterStateDriver
local UIParent = _G.UIParent
local UpdateMicroButtonsParent = _G.UpdateMicroButtonsParent
local hooksecurefunc = _G.hooksecurefunc

local function onLeave()
	if C["ActionBar"].MicroBarMouseover then
		K.UIFrameFadeOut(KkthnxUI_MicroBar, 0.2, KkthnxUI_MicroBar:GetAlpha(), 0.25)
	end
end

local watcher = 0
local function onUpdate(self, elapsed)
	if watcher > 0.1 then
		if not self:IsMouseOver() then
			self.IsMouseOvered = nil
			self:SetScript("OnUpdate", nil)
			onLeave()
		end

		watcher = 0
	else
		watcher = watcher + elapsed
	end
end

local function onEnter()
	if C["ActionBar"].MicroBarMouseover and not KkthnxUI_MicroBar.IsMouseOvered then
		KkthnxUI_MicroBar.IsMouseOvered = true
		KkthnxUI_MicroBar:SetScript("OnUpdate", onUpdate)
		K.UIFrameFadeIn(KkthnxUI_MicroBar, 0.2, KkthnxUI_MicroBar:GetAlpha(), 1)
	end
end

function Module.PLAYER_REGEN_ENABLED()
	if Module.NeedsUpdateMicroBarVisibility then
		Module:UpdateMicroBarVisibility()
		Module.NeedsUpdateMicroBarVisibility = nil
	end

	K:UnregisterEvent("PLAYER_REGEN_ENABLED", Module.PLAYER_REGEN_ENABLED)
end

function Module.HandleMicroButton(button)
	assert(button, "Invalid micro button name.")

	local pushed = button:GetPushedTexture()
	local normal = button:GetNormalTexture()
	local disabled = button:GetDisabledTexture()

	local f = CreateFrame("Frame", nil, button)
	K.CreateBorder(f)
	f:CreateInnerShadow()
	f:SetAllPoints(button)
	button.backdrop = f

	button:SetParent(KkthnxUI_MicroBar)
	button:GetHighlightTexture():Kill()
	button:HookScript("OnEnter", onEnter)
	button:SetHitRectInsets(0, 0, 0, 0)

	if button.Flash then
		button.Flash:SetInside()
		button.Flash:SetTexture(nil)
	end

	pushed:SetTexCoord(0.17, 0.87, 0.5, 0.908)
	pushed:SetInside(f)

	normal:SetTexCoord(0.17, 0.87, 0.5, 0.908)
	normal:SetInside(f)

	if disabled then
		disabled:SetTexCoord(0.17, 0.87, 0.5, 0.908)
		disabled:SetInside(f)
	end
end

function Module.MainMenuMicroButton_SetNormal()
	MainMenuBarPerformanceBar:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 9, -36)
end

function Module.MainMenuMicroButton_SetPushed()
	MainMenuBarPerformanceBar:SetPoint("TOPLEFT", MainMenuMicroButton, "TOPLEFT", 8, -37)
end

function Module.UpdateMicroButtonsParent()
	for _, x in pairs(MICRO_BUTTONS) do
		_G[x]:SetParent(KkthnxUI_MicroBar)
	end
end

-- we use this table to sort the micro buttons on our bar to match Blizzard's button placements.
local __buttonIndex = {
	'CharacterMicroButton',
	'SpellbookMicroButton',
	'TalentMicroButton',
	'QuestLogMicroButton',
	'SocialsMicroButton',
	'WorldMapMicroButton',
	'MainMenuMicroButton',
	'HelpMicroButton'
}

function Module.UpdateMicroBarVisibility()
	if InCombatLockdown() then
		Module.NeedsUpdateMicroBarVisibility = true
		K:RegisterEvent("PLAYER_REGEN_ENABLED", Module.PLAYER_REGEN_ENABLED)
		return
	end

	local visibility = "show"
	if visibility and visibility:match("[\n\r]") then
		visibility = visibility:gsub("[\n\r]","")
	end

	RegisterStateDriver(KkthnxUI_MicroBar.visibility, "visibility", (C["ActionBar"].MicroBar and visibility) or "hide")
end

function Module.UpdateMicroPositionDimensions()
	if not KkthnxUI_MicroBar then
		return
	end

	local numRows = 1
	local prevButton = KkthnxUI_MicroBar
	local offset = 4
	local spacing = offset + 2

	for i = 1, #MICRO_BUTTONS do
		local button = _G[__buttonIndex[i]] or _G[MICRO_BUTTONS[i]]
		if button:IsShown() then

			button:SetSize(20, 20 * 1.4)
			button:ClearAllPoints()

			if prevButton == KkthnxUI_MicroBar then
				button:SetPoint('TOPLEFT', prevButton, 'TOPLEFT', offset, -offset)
			else
				button:SetPoint('LEFT', prevButton, 'RIGHT', spacing, 0)
			end

			prevButton = button
		end
	end

	if C["ActionBar"].MicroBarMouseover and not KkthnxUI_MicroBar:IsMouseOver() then
		KkthnxUI_MicroBar:SetAlpha(0.25)
	else
		KkthnxUI_MicroBar:SetAlpha(1)
	end

	Module.MicroWidth = (((_G['CharacterMicroButton']:GetWidth() + spacing) * 8) - spacing) + (offset * 2)
	Module.MicroHeight = (((_G['CharacterMicroButton']:GetHeight() + spacing) * numRows) - spacing) + (offset * 2)

	KkthnxUI_MicroBar:SetSize(Module.MicroWidth, Module.MicroHeight)

	Module.UpdateMicroBarVisibility()
end

function Module:CreateMicroMenu()
	if not C["ActionBar"].Enable then
		return
	end

	if C["ActionBar"].MicroBar ~= true then
		return
	end

	local microBar = CreateFrame("Frame", "KkthnxUI_MicroBar", UIParent)
	microBar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
	microBar:EnableMouse(false)

	microBar.visibility = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate")
	microBar.visibility:SetScript("OnShow", function()
		microBar:Show()
	end)

	microBar.visibility:SetScript("OnHide", function()
		microBar:Hide()
	end)

	for i = 1, #MICRO_BUTTONS do
		Module.HandleMicroButton(_G[MICRO_BUTTONS[i]])
	end

	MicroButtonPortrait:SetAllPoints(CharacterMicroButton.backdrop)

	hooksecurefunc("MainMenuMicroButton_SetPushed", Module.MainMenuMicroButton_SetPushed)
	hooksecurefunc("MainMenuMicroButton_SetNormal", Module.MainMenuMicroButton_SetNormal)
	hooksecurefunc("UpdateMicroButtonsParent", Module.UpdateMicroButtonsParent)
	hooksecurefunc("MoveMicroButtons", Module.UpdateMicroPositionDimensions)

	UpdateMicroButtonsParent(microBar)

	Module.MainMenuMicroButton_SetNormal()
	Module.UpdateMicroPositionDimensions()

	if MainMenuBarPerformanceBar then
		MainMenuBarPerformanceBar:SetTexture(nil)
		MainMenuBarPerformanceBar:SetVertexColor(0, 0, 0, 0)
		MainMenuBarPerformanceBar:Hide()
	end

	K.Mover(microBar, "MicroBar", "MicroBar", {"BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0})
end