local K = unpack(select(2, ...))

-- Reminder Buffs Checklist
K.ReminderBuffs = {
	MAGE = {
			{	spells = {	-- 奥术智慧
				[1459] = true,
				[8096] = true, -- 智力卷轴
				[23028] = true, -- 奥术光辉
			},
			depend = 1459,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	PRIEST = {
			{	spells = {	-- 真言术耐
				[1243] = true,
				[8099] = true, -- 耐力卷轴
				[21562] = true, -- 坚韧祷言
			},
			depend = 1243,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
	WARLOCK = {
			{	spells = {
				[706] = true,
				[687] = true,
			},
			-- depend = 1243,
			combat = true,
			instance = true,
			pvp = true,
		},
	},
}