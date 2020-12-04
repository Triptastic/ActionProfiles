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
    DateTime = "v1.1.0 (26 November 2020)",
    -- Class settings
    [2] = {
        [ACTION_CONST_DRUID_FERAL] = {             
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
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "In Raid", value = 1 },
                        { text = "In Dungeon", value = 2 },
						{ text = "In PvP", value = 3 },
                        { text = "Everywhere", value = 4 },
                    },
                    MULT = true,
                    DB = "AutoStealthOOC",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    },  
                    L = { 
                        enUS = "AutoStealth where", 
                        ruRU = "AutoStealth где", 
                        frFR = "AutoStealth où", 
                    }, 
                    TT = { 
                        enUS = "Choose where you want to automatically AutoStealth.", 
                        ruRU = "Choose where you want to automatically AutoStealth.", 
						frFR = "Choose where you want to automatically AutoStealth.", 
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
			},
			{
                {
                    E = "Checkbox", 
                    DB = "AutoCatForm",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. A.GetSpellInfo(768), 
                        ruRU = "Авто " .. A.GetSpellInfo(768), 
                        frFR = "Auto " .. A.GetSpellInfo(768), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. A.GetSpellInfo(768), 
                        ruRU = "Автоматически использовать " .. A.GetSpellInfo(768), 
                        frFR = "Utiliser automatiquement " .. A.GetSpellInfo(768), 
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
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
                },
            },				
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Self Defensives -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "SurvivalInstincts",
                    DBV = 100, -- Set healthpercentage @99% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(61336) .. " (%)",
                    }, 
                    M = {},
                },
            },				
		}, -- End Feral
		[ACTION_CONST_DRUID_BALANCE] = {             
            { -- [1]                            
				{
					E 		= "Checkbox", 
					DB 		= "mouseover",
					DBV 	= true,
					L 		= { 
                        ANY	= "Use\n@mouseover", 
                    }, 
                    TT 		= { 
                        ANY = "Will unlock use actions for @mouseover units\nExample: Pummel, Charge,  Intercept, Disarm",
					}, 
					M 		= {},
                },
                {
					E 		= "Checkbox", 
					DB 		= "AoE",
					DBV 	= true,
					L 		= { 
                        ANY	= "Use AoE",
                    }, 
                    TT 		= { 
                        ANY = "Enable multiunits actions",
					}, 
					M 		= {},
                },		
                {
					E 		= "Checkbox", 
					DB 		= "AutoMoonkinForm",
					DBV 	= true,
					L 		= { 
                        ANY	= "Auto " .. A.GetSpellInfo(24858),
                    }, 
                    TT 		= { 
                        ANY = "Auto use " .. A.GetSpellInfo(24858),
					}, 
					M 		= {},
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

			{ -- [4]
                {
                    E		= "Header",
					L		= { 
                        ANY = " -- Dot Refresh -- ",
                    },
                },
            },
            {
				{
                    E 		= "Slider", 													
					MIN 	= 1, 
					MAX 	= 10,							
					DB 		= "SunfireRefresh",
					DBV 	= 5.4,
					Precision = 1,
					ONLYOFF = true,
					L 		= { 
                        enUS = A.GetSpellInfo(93402) .. "\nRefresh", 
                        ruRU = A.GetSpellInfo(93402) .. "\nRefresh",  
                        frFR = A.GetSpellInfo(93402) .. "\nRefresh", 
                    }, 
					TT		= { 
                        enUS = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(93402), 
                        ruRU = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(93402), 
						frFR = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(93402), 
                    },
					M 		= {},
                },
				{
                    E 		= "Slider", 													
					MIN 	= 1, 
					MAX 	= 10,							
					DB 		= "MoonfireRefresh",
					DBV 	= 5.4,
					Precision = 1,
					ONLYOFF = true,
					L 		= { 
                        enUS = A.GetSpellInfo(8921) .. "\nRefresh", 
                        ruRU = A.GetSpellInfo(8921) .. "\nRefresh",  
                        frFR = A.GetSpellInfo(8921) .. "\nRefresh", 
                    }, 
					TT		= { 
                        enUS = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(8921), 
                        ruRU = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(8921), 
						frFR = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(8921), 
                    },
					M 		= {},
                },
				{
                    E 		= "Slider", 													
					MIN 	= 1, 
					MAX 	= 10,							
					DB 		= "StellarFlareRefresh",
					DBV 	= 5.4,
					Precision = 1,
					ONLYOFF = true,
					L 		= { 
                        enUS = A.GetSpellInfo(202347) .. "\nRefresh", 
                        ruRU = A.GetSpellInfo(202347) .. "\nRefresh",  
                        frFR = A.GetSpellInfo(202347) .. "\nRefresh", 
                    }, 
					TT		= { 
                        enUS = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(202347), 
                        ruRU = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(202347), 
						frFR = "Choose the remaining time in seconds before refreshing " .. A.GetSpellInfo(202347), 
                    },
					M 		= {},
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
					MAX 	= 30,							
					DB 		= "MultiDotDistance",
					DBV 	= 40,
					ONLYOFF = false,
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
                    DBV = "Everywhere", 
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
				{
                    E 		= "Slider", 													
					MIN 	= 5, 
					MAX 	= 15,							
					DB 		= "MultiDotMaxUnits",
					DBV 	= 8,
					ONLYOFF = false,
					L 		= { 
                        enUS = "Multidots\nMax Units", 
                        ruRU = "Multidots\nMax Units", 
                        frFR = "Multidots\nMax Units",  
                    }, 
					TT		= { 
                        enUS = "Choose the maximum units in range to automatically multidots.", 
                        ruRU = "Choose the maximum units in range to automatically multidots.",
						frFR = "Choose the maximum units in range to automatically multidots.",
                    }, 
					M 		= {},
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
                    DBV = 8, -- Set healthpercentage @60% life. 
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
                    MAX = 30,                            
                    DB = "FocusedAzeriteBeamTTD",
                    DBV = 5, -- Set healthpercentage @30% life. 
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
                    DBV = 2, -- Set healthpercentage @60% life. 
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
                    DBV = 30, -- Set healthpercentage @60% life. 
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
            { -- [4] 4th Row

                {
                    E = "LayoutSpace",                                                                         
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
			{ -- [6]
                {
                    E 		= "Header",
					L		= { 
                        ANY = " -- Defensives -- ",
                    },
                },
            },
			{
				{
                    E 		= "Slider", 													
					MIN 	= -1,
                    MAX 	= 100,  						
					DB 		= "BarkskinHP",
					DBV 	= 35,
					ONOFF 	= true,
					L 		= { 
                        ANY	= A.GetSpellInfo(22812) .. " (%)"
                    },
					M 		= {},
                },
			},
			{
				{
                    E 		= "Slider", 													
					MIN 	= -1, 
                    MAX 	= 100,  						
					DB 		= "RenewalHP",
					DBV 	= 40,
					ONOFF 	= true,
					L 		= { 
                        ANY	= A.GetSpellInfo(108238) .. " (%)"
                    },
					M 		= {},
                },
				{
                    E 		= "Slider", 													
					MIN 	= -1, 
                    MAX 	= 100,  						
					DB 		= "AbyssalPot",
					DBV 	= 20,
					ONOFF 	= true,
					L 		= { 
                        ANY	= "Abyssal Healing Potion (%)"
                    },
					M 		= {},
                },	
			},
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
                    DB = "SuperiorSteelskinPotionHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(298155) .. " (%)",
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
                        ANY = GetSpellInfo(301308) .. " (%)",
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
            },
            {			
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
					    enUS = "Begin Combat\nBy PreHot",
                        ruRU = "Начинать Бой\nЗаранее произнося", 
	                },
           	        TT = { 
					    enUS = "Will start rotation on enemy by available longer\ncasting spell depended on your spec",
                        ruRU = "Будет начинать ротация на противнике с доступной\nдлинной произносящейся способности в зависимости от спека",
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
                {
                    E = "Checkbox", 
                    DB = "AutoDispel",
                    DBV = true,
                    L = { 
					    enUS = "Activate auto dispel of friendly team",
                        ruRU = "Activate auto dispel of friendly team",
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
         	        DB = "SnipeFriendly",
         	        DBV = true,
         	        L = { 
					    enUS = "Snipe Friendly",
                        ruRU = "Snipe Friendly",
					},
          	        TT = { 
					    enUS = "Enable this option to predict critical healing and instant target unit depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
                        ruRU = "Enable this option to predict critical healing and instant target unit depending of the current dungeon.\nExample:Fulminating Zap in Junkyard",
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
            { -- [2]
                {
                    E = "Header",
                    L = {
                        enUS = " -- Self Defensives -- ",
                        ruRU = " -- Своя Оборона -- ",
                    },
                },
            }, 
            { -- [3]     
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 85,                            
                    DB = "Barkskin",
                    DBV = 85,
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
                    DB = "Stoneform",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(20594) .. " (%)",                        
                    }, 
                    M = {},
                },
            }, 
            { -- [4]    
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Ironbark",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(102342) .. " (%)",                        
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "BearForm",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(5487) .. " (%)",
                    }, 
                    M = {},
                },
            }, 
            { -- [5]    
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DiffuseMagic",
                    DBV = 100,
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(122783) .. " (%)",                        
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "ManaPotion",
                    DBV = 20,
                    ONLYOFF = true,
                    L = { 
                        ANY = A.GetLocalization()["TAB"][1]["POTION"] .. " (Mana %)",
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
                        ANY = " -- Force Spread Macro -- ",
                    },
                },
            },	
            {			
                {
                    E         = "Button",
                    H         = 35,
                    OnClick = function(self, button, down)     
                        if button == "LeftButton" then 
							TR.ToggleForceRejuvenation()
                        else                
                            Action.CraftMacro("QB:BurstHeal", [[#showtip ]] .. Action[ACTION_CONST_DRUID_RESTORATION].Rejuvenation:Info() .. "\n" .. [[/run Action.TasteRotation.ToggleForceRejuvenation(state)]], 1, true, true) 
                        end 
                    end, 
                    L = { 
                        ANY = "Burst\nMacro Creator",
                    }, 
                    TT = { 
                        enUS = "Click this button to create the special " .. A.GetSpellInfo(774) .. " macro.\n@USAGE: Create the macro and add it to your spellbar or keybind it. Then if you know some big damage are incoming, just press once to spread Rejuvenation on max units and press again to stop.", 
                        ruRU = "Click this button to create the special " .. A.GetSpellInfo(774) .. " macro.\n@USAGE: Create the macro and add it to your spellbar or keybind it. Then if you know some big damage are incoming, just press once to spread Rejuvenation on max units and press again to stop.", 
                        frFR = "Click this button to create the special " .. A.GetSpellInfo(774) .. " macro.\n@USAGE: Create the macro and add it to your spellbar or keybind it. Then if you know some big damage are incoming, just press once to spread Rejuvenation on max units and press again to stop.", 
                    },                           
                },
            },				
            { -- LIFEBLOOM
                {
                    E = "Header",
                    L = {
                        ANY = A.GetSpellInfo(33763),
                    },
                },
            }, 
            { -- [11] 
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "LifebloomHP",
                    DBV = 100,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(33763) .. " (%)",                        
                    }, 
                    TT = { 
                        enUS = "Offset Health Percent on which start casting 'Lifebloom'", 
                        ruRU = "Значение Процента Здоровья на котором начинать произносить 'Lifebloom'", 
                    },
                    M = {},
                }, 			
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Auto", value = "Auto" },    
                        { text = "Tanking Units", value = "Tanking Units" },                    
                        { text = "Mostly Inc. Damage", value = "Mostly Inc. Damage" },
                    },
                    DB = "LifebloomWorkMode",
                    DBV = "Auto",
                    L = { 
                        ANY = A.GetSpellInfo(33763) .. " Work Mode",
                    }, 
                    TT = { 
                        enUS = "These conditions will activate differents logic behind.\nAuto: Fully automated settings, priorise Photosynthesis on you if talent is learned.\nTanking Units: Will make sure Lifebloom is always present on tanks.\nMostly Inc. Damage: Friendly unit taking the more damage in the current situation.", 
                        ruRU = "These conditions will activate differents logic behind.\nAuto: Fully automated settings, priorise Photosynthesis on you if talent is learned.\nTanking Units: Will make sure Lifebloom is always present on tanks.\nMostly Inc. Damage: Friendly unit taking the more damage in the current situation.",
                    },                    
                    M = {},
                },
            }, 
			
			
            { -- TRANQUILITY
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. A.GetSpellInfo(740) .. " -- ",
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
            -- Tranquility
            { -- [3] 
              	RowOptions = { margin = { top = 10 } },		
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "TranquilityRaidUnits",
                    DBV = 5,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(740) .. "\n(Total Units)",    
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "TranquilityPartyUnits",
                    DBV = 3,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(740) .. "\n(Total Units)",    
                    },                     
                    M = {},
                },
			},
			{
			    RowOptions = { margin = { top = 10 } },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "TranquilityRaidHP",
                    DBV = 65,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(740) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "TranquilityPartyHP",
                    DBV = 60,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(740) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },			    
            },	
            { -- FLOURISH
                {
                    E = "Header",
                    L = {
                        ANY = A.GetSpellInfo(197721),
                    },
                },
            }, 
            { -- [13]    
                RowOptions = { margin = { top = 10 } },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "FlourishHP",                    
                    DBV = 70,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(197721) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "FlourishUnits",
                    DBV = 4,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(197721) .. "\n(Total Units)",    
                    },                     
                    M = {},
                },
            },
            { -- EFFLORESCENCE
                {
                    E = "Header",
                    L = {
                        ANY = A.GetSpellInfo(145205),
                    },
                },
            }, 		
            { -- [10]
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "EfflorescenceRefresh",
                    DBV = 2,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(145205) .. "\nrefresh(sec)",                        
                    }, 
                    TT = { 
                        enUS = "Time remaining in seconds before refreshing " .. A.GetSpellInfo(145205), 
                        ruRU = "Time remaining in seconds before refreshing " .. A.GetSpellInfo(145205), 
                    },
                    M = {},
                },            
            },			
            { -- [10]
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "SwiftmendHP",
                    DBV = 85,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(18562) .. " (%)",                        
                    }, 
                    TT = { 
                        enUS = "Offset Health Percent on which start casting 'Swiftmend'", 
                        ruRU = "Значение Процента Здоровья на котором начинать произносить 'Swiftmend'", 
                    },
                    M = {},
                },            
            },
            { -- [14]    
                RowOptions = { margin = { top = 10 } },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "WildGrowthHP",                    
                    DBV = 93,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(48438) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "WildGrowthUnits",
                    DBV = 3,
                    ONLYON = true,
                    L = { 
                        ANY = A.GetSpellInfo(48438) .. "\n(Total Units)",    
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
            { -- [17]
                {
                    E = "Header",
                    L = {
                        ANY = " -- PvP -- ",
                    },
                },
            }, 
            { -- [18]
                {
                    E = "Checkbox", 
                    DB = "MouseButtonsCheck",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(145205) .. "\nCheck Mouse Buttons", 
                        ruRU = A.GetSpellInfo(145205) .. "\nПроверять Кнопки Мышки", 
                    }, 
                    TT = { 
                        enUS = "Prevents use if the camera is currently spinning with the mouse button held down", 
                        ruRU = "Предотвращает использование если камера в текущий момент крутится с помощью зажатой кнопки мыши", 
                    }, 
                    M = {},
                },
            }, 
            { -- [19]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "CyclonePvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(33786),
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
                    DB = "CyclonePvPunits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(33786) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
            { -- [19]
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON MELEE BURST", value = "ON MELEE BURST" },
                        { text = "ON COOLDOWN", value = "ON COOLDOWN" },                    
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "MightyBashPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(5211),
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
                    DB = "MightyBashPvPunits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. A.GetSpellInfo(5211) .. " units",
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

