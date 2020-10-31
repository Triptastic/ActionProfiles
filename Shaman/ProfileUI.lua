--############################
--##### TRIP'S SHAMAN UI #####
--############################

--Full credit to Taste


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
A.Data.ProfileUI = {    
    DateTime = "v1 (28 Oct 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_SHAMAN_ENCHANCEMENT] = {
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
            },    
            { -- [4] 4th Row
                {
                    E = "Checkbox", 
                    DB = "EnableFS",
                    DBV = true,
                    L = { 
                        enUS = "Show Feral Spirit in rotation", 
                        ruRU = "Show Feral Spirit in rotation", 
                        frFR = "Show Feral Spirit in rotation",
                    }, 
                    TT = { 
                        enUS = "Uncheck this if you don't want to see Feral Spirit in the rotation.", 
                        ruRU = "Uncheck this if you don't want to see Feral Spirit in the rotation.", 
                        frFR = "Uncheck this if you don't want to see Feral Spirit in the rotation.",
                    }, 
                    M = {},
                },
            },               
            -- Counterstrike Totem
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(204331) .." -- ",
                    },
                },
            },
            {
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 30,                            
                    DB = "CounterStrikeTotemTTD",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(204331) .. "\nTTD",
                    },
                    TT = { 
                        enUS = GetSpellInfo(204331) .. " if player is gonna die in the next X seconds.", 
                        ruRU = GetSpellInfo(204331) .. " if player is gonna die in the next X seconds.",  
                        frFR = GetSpellInfo(204331) .. " if player is gonna die in the next X seconds.", 
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "CounterStrikeTotemHPlosepersec",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(204331) .. "\n%HP loose per sec",
                    },
                    TT = { 
                        enUS = GetSpellInfo(204331) .. " if player is taking damage and HP lost per seconds >= value.", 
                        ruRU = GetSpellInfo(204331) .. " if player is taking damage and HP lost per seconds >= value.", 
                        frFR = GetSpellInfo(204331) .. " if player is taking damage and HP lost per seconds >= value.", 
                    },                     
                    M = {},
                },
            },
            -- Skyfury Totem
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(204330) .." -- ",
                    },
                },
            },
            {
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "SkyfuryTotemHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(204330) .. "\ntarget HP",
                    },
                    TT = { 
                        enUS = GetSpellInfo(204330) .. " on low HP target depending of the value you set.", 
                        ruRU = GetSpellInfo(204330) .. " on low HP target depending of the value you set.", 
                        frFR = GetSpellInfo(204330) .. " on low HP target depending of the value you set.", 
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 30,                            
                    DB = "SkyfuryTotemTTD",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(204330) .. "\nTTD",
                    },
                    TT = { 
                        enUS = GetSpellInfo(204330) .. " if target time to die is inferior to this value.", 
                        ruRU = GetSpellInfo(204330) .. " if target time to die is inferior to this value.", 
                        frFR = GetSpellInfo(204330) .. " if target time to die is inferior to this value.", 
                    },                     
                    M = {},
                },
            },                
            -- EarthElemental
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(198103) .." -- ",
                    },
                },
            },
            {
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "EarthElementalUnits",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198103) .. " units",
                    },
                    TT = { 
                        enUS = GetSpellInfo(198103) .. " if at least X units around and player is in trouble.\nThis settings is linked to Earth Elemental range.",  
                        ruRU = GetSpellInfo(198103) .. " if at least X units around and player is in trouble.\nThis settings is linked to Earth Elemental range.", 
                        frFR = GetSpellInfo(198103) .. " if at least X units around and player is in trouble.\nThis settings is linked to Earth Elemental range.", 
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 30,                            
                    DB = "EarthElementalRange",
                    DBV = 8, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198103) .. " range",
                    },
                    TT = { 
                        enUS = GetSpellInfo(198103) .. " depending of current number of enemies in range value.\nThis settings is linked to Earth Elemental units.", 
                        ruRU = GetSpellInfo(198103) .. " depending of current number of enemies in range value.\nThis settings is linked to Earth Elemental units.", 
                        frFR = GetSpellInfo(198103) .. " depending of current number of enemies in range value.\nThis settings is linked to Earth Elemental units.",  
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "EarthElementalHP",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198103) .. "\n %HP lost per sec",
                    },
                    TT = { 
                        enUS = GetSpellInfo(198103) .. " if player is taking damage and HP lost per seconds >= value.", 
                        ruRU = GetSpellInfo(198103) .. " if player is taking damage and HP lost per seconds >= value.", 
                        frFR = GetSpellInfo(198103) .. " if player is taking damage and HP lost per seconds >= value.", 
                    },                     
                    M = {},
                },
				{
                    E = "Checkbox",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "EarthElementalDPS",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198103) .. " for DPS.",
                    },
                    TT = { 
                        ANY = GetSpellInfo(198103) .. " as a DPS cooldown.",
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
                    E = "Checkbox", 
                    DB = "TrinketOnlyBurst",
                    DBV = true,
                    L = { 
                        enUS = "Trinkets\nBurst only", 
                        ruRU = "Trinkets\nBurst only", 
                        frFR = "Trinkets\nBurst only", 
                    }, 
                    TT = { 
                        enUS = "Enable this to option to trinkets with Burst usage ONLY.", 
                        ruRU = "Enable this to option to trinkets with Burst usage ONLY.", 
                        frFR = "Enable this to option to trinkets with Burst usage ONLY.",  
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
                        ANY = " -- Miscellaneous -- ",
                    },
                },
            },
            {
                {
                    E = "Checkbox", 
                    DB = "UseGhostWolf",
                    DBV = true,
                    L = { 
                        enUS = "Auto" .. GetSpellInfo(2645), 
                        ruRU = "Авто" .. GetSpellInfo(2645), 
                        frFR = "Auto" .. GetSpellInfo(2645), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(2645), 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(2645), 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(2645), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "GhostWolfTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(2645) .. " if moving for",
                    }, 
                    TT = { 
                        enUS = "If " .. GetSpellInfo(2645) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. GetSpellInfo(2645) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. GetSpellInfo(2645) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox", 
                    DB = "UseCapacitorTotem",
                    DBV = true,
                    L = { 
                        enUS = "Use Capacitor Totem", 
                        ruRU = "Use Capacitor Totem", 
                        frFR = "Use Capacitor Totem", 
                    }, 
                    TT = { 
                        enUS = "Will force use of Capacitor Totem if Wind Shear is not ready.", 
                        ruRU = "Will force use of Capacitor Totem if Wind Shear is not ready.",
                        frFR = "Will force use of Capacitor Totem if Wind Shear is not ready.",
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
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AstralShiftHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(108271) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "EarthShieldHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(974) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealingSurgeHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(8004) .. " (%)",
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
                    DB = "HexPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(51514),
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
                    DB = "HexPvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(51514) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_SHAMAN_ELEMENTAL] = {
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
                    DBV = 30, -- Set healthpercentage @60% life. 
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
            { -- [4] 4th Row
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- Miscellaneous -- ",
                    },
                },
            },
            {
                {
                    E = "Checkbox", 
                    DB = "ForceAoE",
                    DBV = true,
                    L = { 
                        enUS = "Force AoE opener", 
                        ruRU = "Force AoE opener", 
                        frFR = "Force AoE opener", 
                    }, 
                    TT = { 
                        enUS = "If activated, opener will use Chain Lightning instead of Lava Burst.\nUsefull if you got issue with AoE detection on opener.", 
                        ruRU = "If activated, opener will use Chain Lightning instead of Lava Burst.\nUsefull if you got issue with AoE detection on opener.",
                        frFR = "If activated, opener will use Chain Lightning instead of Lava Burst.\nUsefull if you got issue with AoE detection on opener.",
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "UseGhostWolf",
                    DBV = true,
                    L = { 
                        enUS = "Use Ghost Wolf", 
                        ruRU = "Use Ghost Wolf", 
                        frFR = "Use Ghost Wolf",
                    }, 
                    TT = { 
                        enUS = "Automatically use Ghost Wolf if out of range and in combat.", 
                        ruRU = "Automatically use Ghost Wolf if out of range and in combat.", 
                        frFR = "Automatically use Ghost Wolf if out of range and in combat.", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "UseCapacitorTotem",
                    DBV = true,
                    L = { 
                        enUS = "Use Capacitor Totem", 
                        ruRU = "Use Capacitor Totem", 
                        frFR = "Use Capacitor Totem", 
                    }, 
                    TT = { 
                        enUS = "Will force use of Capacitor Totem if Wind Shear is not ready.", 
                        ruRU = "Will force use of Capacitor Totem if Wind Shear is not ready.",
                        frFR = "Will force use of Capacitor Totem if Wind Shear is not ready.",
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
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AstralShiftHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(108271) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "EarthShieldHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(974) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "HealingSurgeHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(8004) .. " (%)",
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
            {
                {
                    E = "Checkbox", 
                    DB = "UseEarthElemental",
                    DBV = true,
                    L = { 
                        enUS = "Defensive Earth Elemental", 
                        ruRU = "Defensive Earth Elemental", 
                        frFR = "Defensive Earth Elemental", 
                    }, 
                    TT = { 
                        enUS = "Will use Earth Elemental defensively depending on your settings.", 
                        ruRU = "Will use Earth Elemental defensively depending on your settings.", 
                        frFR = "Will use Earth Elemental defensively depending on your settings.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "EarthElementalHP",
                    DBV = 40, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Health",
                    },
                    TT = { 
                        enUS = "Current player health percentage to use Earth Elemental.", 
                        ruRU = "Current player health percentage to use Earth Elemental.", 
                        frFR = "Current player health percentage to use Earth Elemental.",
                    },                    
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 15,                            
                    DB = "EarthElementalEnemies",
                    DBV = 3, 
                    ONOFF = true,
                    L = { 
                        ANY = "Enemies",
                    }, 
                    TT = { 
                        enUS = "Number of enemies around to use Earth Elemental.", 
                        ruRU = "Number of enemies around to use Earth Elemental.", 
                        frFR = "Number of enemies around to use Earth Elemental.",
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
                        ANY = " -- Ancestral Guidance -- ",
                    },
                },
            },
            {
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "In Raid", value = "In Raid" },
                        { text = "In Dungeon", value = "In Dungeon" },
                        { text = "In PvP", value = "In PvP" },
                        { text = "Everywhere", value = "Everywhere" },
                    },
                    MULT = false,
                    DB = "AncestralGuidanceSelection",
                    DBV = "In Dungeon", 
                    L = { 
                        ANY = "Ancestral Guidance usage",
                    }, 
                    TT = { 
                        enUS = "Choose where you want to automatically Ancestral Guidance units.", 
                        ruRU = "Choose where you want to automatically Ancestral Guidance units.",
                    }, 
                    M = {},
                },    
            },    
            {
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AncestralGuidanceHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Defensive Logic",
                    },
                    TT = { 
                        enUS = "Auto : Will dynamically take in account your current group size, current group damage and healing per second to determine when to use assist healing.\nNOT Auto : the value set with slider will be the current percent damage per second on your group.", 
                        ruRU = "Auto : Will dynamically take in account your current group size, current group damage and healing per second to determine when to use assist healing.\nNOT Auto : the value set with slider will be the current percent damage per second on your group.", 
                        frFR = "Auto : Will dynamically take in account your current group size, current group damage and healing per second to determine when to use assist healing.\nNOT Auto : the value set with slider will be the current percent damage per second on your group.", 
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
                    DB = "HexPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(51514),
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
                    DB = "HexPvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(51514) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
            },
        },
        [ACTION_CONST_SHAMAN_RESTORATION] = {
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
            },
            {            
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
                    DB = "UseGhostWolf",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. GetSpellInfo(2645), 
                        ruRU = "Авто " .. GetSpellInfo(2645), 
                        frFR = "Auto " .. GetSpellInfo(2645), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(2645), 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(2645), 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(2645), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "GhostWolfTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(2645) .. " if moving for",
                        ruRU = GetSpellInfo(2645) .. " если переехать",
                        frFR = GetSpellInfo(2645) .. " si vous bougez pendant",
                    },
                    TT = { 
                        enUS = "If " .. GetSpellInfo(2645) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. GetSpellInfo(2645) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. GetSpellInfo(2645) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
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
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AstralShiftHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(108271) .. " (%)",
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
            { -- HealingTideTotem
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(108280) .. " -- ",
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
            -- HealingTideTotem
            { -- [3] 
                RowOptions = { margin = { top = 10 } },        
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HealingTideTotemRaidUnits",
                    DBV = 5,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(108280) .. "\n(Total Units)",    
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HealingTideTotemPartyUnits",
                    DBV = 3,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(108280) .. "\n(Total Units)",    
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
                    DB = "HealingTideTotemRaidHP",
                    DBV = 65,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(108280) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "HealingTideTotemPartyHP",
                    DBV = 60,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(108280) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },                
            },                            
            { -- EarthShield
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(974) .. " -- ",
                    },
                }, 
            },
            {
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Auto", value = "Auto" },    
                        { text = "Tanking Units", value = "Tanking Units" },                    
                        { text = "Mostly Inc. Damage", value = "Mostly Inc. Damage" },
                    },
                    DB = "EarthShieldWorkMode",
                    DBV = "Tanking Units",
                    L = { 
                        ANY = GetSpellInfo(974) .. "\nWork Mode",
                    }, 
                    TT = { 
                        enUS = "These conditions will be skiped if unit will dying in emergency (critical) situation", 
                        ruRU = "Эти условия будут пропущены если юнит будет умирать в чрезвычайной (критической) ситуациии", 
                    },                    
                    M = {},
                },
            },    
            { -- ChainHeal
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(1064) .. " -- ",
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
            -- ChainHeal
            { -- [3] 
                RowOptions = { margin = { top = 10 } },        
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "ChainHealRaidUnits",
                    DBV = 4,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(1064) .. "\n(Total Units)",    
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "ChainHealPartyUnits",
                    DBV = 3,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(1064) .. "\n(Total Units)",    
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
                    DB = "ChainHealRaidHP",
                    DBV = 92,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(1064) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "ChainHealPartyHP",
                    DBV = 80,
                    ONLYON = true,
                    L = { 
                        ANY = GetSpellInfo(1064) .. "\n(Per UnitHealth %)",                        
                    },                     
                    M = {},
                },                
            },    
            { -- HealingStreamTotem
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(5394) .. " -- ",
                    },
                }, 
            },            
            {
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "HealingStreamTotemHP",
                    DBV = 55,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(5394) .. "\n(%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 5,                            
                    DB = "HealingStreamTotemUnits",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(5394) .. "\nunits",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HealingStreamTotemRefresh",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(5394) .. "\nrefresh(sec)",
                    }, 
                    M = {},
                },
            },
            { -- HealingRain
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(73920) .. " -- ",
                    },
                }, 
            },            
            {
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "HealingRainRefresh",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(73920) .. "\nrefresh(sec)",
                    }, 
                    M = {},
                },
            },
            { -- SpiritWalkersGrace
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(79206) .. " -- ",
                    },
                }, 
            },            
            {
                {
                    E = "Checkbox", 
                    DB = "UseSpiritWalkersGrace",
                    DBV = true,
                    L = { 
                        enUS = "Auto\n" .. GetSpellInfo(79206),
                        ruRU = "Auto\n" .. GetSpellInfo(79206),
                    },
                    TT = { 
                        enUS = "Enable this option to automatically use " .. GetSpellInfo(79206),
                        ruRU = "Enable this option to automatically use " .. GetSpellInfo(79206),
                    },
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "SpiritWalkersGraceTime",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(79206) .. "\nif moving for",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "SpiritWalkersCatch",
                    DBV = 3,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(79206) .. "\nonly if rooted",
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
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_SHAMAN_ENCHANCEMENT] = { 
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
        [ACTION_CONST_SHAMAN_RESTORATION] = { 
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
        [ACTION_CONST_SHAMAN_ELEMENTAL] = { 
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


