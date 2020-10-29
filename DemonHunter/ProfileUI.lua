--#########################################
--##### TRIP'S DEMON HUNTER PROFILEUI #####
--#########################################

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
        [ACTION_CONST_DEMONHUNTER_HAVOC] = {   
            LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },        
            { -- [7]
                {
                    E = "Header",
                    L = {
                        ANY = " -- General -- ",
                    },
                },
            },            
            {
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
            { -- [2] 2nd Row 
                {
                    E = "Checkbox", 
                    DB = "UseMoves",
                    DBV = true,
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
                    DB = "HoABossOnly",
                    DBV = true,
                    L = { 
                        enUS = "HoA Boss Only", 
                        ruRU = "HoA Boss Only",
                        frFR = "HoA Boss Only", 
                    }, 
                    TT = { 
                        enUS = "Use Hearth of Azeroth only on bosses", 
                        ruRU = "Используйте очаг Азерота только на боссов", 
                        frFR = "Utilisez le Coeur d'Azeroth uniquement sur les boss", 
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
                        ANY = " -- Prepull Options -- ",
                    },
                },
            },
            { -- [3] 3rd Row     
                -- Azshara Trinket                
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "AzsharasFontofPowerPrePull",
                    DBV = 6, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(296962) .. " sec",
                    },
                    TT = { 
                        enUS = "Set the Pull timer in seconds to use " .. GetSpellInfo(296962) .. ".", 
                        ruRU = "Set the Pull timer in seconds to use " .. GetSpellInfo(296962) .. ".", 
                        frFR = "Set the Pull timer in seconds to use " .. GetSpellInfo(296962) .. ".", 
                    },                     
                    M = {},
                },
                -- Immolation Aura                
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "ImmolationAuraPrePull",
                    DBV = 4, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(258920) .. " sec",
                    },
                    TT = { 
                        enUS = "Set the Pull timer in seconds to use " .. GetSpellInfo(258920) .. ".", 
                        ruRU = "Set the Pull timer in seconds to use " .. GetSpellInfo(258920) .. ".", 
                        frFR = "Set the Pull timer in seconds to use " .. GetSpellInfo(258920) .. ".",  
                    },                     
                    M = {},
                },
            },
            {
                -- Arcane Torrent                
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "ArcaneTorrentPrePull",
                    DBV = 3, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(28730) .. " sec",
                    },
                    TT = { 
                        enUS = "Set the Pull timer in seconds to use " .. GetSpellInfo(28730) .. ".", 
                        ruRU = "Set the Pull timer in seconds to use " .. GetSpellInfo(28730) .. ".", 
                        frFR = "Set the Pull timer in seconds to use " .. GetSpellInfo(28730) .. ".",  
                    },                     
                    M = {},
                },    
                -- UnbridledFury            
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 10,                            
                    DB = "UnbridledFuryPrePull",
                    DBV = 2, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(300714) .. " sec",
                    },
                    TT = { 
                        enUS = "Set the Pull timer in seconds to use " .. GetSpellInfo(300714) .. ".", 
                        ruRU = "Set the Pull timer in seconds to use " .. GetSpellInfo(300714) .. ".", 
                        frFR = "Set the Pull timer in seconds to use " .. GetSpellInfo(300714) .. ".",  
                    },                     
                    M = {},
                },                
            },
            
            -- FelBlade
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(232893) .. " -- ",
                    },
                },
            },
            { -- [3] 3rd Row
                {
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
                {
                    E = "Checkbox", 
                    DB = "FelBladeOutOfRange",
                    DBV = false,
                    L = { 
                        enUS = "FelBlade Out Of Range", 
                        ruRU = "FelBlade Out Of Range",
                        frFR = "FelBlade Out Of Range", 
                    }, 
                    TT = { 
                        enUS = "If activated, will FelBlade Out Of Range depending on the maximum range you set in above settings.", 
                        ruRU = "If activated, will FelBlade Out Of Range depending on the maximum range you set in above settings.", 
                        frFR = "If activated, will FelBlade Out Of Range depending on the maximum range you set in above settings.", 
                    }, 
                    M = {},
                },             
                {
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
            {
                {
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
                {
                    E = "Slider",                                                     
                    MIN = 5, 
                    MAX = 120,                            
                    DB = "FelBladeFury",
                    DBV = 60, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(232893) .. " fury",
                    },
                    TT = { 
                        enUS = "Set the amount of fury before using " .. GetSpellInfo(232893) .. ".", 
                        ruRU = "Set the amount of fury before using " .. GetSpellInfo(232893) .. ".", 
                        frFR = "Set the amount of fury before using " .. GetSpellInfo(232893) .. ".", 
                    },                     
                    M = {},
                },
            },                
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(198013) .. " -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "SyncBladeDanceDeathSweepWithEyeBeam",
                    DBV = false,
                    L = { 
                        enUS = "BladeDance Sync EyeBeam", 
                        ruRU = "BladeDance Sync EyeBeam", 
                        frFR = "BladeDance Sync EyeBeam", 
                    }, 
                    TT = { 
                        enUS = "If activated, will pool BladeDance if cooldown of EyeBeam > (9 / (1 + Player:HastePct() * 0.01))", 
                        ruRU = "If activated, will pool BladeDance if cooldown of EyeBeam > (9 / (1 + Player:HastePct() * 0.01))", 
                        frFR = "If activated, will pool BladeDance if cooldown of EyeBeam > (9 / (1 + Player:HastePct() * 0.01))", 
                    }, 
                    M = {},
                },     
                {
                    E = "Slider",                                                     
                    MIN = 1, 
                    MAX = 15,                            
                    DB = "BladeDancePoolSeconds",
                    DBV = 15, -- Set healthpercentage @30% life. 
                    Precision = 1,
                    ONOFF = false,
                    L = { 
                        ANY = GetSpellInfo(188499) .. "\nPool secs",
                    },
                    TT = { 
                        enUS = "Define the value in seconds you want to be pooling " .. GetSpellInfo(188499) .. " in order to sync it with next " .. GetSpellInfo(198013) .. ".\nAUTO: will pool BladeDance if cooldown of EyeBeam > (9 / (1 + Player:HastePct() * 0.01))", 
                        ruRU = "Define the value in seconds you want to be pooling " .. GetSpellInfo(188499) .. " in order to sync it with next " .. GetSpellInfo(198013) .. ".\nAUTO: will pool BladeDance if cooldown of EyeBeam > (9 / (1 + Player:HastePct() * 0.01))",  
                        frFR = "Define the value in seconds you want to be pooling " .. GetSpellInfo(188499) .. " in order to sync it with next " .. GetSpellInfo(198013) .. ".\nAUTO: will pool BladeDance if cooldown of EyeBeam > (9 / (1 + Player:HastePct() * 0.01))",  
                    },                     
                    M = {},
                },                
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
            {            
                {
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
                {
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
            { -- [7] 
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
                    MAX = 40,                          
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
            {
                {
                    E = "Checkbox", 
                    DB = "UnbridledFuryWithSecondMeta",
                    DBV = false,
                    L = { 
                        enUS = "Sync 2nd Meta", 
                        ruRU = "Sync 2nd Meta", 
                        frFR = "Sync 2nd Meta", 
                    }, 
                    TT = { 
                        enUS = "If activated, will auto re pots as soon as you recast Metamorphosis.", 
                        ruRU = "If activated, will auto re pots as soon as you recast Metamorphosis.", 
                        frFR = "If activated, will auto re pots as soon as you recast Metamorphosis.", 
                    }, 
                    M = {},
                }, 
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
                        ANY = GetSpellInfo(300714) .. " HP",
                    },
                    TT = { 
                        enUS = "Set the minimum health percent for a unit before using " .. GetSpellInfo(300714) .. ".", 
                        ruRU = "Set the minimum health percent for a unit before using " .. GetSpellInfo(300714) .. ".",  
                        frFR = "Set the minimum health percent for a unit before using " .. GetSpellInfo(300714) .. ".", 
                    },                     
                    M = {},
                },
            },    
            { -- [7] 
                {
                    E = "Header",
                    L = {
                        ANY = " -- " .. GetSpellInfo(196718) .. " -- ",
                    },
                },
            },
            { -- [3] 3rd Row 
                {
                    E = "Checkbox", 
                    DB = "AutoDarkness",
                    DBV = false,
                    L = { 
                        ANY = "Auto " .. GetSpellInfo(196718),
                    },
                    TT = { 
                        enUS = "If activated, will auto use " .. GetSpellInfo(196718) .. " depending on currents settings.\nFor high end raiding, it is recommanded to keep Darkness when your Raid Leader call it.",
                        ruRU = "Если активирован, будет автоматически использовать " .. GetSpellInfo(196718) .. " в зависимости от настроек токов.\nДля рейдового сегмента рекомендуется держать Тьму, когда ваш Рейдовый Лидер называет это.",
                        frFR = "Si activé, utilisera automatiquement " .. GetSpellInfo(196718) .. " en fonction des paramètres de courant.\nPour les raids de haut niveau, il est recommandé de garder Ténèbres lorsque votre chef de raid l'appelle.",
                    }, 
                    M = {},
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
                {
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
            }, -- [4] 4th Row
            {
                {
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
                {
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
                    DB = "Blur",
                    DBV = 100, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(198589) .. " (%)",
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
            { -- [3] 3rd Row 
                {
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
                    DB = "BrandForDamage",
                    DBV = true,
                    L = { 
                        enUS = "Fiery Brand for DPS", 
                        ruRU = "Fiery Brand for DPS", 
                        frFR = "Fiery Brand for DPS",
                    }, 
                    TT = { 
                        enUS = "Use Fiery Brand as a DPS ability when using the Charred Flesh talent.", 
                        ruRU = "Use Fiery Brand as a DPS ability when using the Charred Flesh talent.", 
                        frFR = "Use Fiery Brand as a DPS ability when using the Charred Flesh talent.", 
                    }, 
                    M = {},
                }, 
                {
                    E = "Checkbox", 
                    DB = "ConserveInfernalStrike",
                    DBV = true,
                    L = { 
                        enUS = "Conserve Infernal Strike", 
                        ruRU = "Conserve Infernal Strike", 
                        frFR = "Conserve Infernal Strike",
                    }, 
                    TT = { 
                        enUS = "Save at least 1 Infernal Strike charge for mobility.", 
                        ruRU = "Save at least 1 Infernal Strike charge for mobility.", 
                        frFR = "Save at least 1 Infernal Strike charge for mobility.",
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
                        enUS = "If activated, will use automatically use Torment whenever available.", 
                        ruRU = "If activated, will use automatically use Torment whenever available.",  
                        frFR = "If activated, will use automatically use Torment whenever available.", 
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
                    DB = "MetamorphosisHealthThreshold",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Metamorphosis Health Threshold",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "FieryBrandHealthThreshold",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Fiery Brand Health Threshold",
                    }, 
                    M = {},
                },
            },
            {
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "DemonSpikesHealthThreshold",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Demon Spikes Health Threshold",
                    }, 
                    M = {},
                },
                {
                    E = "Slider",                                                     
                    MIN = -1, 
                    MAX = 100,                            
                    DB = "Blur",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Blur Health Threshold",
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


