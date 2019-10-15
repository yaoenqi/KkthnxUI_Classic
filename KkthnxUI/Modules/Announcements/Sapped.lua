local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Announcements")

local _G = _G

local SendChatMessage = _G.SendChatMessage
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo

-- Build Spell list (this ignores ranks)
local SaySappedList = {
	[GetSpellInfo(11297)] = true, -- Sapped
}

function Module:SetupSaySapped()
	local _, event, _, _, sourceName, _, _, _, destName, _, _, _, spellName = CombatLogGetCurrentEventInfo()

	if not (event == "SPELL_AURA_APPLIED" or not event == "SPELL_AURA_REFRESH") then
		return
	end

	if (SaySappedList[spellName]) and (destName == K.Name) then
		SendChatMessage(L["Sapped"], "SAY")
		UIErrorsFrame:AddMessage(L["SappedBy"]..(sourceName or UNKNOWN))
	end
end

function Module:CreateSaySappedAnnounce()
	if C["Announcements"].SaySapped ~= true then
		return
	end

	self:SetupSaySapped()
end
