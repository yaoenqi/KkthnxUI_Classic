local K = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local _G = _G

local hooksecurefunc = _G.hooksecurefunc
local GetInventoryItemID = _G.GetInventoryItemID
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor

local function ReskinInspectUI()
	InspectModelFrameRotateLeftButton:Kill()
	InspectModelFrameRotateRightButton:Kill()

	for _, slot in pairs({ _G.InspectPaperDollItemsFrame:GetChildren() }) do
		local icon = _G[slot:GetName()..'IconTexture']

		slot:CreateBorder(nil, nil, nil, true)
		slot:CreateInnerShadow()
		slot:StyleButton(slot)
		icon:SetTexCoord(unpack(K.TexCoords))
	end

	hooksecurefunc('InspectPaperDollItemSlotButton_Update', function(button)
		if button.hasItem then
			local itemID = GetInventoryItemID(InspectFrame.unit, button:GetID())
			if itemID then
				local quality = select(3, GetItemInfo(itemID))
				if not quality then
					K.Delay(0.2, function()
						if InspectFrame.unit then
							InspectPaperDollItemSlotButton_Update(button)
						end
					end)
					return
				elseif quality and quality > 1 then
					button:SetBackdropBorderColor(GetItemQualityColor(quality))
					return
				end
			end
		end
		button:SetBackdropBorderColor()
	end)
end

Module.NewSkin["Blizzard_InspectUI"] = ReskinInspectUI