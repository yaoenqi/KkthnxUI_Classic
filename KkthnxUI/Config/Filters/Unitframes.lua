local K = unpack(select(2, ...))

local _G = _G
local print = _G.print

local GetSpellInfo = _G.GetSpellInfo

local function Defaults(priorityOverride)
	return {["enable"] = true, ["priority"] = priorityOverride or 0, ["stackThreshold"] = 0}
end

local function SpellName(id)
	local name = GetSpellInfo(id)
	if not name then
		-- print("|cff3c9bedKkthnxUI:|r SpellID is not valid: " .. id .. ". Please check for an updated version, if none exists report to Kkthnx in Discord.")
		return "Impale"
	else
		return name
	end
end

K.DebuffsTracking = {}
K.DebuffsTracking["RaidDebuffs"] = {
	-- BROKEN: Need to build a new classic RaidDebuffs list
	-- EXAMPLE: See comment in spells table

	["type"] = "Whitelist",
	["spells"] = {
		-- [209858] = Defaults(), -- Necrotic
	},
}

-- CC DEBUFFS (TRACKING LIST)
K.DebuffsTracking["CCDebuffs"] = {
	-- BROKEN: Need to build a new classic CCDebuffs list
	-- EXAMPLE: See comment in spells table

	["type"] = "Whitelist",
	["spells"] = {
		-- [107079] = Defaults(4), -- Quaking Palm
	},
}

-- Raid Buffs (Squared Aura Tracking List)
K.RaidBuffsTracking = {
	PRIEST = {
		-- {194384, "TOPRIGHT", {1, 0, 0.75}}, -- Atonement
	},
	DRUID = {
		-- {774, "TOPRIGHT", {0.8, 0.4, 0.8}}, -- Rejuvenation
	},
	PALADIN = {
		-- {53563, "TOPRIGHT", {0.7, 0.3, 0.7}}, -- Beacon of Light
	},
	SHAMAN = {
		-- {61295, "TOPRIGHT", {0.7, 0.3, 0.7}}, -- Riptide
	},
	ROGUE = {
		--{57934, "TOPRIGHT", {227 / 255, 23 / 255, 13 / 255}} -- Tricks of the Trade
	},

	WARRIOR = {
		--{114030, "TOPLEFT", {0.2, 0.2, 1}}, -- Vigilance
	},
	PET = {
		-- Warlock Pets
		--{193396, "TOPRIGHT", {0.6, 0.2, 0.8}, true}, -- Demonic Empowerment
		-- Hunter Pets
		--{19615, "TOPLEFT", {227 / 255, 23 / 255, 13 / 255}, true}, -- Frenzy
	},
}

K.RaidBuffsTrackingPosition = {
	TOPLEFT = {6, 1},
	TOPRIGHT = {-6, 1},
	BOTTOMLEFT = {6, 1},
	BOTTOMRIGHT = {-6, 1},
	LEFT = {6, 1},
	RIGHT = {-6, 1},
	TOP = {0, 0},
	BOTTOM = {0, 0}
}

K.DebuffHighlightColors = {
	[25771] = {
		enable = false,
		style = "FILL",
		color = {r = 0.85, g = 0, b = 0, a = 0.85}
	},
}

