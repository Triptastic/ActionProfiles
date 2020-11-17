--------------------------------
-- Taste TMW Action ProfileUI --
--------------------------------
local TMW											= TMW 
local CNDT											= TMW.CNDT
local Env											= CNDT.Env

local A												= Action
local GetToggle										= A.GetToggle
local InterruptIsValid								= A.InterruptIsValid

local UnitCooldown									= A.UnitCooldown
local Unit											= A.Unit 
local Player										= A.Player 
local Pet											= A.Pet
local LoC											= A.LossOfControl
local MultiUnits									= A.MultiUnits
local EnemyTeam										= A.EnemyTeam
local FriendlyTeam									= A.FriendlyTeam
local TeamCache										= A.TeamCache
local InstanceInfo									= A.InstanceInfo
local TR                                            = Action.TasteRotation
local select, setmetatable							= select, setmetatable


A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI                                     = {    
    DateTime = "v4.2.8 (02.08.2020)",
	-- Class Settings
    [2] = {        
        [ACTION_CONST_WARRIOR_FURY] = {
            { -- [1]                            
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                    }, 
                    M = {},
                },  
                {
                    E = "Checkbox", 
                    DB = "TasteInterruptList",
                    DBV = true,
                    L = { 
                        enUS = "Use BFA Mythic+ & Raid\nsmart interrupt list", 
                        ruRU = "использование BFA Mythic+ & Raid\nумный список прерываний", 
                        frFR = "Liste d'interrupts intelligente\nBFA Mythic+ & Raid",
                    }, 
                    TT = { 
                        enUS = "If Enabled : Will force a special interrupt list containing all the BFA Mythic+ and Raid stuff WHEN YOU ARE IN MYTHIC+ OR RAID ZONE.\nYou can edit this list in the Interrupts tab\nand customize it as you want",
                        ruRU = "Если включено : Запустит специальный список прерываний, содержащий все BFA Mythic+ и Raid stuff КОГДА ВЫ НАХОДИТЕСЬ В МИФИЧЕСКОЙ + ИЛИ ЗОНЕ RAID.\nВы можете редактировать этот список на вкладке Прерывания\nи настраивай как хочешь",
                        frFR = "Si activé : Force une liste d'interruption spéciale contenant tous les éléments BFA Mythic + et Raid QUAND VOUS ETES EN MYTHIC+ OU EN RAID.\nVous pouvez modifier cette liste dans l'onglet Interruptions\net la personnaliser comme vous le souhaitez", 
                    }, 
                    M = {},
                },					
            }, 
            { -- [7] Spell Status Frame
                {
                    E = "Header",
                    L = {
                        ANY = " -- Spell Status Frame -- ",
                    },
                },
            },	
			{
                {
                    E         = "Button",
                    H         = 35,
                    OnClick = function(self, button, down)     
                        if button == "LeftButton" then 
							TR.ToggleStatusFrame() 
                        else                
                            Action.CraftMacro("Status Frame", [[/run Action.TasteRotation.ToggleStatusFrame()]], 1, true, true)   
                        end 
                    end, 
                    L = { 
                        ANY = "Status Frame\nMacro Creator",
                    }, 
                    TT = { 
                        enUS = "Click this button to create the special status frame macro.\nStatus Frame is a new windows that allow user to track blocked spells during fight. So you don't have to check your chat anymore.", 
                        ruRU = "Нажмите эту кнопку, чтобы создать специальный макрос статуса.\nStatus Frame - это новые окна, которые позволяют пользователю отслеживать заблокированные заклинания во время боя. Так что вам больше не нужно проверять свой чат.",  
                        frFR = "Cliquez sur ce bouton pour créer la macro de cadre d'état spécial.\nLe cadre d'état est une nouvelle fenêtre qui permet à l'utilisateur de suivre les sorts bloqués pendant le combat. Vous n'avez donc plus besoin de vérifier votre chat.", 
                    },                           
                },
                {
                    E = "Checkbox", 
                    DB = "ChangelogOnStartup",
                    DBV = true,
                    L = { 
                        enUS = "Changelog On Startup", 
                        ruRU = "Журнал изменений при запуске", 
                        frFR = "Journal des modifications au démarrage",
                    }, 
                    TT = { 
                        enUS = "Will show latest changelog of the current rotation when you enter in game.\nDisable this option to block the popup when you enter the game.", 
                        ruRU = "При входе в игру будет отображаться последний список изменений текущего вращения.\nОтключить эту опцию, чтобы заблокировать всплывающее окно при входе в игру.", 
                        frFR = "Affiche le dernier journal des modifications de la rotation actuelle lorsque vous entrez dans le jeu.\nDésactivez cette option pour bloquer la fenêtre contextuelle lorsque vous entrez dans le jeu..", 
                    }, 
                    M = {},
                }, 
			},	
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Trinkets -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "TrinketsAoE",
                    DBV = true,
                    L = { 
                        enUS = "Trinkets\nAoE only", 
                        ruRU = "Trinkets\nAoE only",  
                        frFR = "Trinkets\nAoE only",  
                    }, 
                    TT = { 
                        enUS = "Enable this to option to trinkets for AoE usage ONLY.", 
                        ruRU = "Enable this to option to trinkets for AoE usage ONLY.", 
                        frFR = "Enable this to option to trinkets for AoE usage ONLY.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 30,                            
                    DB = "TrinketsMinTTD",
                    DBV = 10, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min TTD",
                    },
                    TT = { 
                        enUS = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        ruRU = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        frFR = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                    },					
                    M = {},
                },
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 10,                            
                    DB = "TrinketsMinUnits",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min Units",
                    },
                    TT = { 
                        enUS = "Minimum number of units in range to activate Trinkets.", 
                        ruRU = "Minimum number of units in range to activate Trinkets.", 
                        frFR = "Minimum number of units in range to activate Trinkets.",  
                    },					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,                            
                    DB = "TrinketsUnitsRange",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Max AoE range",
                    },
                    TT = { 
                        enUS = "Maximum range for units detection to automatically activate AoE rotation.", 
                        ruRU = "Maximum range for units detection to automatically activate AoE rotation.", 
                        frFR = "Maximum range for units detection to automatically activate AoE rotation.",  
                    },					
                    M = {},
                },
			},
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- AoE -- ",
                    },
                },
            },
			{
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 5,                            
                    DB = "MinAoETargets",
                    DBV = 2, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min AoE units",
                    },
                    TT = { 
                        enUS = "Minimum units in range to automatically activate AoE rotation.", 
                        ruRU = "Minimum units in range to automatically activate AoE rotation.", 
                        frFR = "Minimum units in range to automatically activate AoE rotation.", 
                    },					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,                            
                    DB = "MaxAoERange",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Max AoE range",
                    },
                    TT = { 
                        enUS = "Maximum range for units detection to automatically activate AoE rotation.", 
                        ruRU = "Maximum range for units detection to automatically activate AoE rotation.", 
                        frFR = "Maximum range for units detection to automatically activate AoE rotation.",  
                    },					
                    M = {},
                },
			},
            -- Blood of the enemy
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(298277) .. " -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "BloodoftheEnemySyncAoE",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(298277) .. " AoE sync", 
                        ruRU = A.GetSpellInfo(298277) .. " AoE sync",  
                        frFR = A.GetSpellInfo(298277) .. " AoE sync", 
                    }, 
                    TT = { 
                        enUS = "Enable this to option to keep " .. A.GetSpellInfo(298277) .. " for maximum AoE damage.", 
                        ruRU = "Enable this to option to keep " .. A.GetSpellInfo(298277) .. " for maximum AoE damage.", 
                        frFR = "Enable this to option to keep " .. A.GetSpellInfo(298277) .. " for maximum AoE damage.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 20,                            
                    DB = "BloodoftheEnemyAoETTD",
                    DBV = 10, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(298277) .. " AoE TTD",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 8,                            
                    DB = "BloodoftheEnemyUnits",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(298277) .. " AoE units",
                    }, 
                    TT = { 
                        enUS = "Minimum active units around before using " .. A.GetSpellInfo(298277) .. ".", 
                        ruRU = "Minimum active units around before using " .. A.GetSpellInfo(298277) .. ".", 
                        frFR = "Minimum active units around before using " .. A.GetSpellInfo(298277) .. ".", 
                    },
                    M = {},
                },
			},
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Utilities -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
               --Charge {              
					{
						E = "Checkbox", 
						DB = "UseCharge",
						DBV = true,
						L = { 
							enUS = "Auto " .. A.GetSpellInfo(100), 
							ruRU = "Авто " .. A.GetSpellInfo(100), 
							frFR = "Auto " .. A.GetSpellInfo(100), 
						}, 
						TT = { 
							enUS = "Automatically use " .. A.GetSpellInfo(100), 
							ruRU = "Автоматически использовать " .. A.GetSpellInfo(100), 
							frFR = "Utiliser automatiquement " .. A.GetSpellInfo(100), 
						}, 
						M = {},
					},
					{
						E = "Slider",                                                     
						MIN = 1, 
						MAX = 7,                            
						DB = "ChargeTime",
						DBV = 3, -- Set healthpercentage @60% life. 
						ONOFF = true,
						L = { 
							enUS = A.GetSpellInfo(100) .. " if moving for",
							ruRU = A.GetSpellInfo(100) .. " если переехать",
							frFR = A.GetSpellInfo(100) .. " si vous bougez pendant",
						},
						TT = { 
							enUS = "If " .. A.GetSpellInfo(100) .. " is talented and ready, will use it if moving for set value.", 
							ruRU = "Если " .. A.GetSpellInfo(100) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
							frFR = "Si " .. A.GetSpellInfo(100) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
						}, 
						M = {},
					},	
            },	
			-- Heroic Leap
            {              
					{
						E = "Checkbox", 
						DB = "UseHeroicLeap",
						DBV = true,
						L = { 
							enUS = "Auto " .. A.GetSpellInfo(6544), 
							ruRU = "Авто " .. A.GetSpellInfo(6544), 
							frFR = "Auto " .. A.GetSpellInfo(6544), 
						}, 
						TT = { 
							enUS = "Automatically use " .. A.GetSpellInfo(6544), 
							ruRU = "Автоматически использовать " .. A.GetSpellInfo(6544), 
							frFR = "Utiliser automatiquement " .. A.GetSpellInfo(6544), 
						}, 
						M = {},
					},
					{
						E = "Slider",                                                     
						MIN = 1, 
						MAX = 7,                            
						DB = "HeroicLeapTime",
						DBV = 3, -- Set healthpercentage @60% life. 
						ONOFF = true,
						L = { 
							enUS = A.GetSpellInfo(6544) .. " if moving for",
							ruRU = A.GetSpellInfo(6544) .. " если переехать",
							frFR = A.GetSpellInfo(6544) .. " si vous bougez pendant",
						},
						TT = { 
							enUS = "If " .. A.GetSpellInfo(6544) .. " is talented and ready, will use it if moving for set value.", 
							ruRU = "Если " .. A.GetSpellInfo(6544) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
							frFR = "Si " .. A.GetSpellInfo(6544) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
						}, 
						M = {},
					},	
                --},					
            },
            { -- [2]
                {
                    E = "Header",
                    L = {
                        enUS = " -- Defensives -- ",
                    },
                },
            }, 
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "VictoryRush",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(34428) .. " (%)",
                    }, 
                    M = {},
                },   
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "RallyingCry",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(97462) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "EnragedRegeneration",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(184364) .. " (%)",
                    }, 
                    M = {},
                },
            }, 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Dummy DPS Test -- ",
                    },
                },
            },
            { -- [3] 3rd Row 					
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 10,                            
                    DB = "DummyTime",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "DPS Testing Time",
                    },
                    TT = { 
                        enUS = "Set the desired time for test in minutes.\nWill show a notification icon when time is expired.\nMin: 1 / Max: 10.", 
                        ruRU = "Установите желаемое время для теста в минутах.\nПо истечении времени будет отображаться значок уведомления.\nMin: 1 / Max: 10.",  
                        frFR = "Définissez la durée souhaitée pour le test en minutes.\nAffiche une icône de notification lorsque le temps est écoulé.\nMin: 1 / Max: 10.", 
                    }, 					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 15,                            
                    DB = "DummyStopDelay",
                    DBV = 10, -- 2sec
                    ONOFF = true,
                    L = { 
                        ANY = "Stop Delay",
                    },
                    TT = { 
                        enUS = "After the dummy test is concluded, how much time should we stop the rotation. (In seconds)\nThis value is mainly used as a protection when you are out of combat to avoid auto attack.\nDefault value : 10 seconds.", 
                        ruRU = "После того, как фиктивный тест закончен, сколько времени мы должны остановить вращение. (В секундах)\nЭто значение в основном используется в качестве защиты, когда вы находитесь вне боя, чтобы избежать автоматической атаки.\nЗначение по умолчанию: 10 секунд.", 
                        frFR = "Une fois le test fictif terminé, combien de temps devons-nous arrêter la rotation. (En secondes)\nCette valeur est principalement utilisée comme protection lorsque vous êtes hors de combat pour éviter l'attaque automatique.\nValeur par défaut: 10 secondes.", 
                    }, 					
                    M = {},
                },
			},
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Overlay -- ",
                    },
                },
            },
            { -- [2] 2nd Row
                {
                    E = "Checkbox", 
                    DB = "UseAnnouncer",
                    DBV = true,
                    L = { 
                        enUS = "Use Smart Announcer", 
                        ruRU = "Use Smart Announcer",  
                        frFR = "Use Smart Announcer", 
                    }, 
                    TT = { 
                        enUS = "Will make the rotation to announce importants informations.\nUseful to get fast and clear status of what the rotation is doing and why it is doing.\nFor example :\n- Blind on enemy healer to interrupt an incoming heal.\n- Vanish to survive incoming damage.", 
                        ruRU = "Will make the rotation to announce importants informations.\nUseful to get fast and clear status of what the rotation is doing and why it is doing.\nFor example :\n- Blind on enemy healer to interrupt an incoming heal.\n- Vanish to survive incoming damage.", 
                        frFR = "Will make the rotation to announce importants informations.\nUseful to get fast and clear status of what the rotation is doing and why it is doing.\nFor example :\n- Blind on enemy healer to interrupt an incoming heal.\n- Vanish to survive incoming damage.", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AnnouncerInCombatOnly",
                    DBV = true,
                    L = { 
                        enUS = "Only use in combat", 
                        ruRU = "Only use in combat", 
                        frFR = "Only use in combat",
                    }, 
                    TT = { 
                        enUS = "Will only use Smart Announcer while in combat.\nDisable it will make Smart Announcer work with precombat actions if available.\nFor example : Sap out of combat, pre potion.", 
                        ruRU = "Will only use Smart Announcer while in combat.\nDisable it will make Smart Announcer work out of combat if precombat actions are available.\nFor example : Sap out of combat, pre potion.",
                        frFR = "Will only use Smart Announcer while in combat.\nDisable it will make Smart Announcer work out of combat if precombat actions are available.\nFor example : Sap out of combat, pre potion.",  
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "AnnouncerDelay",
                    DBV = 2, -- 2sec
                    ONOFF = true,
                    L = { 
                        ANY = "Alerts delay (sec)",
                    },
                    TT = { 
                        enUS = "Will force a specific delay before the alerts fade.\nDefault value : 2 seconds.", 
                        ruRU = "Will force a specific delay before the alerts fade.\nDefault value : 2 seconds.", 
                        frFR = "Will force a specific delay before the alerts fade.\nDefault value : 2 seconds.", 
                    }, 					
                    M = {},
                },				
            },	
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Interrupts Settings -- ",
                    },
                },
            },
            { -- [3] 3rd Row 					
                {
                    E = "Checkbox", 
                    DB = "SmartStormbolt",
                    DBV = true,
                    L = { 
                        enUS = "Smart " .. A.GetSpellInfo(107570), 
                        ruRU = "Smart " .. A.GetSpellInfo(107570), 
                        frFR = "Smart " .. A.GetSpellInfo(107570), 
                    }, 
                    TT = { 
                        enUS = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        ruRU = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        frFR = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.",   
                    }, 
                    M = {},
                },				
			},
            { -- [6]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Party -- ",
                    },
                },
            }, 
            { -- [7]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@party1", value = 1 },
                        { text = "@party2", value = 2 },
                    },
                    MULT = true,
                    DB = "PartyUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                    }, 
                    L = { 
                        ANY = "Party Units",
                    }, 
                    TT = { 
                        enUS = "Enable/Disable relative party passive rotation", 
                    }, 
                    M = {},
                },            
            },            
            { -- [8]
                {
                    E = "Header",
                    L = {
                        ANY = " -- PvP -- ",
                    },
                },
            }, 
            { -- [9]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Only Heal", value = "Heal" },
                        { text = "Only PvP", value = "PvP" },
                        { text = "BOTH", value = "BOTH" },
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "StormboltPvP",
                    DBV = "BOTH",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(107570),
                    }, 
                    TT = { 
                        enUS = "@arena1-3 interrupt PvP list from 'Interrupts' tab by Stormbolt\nMore custom config you can find in group by open /tmw", 
                    }, 
                    M = {},
                },
            }, 
            { -- [10]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "DisarmPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(236077),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@arena1", value = 1 },
                        { text = "@arena2", value = 2 },
                        { text = "@arena3", value = 3 },
                        { text = "primary", value = 4 },
                    },
                    MULT = true,
                    DB = "DisarmPvPunits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(236077) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        }, 

		[ACTION_CONST_WARRIOR_ARMS] = {
            { -- [1]                            
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "TasteInterruptList",
                    DBV = true,
                    L = { 
                        enUS = "Use BFA Mythic+ & Raid\nsmart interrupt list", 
                        ruRU = "использование BFA Mythic+ & Raid\nумный список прерываний", 
                        frFR = "Liste d'interrupts intelligente\nBFA Mythic+ & Raid",
                    }, 
                    TT = { 
                        enUS = "If Enabled : Will force a special interrupt list containing all the BFA Mythic+ and Raid stuff WHEN YOU ARE IN MYTHIC+ OR RAID ZONE.\nYou can edit this list in the Interrupts tab\nand customize it as you want",
                        ruRU = "Если включено : Запустит специальный список прерываний, содержащий все BFA Mythic+ и Raid stuff КОГДА ВЫ НАХОДИТЕСЬ В МИФИЧЕСКОЙ + ИЛИ ЗОНЕ RAID.\nВы можете редактировать этот список на вкладке Прерывания\nи настраивай как хочешь",
                        frFR = "Si activé : Force une liste d'interruption spéciale contenant tous les éléments BFA Mythic + et Raid QUAND VOUS ETES EN MYTHIC+ OU EN RAID.\nVous pouvez modifier cette liste dans l'onglet Interruptions\net la personnaliser comme vous le souhaitez", 
                    }, 
                    M = {},
                },					
            }, 
            { -- [7] Spell Status Frame
                {
                    E = "Header",
                    L = {
                        ANY = " -- Spell Status Frame -- ",
                    },
                },
            },	
			{
                {
                    E         = "Button",
                    H         = 35,
                    OnClick = function(self, button, down)     
                        if button == "LeftButton" then 
							TR.ToggleStatusFrame() 
                        else                
                            Action.CraftMacro("Status Frame", [[/run Action.TasteRotation.ToggleStatusFrame()]], 1, true, true)   
                        end 
                    end, 
                    L = { 
                        ANY = "Status Frame\nMacro Creator",
                    }, 
                    TT = { 
                        enUS = "Click this button to create the special status frame macro.\nStatus Frame is a new windows that allow user to track blocked spells during fight. So you don't have to check your chat anymore.", 
                        ruRU = "Нажмите эту кнопку, чтобы создать специальный макрос статуса.\nStatus Frame - это новые окна, которые позволяют пользователю отслеживать заблокированные заклинания во время боя. Так что вам больше не нужно проверять свой чат.",  
                        frFR = "Cliquez sur ce bouton pour créer la macro de cadre d'état spécial.\nLe cadre d'état est une nouvelle fenêtre qui permet à l'utilisateur de suivre les sorts bloqués pendant le combat. Vous n'avez donc plus besoin de vérifier votre chat.", 
                    },                           
                },
                {
                    E = "Checkbox", 
                    DB = "ChangelogOnStartup",
                    DBV = true,
                    L = { 
                        enUS = "Changelog On Startup", 
                        ruRU = "Журнал изменений при запуске", 
                        frFR = "Journal des modifications au démarrage",
                    }, 
                    TT = { 
                        enUS = "Will show latest changelog of the current rotation when you enter in game.\nDisable this option to block the popup when you enter the game.", 
                        ruRU = "При входе в игру будет отображаться последний список изменений текущего вращения.\nОтключить эту опцию, чтобы заблокировать всплывающее окно при входе в игру.", 
                        frFR = "Affiche le dernier journal des modifications de la rotation actuelle lorsque vous entrez dans le jeu.\nDésactivez cette option pour bloquer la fenêtre contextuelle lorsque vous entrez dans le jeu..", 
                    }, 
                    M = {},
                }, 
			},	
           { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Trinkets -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "TrinketsAoE",
                    DBV = true,
                    L = { 
                        enUS = "Trinkets\nAoE only", 
                        ruRU = "Trinkets\nAoE only",  
                        frFR = "Trinkets\nAoE only",  
                    }, 
                    TT = { 
                        enUS = "Enable this to option to trinkets for AoE usage ONLY.", 
                        ruRU = "Enable this to option to trinkets for AoE usage ONLY.", 
                        frFR = "Enable this to option to trinkets for AoE usage ONLY.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 30,                            
                    DB = "TrinketsMinTTD",
                    DBV = 10, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min TTD",
                    },
                    TT = { 
                        enUS = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        ruRU = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        frFR = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                    },					
                    M = {},
                },
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 10,                            
                    DB = "TrinketsMinUnits",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min Units",
                    },
                    TT = { 
                        enUS = "Minimum number of units in range to activate Trinkets.", 
                        ruRU = "Minimum number of units in range to activate Trinkets.", 
                        frFR = "Minimum number of units in range to activate Trinkets.",  
                    },					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,                            
                    DB = "TrinketsUnitsRange",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Max AoE range",
                    },
                    TT = { 
                        enUS = "Maximum range for units detection to automatically activate trinkets.", 
                        ruRU = "Maximum range for units detection to automatically activate trinkets.", 
                        frFR = "Maximum range for units detection to automatically activate trinkets.",  
                    },					
                    M = {},
                },
			},
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Utilities -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
               --Charge {              
					{
						E = "Checkbox", 
						DB = "UseCharge",
						DBV = true,
						L = { 
							enUS = "Auto " .. A.GetSpellInfo(100), 
							ruRU = "Авто " .. A.GetSpellInfo(100), 
							frFR = "Auto " .. A.GetSpellInfo(100), 
						}, 
						TT = { 
							enUS = "Automatically use " .. A.GetSpellInfo(100), 
							ruRU = "Автоматически использовать " .. A.GetSpellInfo(100), 
							frFR = "Utiliser automatiquement " .. A.GetSpellInfo(100), 
						}, 
						M = {},
					},
					{
						E = "Slider",                                                     
						MIN = 1, 
						MAX = 7,                            
						DB = "ChargeTime",
						DBV = 3, -- Set healthpercentage @60% life. 
						ONOFF = true,
						L = { 
							enUS = A.GetSpellInfo(100) .. " if moving for",
							ruRU = A.GetSpellInfo(100) .. " если переехать",
							frFR = A.GetSpellInfo(100) .. " si vous bougez pendant",
						},
						TT = { 
							enUS = "If " .. A.GetSpellInfo(100) .. " is talented and ready, will use it if moving for set value.", 
							ruRU = "Если " .. A.GetSpellInfo(100) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
							frFR = "Si " .. A.GetSpellInfo(100) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
						}, 
						M = {},
					},	
            },	
			-- Heroic Leap
            {              
					{
						E = "Checkbox", 
						DB = "UseHeroicLeap",
						DBV = true,
						L = { 
							enUS = "Auto " .. A.GetSpellInfo(6544), 
							ruRU = "Авто " .. A.GetSpellInfo(6544), 
							frFR = "Auto " .. A.GetSpellInfo(6544), 
						}, 
						TT = { 
							enUS = "Automatically use " .. A.GetSpellInfo(6544), 
							ruRU = "Автоматически использовать " .. A.GetSpellInfo(6544), 
							frFR = "Utiliser automatiquement " .. A.GetSpellInfo(6544), 
						}, 
						M = {},
					},
					{
						E = "Slider",                                                     
						MIN = 1, 
						MAX = 7,                            
						DB = "HeroicLeapTime",
						DBV = 3, -- Set healthpercentage @60% life. 
						ONOFF = true,
						L = { 
							enUS = A.GetSpellInfo(6544) .. " if moving for",
							ruRU = A.GetSpellInfo(6544) .. " если переехать",
							frFR = A.GetSpellInfo(6544) .. " si vous bougez pendant",
						},
						TT = { 
							enUS = "If " .. A.GetSpellInfo(6544) .. " is talented and ready, will use it if moving for set value.", 
							ruRU = "Если " .. A.GetSpellInfo(6544) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
							frFR = "Si " .. A.GetSpellInfo(6544) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
						}, 
						M = {},
					},	
                --},					
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Interrupts Settings -- ",
                    },
                },
            },
            { -- [3] 3rd Row 					
                {
                    E = "Checkbox", 
                    DB = "SmartStormbolt",
                    DBV = true,
                    L = { 
                        enUS = "Smart " .. A.GetSpellInfo(107570), 
                        ruRU = "Smart " .. A.GetSpellInfo(107570), 
                        frFR = "Smart " .. A.GetSpellInfo(107570), 
                    }, 
                    TT = { 
                        enUS = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        ruRU = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        frFR = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.",   
                    }, 
                    M = {},
                },				
			},
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Dummy DPS Test -- ",
                    },
                },
            },
            { -- [3] 3rd Row 					
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 10,                            
                    DB = "DummyTime",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "DPS Testing Time",
                    },
                    TT = { 
                        enUS = "Set the desired time for test in minutes.\nWill show a notification icon when time is expired.\nMin: 1 / Max: 10.", 
                        ruRU = "Установите желаемое время для теста в минутах.\nПо истечении времени будет отображаться значок уведомления.\nMin: 1 / Max: 10.",  
                        frFR = "Définissez la durée souhaitée pour le test en minutes.\nAffiche une icône de notification lorsque le temps est écoulé.\nMin: 1 / Max: 10.", 
                    }, 					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 15,                            
                    DB = "DummyStopDelay",
                    DBV = 10, -- 2sec
                    ONOFF = true,
                    L = { 
                        ANY = "Stop Delay",
                    },
                    TT = { 
                        enUS = "After the dummy test is concluded, how much time should we stop the rotation. (In seconds)\nThis value is mainly used as a protection when you are out of combat to avoid auto attack.\nDefault value : 10 seconds.", 
                        ruRU = "После того, как фиктивный тест закончен, сколько времени мы должны остановить вращение. (В секундах)\nЭто значение в основном используется в качестве защиты, когда вы находитесь вне боя, чтобы избежать автоматической атаки.\nЗначение по умолчанию: 10 секунд.", 
                        frFR = "Une fois le test fictif terminé, combien de temps devons-nous arrêter la rotation. (En secondes)\nCette valeur est principalement utilisée comme protection lorsque vous êtes hors de combat pour éviter l'attaque automatique.\nValeur par défaut: 10 secondes.", 
                    }, 					
                    M = {},
                },
			},	
            { -- [2]
                {
                    E = "Header",
                    L = {
                        enUS = " -- Self Defensives -- ",
                    },
                },
            }, 
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "VictoryRush",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(34428) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ImpendingVictory",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(202168) .. " (%)",
                    }, 
                    M = {},
                },
            }, 
            { -- [4]    
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "RallyingCry",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(97462) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DiebytheSword",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(118038) .. " (%)",
                    }, 
                    M = {},
                },
            }, 
            { -- [5]    

                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "TrinketDefensive",
                    DBV = 50,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetLocalization()["TAB"][1]["TRINKET"] .. "\n(Self HP %)",
                    }, 
                    M = {},
                },
            }, 
            { -- [6]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Party -- ",
                    },
                },
            }, 
            { -- [7]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@party1", value = 1 },
                        { text = "@party2", value = 2 },
                    },
                    MULT = true,
                    DB = "PartyUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                    }, 
                    L = { 
                        ANY = "Party Units",
                    }, 
                    TT = { 
                        enUS = "Enable/Disable relative party passive rotation", 
                    }, 
                    M = {},
                },            
            },            
            { -- [8]
                {
                    E = "Header",
                    L = {
                        ANY = " -- PvP -- ",
                    },
                },
            }, 
            { -- [9]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Only Heal", value = "Heal" },
                        { text = "Only PvP", value = "PvP" },
                        { text = "BOTH", value = "BOTH" },
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "StormboltPvP",
                    DBV = "BOTH",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(107570),
                    }, 
                    TT = { 
                        enUS = "@arena1-3 interrupt PvP list from 'Interrupts' tab by Stormbolt\nMore custom config you can find in group by open /tmw", 
                    }, 
                    M = {},
                },
            }, 
            { -- [10]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "DisarmPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(236077),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@arena1", value = 1 },
                        { text = "@arena2", value = 2 },
                        { text = "@arena3", value = 3 },
                        { text = "primary", value = 4 },
                    },
                    MULT = true,
                    DB = "DisarmPvPunits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(236077) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_WARRIOR_PROTECTION] = { 
        LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },		
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },			
            { -- [1] 1st Row                           
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use @mouseover", 
                        ruRU = "Использовать @mouseover", 
                        frFR = "Utiliser les fonctions @mouseover",
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                        frFR = "Activera les actions via @mouseover\n Exemple: Ressusciter, Soigner",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use AoE", 
                        ruRU = "Использовать AoE", 
                        frFR = "Utiliser l'AoE"
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {},
                }, 
				                {
                    E = "Checkbox", 
                    DB = "TasteInterruptList",
                    DBV = true,
                    L = { 
                        enUS = "Use BFA Mythic+ & Raid\nsmart interrupt list", 
                        ruRU = "использование BFA Mythic+ & Raid\nумный список прерываний", 
                        frFR = "Liste d'interruption spéciale\nBFA Mythic+ & Raid",
                    }, 
                    TT = { 
                        enUS = "If Enabled : Will force a special interrupt list containing all the BFA Mythic+ and Raid stuff WHEN YOU ARE IN MYTHIC+ OR RAID ZONE.\nYou can edit this list in the Interrupts tab\nand customize it as you want",
                        ruRU = "Если включено : Запустит специальный список прерываний, содержащий все BFA Mythic+ и Raid stuff КОГДА ВЫ НАХОДИТЕСЬ В МИФИЧЕСКОЙ + ИЛИ ЗОНЕ RAID.\nВы можете редактировать этот список на вкладке Прерывания\nи настраивай как хочешь",
                        frFR = "Si activé : Force une liste d'interruption spéciale contenant tous les éléments BFA Mythic + et Raid QUAND VOUS ETES EN MYTHIC+ OU EN RAID.\nVous pouvez modifier cette liste dans l'onglet Interruptions\net la personnaliser comme vous le souhaitez", 
                    }, 
                    M = {},
                },	
            }, 
            { -- [7] Spell Status Frame
                {
                    E = "Header",
                    L = {
                        ANY = " -- Spell Status Frame -- ",
                    },
                },
            },	
			{
                {
                    E         = "Button",
                    H         = 35,
                    OnClick = function(self, button, down)     
                        if button == "LeftButton" then 
							TR.ToggleStatusFrame() 
                        else                
                            Action.CraftMacro("Status Frame", [[/run Action.TasteRotation.ToggleStatusFrame()]], 1, true, true)   
                        end 
                    end, 
                    L = { 
                        ANY = "Status Frame\nMacro Creator",
                    }, 
                    TT = { 
                        enUS = "Click this button to create the special status frame macro.\nStatus Frame is a new windows that allow user to track blocked spells during fight. So you don't have to check your chat anymore.", 
                        ruRU = "Нажмите эту кнопку, чтобы создать специальный макрос статуса.\nStatus Frame - это новые окна, которые позволяют пользователю отслеживать заблокированные заклинания во время боя. Так что вам больше не нужно проверять свой чат.",  
                        frFR = "Cliquez sur ce bouton pour créer la macro de cadre d'état spécial.\nLe cadre d'état est une nouvelle fenêtre qui permet à l'utilisateur de suivre les sorts bloqués pendant le combat. Vous n'avez donc plus besoin de vérifier votre chat.", 
                    },                           
                },
                {
                    E = "Checkbox", 
                    DB = "ChangelogOnStartup",
                    DBV = true,
                    L = { 
                        enUS = "Changelog On Startup", 
                        ruRU = "Журнал изменений при запуске", 
                        frFR = "Journal des modifications au démarrage",
                    }, 
                    TT = { 
                        enUS = "Will show latest changelog of the current rotation when you enter in game.\nDisable this option to block the popup when you enter the game.", 
                        ruRU = "При входе в игру будет отображаться последний список изменений текущего вращения.\nОтключить эту опцию, чтобы заблокировать всплывающее окно при входе в игру.", 
                        frFR = "Affiche le dernier journal des modifications de la rotation actuelle lorsque vous entrez dans le jeu.\nDésactivez cette option pour bloquer la fenêtre contextuelle lorsque vous entrez dans le jeu..", 
                    }, 
                    M = {},
                }, 
			},	
            { -- [1] 1st Row                           
                {
                    E = "Checkbox", 
                    DB = "AvatarOnCD",
                    DBV = false,
                    L = { 
                        enUS = "Use Avatar on cooldown", 
                        ruRU = "Use Avatar on cooldown", 
                        frFR = "Use Avatar on cooldown", 
                    }, 
                    TT = { 
                        enUS = "Use Avatar on cooldown", 
                        ruRU = "Use Avatar on cooldown", 
                        frFR = "Use Avatar on cooldown", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "DSOnCD",
                    DBV = false,
                    L = { 
                        enUS = "Use Demoralizing Shout on cooldown", 
                        ruRU = "Use Demoralizing Shout on cooldown",  
                        frFR = "Use Demoralizing Shout on cooldown", 
                    }, 
                    TT = { 
                        enUS = "Use Demoralizing Shout on cooldown", 
                        ruRU = "Use Demoralizing Shout on cooldown",  
                        frFR = "Use Demoralizing Shout on cooldown", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "ReflectThingFromBeyond",
                    DBV = true,
                    L = { 
                        enUS = "Auto Reflect\nThing from Beyond", 
                        ruRU = "Auto Reflect\nThing from Beyond", 
                        frFR = "Auto Reflect\nThing from Beyond",  
                    }, 
                    M = {},
                },				
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AbyssalHealingPotionHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(301308) .. " (%)",
                    }, 
                    M = {},
                },
            }, 
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Auto Taunt -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
    			{
                    E = "Checkbox", 
                    DB = "AutoTaunt",
                    DBV = true,
                    L = { 
                        enUS = "Automatic Taunt", 
                        ruRU = "Автоматическая Насмешка", 
                        frFR = "Raillerie automatique",
                    }, 
                    TT = { 
                        enUS = "If activated, will use automatically use Taunt whenever available.", 
                        ruRU = "Если активирован, будет автоматически использовать Taunt при любой возможности.",  
                        frFR = "S'il est activé, utilisera automatiquement Taunt dès qu'il sera disponible.", 
                    }, 
                    M = {},
                },
    			{
                    E = "Checkbox", 
                    DB = "HeroicThrowPull",
                    DBV = true,
                    L = { 
                        enUS = "Automatic Heroic Throw", 
                        ruRU = "Automatic Heroic Throw",
                        frFR = "Automatic Heroic Throw",
                    }, 
                    TT = { 
                        enUS = "If activated, will use automatically use Heroic Throw whenever available.", 
                        ruRU = "Если активирован, будет автоматически использовать Heroic Throw при любой возможности.",  
                        frFR = "S'il est activé, utilisera automatiquement Heroic Throw dès qu'il sera disponible.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ThreatDamagerLimit",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = "Only 'Damager'\nThreat limit(agro,>= %)",
						ruRU = "Только 'Урон'\nЛимит угрозы(агро,>= %)", 
						frFR = "Seulement 'DPS'\nLimite de menace(аggrо,>= %)", 
					}, 
                    TT = { 
                        enUS = "OFF - No limit\nIf the percentage of the threat (agro) is greater than\nor equal to the specified one, then the\n'safe' rotation will be performed. As far as possible, the\nabilities causing too many threats will be stopped until the\nthreat level (agro) is normalized", 
                        ruRU = "OFF - Нет лимита\nЕсли процент угрозы (агро) больше или равен указанному,\nто будет выполняться 'безопасная' ротация\nПо мере возможности перестанут использоваться способности\nвызывающие слишком много угрозы пока\nуровень угрозы (агро) не нормализуется",  
                        frFR = "OFF - Aucune limite\nSi le pourcentage de la menace (agro) est supérieur ou égal à celui spécifié, alors la rotation\n'safe' sera effectuée. Dans la mesure du possible, les \nabilités causant trop de menaces seront arrêtées jusqu'à ce que le\n niveau de menace (agro) soit normalisé",
					},     
                    M = {},
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Smart Reflect -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
    			{
                    E = "Checkbox", 
                    DB = "SmartReflect",
                    DBV = true,
                    L = { 
                        enUS = "Smart Spell Reflect", 
                        ruRU = "Smart Spell Reflect", 
                        frFR = "Smart Spell Reflect",
                    }, 
                    TT = { 
                        enUS = "Auto reflect spells in instances.", 
                        ruRU = "Auto reflect spells in instances.",
                        frFR = "Auto reflect spells in instances.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "SmartReflectPercent",
                    DBV = 90, 
                    ONOFF = false,
                    L = { 
                        enUS = "Reflect %",
						ruRU = "Reflect %",
						frFR = "Reflect %", 
					}, 
                    TT = { 
                        enUS = "Spell reflect when spell is X % complete.\nExample: 90 = 90% complete.", 
                        ruRU = "Spell reflect when spell is X % complete.\nExample: 90 = 90% complete.",
                        frFR = "Spell reflect when spell is X % complete.\nExample: 90 = 90% complete.",
					},     
                    M = {},
                },
            },
            { -- Lucid Dream
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(299374) .. " -- ",
                    },
                },
            },
            { -- [4] 4th Row
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "LucidDreamTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(299374) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(299374) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(299374) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "LucidDreamHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(299374) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(299374) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(299374) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Defensives -- ",
                    },
                },
            },
            { -- [1] 1st Row  	
                {
                    E = "Checkbox", 
                    DB = "LastStandIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(12975) .. "\nSkip if " .. A.GetSpellInfo(871) .. " used",
                        ruRU = A.GetSpellInfo(12975) .. "\nSkip if " .. A.GetSpellInfo(871) .. " used",  
                        frFR = A.GetSpellInfo(12975) .. "\nSkip if " .. A.GetSpellInfo(871) .. " used", 
                    }, 
                    M = {},
                }, 		    
                {
                    E = "Checkbox", 
                    DB = "ShieldWallCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(12975) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(12975) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(12975) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },
            },
            {			
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "LastStandTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(12975) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(12975) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(12975) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "LastStandHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(12975) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(12975) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(12975) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
			{
    			{
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 50,                            
                    DB = "ShieldBlockHPLost",
                    DBV = 3, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(2565) .. "\n%HP lost per sec",
                    }, 
                    M = {},
                },
    			{
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "RallyingCryHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(97462) .. " (%)",
                    }, 
                    M = {},
                },	
			},
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [1] 1st Row  			    
                {
                    E = "Checkbox", 
                    DB = "ShieldWallCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(871) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(871) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(871) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                }, 					
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "ShieldWallTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(871) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(871) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(871) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "ShieldWallHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(871) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(871) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(871) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "UseLastStandToFillShieldBlockDownTime",
                    DBV = true,
                    L = { 
                        enUS = "Use Last Stand to fill Shield Block down time", 
                        ruRU = "Use Last Stand to fill Shield Block down time", 
                        frFR = "Use Last Stand to fill Shield Block down time",
                    }, 
                    TT = { 
                        enUS = "Enable this if you want to fill Shield Block down time with Last Stand.", 
                        ruRU = "Enable this if you want to fill Shield Block down time with Last Stand.", 
                        frFR = "Enable this if you want to fill Shield Block down time with Last Stand.",
                    }, 
                    M = {},
                },					
                {
                    E = "Checkbox", 
                    DB = "UseShieldBlockDefensively",
                    DBV = true,
                    L = { 
                        enUS = "Use Shield Block purely defensively", 
                        ruRU = "Use Shield Block purely defensively", 
                        frFR = "Use Shield Block purely defensively",
                    }, 
                    TT = { 
                        enUS = "Enable this if you only want to use Shield Block in a defensive manner.", 
                        ruRU = "Enable this if you only want to use Shield Block in a defensive manner.", 
                        frFR = "Enable this if you only want to use Shield Block in a defensive manner.",
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "UseRageDefensively",
                    DBV = true,
                    L = { 
                        enUS = "Use Rage defensively", 
                        ruRU = "Use Rage defensively", 
                        frFR = "Use Rage defensively",
                    }, 
                    TT = { 
                        enUS = "Enable this to prioritize defensive use of Rage.", 
                        ruRU = "Enable this to prioritize defensive use of Rage.", 
                        frFR = "Enable this to prioritize defensive use of Rage.",
                    }, 
                    M = {},
                }, 
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Utilities -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
               --Charge {              
					{
						E = "Checkbox", 
						DB = "UseCharge",
						DBV = true,
						L = { 
							enUS = "Auto " .. A.GetSpellInfo(100), 
							ruRU = "Авто " .. A.GetSpellInfo(100), 
							frFR = "Auto " .. A.GetSpellInfo(100), 
						}, 
						TT = { 
							enUS = "Automatically use " .. A.GetSpellInfo(100), 
							ruRU = "Автоматически использовать " .. A.GetSpellInfo(100), 
							frFR = "Utiliser automatiquement " .. A.GetSpellInfo(100), 
						}, 
						M = {},
					},
					{
						E = "Slider",                                                     
						MIN = 1, 
						MAX = 7,                            
						DB = "ChargeTime",
						DBV = 3, -- Set healthpercentage @60% life. 
						ONOFF = true,
						L = { 
							enUS = A.GetSpellInfo(100) .. " if moving for",
							ruRU = A.GetSpellInfo(100) .. " если переехать",
							frFR = A.GetSpellInfo(100) .. " si vous bougez pendant",
						},
						TT = { 
							enUS = "If " .. A.GetSpellInfo(100) .. " is talented and ready, will use it if moving for set value.", 
							ruRU = "Если " .. A.GetSpellInfo(100) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
							frFR = "Si " .. A.GetSpellInfo(100) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
						}, 
						M = {},
					},	
            },	
			-- Heroic Leap
            {              
					{
						E = "Checkbox", 
						DB = "UseHeroicLeap",
						DBV = true,
						L = { 
							enUS = "Auto " .. A.GetSpellInfo(6544), 
							ruRU = "Авто " .. A.GetSpellInfo(6544), 
							frFR = "Auto " .. A.GetSpellInfo(6544), 
						}, 
						TT = { 
							enUS = "Automatically use " .. A.GetSpellInfo(6544), 
							ruRU = "Автоматически использовать " .. A.GetSpellInfo(6544), 
							frFR = "Utiliser automatiquement " .. A.GetSpellInfo(6544), 
						}, 
						M = {},
					},
					{
						E = "Slider",                                                     
						MIN = 1, 
						MAX = 7,                            
						DB = "HeroicLeapTime",
						DBV = 3, -- Set healthpercentage @60% life. 
						ONOFF = true,
						L = { 
							enUS = A.GetSpellInfo(6544) .. " if moving for",
							ruRU = A.GetSpellInfo(6544) .. " если переехать",
							frFR = A.GetSpellInfo(6544) .. " si vous bougez pendant",
						},
						TT = { 
							enUS = "If " .. A.GetSpellInfo(6544) .. " is talented and ready, will use it if moving for set value.", 
							ruRU = "Если " .. A.GetSpellInfo(6544) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
							frFR = "Si " .. A.GetSpellInfo(6544) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
						}, 
						M = {},
					},	
                --},					
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Interrupts Settings -- ",
                    },
                },
            },
            { -- [3] 3rd Row 					
               
                {
                    E = "Checkbox", 
                    DB = "SmartStormbolt",
                    DBV = true,
                    L = { 
                        enUS = "Smart " .. A.GetSpellInfo(107570), 
                        ruRU = "Smart " .. A.GetSpellInfo(107570), 
                        frFR = "Smart " .. A.GetSpellInfo(107570), 
                    }, 
                    TT = { 
                        enUS = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        ruRU = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        frFR = "[BETA] Activate the smart " .. A.GetSpellInfo(107570) .. " system working with special list for all Battle For Azeroth Mythic dungeon.",   
                    }, 
                    M = {},
                },				
			},
            { -- [4] 4th Row
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- PvP -- ",
                    },
                },
            },
            { -- [5] 5th Row     
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "FearPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(5782),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "@arena1", value = 1 },
                        { text = "@arena2", value = 2 },
                        { text = "@arena3", value = 3 },
                        { text = "primary", value = 4 },
                    },
                    MULT = true,
                    DB = "FearPvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(5782) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },		
    },
    [7] = {
        [ACTION_CONST_WARRIOR_FURY] = {
            ["stun"] = { Enabled = true, Key = "Stormbolt", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_WARRIOR_ARMS]
                return  (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 20)
                        )                                                             
            ]] },
            ["disarm"] = { Enabled = true, Key = "Disarm", LUAVER = 5, LUA = [[
                return     DisarmIsReady(thisunit, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "Reflect", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true)
            ]] },
            ["kick"] = { Enabled = true, Key = "Pummel", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_WARRIOR_ARMS]
                return     A.Pummel:IsReadyM(thisunit) and                         
                        A.Pummel:AbsentImun(thisunit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and 
                        Unit(thisunit):IsCastingRemains() > 0 and 
            ]] },
        },
        [ACTION_CONST_WARRIOR_ARMS] = {
            ["stun"] = { Enabled = true, Key = "Stormbolt", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_WARRIOR_ARMS]
                return  (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 20)
                        )                                                             
            ]] },
            ["disarm"] = { Enabled = true, Key = "Disarm", LUAVER = 5, LUA = [[
                return     DisarmIsReady(thisunit, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "Reflect", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true)
            ]] },
            ["kick"] = { Enabled = true, Key = "Pummel", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_WARRIOR_ARMS]
                return     A.Pummel:IsReadyM(thisunit) and                         
                        A.Pummel:AbsentImun(thisunit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and 
                        Unit(thisunit):IsCastingRemains() > 0 and 
            ]] },
        },
        [ACTION_CONST_WARRIOR_PROTECTION] = {
            ["stun"] = { Enabled = true, Key = "Stormbolt", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_WARRIOR_ARMS]
                return  (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 20)
                        )                                                             
            ]] },
            ["disarm"] = { Enabled = true, Key = "Disarm", LUAVER = 5, LUA = [[
                return     DisarmIsReady(thisunit, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "Reflect", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true)
            ]] },
            ["kick"] = { Enabled = true, Key = "Pummel", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_WARRIOR_ARMS]
                return     A.Pummel:IsReadyM(thisunit) and                         
                        A.Pummel:AbsentImun(thisunit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and 
                        Unit(thisunit):IsCastingRemains() > 0 and 
            ]] },
        },
    },
}

