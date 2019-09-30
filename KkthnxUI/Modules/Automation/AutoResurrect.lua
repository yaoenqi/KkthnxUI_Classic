local K, C = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G

local UnitAffectingCombat = _G.UnitAffectingCombat
local AcceptResurrect = _G.AcceptResurrect
local C_Timer_After = _G.C_Timer.After
local UnitIsDeadOrGhost = _G.UnitIsDeadOrGhost
local DoEmote = _G.DoEmote

local GameLocale = GetLocale()

function Module.SetupAutoResurrect(_, arg1)
	-- Manage other resurrection requests
	if not UnitAffectingCombat(arg1) then
		AcceptResurrect()
		StaticPopup_Hide("RESURRECT_NO_TIMER")

		if C["Automation"].AutoResurrectThank ~= true then
			return
		end

		C_Timer_After(1, function() -- Give this more time to say thanks.
			if not UnitIsDeadOrGhost("player") then
				DoEmote("thank", arg1)
			end
		end)
	end
	return
end

function Module:CreateAutoResurrect()
	if C["Automation"].AutoResurrect ~= true then
		return
	end

	K:RegisterEvent("RESURRECT_REQUEST", self.SetupAutoResurrect)
end
