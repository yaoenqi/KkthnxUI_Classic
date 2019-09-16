local K, C = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local _G = _G
local table_insert = table.insert

local function LoadSpellBookSkin()
	-- Spell Buttons
	for i = 1, SPELLS_PER_PAGE do
		local button = _G['SpellButton'..i]
		local icon = _G['SpellButton'..i..'IconTexture']

		for _ = 1, button:GetNumRegions() do
			local region = select(i, button:GetRegions())
			if region:GetObjectType() == 'Texture' then
				if region:GetTexture() ~= 'Interface\\Buttons\\ActionBarFlyoutButton' then
					region:SetTexture(nil)
				end
			end
		end

		button:CreateBorder()
		icon:SetTexCoord(unpack(K.TexCoords))
	end
end

table_insert(Module.NewSkin["KkthnxUI"], LoadSpellBookSkin)