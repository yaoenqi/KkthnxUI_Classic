local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("WorldMap")

if not Module then
	return
end

-- Sourced: Leatrix_Maps by Leatrix

-- Function to refresh overlays (Blizzard_SharedMapDataProviders\MapExplorationDataProvider)
local _G = _G
local overlayTextures, TileExists = {}, {}
local strsplit, ceil, mod = _G.string.split, _G.math.ceil, _G.mod
local pairs, tonumber, tinsert = _G.pairs, _G.tonumber, _G.table.insert

local function MapExplorationPin_RefreshOverlays(pin, fullUpdate)
	wipe(overlayTextures)
	wipe(TileExists)

	local mapID = WorldMapFrame.mapID
	if not mapID then
		return
	end

	local artID = C_Map.GetMapArtID(mapID)
	if not artID or not K.WorldMapPlusData[artID] then
		return
	end

	local KkthnxUIMapsZone = K.WorldMapPlusData[artID]
	local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
	if exploredMapTextures then
		for _, exploredTextureInfo in ipairs(exploredMapTextures) do
			local key = exploredTextureInfo.textureWidth..":"..exploredTextureInfo.textureHeight..":"..exploredTextureInfo.offsetX..":"..exploredTextureInfo.offsetY
			TileExists[key] = true
		end
	end

	pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
	local layers = C_Map.GetMapArtLayers(mapID)
	local layerInfo = layers and layers[pin.layerIndex]

	if not layerInfo then
		return
	end

	local TILE_SIZE_WIDTH = layerInfo.tileWidth
	local TILE_SIZE_HEIGHT = layerInfo.tileHeight

	-- Show textures if they are in database and have not been explored
	for key, files in pairs(KkthnxUIMapsZone) do
		if not TileExists[key] then
			local width, height, offsetX, offsetY = strsplit(":", key)
			local fileDataIDs = {strsplit(",", files)}
			local numTexturesWide = ceil(width/TILE_SIZE_WIDTH)
			local numTexturesTall = ceil(height/TILE_SIZE_HEIGHT)
			local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
			for j = 1, numTexturesTall do
				if (j < numTexturesTall) then
					texturePixelHeight = TILE_SIZE_HEIGHT
					textureFileHeight = TILE_SIZE_HEIGHT
				else
					texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
					if (texturePixelHeight == 0) then
						texturePixelHeight = TILE_SIZE_HEIGHT
					end
					textureFileHeight = 16
					while(textureFileHeight < texturePixelHeight) do
						textureFileHeight = textureFileHeight * 2
					end
				end
				for k = 1, numTexturesWide do
					local texture = pin.overlayTexturePool:Acquire()
					if (k < numTexturesWide) then
						texturePixelWidth = TILE_SIZE_WIDTH
						textureFileWidth = TILE_SIZE_WIDTH
					else
						texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
						if (texturePixelWidth == 0) then
							texturePixelWidth = TILE_SIZE_WIDTH
						end
						textureFileWidth = 16
						while(textureFileWidth < texturePixelWidth) do
							textureFileWidth = textureFileWidth * 2
						end
					end

					texture:SetSize(texturePixelWidth, texturePixelHeight)
					texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight)
					texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k-1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
					texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")
					texture:SetDrawLayer("ARTWORK", -1)
					if KkthnxUIData[GetRealmName()][UnitName("player")].RevealWorldMap then
						texture:Show()
						if fullUpdate then
							pin.textureLoadGroup:AddTexture(texture)
						end
					else
						texture:Hide()
					end
					texture:SetVertexColor(0.6, 0.6, 0.6)

					tinsert(overlayTextures, texture)
				end
			end
		end
	end
end

-- Reset texture color and alpha
local function TexturePool_ResetVertexColor(pool, texture)
	texture:SetVertexColor(1, 1, 1)
	texture:SetAlpha(1)
	return TexturePool_HideAndClearAnchors(pool, texture)
end

