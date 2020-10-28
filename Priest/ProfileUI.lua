--############################
--##### TRIP'S PRIESTUI ######
--############################

-- Full credit to Taste

local TMW                                            = TMW 
local CNDT                                            = TMW.CNDT
local Env                                            = CNDT.Env
local A                                                = Action
local GetToggle                                        = A.GetToggle
local InterruptIsValid                                = A.InterruptIsValid
local UnitCooldown                                    = A.UnitCooldown
local Unit                                            = A.Unit 
local Player                                        = A.Player 
local Pet                                            = A.Pet
local LoC                                            = A.LossOfControl
local MultiUnits                                    = A.MultiUnits
local EnemyTeam                                        = A.EnemyTeam
local FriendlyTeam                                    = A.FriendlyTeam
local TeamCache                                        = A.TeamCache
local InstanceInfo                                    = A.InstanceInfo
local TR                                            = Action.TasteRotation
local select, setmetatable                            = select, setmetatable

-- Shadowlands Spell Info fix for empty spells
local GetSpellInfo_original                                = _G.GetSpellInfo
local function GetSpellInfo(...)
    return GetSpellInfo_original(...) or ""
end

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI                                     = {    
    DateTime = "v1.0 (28 Oct 2020)",
    [2] = {        
        [ACTION_CONST_PRIEST_SHADOW] = {             
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
            { -- [2]
                {
                    E = "Checkbox", 
                    DB = "ByPassSpells",
                    DBV = true,
                    L = { 
                        enUS = "ByPassSpells", 
                    }, 
                    TT = { 
                        enUS = "Spells\nWill stop channeling",
                    }, 
                    M = {},
                },         
                {
                    E = "Checkbox", 
                    DB = "SpellsTiming",
                    DBV = false,
                    L = { 
                        enUS = "Spells\nVoid Bolt timed",
                    }, 
                    TT = { 
                        enUS = "Spells will not be used if Void Bolt will be up within next GCD",
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
                    E         = "Slider",                                                     
                    MIN     = 5, 
                    MAX     = 40,                            
                    DB         = "MultiDotDistance",
                    DBV     = 35,
                    ONLYOFF = true,
                    L         = { 
                        enUS = "Multidots Range", 
                        ruRU = "Сфера Multidots", 
                        frFR = "Portée du Multidots", 
                    }, 
                    TT        = { 
                        enUS = "Choose the range where you want to automatically multidots units.", 
                        ruRU = "Выберите диапазон, в котором вы хотите автоматически многоточечные единицы.", 
                        frFR = "Choisissez la portée dans laquelle vous souhaitez multidoter automatiquement les unités.", 
                    }, 
                    M         = {},
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
            { -- [7]  Azerite Beam settings
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(295258) .. " -- ",
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
                        ANY = GetSpellInfo(295258) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the minimum Time To Die for a unit before using " .. GetSpellInfo(295258) .. " \nDoes not apply to Boss.", 
                        ruRU = "Установите минимальное время смерти для отряда перед использованием " .. GetSpellInfo(295258) .. " \nНе применимо к боссу.", 
                        frFR = "Définissez le temps minimum pour mourir pour une unité avant d'utiliser " .. GetSpellInfo(295258) .. " \nNe s'applique pas aux boss.", 
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
                        ANY = GetSpellInfo(295258) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the minimum Time To Die for a unit before using " .. GetSpellInfo(295258) .. " \nDoes not apply to Boss.", 
                        ruRU = "Установите минимальное время смерти для отряда перед использованием " .. GetSpellInfo(295258) .. " \nНе применимо к боссу.", 
                        frFR = "Définissez le temps minimum pour mourir pour une unité avant d'utiliser " .. GetSpellInfo(295258) .. " \nNe s'applique pas aux boss.", 
                    },                     
                    M = {},
                },                 
            },
            { -- [7] UnbridledFuryAuto
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(300714) .. " -- ",
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
                    MAX = 60,                          
                    DB = "UnbridledFuryTTD",
                    DBV = 40, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(300714) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the minimum Time To Die for a unit before using " .. GetSpellInfo(300714) .. " \nDoes not apply to Boss.", 
                        ruRU = "Установите минимальное время смерти для отряда перед использованием " .. GetSpellInfo(300714) .. " \nНе применимо к боссу.", 
                        frFR = "Définissez le temps minimum pour mourir pour une unité avant d'utiliser " .. GetSpellInfo(300714) .. " \nNe s'applique pas aux boss.", 
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
            { -- [3]
                {
                    E = "Header",
                    L = {
                        enUS = " -- Defensives -- ",
                    },
                },
            }, 
            { -- [4]     
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "VampiricEmbrace",
                    DBV = 60, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(15286) .. " (%)",
                    }, 
                    M = {},
                },
                {                    
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Dispersion",
                    DBV = 60, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(47585) .. " (%)",
                    }, 
                    M = {},
                },
            }, 
        },
        
        [ACTION_CONST_PRIEST_DISCIPLINE] = {          
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
            },
            {            
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
                {        
                    E = "Checkbox", 
                    DB = "HE_Absorb",
                    DBV = true,
                    L = { 
                        enUS = "Calculate Absorb",
                        ruRU = "Calculate Absorb",
                    },
                    TT = { 
                        enUS = "Will auto calculate absorb to avoid wasting of refresh spells if they got absorb superior than spell that gonna be casted",
                        ruRU = "Will auto calculate absorb to avoid wasting of refresh spells if they got absorb superior than spell that gonna be casted",
                    },
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "SpellKick",
                    DBV = true,
                    L = { 
                        enUS = "Spell Kick",
                        ruRU = "Spell Kick",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use your kicking spells.",
                        ruRU = "Enable this option to automatically use your kicking spells.",
                    },
                    M = {},
                },
            },
            {                            
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "SwitchFriendlyTTD",                    
                    DBV = 4,
                    ONLYON = true,
                    L = { 
                        ANY = "Urgent switch\nto friendly TTD(sec)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "SwitchFriendlyHP",                    
                    DBV = 45,
                    ONLYON = true,
                    L = { 
                        ANY = "Urgent switch\nto friendly HP(%)",                        
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
                        ANY = GetSpellInfo(299374) .. "\nMana %",                        
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
                        ANY = GetSpellInfo(299944) .. "\nunits number",                        
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
                        ANY = GetSpellInfo(299944) .. "\n(%)",                        
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
            { -- Penance
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(47540) .. " -- ",
                    },
                }, 
            },
            {
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "BOTH", value = "BOTH" },
                        { text = "HEAL", value = "HEAL" },    
                        { text = "DMG", value = "DMG" },                    
                    },
                    DB = "PenanceWorkMode",
                    DBV = "BOTH",
                    L = { 
                        ANY = GetSpellInfo(47540) .. " Work Mode",
                    }, 
                    TT = { 
                        enUS = "These conditions will be skiped if unit will dying in emergency (critical) situation", 
                        ruRU = "Эти условия будут пропущены если юнит будет умирать в чрезвычайной (критической) ситуациии", 
                    },                    
                    M = {},
                },
            },     
            { -- Angelic Feather
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
                    DB = "AngelicFeather",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(121536),
                        ruRU = "Auto\n" .. GetSpellInfo(121536),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(121536),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(121536),
                    },
                    M = {},
                },    
                {
                    E = "Checkbox", 
                    DB = "LeapofFaith",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(73325),
                        ruRU = "Auto\n" .. GetSpellInfo(73325),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(73325),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(73325),
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
                    DB = "Dispel",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(528),
                        ruRU = "Auto\n" .. GetSpellInfo(528),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(528),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(528),
                    },
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "MassDispel",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(32375),
                        ruRU = "Auto\n" .. GetSpellInfo(32375),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(32375),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(32375),
                    },
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "Purje",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(527),
                        ruRU = "Auto\n" .. GetSpellInfo(527),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(527),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(527),
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
        [ACTION_CONST_PRIEST_HOLY] = {          
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
            },
            {            
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
                {        
                    E = "Checkbox", 
                    DB = "HE_Absorb",
                    DBV = true,
                    L = { 
                        enUS = "Calculate Absorb",
                        ruRU = "Calculate Absorb",
                    },
                    TT = { 
                        enUS = "Will auto calculate absorb to avoid wasting of refresh spells if they got absorb superior than spell that gonna be casted",
                        ruRU = "Will auto calculate absorb to avoid wasting of refresh spells if they got absorb superior than spell that gonna be casted",
                    },
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "SpellKick",
                    DBV = true,
                    L = { 
                        enUS = "Spell Kick",
                        ruRU = "Spell Kick",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use your kicking spells.",
                        ruRU = "Enable this option to automatically use your kicking spells.",
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
                        ANY = GetSpellInfo(299374) .. "\nMana %",                        
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
                        ANY = GetSpellInfo(299944) .. "\nunits number",                        
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
                        ANY = GetSpellInfo(299944) .. "\n(%)",                        
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
            { -- GuardianSpiritSelfDeff
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(47788) .. " -- ",
                    },
                }, 
            },
            {
                {
                    E = "Checkbox", 
                    DB = "GuardianSpiritSelfDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(47788) .. " Self Deff",
                        ruRU = GetSpellInfo(47788) .. " Self Deff",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(47788) .. " for Self defense.",
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(47788) .. " for Self defense.",
                    },
                    M = {},
                },    
                {
                    E = "Checkbox", 
                    DB = "GuardianSpiritTeamDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(47788) .. " Team Deff",
                        ruRU = GetSpellInfo(47788) .. " Team Deff",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(47788) .. " for Team deffense.",
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(47788) .. " for Team deffense.",
                    },
                    M = {},
                },    
            },     
            { -- Renew
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(139) .. " -- ",
                    },
                }, 
            },
            {
                {
                    E = "Checkbox", 
                    DB = "RenewRefresh",
                    DBV = false,
                    L = { 
                        enUS = GetSpellInfo(139) .. " Force Refresh",
                        ruRU = GetSpellInfo(139) .. " Force Refresh",
                    },
                    TT = { 
                        enUS = "Enable this option to automatically force " .. GetSpellInfo(139) .. " refreshment on every units.",
                        ruRU = "Enable this option to automatically force " .. GetSpellInfo(139) .. " refreshment on every units.",
                    },
                    M = {},
                },        
            },     
            { -- Angelic Feather
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
                    DB = "AngelicFeather",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(121536),
                        ruRU = "Auto\n" .. GetSpellInfo(121536),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(121536),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(121536),
                    },
                    M = {},
                },    
                {
                    E = "Checkbox", 
                    DB = "LeapofFaith",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(73325),
                        ruRU = "Auto\n" .. GetSpellInfo(73325),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(73325),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(73325),
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
                    DB = "Dispel",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(528),
                        ruRU = "Auto\n" .. GetSpellInfo(528),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(528),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(528),
                    },
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "MassDispel",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(32375),
                        ruRU = "Auto\n" .. GetSpellInfo(32375),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(32375),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(32375),
                    },
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "Purje",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(527),
                        ruRU = "Auto\n" .. GetSpellInfo(527),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(527),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(527),
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
}

function A.Main_CastBars(unit, list)
    if not A.IsInitialized or A.IamHealer or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].SpearHandStrike and A[A.PlayerSpec].SpearHandStrike:IsReadyP(unit, nil, true) and A[A.PlayerSpec].SpearHandStrike:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp")  then 
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

