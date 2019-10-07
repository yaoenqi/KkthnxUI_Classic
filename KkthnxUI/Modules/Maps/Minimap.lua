local K, C = unpack(select(2, ...))
local Module = K:NewModule("Minimap", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

local _G = _G
local string_sub = string.sub

local C_Timer_After = _G.C_Timer.After
local CreateFrame = _G.CreateFrame
local hooksecurefunc = _G.hooksecurefunc
local InCombatLockdown = _G.InCombatLockdown
local Minimap = _G.Minimap
local MiniMapMailFrame = _G.MiniMapMailFrame
local UIParent = _G.UIParent

function Module:OnMouseWheelScroll(d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end

local isResetting
local function ResetZoom()
	Minimap:SetZoom(0)
	MinimapZoomIn:Enable() -- Reset enabled state of buttons
	MinimapZoomOut:Disable()
	isResetting = false
end

local function SetupZoomReset()
	if C["Minimap"].ResetZoom and not isResetting then
		isResetting = true
		C_Timer_After(C["Minimap"].ResetZoomTime, ResetZoom)
	end
end
hooksecurefunc(Minimap, "SetZoom", SetupZoomReset)

function Module:UpdateSettings()
	if InCombatLockdown() then
		return self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnEvent")
	end

	K.MinimapSize = C["Minimap"].Enable and C["Minimap"].Size or Minimap:GetWidth() + 10
	K.MinimapWidth, K.MinimapHeight = K.MinimapSize, K.MinimapSize

	if C["Minimap"].Enable then
		Minimap:SetSize(K.MinimapSize, K.MinimapSize)
	end

	local MinimapFrameHolder = _G.MinimapFrameHolder
	if MinimapFrameHolder then
		MinimapFrameHolder:SetWidth(Minimap:GetWidth())
	end

	-- Stop here if KkthnxUI Minimap is disabled.
	if not C["Minimap"].Enable then
		return
	end

	if MiniMapMailFrame then
		MiniMapMailFrame:ClearAllPoints()
		MiniMapMailFrame:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, 4)
		MiniMapMailFrame:SetScale(1.2)
	end

	if MiniMapTrackingFrame then
		MiniMapTrackingFrame:ClearAllPoints()
		MiniMapTrackingFrame:SetPoint("BOTTOMLEFT", Minimap, -4, -6)

		if (MiniMapTrackingBorder) then
			MiniMapTrackingBorder:Hide()
		end

		if (MiniMapTrackingIcon) then
			MiniMapTrackingIcon:SetDrawLayer("ARTWORK")
			MiniMapTrackingIcon:SetTexCoord(unpack(K.TexCoords))
			MiniMapTrackingIcon:SetSize(18, 18)
		end

		MiniMapTrackingFrame:CreateBackdrop()
		MiniMapTrackingFrame.Backdrop:SetFrameLevel(MiniMapTrackingFrame:GetFrameLevel())
		MiniMapTrackingFrame.Backdrop:SetAllPoints(MiniMapTrackingIcon)
		MiniMapTrackingFrame.Backdrop:CreateBorder()
		MiniMapTrackingFrame.Backdrop:CreateInnerShadow()
		MiniMapTrackingFrame.Backdrop:SetBackdropBorderColor(K.r, K.g, K.b)
	end

	if StreamingIcon then
		StreamingIcon:ClearAllPoints()
		StreamingIcon:SetPoint("TOP", UIParent, "TOP", 0, -6)
	end
end

function Module.ADDON_LOADED(_, addon)
	if addon == "Blizzard_TimeManager" then
		TimeManagerClockButton:Kill()
	elseif addon == "Blizzard_FeedbackUI" then
		FeedbackUIButton:Kill()
	end
end

function Module.OnEvent(event)
	if event == "PLAYER_REGEN_ENABLED" then
		Module:UpdateSettings()
	end
end

function Module:WhoPingedMyMap()
	local MinimapPing = CreateFrame("Frame", nil, Minimap)
	MinimapPing:SetAllPoints()

	MinimapPing.Text = MinimapPing:CreateFontString(nil, "OVERLAY")
	MinimapPing.Text:FontTemplate(nil, 14)
	MinimapPing.Text:SetPoint("TOP", MinimapPing, "TOP", 0, -20)

	local AnimationPing = MinimapPing:CreateAnimationGroup()
	AnimationPing:SetScript("OnPlay", function()
		MinimapPing:SetAlpha(1)
	end)

	AnimationPing:SetScript("OnFinished", function()
		MinimapPing:SetAlpha(0)
	end)

	AnimationPing.Fader = AnimationPing:CreateAnimation("Alpha")
	AnimationPing.Fader:SetFromAlpha(1)
	AnimationPing.Fader:SetToAlpha(0)
	AnimationPing.Fader:SetDuration(3)
	AnimationPing.Fader:SetSmoothing("OUT")
	AnimationPing.Fader:SetStartDelay(3)

	function Module.MINIMAP_PING(_, unit)
		local class = select(2, UnitClass(unit))
		if not class then
			return
		end

		local r, g, b = K.ColorClass(class)
		local name = GetUnitName(unit)
		if not name then
			return
		end

		AnimationPing:Stop()
		MinimapPing.Text:SetText(name)
		MinimapPing.Text:SetTextColor(r, g, b)
		AnimationPing:Play()
	end

	K:RegisterEvent("MINIMAP_PING", self.MINIMAP_PING)
end

local function GetMinimapShape()
	return "SQUARE"
end

function Module:SetGetMinimapShape()
	-- This is just to support for other mods
	GetMinimapShape = GetMinimapShape
	Minimap:SetSize(C["Minimap"].Size, C["Minimap"].Size)
end


function Module:OnEnable()
	self:UpdateSettings()

	if not C["Minimap"].Enable then
		Minimap:SetMaskTexture([[Interface\CharacterFrame\TempPortraitAlphaMask]])
		Minimap:SetBlipTexture("Interface\\MiniMap\\ObjectIconsAtlas")
		return
	end

	self:SetGetMinimapShape()

	local MinimapFrameHolder = CreateFrame("Frame", "MinimapFrameHolder", Minimap)
	MinimapFrameHolder:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -4, -4)
	MinimapFrameHolder:SetWidth(Minimap:GetWidth())
	MinimapFrameHolder:SetHeight(Minimap:GetHeight())

	Minimap:ClearAllPoints()
	Minimap:SetPoint("CENTER", MinimapFrameHolder, "CENTER", 0, 0)
	Minimap:SetMaskTexture(C["Media"].Blank)
	Minimap:CreateBorder()
	Minimap:CreateInnerShadow(nil, 0.4)
	Minimap:SetScale(1.0)
	Minimap:SetBlipTexture(C["Minimap"].BlipTexture.Value)

	_G.GameTimeFrame:Hide()
	_G.MiniMapMailBorder:Hide()
	_G.MiniMapMailIcon:SetTexture("Interface\\Addons\\KkthnxUI\\Media\\Textures\\Mail")
	_G.MinimapBorder:Hide()
	_G.MinimapNorthTag:Kill()
	_G.MinimapBorderTop:Hide()
	_G.MinimapToggleButton:Hide()
	_G.MinimapZoneTextButton:Hide()
	_G.MinimapZoomIn:Hide()
	_G.MinimapZoomOut:Hide()

	_G.MiniMapWorldMapButton:Hide()

	if _G.TimeManagerClockButton then
		_G.TimeManagerClockButton:Kill()
	end

	if _G.FeedbackUIButton then
		_G.FeedbackUIButton:Kill()
	end

	_G.MinimapCluster:EnableMouse(false)

	K.Mover(MinimapFrameHolder, "Minimap", "Minimap", {"TOPRIGHT", UIParent, "TOPRIGHT", -4, -4}, Minimap:GetWidth(), Minimap:GetHeight())

	Minimap:EnableMouseWheel(true)
	Minimap:SetScript("OnMouseWheel", Module.OnMouseWheelScroll)

	K:RegisterEvent("PLAYER_ENTERING_WORLD", self.OnEvent)
	K:RegisterEvent("ADDON_LOADED", self.ADDON_LOADED)

	self:UpdateSettings()

	self:WhoPingedMyMap()
	self:CreateRecycleBin()
end