--#####################################
--###### TRIP'S DRUID PROFILEUI  ######
--#####################################


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
local TR                                            = A.TasteRotation
local select, setmetatable							= select, setmetatable
	

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "v1.5.0 (15 Dec 2020)",
    -- Class settings
    [2] = {
        [ACTION_CONST_DRUID_FERAL] = {             
        LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },			
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },            
            { -- GENERAL OPTIONS FIRST ROW
                { -- MOUSEOVER
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
				{ -- AOE
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
                    DB = "AutoCatForm",
                    DBV = true,
                    L = { 
                        ANY = "Auto Cat Form"
                    }, 
                    TT = { 
                        ANY = "Automatically Cat Form where applicable."
                    }, 
                    M = {},
                },
			},
			{
                {
                    E = "Checkbox", 
                    DB = "RegrowthProcs",
                    DBV = true,
                    L = { 
                        ANY = "Regrowth Procs"
                    }, 
                    TT = { 
                        ANY = "Automatically use Predatory Swiftness procs with Regrowth for healing."
                    }, 
                    M = {},
                }, 
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 5,                            
                    DB = "PrimalWrathTargets",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Primal Wrath targets"
					}, 
                    TT = { 
                        ANY = "Amount of enemies to use Primal Wrath."
					},    
                    M = {},
                }, 				
            },
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },
			{
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Barkskin",
                    DBV = 70, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Barkskin HP (%)"
					}, 
                    TT = { 
                        ANY = "HP % to use Barkskin."
					},    
                    M = {},
                }, 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SurvivalInstincts",
                    DBV = 35, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Survival Instincts HP (%)"
					}, 
                    TT = { 
                        ANY = "HP % to use Survival Instincts."
					},    
                    M = {},
                }, 				
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FrenziedRegeneration",
                    DBV = 40, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Frenzied Regeneration HP (%)"
					}, 
                    TT = { 
                        ANY = "Only works with Guardian Affinity. Will try to keep you locked into Bear Form for optimal duration."
					},    
                    M = {},
                }, 			
			    {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SpiritualHealingPotionHP",
                    DBV = 30, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Spiritual Healing Potion HP (%)"
					}, 
                    TT = { 
                        ANY = "HP % to use Spiritual Healing Potion."
					},    
                    M = {},
                },
			},	
		},	
		[ACTION_CONST_DRUID_BALANCE] = {             
		},
        [ACTION_CONST_DRUID_GUARDIAN] = {
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
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Rotation Settings -- ",
                    },
                },
            },
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },			
            {
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
    			{
                    E = "Checkbox", 
                    DB = "OffensiveRage",
                    DBV = true,
                    L = { 
                        enUS = "Offensive Rage use", 
                        ruRU = "Offensive Rage use",
                        frFR = "Offensive Rage use",
                    }, 
                    TT = { 
                        enUS = "If activated, will priorize dps over survivability.", 
                        ruRU = "If activated, will priorize dps over survivability.",  
                        frFR = "If activated, will priorize dps over survivability.",  
                    }, 
                    M = {},
                },
			}, 
            { -- [2] 2nd Row 
                {
                    E = "Checkbox", 
                    DB = "SoloMode",
                    DBV = false,
                    L = { 
                        enUS = "Enable Solo Mode", 
                        ruRU = "Включить Solo Mode",  
                        frFR = "Activez le mode solo", 
                    }, 
                    TT = { 
                        enUS = "Activate Solo Mode and priorize survivability over the rest.\nUseful for low level chars or during leveling phase", 
                        ruRU = "Активируйте Solo Mode и установите приоритет выживаемости над остальными.\nПолезно для персонажей низкого уровня или во время фазы прокачки.", 
                        frFR = "Activez le mode solo et priorisez la survie par rapport au reste.\nUtile pour les caractères de bas niveau ou pendant la phase de leveling.", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "UseStampedingRoar",
                    DBV = true,
                    L = { 
                        enUS = "Auto" .. GetSpellInfo(77761), 
                        ruRU = "Авто" .. GetSpellInfo(77761), 
                        frFR = "Auto" .. GetSpellInfo(77761), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(77761), 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(77761), 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(77761), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "StampedingRoarTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(77761) .. " if moving for",
                    }, 
                    TT = { 
                        enUS = "If " .. GetSpellInfo(77761) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. GetSpellInfo(77761) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. GetSpellInfo(77761) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
                    }, 
                    M = {},
                },				
            },
            { -- Lucid Dream
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(299374) .. " -- ",
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
                        enUS = GetSpellInfo(299374) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(299374) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(299374) .. "\n<= time to die (sec)",  
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
                        enUS = GetSpellInfo(299374) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(299374) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(299374) .. "\n<= health (%)", 
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
            { -- [1] Barkskin  	
                {
                    E = "Checkbox", 
                    DB = "BarkskinIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(22812) .. "\nSkip if " .. GetSpellInfo(61336) .. " used",
                        ruRU = GetSpellInfo(22812) .. "\nSkip if " .. GetSpellInfo(61336) .. " used",  
                        frFR = GetSpellInfo(22812) .. "\nSkip if " .. GetSpellInfo(61336) .. " used", 
                    }, 
                    M = {},
                }, 		    
                {
                    E = "Checkbox", 
                    DB = "BarkskinCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(22812) .. "\nCatch death hit",
                        ruRU = GetSpellInfo(22812) .. "\nCatch death hit",  
                        frFR = GetSpellInfo(22812) .. "\nCatch death hit", 
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
                    DB         = "BarkskinTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(22812) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(22812) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(22812) .. "\n<= time to die (sec)",  
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
                    DB         = "BarkskinHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(22812) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(22812) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(22812) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
            { -- [1] SurvivalInstincts			    
                {
                    E = "Checkbox", 
                    DB = "SurvivalInstinctsCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(61336) .. "\nCatch death hit",
                        ruRU = GetSpellInfo(61336) .. "\nCatch death hit",  
                        frFR = GetSpellInfo(61336) .. "\nCatch death hit", 
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
                    DB         = "SurvivalInstinctsTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(61336) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(61336) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(61336) .. "\n<= time to die (sec)",  
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
                    DB         = "SurvivalInstinctsHP",
                    DBV     = 20,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(61336) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(61336) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(61336) .. "\n<= health (%)", 
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
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "LunarBeamHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(204066) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FrenziedRegenerationHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(22842) .. " (%)",
                    }, 
                    M = {},
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SurvivalInstinctsHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(61336) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "IronfurHPLost",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(192081) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "BristlingFurRage",
                    DBV = 70, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(155835) .. "\nmin rage",
                    }, 
                    TT = { 
                        enUS = "Minimum rage required before using Bristling Fur", 
                        ruRU = "Minimum rage required before using Bristling Fur", 
                    }, 
                    M = {},
                },
            },
            { -- [4] Potions 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SpiritualHealingPotionHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Spiritual Healing Potion HP (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "PhialOfSerenityHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Phial of Serenity HP (%)",
                    }, 
                    M = {},
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
					MIN 	= 1, 
					MAX 	= 5,							
					DB 		= "MultiDotDistance",
					DBV 	= 5,
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
                        ANY = "PvP " .. GetSpellInfo(5782),
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
                        ANY = "PvP " .. GetSpellInfo(5782) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_DRUID_RESTORATION] = { 
            LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            }, 
			{
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
			},
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",                                                                         
                },
            },				
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< ROTATION CHANGES ><><><l ",
                    },
                },
            }, 
			{
                {
                    E = "Checkbox", 
                    DB = "AutoShift",
                    DBV = true,
                    L = { 
                        ANY = "Auto Form Shift" 
                    }, 
                    TT = { 
                        ANY = "Automatically switch forms based on your affinity."
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "UseDispel",
                    DBV = true,
                    L = { 
                        ANY = "Auto Dispel" 
                    }, 
                    TT = { 
                        ANY = "Automatically Dispel from your Aura List."
                    }, 
                    M = {},
                },	
                {
                    E = "Checkbox", 
                    DB = "DarkTitan",
                    DBV = false,
                    L = { 
                        ANY = "The Dark Titan's Lesson" 
                    }, 
                    TT = { 
                        ANY = "Check this if you're using The Dark Titan's Lesson."
                    }, 
                    M = {},
                },	
                {
                    E = "Checkbox", 
                    DB = "EfflorescenceOnSelf",
                    DBV = false,
                    L = { 
                        ANY = "Efflorescence on self" 
                    }, 
                    TT = { 
                        ANY = "Automatically drop Efflorescence on yourself (NOTE: YOU NEED TO SET YOUR EFFLORESCENCE MACRO TO /CAST [@PLAYER]"
                    }, 
                    M = {},
                },					
            },
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Barkskin",
                    DBV = 75,
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(22812) .. " (%)",
                    }, 
                    M = {},
                }, 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FrenziedRegeneration",
                    DBV = 30,
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(22842) .. " (%)",
                    }, 
                    M = {},
                },
			},
			{
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Renewal",
                    DBV = 40,
                    ONOFF = true,
                    L = { 
                        ANY = "Renewal (%)",
                    }, 
                    M = {},
                },				
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SpiritualHealingPotionHP",
                    DBV = 30,
                    ONOFF = true,
                    L = { 
                        ANY = "Spiritual Healing Potion (%)",
                    }, 
                    M = {},
                },			
            },   
        },
    },
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_DRUID_FERAL] = { 
            ["stun"] = { Enabled = true, Key = "LegSweep", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.LegSweep:IsReadyM(thisunit, true) and 
                        (
                            not IsInPvP and 
                            MultiUnits:GetByRange(5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0), 1) >= 1                            
                        ) or 
                        (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0))
                        )                                                     
            ]] },
            ["disarm"] = { Enabled = true, Key = "GrappleWeapon", LUAVER = 5, LUA = [[
                return     GrappleWeaponIsReady(thisunit, true)
            ]] },
            ["freedom"] = { Enabled = true, Key = "TigersLust", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.TigersLust:IsReadyM(thisunit) and 
                        A.TigersLust:AbsentImun(thisunit) and 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
            ["dispel"] = { Enabled = true, Key = "Detox", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.Detox:IsReadyM(thisunit) and 
                        A.Detox:AbsentImun(thisunit) and 
                        AuraIsValid(thisunit, "UseDispel", "Dispel") and                                                 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
        },
        [ACTION_CONST_DRUID_GUARDIAN] = { 
            ["stun"] = { Enabled = true, Key = "LegSweep", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.LegSweep:IsReadyM(thisunit, true) and 
                        (
                            not IsInPvP and 
                            MultiUnits:GetByRange(5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0), 1) >= 1                            
                        ) or 
                        (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0))
                        )                                                     
            ]] },
            ["disarm"] = { Enabled = true, Key = "GrappleWeapon", LUAVER = 5, LUA = [[
                return     GrappleWeaponIsReady(thisunit, true)
            ]] },
            ["freedom"] = { Enabled = true, Key = "TigersLust", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.TigersLust:IsReadyM(thisunit) and 
                        A.TigersLust:AbsentImun(thisunit) and 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
            ["dispel"] = { Enabled = true, Key = "Detox", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.Detox:IsReadyM(thisunit) and 
                        A.Detox:AbsentImun(thisunit) and 
                        AuraIsValid(thisunit, "UseDispel", "Dispel") and                                                 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
        },
        [ACTION_CONST_DRUID_BALANCE] = { 
            ["stun"] = { Enabled = true, Key = "LegSweep", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.LegSweep:IsReadyM(thisunit, true) and 
                        (
                            not IsInPvP and 
                            MultiUnits:GetByRange(5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0), 1) >= 1                            
                        ) or 
                        (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0))
                        )                                                     
            ]] },
            ["disarm"] = { Enabled = true, Key = "GrappleWeapon", LUAVER = 5, LUA = [[
                return     GrappleWeaponIsReady(thisunit, true)
            ]] },
            ["freedom"] = { Enabled = true, Key = "TigersLust", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.TigersLust:IsReadyM(thisunit) and 
                        A.TigersLust:AbsentImun(thisunit) and 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
            ["dispel"] = { Enabled = true, Key = "Detox", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.Detox:IsReadyM(thisunit) and 
                        A.Detox:AbsentImun(thisunit) and 
                        AuraIsValid(thisunit, "UseDispel", "Dispel") and                                                 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
        },
        [ACTION_CONST_DRUID_RESTORATION] = {    
            ["stun"] = { Enabled = true, Key = "LegSweep", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.LegSweep:IsReadyM(thisunit, true) and 
                        (
                            not IsInPvP and 
                            MultiUnits:GetByRange(5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0), 1) >= 1                            
                        ) or 
                        (
                            IsInPvP and 
                            EnemyTeam():PlayersInRange(1, 5 + (A.TigerTailSweep:IsSpellLearned() and 2 or 0))
                        )                                                     
            ]] },
            ["disarm"] = { Enabled = true, Key = "GrappleWeapon", LUAVER = 5, LUA = [[
                return     GrappleWeaponIsReady(thisunit, true)
            ]] },
            ["freedom"] = { Enabled = true, Key = "TigersLust", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.TigersLust:IsReadyM(thisunit) and 
                        A.TigersLust:AbsentImun(thisunit) and 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
            ["dispel"] = { Enabled = true, Key = "Detox", LUAVER = 5, LUA = [[
                local A = Action[ACTION_CONST_MONK_MISTWEAVER]
                return     A.Detox:IsReadyM(thisunit) and 
                        A.Detox:AbsentImun(thisunit) and 
                        AuraIsValid(thisunit, "UseDispel", "Dispel") and                                                 
                        LossOfControl:IsMissed("SILENCE") and 
                        LossOfControl:Get("SCHOOL_INTERRUPT", "NATURE") == 0
            ]] },
        },
    },
}

