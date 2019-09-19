local K, C = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local _G = _G
local table_insert = table.insert

local hooksecurefunc = _G.hooksecurefunc

local function LoadSpellBookSkin()
	-- Spell Buttons
	for i = 1, _G.SPELLS_PER_PAGE do
		local button = _G['SpellButton'..i]
		local icon = _G['SpellButton'..i..'IconTexture']

		for i = 1, button:GetNumRegions() do
			local region = select(i, button:GetRegions())
			if region:GetObjectType() == 'Texture' then
				if region:GetTexture() ~= 'Interface\\Buttons\\ActionBarFlyoutButton' then
					region:SetTexture(nil)
				end
			end
		end

		button:CreateBorder()
		button:CreateInnerShadow()
		icon:SetTexCoord(unpack(K.TexCoords))
	end

	for i = 1, _G.MAX_SKILLLINE_TABS do
		local tab = _G['SpellBookSkillLineTab'..i]

		tab:StripTextures()
		tab:StyleButton(nil, true)
		tab:CreateBorder()
		tab.pushed = true

		tab:GetNormalTexture():SetInside()
		tab:GetNormalTexture():SetTexCoord(unpack(K.TexCoords))

		hooksecurefunc(tab:GetHighlightTexture(), 'SetTexture', function(self, texPath)
			if texPath ~= nil then
				self:SetPushedTexture(nil)
			end
		end)

		hooksecurefunc(tab:GetCheckedTexture(), 'SetTexture', function(self, texPath)
			if texPath ~= nil then
				self:SetHighlightTexture(nil)
			end
		end)
	end

end

table_insert(Module.NewSkin["KkthnxUI"], LoadSpellBookSkin)