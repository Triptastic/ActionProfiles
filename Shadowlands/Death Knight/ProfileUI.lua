--#########################################
--##### TRIP'S DEATH KNIGHT PROFILE UI#####
--#########################################

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

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {      
    DateTime = "v2.0 (31 December 2020)",
    -- Class settings
    [2] = {
        -- Unholy    
        [ACTION_CONST_DEATHKNIGHT_UNHOLY] = {
            LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },            
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },            
            { -- GENERAL OPTIONS
                { -- MOUSEOVER CHECKBOX
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
                { -- AOE CHECKBOX
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
				{ -- Soul Reaper MOUSEOVER
                    E = "Checkbox", 
                    DB = "SoulReaperMouseover",
                    DBV = true,
                    L = { 
                        ANY = "Soul Reaper @mouseover", 
                    }, 
                    TT = { 
                        ANY = "/cast [@mouseover, harm]Soul Reaper; Soul Reaper"
                    }, 
                    M = {},
                },
            },
            {
                { -- DEATHGRIP INTERRUPT
                    E = "Checkbox", 
                    DB = "DeathGripInterrupt",
                    DBV = true,
                    L = { 
                        ANY = "Use Death Grip for Interrupt"
                    }, 
                    TT = { 
                        ANY = "Use Death Grip to Interrupt if Mind Freeze is on cooldown."
                    },
                    M = {},
                },
                { -- ASPHYXIATE INTERRUPT
                    E = "Checkbox", 
                    DB = "AsphyxiateInterrupt",
                    DBV = true,
                    L = { 
                        ANY = "Use Asphyxiate for Interrupt"
                    }, 
                    TT = { 
                        ANY = "Use Asphyxiate to Interrupt if Mind Freeze is on cooldown."
                    },
                    M = {},
                },  
				{ -- Slow Spiteful @ MouseOver
                    E = "Checkbox", 
                    DB = "SlowSpiteful",
                    DBV = true,
                    L = { 
                        ANY = "Slow Spiteful with Chains @mouseover"
                    }, 
                    TT = { 
                        ANY = "/cast [@mouseover, harm]Chains of Ice; Chains of Ice"
                    },
                    M = {},
                },					
            },    
			{
				{ -- Legendary Swap Opening
                    E = "Checkbox", 
                    DB = "LegoSwap",
                    DBV = true,
                    L = { 
                        ANY = "Legendary Swap Opening"
                    }, 
                    TT = { 
                        ANY = "Must have BOTH Deadliest Coil and Frenzied Monstrocity"
                    },
                    M = {},
                },	
			},
            { -- LAYOUT SPACE
                {
                    E = "LayoutSpace",                                                                         
                },
            },            
            { -- AOE HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< AOE ><><><l ",
                    },
                },
            },            
            { -- AOE SETTINGS
                {    -- AUTO SWITCH FESTERING STRIKE
                    E = "Checkbox", 
                    DB = "AutoSwitchFesteringStrike",
                    DBV = true,
                    L = { 
                        enUS = "AutoSwitch Festering Strike", 
                        ruRU = "AutoSwitch Festering Strike",  
                        frFR = "AutoSwitch Festering Strike", 
                    }, 
                    TT = { 
                        enUS = "Enable this to option to automatically switch between target to apply maximum Festering Strike debuff.", 
                        ruRU = "Enable this to option to automatically switch between target to apply maximum Festering Strike debuff.",
                        frFR = "Enable this to option to automatically switch between target to apply maximum Festering Strike debuff.",
                    }, 
                    M = {},
                },
                { -- AOE TARGETS
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 10,                            
                    DB = "AoETargets",
                    DBV = 2, -- Set healthpercentage @30% life. 
                    ONOFF = false,
                    L = { 
                        ANY = "Amount of targets to use AoE rotation",
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
            { -- SLIDERS 1 
                { -- IceboundFortitudeHP SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "IceboundFortitudeHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(48792) .. " (%)",
                    }, 
                    M = {},
                },
                { -- IceboundFortitudeAntiStun
                    E = "Checkbox", 
                    DB = "IceboundFortitudeAntiStun",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(48792) .. " AntiStun", 
                        ruRU = A.GetSpellInfo(48792) .. " AntiStun", 
                        frFR = A.GetSpellInfo(48792) .. " AntiStun",
                    }, 
                    TT = { 
                        enUS = "Enable this to option to automatically cast " .. A.GetSpellInfo(48792) .. " when you are stunned.", 
                        ruRU = "Enable this to option to automatically cast " .. A.GetSpellInfo(48792) .. " when you are stunned.",
                        frFR = "Enable this to option to automatically cast " .. A.GetSpellInfo(48792) .. " when you are stunned.",
                    }, 
                    M = {},
                },     
            },
            { -- SLIDERS 2
                { -- DEATHPACTHP SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathPactHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(48743) .. " (%)",
                    }, 
                    M = {},
                },
                { -- ANTIMAGICSHELL SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AntiMagicShellHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(48707) .. " (%)",
                    }, 
                    M = {},
                },
            },
            {
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
                { -- DeathStrikeHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathStrikeHP",
                    DBV = 40, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Death Strike HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Death Strike at this percent HP."
                    },                    
                    M = {},
                },
            },
            { -- LAYOUTSPACE
                {
                    E = "LayoutSpace",                                                                         
                },
            },
        },
        -- Frost
        [ACTION_CONST_DEATHKNIGHT_FROST] = {  
            LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },            
            { -- GENERAL HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< GENERAL ><><><l ",
                    },
                },
            },            
            { -- GENERAL OPTIONS
                { -- MOUSEOVER CHECKBOX
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
                { -- AOE CHECKBOX
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
                { -- DEATHGRIP INTERRUPT
                    E = "Checkbox", 
                    DB = "DeathGripInterrupt",
                    DBV = true,
                    L = { 
                        ANY = "Use Death Grip for Interrupt"
                    }, 
                    TT = { 
                        ANY = "Use Death Grip to Interrupt if Mind Freeze is on cooldown."
                    },
                    M = {},
                },
                { -- ASPHYXIATE INTERRUPT
                    E = "Checkbox", 
                    DB = "AsphyxiateInterrupt",
                    DBV = true,
                    L = { 
                        ANY = "Use Asphyxiate for Interrupt"
                    }, 
                    TT = { 
                        ANY = "Use Asphyxiate to Interrupt if Mind Freeze is on cooldown."
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
            { -- SLIDERS 1 
                { -- IceboundFortitudeHP SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "IceboundFortitudeHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(48792) .. " (%)",
                    }, 
                    M = {},
                },
                { -- IceboundFortitudeAntiStun
                    E = "Checkbox", 
                    DB = "IceboundFortitudeAntiStun",
                    DBV = true,
                    L = { 
                        enUS = A.GetSpellInfo(48792) .. " AntiStun", 
                        ruRU = A.GetSpellInfo(48792) .. " AntiStun", 
                        frFR = A.GetSpellInfo(48792) .. " AntiStun",
                    }, 
                    TT = { 
                        enUS = "Enable this to option to automatically cast " .. A.GetSpellInfo(48792) .. " when you are stunned.", 
                        ruRU = "Enable this to option to automatically cast " .. A.GetSpellInfo(48792) .. " when you are stunned.",
                        frFR = "Enable this to option to automatically cast " .. A.GetSpellInfo(48792) .. " when you are stunned.",
                    }, 
                    M = {},
                },     
            },
            { -- SLIDERS 2
                { -- DEATHPACTHP SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathPactHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(48743) .. " (%)",
                    }, 
                    M = {},
                },
                { -- ANTIMAGICSHELL SLIDER
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "AntiMagicShellHP",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = A.GetSpellInfo(48707) .. " (%)",
                    }, 
                    M = {},
                },
            },
            {
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
                { -- DeathStrikeHP
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathStrikeHP",
                    DBV = 40, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Death Strike HP (%)",
                    }, 
                    TT = { 
                        ANY = "Will use Death Strike at this percent HP."
                    },                    
                    M = {},
                },    
            },
            { -- LAYOUTSPACE
                {
                    E = "LayoutSpace",                                                                         
                },
            },
        },
        -- Blood
        [ACTION_CONST_DEATHKNIGHT_BLOOD] = { 
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
            { -- [2] 2nd Row 
                {
                    E = "Checkbox", 
                    DB = "ConsumptionSuggested",
                    DBV = true,
                    L = { 
                        enUS = "Suggested: Consumption", 
                        ruRU = "Suggested: Consumption", 
                        frFR = "Suggested: Consumption",
                    }, 
                    TT = { 
                        enUS = "Suggest (Left Top icon) Consumption if Consumption is not enabled.", 
                        ruRU = "Suggest (Left Top icon) Consumption if Consumption is not enabled.", 
                        frFR = "Suggest (Left Top icon) Consumption if Consumption is not enabled.", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "Consumption",
                    DBV = true,
                    L = { 
                        enUS = "Force Use: Consumption", 
                        ruRU = "Force Use: Consumption", 
                        frFR = "Force Use: Consumption",
                    }, 
                    TT = { 
                        enUS = "Enable use of Consumption if not enabled.", 
                        ruRU = "Enable use of Consumption if not enabled.", 
                        frFR = "Enable use of Consumption if not enabled.", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "PoolDuringBlooddrinker",
                    DBV = true,
                    L = { 
                        enUS = "Pool: Blooddrinker", 
                        ruRU = "Pool: Blooddrinker", 
                        frFR = "Pool: Blooddrinker",
                    }, 
                    TT = { 
                        enUS = "Display the 'Pool' icon whenever you're channeling Blooddrinker as long as you shouldn't interrupt it (supports Quaking).", 
                        ruRU = "Display the 'Pool' icon whenever you're channeling Blooddrinker as long as you shouldn't interrupt it (supports Quaking).", 
                        frFR = "Display the 'Pool' icon whenever you're channeling Blooddrinker as long as you shouldn't interrupt it (supports Quaking).",
                    }, 
                    M = {},
                },                
            },
            { -- [4] 4th Row
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [2] 2nd Row 
                {
                    E = "Checkbox", 
                    DB = "ArcaneTorrent",
                    DBV = true,
                    L = { 
                        enUS = "Force Use: ArcaneTorrent", 
                        ruRU = "Force Use: ArcaneTorrent", 
                        frFR = "Force Use: ArcaneTorrent", 
                    }, 
                    TT = { 
                        enUS = "Enable use of ArcaneTorrent if not enabled.", 
                        ruRU = "Enable use of ArcaneTorrent if not enabled.", 
                        frFR = "Enable use of ArcaneTorrent if not enabled.", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "DancingRuneWeapon",
                    DBV = true,
                    L = { 
                        enUS = "Force Use: DancingRuneWeapon", 
                        ruRU = "Force Use: DancingRuneWeapon", 
                        frFR = "Force Use: DancingRuneWeapon",
                    }, 
                    TT = { 
                        enUS = "Enable use of DancingRuneWeapon if not enabled.", 
                        ruRU = "Enable use of DancingRuneWeapon if not enabled.", 
                        frFR = "Enable use of DancingRuneWeapon if not enabled.", 
                    }, 
                    M = {},
                },                 
            },
            -- Death grip
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(49576) .. " -- ",
                    },
                },
            },
            {
                {
                    E = "Checkbox", 
                    DB = "UseDeathGrip",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. GetSpellInfo(49576), 
                        ruRU = "Авто " .. GetSpellInfo(49576), 
                        frFR = "Auto " .. GetSpellInfo(49576), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(49576) .. " if enemy try to move out.", 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(49576) .. " если враг попытается выйти.", 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(49576) .. " si l'ennemi essaie de partir.",  
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "DeathGripInterrupt",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(49576) .. " interrupt", 
                        ruRU = GetSpellInfo(49576) .. " прерывание", 
                        frFR = GetSpellInfo(49576) .. " interrupt", 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(49576) .. " as interrupt.", 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(49576) .. " как прерывание.", 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(49576) .. " comme interrupt.", 
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Checkbox", 
                    DB = "DeathGripLowHealth",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(49576) .. " low HP(%)", 
                        ruRU = GetSpellInfo(49576) .. " low HP(%)", 
                        frFR = GetSpellInfo(49576) .. " low HP(%)",
                    }, 
                    TT = { 
                        enUS = "Enable this to option to automatically cast " .. GetSpellInfo(49576) .. " when enemy if running out and under specified percent life value.", 
                        ruRU = "Enable this to option to automatically cast " .. GetSpellInfo(49576) .. " when enemy if running out and under specified percent life value.", 
                        frFR = "Enable this to option to automatically cast " .. GetSpellInfo(49576) .. " when enemy if running out and under specified percent life value.", 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathGripHealthPercent",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(49576) .. " HP(%)",
                    }, 
                    M = {},
                },                
            },
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(48792) .. " -- ",
                    },
                },
            },
            { -- [1] 1st Row  
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "IceboundFortitudeIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(48792) .. "\nSkip if " .. GetSpellInfo(49028) .. " used",
                        ruRU = GetSpellInfo(48792) .. "\nSkip if " .. GetSpellInfo(49028) .. " used",  
                        frFR = GetSpellInfo(48792) .. "\nSkip if " .. GetSpellInfo(49028) .. " used", 
                    }, 
                    M = {},
                },     
                {
                    E       = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB      = "IceboundFortitudeTTD",
                    DBV     = 6,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(48792) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(48792) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(48792) .. "\n<= time to die (sec)",  
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
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "IceboundFortitudeCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(48792) .. "\nCatch death hit",
                        ruRU = GetSpellInfo(48792) .. "\nCatch death hit",  
                        frFR = GetSpellInfo(48792) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },
                {
                    E       = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB      = "IceboundFortitudeHP",
                    DBV     = 20,
                    ONLYOFF = true,
                    L = { 
                        enUS = GetSpellInfo(48792) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(48792) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(48792) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
            -- Rune Tap
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(194679) .. " -- ",
                    },
                },
            },
            { -- [1] 1st Row  
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "RuneTapIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(194679) .. "\nSkip if " .. GetSpellInfo(55233) .. " used",
                        ruRU = GetSpellInfo(194679) .. "\nSkip if " .. GetSpellInfo(55233) .. " used",  
                        frFR = GetSpellInfo(194679) .. "\nSkip if " .. GetSpellInfo(55233) .. " used", 
                    }, 
                    M = {},
                },     
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "RuneTapTTD",
                    DBV     = 3,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(194679) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(194679) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(194679) .. "\n<= time to die (sec)",  
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
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "RuneTapCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(194679) .. "\nCatch death hit",
                        ruRU = GetSpellInfo(194679) .. "\nCatch death hit",  
                        frFR = GetSpellInfo(194679) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },
                {
                    E       = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB      = "RuneTapHP",
                    DBV     = 50,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(194679) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(194679) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(194679) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
                {
                    E       = "Slider",                                                     
                    MIN     = 1, 
                    MAX     = 20,                            
                    DB      = "RuneTapUnits",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(194679) .. "\nmin units", 
                        ruRU = GetSpellInfo(194679) .. "\nmin units",   
                        frFR = GetSpellInfo(194679) .. "\nmin units",  
                    }, 
                    TT = { 
                        enUS = "Minimum number of enemies around to use " .. GetSpellInfo(194679) .. ".\nRotation will try to always use it if we got 2 charges.",
                        ruRU = "Minimum number of enemies around to use " .. GetSpellInfo(194679) .. ".\nRotation will try to always use it if we got 2 charges.",
                        frFR = "Minimum number of enemies around to use " .. GetSpellInfo(194679) .. ".\nRotation will try to always use it if we got 2 charges.", 
                    },
                    M = {},
                }, 
            }, 
            -- Vampiric Blood
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(55233) .. " -- ",
                    },
                },
            },
            { -- [1] 1st Row  
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "VampiricBloodIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(55233) .. "\nSkip if " .. GetSpellInfo(49028) .. " used",
                        ruRU = GetSpellInfo(55233) .. "\nSkip if " .. GetSpellInfo(49028) .. " used",  
                        frFR = GetSpellInfo(55233) .. "\nSkip if " .. GetSpellInfo(49028) .. " used", 
                    }, 
                    M = {},
                },     
                {
                    E         = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB         = "VampiricBloodTTD",
                    DBV     = 6,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(55233) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(55233) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(55233) .. "\n<= time to die (sec)",  
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
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "VampiricBloodCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(55233) .. "\nCatch death hit",
                        ruRU = GetSpellInfo(55233) .. "\nCatch death hit",  
                        frFR = GetSpellInfo(55233) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },
                {
                    E       = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB      = "VampiricBloodHP",
                    DBV     = 45,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(55233) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(55233) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(55233) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
            -- Dancing Rune Weapon
            {
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(49028) .. " -- ",
                    },
                },
            },
            { -- [1] 1st Row  
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "DancingRuneWeaponIgnoreBigDeff",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(49028) .. "\nSkip if " .. GetSpellInfo(55233) .. " used",
                        ruRU = GetSpellInfo(49028) .. "\nSkip if " .. GetSpellInfo(55233) .. " used",  
                        frFR = GetSpellInfo(49028) .. "\nSkip if " .. GetSpellInfo(55233) .. " used", 
                    }, 
                    M = {},
                },     
                {
                    E       = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 20,                            
                    DB      = "DancingRuneWeaponTTD",
                    DBV     = 5,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(49028) .. "\n<= time to die (sec)", 
                        ruRU = GetSpellInfo(49028) .. "\n<= time to die (sec)",  
                        frFR = GetSpellInfo(49028) .. "\n<= time to die (sec)",  
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
                RowOptions = { margin = { top = 10 } },            
                {
                    E = "Checkbox", 
                    DB = "DancingRuneWeaponCatchKillStrike",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(49028) .. "\nCatch death hit",
                        ruRU = GetSpellInfo(49028) .. "\nCatch death hit",  
                        frFR = GetSpellInfo(49028) .. "\nCatch death hit", 
                    }, 
                    TT = { 
                        enUS = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!", 
                        ruRU = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",
                        frFR = "Try to manage to use ability before receiving a fatal strike\nThis option is not related to other triggers!",  
                    },
                    M = {},
                },
                {
                    E       = "Slider",                                                     
                    MIN     = -1, 
                    MAX     = 100,                            
                    DB      = "DancingRuneWeaponHP",
                    DBV     = 35,
                    ONLYOFF    = true,
                    L = { 
                        enUS = GetSpellInfo(49028) .. "\n<= health (%)", 
                        ruRU = GetSpellInfo(49028) .. "\n<= health (%)",  
                        frFR = GetSpellInfo(49028) .. "\n<= health (%)", 
                    }, 
                    TT = { 
                        enUS = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",
                        ruRU = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                        frFR = "OFF - The trigger is disabled\n0->100 Less than or equal to the specified percentage of your health\nWARNING: There must be at least one of several triggers turned on\nWhen selecting multiple triggers, they will be synchronized as one general condition",  
                    },
                    M = {},
                }, 
            }, 
            -- Bonestorm
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(194844) .. " -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "BonestormHP",
                    DBV = 80, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(194844) .. " (%)",
                        ruRU = GetSpellInfo(194844) .. " (%)",
                        frFR = GetSpellInfo(194844) .. " (%)",
                    },
                    TT = { 
                        enUS = "Set the HP percent value before using " .. GetSpellInfo(194844) .. ".",
                        ruRU = "Set the HP percent value before using " .. GetSpellInfo(194844) .. ".",
                        frFR = "Set the HP percent value before using " .. GetSpellInfo(194844) .. ".", 
                    }, 
                    M = {},
                },        
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "BonestormRunicPower",
                    DBV = 40, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(194844) .. " \nRunic Power",
                        ruRU = GetSpellInfo(194844) .. " \nRunic Power",
                        frFR = GetSpellInfo(194844) .. " \nRunic Power",
                    },
                    TT = { 
                        enUS = "Set the Runic Power value before using " .. GetSpellInfo(194844) .. ".",
                        ruRU = "Set the Runic Power value before using " .. GetSpellInfo(194844) .. ".",
                        frFR = "Set the Runic Power value before using " .. GetSpellInfo(194844) .. ".",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "BonestormRunicPowerWithVampiricBlood",
                    DBV = 20, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(194844) .. " \nRunic Power with " .. GetSpellInfo(55233),
                        ruRU = GetSpellInfo(194844) .. " \nRunic Power with " .. GetSpellInfo(55233),
                        frFR = GetSpellInfo(194844) .. " \nRunic Power with " .. GetSpellInfo(55233),
                    },
                    TT = { 
                        enUS = "Set the Runic Power value before using " .. GetSpellInfo(194844) .. " IF " .. GetSpellInfo(55233) .. " is active.",
                        ruRU = "Set the Runic Power value before using " .. GetSpellInfo(194844) .. " IF " .. GetSpellInfo(55233) .. " is active.",
                        frFR = "Set the Runic Power value before using " .. GetSpellInfo(194844) .. " IF " .. GetSpellInfo(55233) .. " is active.",
                    }, 
                    M = {},
                },                
            },
            -- AntiMagicShell
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(48707) .. " -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "AntiMagicShellHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(48707) .. " (%)",
                        ruRU = GetSpellInfo(48707) .. " (%)",
                        frFR = GetSpellInfo(48707) .. " (%)",
                    },
                    TT = { 
                        enUS = "Set the HP percent value before using " .. GetSpellInfo(48707) .. ".\nIf set on AUTO, then will use custom logic inside rotation.",
                        ruRU = "Set the HP percent value before using " .. GetSpellInfo(48707) .. ".\nIf set on AUTO, then will use custom logic inside rotation.",
                        frFR = "Set the HP percent value before using " .. GetSpellInfo(48707) .. ".\nIf set on AUTO, then will use custom logic inside rotation.",
                    }, 
                    M = {},
                },        
                {
                    E = "Slider",                                                     
                    MIN = 2, 
                    MAX = 30,                            
                    DB = "AntiMagicShellTTDMagic",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(48707) .. " TTD",
                        ruRU = GetSpellInfo(48707) .. " TTD",
                        frFR = GetSpellInfo(48707) .. " TTD",
                    },
                    TT = { 
                        enUS = "Set the Time To Die value by magic damage before using " .. GetSpellInfo(48707) .. ".",
                        ruRU = "Set the Time To Die value by magic damage before using " .. GetSpellInfo(48707) .. ".",
                        frFR = "Set the Time To Die value by magic damage before using " .. GetSpellInfo(48707) .. ".",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 100,                            
                    DB = "AntiMagicShellTTDMagicHP",
                    DBV = 40, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(48707) .. " TTD(%)",
                        ruRU = GetSpellInfo(48707) .. " TTD(%)",
                        frFR = GetSpellInfo(48707) .. " TTD(%)",
                    },
                    TT = { 
                        enUS = "Set the Time To Die Health Percent value by magic damage before using " .. GetSpellInfo(48707) .. ".",
                        ruRU = "Set the Time To Die Health Percent value by magic damage before using " .. GetSpellInfo(48707) .. ".",
                        frFR = "Set the Time To Die Health Percent value by magic damage before using " .. GetSpellInfo(48707) .. ".",
                    }, 
                    M = {},
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
                    DBV = false,
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
            { -- [4] 4th Row
                
                {
                    E = "LayoutSpace",                                                                         
                },
            },
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- General Defensives -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
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
            { -- [3] 3rd Row 
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathStrikeHP",
                    DBV = 80, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(49998) .. " (%)",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DeathPactHP",
                    DBV = 100, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(48743) .. " (%)",
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
                {
                    E = "Dropdown",                                                         
                    OT = {
                        { text = "Tank", value = 1 },
                        { text = "Healer", value = 2 },
                        { text = "Damager", value = 3 },
                        { text = "Mouseover", value = 4 },
                    },
                    MULT = true,
                    DB = "RaiseAllyUnits",
                    DBV = {
                        [1] = true, 
                        [2] = false,
                        [3] = false,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = GetSpellInfo(61999) .. " units",
                    }, 
                    TT = { 
                        enUS = "Tank: Will only use if current tank is dead.\nHealer: Will only use if current healer is dead.\nDamager: Will only use if one of friendly damager is dead.\nMouseover: Will only use if you are mouseovering a dead target.", 
                        ruRU = "Tank: Will only use if current tank is dead.\nHealer: Will only use if current healer is dead.\nDamager: Will only use if one of friendly damager is dead.\nMouseover: Will only use if you are mouseovering a dead target.",  
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
                {
                    E = "Checkbox", 
                    DB = "UseWraithWalk",
                    DBV = true,
                    L = { 
                        enUS = "Auto" .. GetSpellInfo(212552), 
                        ruRU = "Авто" .. GetSpellInfo(212552), 
                        frFR = "Auto" .. GetSpellInfo(212552), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(212552), 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(212552), 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(212552), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "WraithWalkTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(212552) .. " if moving for",
                        ruRU = GetSpellInfo(212552) .. " если переехать",
                        frFR = GetSpellInfo(212552) .. " si vous bougez pendant",
                    },
                    TT = { 
                        enUS = "If " .. GetSpellInfo(212552) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. GetSpellInfo(212552) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. GetSpellInfo(212552) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
                    }, 
                    M = {},
                },            
            },
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "UseDeathsAdvance",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. GetSpellInfo(48265), 
                        ruRU = "Авто " .. GetSpellInfo(48265), 
                        frFR = "Auto " .. GetSpellInfo(48265), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(48265), 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(48265), 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(48265), 
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 7,                            
                    DB = "DeathsAdvanceTime",
                    DBV = 3, -- Set healthpercentage @60% life. 
                    ONOFF = true,
                    L = { 
                        enUS = GetSpellInfo(48265) .. " if moving for",
                        ruRU = GetSpellInfo(48265) .. " если переехать",
                        frFR = GetSpellInfo(48265) .. " si vous bougez pendant",
                    },
                    TT = { 
                        enUS = "If " .. GetSpellInfo(48265) .. " is talented and ready, will use it if moving for set value.", 
                        ruRU = "Если " .. GetSpellInfo(48265) .. " изучен и готов, будет использовать его при переходе на заданное значение.", 
                        frFR = "Si " .. GetSpellInfo(48265) .. " est prêt, l'utilisera s'il se déplace pour la valeur définie.", 
                    }, 
                    M = {},
                },            
            },
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "UseDeathGrip",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. GetSpellInfo(49576), 
                        ruRU = "Авто " .. GetSpellInfo(49576), 
                        frFR = "Auto " .. GetSpellInfo(49576), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(49576) .. " if enemy try to move out.", 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(49576) .. " если враг попытается выйти.", 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(49576) .. " si l'ennemi essaie de partir.",  
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "DeathGripInterrupt",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(49576) .. " interrupt", 
                        ruRU = GetSpellInfo(49576) .. " прерывание", 
                        frFR = GetSpellInfo(49576) .. " interrupt", 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(49576) .. " as interrupt.", 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(49576) .. " как прерывание.", 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(49576) .. " comme interrupt.", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "GorefiendsGraspInterrupt",
                    DBV = true,
                    L = { 
                        enUS = GetSpellInfo(108199) .. " interrupt", 
                        ruRU = GetSpellInfo(108199) .. " прерывание", 
                        frFR = GetSpellInfo(108199) .. " interrupt", 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(108199) .. " as interrupt.", 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(108199) .. " как прерывание.", 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(108199) .. " comme interrupt.", 
                    }, 
                    M = {},
                },
                {
                    E = "Checkbox", 
                    DB = "UseChainsofIce",
                    DBV = true,
                    L = { 
                        enUS = "Auto " .. GetSpellInfo(45524), 
                        ruRU = "Авто " .. GetSpellInfo(45524), 
                        frFR = "Auto " .. GetSpellInfo(45524), 
                    }, 
                    TT = { 
                        enUS = "Automatically use " .. GetSpellInfo(45524), 
                        ruRU = "Автоматически использовать " .. GetSpellInfo(45524), 
                        frFR = "Utiliser automatiquement " .. GetSpellInfo(45524), 
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
                    DB = "AsphyxiatePvP",
                    DBV = "ON MELEE BURST",
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(221562),
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
                    DB = "AsphyxiatePvPUnits",
                    DBV = {
                        [1] = true, 
                        [2] = true,
                        [3] = true,
                        [4] = true,
                    }, 
                    L = { 
                        ANY = "PvP " .. GetSpellInfo(221562) .. " units",
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
        [ACTION_CONST_DEATHKNIGHT_UNHOLY] = { 
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
        [ACTION_CONST_DEATHKNIGHT_FROST] = {  
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
        [ACTION_CONST_DEATHKNIGHT_BLOOD] = {  
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

