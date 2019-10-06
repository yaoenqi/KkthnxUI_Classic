local _, ns = ...
local oUF = ns.oUF or oUF
local LibClassicDurations = LibStub("LibClassicDurations")

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		print("|cff3c9bedKkthnxUI:|r PortraitTimer SpellID is not valid: " .. id .. ". Please check for an updated version, if none exists report to Kkthnx in Discord.")
		return "Impale"
	else
		return name
	end
end

ns.PortraitTimerDB = {
	[SpellName(1022)] = true,
	[SpellName(1022)] = true, -- Hand of Protection
	[SpellName(1044)] = true, -- Hand of Freedom
	[SpellName(118)] = true, -- Polymorph
	[SpellName(11958)] = true, -- Ice Block
	[SpellName(122)] = true, -- Frost Nova
	[SpellName(12489)] = true, -- Improved Cone of Cold
	[SpellName(12809)] = true, -- Concussion Blow
	[SpellName(1330)] = true, -- Garrote - Silence
	[SpellName(1499)] = true, -- Freezing Trap
	[SpellName(1513)] = true, -- Scare Beast
	[SpellName(15487)] = true, -- Silence (priest)
	[SpellName(16689)] = true, -- Nature's Grasp
	[SpellName(1702)] = true, -- Shockwave
	[SpellName(1776)] = true, -- Gouge
	[SpellName(1833)] = true, -- Cheap Shot
	[SpellName(18499)] = true, -- Berserker Rage
	[SpellName(1850)] = true, -- Dash
	[SpellName(19263)] = true, -- Deterrence
	[SpellName(19387)] = true, -- Entrapment
	[SpellName(19503)] = true, -- Scatter Shot
	[SpellName(19647)] = true, -- Spell Lock
	[SpellName(20066)] = true, -- Repentance
	[SpellName(20253)] = true, -- Intercept
	[SpellName(2094)] = true, -- Blind
	[SpellName(22570)] = true, -- Maim
	[SpellName(22812)] = true, -- Barkskin
	[SpellName(23694)] = true, -- Improved Hamstring
	[SpellName(23920)] = true, -- Spell Reflection (warrior)
	[SpellName(2637)] = true, -- Hibernate
	[SpellName(29166)] = true, -- Innervate
	[SpellName(2983)] = true, -- Sprint
	[SpellName(339)] = true, -- Entangling Roots
	[SpellName(408)] = true, -- Kidney Shot
	[SpellName(498)] = true, -- Divine Protection
	[SpellName(5197)] = true, -- Cyclone
	[SpellName(5211)] = true, -- Bash
	[SpellName(5211)] = true, -- Mighty Bash
	[SpellName(5246)] = true, -- Intimidating Shout
	[SpellName(5277)] = true, -- Evasion
	[SpellName(5484)] = true, -- Howl of Terror
	[SpellName(5782)] = true, -- Fear
	[SpellName(605)] = true, -- Mind Control
	[SpellName(6358)] = true, -- Seduction
	[SpellName(642)] = true, -- Divine Shield
	[SpellName(6466)] = true, -- Axe Toss
	[SpellName(676)] = true, -- Disarm
	[SpellName(6770)] = true, -- Sap
	[SpellName(6789)] = true, -- Death Coil
	[SpellName(6940)] = true, -- Hand of Sacrifice
	[SpellName(8122)] = true, -- Psychic Scream
	[SpellName(8377)] = true, -- Earthgrab
	[SpellName(853)] = true, -- Hammer of Justice
	[SpellName(8643)] = true, -- Kidney Shot(R2)
	[SpellName(871)] = true, -- Shield Wall
	[SpellName(9005)] = true, -- Pounce
	[SpellName(9484)] = true, -- Shackle Undead
}

local Update = function(self, event, unit)
	if self.unit ~= unit or self.IsTargetFrame then
		return
	end

	local element = self.PortraitTimer
	local name, texture, duration, expirationTime, unitCaster, spellId
	local results

	for i = 1, 40 do
		name, texture, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitBuff(unit, i)

		if name then
			results = ns.PortraitTimerDB[SpellName(spellId)]

			if results then
				local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster, name)
				if durationNew and durationNew > 0 then
					duration = durationNew
					expirationTime = expirationTimeNew
				end

				element.Icon:SetTexture(texture)
				CooldownFrame_Set(element.cooldownFrame, expirationTime - duration, duration, duration > 0)
				element:Show()

				if self.CombatFeedbackText then
					self.CombatFeedbackText.maxAlpha = 0
				end
				return
			end
		end
	end

	for i = 1, 40 do
		name, texture, _, _, duration, expirationTime, unitCaster, _, _, spellId = UnitDebuff(unit, i)

		if name then
			results = ns.PortraitTimerDB[SpellName(spellId)]

			if results then
				local durationNew, expirationTimeNew = LibClassicDurations:GetAuraDurationByUnit(unit, spellId, unitCaster, name)
				if durationNew and durationNew > 0 then
					duration = durationNew
					expirationTime = expirationTimeNew
				end

				element.Icon:SetTexture(texture)
				CooldownFrame_Set(element.cooldownFrame, expirationTime - duration, duration, duration > 0)
				element:Show()

				if self.CombatFeedbackText then
					self.CombatFeedbackText.maxAlpha = 0
				end
				return
			end
		end
	end

	element:Hide()
	if self.CombatFeedbackText then
		self.CombatFeedbackText.maxAlpha = 1
	end

	if event == "PLAYER_ENTERING_WORLD" then
		CooldownFrame_Set(element.cooldownFrame, 1, 1, 1)
	end
end

local Enable = function(self)
	local element = self.PortraitTimer

	if element then
		self:RegisterEvent("UNIT_AURA", Update)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Update, true)

		if not element.Icon then
			local mask = element:CreateMaskTexture()
			mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
			mask:SetAllPoints(element)

			element.Icon = element:CreateTexture(nil, "ARTWORK")
			element.Icon:SetAllPoints(element)
			element.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		end

		if not element.cooldownFrame then
			element.cooldownFrame = CreateFrame("Cooldown", nil, element, "CooldownFrameTemplate")
			element.cooldownFrame:SetAllPoints(element)
			element.cooldownFrame:SetHideCountdownNumbers(false)
			element.cooldownFrame:SetDrawSwipe(false)
		end

		element:Hide()

		return true
	end
end

local Disable = function(self)
	local element = self.PortraitTimer
	if element then
		self:UnregisterEvent("UNIT_AURA", Update)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Update)
	end
end

oUF:AddElement("PortraitTimer", Update, Enable, Disable)