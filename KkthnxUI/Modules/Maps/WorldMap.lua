local K, C = unpack(select(2, ...))
local Module = K:NewModule("WorldMap", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")

local _G = _G

local CreateFrame = _G.CreateFrame
local PLAYER = _G.PLAYER
local SetCVar = _G.SetCVar
local SetUIPanelAttribute = _G.SetUIPanelAttribute
local UIParent = _G.UIParent
local WorldMapFrame = _G.WorldMapFrame
local hooksecurefunc = _G.hooksecurefunc
local InCombatLockdown = _G.InCombatLockdown
local C_Map_GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local CreateVector2D = _G.CreateVector2D
local UnitPosition = _G.UnitPosition
local C_Map_GetWorldPosFromMapPos = _G.C_Map.GetWorldPosFromMapPos

local mapRects = {}
local tempVec2D = CreateVector2D(0, 0)
local currentMapID, playerCoords, cursorCoords
local smallerMapScale = 0.8

function Module:SetLargeWorldMap()
	local WorldMapFrame = _G.WorldMapFrame
	WorldMapFrame:SetParent(UIParent)
	WorldMapFrame:SetScale(1)
	WorldMapFrame:OnFrameSizeChanged()
	WorldMapFrame.ScrollContainer.Child:SetScale(smallerMapScale)
end

function Module:SetSmallWorldMap()
	local WorldMapFrame = _G.WorldMapFrame
	WorldMapFrame:SetParent(UIParent)
	WorldMapFrame:SetScale(smallerMapScale)
	WorldMapFrame:EnableKeyboard(false)
	WorldMapFrame:EnableMouse(false)
	WorldMapFrame:SetFrameStrata('HIGH')

	_G.WorldMapTooltip:SetFrameLevel(WorldMapFrame.ScrollContainer:GetFrameLevel() + 110)
end

function Module:GetPlayerMapPos(mapID)
	tempVec2D.x, tempVec2D.y = UnitPosition("player")
	if not tempVec2D.x then
		return
	end

	local mapRect = mapRects[mapID]
	if not mapRect then
		mapRect = {}
		mapRect[1] = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(0, 0)))
		mapRect[2] = select(2, C_Map_GetWorldPosFromMapPos(mapID, CreateVector2D(1, 1)))
		mapRect[2]:Subtract(mapRect[1])

		mapRects[mapID] = mapRect
	end
	tempVec2D:Subtract(mapRect[1])

	return tempVec2D.y / mapRect[2].y, tempVec2D.x / mapRect[2].x
end

function Module:GetCursorCoords()
	if not WorldMapFrame.ScrollContainer:IsMouseOver() then
		return
	end

	local cursorX, cursorY = WorldMapFrame.ScrollContainer:GetNormalizedCursorPosition()
	if cursorX < 0 or cursorX > 1 or cursorY < 0 or cursorY > 1 then
		return
	end

	return cursorX, cursorY
end

local function CoordsFormat(owner, none)
	local text = none and ": --, --" or ": %.1f, %.1f"
	return owner..K.MyClassColor..text
end