-----------------------------------------
--                   PvP  
-----------------------------------------
function A.MightyBashIsReady(unit, isMsg, skipShouldStop)
    if A[A.PlayerSpec].MightyBash then 
        local unitID = A.GetToggle(2, "MightyBashPvPunits")
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
                A.GetToggle(2, "MightyBashPvP") ~= "OFF" and 
                A[A.PlayerSpec].MightyBash:IsReady(unit, nil, nil, skipShouldStop) and 
                Unit(unit):IsMelee() and 
                (
                    A.GetToggle(2, "MightyBashPvP") == "ON COOLDOWN" or 
                    Unit(unit):HasBuffs("DamageBuffs") > 3 
                )
            ) or 
            (
                isMsg and 
                A[A.PlayerSpec].MightyBash:IsReadyM(unit)                     
            )
        ) and 
        Unit(unit):IsPlayer() and                     
        A[A.PlayerSpec].MightyBash:AbsentImun(unit, {"CCTotalImun", "DamagePhysImun", "TotalImun"}, true) and 
        Unit(unit):IsControlAble("stun", 0) and 
        Unit(unit):HasDeBuffs("Stunned") == 0
    end 
end
 

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].Kick and A[A.PlayerSpec].Kick:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Kick:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp")  then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "CyclonePvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Cyclone and A[A.PlayerSpec].Cyclone:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Cyclone:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("disorient", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end
    local Toggle2 = A.GetToggle(2, "MightyBashPvP")    
    if Toggle2 and Toggle2 ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Cyclone and A[A.PlayerSpec].Cyclone:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Cyclone:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("disorient", 0) then 
        if Toggle2 == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle2, true))         
        end 
    end 
	
end 

