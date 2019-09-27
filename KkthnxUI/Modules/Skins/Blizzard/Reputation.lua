local K, C = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local table_insert = table.insert

local function SkinFactionbarTextures()
	for i = 1, NUM_FACTIONS_DISPLAYED do
		local factionBar = _G["ReputationBar"..i]
		local factionBarTexture = K.GetTexture(C["UITextures"].SkinTextures)

		factionBar:SetStatusBarTexture(factionBarTexture)
	end
end

table_insert(Module.NewSkin["KkthnxUI"], SkinFactionbarTextures)