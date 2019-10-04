local K, _, L = unpack(select(2, ...))

if GetLocale() == "deDE" then
	L["Ghost"] = "Geist"
	L["General"] = "Allgemein"
	L["Combat"] = "Kampflog"
	L["Whisper"] = "Flüstern"
	L["Trade"] = "Handel"
	L["Loot"] = "Beute"
	L["ConfigPerAccount"] = "Globales Profil ist aktiv. Beende."
end