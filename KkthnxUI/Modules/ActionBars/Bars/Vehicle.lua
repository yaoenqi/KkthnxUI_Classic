local K, C = unpack(select(2, ...))
local Module = K:GetModule("ActionBar")
local FilterConfig = K.ActionBars.leaveVehicle

local _G = _G
local table_insert = _G.table.insert

local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local UnitOnTaxi = _G.UnitOnTaxi

function Module:CreateLeaveVehicle()
	local padding, margin = 0, 5
	local num = 1
	local buttonList = {}

	-- Create The Frame To Hold The Buttons
	local frame = CreateFrame("Frame", "KkthnxUI_LeaveVehicleBar", UIParent)
	frame:SetWidth(num * FilterConfig.size + (num - 1) * margin + 2 * padding)
	frame:SetHeight(FilterConfig.size + 2 * padding)
	frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 260, 4}

	-- The Button
	local button = CreateFrame("Button", "KkthnxUI_LeaveVehicleButton", frame)
	table_insert(buttonList, button) -- Add The Button Object To The List
	button:SetSize(FilterConfig.size, FilterConfig.size)
	button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	button:StyleButton()
	button:RegisterForClicks("AnyUp")
	button.Icon = button:CreateTexture(nil, "ARTWORK")
	button.Icon:SetAllPoints()
	button.Icon:SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
	button.Icon:SetTexCoord(.216, .784, .216, .784)
	button:SetNormalTexture(nil)
	button:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
	K.CreateBorder(button)
	button:CreateInnerShadow()

	local function updateVisibility()
		if UnitOnTaxi("player") then
			button:Show()
		else
			button:Hide()
			button:UnlockHighlight()
		end
	end
	hooksecurefunc("MainMenuBarVehicleLeaveButton_Update", updateVisibility)

	local function onClick(self)
		if not UnitOnTaxi("player") then self:Hide() return end
		TaxiRequestEarlyLanding()
		self:LockHighlight()
	end
	button:SetScript("OnClick", onClick)
	button:SetScript("OnEnter", MainMenuBarVehicleLeaveButton_OnEnter)
	button:SetScript("OnLeave", K.HideTooltip)

	-- Create Drag Frame And Drag Functionality
	if K.ActionBars.userPlaced then
		K.Mover(frame, "LeaveVehicle", "LeaveVehicle", frame.Pos)
	end

	-- create the mouseover functionality
	if FilterConfig.fader then
		K.CreateButtonFrameFader(frame, buttonList, FilterConfig.fader)
	end
end