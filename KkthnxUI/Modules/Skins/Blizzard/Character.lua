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
	for _, slot in pairs({PaperDollItemsFrame:GetChildren()}) do
		local icon = _G[slot:GetName()..'IconTexture']

		slot:CreateBorder(nil, nil, nil, true)
		slot:CreateInnerShadow()
		slot:StyleButton(slot)
		icon:SetTexCoord(unpack(K.TexCoords))
	end

	hooksecurefunc('PaperDollItemSlotButton_Update', function(self, cooldownOnly)
		if cooldownOnly then
			return
		end

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
end

table_insert(Module.NewSkin["KkthnxUI"], ReskinCharacterFrame)