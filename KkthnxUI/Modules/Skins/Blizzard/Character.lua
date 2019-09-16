local K, C = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local _G = _G
local table_insert = _G.table.insert

local HideUIPanel = _G.HideUIPanel
local hooksecurefunc = _G.hooksecurefunc
local unpack = _G.unpack

local function ReskinCharacterFrame()

	-- Strip Textures
	--_G.CharacterModelFrame:StripTextures()

	-- for _, corner in pairs({"TopLeft", "TopRight", "BotLeft", "BotRight"}) do
	-- 	local CharacterModelFrameBackground_Textures = _G["CharacterModelFrameBackground"..corner]
	-- 	if CharacterModelFrameBackground_Textures then
	-- 		CharacterModelFrameBackground_Textures:Kill()
	-- 	end
	-- end
	local ResistanceCoords = {
		[1] = { 0.21875, 0.8125, 0.25, 0.32421875 },		--Arcane
		[2] = { 0.21875, 0.8125, 0.0234375, 0.09765625 },	--Fire
		[3] = { 0.21875, 0.8125, 0.13671875, 0.2109375 },	--Nature
		[4] = { 0.21875, 0.8125, 0.36328125, 0.4375},		--Frost
		[5] = { 0.21875, 0.8125, 0.4765625, 0.55078125},	--Shadow
	}

	local function HandleResistanceFrame(frameName)
		for i = 1, 5 do
			local frame, icon, text = _G[frameName..i], _G[frameName..i]:GetRegions()
			frame:SetSize(22, 22)
			frame:CreateBorder()

			if i ~= 1 then
				frame:ClearAllPoints()
				frame:SetPoint('TOP', _G[frameName..i - 1], 'BOTTOM', 0, -4)
			end

			if icon then
				icon:SetInside()
				icon:SetTexCoord(unpack(ResistanceCoords[i]))
				icon:SetDrawLayer('ARTWORK')
			end

			if text then
				text:SetDrawLayer('OVERLAY')
			end
		end
	end

	HandleResistanceFrame('MagicResFrame')

	for _, slot in pairs({ PaperDollItemsFrame:GetChildren() }) do
		local icon = _G[slot:GetName()..'IconTexture']

		slot:CreateBorder(nil, nil, nil, true)
		slot:CreateInnerShadow()
		slot:StyleButton(slot)
		icon:SetTexCoord(unpack(K.TexCoords))
	end

	hooksecurefunc('PaperDollItemSlotButton_Update', function(self, cooldownOnly)
		if cooldownOnly then return end

		local textureName = GetInventoryItemTexture('player', self:GetID())
		if textureName then
			local rarity = GetInventoryItemQuality('player', self:GetID())
			if rarity and rarity > 1 then
				self:SetBackdropBorderColor(GetItemQualityColor(rarity))
			else
				self:SetBackdropBorderColor()
			end
		else
			self:SetBackdropBorderColor()
		end
	end)

	-- for _, slot in pairs({_G.PaperDollItemsFrame:GetChildren()}) do
	-- 	if slot:IsObjectType("Button") or slot:IsObjectType("ItemButton") then
	-- 		slot:CreateBorder(nil, nil, nil, true)
	-- 		slot:CreateInnerShadow()
	-- 		slot:StyleButton(slot)
	-- 		--slot.icon:SetTexCoord(unpack(K.TexCoords))
	-- 		slot:SetSize(36, 36)

	-- 		-- hooksecurefunc(slot, "DisplayAsAzeriteItem", UpdateAzeriteItem)
	-- 		-- hooksecurefunc(slot, "DisplayAsAzeriteEmpoweredItem", UpdateAzeriteEmpoweredItem)

	-- 		-- if slot.popoutButton:GetPoint() == "TOP" then
	-- 		-- 	slot.popoutButton:SetPoint("TOP", slot, "BOTTOM", 0, 2)
	-- 		-- else
	-- 		-- 	slot.popoutButton:SetPoint("LEFT", slot, "RIGHT", -2, 0)
	-- 		-- end

	-- 		-- slot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
	-- 		--slot.IconBorder:SetAlpha(0)
	-- 		-- hooksecurefunc(slot.IconBorder, "SetVertexColor", function(_, r, g, b)
	-- 		-- 	slot:SetBackdropBorderColor(r, g, b)
	-- 		-- end)

	-- 		-- hooksecurefunc(slot.IconBorder, "Hide", function()
	-- 		-- 	slot:SetBackdropBorderColor()
	-- 		-- end)
	-- 	end
	-- end

	-- CharacterHeadSlot:SetPoint("TOPLEFT", CharacterFrame.Inset, "TOPLEFT", 6, -6)
	-- CharacterHandsSlot:SetPoint("TOPRIGHT", CharacterFrame.Inset, "TOPRIGHT", -6, -6)
	-- CharacterMainHandSlot:SetPoint("BOTTOMLEFT", CharacterFrame.Inset, "BOTTOMLEFT", 176, 5)
	-- CharacterSecondaryHandSlot:ClearAllPoints()
	-- CharacterSecondaryHandSlot:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, "BOTTOMRIGHT", -176, 5)

	-- CharacterModelFrame:SetSize(0, 0)
	-- CharacterModelFrame:ClearAllPoints()
	-- CharacterModelFrame:SetPoint("TOPLEFT", CharacterFrame.Inset, 0, 0)
	-- CharacterModelFrame:SetPoint("BOTTOMRIGHT", CharacterFrame.Inset, 0, 30)
	-- CharacterModelFrame:SetCamDistanceScale(1.1)

	-- hooksecurefunc("CharacterFrame_Expand", function()
	-- 	CharacterFrame:SetSize(640, 431) -- 540 + 100, 424 + 7
	-- 	CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 432, 4)

	-- 	CharacterFrame.Inset.Bg:SetTexture("Interface\\DressUpFrame\\DressingRoom" .. K.Class)
	-- 	CharacterFrame.Inset.Bg:SetTexCoord(1 / 512, 479 / 512, 46 / 512, 455 / 512)
	-- 	CharacterFrame.Inset.Bg:SetHorizTile(false)
	-- 	CharacterFrame.Inset.Bg:SetVertTile(false)
	-- end)

	-- hooksecurefunc("CharacterFrame_Collapse", function()
	-- 	CharacterFrame:SetHeight(424)
	-- 	CharacterFrame.Inset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 332, 4)

	-- 	CharacterFrame.Inset.Bg:SetTexture("Interface\\FrameGeneral\\UI-Background-Marble", "REPEAT", "REPEAT")
	-- 	CharacterFrame.Inset.Bg:SetTexCoord(0, 1, 0, 1)
	-- 	CharacterFrame.Inset.Bg:SetHorizTile(true)
	-- 	CharacterFrame.Inset.Bg:SetVertTile(true)
	-- end)

	-- _G.CharacterLevelText:FontTemplate()
	-- _G.CharacterStatsPane.ItemLevelFrame.Value:FontTemplate(nil, 20)

	-- CharacterStatsPane.ClassBackground:ClearAllPoints()
	-- CharacterStatsPane.ClassBackground:SetHeight(CharacterStatsPane.ClassBackground:GetHeight() + 6)
	-- CharacterStatsPane.ClassBackground:SetParent(CharacterFrameInsetRight)
	-- CharacterStatsPane.ClassBackground:SetPoint("CENTER")

	-- if not IsAddOnLoaded("DejaCharacterStats") then
	-- 	StatsPane("EnhancementsCategory")
	-- 	StatsPane("ItemLevelCategory")
	-- 	StatsPane("AttributesCategory")
	-- end

	--Buttons used to toggle between equipment manager, titles, and character stats
	-- hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", FixSidebarTabCoords)
end

table_insert(Module.NewSkin["KkthnxUI"], ReskinCharacterFrame)