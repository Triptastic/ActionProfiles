--####################################
--##### TRIP'S WARLOCK PROFILEUI #####
--####################################


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
local select, setmetatable							= select, setmetatable


A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "v1.1.0 (18 Nov 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_WARLOCK_AFFLICTION] = {  
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },		
            { -- General -- Content
                { -- Mouseover
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
                { -- AoE
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
			},
			{
				{ -- Auto Multi Dot
                    E = "Checkbox", 
                    DB = "AutoMultiDot",
                    DBV = true,
                    L = { 
                        ANY = "Auto Multi DoT (BETA)"
                    }, 
                    TT = { 
                        ANY = "Switch through enemies to apply DoTs automatically! Limited to five total targets per combat."
                    }, 
                    M = {},
                },			
				{ -- ForceAoE
                    E = "Checkbox", 
                    DB = "ForceAoE",
                    DBV = true,
                    L = { 
                        ANY = "Force AoE Opener"
                    }, 
                    TT = { 
                        ANY = "Force Seed of Corruption as first spell if using Sow The Seeds talent - this is to help with AoE detection!"
                    }, 
                    M = {},
                },				
            }, 								
            { -- Spacer

                {
                    E = "LayoutSpace",                                                                        
                },
            },
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PET STUFF ><><><l ",
                    },
                },
            },
            { -- Pet Stuff - Content
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = A.GetSpellInfo(688), value = "IMP" },
                        { text = A.GetSpellInfo(697), value = "VOIDWALKER" },                    
                        { text = A.GetSpellInfo(691), value = "FELHUNTER" },
                        { text = A.GetSpellInfo(712), value = "SUCCUBUS" },
                    },
                    DB = "PetChoice",
                    DBV = "IMP",
                    L = { 
                        enUS = "Pet Selection", 
                        ruRU = "Выбор питомца", 
                        frFR = "Sélection du familier",
                    }, 
                    TT = { 
                        enUS = "Choose the pet to summon", 
                        ruRU = "Выберите питомца для призыва", 
                        frFR = "Choisir le familier à invoquer",
					},
                    M = {},
                },
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
					},					
                    M = {},
                },					
            }, 
            { -- Spacer
                {
                    E = "LayoutSpace",                                                                         
                },
            },			
			{ -- Defensives -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },			
            { -- Defensives -- Content
                { -- UnendingResolve
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "UnendingResolve",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(104773) .. " HP (%)",
                    }, 
                    M = {},
                },
                { -- DrainLife
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DrainLifeHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Drain Life HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Drain Life at this percent HP."
					},					
                    M = {},
                },				
            },
            { -- Spacer

                {
                    E = "LayoutSpace",                                                                         
                },
            },
        },
        [ACTION_CONST_WARLOCK_DESTRUCTION] = {  
            { -- General -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },	
            { -- General -- Content
                { -- Mouseover
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
                { -- AoE
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
				{ -- Auto Multi Dot
                    E = "Checkbox", 
                    DB = "AutoHavoc",
                    DBV = true,
                    L = { 
                        ANY = "Auto Havoc"
                    }, 
                    TT = { 
                        ANY = "Automatically switch targets when Havoc is used!"
                    }, 
                    M = {},
                },							
            }, 
            { -- Spacer

                {
                    E = "LayoutSpace",                                                                        
                },
            },
            { -- Pet Stuff -- Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PET STUFF ><><><l ",
                    },
                },
            },
            { -- Pet Stuff - Content
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = A.GetSpellInfo(688), value = "IMP" },
                        { text = A.GetSpellInfo(697), value = "VOIDWALKER" },                    
                        { text = A.GetSpellInfo(691), value = "FELHUNTER" },
                        { text = A.GetSpellInfo(712), value = "SUCCUBUS" },
                    },
                    DB = "PetChoice",
                    DBV = "IMP",
                    L = { 
                        enUS = "Pet Selection", 
                        ruRU = "Выбор питомца", 
                        frFR = "Sélection du familier",
                    }, 
                    TT = { 
                        enUS = "Choose the pet to summon", 
                        ruRU = "Выберите питомца для призыва", 
                        frFR = "Choisir le familier à invoquer",
					},
                    M = {},
                },
                { -- Health Funnel
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealthFunnelHP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Health Funnel HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Health Funnel when pet reaches percent HP. Won't use if own HP is critical."
					},					
                    M = {},
                },					
            }, 				
            { -- LayoutSpace

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { --Defensives Header
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },			
            { -- Unending Resolve Slider
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "UnendingResolve",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(104773) .. " HP (%)",
                    }, 
                    M = {},
                },
            },
            { -- Healing Potion Slider
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SpectralHealingPotionHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Spectral Healing Potion HP (%)",
                    }, 
                    M = {},
                },
			},
            { -- Mortal Coil HP
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "MortalCoilHP",
                    DBV = 30, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(6789) .. " HP(%)",
                    }, 
                    M = {},
                },
			},			
        },
        [ACTION_CONST_WARLOCK_DEMONOLOGY] = {  
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
                    DBV = false,
                    L = { 
                        enUS = "Trinkets\nAoE only", 
                        ruRU = "Trinkets\nAoE only",  
                        frFR = "Trinkets\nAoE only",  
                    }, 
                    TT = { 
                        enUS = "Enable this to option to trinkets for AoE usage ONLY.", 
                        ruRU = "Включите эту опцию для Брелков ТОЛЬКО для использования AoE.", 
                        frFR = "Activez cette option pour les trinkets pour une utilisation AoE UNIQUEMENT.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 15,                            
                    DB = "TrinketsMinTTD",
                    DBV = 5, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min TTD",
                    },
                    TT = { 
                        enUS = "Minimum Time To Die for units in range before using Trinkets.\nNOTE: This will calculate Time To Die of your current target OR the Area Time To Die if multiples units are detected.", 
                        ruRU = "Минимальное время до смерти для юнитов в радиусе действия до использования Брелков.\nПРИМЕЧАНИЕ. При этом будет рассчитано время до смерти текущей цели ИЛИ время до смерти в случае обнаружения нескольких единиц.", 
                        frFR = "Temps minimum pour mourir pour les unités à portée avant d'utiliser des Trinkets.\nREMARQUE: Cela calculera le temps de mourir de votre cible actuelle OU le temps de mourir de la zone si plusieurs unités sont détectées.", 
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
                    DBV = 2, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Min Units",
                    },
                    TT = { 
                        enUS = "Minimum number of units in range to activate Trinkets.", 
                        ruRU = "Минимальное количество юнитов в радиусе действия для активации Брелков.", 
                        frFR = "Nombre minimum d'unités à portée pour activer les Trinkets.",  
                    },					
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,                            
                    DB = "TrinketsUnitsRange",
                    DBV = 40, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Max AoE range",
                    },
                    TT = { 
                        enUS = "Maximum range for units detection to automatically activate trinkets.", 
                        ruRU = "Максимальная дальность обнаружения юнитов для автоматической активации безделушек.", 
                        frFR = "Portée maximale de détection des unités pour activer automatiquement les trinkets.",  
                    },					
                    M = {},
                },
			},
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- Rotation -- ",
                    },
                },
            },
            { -- [1] 1st Row                           
                {
                    E = "Checkbox", 
                    DB = "PredictShards",
                    DBV = true,
                    L = { 
                        enUS = "Soul Shards prediction", 
                        ruRU = "Soul Shards prediction", 
                        frFR = "Soul Shards prediction", 
                    }, 
                    TT = { 
                        enUS = "Rotation will predict future shards depending on current casted spell.", 
                        ruRU = "Rotation will predict future shards depending on current casted spell.",  
                        frFR = "Rotation will predict future shards depending on current casted spell.", 
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
                        ANY = " -- " .. A.GetSpellInfo(196277) .. " settings -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "ImplosionEnemies",
                    DBV = 3, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(196277) .. " Enemies",
                    }, 
                    TT = { 
                        enUS = "Set the number of enemies to use " .. A.GetSpellInfo(196277), 
                        ruRU = "Set the number of enemies to use " .. A.GetSpellInfo(196277), 
                        frFR = "Set the number of enemies to use " .. A.GetSpellInfo(196277), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 40,                            
                    DB = "ImplosionRange",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(196277) .. " Range",
                    }, 
                    TT = { 
                        enUS = "Set the range to use " .. A.GetSpellInfo(196277), 
                        ruRU = "Set the range to use " .. A.GetSpellInfo(196277), 
                        frFR = "Set the range to use " .. A.GetSpellInfo(196277), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "ImplosionImp",
                    DBV = 3, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(196277) .. " Imps",
                    }, 
                    TT = { 
                        enUS = "Set the number of imps to use " .. A.GetSpellInfo(196277), 
                        ruRU = "Set the number of imps to use " .. A.GetSpellInfo(196277), 
                        frFR = "Set the number of imps to use " .. A.GetSpellInfo(196277), 
                    }, 
                    M = {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Range By Pet", value = "RangeByPet" },
                        { text = "Range By Nameplate", value = "RangeByNameplate" },                    
                        { text = "Range By CLEU", value = "RangeByCLEU" },
                    },
                    DB = "ImplosionMode",
                    DBV = "RangeByCLEU",
                    L = { 
                        ANY = A.GetSpellInfo(196277) .. " Mode",
                    }, 
                    TT = { 
                        enUS = "Set the " .. A.GetSpellInfo(196277) .. " mode you want to use. \nRange By Pet: Get number of enemies in pet range. \nRange By Nameplate: Get number of enemies with nameplates. \nRange By CLEU: Get number of enemies with combat events logs.", 
                        ruRU = "Set the " .. A.GetSpellInfo(196277) .. " mode you want to use. \nRange By Pet: Get number of enemies in pet range. \nRange By Nameplate: Get number of enemies with nameplates. \nRange By CLEU: Get number of enemies with combat events logs.", 
                    }, 
                    M = {},
                },
            },
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] Multidots settings
                {
                    E = "Header",
                    L = {
                        ANY = " -- Multidots settings -- ",
                    },
                },
            },
			{
                {
                    E = "Checkbox", 
                    DB = "AutoDot",
                    DBV = true,
                    L = { 
                        enUS = "Enable auto Multidots", 
                        ruRU = "Использовать auto Multidots", 
                        frFR = "Activer le Multidots auto", 
                    }, 
                    TT = { 
                        enUS = "Automatically multidots units.\nMake sure to stay front of the enemies nameplate you want the bot to target.\nMake sure you correctly keybinded the TargetEnemy key in both game and GG.",
                        ruRU = "Автоматически многоточечные юниты.\nУбедитесь, что вы находитесь перед именной табличкой врагов, на которую должен нацелиться бот. \nУбедитесь, что вы правильно связали клавишу TargetEnemy в игре и в GG.",
                        frFR = "Multidot automatique des unités.\nAssurez-vous de rester en face du nameplate de l'ennemi que le bot doit cibler. \nAssurez-vous que la touche TargetEnemy a été correctement indexée dans le jeu et dans GG.",
                    }, 
                    M = {},
                },
				{
                    E 		= "Slider", 													
					MIN 	= 15, 
					MAX 	= 40,							
					DB 		= "MultiDotDistance",
					DBV 	= 25,
					ONLYOFF = true,
					L 		= { 
                        enUS = "Multidots Range", 
                        ruRU = "Сфера Multidots", 
                        frFR = "Portée du Multidots", 
                    }, 
					TT		= { 
                        enUS = "Choose the range where you want to automatically multidots units.", 
                        ruRU = "Выберите диапазон, в котором вы хотите автоматически многоточечные единицы.", 
						frFR = "Choisissez la portée dans laquelle vous souhaitez multidoter automatiquement les unités.", 
                    },
					M 		= {},
                },
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "In Raid", value = "In Raid" },
                        { text = "In Dungeon", value = "In Dungeon" },
						{ text = "In PvP", value = "In PvP" },
                        { text = "Everywhere", value = "Everywhere" },
                    },
                    MULT = false,
                    DB = "AutoDotSelection",
                    DBV = "In Raid", 
                    L = { 
                        enUS = "Multidots where", 
                        ruRU = "Multidots где", 
                        frFR = "Multidots où", 
                    }, 
                    TT = { 
                        enUS = "Choose where you want to automatically multidots units.", 
                        ruRU = "Выберите, где вы хотите автоматически многоточечные единицы.", 
						frFR = "Choisissez l'endroit où vous souhaitez multidoter automatiquement les unités.",
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
                    DB = "UnendingResolve",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(104773) .. " HP (%)",
                    }, 
                    M = {},
                },
            },
            { -- [3] 3rd Row 
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
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_WARLOCK_AFFLICTION] = { 
            ["dispel"] = { Enabled = true, Key = "SingeMagic", LUAVER = 5, LUA = [[
                return     DispelIsReady(thisunit, true, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "NetherWard", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true, true)
            ]] },
        },
        [ACTION_CONST_WARLOCK_DESTRUCTION] = { 
            ["dispel"] = { Enabled = true, Key = "SingeMagic", LUAVER = 5, LUA = [[
                return     DispelIsReady(thisunit, true, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "NetherWard", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true, true)
            ]] },

        },
        [ACTION_CONST_WARLOCK_DEMONOLOGY] = { 
            ["dispel"] = { Enabled = true, Key = "SingeMagic", LUAVER = 5, LUA = [[
                return     DispelIsReady(thisunit, true, true)
            ]] },
            ["reflect"] = { Enabled = true, Key = "NetherWard", LUAVER = 5, LUA = [[
                return     ReflectIsReady(thisunit, true, true)
            ]] },

        },
    },
}