function Module:CreateMapReveal()
	local bu = CreateFrame("CheckButton", nil, WorldMapFrame.BorderFrame, "OptionsCheckButtonTemplate")
	bu:SetPoint("TOPRIGHT", -260, 0)
	bu:SetSize(24, 24)
	bu:SetChecked(KkthnxUIData[GetRealmName()][UnitName("player")].RevealWorldMap)

	bu.text = bu:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	bu.text:SetPoint("LEFT", 24, 0)
	bu.text:SetText("Map Reveal")
	bu:SetHitRectInsets(0, 0 - bu.text:GetWidth(), 0, 0)
	bu.text:Show()

	for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		hooksecurefunc(pin, "RefreshOverlays", MapExplorationPin_RefreshOverlays)
		pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
	end

	function bu.UpdateTooltip(self)
		if (GameTooltip:IsForbidden()) then
			return
		end

		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 10)

		local r, g, b = 0.2, 1.0, 0.2

		if KkthnxUIData[GetRealmName()][UnitName("player")].RevealWorldMap == true then
			GameTooltip:AddLine(L["Hide Undiscovered Areas"])
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["Disable to hide areas."], r, g, b)
		else
			GameTooltip:AddLine(L["Reveal Hidden Areas"])
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L["Enable to show hidden areas."], r, g, b)
		end

		GameTooltip:Show()
	end

	bu:HookScript("OnEnter", function(self)
		if (GameTooltip:IsForbidden()) then
			return
		end

		self:UpdateTooltip()
	end)

	bu:HookScript("OnLeave", function()
		if (GameTooltip:IsForbidden()) then
			return
		end

		GameTooltip:Hide()
	end)

	bu:SetScript("OnClick", function(self)
		KkthnxUIData[GetRealmName()][UnitName("player")].RevealWorldMap = self:GetChecked()

		for i = 1, #overlayTextures do
			overlayTextures[i]:SetShown(KkthnxUIData[GetRealmName()][UnitName("player")].RevealWorldMap)
		end
	end)
end