-----------------------------------------
--                   PvP  
-----------------------------------------

-- Disarm
function A.DisarmIsReady(unit, isMsg, skipShouldStop)
    if A[A.PlayerSpec].Disarm then 
        local unitID = A.GetToggle(2, "DisarmPvPunits")
        return     (
            (unit == "arena1" and unitID[1]) or 
            (unit == "arena2" and unitID[2]) or
            (unit == "arena3" and unitID[3]) or
            (not unit:match("arena") and unitID[4]) 
        ) and 
        A.IsInPvP and
        Unit(unit):IsEnemy() and  
        (
            (
                not isMsg and 
                A.GetToggle(2, "DisarmPvP") ~= "OFF" and 
                A[A.PlayerSpec].Disarm:IsReady(unit, nil, nil, skipShouldStop) and 
                Unit(unit):IsMelee() and 
                (
                    A.GetToggle(2, "DisarmPvP") == "ON COOLDOWN" or 
                    Unit(unit):HasBuffs("DamageBuffs") > 3 
                )
            ) or 
            (
                isMsg and 
                A[A.PlayerSpec].Disarm:IsReadyM(unit)                     
            )
        ) and 
        Unit(unit):IsPlayer() and                     
        A[A.PlayerSpec].Disarm:AbsentImun(unit, {"CCTotalImun", "DamagePhysImun", "TotalImun"}, true) and 
        Unit(unit):IsControlAble("disarm", 0) and 
        Unit(unit):HasDeBuffs("Disarmed") == 0
    end 
