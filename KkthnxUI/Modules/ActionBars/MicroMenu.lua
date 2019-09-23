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

local function onLeaveBar()
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
			onLeaveBar()
		end

		watcher = 0
	else
		watcher = watcher + elapsed
	end
end

local function onEnter(button)
	if C["ActionBar"].MicroBarMouseover and not KkthnxUI_MicroBar.IsMouseOvered then
		KkthnxUI_MicroBar.IsMouseOvered = true
		KkthnxUI_MicroBar:SetScript("OnUpdate", onUpdate)
		K.UIFrameFadeIn(KkthnxUI_MicroBar, 0.2, KkthnxUI_MicroBar:GetAlpha(), 1)
	end

	if button.backdrop then
		button.backdrop:SetBackdropBorderColor(K.r, K.g, K.b)
	end
end

local function onLeave(button)
	if button.backdrop then
		button.backdrop:SetBackdropBorderColor()
	end
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
	button:HookScript("OnLeave", onLeave)
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

function Module.UpdateMicroBarVisibility()
	if InCombatLockdown() then
		Module.NeedsUpdateMicroBarVisibility = true
		K:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	local visibility = "show"
	if visibility and visibility:match("[\n\r]") then
		visibility = visibility:gsub("[\n\r]","")
	end

	RegisterStateDriver(KkthnxUI_MicroBar.visibility, "visibility", (C["ActionBar"].MicroBar and visibility) or "hide")
end

local VisibleMicroButtons = {}
function Module.UpdateMicroPositionDimensions()
	if not KkthnxUI_MicroBar then
		return
	end

	local numRows = 1
	local prevButton = KkthnxUI_MicroBar
	local offset = 4
	local spacing = offset + 2
	wipe(VisibleMicroButtons)

	for i = 1, #MICRO_BUTTONS do
		local button = _G[MICRO_BUTTONS[i]]
		if button:IsShown() then
			tinsert(VisibleMicroButtons, button:GetName())
		end
	end

	for i = 1, #VisibleMicroButtons do
		local button = _G[VisibleMicroButtons[i]]
		button:ClearAllPoints()
		button:SetSize(20, 20 * 1.4)

		if prevButton == KkthnxUI_MicroBar then
			button:SetPoint('TOPLEFT', prevButton, 'TOPLEFT', offset, -offset)
		else
			button:SetPoint('LEFT', prevButton, 'RIGHT', spacing, 0)
		end

		prevButton = button
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