--#########################################
--##### TRIP'S DEMON HUNTER PROFILEUI #####
--#########################################

local TMW					= TMW 
local CNDT					= TMW.CNDT
local Env					= CNDT.Env
local A						= Action
local GetToggle				= A.GetToggle
local InterruptIsValid		= A.InterruptIsValid
local UnitCooldown			= A.UnitCooldown
local Unit					= A.Unit 
local Player				= A.Player 
local Pet					= A.Pet
local LoC					= A.LossOfControl
local MultiUnits			= A.MultiUnits
local EnemyTeam				= A.EnemyTeam
local FriendlyTeam			= A.FriendlyTeam
local TeamCache				= A.TeamCache
local InstanceInfo			= A.InstanceInfo
local TR					= Action.TasteRotation
local select, setmetatable	= select, setmetatable

-- Shadowlands Spell Info fix for empty spells
local GetSpellInfo_original                                = _G.GetSpellInfo
local function GetSpellInfo(...)
    return GetSpellInfo_original(...) or ""
end

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {      
    DateTime = "v1.0.0 (28 Oct 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_DEMONHUNTER_HAVOC] = {   
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
            },  
            { -- GENERAL OPTIONS SECOND ROW
                {
                    E = "Checkbox", 
                    DB = "UseMoves",
                    DBV = false,
                    L = { 
                        enUS = "Use Fel Rush & Vengeful Retreat", 
                        ruRU = "Используйте Fel Rush & Vengeful Retreat", 
                        frFR = "Utiliser Ruée Fulgurante & Retraite Vengeresse",
                    }, 
                    TT = { 
                        enUS = "Suggest when Fel Rush & Vengeful Retreat for mobility or for Momentum build.", 
                        ruRU = "Предложите, когда Ослепительная Раш & Мстительное отступление для мобильности или для наращивания Momentum.", 
                        frFR = "Suggère quand utiliser Ruée Fulgurante & Retraite Vengeresse pour la mobilité ou pour la build Momentum",
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "ImprisonAsInterrupt",
                    DBV = false,
                    L = { 
                        enUS = GetSpellInfo(217832) .. " Interrupt", 
                        ruRU = GetSpellInfo(217832) .. " Прерывание",  
                        frFR = GetSpellInfo(217832) .. " Interruption",  
                    }, 
                    TT = { 
                        enUS = "Use your Imprison as interrupt if you don't have your Disrupt ready.", 
                        ruRU = "Используйте свою тюрьму в качестве прерывания, если у вас нет готовности к прерыванию.",  
                        frFR = "Utilisez votre Emprisonnement comme interruption si vous n'avez pas votre Disruption prêt.", 
                    }, 
                    M = {},
                },     
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },            
			{ -- FELBLADE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< FELBLADE ><><><l ",
                    },
                },
            },
            { -- FELBLADE OPTIONS FIRST ROW
                { -- FELBLADE MODE
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "AUTO", value = "AUTO" },
                        { text = "PVP", value = "PVP" },
                        { text = "NEVER", value = "NEVER" },
                    },
                    MULT = false,
                    DB = "FelBladeMode",
                    DBV = "AUTO", 
                    L = { 
                        ANY = GetSpellInfo(232893) .. " Mode",
                    }, 
                    TT = { 
                        enUS = "Customize your " .. GetSpellInfo(232893) .. " options. Multiple checks possible.\nAUTO: Will use it as soon as you are out of range of your current target.\nPVP: Will use it only in PvP to chase enemy.\nNEVER: Will never use " .. GetSpellInfo(232893) .. ".", 
                        ruRU = "Customize your " .. GetSpellInfo(232893) .. " options. Multiple checks possible.\nAUTO: Will use it as soon as you are out of range of your current target.\nPVP: Will use it only in PvP to chase enemy.\nNEVER: Will never use " .. GetSpellInfo(232893) .. ".", 
                        frFR = "Customize your " .. GetSpellInfo(232893) .. " options. Multiple checks possible.\nAUTO: Will use it as soon as you are out of range of your current target.\nPVP: Will use it only in PvP to chase enemy.\nNEVER: Will never use " .. GetSpellInfo(232893) .. ".", 
                    }, 
                    M = {},
                },                
                { -- FELBLADE PVP RANGE
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 15,                            
                    DB = "FelBladeRangePvP",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(232893) .. "\nPvP range",
                    },
                    TT = { 
                        enUS = "Set the maximum range for a unit before using " .. GetSpellInfo(232893) .. ".\nThis setting only valid in PvP.", 
                        ruRU = "Set the maximum range for a unit before using " .. GetSpellInfo(232893) .. ".\nThis setting only valid in PvP.", 
                        frFR = "Set the maximum range for a unit before using " .. GetSpellInfo(232893) .. ".\nThis setting only valid in PvP.", 
                    },                     
                    M = {},
                },
            },
            { -- FELBLADE OPTIONS SECOND ROW
                { -- FELBLADE RANGE PVE
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 15,                            
                    DB = "FelBladeRange",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(232893) .. " range",
                    },
                    TT = { 
                        enUS = "Set the maximum range for a unit before using " .. GetSpellInfo(232893) .. ".", 
                        ruRU = "Set the maximum range for a unit before using " .. GetSpellInfo(232893) .. ".", 
                        frFR = "Set the maximum range for a unit before using " .. GetSpellInfo(232893) .. ".", 
                    },                     
                    M = {},
                },
                { -- FELBLADE FURY
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 120,                            
                    DB = "FelBladeFury",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(232893) .. " Fury",
                    },
                    TT = { 
                        ANY = "Set the maximum amount of Fury before using " .. GetSpellInfo(232893) .. ".", 
                    },                     
                    M = {},
                },
            },                
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },            
			{ -- EYEBEAM HEADER
                {
                    E = "Header",
                    L = {
                        ANY = "  l><><>< EYEBEAM ><><><l ",
                    },
                },
            },
            { -- EYEBEAM MODE              
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Burst Only", value = 1 },
                        { text = "Aoe Only", value = 2 },
                        { text = "Everytime", value = 3 },
                    },
                    MULT = true,
                    DB = "EyeBeamMode",
                    DBV = {
                        [1] = false, 
                        [2] = false,
                        [3] = true,
                    }, 
                    L = { 
                        ANY = GetSpellInfo(198013) .. " behavior",
                    }, 
                    TT = { 
                        enUS = "Customize your " .. GetSpellInfo(198013) .. " options. Multiple checks possible.", 
                        ruRU = "Настройте свои параметры " .. GetSpellInfo(198013) .. ". Возможно несколько проверок.", 
                        frFR = "Personnalisez vos options " .. GetSpellInfo(198013) .. ". Plusieurs contrôles possibles..",  
                    }, 
                    M = {},
                },    
            },
            { -- EYEBEAM SLIDERS           
                { -- EYEBEAM TTD
                    E = "Slider",                                                     
                    MIN = 3, 
                    MAX = 60,                            
                    DB = "EyeBeamTTD",
                    DBV = 7, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198013) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the minimum Time To Die for a unit before using " .. GetSpellInfo(198013) .. " \nDoes not apply to Boss.", 
                        ruRU = "Установите минимальное время смерти для отряда перед использованием " .. GetSpellInfo(198013) .. " \nНе применимо к боссу.", 
                        frFR = "Définissez le temps minimum pour mourir pour une unité avant d'utiliser " .. GetSpellInfo(198013) .. " \nNe s'applique pas aux boss.", 
                    },                     
                    M = {},
                },
                { -- EYEBEAM RANGE
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 20,                            
                    DB = "EyeBeamRange",
                    DBV = 7, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198013) .. " range",
                    },
                    TT = { 
                        enUS = "Set the minimum range for a unit before using " .. GetSpellInfo(198013) .. " \n", 
                        ruRU = "Set the minimum range for a unit before using " .. GetSpellInfo(198013) .. " \n", 
                        frFR = "Set the minimum range for a unit before using " .. GetSpellInfo(198013) .. " \n", 
                    },                     
                    M = {},
                },
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- POTIONS HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< COMBAT POTION ><><><l ",
                    },
                },
            },
            { -- POTIONS OPTIONS
                { -- POTION SELECTION
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Unbridled Fury", value = "UnbridledFuryPot" },
                        { text = "Spectral Agility", value = "SpectralAgilityPot" },
                        { text = "Empowered Exorcisms", value = "EmpoweredExorcismsPot" },
                        { text = "Phantom Fire", value = "PhantomFirePot" },
                        { text = "Deathly Fixation", value = "DeathlyFixationPot" },						
                    },
                    MULT = false,
                    DB = "AutoPotionSelect",
                    DBV = "SpectralAgilityPot", 
                    L = { 
                        ANY = "Pick Your Potion",
                    }, 
                    TT = { 
                        ANY = "Select which potion to use."
                    }, 
                    M = {},
                },                
                { -- POTION HEROISM ONLY
                    E = "Checkbox", 
                    DB = "PotionHeroOnly",
                    DBV = false,
                    L = { 
                        ANY = "Use with Bloodlust/Heroism"  
                    }, 
                    TT = { 
                        ANY = "Use Potion with Bloodlust/Heroism."
                    }, 
                    M = {},
                },
			},
			{ -- POTIONS OPTIONS CONTINUED
                { -- POTION META ONLY
                    E = "Checkbox", 
                    DB = "PotionMetaOnly",
                    DBV = false,
                    L = { 
                        ANY = "Use Potion With Metamorphosis"  
                    }, 
                    TT = { 
                        ANY = "Try to sync cooldown of Metamorphosis with cooldown of potion."
                    }, 
                    M = {},
                },
                { -- POTION TIME TO DIE
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                          
                    DB = "PotionTTD",
                    DBV = 25, 
                    ONOFF = true,
                    L = { 
                        ANY = "Time To Die Requirement",
                    },
                    TT = { 
                        ANY = "Length of time target needs to stay alive for before using potion. It's a good idea to set this value to a little bit longer than the duration of your potion if you don't want to waste any!"
                    },                     
                    M = {},
                },
            },    
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- DARKNESS HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DARKNESS ><><><l ",
                    },
                },
            },
            { -- AUTO DARKNESS CHECKBOX
                {
                    E = "Checkbox", 
                    DB = "AutoDarkness",
                    DBV = false,
                    L = { 
                        ANY = "Auto " .. GetSpellInfo(196718),
                    },
                    TT = { 
                        enUS = "If activated, will auto use " .. GetSpellInfo(196718) .. " depending on currents settings.\nFor high end raiding, it is recommended to keep Darkness when your Raid Leader call it.",
                        ruRU = "Если активирован, будет автоматически использовать " .. GetSpellInfo(196718) .. " в зависимости от настроек токов.\nДля рейдового сегмента рекомендуется держать Тьму, когда ваш Рейдовый Лидер называет это.",
                        frFR = "Si activé, utilisera automatiquement " .. GetSpellInfo(196718) .. " en fonction des paramètres de courant.\nPour les raids de haut niveau, il est recommandé de garder Ténèbres lorsque votre chef de raid l'appelle.",
                    }, 
                    M = {},
                }, 
                { -- AUTO DARKNESS DROPDOWN
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "In Raid", value = "In Raid" },
                        { text = "In Dungeon", value = "In Dungeon" },
                        { text = "In PvP", value = "In PvP" },
                        { text = "Everywhere", value = "Everywhere" },
                    },
                    MULT = false,
                    DB = "DarknessMode",
                    DBV = "In Dungeon", 
                    L = { 
                        enUS = GetSpellInfo(196718) .. " where", 
                        ruRU = GetSpellInfo(196718) .. " где", 
                        frFR = GetSpellInfo(196718) .. " où", 
                    }, 
                    TT = { 
                        enUS = "Choose where you want to automatically use " .. GetSpellInfo(196718),
                        ruRU = "Выберите, где вы хотите использовать автоматически " .. GetSpellInfo(196718),
                        frFR = "Choisissez où vous souhaitez utiliser automatiquement " .. GetSpellInfo(196718),
                    }, 
                    M = {},
                }, 
                {-- DARKNESS UNITS
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "DarknessUnits",
                    DBV = 3, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(196718) .. " units",
                    }, 
                    TT = { 
                        enUS = "Define the number of party/raid members that have to be injured to use " .. GetSpellInfo(196718), 
                        ruRU = "Определите количество членов партии/рейда, которые должны быть ранены, чтобы использовать " .. GetSpellInfo(196718),  
                        frFR = "Définir le nombre de membres du groupe/raid qui doivent être blessés pour utiliser " .. GetSpellInfo(196718), 
                    },
                    M = {},
                },
            }, 
            { -- AUTO DARKNESS CONTINUED
                { -- AUTO DARKNESS TTD
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "DarknessUnitsTTD",
                    DBV = 5, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(196718) .. " TTD",
                    }, 
                    TT = { 
                        enUS = "Define the minimum Time To Die for party/raid members before using " .. GetSpellInfo(196718), 
                        ruRU = "Определите минимальное время жизни для членов партии или рейда перед использованием " .. GetSpellInfo(196718), 
                        frFR = "Définissez le temps minimum pour mourir pour les membres du groupe/raid avant d'utiliser " .. GetSpellInfo(196718),
                    },
                    M = {},
                },
                { -- AUTO DARKNESS HP
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 100,                            
                    DB = "DarknessUnitsHP",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(196718) .. " HP",
                    }, 
                    TT = { 
                        enUS = "Define the minimum health percent for party/raid members before using " .. GetSpellInfo(196718), 
                        ruRU = "Определите минимальный процент здоровья для участников группы или рейда перед использованием " .. GetSpellInfo(196718), 
                        frFR = "Définissez le pourcentage de santé minimum pour les membres du groupe / raid avant d'utiliser " .. GetSpellInfo(196718),
                    },
                    M = {},
                },
                
            },
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- DEFENSIVES HEADER 
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< DEFENSIVES ><><><l ",
                    },
                },
            },
            { -- DEFENSIVES OPTIONS 
                { -- BLUR HP SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Blur",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198589) .. " (%)",
                    }, 
                    M = {},
                },
                { -- HEALING POTION 
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
            }, 
            { -- DEFENSIVES OPTIONS CONTINUED
                { -- NETHERWALK
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Netherwalk",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(196555) .. " (%)",
                    }, 
                    M = {},
                },
            },   
            { -- LAYOUT SPACE
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- PVP HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PVP ><><><l ",
                    },
                },
            },
            { -- IMPRISON    
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
                        ANY = "PvP " .. GetSpellInfo(217832),
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
                        ANY = "PvP " .. GetSpellInfo(217832) .. " units",
                    }, 
                    TT = { 
                        enUS = "primary - is @target, @mouseover, @targettarget (these units are depend on toggles above)", 
                        ruRU = "primary - это @target, @mouseover, @targettarget (эти юниты зависят от чекбоксов наверху)", 
                    }, 
                    M = {},
                },
                -- Leotheras
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "ON CD", value = "ON CD" },
                        { text = "ON ENEMY BURST", value = "ON ENEMY BURST" },                    
                        { text = "ON TEAM DEFF", value = "ON TEAM DEFF" },
                        { text = "OFF", value = "OFF" },
                    },
                    DB = "LeotherasPvP",
                    DBV = "ON ENEMY BURST",
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(206649),
                    }, 
                    TT = { 
                        enUS = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Only if melee player has damage buffs\nON COOLDOWN - means will use always on melee players\nOFF - Cut out from rotation but still allow work through Queue and MSG systems\nIf you want fully turn it OFF then you should make SetBlocker in 'Actions' tab", 
                        ruRU = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Только если игрок ближнего боя имеет бафы на урон\nON COOLDOWN - значит будет использовано по игрокам ближнего боя по восстановлению способности\nOFF - Выключает из ротации, но при этом позволяет Очередь и MSG системам работать\nЕсли нужно полностью выключить, тогда установите блокировку во вкладке 'Действия'", 
                        frFR = "@arena1-3, @target, @mouseover, @targettarget\nON MELEE BURST - Seulement si le joueur de mêlée a des buffs de dégâts\nON COOLDOWN - les moyens seront toujours utilisés sur les joueurs de mêlée\nOFF - Coupé de la rotation mais autorisant toujours le travail dans la file d'attente et Systèmes MSG\nSi vous souhaitez l'éteindre complètement, vous devez définir SetBlocker dans l'onglet 'Actions'", 
                    },  
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "LeotherasPvP",
                    DBV = true,
                    L = { 
                        enUS = "Use Leotheras", 
                        ruRU = "Use Leotheras", 
                        frFR = "Use Leotheras",
                    }, 
                    TT = { 
                        enUS = "Will activate auto logic for Eye of Leotheras in PvP arena.", 
                        ruRU = "Will activate auto logic for Eye of Leotheras in PvP arena.", 
                        frFR = "Will activate auto logic for Eye of Leotheras in PvP arena.",  
                    }, 
                    M = {},
                },
            },
        },
        -- Vengeance Specialisation
        [ACTION_CONST_DEMONHUNTER_VENGEANCE] = {          
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
					DB = "AutoTaunt",
					DBV = true,
					L = { 
						enUS = "Automatic Taunt", 
						ruRU = "Автоматическая Насмешка", 
						frFR = "Raillerie automatique",
					}, 
					TT = { 
						enUS = "If activated, will use automatically use Torment if you do not have aggro on your target.", 
						ruRU = "If activated, will use automatically use Torment if you do not have aggro on your target.",  
						frFR = "If activated, will use automatically use Torment if you do not have aggro on your target.", 
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
                    DB = "ImprisonPvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(217832),
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
                        ANY = "PvP " .. GetSpellInfo(217832) .. " units",
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
        [ACTION_CONST_DEMONHUNTER_HAVOC] = { 
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
        [ACTION_CONST_DEMONHUNTER_VENGEANCE] = { 
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
function A.ImprisonIsReady(unit, isMsg, skipShouldStop)
    if A[A.PlayerSpec].Imprison then 
        local unitID = A.GetToggle(2, "ImprisonPvPUnits")
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
                A.GetToggle(2, "ImprisonPvP") ~= "OFF" and 
                A[A.PlayerSpec].Imprison:IsReady(unit, nil, nil, skipShouldStop) and 
                Unit(unit):GetRange() <= 20 and 
                (
                    A.GetToggle(2, "ImprisonPvP") == "ON COOLDOWN" or 
                    Unit(unit):HasBuffs("DamageBuffs") > 3 
                )
            ) or 
            (
                isMsg and 
                A[A.PlayerSpec].Imprison:IsReadyM(unit)                     
            )
        ) and 
        Unit(unit):IsPlayer() and                     
        A[A.PlayerSpec].Imprison:AbsentImun(unit, {"CCTotalImun", "DamagePhysImun", "TotalImun"}, true)
    end 
end 

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


