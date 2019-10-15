local K, C, L = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G
local string_format = string.format

local CancelDuel = _G.CancelDuel
local InCombatLockdown = _G.InCombatLockdown
local StaticPopup_Hide = _G.StaticPopup_Hide

-- Auto decline duels
function Module.DeclineDuels(event, name)
	local cancelled = false
	if event == "DUEL_REQUESTED" and C["Automation"].DeclinePvPDuel and not InCombatLockdown() then
		CancelDuel()
		StaticPopup_Hide("DUEL_REQUESTED")
		cancelled = "Regular"
	end

	if cancelled then
		K.Print(string_format(L["DuelCanceled_"..cancelled], "|cff4488ff"..name.."|r"))
	end
end

function Module:CreateAutoDeclineDuels()
	K:RegisterEvent("DUEL_REQUESTED", self.DeclineDuels)
end