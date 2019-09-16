local _G = _G

local K = _G.unpack(_G.select(2, ...))
local Module = K:GetModule("Unitframes")

--WoW API / Variables
local CheckInteractDistance = CheckInteractDistance

function Module:CreateRangeIndicator(unit)
	if not self.Fader then return end
	local alpha

	unit = unit or self.unit

	if self.forceInRange or unit == 'player' then
		alpha = self.Fader.MaxAlpha
	elseif self.forceNotInRange then
		alpha = self.Fader.MinAlpha
	elseif unit then
	    local inRange = CheckInteractDistance(unit, 4)
        if not inRange then
            alpha = self.Fader.MinAlpha
        elseif inRange then
            alpha = self.Fader.MaxAlpha
        end
	else
		alpha = self.Fader.MaxAlpha
	end

	self.Fader.RangeAlpha = alpha
end