function Module:CreateMapIcons()
		-- Flight points
		local tATex, tHTex = "TaxiNode_Alliance", "TaxiNode_Horde"
		local playerFaction = UnitFactionGroup("player")

		-- Add situational data
		if K.Class == "DRUID" then
			-- Moonglade flight points for druids only
			tinsert(K.WorldMapPlusPinData[1450], {"FlightA", 44.1, 45.2, "Nighthaven" .. ", " .. "Moonglade", "Druid only flight point to Darnassus", tATex, nil, nil})
			tinsert(K.WorldMapPlusPinData[1450], {"FlightH", 44.3, 45.9, "Nighthaven" .. ", " .. "Moonglade", "Druid only flight point to Thunder Bluff", tHTex, nil, nil})
		end

		local KkthnxUIMix = CreateFromMixins(MapCanvasDataProviderMixin)
		function KkthnxUIMix:RefreshAllData()
			-- Remove all pins
			self:GetMap():RemoveAllPinsByTemplate("KkthnxUIMapsGlobalPinTemplate")

			-- Make new pins
			local pMapID = WorldMapFrame.mapID
			if K.WorldMapPlusPinData[pMapID] then
				local count = #K.WorldMapPlusPinData[pMapID]
				for i = 1, count do

					-- Do nothing if pinInfo has no entry for zone we are looking at
					local pinInfo = K.WorldMapPlusPinData[pMapID][i]
					if not pinInfo then return nil end

					-- Get POI if any quest requirements have been met
					if (pinInfo[1] == "Dungeon" or pinInfo[1] == "Raid" or pinInfo[1] == "Dunraid")
						or playerFaction == "Alliance" and (pinInfo[1] == "FlightA" or pinInfo[1] == "FlightN")
						or playerFaction == "Horde" and (pinInfo[1] == "FlightH" or pinInfo[1] == "FlightN")
						or playerFaction == "Alliance" and (pinInfo[1] == "TravelA" or pinInfo[1] == "TravelN")
						or playerFaction == "Horde" and (pinInfo[1] == "TravelH" or pinInfo[1] == "TravelN")
					then
						local myPOI = {}
						myPOI["position"] = CreateVector2D(pinInfo[2] / 100, pinInfo[3] / 100)
						if pinInfo[7] and pinInfo[8] then
							-- Set dungeon level in title
							local playerLevel = K.Level
							local color
							local name = ""
							local dungeonMinLevel, dungeonMaxLevel = pinInfo[7], pinInfo[8]
							if playerLevel < dungeonMinLevel then
								color = GetQuestDifficultyColor(dungeonMinLevel)
							elseif playerLevel > dungeonMaxLevel then
								-- Subtract 2 from the maxLevel so zones entirely below the player's level won't be yellow
								color = GetQuestDifficultyColor(dungeonMaxLevel - 2)
							else
								color = QuestDifficultyColors["difficult"]
							end
							color = ConvertRGBtoColorString(color)
							if dungeonMinLevel ~= dungeonMaxLevel then
								name = name..color.." (" .. dungeonMinLevel .. "-" .. dungeonMaxLevel .. ")" .. FONT_COLOR_CODE_CLOSE
							else
								name = name..color.." (" .. dungeonMaxLevel .. ")" .. FONT_COLOR_CODE_CLOSE
							end
							myPOI["name"] = pinInfo[4] .. name
						else
							-- Show zone levels is disabled or dungeon has no level range
							myPOI["name"] = pinInfo[4]
						end
						myPOI["description"] = pinInfo[5]
						myPOI["atlasName"] = pinInfo[6]
						local pin = self:GetMap():AcquirePin("KkthnxUIMapsGlobalPinTemplate", myPOI)
						-- Override travel textures
						if pinInfo[1] == "TravelA" then
							pin.Texture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.Texture:SetTexCoord(0, 0.125, 0.5, 1)
							pin.HighlightTexture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.HighlightTexture:SetTexCoord(0, 0.125, 0.5, 1)
						elseif pinInfo[1] == "TravelH" then
							pin.Texture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.HighlightTexture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.Texture:SetTexCoord(0.125, 0.25, 0.5, 1)
							pin.HighlightTexture:SetTexCoord(0.125, 0.25, 0.5, 1)
						elseif pinInfo[1] == "TravelN" then
							pin.Texture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.HighlightTexture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.Texture:SetTexCoord(0.25, 0.375, 0.5, 1)
							pin.HighlightTexture:SetTexCoord(0.25, 0.375, 0.5, 1)
						elseif pinInfo[1] == "Dunraid" then
							pin.Texture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.HighlightTexture:SetTexture("Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps.blp")
							pin.Texture:SetTexCoord(0.375, 0.5, 0.5, 1)
							pin.Texture:SetSize(32, 32)
							pin.HighlightTexture:SetTexCoord(0.375, 0.5, 0.5, 1)
							pin.HighlightTexture:SetSize(32, 32)
						end
					end
				end
			end
		end

		KkthnxUIMapsGlobalPinMixin = BaseMapPoiPinMixin:CreateSubPin("PIN_FRAME_LEVEL_DUNGEON_ENTRANCE")

		function KkthnxUIMapsGlobalPinMixin:OnAcquired(myInfo)
			BaseMapPoiPinMixin.OnAcquired(self, myInfo)
		end

		function KkthnxUIMapsGlobalPinMixin:OnMouseUp(btn)
			if btn == "RightButton" then
				WorldMapFrame:NavigateToParentMap()
			end
		end

		WorldMapFrame:AddDataProvider(KkthnxUIMix)
end

