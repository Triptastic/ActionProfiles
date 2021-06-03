--############################
--##### TRIP'S HUNTER UI #####
--############################

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
    DateTime = "v1.0.0 (02.06.2021)",
    -- Class settings
    [2] = {        
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
                    M = {},
                },				
            },
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 
			{ -- PET HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< ROTATION STUFF ><><><l ",
                    },
                },
            },
			{
				{ -- MultiShot
                    E = "Checkbox", 
                    DB = "MultiShotST",
                    DBV = true,
                    L = { 
                        ANY = "MultiShot Single Target", 
                    }, 
                    TT = { 
                        ANY = "This is an overall DPS gain but be careful if you need to cc nearby targets.", 
                    }, 
                    M = {},
                },
				{ -- AutoSyncCDs
                    E = "Checkbox", 
                    DB = "AutoSyncCDs",
                    DBV = true,
                    L = { 
                        ANY = "Automatically Sync CDs", 
                    }, 
                    TT = { 
                        ANY = "Check this box to automatically use your cooldowns during Bloodlust/Heroism/Drums.", 
                    }, 
                    M = {},
                },
			},
			{
                { -- Mana Value
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ManaSave",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Save Mana (%)",
                    },
                    TT = { 
                        ANY = "Value (%) to not spend mana (will still use emergency abilities, however.)", 
                    },                     
                    M = {},
                },				
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            },  
			{ -- PET HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< PET CARE ><><><l ",
                    },
                },
            },
			{
                { -- MEND PET
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "MendPet",
                    DBV = 30, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(13543) .. " HP(%)",
                    },
                    TT = { 
                        ANY = "Set your pet HP % for using " .. GetSpellInfo(13543), 
                    },                     
                    M = {},
                },
			},			
		},
}