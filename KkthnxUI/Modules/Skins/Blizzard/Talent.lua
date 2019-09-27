local K = unpack(select(2, ...))
local Module = K:GetModule("Skins")

local function ReskinTalentUI()
	for i = 1, _G.MAX_NUM_TALENTS do
		local talent = _G["TalentFrameTalent"..i]
		local icon = _G["TalentFrameTalent"..i.."IconTexture"]
		local rank = _G["TalentFrameTalent"..i.."Rank"]

		if talent then
			talent:CreateBorder(nil, nil, nil, true)
			talent:StyleButton()

			icon:SetAllPoints()
			icon:SetTexCoord(unpack(K.TexCoords))
			icon:SetDrawLayer("ARTWORK")

			rank:FontTemplate(nil, nil, "OUTLINE")
		end
	end
end

Module.NewSkin["Blizzard_TalentUI"] = ReskinTalentUI