end 

-- Spell Reflection 
function A.ReflectIsReady(unit, isMsg, skipShouldStop)
    if A[A.PlayerSpec].SpellReflection then 
        local unitID = A.GetToggle(2, "ReflectPvPunits")
        return     (
            (unit == "arena1" and unitID[1]) or 
            (unit == "arena2" and unitID[2]) or
            (unit == "arena3" and unitID[3]) or
            (not unit:match("arena") and unitID[4]) 
        ) and 
        A.IsInPvP and
        Unit(unit):IsEnemy() and  
        (
            (
                not isMsg and 
                A.GetToggle(2, "ReflectPvP") ~= "OFF" and 
                A[A.PlayerSpec].SpellReflection:IsReady(unit, nil, nil, skipShouldStop) and
                (
                    A.GetToggle(2, "ReflectPvP") == "ON COOLDOWN" or 
                    (A.GetToggle(2, "ReflectPvP") == "DANGEROUS CAST" and Action.ShouldReflect(unit))
                )
            ) or 
            (
                isMsg and 
                A[A.PlayerSpec].SpellReflection:IsReadyM(unit)                     
            )
        ) and 
        Unit(unit):IsPlayer()
    end 
end 

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].Pummel and A[A.PlayerSpec].Pummel:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Pummel:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp")  then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "StormboltPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Stormbolt and A[A.PlayerSpec].Stormbolt:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Stormbolt:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("stun", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 