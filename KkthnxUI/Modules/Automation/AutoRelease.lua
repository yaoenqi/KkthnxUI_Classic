local K, C = unpack(select(2, ...))
local Module = K:GetModule("Automation")

local _G = _G

local IsInInstance = _G.IsInInstance

-- Auto release the spirit in battlegrounds
function Module.PLAYER_DEAD()
	-- If player has ability to self-resurrect (soulstone, reincarnation, etc), do nothing and quit
	if C_DeathInfo.GetSelfResurrectOptions() and #C_DeathInfo.GetSelfResurrectOptions() > 0 then
		return
	end

	-- Resurrect if player is in a battleground
	local InstStat, InstType = IsInInstance()
	if InstStat and InstType == "pvp" then
		RepopMe()
		return
	end
	return
end

function Module:CreateAutoRelease()
	if C["Automation"].AutoRelease ~= true then
		return
	end

	K:RegisterEvent("PLAYER_DEAD", self.PLAYER_DEAD)
end