-- Filter this. Pointless to see.
K.UnimportantBuffs = {
	[SpellName(113942)] = true, -- Demonic: Gateway
	[SpellName(117870)] = true, -- Touch of The Titans
	[SpellName(123981)] = true, -- Perdition
	[SpellName(126434)] = true, -- Tushui Champion
	[SpellName(126436)] = true, -- Huojin Champion
	[SpellName(131493)] = true, -- B.F.F. Friends forever!
	[SpellName(143625)] = true, -- Brawling Champion
	[SpellName(15007)] = true, -- Ress Sickness
	[SpellName(170616)] = true, -- Pet Deserter
	[SpellName(182957)] = true, -- Treasures of Stormheim
	[SpellName(182958)] = true, -- Treasures of Azsuna
	[SpellName(185719)] = true, -- Treasures of Val"sharah
	[SpellName(186401)] = true, -- Sign of the Skirmisher
	[SpellName(186403)] = true, -- Sign of Battle
	[SpellName(186404)] = true, -- Sign of the Emissary
	[SpellName(186406)] = true, -- Sign of the Critter
	[SpellName(188741)] = true, -- Treasures of Highmountain
	[SpellName(199416)] = true, -- Treasures of Suramar
	[SpellName(225787)] = true, -- Sign of the Warrior
	[SpellName(225788)] = true, -- Sign of the Emissary
	[SpellName(227723)] = true, -- Mana Divining Stone
	[SpellName(231115)] = true, -- Treasures of Broken Shore
	[SpellName(233641)] = true, -- Legionfall Commander
	[SpellName(23445)] = true, -- Evil Twin
	[SpellName(237137)] = true, -- Knowledgeable
	[SpellName(237139)] = true, -- Power Overwhelming
	[SpellName(239645)] = true, -- Fel Treasures
	[SpellName(239647)] = true, -- Epic Hunter
	[SpellName(239648)] = true, -- Forces of the Order
	[SpellName(239966)] = true, -- War Effort
	[SpellName(239967)] = true, -- Seal Your Fate
	[SpellName(239968)] = true, -- Fate Smiles Upon You
	[SpellName(239969)] = true, -- Netherstorm
	[SpellName(240979)] = true, -- Reputable
	[SpellName(240980)] = true, -- Light As a Feather
	[SpellName(240985)] = true, -- Reinforced Reins
	[SpellName(240986)] = true, -- Worthy Champions
	[SpellName(240987)] = true, -- Well Prepared
	[SpellName(240989)] = true, -- Heavily Augmented
	[SpellName(24755)] = true, -- Tricked or Treated
	[SpellName(25163)] = true, -- Oozeling"s Disgusting Aura
	[SpellName(26013)] = true, -- Deserter
	[SpellName(36032)] = true, -- Arcane Charge
	[SpellName(36893)] = true, -- Transporter Malfunction
	[SpellName(36900)] = true, -- Soul Split: Evil!
	[SpellName(36901)] = true, -- Soul Split: Good
	[SpellName(39953)] = true, -- A"dal"s Song of Battle
	[SpellName(41425)] = true, -- Hypothermia
	[SpellName(44212)] = true, -- Jack-o"-Lanterned!
	[SpellName(55711)] = true, -- Weakened Heart
	[SpellName(57723)] = true, -- Exhaustion (heroism debuff)
	[SpellName(57724)] = true, -- Sated (lust debuff)
	[SpellName(57819)] = true, -- Argent Champion
	[SpellName(57820)] = true, -- Ebon Champion
	[SpellName(57821)] = true, -- Champion of the Kirin Tor
	[SpellName(58539)] = true, -- Watcher"s Corpse
	[SpellName(71041)] = true, -- Dungeon Deserter
	[SpellName(72968)] = true, -- Precious"s Ribbon
	[SpellName(80354)] = true, -- Temporal Displacement (timewarp debuff)
	[SpellName(8326)] = true, -- Ghost
	[SpellName(85612)] = true, -- Fiona"s Lucky Charm
	[SpellName(85613)] = true, -- Gidwin"s Weapon Oil
	[SpellName(85614)] = true, -- Tarenar"s Talisman
	[SpellName(85615)] = true, -- Pamela"s Doll
	[SpellName(85616)] = true, -- Vex"tul"s Armbands
	[SpellName(85617)] = true, -- Argus" Journal
	[SpellName(85618)] = true, -- Rimblat"s Stone
	[SpellName(85619)] = true, -- Beezil"s Cog
	[SpellName(8733)] = true, -- Blessing of Blackfathom
	[SpellName(89140)] = true, -- Demonic Rebirth: Cooldown
	[SpellName(93337)] = true, -- Champion of Ramkahen
	[SpellName(93339)] = true, -- Champion of the Earthen Ring
	[SpellName(93341)] = true, -- Champion of the Guardians of Hyjal
	[SpellName(93347)] = true, -- Champion of Therazane
	[SpellName(93368)] = true, -- Champion of the Wildhammer Clan
	[SpellName(93795)] = true, -- Stormwind Champion
	[SpellName(93805)] = true, -- Ironforge Champion
	[SpellName(93806)] = true, -- Darnassus Champion
	[SpellName(93811)] = true, -- Exodar Champion
	[SpellName(93816)] = true, -- Gilneas Champion
	[SpellName(93821)] = true, -- Gnomeregan Champion
	[SpellName(93825)] = true, -- Orgrimmar Champion
	[SpellName(93827)] = true, -- Darkspear Champion
	[SpellName(93828)] = true, -- Silvermoon Champion
	[SpellName(93830)] = true, -- Bilgewater Champion
	[SpellName(94158)] = true, -- Champion of the Dragonmaw Clan
	[SpellName(94462)] = true, -- Undercity Champion
	[SpellName(94463)] = true, -- Thunder Bluff Champion
	[SpellName(95809)] = true, -- Insanity debuff (hunter pet heroism: ancient hysteria)
	[SpellName(97340)] = true, -- Guild Champion
	[SpellName(97341)] = true, -- Guild Champion
	[SpellName(97821)] = true -- Void-Touched
}

K.ChannelingTicks = {
	[SpellName(740)] = 4,		-- 宁静
	[SpellName(755)] = 3,		-- 生命通道
	[SpellName(5143)] = 5, 		-- 奥术飞弹
	[SpellName(12051)] = 3, 		-- 唤醒
	[SpellName(15407)] = 4,		-- 精神鞭笞
	[SpellName(6948)] = 4,		-- 精神鞭笞
}