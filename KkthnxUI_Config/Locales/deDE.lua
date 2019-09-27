-- local MissingDesc = "The description for this module/setting is missing. Someone should really remind Kkthnx to do his job!"
local ModuleNewFeature = [[|TInterface\OptionsFrame\UI-OptionsFrame-NewFeatureIcon:0:0:0:0|t]] -- Used for newly implemented features.
-- local PerformanceIncrease = "|n|nDisabling this may slightly increase performance|r" -- For semi-high CPU options
-- local RestoreDefault = "|n|nRight-click to restore to default" -- For color pickers

local _G = _G

local REVERSE_NEW_LOOT_TEXT = _G.REVERSE_NEW_LOOT_TEXT

_G.KkthnxUIConfig["deDE"] = {
	-- Menu Groups Display Names
	["GroupNames"] = {
		-- Let's Keep This In Alphabetical Order, Shall We?
		["ActionBar"] = "Aktionsleisten",
		["Announcements"] = "Ansagen",
		["Arena"] = "Arena",
		["Auras"] = "Buffs",
		["Automation"] = "Automatisierung",
		["Boss"] = "Boss",
		["Chat"] = "Chat",
		["DataBars"] = "Datenleisten",
		["DataText"] = "Datentext",
		["Filger"] = "Filger",
		["General"] = "Allgemein",
		["Inventory"] = "Inventar",
		["Loot"] = "Beute",
		["Minimap"] = "Minikarte",
		["Misc"] = "Diverses",
		["Nameplates"] = "Namensplaketten",
		["Party"] = "Gruppe",
		["QuestNotifier"] = "Quest Benachrichtigung",
		["Raid"] = "Raid",
		["Skins"] = "Skins",
		["Tooltip"] = "Tooltip",
		["UIFonts"] = ModuleNewFeature.."Schriftarten",
		["UITextures"] = ModuleNewFeature.."Texturen",
		["Unitframe"] = "Einheitenfenster",
		["WorldMap"] = "Weltkarte",
	},

	-- Actionbar Local
	["ActionBar"] = {
		["Cooldowns"] = {
			["Name"] = "Zeige Abklingzeiten",
		},

		["Count"] = {
			["Name"] = "Zeige Gegenstandsanzahl",
		},

		["DecimalCD"] = {
			["Name"] = "Dezimal für Abklingzeiten in 3s",
		},

		["DefaultButtonSize"] = {
			["Name"] = "Größe der Knöpfe der Hauptaktionsleiste",
		},

		["DisableStancePages"] = {
			["Name"] = "Deaktiviere Haltungsseiten (Druiden & Schurken )",
		},

		["Enable"] = {
			["Name"] = "Aktiviere Aktionsleisten",
		},

		["EquipBorder"] = {
			["Name"] = "Angelegte Gegenstände mit Rahmen hervorheben",
		},

		["FadeRightBar"] = {
			["Name"] = "Rechte Aktionsleiste 1 verblassen",
		},

		["FadeRightBar2"] = {
			["Name"] = "Rechte Aktionsleiste 2 verblassen",
		},

		["HideHighlight"] = {
			["Name"] = "Deaktiviere Proc-Hervorhebung",
		},

		["Hotkey"] = {
			["Name"] = "Tastaturkürzel anzeigen",
		},

		["Macro"] = {
			["Name"] = "Makronamen anzeigen",
		},

		["MicroBar"] = {
			["Name"] = "Mikroleiste anzeigen",
		},

		["MicroBarMouseover"] = {
			["Name"] = "Mikroleiste ausblenden",
		},

		["OverrideWA"] = {
			["Name"] = "Verstecke Cooldowns auf WeakAuras",
		},

		["RightButtonSize"] = {
			["Name"] = "Größe der Knöpfe der rechten Aktionsleisten",
		},

		["StancePetSize"] = {
			["Name"] = "Größe der Begleiter- & Haltungsknöpfe",
		}
	},

	-- Announcements Local
	["Announcements"] = {
		["PullCountdown"] = {
			["Name"] = "Pull-Countdown ansagen (/pc #)",
		},

		["SaySapped"] = {
			["Name"] = "Ansagen wenn betäubt",
		},

		["Interrupt"] = {
			["Name"] = "Unterbrechungen ansagen",
		}
	},

	-- Automation Local
	["Automation"] = {
		["AutoBubbles"] = {
			["Name"] = "Nachrichtenblasen automatich aktivieren",
			["Desc"] = "Nachrichtenblasen abhängig von der Instanz-Art aktivieren. Werden in Schlachtzügen/Instanzen deaktiviert."
		},

		["AutoCollapse"] = {
			["Name"] = "Zielverfolgung automatisch zusammenklappen",
		},

		["AutoInvite"] = {
			["Name"] = "Einladungen von Freunden & Gildenmitgliedern annehmen",
		},

		["AutoDisenchant"] = {
			["Name"] = "Automatisch mit der 'ALT' Taste entzaubern",
		},

		["AutoQuest"] = {
			["Name"] = "Quests automatisch abgeben & annehmen",
		},

		["AutoRelease"] = {
			["Name"] = "In Schlachtfeldern & Arenen automatisch freilassen",
		},

		["AutoResurrect"] = {
			["Name"] = "Wiederbelebungsversuche automatisch annehmen",
		},

		["AutoResurrectThank"] = {
			["Name"] = "'Danke' sagen wenn wiederbelebt",
		},

		["AutoReward"] = {
			["Name"] = "Questbelohnungen automatisch auswählen",
		},

		["AutoTabBinder"] = {
			["Name"] = "Nur anderen Spieler mit der Tab-Taste ins Ziel nehmen",
		},

		["BuffThanks"] = {
			["Name"] = "Bei Spielern für Buffs bedanken (nur in der offenen Welt)",
		},

		["BlockMovies"] = {
			["Name"] = "Filme blockieren, die du bereits gesehen hast",
		},

		["DeclinePvPDuel"] = {
			["Name"] = "PvP Duelle ablehnen",
		},

		["WhisperInvite"] = {
			["Name"] = "Schlüsselwort für automatische Einladung (durch flüstern)",
		},
	},

	-- Bags Local
	["Inventory"] = {
		["AutoSell"] = {
			["Name"] = "Automatsicher Verkauf grauer Gegenstände",
			["Desc"] = "Bei Besuch eines Händlers automatisch alle grauen Gegenstände verkaufen.",
		},

		["BagBar"] = {
			["Name"] = "Taschenleiste zeigen",
		},

		["BagBarMouseover"] = {
			["Name"] = "Taschenleiste ausblenden",
		},

		["BagColumns"] = {
			["Name"] = "Anzahl von Spalten in den Taschen",
		},

		["BankColumns"] = {
			["Name"] = "Anzahl von Spalten in der Bank",
		},

		["ButtonSize"] = {
			["Name"] = "Größe der einzelnen Taschenknöpfe",
		},

		["ButtonSpace"] = {
			["Name"] = "Abstand der Taschenknöpfe zueinander",
		},

		["DetailedReport"] = {
			["Name"] = "Verkauf grauer Gegenstände - genauer Bericht",
			["Desc"] = "Zeigt einen genauen Bericht über jeden verkauften Gegenstand, wenn aktiviert.",
		},

		["Enable"] = {
			["Name"] = "Aktivieren",
			["Desc"] = "(De-)Aktivieren des Taschenmoduls.",
		},

		["ItemLevel"] = {
			["Name"] = "Gegenstandsstufe anzeigen",
			["Desc"] = "Zeigt die Gegenstandsstufe auf anlegbaren Gegenständen.",
		},

		["JunkIcon"] = {
			["Name"] = "Zeige Müll SymbolShow Junk Icon",
			["Desc"] = "Zeige Müll Symbol auf allen grauen Gegenständen die verkauft werden können.",
		},

		["PulseNewItem"] = {
			["Name"] = "Hebe neue Gegenstände durch einen glühenden Rahmen hervor.",
		},

		["AutoRepair"] = {
			["Name"] = "Ausrüstung automatisch reparieren",
		},
	},

	-- Auras Local
	["Auras"] = {
		["BuffSize"] = {
			["Name"] = "Größe für Stärkungszaubersymbole",
		},

		["BuffsPerRow"] = {
			["Name"] = "Stärkungszauber pro Reihe",
		},

		["DebuffSize"] = {
			["Name"] = "Schwächungszaubersymbolgröße",
		},

		["DebuffsPerRow"] = {
			["Name"] = "Schwächungszauber pro Reihe",
		},

		["Enable"] = {
			["Name"] = "Aktivieren",
		},

		["Reminder"] = {
			["Name"] = "Bufferinnerungen (Ruf/Intelligenz/Gift)",
		},

		["ReverseBuffs"] = {
			["Name"] = "Stärkungszauber erweitern nach Rechts",
		},

		["ReverseDebuffs"] = {
			["Name"] = "Schwächungszauber erweitern nach Links",
		},
	},

	-- Chat Local
	["Chat"] = {
		["Background"] = {
			["Name"] = "Chathintergrund anzeigen",
		},

		["BackgroundAlpha"] = {
			["Name"] = "Chat Hintergrund Alpha",
		},

		["BlockAddonAlert"] = {
			["Name"] = "AddOn Warnungen blockieren",
		},

		["ChatItemLevel"] = {
			["Name"] = "Zeige Gegenstandstufe in Chatfenstern",
		},

		["Enable"] = {
			["Name"] = "Chat aktivieren",
		},

		["EnableFilter"] = {
			["Name"] = "Chat-Filter aktivieren",
		},

		["Fading"] = {
			["Name"] = "Chat verblassen",
		},

		["FadingTimeFading"] = {
			["Name"] = "Dauer des Verblassens des Chats",
		},

		["FadingTimeVisible"] = {
			["Name"] = "Zeit, bevor der Chat verblassst wird",
		},

		["Height"] = {
			["Name"] = "Chat-Höhe",
		},

		["QuickJoin"] = {
			["Name"] = "Schnellbeitrittnachrichten",
			["Desc"] = "Zeige anklickbare Schnellbeitrittnachrichten im Chat an."
		},

		["ScrollByX"] = {
			["Name"] = "Scrollen um '#' Zeilen",
		},

		["ShortenChannelNames"] = {
			["Name"] = "Kanalnamen einkürzen",
		},

		["TabsMouseover"] = {
			["Name"] = "Chat-Tabs verblassen",
		},

		["WhisperSound"] = {
			["Name"] = "Geräusch bei Flüstern",
		},

		["Width"] = {
			["Name"] = "Chat-Breite",
		},

	},

	-- Databars Local
	["DataBars"] = {
		["Enable"] = {
			["Name"] = "Datenleisten aktivieren",
		},

		["ExperienceColor"] = {
			["Name"] = "Farbe der Erfahrungsleiste",
		},

		["Height"] = {
			["Name"] = "Datenleistenhöhe",
		},

		["HonorColor"] = {
			["Name"] = "Farbe der Ehrenleiste",
		},

		["MouseOver"] = {
			["Name"] = "Datenleisten verblassen",
		},

		["RestedColor"] = {
			["Name"] = "Farbe der Leiste wenn ausgeruht",
		},

		["Text"] = {
			["Name"] = "Text anzeigen",
		},

		["TrackHonor"] = {
			["Name"] = "Ehre verfolgen",
		},

		["Width"] = {
			["Name"] = "Datenleistenbreite",
		},

	},

	-- DataText Local
	["DataText"] = {
		["Battleground"] = {
			["Name"] = "Schlachtfeldinformationen",
		},

		["LocalTime"] = {
			["Name"] = "12 Stunden Zeitformat",
		},

		["System"] = {
			["Name"] = "Zeige FPS/MS an der Minikarte",
		},

		["Time"] = {
			["Name"] = "Zeige Uhrzeit an der Minikarte",
		},

		["Time24Hr"] = {
			["Name"] = "24 Stunden Zeitformat",
		},
	},

	-- Filger Local
	["Filger"] = {
		["BuffSize"] = {
			["Name"] = "Stärkungszaubergröße",
		},

		["CooldownSize"] = {
			["Name"] = "Cooldown Größe",
		},

		["DisableCD"] = {
			["Name"] = "Cooldown-Verfolgung deaktivieren",
		},

		["DisablePvP"] = {
			["Name"] = "PvP-Verfolgung deaktivieren",
		},

		["Expiration"] = {
			["Name"] = "Nach Auslaufzeit sortieren",
		},

		["Enable"] = {
			["Name"] = "Filger aktivieren",
		},

		["MaxTestIcon"] = {
			["Name"] = "Maximale Anzahgl von Testsymbolen",
		},

		["PvPSize"] = {
			["Name"] = "PvP-Symbolgröße",
		},

		["ShowTooltip"] = {
			["Name"] = "Zeige Tooltip, wenn Maus darüber",
		},

		["TestMode"] = {
			["Name"] = "Test-Modus",
		},
	},

	-- General Local
	["General"] = {
		["ColorTextures"] = {
			["Name"] = "Einfärben der 'meisten' KkthnxUI Ränder",
		},

		["DisableTutorialButtons"] = {
			["Name"] = "Tutorial-Knöpfe deaktivieren",
		},

		["ShowTooltip"] = {
			["Name"] = "Müllsammlung korrigieren",
		},

		["FontSize"] = {
			["Name"] = "Allgemeine Schriftgröße",
		},

		["HideErrors"] = {
			["Name"] = "Verstecke 'einige' UI Fehler",
		},

		["LagTolerance"] = {
			["Name"] = "Lagtoleranz automatisch einstellen",
		},

		["MoveBlizzardFrames"] = {
			["Name"] = "Blizzard-Fenster verschieben",
		},

		["ReplaceBlizzardFonts"] = {
			["Name"] = "Ersetze 'einige' Blizzard Schriftarten",
		},

		["TexturesColor"] = {
			["Name"] = "Texturenfarbe",
		},

		["Welcome"] = {
			["Name"] = "Zeige Willkommensnachricht",
		},

		["NumberPrefixStyle"] = {
			["Name"] = "Nummernpräfix-Stil für Einheitenfenster",
		},

		["PortraitStyle"] = {
			["Name"] = "Portraitstil für Einheitenfenster",
		},
	},

	-- Loot Local
	["Loot"] = {
		["AutoConfirm"] = {
			["Name"] = "Beutedialoge automatisch bestätigen",
		},

		["AutoGreed"] = {
			["Name"] = "Automatisch 'Gier' für grüne Gegenstände wählen",
		},

		["Enable"] = {
			["Name"] = "Beute-Modul aktivieren",
		},

		["FastLoot"] = {
			["Name"] = "Schnelleres Schnellplündern",
		},

		["GroupLoot"] = {
			["Name"] = "Gruppenbeute aktivieren",
		},
	},

	-- Minimap Local
	["Minimap"] = {
		["Calendar"] = {
			["Name"] = "Kalender anzeigen",
		},

		["Enable"] = {
			["Name"] = "Minikarte aktivieren",
		},

		["ResetZoom"] = {
			["Name"] = "Zoom der Minikarte zurücksetzen",
		},

		["ResetZoomTime"] = {
			["Name"] = "Zeit, nach der der Zoom zurückgesetzt wird",
		},

		["ShowRecycleBin"] = {
			["Name"] = "Zeige Papierkorb",
		},

		["Size"] = {
			["Name"] = "Größe der Minikarte",
		},
	},

	-- Miscellaneous Local
	["Misc"] = {
		["AFKCamera"] = {
			["Name"] = "AFK Kamera",
		},

		["AutoDismountStand"] = {
			["Name"] = "Automatisch aufstehen/absitzen",
			["Desc"] = "Lässst dich aufstehen/absitzen wenn du einen Zauber wirken oder etwas bekämpfen willst",
		},

		["ColorPicker"] = {
			["Name"] = "Verbesserter Farbwähler",
		},

		["EnhancedFriends"] = {
			["Name"] = "Verbesserte Farben (Freunde/Gilde +)",
		},

		["EnhancedMenu"] = {
			["Name"] = "Füge Gildeneinladung und mehr zu Kontextmenüs hinzu",
		},

		["GemEnchantInfo"] = {
			["Name"] = "Charakter/Betrachten Edelsteine-/Verzauberungsinfo",
		},

		["ImprovedQuestLog"] = {
			["Name"] = "Verbessere das Aussehen des Questlogs",
		},

		["ItemLevel"] = {
			["Name"] = "Zeige Charakter/Betrachten Gegenstandsstufe",
		},

		["KillingBlow"] = {
			["Name"] = "Zeige Informationen über deine Tötungsschläge/-treffer",
		},

		["PvPEmote"] = {
			["Name"] = "Automatisches Emote bei Tötungsschlag/-treffer",
		},

		["ShowHelmCloak"] = {
			["Name"] = "Zeige Knöpfe für Helm/Umhang im Charakterfenster",
		},

		["ShowWowHeadLinks"] = {
			["Name"] = "Zeige Wowhead Links über dem Questlog Fenster",
		},

		["SlotDurability"] = {
			["Name"] = "Zeige Slothaltbarkeit in %",
		},
	},

	-- Nameplates Local
	["Nameplates"] = {
		["GoodColor"] = {
			["Name"] = "Farbe für gute Bedrohung",
		},

		["NearColor"] = {
			["Name"] = "Farbe nahe der Bedrohungsgrenze",
		},

		["BadColor"] = {
			["Name"] = "Farbe für schlechte Bedrohung",
		},

		["SlotDurability"] = {
			["Name"] = "Farbe für die Bedrohung des Nebentanks",
		},

		["Clamp"] = {
			["Name"] = "In Sicht halten",
			["Desc"] = "Behält die Namensplaketten am oberen Rand in Sicht wenn diese außerhalb des Sichtfeldes geraten würden."
		},

		["ClassResource"] = {
			["Name"] = "Zeige Klassenressourcen",
		},

		["Combat"] = {
			["Name"] = "Zeige Namensplaketten im Kampf",
		},

		["Enable"] = {
			["Name"] = "Aktiviere Namensplaketten",
		},

		["HealthValue"] = {
			["Name"] = "Zeige Werte für Lebenspunkte",
		},

		["Height"] = {
			["Name"] = "Höhe der Namensplaketten",
		},

		["NonTargetAlpha"] = {
			["Name"] = "Alpha für Nichtziel Namensplaketten",
		},

		["OverlapH"] = {
			["Name"] = "Horizontale Überlappung",
		},

		["OverlapV"] = {
			["Name"] = "Veritkale Überlappung",
		},

		["QuestInfo"] = {
			["Name"] = "Zeige Questinformationssymbol",
		},

		["SelectedScale"] = {
			["Name"] = "Ausgewählte Skalierung für Namensplaketten",
		},

		["Smooth"] = {
			["Name"] = "Leisten flüssiger zeichnen",
		},

		["TankMode"] = {
			["Name"] = "Tank Modus",
		},

		["Threat"] = {
			["Name"] = "Bedrohung an Namensplakette",
		},

		["TrackAuras"] = {
			["Name"] = "Stärkungs-/Schwächungszauber verfolgen",
		},

		["Width"] = {
			["Name"] = "Breite der Namensplaketten",
		},

		["LevelFormat"] = {
			["Name"] = "Anzeigeformat für das Level",
		},

		["TargetArrowMark"] = {
			["Name"] = "Zeige Zielpfeile",
		},

		["HealthFormat"] = {
			["Name"] = "ANzeigeformat für Lebenspunkte",
		},

		["ShowEnemyCombat"] = {
			["Name"] = "Zeige feindliche im Kampf",
		},

		["ShowFriendlyCombat"] = {
			["Name"] = "Zeige feindliche im Kampf",
		},
	},

	-- Skins Local
	["Skins"] = {
		["ChatBubbles"] = {
			["Name"] = "Verändere das Aussehen von Nachrichtenblasen",
		},

		["DBM"] = {
			["Name"] = "Verändere das Aussehen von DeadlyBossMods",
		},

		["Details"] = {
			["Name"] = "Verändere das Aussehen von Details",
		},

		["Hekili"] = {
			["Name"] = "Verändere das Aussehen von Hekili",
		},

		["Skada"] = {
			["Name"] = "Verändere das Aussehen von Skada",
		},

		["TalkingHeadBackdrop"] = {
			["Name"] = "Zeige den Hintergrund des Redenden Kopfes",
		},

		["WeakAuras"] = {
			["Name"] = "Verändere das Aussehen von WeakAuras",
		},
	},

	-- Unitframe Local
	["Unitframe"] = {
		["AdditionalPower"] = {
			["Name"] = "Zeige Druidenmana (nur bei gewandelter Gestalt)",
		},

		["CastClassColor"] = {
			["Name"] = "Zauberleisten in Klassenfarbe",
		},

		["CastReactionColor"] = {
			["Name"] = "Zauberleisten in Reaktionsfarbe",
		},

		["CastbarLatency"] = {
			["Name"] = "Zeige Latenz in Zauberleiste",
		},

		["Castbars"] = {
			["Name"] = "Zauberleisten aktivieren",
		},

		["ClassResource"] = {
			["Name"] = "Klassenressourcen anzeigen",
		},

		["CombatFade"] = {
			["Name"] = "Einheitenfenster ausblenden (außerhalb des Kampfes)",
		},

		["CombatText"] = {
			["Name"] = "Zeige Meldungen des Kamptextes",
		},

		["DebuffHighlight"] = {
			["Name"] = "Zeige Hervorhebung bei Lebenspunkteschwächungszauber",
		},

		["DebuffsOnTop"] = {
			["Name"] = "Zeige Schwächungszauber des Ziels oberhalb",
		},

		["Enable"] = {
			["Name"] = "Einheitenfenster aktivieren",
		},

		["EnergyTick"] = {
			["Name"] = "Zeige Energie-Ticks (Druide / Schurke)",
		},

		["GlobalCooldown"] = {
			["Name"] = "Zeige die Globale Abklingzeit",
		},

		["HideTargetofTarget"] = {
			["Name"] = "Verstecke das Ziel des Zieles",
		},

		["OnlyShowPlayerDebuff"] = {
			["Name"] = "Nur eigene Schwächungszauber anzeigen",
		},

		["PlayerBuffs"] = {
			["Name"] = "Zeige Stärkungszauber am Spielerfenster",
		},

		["PlayerCastbarHeight"] = {
			["Name"] = "Höhe der Spielerzauberleiste",
		},

		["PlayerCastbarWidth"] = {
			["Name"] = "Breite der Spielerzauberleiste",
		},

		["PortraitTimers"] = {
			["Name"] = "Zauberzeiten im Portrait anzeigen",
		},

		["PvPIndicator"] = {
			["Name"] = "Zeige PvP-Symbole am Spieler/Ziel",
		},

		["ShowPlayerLevel"] = {
			["Name"] = "Zeige Spielerlevel am Spielerfenster",
		},

		["ShowPlayerName"] = {
			["Name"] = "Zeige Spielername am Spielerfenster",
		},

		["Smooth"] = {
			["Name"] = "Leisten flüssiger zeichnen",
		},

		["Swingbar"] = {
			["Name"] = "Unitframe Swingbar",
		},

		["SwingbarTimer"] = {
			["Name"] = "Unitframe Swingbar Timer",
		},

		["TargetCastbarHeight"] = {
			["Name"] = "Target Castbar Height",
		},

		["TargetCastbarWidth"] = {
			["Name"] = "Target Castbar Width",
		},

		["TotemBar"] = {
			["Name"] = "Show Totembar",
		},

		["PlayerHealthFormat"] = {
			["Name"] = "Player Health Format",
		},

		["PlayerPowerFormat"] = {
			["Name"] = "Player Power Format",
		},

		["TargetHealthFormat"] = {
			["Name"] = "Target Health Format",
		},

		["TargetPowerFormat"] = {
			["Name"] = "Target Power Format",
		},

		["TargetLevelFormat"] = {
			["Name"] = "Target Level Format",
		},
	},

	-- Arena Local
	["Arena"] = {
		["Castbars"] = {
			["Name"] = "Show Castbars",
		},

		["Enable"] = {
			["Name"] = "Enable Arena",
		},

		["Smooth"] = {
			["Name"] = "Smooth Bars",
		},
	},

	-- Boss Local
	["Boss"] = {
		["Castbars"] = {
			["Name"] = "Show Castbars",
		},

		["Enable"] = {
			["Name"] = "Enable Boss",
		},

		["Smooth"] = {
			["Name"] = "Smooth Bars",
		},
	},

	-- Party Local
	["Party"] = {
		["Castbars"] = {
			["Name"] = "Show Castbars",
		},

		["Enable"] = {
			["Name"] = "Enable Party",
		},

		["PortraitTimers"] = {
			["Name"] = "Portrait Spell Timers",
		},

		["ShowBuffs"] = {
			["Name"] = "Show Party Buffs",
		},

		["ShowPlayer"] = {
			["Name"] = "Show Player In Party",
		},

		["Smooth"] = {
			["Name"] = "Smooth Bars",
		},

		["TargetHighlight"] = {
			["Name"] = "Show Highlighted Target",
		},

		["PartyHealthFormat"] = {
			["Name"] = "Party Health Format",
		},

		["PartyPowerFormat"] = {
			["Name"] = "Party Power Format",
		},
	},

	-- QuestNotifier Local
	["QuestNotifier"] = {
		["Enable"] = {
			["Name"] = "Enable QuestNotifier",
		},

		["QuestProgress"] = {
			["Name"] = "Quest Progress",
			["Desc"] = "Alert on QuestProgress in chat. This can get spammy so do not piss off your groups!",
		},

		["OnlyCompleteRing"] = {
			["Name"] = "Only Complete Sound",
			["Desc"] = "Only play the complete sound at the end of completing the quest"
		},
	},

	-- Raidframe Local
	["Raid"] = {
		["AuraDebuffIconSize"] = {
			["Name"] = "Aura Debuff Icon Size",
		},

		["AuraWatch"] = {
			["Name"] = "Show AuraWatch Icons",
		},

		["AuraWatchIconSize"] = {
			["Name"] = "AuraWatch Icon Size",
		},

		["AuraWatchTexture"] = {
			["Name"] = "Show Color AuraWatch Texture",
		},

		["Enable"] = {
			["Name"] = "Enable Raidframes",
		},

		["Height"] = {
			["Name"] = "Raidframe Height",
		},

		["MainTankFrames"] = {
			["Name"] = "Show MainTank Frames",
		},

		["ManabarShow"] = {
			["Name"] = "Show Manabars",
		},

		["MaxUnitPerColumn"] = {
			["Name"] = "MaxUnit Per Column",
		},

		["RaidUtility"] = {
			["Name"] = "Show Raid Utility Frame",
		},

		["ShowGroupText"] = {
			["Name"] = "Show Player Group #",
		},

		["ShowNotHereTimer"] = {
			["Name"] = "Show Away/DND Status",
		},

		["ShowRolePrefix"] = {
			["Name"] = "Show Healer/Tank Roles",
		},

		["Smooth"] = {
			["Name"] = "Smooth Bars",
		},

		["TargetHighlight"] = {
			["Name"] = "Show Highlighted Target",
		},

		["Width"] = {
			["Name"] = "Raidframe Width",
		},

		["RaidLayout"] = {
			["Name"] = "Raid Layouts",
		},

		["GroupBy"] = {
			["Name"] = "Sort Raid Frames",
		},

		["HealthFormat"] = {
			["Name"] = "Health Format Display",
		},
	},

	-- Worldmap Local
	["WorldMap"] = {
		["AlphaWhenMoving"] = {
			["Name"] = "Alpha When Moving",
		},

		["Coordinates"] = {
			["Name"] = "Show Player/Mouse Coordinates",
		},

		["FadeWhenMoving"] = {
			["Name"] = "Fade Worldmap When Moving",
		},

		["SmallWorldMap"] = {
			["Name"] = "Show Smaller Worldmap",
		},

		["WorldMapPlus"] = {
			["Name"] = "Show Enhanced World Map Features",
		},
	},

	-- Tooltip Local
	["Tooltip"] = {
		["AzeriteArmor"] = {
			["Name"] = "Show AzeriteArmor Info",
		},

		["ClassColor"] = {
			["Name"] = "Quality Color Border",
		},

		["CombatHide"] = {
			["Name"] = "Hide Tooltip in Combat",
		},

		["Cursor"] = {
			["Name"] = "Follow Cursor",
		},

		["FactionIcon"] = {
			["Name"] = "Show Faction Icon",
		},

		["HideJunkGuild"] = {
			["Name"] = "Abbreviate Guild Names",
		},

		["HideRank"] = {
			["Name"] = "Hide Guild Rank",
		},

		["HideRealm"] = {
			["Name"] = "Show realm name by SHIFT",
		},

		["HideTitle"] = {
			["Name"] = "Hide Unit Title",
		},

		["Icons"] = {
			["Name"] = "Item Icons",
		},

		["ShowIDs"] = {
			["Name"] = "Show Tooltip IDs",
		},

		["LFDRole"] = {
			["Name"] = "Show Roles Assigned Icon",
		},

		["SpecLevelByShift"] = {
			["Name"] = "Show Spec/iLvl by SHIFT",
		},

		["TargetBy"] = {
			["Name"] = "Show Unit Targeted By",
		},
	},

	-- Fonts Local
	["UIFonts"] = {
		["ActionBarsFonts"] = {
			["Name"] = "ActionBar",
		},

		["AuraFonts"] = {
			["Name"] = "Auras",
		},

		["ChatFonts"] = {
			["Name"] = "Chat",
		},

		["DataBarsFonts"] = {
			["Name"] = "DataBars",
		},

		["DataTextFonts"] = {
			["Name"] = "DataTexts",
		},

		["GeneralFonts"] = {
			["Name"] = "General",
		},

		["InventoryFonts"] = {
			["Name"] = "Inventory",
		},

		["MinimapFonts"] = {
			["Name"] = "Minimap",
		},

		["NameplateFonts"] = {
			["Name"] = "Nameplate",
		},

		["QuestTrackerFonts"] = {
			["Name"] = "Quest Tracker",
		},

		["SkinFonts"] = {
			["Name"] = "Skins",
		},

		["TooltipFonts"] = {
			["Name"] = "Tooltip",
		},

		["UnitframeFonts"] = {
			["Name"] = "Unitframes",
		},
	},

	-- Textures Local
	["UITextures"] = {
		["DataBarsTexture"] = {
			["Name"] = "Data Bars",
		},

		["FilgerTextures"] = {
			["Name"] = "Filger",
		},

		["GeneralTextures"] = {
			["Name"] = "General",
		},

		["LootTextures"] = {
			["Name"] = "Loot",
		},

		["NameplateTextures"] = {
			["Name"] = "Nameplate",
		},

		["QuestTrackerTexture"] = {
			["Name"] = "Quest Tracker",
		},

		["SkinTextures"] = {
			["Name"] = "Skins",
		},

		["TooltipTextures"] = {
			["Name"] = "Tooltip",
		},

		["UnitframeTextures"] = {
			["Name"] = "Unitframes",
		},

		["HealPredictionTextures"] = {
			["Name"] = "Heal Prediction",
		},
	}
}