function Module:UpdateCoords(elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.5 then
		local cursorX, cursorY = Module:GetCursorCoords()
		if cursorX and cursorY then
			cursorCoords:SetFormattedText(CoordsFormat("Mouse"), 100 * cursorX, 100 * cursorY)
		else
			cursorCoords:SetText(CoordsFormat("Mouse", true))
		end

		if not currentMapID then
			playerCoords:SetText(CoordsFormat(PLAYER, true))
		else
			local x, y = Module:GetPlayerMapPos(currentMapID)
			if not x or (x == 0 and y == 0) then
				playerCoords:SetText(CoordsFormat(PLAYER, true))
			else
				playerCoords:SetFormattedText(CoordsFormat(PLAYER), 100 * x, 100 * y)
			end
		end

		self.elapsed = 0
	end
end

function Module:UpdateMapID()
	if self:GetMapID() == C_Map_GetBestMapForUnit("player") then
		currentMapID = self:GetMapID()
	else
		currentMapID = nil
	end
end

function Module:AllowMapFade()
	return GetCVarBool('mapFade') and not _G.WorldMapFrame:IsMouseOver()
end

function Module:SetMovementAlpha()
	local WorldMapFrame = _G.WorldMapFrame
	_G.PlayerMovementFrameFader.RemoveFrame(WorldMapFrame)
	_G.PlayerMovementFrameFader.AddDeferredFrame(WorldMapFrame, C["WorldMap"].AlphaWhenMoving, 1, .5, Module.AllowMapFade)
end

function Module:ToggleMapFix(event)
	local WorldMapFrame = _G.WorldMapFrame
	ShowUIPanel(WorldMapFrame)
	WorldMapFrame:SetAttribute('UIPanelLayout-area', 'center')
	WorldMapFrame:SetAttribute('UIPanelLayout-allowOtherPanels', true)
	HideUIPanel(WorldMapFrame)

	if event then
		K:UnregisterEvent(event)
	end
end

function Module:OnEnable()
	if C["WorldMap"].Coordinates then
		playerCoords = WorldMapFrame.BorderFrame:CreateFontString(nil, "OVERLAY")
		playerCoords:FontTemplate(nil, 13, "OUTLINE")
		playerCoords:SetPoint("BOTTOMLEFT", 12, 9)
		playerCoords:SetTextColor(1, 1 ,0)

		cursorCoords = WorldMapFrame.BorderFrame:CreateFontString(nil, "OVERLAY")
		cursorCoords:FontTemplate(nil, 13, "OUTLINE")
		cursorCoords:SetPoint("LEFT", playerCoords, "RIGHT", 8, 0)
		cursorCoords:SetTextColor(1, 1 ,0)

		hooksecurefunc(WorldMapFrame, "OnFrameSizeChanged", self.UpdateMapID)
		hooksecurefunc(WorldMapFrame, "OnMapChanged", self.UpdateMapID)

		local CoordsUpdater = CreateFrame("Frame", nil, WorldMapFrame.BorderFrame)
		CoordsUpdater:SetScript("OnUpdate", self.UpdateCoords)
	end

	if C["WorldMap"].SmallWorldMap then
		smallerMapScale = 0.9

		WorldMapFrame.BlackoutFrame.Blackout:SetTexture()
		WorldMapFrame.BlackoutFrame:EnableMouse(false)

		if InCombatLockdown() then
			K:RegisterEvent("PLAYER_REGEN_ENABLED", self.ToggleMapFix)
		else
			Module:ToggleMapFix()
		end

		if (not WorldMapFrame.isHooked) then
			WorldMapFrame:HookScript("OnShow", function()
				Module:SetSmallWorldMap(smallerMapScale)
			end)

			WorldMapFrame.isHooked = true
		end
	else
		Module:SetLargeWorldMap()
	end

	_G.WorldMapMagnifyingGlassButton:SetPoint('TOPLEFT', 60, -120)

	-- Fix scroll zooming in classic
	WorldMapFrame.ScrollContainer:HookScript("OnMouseWheel", function(self, delta)
		local x, y = self:GetNormalizedCursorPosition()
		local nextZoomOutScale, nextZoomInScale = self:GetCurrentZoomRange()
		if delta == 1 then
			if nextZoomInScale > self:GetCanvasScale() then
				self:InstantPanAndZoom(nextZoomInScale, x, y)
			end
		else
			if nextZoomOutScale < self:GetCanvasScale() then
				self:InstantPanAndZoom(nextZoomOutScale, x, y)
			end
		end
	end)

	--Set alpha used when moving
	WORLD_MAP_MIN_ALPHA = C["WorldMap"].AlphaWhenMoving
	SetCVar('mapAnimMinAlpha', C["WorldMap"].AlphaWhenMoving)

	--Enable/Disable map fading when moving
	SetCVar('mapFade', (C["WorldMap"].FadeWhenMoving == true and 1 or 0))

	self:SetMovementAlpha()

	self:CreateWorldMapPlus()
end