-----------------------------------------
--                   PvP  
-----------------------------------------
-- SingeMagic
function A.DispelIsReady(unit, isMsg, skipShouldStop)
	if Unit(unit):IsPlayer() then 
        if not isMsg then		
            return not Unit(unit):IsEnemy() and not Unit(unit):InLOS() and A[A.PlayerSpec].SingeMagic:IsReady(unit, nil, nil, true) and A.AuraIsValid(unit, "UseDispel", "Dispel")
		else
		    -- Notification			
			-- Mate in raid need to create a macro with their Index by doing this in game : /script print(UnitInRaid("player"))	
            -- 	
            A.SendNotification("Dispel requested by : " .. UnitName(unit), 119905)
		    return A[A.PlayerSpec].SingeMagic:IsReadyM(unit) 
		end
    end 
end 

-- NetherWard spell Reflect
function A.ReflectIsReady(unit, isMsg, skipShouldStop)
    if A[A.PlayerSpec].NetherWard then 
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
                A[A.PlayerSpec].NetherWard:IsReady(unit, nil, nil, skipShouldStop) and
                (
                    A.GetToggle(2, "ReflectPvP") == "ON COOLDOWN" or 
                    (A.GetToggle(2, "ReflectPvP") == "DANGEROUS CAST" and EnemyTeam():IsCastingBreakAble(0.25))
                )
            ) or 
            (
                isMsg and 
                A[A.PlayerSpec].NetherWard:IsReadyM(unit)                     
            )
        ) and 
        Unit(unit):IsPlayer()
    end 
end 

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].PetKick and A[A.PlayerSpec].PetKick:IsReadyP(unit, nil, true) and A[A.PlayerSpec].PetKick:AbsentImun(unit, {"KickImun", "TotalImun", "TotalAndMag"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp")  then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "FearPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Fear and A[A.PlayerSpec].Fear:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Fear:AbsentImun(unit, {"CCTotalImun", "TotalImun", "TotalAndMag"}, true) and Unit(unit):IsControlAble("disorient", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 