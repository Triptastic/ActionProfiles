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
local TR                                            = Action.TasteRotation
local select, setmetatable							= select, setmetatable

A.Data.ProfileEnabled[Action.CurrentProfile] = true
A.Data.ProfileUI = {    
    DateTime = "v1.0.0 (10 December 2020)",
    -- Class settings
    [2] = {        
        [ACTION_CONST_HUNTER_BEASTMASTERY] = { 
		LayoutOptions = { gutter = 4, padding = { left = 5, right = 5 } },    
        },
        [ACTION_CONST_HUNTER_SURVIVAL] = { 
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
                { -- EAGLE RANGE
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 40,                            
                    DB = "EagleRange",
                    DBV = 10, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = "Range from target to use " .. GetSpellInfo(186289),
                    },
                    TT = { 
                        ANY = "Set your distance from your current target before using " .. GetSpellInfo(186289), 
                    },                     
                    M = {},
                },
			},
            { -- LAYOUT SPACE   
                {
                    E = "LayoutSpace",                                                                         
                },
            }, 
			{ -- LEGENARDIES HEADER
                {
                    E = "Header",
                    L = {
                        ANY = " l><><>< LEGENDARIES ><><><l ",
                    },
                },
            },
			{
                { -- NESINGWARY'S
                    E = "Checkbox", 
                    DB = "Nessingwarys",
                    DBV = false,
                    L = { 
                        ANY = "Nesingwary's Trapping Apparatus"
                    }, 
                    TT = { 
                        ANY = "Tick this if you're currently wearing Nesingwary's Trapping Apparatus."
                    }, 
                    M = {},
                },
                { -- RYLAKSTALKERS
                    E = "Checkbox", 
                    DB = "Rylakstalkers",
                    DBV = false,
                    L = { 
                        ANY = "Rylakstalker's Confounding Strikes"
                    }, 
                    TT = { 
                        ANY = "Tick this if you're currently wearing Rylakstalker's Confounding Strikes."
                    }, 
                    M = {},
                },
                { -- EMBERS
                    E = "Checkbox", 
                    DB = "Embers",
                    DBV = false,
                    L = { 
                        ANY = "Soulforge Embers"
                    }, 
                    TT = { 
                        ANY = "Tick this if you're currently wearing Soulforge Embers."
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
			{
                { -- TURTLE
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "ExhilarationHP",
                    DBV = 40, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(109304) .. " HP(%)",
                    },
                    TT = { 
                        ANY = "Set your HP % for using " .. GetSpellInfo(109304), 
                    },                     
                    M = {},
                },			
                { -- TURTLE
                    E = "Slider",                                                     
                    MIN = 0, 
                    MAX = 100,                            
                    DB = "Turtle",
                    DBV = 20, -- Set healthpercentage @30% life. 
                    ONOFF = true,
                    L = { 
                        ANY = GetSpellInfo(186265) .. " HP(%)",
                    },
                    TT = { 
                        ANY = "Set your HP % for using " .. GetSpellInfo(186265), 
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
                        ANY = GetSpellInfo(982) .. " HP(%)",
                    },
                    TT = { 
                        ANY = "Set your pet HP % for using " .. GetSpellInfo(982), 
                    },                     
                    M = {},
                },
			},			
		},
        [ACTION_CONST_HUNTER_MARKSMANSHIP] = { 
    },
},	
    -- MSG Actions UI
    [7] = {
        [ACTION_CONST_HUNTER_BEASTMASTERY] = { 
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
        [ACTION_CONST_HUNTER_MARKSMANSHIP] = { 
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
        [ACTION_CONST_HUNTER_SURVIVAL] = { 
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
    
    if A[A.PlayerSpec] and A[A.PlayerSpec].Counterspell and A[A.PlayerSpec].Counterspell:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Counterspell:AbsentImun(unit, {"KickImun", "TotalImun", "DamagePhysImun"}, true) and A.InterruptIsValid(unit, list) then 
        return true         
    end 
end 

function A.Second_CastBars(unit)
    if not A.IsInitialized or (A.Zone ~= "arena" and A.Zone ~= "pvp") then 
        return false 
    end 
    
    local Toggle = A.GetToggle(2, "PolymorphPvP")    
    if Toggle and Toggle ~= "OFF" and A[A.PlayerSpec] and A[A.PlayerSpec].Polymorph and A[A.PlayerSpec].Polymorph:IsReadyP(unit, nil, true) and A[A.PlayerSpec].Polymorph:AbsentImun(unit, {"CCTotalImun", "TotalImun", "DamagePhysImun"}, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
        if Toggle == "BOTH" then 
            return select(2, A.InterruptIsValid(unit, "Heal", true)) or select(2, A.InterruptIsValid(unit, "PvP", true)) 
        else
            return select(2, A.InterruptIsValid(unit, Toggle, true))         
        end 
    end 
end 

