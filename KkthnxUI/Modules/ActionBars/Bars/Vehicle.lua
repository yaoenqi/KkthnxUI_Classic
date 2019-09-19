local K, C, L = unpack(select(2, ...))
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
	local button = CreateFrame("Button", "KkthnxUI_LeaveVehicleButton", frame, "SecureActionButtonTemplate")
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
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext", "/leavevehicle [target=vehicle,exists,canexitvehicle]\n/dismount [mounted]")

	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:ClearLines()

		if UnitOnTaxi("player") then
			GameTooltip:AddLine(TAXI_CANCEL)
			GameTooltip:AddLine(TAXI_CANCEL_DESCRIPTION)
		elseif IsMounted() then
			GameTooltip:AddLine(BINDING_NAME_DISMOUNT)
			GameTooltip:AddLine(L["%s to dismount."]:format(L["Left Click"]))
		else
			GameTooltip:AddLine(LEAVE_VEHICLE)
			GameTooltip:AddLine(L["%s to leave the vehicle."]:format(L["Left Click"]))
		end

		GameTooltip:Show()
	end)

	button:SetScript("OnLeave", K.HideTooltip)

	-- Gotta do this the unsecure way, no macros exist for this yet.
	button:HookScript("OnClick", function(self, button)
		if (UnitOnTaxi("player") and (not InCombatLockdown())) then
			TaxiRequestEarlyLanding()
		end
	end)

	-- Frame Visibility
	RegisterAttributeDriver(frame, "state-visibility", "[target=vehicle,exists,canexitvehicle][mounted]show;hide")

	-- Create Drag Frame And Drag Functionality
	if K.ActionBars.userPlaced then
		K.Mover(frame, "LeaveVehicle", "LeaveVehicle", frame.Pos)
	end

	-- create the mouseover functionality
	if FilterConfig.fader then
		K.CreateButtonFrameFader(frame, buttonList, FilterConfig.fader)
	end
end