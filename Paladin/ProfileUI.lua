--############################
--##### TRIP'S PALADINUI #####
--############################

-- Full credit to Taste

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
A.Data.ProfileUI = {      
    DateTime = "v1 (28 Oct 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_PALADIN_RETRIBUTION] = {          
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
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
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
                {
                    E = "Checkbox", 
                    DB = "AllowDelayedAW",
                    DBV = true,
                    L = { 
                        enUS = "Allow Delayed Avenging Wrath", 
                        ruRU = "Разрешить отсроченный гнев отомстить", 
                        frFR = "Autoriser Avenging Wrath en différé",
                    }, 
                    TT = { 
                        enUS = "Enable this to allow Templar's Verdict to be suggested while delaying use of Avenging Wrath/Crusade/Execution Sentence.", 
                        ruRU = "Включите этот параметр, чтобы разрешить вынесение вердикта тамплиеров при задержке использования приговора «Мстительный гнев / Крестовый поход / Исполнение».", 
                        frFR = "Activez cette option pour permettre au verdict du templier d'être suggéré tout en retardant l'utilisation de Avenging Wrath / Crusade / Execution Sentence.",
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
            { -- [7]  Azerite Beam settings
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(295258) .. " -- ",
                    },
                },
            },
            { -- [3] 3rd Row 				
		
                {
                    E = "Slider",                                                     
                    MIN = 3, 
                    MAX = 50,                            
                    DB = "FocusedAzeriteBeamTTD",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(295258) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the minimum Time To Die for a unit before using " .. A.GetSpellInfo(295258) .. " \nDoes not apply to Boss.", 
                        ruRU = "Установите минимальное время смерти для отряда перед использованием " .. A.GetSpellInfo(295258) .. " \nНе применимо к боссу.", 
                        frFR = "Définissez le temps minimum pour mourir pour une unité avant d'utiliser " .. A.GetSpellInfo(295258) .. " \nNe s'applique pas aux boss.", 
                    }, 					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "FocusedAzeriteBeamUnits",
                    DBV = 3, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(295258) .. " units",
                    },
                    TT = { 
                        enUS = "Set the minimum number of units around before using " .. A.GetSpellInfo(295258) .. " \nDoes not apply to Boss.", 
                        ruRU = "Set the minimum number of units around before using " .. A.GetSpellInfo(295258) .. " \nDoes not apply to Boss.",
                        frFR = "Set the minimum number of units around before using " .. A.GetSpellInfo(295258) .. " \nDoes not apply to Boss.",
                    }, 					
                    M = {},
                }, 				
            },
            { -- [6]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Potion Selection -- ",
                    },
                },
            }, 
            { -- [7]
                {
                    E = "Dropdown",                                                         
                    OT = {
					    { text = "UNBRIDLEDFURY", value = "UNBRIDLEDFURY" },
                        { text = "FOCUSEDRESOLVE", value = "FOCUSEDRESOLVE" },
                        { text = "BATTLEPOTIONOFSTRENGTH", value = "BATTLEPOTIONOFSTRENGTH" },
                        { text = "EMPOWEREDPROXIMITY", value = "EMPOWEREDPROXIMITY" },
                    },
                    MULT = false,
                    DB = "PotionSelection",
                    DBV = "UNBRIDLEDFURY", 
                    L = { 
                        ANY = "Select Potion",
                    }, 
                    TT = { 
                        enUS = "Select here the potion that will be used with rotation.\nYou need the potion in bag for it to works.", 
                        ruRU = "Select here the potion that will be used with rotation.\nYou need the potion in bag for it to works.", 
                        frFR = "Select here the potion that will be used with rotation.\nYou need the potion in bag for it to works.", 
                    }, 
                    M = {},
                },           
            }, 
            { -- [7] UnbridledFury 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(300714) .. " -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "UnbridledFuryAuto",
                    DBV = false,
                    L = { 
                        enUS = "Burst Potion", 
                        ruRU = "Burst Potion",
                        frFR = "Burst Potion",
                    }, 
                    TT = { 
                        enUS = "If activated, will auto re pots depending of the settings of this section", 
                        ruRU = "If activated, will auto re pots depending of the settings of this section", 
                        frFR = "If activated, will auto re pots depending of the settings of this section", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "UnbridledFuryWithExecute",
                    DBV = false,
                    L = { 
                        enUS = "Sync execute phase", 
                        ruRU = "Sync execute phase",
                        frFR = "Sync execute phase",   
                    }, 
                    TT = { 
                        enUS = "If activated, will auto re pots as soon as Execute phase is detected.", 
                        ruRU = "If activated, will auto re pots as soon as Execute phase is detected.", 
                        frFR = "If activated, will auto re pots as soon as Execute phase is detected.", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,      					
                    DB = "UnbridledFuryTTD",
                    DBV = 40, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(300714) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the minimum Time To Die for a unit before using " .. A.GetSpellInfo(300714) .. " \nDoes not apply to Boss.", 
                        ruRU = "Установите минимальное время смерти для отряда перед использованием " .. A.GetSpellInfo(300714) .. " \nНе применимо к боссу.", 
                        frFR = "Définissez le temps minimum pour mourir pour une unité avant d'utiliser " .. A.GetSpellInfo(300714) .. " \nNe s'applique pas aux boss.", 
                    }, 					
                    M = {},
                },				
            },
			{
                {
                    E = "Checkbox", 
                    DB = "UnbridledFuryWithBloodlust",
                    DBV = false,
                    L = { 
                        enUS = "Sync Bloodlust", 
                        ruRU = "Sync Bloodlust", 
                        frFR = "Sync Bloodlust",  
                    }, 
                    TT = { 
                        enUS = "If activated, will auto re pots as soon as Bloodlust is detected.", 
                        ruRU = "If activated, will auto re pots as soon as Bloodlust is detected.",
                        frFR = "If activated, will auto re pots as soon as Bloodlust is detected.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "UnbridledFuryWithSecondAscendance",
                    DBV = false,
                    L = { 
                        enUS = "Sync Avenging Wrath", 
                        ruRU = "Sync Avenging Wrath", 
                        frFR = "Sync Avenging Wrath",  
                    }, 
                    TT = { 
                        enUS = "If activated, will auto re pots as soon as Avenging Wrath is detected.", 
                        ruRU = "If activated, will auto re pots as soon as Avenging Wrath is detected.", 
                        frFR = "If activated, will auto re pots as soon as Avenging Wrath is detected.", 
                    }, 
                    M = {},
                }, 				
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,      					
                    DB = "UnbridledFuryHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(300714) .. " HP",
                    },
                    TT = { 
                        enUS = "Set the minimum health percent for a unit before using " .. A.GetSpellInfo(300714) .. ".", 
                        ruRU = "Set the minimum health percent for a unit before using " .. A.GetSpellInfo(300714) .. ".",  
                        frFR = "Set the minimum health percent for a unit before using " .. A.GetSpellInfo(300714) .. ".", 
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
                        ANY = " -- Defensives -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DivineShieldHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(642) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FlashofLightHP",
                    DBV = 40, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(19750) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Bubble",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(642) .. " (%)",
                    }, 
                    M = {},
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "JusticarsVengeanceHP",
                    DBV = 50, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(215661) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "WordofGloryHP",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(212191) .. " (%)",
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
                        ANY = " -- Utilities -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "UseCavalier",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. A.GetSpellInfo(190784), 
                        ruRU = "Авто " .. A.GetSpellInfo(190784), 
                        frFR = "Auto " .. A.GetSpellInfo(190784), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. A.GetSpellInfo(190784), 
                        ruRU = "Автоматически использовать " .. A.GetSpellInfo(190784), 
                        frFR = "Utiliser automatiquement " .. A.GetSpellInfo(190784), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "CavalierTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = A.GetSpellInfo(190784) .. " if moving for",
                        ruRU = A.GetSpellInfo(190784) .. " если переехать",
                        frFR = A.GetSpellInfo(190784) .. " si vous bougez pendant",
                    },
                    TT = { 
                        enUS = "If " .. A.GetSpellInfo(190784) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. A.GetSpellInfo(190784) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. A.GetSpellInfo(190784) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
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
                        enUS = "Enable/Disable relative party passive rotation\nExample : Pet Dispell over party members.", 
                        ruRU = "Включить/Выключить относительно группы пассивную ротацию\nExample : Pet Dispell over party members.", 
						frFR = "Active/Désactive la rotation spécifique aux alliés pour les personnes dans le groupe.\nExemple : Dispell automatique sur les membres du groupe.",
                    }, 
                    M = {},
                },            
            }, 
            -- Blessing of Protection
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(1022) .." -- ",
                    },
                },
            },
            {
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "BlessingofProtectionHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(1022) .. "\nunit HP",
                    },
                    TT = { 
                        enUS = A.GetSpellInfo(1022) .. " on low HP unit depending of the value you set.", 
                        ruRU = A.GetSpellInfo(1022) .. " on low HP unit depending of the value you set.", 
                        frFR = A.GetSpellInfo(1022) .. " on low HP unit depending of the value you set.", 
                    }, 					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 30,                            
                    DB = "BlessingofProtectionTTD",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(1022) .. "\nTTD",
                    },
                    TT = { 
                        enUS = A.GetSpellInfo(1022) .. " if unit time to die is inferior to this value.", 
                        ruRU = A.GetSpellInfo(1022) .. " if unit time to die is inferior to this value.", 
                        frFR = A.GetSpellInfo(1022) .. " if unit time to die is inferior to this value.", 
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
                    DB = "HammerofJusticePvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(853),
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
                    DB = "HammerofJusticePvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(853) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_PALADIN_PROTECTION] = {          
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
                        frFR = "Utiliser l'AoE",
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
                        frFR = "Activer les actions multi-unités",
                    }, 
                    M = {
					    Custom = "/run Action.AoEToggleMode()",
						-- It does call func CraftMacro(L[CL], macro above, 1) -- 1 means perCharacter tab in MacroUI, if nil then will be used allCharacters tab in MacroUI
						Value = value or nil, 
						-- Very Very Optional, no idea why it will be need however.. 
						TabN = '@number' or nil,								
						Print = '@string' or nil,
					},
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
                        ANY = " -- Utilities -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "SmartHoJ",
                    DBV = true,
                    L = { 
                        enUS = "Smart " .. A.GetSpellInfo(853), 
                        ruRU = "Smart " .. A.GetSpellInfo(853), 
                        frFR = "Smart " .. A.GetSpellInfo(853), 
                    }, 
                    TT = { 
                        enUS = "[BETA] Activate the smart " .. A.GetSpellInfo(853) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        ruRU = "[BETA] Activate the smart " .. A.GetSpellInfo(853) .. " system working with special list for all Battle For Azeroth Mythic dungeon.", 
                        frFR = "[BETA] Activate the smart " .. A.GetSpellInfo(853) .. " system working with special list for all Battle For Azeroth Mythic dungeon.",   
                    }, 
                    M = {},
                },				
                {
                    E = "Checkbox", 
                    DB = "UseCavalier",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. A.GetSpellInfo(190784), 
                        ruRU = "Авто " .. A.GetSpellInfo(190784), 
                        frFR = "Auto " .. A.GetSpellInfo(190784), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. A.GetSpellInfo(190784), 
                        ruRU = "Автоматически использовать " .. A.GetSpellInfo(190784), 
                        frFR = "Utiliser automatiquement " .. A.GetSpellInfo(190784), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "CavalierTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = A.GetSpellInfo(190784) .. " if moving for",
                        ruRU = A.GetSpellInfo(190784) .. " если переехать",
                        frFR = A.GetSpellInfo(190784) .. " si vous bougez pendant",
                    },
                    TT = { 
                        enUS = "If " .. A.GetSpellInfo(190784) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. A.GetSpellInfo(190784) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. A.GetSpellInfo(190784) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
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
            { -- DivineProtection
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(498) .. " -- ",
                    },
                },
            },
            -- DivineProtection
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 15,                            
                    DB = "DivineProtectionTTD",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(498) .. "\nTTD(sec)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "DivineProtectionHP",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(498) .. "\n(%)",
                    }, 
                    M = {},
                },
			},						
            { -- [1] 1st Row  	
			LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },
                {
                    E = "Checkbox", 
                    DB = "ArdentDefenderIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(31850) .. "\nSkip if " .. A.GetSpellInfo(86659) .. " used",
                        ruRU = A.GetSpellInfo(31850) .. "\nSkip if " .. A.GetSpellInfo(86659) .. " used",  
                        frFR = A.GetSpellInfo(31850) .. "\nSkip if " .. A.GetSpellInfo(86659) .. " used", 
                    }, 
                    M = {},
                }, 		    
                {
                    E = "Checkbox", 
                    DB = "ArdentDefenderCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(31850) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(31850) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(31850) .. "\nCatch death hit", 
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
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "ArdentDefenderTTD",
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
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "ArdentDefenderHP",
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
			
            { -- [1] 1st Row  	
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
                {
                    E = "Checkbox", 
                    DB = "GuardianofAncientKingsCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(86659) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(86659) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(86659) .. "\nCatch death hit", 
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
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "GuardianofAncientKingsTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(86659) .. "\n<= time to die (sec)", 
                        ruRU = A.GetSpellInfo(86659) .. "\n<= time to die (sec)",  
                        frFR = A.GetSpellInfo(86659) .. "\n<= time to die (sec)",  
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition", 
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                },
                {
				RowOptions = { margin = { top = 10 } },
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB         = "GuardianofAncientKingsHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = A.GetSpellInfo(86659) .. "\n<= health (%)", 
                        ruRU = A.GetSpellInfo(86659) .. "\n<= health (%)",  
                        frFR = A.GetSpellInfo(86659) .. "\n<= health (%)", 
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
			LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },
    			{
				RowOptions = { margin = { top = 10 } },
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 70,                            
                    DB = "LightoftheProtectorHPLost",
                    DBV = 15, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. "\n%HP lost per sec",
                    }, 
                    M = {},
                },
    			{
				RowOptions = { margin = { top = 10 } },
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "LightoftheProtectorHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. " (%)",
                    }, 
                    M = {},
                },
    			{
				RowOptions = { margin = { top = 10 } },
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HandoftheProtectorHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(315924) .. " (%)",
                    }, 
                    M = {},
                },		
            },
            {
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },			
	            {
                    E = "Checkbox", 
                    DB = "LayonHandsCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(633) .. "\nCatch death hit",
                        ruRU = A.GetSpellInfo(633) .. "\nCatch death hit",  
                        frFR = A.GetSpellInfo(633) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use\nability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },	
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ArdentDefenderHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(31850) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AbyssalHealingPotionHP",
                    DBV = 30, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(301308) .. " (%)",
                    }, 
                    M = {},
                },
			},
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ShieldoftheRighteousHPLost",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(53600) .. " (%) lost/sec",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "LightoftheProtectorHPLost",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. " (%) lost/sec",
                    }, 
                    M = {},
                },
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "LightoftheProtectorHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(267461) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "GuardianofAncientKingsHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(86659) .. " (%)",
                    }, 
                    M = {},
                },
            },
            { -- [7] 
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
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
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
                        enUS = "Enable/Disable relative party passive rotation\nExample : Dispell over party members.", 
                        ruRU = "Включить/Выключить относительно группы пассивную ротацию\nПример: Разогнать членов группы.", 
						frFR = "Active/Désactive la rotation spécifique aux alliés pour les personnes dans le groupe.\nExemple : Dispell automatique sur les membres du groupe.",
                    }, 
                    M = {},
                }, 
        	    {	    
           	        E = "Checkbox", 
           	        DB = "AutoFreedom",
           	        DBV = true,
           	        L = { 
					    enUS = "Auto " .. A.GetSpellInfo(1044),
                        ruRU = "Auto " .. A.GetSpellInfo(1044),
	                },
           	        TT = { 
					    enUS = "Will auto use " .. A.GetSpellInfo(1044) .. " on friendly party units.",
                        ruRU = "Will auto use " .. A.GetSpellInfo(1044) .. " on friendly party units.",
					},
           	        M = {},
        	    },				
            }, 			            
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "UseSotROffensively",
                    DBV = true,
                    L = { 
                        enUS = "Use SotR Offensively", 
                        ruRU = "Используйте SotR в нападении",  
                        frFR = "Utiliser SotR Offensif", 
                    }, 
                    TT = { 
                        enUS = "Enable this setting if you want the addon to suggest Shield of the Righteous as an offensive ability.", 
                        ruRU = "Включите этот параметр, если вы хотите, чтобы аддон предлагал «Щит праведника» в качестве атакующей способности.", 
                        frFR = "Activez ce paramètre si vous souhaitez que l'addon suggère Bouclier des justes comme capacité offensive.",
                    }, 
                    M = {},
                },
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
                        enUS = "If activated, will use automatically use Growl whenever available.", 
                        ruRU = "Если активирован, будет автоматически использовать Growl при любой возможности.",  
                        frFR = "S'il est activé, utilisera automatiquement Growl dès qu'il sera disponible.", 
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
                    DB = "ImprisonPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(217832),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                        frFR = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Seulement si le joueur de mêlée a des buffs de dégâts\nON COOLDOWN - les moyens seront toujours utilisés sur les joueurs de mêlée\nOFF - Coupé de la rotation mais autorisant toujours le travail dans la file d'attente et Systèmes MSG\nSi vous souhaitez l'éteindre complètement, vous devez définir SetBlocker dans l'onglet 'Actions'", 
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
                    DB = "ImprisonPvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(217832) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },	
        [ACTION_CONST_PALADIN_HOLY] = {          
            LayoutOptions = { gutter = 5, padding = { left = 10, right = 10 } },	
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },
            { -- [1]                             
                {
                    E = "Checkbox", 
                    DB = "mouseover",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@mouseover", 
                        ruRU = "Использовать\n@mouseover", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions for @mouseover units\nExample: Resuscitate, Healing", 
                        ruRU = "Разблокирует использование действий для @mouseover юнитов\nНапример: Воскрешение, Хилинг", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "targettarget",
                    DBV = true,
                    L = { 
                        enUS = "Use\n@targettarget", 
                        ruRU = "Использовать\n@targettarget", 
                    }, 
                    TT = { 
                        enUS = "Will unlock use actions\nfor enemy @targettarget units", 
                        ruRU = "Разблокирует использование\nдействий для вражеских @targettarget юнитов", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "AoE",
                    DBV = true,
                    L = { 
                        enUS = "Use\nAoE", 
                        ruRU = "Использовать\nAoE", 
                    }, 
                    TT = { 
                        enUS = "Enable multiunits actions", 
                        ruRU = "Включает действия для нескольких целей", 
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
                {
                    E = "Checkbox", 
                    DB = "UseRotationPassive",
                    DBV = true,
                    L = { 
					    enUS = "Use\nPassive\nRotation",
                        ruRU = "Включить\nПассивную\nРотацию" 
	                },
                    M = {},
                },  								
            }, 	
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Healing Engine -- ",
                    },
                },
            },	
   	        { -- [7] 
                {
                    E = "Checkbox", 
                    DB = "ManaManagement",
                    DBV = true,
                    L = { 
                        enUS = "Boss Fight\nManaSave\n(PvE)", 
                        ruRU = "Бой с Боссом\nУправление Маной\n(PvE)",
                    }, 
                    TT = { 
                        enUS = "Enable to keep small mana save tricks during boss fight\nMana will keep going to save phase if Boss HP >= our Mana", 
                        ruRU = "Включает сохранение малого количества маны с помощью некоторых манипуляций в течении боя против Босса\nМана будет переходить в фазу сохранения если ХП Босса >= нашей Маны", 
                    }, 
                    M = {},
                }, 			
      	        {
         	        E = "Checkbox", 
         	        DB = "ManaPotion",
         	        DBV = true,
         	        L = { 
					    enUS = "Use\nMana Potion",
                        ruRU = "Использовать\nЗелье Маны",
					},
        	        M = {},
       	        },
      	        {
         	        E = "Checkbox", 
         	        DB = "StopCastOverHeal",
         	        DBV = true,
         	        L = { 
					    enUS = "Stop Cast\noverhealing",
                        ruRU = "Stop Cast\noverhealing",
					},
          	        TT = { 
					    enUS = "Enable this option to automatically stop the current cast to avoid overhealing.",
                        ruRU = "Enable this option to automatically stop the current cast to avoid overhealing.",
					},
        	        M = {},
       	        },	 				
        	    {	    
           	        E = "Checkbox", 
           	        DB = "StartByPreCast",
           	        DBV = true,
           	        L = { 
					    enUS = "Begin Combat\nBy PreCast",
                        ruRU = "Начинать Бой\nЗаранее произнося", 
	                },
           	        TT = { 
					    enUS = "Will start rotation on enemy by available longer\ncasting spell depended on your spec",
                        ruRU = "Будет начинать ротация на противнике с доступной\nдлинной произносящейся способности в зависимости от спека",
					},
           	        M = {},
        	    },
   	        },
		    -- Beacon of Virtue(talent)
			-- + Classic Beacon 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Beacons -- ",
                    },
                },
            },	
            { -- [3]  
                RowOptions = { margin = { top = 10 } },		
                {
                    E = "Dropdown",                                                         
                    OT = {   
                        { text = "Tanking Units", value = "Tanking Units" },                    
                        { text = "Mostly Inc. Damage", value = "Mostly Inc. Damage" },
                        { text = "HPS < Inc. Damage", value = "HPS < Inc. Damage" },
                    },
                    DB = "BeaconWorkMode",
                    DBV = "Tanking Units",
                    L = { 
                        ANY = A.GetSpellInfo(53563) .. "\nMode",
                    }, 
                    TT = { 
                        enUS = "These conditions will be skiped if unit will dying in emergency (critical) situation", 
                        ruRU = "Эти условия будут пропущены если юнит будет умирать в чрезвычайной (критической) ситуациии", 
                    },                    
                    M = {},
                },			
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "BeaconofVirtueHP",
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(200025) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "BeaconofVirtueTTD",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(200025) .. " TTD",                        
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                             
                    DB = "BeaconofVirtue",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(200025) .. " units",                        
                    }, 
                    M = {},
                },
            },			
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Racials -- ",
                    },
                },
            },	
			{
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RacialBurstHealing",                    
                    DBV = 100,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetLocalization()["TAB"][1]["RACIAL"] .. "\n(Healing HP %)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "RacialBurstDamaging",                    
                    DBV = 100,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetLocalization()["TAB"][1]["RACIAL"] .. "\n(Damaging HP %)",                        
                    },                     
                    M = {},
                },
			},
            { -- Trinkets
                {
                    E = "Header",
                    L = {
                        ANY = " -- Trinkets -- ",
                    },
                },
            },	
            {     			
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Always", value = "Always" },
                        { text = "Burst Synchronized", value = "BurstSync" },                    
                    },
                    DB = "TrinketBurstSyncUP",
                    DBV = "Always",
                    L = { 
					    enUS = "Damager: How to use trinkets",
                        ruRU = "Урон: Как использовать аксессуары", 
					},
                    TT = { 
					    enUS = "Always: On cooldown\nBurst Synchronized: By Burst Mode in 'General' tab",
                        ruRU = "Always: По доступности\nBurst Synchronized: От Режима Бурстов во вкладке 'Общее'", 
					}, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketMana",
                    DBV = 85,
                    ONLYOFF = false,
                    L = { 
					    enUS = "Trinket: Mana(%)",
                        ruRU = "Trinket: Mana(%)",
	                },
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "TrinketBurstHealing",
                    DBV = 75,
                    ONLYOFF = false,
                    L = { 
					    enUS = "Healer: Target Health (%)",
                        ruRU = "Лекарь: Здоровье Цели (%)", 
	                },
                    M = {},
                },		
		    },
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Essences -- ",
                    },
                },
            },	
			{
			RowOptions = { margin = { top = 10 } },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "LucidDreamManaPercent",                    
                    DBV = 85,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(299374) .. "\nMana %",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 10,                            
                    DB = "LifeBindersInvocationUnits",                    
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(299944) .. "\nunits number",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "LifeBindersInvocationHP",                    
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(299944) .. "\n(%)",                        
                    },                     
                    M = {},
                },
			},
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Mythic + -- ",
                    },
                },
            },	
			{
      	        {
         	        E = "Checkbox", 
         	        DB = "MythicPlusLogic",
         	        DBV = true,
         	        L = { 
					    enUS = "Smart Mythic+",
                        ruRU = "Smart Mythic+",
					},
          	        TT = { 
					    enUS = "Enable this option to activate critical healing logic depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
                        ruRU = "Enable this option to activate critical healing logic depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
					},
        	        M = {},
       	        },	
      	        {
         	        E = "Checkbox", 
         	        DB = "GrievousWoundsLogic",
         	        DBV = true,
         	        L = { 
					    enUS = "Grievous Wounds\nlogic",
                        ruRU = "Grievous Wounds\nlogic",
					},
          	        TT = { 
					    enUS = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
                        ruRU = "Enable this option to activate critical healing logic for friendly units that got Grievous Wounds debuff.",
					},
        	        M = {},
       	        },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "GrievousWoundsMinStacks",                    
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = "Grievous Wounds\nmin stacks",                        
                    },   
          	        TT = { 
					    enUS = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
                        ruRU = "How many stacks of Grievous Wounds should be up on friendly unit before force targetting on this unit.\nExample: 2 means friendly unit will be urgently targetted if he got 2 stacks.", 
					},					
                    M = {},
                },				
      	        {
         	        E = "Checkbox", 
         	        DB = "StopCastQuake",
         	        DBV = true,
         	        L = { 
					    enUS = "Stop Cast\nquaking",
                        ruRU = "Stop Cast\nquaking",
					},
          	        TT = { 
					    enUS = "Enable this option to automatically stop your current cast before Quake.",
                        ruRU = "Enable this option to automatically stop your current cast before Quake.",
					},
        	        M = {},
       	        },	
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 3,                            
                    DB = "StopCastQuakeSec",                    
                    DBV = 1,
					Precision = 1,
                    ONOFF = false,
                    L = { 
                        ANY = "Stop Cast\nquaking seconds",                      
                    },
          	        TT = { 
					    enUS = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
                        ruRU = "Define the value you want to stop your cast before next Quake hit.\nValue is in seconds.\nExample: 1 means you will stop cast at 1sec remaining on Quaking.",            
					},					
                    M = {},
                },
			},

            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Raid -- ",
                    },
                },
            },	
			{	
      	        {
         	        E = "Checkbox", 
         	        DB = "BlessingofFreedomWrathion",
         	        DBV = true,
         	        L = { 
					    ANY = A.GetSpellInfo(1044) .. "\non Wrathion Slow",
					},
          	        TT = { 
					    enUS = "Enable this option to automatically use " .. A.GetSpellInfo(1044) .. " on Wrathion Slow.",
                        ruRU = "Enable this option to automatically use " .. A.GetSpellInfo(1044) .. " on Wrathion Slow.",
					},
        	        M = {},
       	        },	
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "WrathionMovementStacks",                    
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(1044) .. "\nWrathion Slow stacks",                        
                    },                     
                    M = {},
                },				
      	        {
         	        E = "Checkbox", 
         	        DB = "BlessingofFreedomShadhar",
         	        DBV = true,
         	        L = { 
					    ANY = A.GetSpellInfo(1044) .. "\non Shadhar Fixate",
					},
          	        TT = { 
					    enUS = "Enable this option to automatically use " .. A.GetSpellInfo(1044) .. " on Shadhar Fixate.",
                        ruRU = "Enable this option to automatically use " .. A.GetSpellInfo(1044) .. " on Shadhar Fixate.",
					},
        	        M = {},
       	        },	
			},

            { -- [7] Holy Avenger
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(105809) .. " -- ",
                    },
                }, 
            },
			{
			    RowOptions = { margin = { top = -10 } },
                {
                    E = "Header",
                    L = {
                        ANY = " -- Raid -- ",
                    },
                },
                {
                    E = "Header",
                    L = {
                        ANY = " -- Dungeon -- ",
                    },
                },
			},
            -- Holy Avenger
            { -- [3] 
              	RowOptions = { margin = { top = 10 } },						
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HolyAvengerRaidUnits",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(105809) .. "\nmin units",                        
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HolyAvengerPartyUnits",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(105809) .. "\nmin units",                        
                    }, 
                    M = {},
                },
			},
			{
			    RowOptions = { margin = { top = 10 } },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "HolyAvengerRaidHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(105809) .. "\n(%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "HolyAvengerPartyHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(105809) .. "\n(%)",
                    }, 
                    M = {},
                },
			    
            },			
            { -- [7] Avenging Wrath
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(31884) .. " -- ",
                    },
                }, 
            },
			{
			RowOptions = { margin = { top = -10 } },
                {
                    E = "Header",
                    L = {
                        ANY = " -- Raid -- ",
                    },
                },
                {
                    E = "Header",
                    L = {
                        ANY = " -- Dungeon -- ",
                    },
                },
			},
            -- Avenging Wrath
            { -- [3] 
              	RowOptions = { margin = { top = 10 } },						
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "AvengingWrathRaidUnits",
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31884) .. "\nmin units",                        
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "AvengingWrathPartyUnits",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31884) .. "\nmin units",                        
                    }, 
                    M = {},
                },
			},
			{
			    RowOptions = { margin = { top = 10 } },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "AvengingWrathRaidHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31884) .. "\n(%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "AvengingWrathPartyHP",
                    DBV = 45,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31884) .. "\n(%)",
                    }, 
                    M = {},
                },
			    
            },	
            { -- AuraMastery
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(31821) .. " -- ",
                    },
                },
            },
            -- AuraMastery
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 15,                            
                    DB = "AuraMasteryAoETTD",
                    DBV = 10,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31821) .. "\ngroup TTD(sec)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "AuraMasteryBelowHealthPercent",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31821) .. "\n(%)",
                    }, 
                    M = {},
                },
			},
			{
                {                    
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 6,                            
                    DB = "AuraMasteryLast",
					Precision = 1,
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31821) .. "\nLast5sec DMG threshold",                        
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 30,                            
                    DB = "AuraMasteryAfter",
                    DBV = 15,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31821) .. "\nmin sec in combat",                        
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "AuraMasteryUnits",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(31821) .. "\nmin units",                        
                    }, 
                    M = {},
                },
            },
            { -- DivineProtection
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(498) .. " -- ",
                    },
                },
            },
            -- DivineProtection
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 15,                            
                    DB = "DivineProtectionTTD",
                    DBV = 10,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(498) .. "\nTTD(sec)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "DivineProtectionHP",
                    DBV = 35,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(498) .. "\n(%)",
                    }, 
                    M = {},
                },
			},						
		    -- Divine Shield 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(642) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "DivineShieldHP",
                    DBV = 25,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(642) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "DivineShieldTTD",
                    DBV = 1,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(642) .. " TTD",                        
                    }, 
                    M = {},
                },
            },	
		    -- Lay on Hands 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(633) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "LayOnHandsHP",
                    DBV = 25,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(633) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "LayOnHandsTTD",
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(633) .. " TTD",                        
                    }, 
                    M = {},
                },
            },		
		    -- Holy Shock 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(20473) .. " -- ",
                    },
                },
            },
            { -- [3]     
        	    {	    
           	        E = "Checkbox", 
           	        DB = "ForceGlimmerOnMaxUnits",
           	        DBV = true,
           	        L = { 
					    enUS = "Force " .. A.GetSpellInfo(287268) .. "\non maximum units",
                        ruRU = "Force " .. A.GetSpellInfo(287268) .. "\non maximum units",
	                },
           	        TT = { 
					    enUS = "Will try to spread as much as possible your " .. A.GetSpellInfo(20473) .. " to apply up to 8 " .. A.GetSpellInfo(287268) .. " buffs.\nOnly works with Glimmer of Light azerite trait.",
                        ruRU = "Will try to spread as much as possible your " .. A.GetSpellInfo(20473) .. " to apply up to 8 " .. A.GetSpellInfo(287268) .. " buffs.\nOnly works with Glimmer of Light azerite trait.",
					},
           	        M = {},
        	    },
        	    {	    
           	        E = "Checkbox", 
           	        DB = "GlimmerTankOOC",
           	        DBV = true,
           	        L = { 
					    enUS = A.GetSpellInfo(287268) .. "\tanks out of combat",
                        ruRU = A.GetSpellInfo(287268) .. "\tanks out of combat",
	                },
           	        TT = { 
					    enUS = "Will force your " .. A.GetSpellInfo(20473) .. " to apply " .. A.GetSpellInfo(287268) .. " buffs on tank before combat start.",
                        ruRU = "Will force your " .. A.GetSpellInfo(20473) .. " to apply " .. A.GetSpellInfo(287268) .. " buffs on tank before combat start.",
					},
           	        M = {},
        	    },
      	        {
         	        E = "Checkbox", 
         	        DB = "HolyShockDPS",
         	        DBV = true,
         	        L = { 
					    enUS = "Use " .. A.GetSpellInfo(20473) .. "\noffensive",
                        ruRU = "Use " .. A.GetSpellInfo(20473) .. "\noffensive",
					},
        	        M = {},
       	        }, 	
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "HolyShockHP",
                    DBV = 90,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(20473) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                             
                    DB = "HolyShockTTD",
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(20473) .. " TTD",                        
                    }, 
                    M = {},
                },
            },
		    -- Word of Glory 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(85673) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "WordofGloryHP",
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(85673) .. " (%)",
                    }, 
                    M = {},
                },
			},
		    -- Light of Dawn  
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(85222) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "LightofDawnHP",
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(85222) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                             
                    DB = "LightofDawnTTD",
                    DBV = 4,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(85222) .. " TTD",                        
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                             
                    DB = "LightofDawnUnits",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(85222) .. " units",                        
                    }, 
                    M = {},
                },
            },		
		    -- Flash of Light  
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(19750) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "FlashofLightHP",
                    DBV = 60,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(19750) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "FlashofLightTTD",
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(19750) .. " TTD",                        
                    }, 
                    M = {},
                },
            },		
		    -- Holy Light 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(82326) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                             
                    DB = "HolyLightHP",
                    DBV = 91,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(82326) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                             
                    DB = "HolyLightTTD",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(82326) .. " TTD",                        
                    }, 
                    M = {},
                },
            },		
		    -- Light of the Martyr  
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(183998) .." -- ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "LightoftheMartyrHP",
                    DBV = 40,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(183998) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                             
                    DB = "LightoftheMartyrTTD",
                    DBV = 2,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(183998) .. " TTD",                        
                    }, 
                    M = {},
                },
            },		
		    -- Light's Hammer (talent) 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(114158) .." -- ",
                    },
                },
            },			
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "LightsHammerHP",
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(114158) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                             
                    DB = "LightsHammerTTD",
                    DBV = 5,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(114158) .. " TTD",                        
                    }, 
                    M = {},
                },
            },		
		    -- Holy Prism(talent) 
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(114165) .." -- ",
                    },
                },
            },			
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "HolyPrismHP",
                    DBV = 85,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(114165) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "HolyPrismTTD",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = A.GetSpellInfo(114165) .. " TTD",                        
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
                        ruRU = "Включить/Выключить относительно группы пассивную ротацию", 
                    }, 
                    M = {},
                }, 
        	    {	    
           	        E = "Checkbox", 
           	        DB = "AutoFreedom",
           	        DBV = true,
           	        L = { 
					    enUS = "Auto " .. A.GetSpellInfo(1044),
                        ruRU = "Auto " .. A.GetSpellInfo(1044),
	                },
           	        TT = { 
					    enUS = "Will auto use " .. A.GetSpellInfo(1044) .. " on friendly party units.",
                        ruRU = "Will auto use " .. A.GetSpellInfo(1044) .. " on friendly party units.",
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

        },
    },
	
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_PALADIN_RETRIBUTION] = { 
            -- MSG Action Pet Dispell
            ["dispell"] = { Enabled = true, Key = "PetDispell", LUA = [[
                return     A.DispellMagic:IsReady(unit, true) and 
                        (
                            ( 
                                not Unit(thisunit):IsEnemy() and 
                                (
                                    (
                                        not InPvP() and 
                                        Env.Dispel(unit)
                                    ) or 
                                    (
                                        InPvP() and 
                                        EnemyTeam():PlayersInRange(1, 5)
                                    ) 
                                )
                            ) or 
                            ( 
                                Unit(thisunit):IsEnemy() and 
                                Unit(thisunit):GetRange() <= 5 and 
                                Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"TotalImun", "DeffBuffsMagic"}, true) 
                            )                
                        ) 
            ]] },
            -- MSG Action Pet Kick
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
            -- MSG Action Fear
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
        },
        [ACTION_CONST_PALADIN_PROTECTION] = { 
            -- MSG Action Pet Dispell
            ["dispell"] = { Enabled = true, Key = "PetDispell", LUA = [[
                return     A.DispellMagic:IsReady(unit, true) and 
                        (
                            ( 
                                not Unit(thisunit):IsEnemy() and 
                                (
                                    (
                                        not InPvP() and 
                                        Env.Dispel(unit)
                                    ) or 
                                    (
                                        InPvP() and 
                                        EnemyTeam():PlayersInRange(1, 5)
                                    ) 
                                )
                            ) or 
                            ( 
                                Unit(thisunit):IsEnemy() and 
                                Unit(thisunit):GetRange() <= 5 and 
                                Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"TotalImun", "DeffBuffsMagic"}, true) 
                            )                
                        ) 
            ]] },
            -- MSG Action Pet Kick
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
            -- MSG Action Fear
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
        },
        [ACTION_CONST_PALADIN_HOLY] = { 
            -- MSG Action Pet Dispell
            ["dispell"] = { Enabled = true, Key = "PetDispell", LUA = [[
                return     A.DispellMagic:IsReady(unit, true) and 
                        (
                            ( 
                                not Unit(thisunit):IsEnemy() and 
                                (
                                    (
                                        not InPvP() and 
                                        Env.Dispel(unit)
                                    ) or 
                                    (
                                        InPvP() and 
                                        EnemyTeam():PlayersInRange(1, 5)
                                    ) 
                                )
                            ) or 
                            ( 
                                Unit(thisunit):IsEnemy() and 
                                Unit(thisunit):GetRange() <= 5 and 
                                Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"TotalImun", "DeffBuffsMagic"}, true) 
                            )                
                        ) 
            ]] },
            -- MSG Action Pet Kick
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
            -- MSG Action Fear
            ["kick"] = { Enabled = true, Key = "Pet Kick", LUA = [[
                return  SpellInRange(thisunit, Action[PlayerSpec].SpellLock.ID) and 
                        select(2, CastTime(nil, thisunit)) > 0 and 
                        Action[PlayerSpec].SpellLock:AbsentImun(thisunit, {"KickImun", "TotalImun", "DeffBuffsMagic"}, true) 
            ]] },
        },
    },
}

-----------------------------------------
--                   PvP  
-----------------------------------------

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].SpearHandStrike and A[A.PlayerSpec].SpearHandStrike:IsReadyP(unit, nil, true) and A[A.PlayerSpec].SpearHandStrike:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "ParalysisPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Paralysis and A[A.PlayerSpec].Paralysis:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Paralysis:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 