local function AreaLabel_OnUpdate(self)
	self:ClearLabel(MAP_AREA_LABEL_TYPE.AREA_NAME)
	local map = self.dataProvider:GetMap()
	if map:IsCanvasMouseFocus() then
		local name, description
		local mapID = map:GetMapID()
		local normalizedCursorX, normalizedCursorY = map:GetNormalizedCursorPosition()
		local positionMapInfo = C_Map.GetMapInfoAtPosition(mapID, normalizedCursorX, normalizedCursorY)
		if positionMapInfo and positionMapInfo.mapID ~= mapID then
			-- print(positionMapInfo.mapID)
			name = positionMapInfo.name
			-- Get level range from table
			local playerMinLevel, playerMaxLevel, playerFaction
			if K.WorldMapLevelZoneData[positionMapInfo.mapID] then
				playerMinLevel = K.WorldMapLevelZoneData[positionMapInfo.mapID]["minLevel"]
				playerMaxLevel = K.WorldMapLevelZoneData[positionMapInfo.mapID]["maxLevel"]
				playerFaction = K.WorldMapLevelZoneData[positionMapInfo.mapID].faction
			end

			if (playerFaction) then
				local englishFaction = UnitFactionGroup("player")
				if (playerFaction == "Alliance") then
					description = string.format(FACTION_CONTROLLED_TERRITORY, FACTION_ALLIANCE)
				elseif (playerFaction == "Horde") then
					description = string.format(FACTION_CONTROLLED_TERRITORY, FACTION_HORDE)
				end

				if (englishFaction == playerFaction) then
					description = "|CFF40D326" .. description.."|r" .. FONT_COLOR_CODE_CLOSE
				else
					description = "|CFFF52E24" .. description.."|r" .. FONT_COLOR_CODE_CLOSE
				end
			end
			-- Show level range if map zone exists in table
			if name and playerMinLevel and playerMaxLevel and playerMinLevel > 0 and playerMaxLevel > 0 then
				local playerLevel = K.Level
				local color
				if playerLevel < playerMinLevel then
					color = GetQuestDifficultyColor(playerMinLevel)
				elseif playerLevel > playerMaxLevel then
					-- Subtract 2 from the maxLevel so zones entirely below the player's level won't be yellow
					color = GetQuestDifficultyColor(playerMaxLevel - 2)
				else
					color = QuestDifficultyColors["difficult"]
				end
				color = ConvertRGBtoColorString(color)
				if playerMinLevel ~= playerMaxLevel then
					name = name..color.." ("..playerMinLevel.."-"..playerMaxLevel..")"..FONT_COLOR_CODE_CLOSE
				else
					name = name..color.." ("..playerMaxLevel..")"..FONT_COLOR_CODE_CLOSE
				end
			end
		else
			name = MapUtil.FindBestAreaNameAtMouse(mapID, normalizedCursorX, normalizedCursorY)
		end

		if name then
			self:SetLabel(MAP_AREA_LABEL_TYPE.AREA_NAME, name, description)
		end
	end
	self:EvaluateLabels()
end

function Module:CreatePlayerArrowSize()
	local WorldMapUnitPin, WorldMapUnitPinSizes

	-- Get unit provider
	for pin in WorldMapFrame:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
		WorldMapUnitPin = pin
		WorldMapUnitPinSizes = pin.dataProvider:GetUnitPinSizesTable()
		break
	end

	WorldMapUnitPinSizes.player = 22
	WorldMapUnitPin:SynchronizePinSizes()
end

function Module:SetUpZoneLevels()
	for provider in next, WorldMapFrame.dataProviders do
		if provider.setAreaLabelCallback then
			provider.Label:SetScript("OnUpdate", AreaLabel_OnUpdate)
		end
	end
end

function Module:CreateClassIcons()
	local WorldMapUnitPin, WorldMapUnitPinSizes
	local partyTexture = "Interface\\AddOns\\KkthnxUI\\Media\\Worldmap\\Leatrix_Maps_Icon.blp"

	-- Set group icon textures
	for pin in WorldMapFrame:EnumeratePinsByTemplate("GroupMembersPinTemplate") do
		WorldMapUnitPin = pin
		WorldMapUnitPinSizes = pin.dataProvider:GetUnitPinSizesTable()
		WorldMapUnitPin:SetPinTexture("raid", partyTexture)
		WorldMapUnitPin:SetPinTexture("party", partyTexture)
		hooksecurefunc(WorldMapUnitPin, "UpdateAppearanceData", function(self)
			self:SetPinTexture("raid", partyTexture)
			self:SetPinTexture("party", partyTexture)
		end)
		break
	end

	-- Set party icon size and enable class colors
	WorldMapUnitPinSizes.party = 20
	WorldMapUnitPin:SetAppearanceField("party", "useClassColor", true)
	WorldMapUnitPin:SetAppearanceField("raid", "useClassColor", true)
	WorldMapUnitPin:SynchronizePinSizes()
end

function Module:CreateWorldMapPlus()
	if C["WorldMap"].WorldMapPlus ~= true then
		return
	end

	self:CreateMapReveal()
	self:CreateMapIcons()
	self:SetUpZoneLevels()
	self:CreatePlayerArrowSize()
	self:CreateClassIcons()
end