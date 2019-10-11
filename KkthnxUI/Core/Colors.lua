local K = unpack(select(2, ...))
local oUF = oUF or K.oUF

if (not oUF) then
	K.Print("Could not find a vaild instance of oUF. Stopping Colors.lua code!")
	return
end

oUF.colors.fallback = {1, 1, 0.8}

oUF.colors.castbar = {
	CastingColor = {0.26, 0.53, 1.0},
	ChannelingColor = {0.26, 0.53, 1.0},
	notInterruptibleColor = {0.78, 0.25, 0.25},
	CompleteColor = {0.1, 0.8, 0},
	FailColor = {1, 0.1, 0},
}

-- Aura Coloring
oUF.colors.debuff = {
	none = {204/255, 0/255, 0/255},
	Magic = {51/255, 153/255, 255/255},
	Curse = {204/255, 0/255, 255/255},
	Disease = {153/255, 102/255, 0/255},
	Poison = {0/255, 153/255, 0/255},
	[""] = {0/255, 0/255, 0/255},
}

oUF.colors.reaction = {
	[1] = {0.87, 0.37, 0.37}, -- Hated
	[2] = {0.87, 0.37, 0.37}, -- Hostile
	[3] = {0.87, 0.37, 0.37}, -- Unfriendly
	[4] = {0.85, 0.77, 0.36}, -- Neutral
	[5] = {0.29, 0.67, 0.30}, -- Friendly
	[6] = {0.29, 0.67, 0.30}, -- Honored
	[7] = {0.29, 0.67, 0.30}, -- Revered
	[8] = {0.29, 0.67, 0.30}, -- Exalted
}

oUF.colors.power = {
	["RUNES"] = {0.55, 0.57, 0.61},
	["SOUL_SHARDS"] = {0.50, 0.32, 0.55},
	["AMMOSLOT"] = {0.80, 0.60, 0.00},
	["FUEL"] = {0.00, 0.55, 0.50},
	["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
	["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
	["ALTPOWER"] = {0.00, 1.00, 1.00},
	["ENERGY"] = {0.65, 0.63, 0.35},
	["FOCUS"] = {0.71, 0.43, 0.27},
	["MANA"] = {0.31, 0.45, 0.63},
	["RAGE"] = {0.78, 0.25, 0.25},
	["COMBO_POINTS"] = {
		[1] = {.69, .31, .31, 1},
		[2] = {.65, .42, .31, 1},
		[3] = {.65, .63, .35, 1},
		[4] = {.50, .63, .35, 1},
		[5] = {.33, .63, .33, 1},
		[6] = {.03, .63, .33, 1},
	},
	["UNUSED"] = {195/255, 202/255, 217/255},
}

oUF.colors.class = {
	["DRUID"] = {1.00, 0.49, 0.03},
	["HUNTER"] = {0.67, 0.84, 0.45},
	["MAGE"] = {0.41, 0.80, 1.00},
	["PALADIN"] = {0.96, 0.55, 0.73},
	["PRIEST"] = {0.86, 0.92, 0.98},
	["ROGUE"] = {1.00, 0.95, 0.32},
	["SHAMAN"] = {0.16, 0.31, 0.61},
	["WARLOCK"] = {0.58, 0.51, 0.79},
	["WARRIOR"] = {0.78, 0.61, 0.43},
}

oUF.colors.totems = {
	[1] = {192/255, 57/255, 43/255}, -- Fire
	[2] = {183/255, 149/255, 11/255}, -- Earth
	[3] = {46/255, 134/255, 193/255}, -- Water
	[4] = {128/255, 222/255, 234/255}, -- Air
}

K["Colors"] = oUF.colors