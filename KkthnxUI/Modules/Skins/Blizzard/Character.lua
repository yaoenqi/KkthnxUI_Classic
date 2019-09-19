local K, C = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local _G = _G
local table_insert = _G.table.insert

local GetInventoryItemQuality = _G.GetInventoryItemQuality
local GetInventoryItemTexture = _G.GetInventoryItemTexture
local GetItemQualityColor = _G.GetItemQualityColor
local hooksecurefunc = _G.hooksecurefunc
local unpack = _G.unpack

local function ReskinCharacterFrame()
	local ResistanceCoords = {
		[1] = {0.21875, 0.8125, 0.25, 0.32421875}, -- Arcane
		[2] = {0.21875, 0.8125, 0.0234375, 0.09765625}, -- Fire
		[3] = {0.21875, 0.8125, 0.13671875, 0.2109375}, -- Nature
		[4] = {0.21875, 0.8125, 0.36328125, 0.4375}, -- Frost
		[5] = {0.21875, 0.8125, 0.4765625, 0.55078125}, -- Shadow
	}

	local function HandleResistanceFrame(frameName)
		for i = 1, 5 do
			local frame, icon, text = _G[frameName..i], _G[frameName..i]:GetRegions()
			frame:SetSize(22, 22)
			frame:CreateBorder()
			frame:ClearAllPoints()

			if i == 1 then
				frame:SetPoint("TOP", 2, -4)
			elseif i ~= 1 then
				frame:SetPoint("TOP", _G[frameName..i - 1], "BOTTOM", 0, -6)
			end

			if icon then
				icon:SetInside()
				icon:SetTexCoord(unpack(ResistanceCoords[i]))
				icon:SetDrawLayer("ARTWORK")
			end

			if text then
				text:SetDrawLayer("OVERLAY")
			end
		end
	end
	HandleResistanceFrame("MagicResFrame")

	for _, slot in pairs({PaperDollItemsFrame:GetChildren()}) do
		local icon = _G[slot:GetName().."IconTexture"]

		slot:CreateBorder(nil, nil, nil, true)
		slot:CreateInnerShadow()
		slot:StyleButton(slot)
		icon:SetTexCoord(unpack(K.TexCoords))
	end

	hooksecurefunc("PaperDollItemSlotButton_Update", function(self, cooldownOnly)
		if cooldownOnly then
			return
		end

		local textureName = GetInventoryItemTexture("player", self:GetID())
		if textureName then
			local rarity = GetInventoryItemQuality("player", self:GetID())
			if rarity and rarity > 1 then
				self:SetBackdropBorderColor(GetItemQualityColor(rarity))
			else
				self:SetBackdropBorderColor()
			end
		else
			self:SetBackdropBorderColor()
		end
	end)
end

table_insert(Module.NewSkin["KkthnxUI"], ReskinCharacterFrame)