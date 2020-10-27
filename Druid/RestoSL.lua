-------------------------------
-- Taste TMW Action Rotation --
-------------------------------
local TMW                                       = TMW
local CNDT                                      = TMW.CNDT
local Env                                       = CNDT.Env
local HealingEngine                             = Action.HealingEngine
--local Pet                                     = LibStub("PetLibrary")
--local Azerite                                 = LibStub("AzeriteTraits")
local Action                                    = Action
local Listener                                    = Action.Listener
local Create                                    = Action.Create
local GetToggle                                    = Action.GetToggle
local SetToggle                                    = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                                = Action.GetCurrentGCD
local GetPing                                    = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                    = Action.BurstIsON
local AuraIsValid                                = Action.AuraIsValid
local InterruptIsValid                            = Action.InterruptIsValid
local FrameHasSpell                                = Action.FrameHasSpell
local Azerite                                    = LibStub("AzeriteTraits")
local Utils                                        = Action.Utils
local TeamCache                                    = Action.TeamCache
local TeamCacheFriendly                         = TeamCache.Friendly
local TeamCacheFriendlyIndexToPLAYERs           = TeamCacheFriendly.IndexToPLAYERs
local HealingEngineMembersALL                   = HealingEngine.GetMembersAll() -- function call!
local EnemyTeam                                    = Action.EnemyTeam
local FriendlyTeam                                = Action.FriendlyTeam
local LoC                                        = Action.LossOfControl
local Player                                    = Action.Player 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                                = Action.UnitCooldown
local Unit                                        = Action.Unit 
local IsUnitEnemy                                = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                            = MultiUnits:GetActiveUnitPlates()
local _G, setmetatable                            = _G, setmetatable
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local TR                                        = Action.TasteRotation
local pairs                                     = pairs
local Pet                                       = LibStub("PetLibrary")
local next, pairs, type, print                  = next, pairs, type, print
local wipe                                      = wipe 
local math_floor                                = math.floor
local math_ceil                                 = math.ceil
local tinsert                                   = table.insert 
local TMW                                       = TMW
local _G, setmetatable                          = _G, setmetatable
local select, unpack, table, pairs              = select, unpack, table, pairs 
local CombatLogGetCurrentEventInfo              = _G.CombatLogGetCurrentEventInfo
local UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower = UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DRUID_RESTORATION] = {
    -------------------------------------------------------------------------------------
    -- Racial
    Darkflight                                    = Create({ Type = "Spell", ID = 68992    }),
    ArcaneTorrent                             = Create({ Type = "Spell", ID = 50613     }),
    BloodFury                                 = Create({ Type = "Spell", ID = 20572      }),
    Fireblood                                 = Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                             = Create({ Type = "Spell", ID = 274738     }),
    Berserking                                = Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                               = Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                               = Create({ Type = "Spell", ID = 107079     }),
    Haymaker                                  = Create({ Type = "Spell", ID = 287712     }), 
    WarStomp                                  = Create({ Type = "Spell", ID = 20549     }),
    BullRush                                  = Create({ Type = "Spell", ID = 255654     }),    
    GiftofNaaru                               = Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                                = Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                                 = Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                               = Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                         = Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it    
    EscapeArtist                              = Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                        = Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Roots   
    EntanglingRoots                           = Create({ Type = "Spell", ID = 339    }),
    MassEntanglement                          = Create({ Type = "Spell", ID = 102359, isTalent = true   }), 
    -- Disorient
    Cyclone                                   = Create({ Type = "Spell", ID = 33786, isTalent = true   }), -- PvP Talent
    -- Stun
    MightyBash                                = Create({ Type = "Spell", ID = 5211, isTalent = true   }),
    -- Knockbacks
    Typhoon                                   = Create({ Type = "Spell", ID = 132469, isTalent = true   }),
    -- Hots
    Lifebloom                                 = Create({ Type = "Spell", ID = 33763, predictName = "Lifebloom"     }),
    Rejuvenation                              = Create({ Type = "Spell", ID = 774, predictName = "Rejuvenation"     }),
    RejuvenationGermimation                   = Create({ Type = "Spell", ID = 155777, predictName = "Rejuvenation"    }),
    WildGrowth                                = Create({ Type = "Spell", ID = 48438, predictName = "WildGrowth"     }),
    CenarionWard                              = Create({ Type = "Spell", ID = 102351, isTalent = true, predictName = "CenarionWard"     }),
    -- Direct Heals
    Regrowth                                  = Create({ Type = "Spell", ID = 8936, predictName = "Regrowth"     }),
    Swiftmend                                 = Create({ Type = "Spell", ID = 18562, predictName = "Swiftmend"     }),
    -- Self Defensives
    Barkskin                                  = Create({ Type = "Spell", ID = 22812     }),	
	VitalityConduit                           = Create({ Type = "Spell", ID = 299959     }),
	HeartoftheWild                            = Create({ Type = "Spell", ID = 319454, isTalent = true     }),
	EclipseSolar                              = Create({ Type = "Spell", ID = 48517     }),
	EclipseLunar                              = Create({ Type = "Spell", ID = 48518     }),
    -- Cooldowns
    Ironbark                                  = Create({ Type = "Spell", ID = 102342     }),
    Tranquility                               = Create({ Type = "Spell", ID = 740, predictName = "Tranquility"     }),
    Innervate                                 = Create({ Type = "Spell", ID = 29166     }),
    -- Shapeshift
    TravelForm                                = Create({ Type = "Spell", ID = 783     }), 
    BearForm                                  = Create({ Type = "Spell", ID = 5487     }), 
    CatForm                                   = Create({ Type = "Spell", ID = 768     }), 
    AquaticForm                               = Create({ Type = "Spell", ID = 276012     }),     
    -- Utilities
    UrsolVortex                               = Create({ Type = "Spell", ID = 102793     }),
    NaturesCure                               = Create({ Type = "Spell", ID = 88423     }),  
    Dash                                      = Create({ Type = "Spell", ID = 1850     }), 
    Rebirth                                   = Create({ Type = "Spell", ID = 20484     }),  -- Combat Rez
    Revive                                    = Create({ Type = "Spell", ID = 50769     }), 
    Hibernate                                 = Create({ Type = "Spell", ID = 2637     }), 
    Soothe                                    = Create({ Type = "Spell", ID = 2908     }), 
    Prowl                                     = Create({ Type = "Spell", ID = 5215     }), 
    Revitalize                                = Create({ Type = "Spell", ID = 212040     }), 
    WildCharge                                = Create({ Type = "Spell", ID = 102401, isTalent = true     }),
    -- Healing Spells       
    Efflorescence                             = Create({ Type = "Spell", ID = 145205, predictName = "Efflorescence"     }),
    Renewal                                   = Create({ Type = "Spell", ID = 108238, isTalent = true     }),
    -- Talents
    SouloftheForest                           = Create({ Type = "Spell", ID = 114108, isTalent = true, Hidden = true     }),
    IncarnationTreeofLife                     = Create({ Type = "Spell", ID = 33891, isTalent = true     }),
    IncarnationTreeofLifeBuff                 = Create({ Type = "Spell", ID = 117679, Hidden = true     }),
    Flourish                                  = Create({ Type = "Spell", ID = 197721, isTalent = true     }),
    Photosynthesis                            = Create({ Type = "Spell", ID = 274902, isTalent = true, Hidden = true     }),
    Germination                               = Create({ Type = "Spell", ID = 155675, isTalent = true, Hidden = true     }),
    GuardianAffinity                          = Create({ Type = "Spell", ID = 197491, isTalent = true, Hidden = true     }),
    FeralAffinity                             = Create({ Type = "Spell", ID = 197490, isTalent = true, Hidden = true     }),
    BalanceAffinity                           = Create({ Type = "Spell", ID = 197632, isTalent = true, Hidden = true     }),    
    InnerPeace                                = Create({ Type = "Spell", ID = 197073, isTalent = true, Hidden = true     }),
    Stonebark                                 = Create({ Type = "Spell", ID = 197061, isTalent = true, Hidden = true     }),
    Prosperity                                = Create({ Type = "Spell", ID = 200383, isTalent = true, Hidden = true     }),
    Abundance                                   = Create({ Type = "Spell", ID = 207383, isTalent = true, Hidden = true     }),
    SpringBlossoms                            = Create({ Type = "Spell", ID = 207385, isTalent = true, Hidden = true     }),
    Cultivation                               = Create({ Type = "Spell", ID = 200390, isTalent = true, Hidden = true     }),
    -- PvP Talents
    Disentanglement                           = Create({ Type = "Spell", ID = 233673, isTalent = true, Hidden = true     }),
    EntanglingBark                            = Create({ Type = "Spell", ID = 247543, isTalent = true, Hidden = true     }),
    EarlySpring                               = Create({ Type = "Spell", ID = 203624, isTalent = true, Hidden = true     }),
    Nourish                                   = Create({ Type = "Spell", ID = 289022, isTalent = true, predictName = "Nourish"     }),
    Overgrowth                                = Create({ Type = "Spell", ID = 203651, isTalent = true, predictName = "Overgrowth"     }),
    Thorns                                    = Create({ Type = "Spell", ID = 236696, isTalent = true     }),
    DeepRoots                                 = Create({ Type = "Spell", ID = 233755, isTalent = true, Hidden = true     }),        
    MarkoftheWild                             = Create({ Type = "Spell", ID = 289318, isTalent = true     }),
    FocusedGrowth                             = Create({ Type = "Spell", ID = 203553, isTalent = true, Hidden = true     }),
    MasterShapeshifter                        = Create({ Type = "Spell", ID = 289237, isTalent = true     }),
    -- Azerites
    AutumnLeaves                              = Create({ Type = "Spell", ID = 274432, Hidden = true     }),
    EarlyHarvest                              = Create({ Type = "Spell", ID = 287251, Hidden = true     }),
    GroveTending                              = Create({ Type = "Spell", ID = 279778, Hidden = true     }),
    LivelySpirit                              = Create({ Type = "Spell", ID = 279642, Hidden = true     }),
    RampantGrowth                             = Create({ Type = "Spell", ID = 278515, Hidden = true     }),
    WakingDream                               = Create({ Type = "Spell", ID = 278513, Hidden = true     }),
    -- Offensives Spells
    Moonfire                                  = Create({ Type = "Spell", ID = 8921     }),
    MoonfireDebuff                            = Create({ Type = "Spell", ID = 164812     }),
    Sunfire                                   = Create({ Type = "Spell", ID = 93402     }),
    SunfireDebuff                             = Create({ Type = "Spell", ID = 164815     }),
    SolarWrath                                = Create({ Type = "Spell", ID = 5176     }),
    Mutilate                                  = Create({ Type = "Spell", ID = 33917     }),
    -- Offensives abilities with Affinity
    -- Boomkin
    Starsurge                                 = Create({ Type = "Spell", ID = 197626     }),
    LunarStrike                               = Create({ Type = "Spell", ID = 197628     }),
    MoonkinForm                               = Create({ Type = "Spell", ID = 24858     }),
    -- Guardian
    FrenziedRegeneration                      = Create({ Type = "Spell", ID = 22842, predictName = "FrenziedRegeneration"     }),
    Ironfur                                   = Create({ Type = "Spell", ID = 192081     }),
    Thrash                                    = Create({ Type = "Spell", ID = 77758     }),
    Mangle                                    = Create({ Type = "Spell", ID = 22570   }),
    -- Feral
    Shred                                     = Create({ Type = "Spell", ID = 5221     }),
    Rip                                       = Create({ Type = "Spell", ID = 1079     }),
    FerociousBite                             = Create({ Type = "Spell", ID = 22568     }),
    Rake                                      = Create({ Type = "Spell", ID = 1822     }),
    RakeDebuff                                = Create({ Type = "Spell", ID = 155722    ,    Hidden = true }),
    Swipe                                     = Create({ Type = "Spell", ID = 106785 }),
    -- Items
    PotionofReconstitution                    = Create({ Type = "Potion", ID = 168502     }),     
    CoastalManaPotion                         = Create({ Type = "Potion", ID = 152495     }), 
    -- Hidden 
    ClearCasting                              = Create({ Type = "Spell", ID = 16870,    Hidden = true }), -- 4/1 Talent +2y increased range of LegSweep  
    TigerTailSweep                            = Create({ Type = "Spell", ID = 264348,     isTalent = true, Hidden = true }), -- 4/1 Talent +2y increased range of LegSweep    
    RisingMist                                = Create({ Type = "Spell", ID = 274909,     isTalent = true, Hidden = true }), -- 7/3 Talent "Fistweaving Rotation by damage healing"
    SpiritoftheCrane                          = Create({ Type = "Spell", ID = 210802,     isTalent = true, Hidden = true }), -- 3/2 Talent "Mana regen by BlackoutKick"
    TeachingsoftheMonastery                   = Create({ Type = "Spell", ID = 202090,     Hidden = true }), -- Buff condition for Blackout Kick
    PoolResource                              = Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    DummyTest                                 = Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon    
    --Mythic Plus Spells 
    Quake                                     = Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
    Burst                                     = Create({ Type = "Spell", ID = 240443, Hidden = true     }), -- Bursting (Mythic Plus Affix) Upon death the creature Bursts, inflicting damage equal to (35 / 10)% of maximum health every 1 sec.
    GrievousWound                             = Create({ Type = "Spell", ID = 240559, Hidden = true     }), -- Grievous (Mythic Plus Affix) 2% of a player's maximum health every 3 sec
    Slow                                      = Create({ Type = "Spell", ID = 313255, Hidden = true     }), -- Shadhar slow
    Fixate                                    = Create({ Type = "Spell", ID = 318078, Hidden = true     }), -- Wrathion Fixate
}

Action:CreateEssencesFor(ACTION_CONST_DRUID_RESTORATION)
local A = setmetatable(Action[ACTION_CONST_DRUID_RESTORATION], { __index = Action })
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    AttackTypes                             = {"TotalImun", "DamageMagicImun"},
    AuraForStun                                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},    
    AuraForCC                                = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    AuraForOnlyCCAndStun                    = {"CCTotalImun", "StunImun"},
    AuraForDisableMag                        = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    AuraForInterrupt                        = {"TotalImun", "DamagePhysImun", "KickImun"},
}
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local GetTotemInfo, IsMouseButtonDown, UnitIsUnit = GetTotemInfo, IsMouseButtonDown, UnitIsUnit

local player = "player"
local targettarget = "targettarget"
local target = "target"
local mouseover = "mouseover"
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Call to avoid lua limit of 60upvalues 
-- Call RotationsVariables in each function that need these vars
local function RotationsVariables()
    UseDBM = GetToggle(1 ,"DBM") -- Don't call it DBM else it broke all the global DBM var used by another addons
    Potion = GetToggle(1, "Potion")
    Racial = GetToggle(1, "Racial")
    HeartOfAzeroth = GetToggle(1, "HeartOfAzeroth")
    MouseOver = GetToggle(2, "mouseover")
    -- ProfileUI vars
    UseRotationPassive = GetToggle(2, "UseRotationPassive")
    ManaManagement = GetToggle(2, "ManaManagement")
    ManaPotion = GetToggle(2, "ManaPotion")
    StopCastOverHeal = GetToggle(2, "StopCastOverHeal")
    StartByPreCast = GetToggle(2, "StartByPreCast")
    AutoDispel = GetToggle(2, "AutoDispel")
    MythicPlusLogic = GetToggle(2, "MythicPlusLogic")
    StopCastOverHeal = GetToggle(2, "StopCastOverHeal")
    StopCastQuake = GetToggle(2, "StopCastQuake")
    StopCastQuakeSec = GetToggle(2, "StopCastQuakeSec")
    RacialBurstHealing = GetToggle(2, "RacialBurstHealing")
    RacialBurstDamaging = GetToggle(2, "RacialBurstDamaging")
    TrinketBurstSyncUP = GetToggle(2, "TrinketBurstSyncUP")
    TrinketMana = GetToggle(2, "TrinketMana")
    TrinketBurstHealing = GetToggle(2, "TrinketBurstHealing")
    LucidDreamManaPercent = GetToggle(2, "LucidDreamManaPercent")
    LifeBindersInvocationUnits = GetToggle(2, "LifeBindersInvocationUnits")
    LifeBindersInvocationHP = GetToggle(2, "LifeBindersInvocationHP")
    LifebloomHP = GetToggle(2, "LifebloomHP")
    LifebloomWorkMode = GetToggle(2, "LifebloomWorkMode")
    TranquilityRaidHP = GetToggle(2, "TranquilityRaidHP")
    TranquilityRaidUnits = GetToggle(2, "TranquilityRaidUnits")
    TranquilityPartyHP = GetToggle(2, "TranquilityPartyHP")
    TranquilityPartyUnits = GetToggle(2, "TranquilityPartyUnits")
    FlourishHP = GetToggle(2, "FlourishHP")
    FlourishUnits = GetToggle(2, "FlourishUnits")
    SwiftmendHP = GetToggle(2, "SwiftmendHP")
    WildGrowthHP = GetToggle(2, "WildGrowthHP")
    WildGrowthUnits = GetToggle(2, "WildGrowthUnits")
    EfflorescenceRefresh = GetToggle(2, "EfflorescenceRefresh")
    SnipeFriendly  = GetToggle(2, "SnipeFriendly")  
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "NATURE") == 0
end 

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    
    
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
end 
A[1] = function(icon)
    
    -- Cyclone AntiFake CC Focus
    local cast = Unit(player):CastTime(A.Cyclone.ID)
    if A.Cyclone:IsReady("focus") and
    A.Cyclone:IsSpellLearned() and
    (
        cast == 0 or
        Unit(player):GetCurrentSpeed() == 0 
    ) and
    A.Cyclone:IsSpellInRange("focus") and
    Unit("focus"):HasBuffs("CCMagicImun") <= cast  
    then
        return A.Cyclone:Show(icon)                  
    end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
    -- AntiFake Bash Cat / Bear form
    if A.MightyBash:IsReady("focus") and
    Player:GetStance()~=2 and
    Player:GetStance()~=1 and
    A.WildCharge:IsSpellLearned() and -- Charge
    A.WildCharge:GetCooldown()==0 and
    A.WildCharge:IsSpellInRange("focus") and
    A.MightyBash:IsSpellLearned() and -- Bash
    A.MightyBash:GetCooldown() == 0 and
    not A.MightyBash:IsSpellInRange("focus") and
    A.MightyBash:AbsentImun("focus", Temp.TotalAndPhys, true)
    then
        return A.MightyBash:Show(icon)                  
    end 
         --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
    -- AntiFake Bash Jump
    if A.WildCharge:IsReady("focus") and
    (
        Player:GetStance()==2 or
        Player:GetStance()==1
    ) and
    A.WildCharge:IsSpellLearned() and -- Charge
    A.WildCharge:GetCooldown()==0 and
    A.WildCharge:IsSpellInRange("focus") and
    A.MightyBash:IsSpellLearned() and -- Bash
    A.MightyBash:GetCooldown() == 0 and
    not A.MightyBash:IsSpellInRange("focus") and
    A.WildCharge:AbsentImun("focus", Temp.TotalAndPhys, true)
    then
        return A.WildCharge:Show(icon)                  
    end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
    -- AntiFake Bash
    if A.MightyBash:IsReady("focus") and 
    A.MightyBash:IsSpellLearned() and
    A.MightyBash:IsSpellInRange("focus") and
    A.MightyBash:AbsentImun("focus", Temp.TotalAndPhys, true)
    then
        return A.MightyBash:Show(icon)                  
    end 
    
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if A.IsUnitEnemy(mouseover) then 
        unit = mouseover
    elseif A.IsUnitEnemy(target) then 
        unit = target
    elseif A.IsUnitEnemy(targettarget) then 
        unit = targettarget
    end 
    
    if unit then         
        local total, sleft, _, _, _, notKickAble = Unit(unit):CastTime()
        if sleft > 0 then                                     
            
            -- Typhun Target
            if not notKickAble and A.Typhoon:IsReady(unit, nil, nil, true) and A.Typhoon:AbsentImun("target", Temp.TotalAndMag, true) and
            A.Typhoon:IsSpellLearned() and
            A.Typhoon:GetCooldown() and
            Unit("target"):CanInterract(15)            
            then
                return A.Typhoon:Show(icon)                                                  
            end 
            
            -- Typhun MouseOver Restor Only
            if not notKickAble and A.Typhoon:IsReady(unit, nil, nil, true) and A.Typhoon:AbsentImun("mouseover", Temp.TotalAndMag, true) and
            A.Typhoon:IsSpellLearned() and
            A.Typhoon:GetCooldown() and
            Unit("mouseover"):CanInterract(15)
            then
                return A.Typhoon:Show(icon)                                                  
            end
            
            -- Typhun TargetTarget Restor Only
            if not notKickAble and A.Typhoon:IsReady(unit, nil, nil, true) and A.Typhoon:AbsentImun("targettarget", Temp.TotalAndMag, true) and
            A.Typhoon:IsSpellLearned() and
            not IsUnitEnemy("target") and
            A.Typhoon:GetCooldown() and
            Unit("targettarget"):CanInterract(15)
            then
                return A.Typhoon:Show(icon)                                                  
            end
            
            -- Racials 
            if A.QuakingPalm:IsRacialReadyP(unit, nil, nil, true) and A.LastPlayerCastID ~= A.Typhoon.ID then 
                return A.QuakingPalm:Show(icon)
            end 
            
            if A.Haymaker:IsRacialReadyP(unit, nil, nil, true) and A.LastPlayerCastID ~= A.Typhoon.ID then 
                return A.Haymaker:Show(icon)
            end 
            
            if A.WarStomp:IsRacialReadyP(unit, nil, nil, true) and A.LastPlayerCastID ~= A.Typhoon.ID then 
                return A.WarStomp:Show(icon)
            end 
            
            if A.BullRush:IsRacialReadyP(unit, nil, nil, true) and A.LastPlayerCastID ~= A.Typhoon.ID then 
                return A.BullRush:Show(icon)
            end                         
        end 
    end                                                                                 
end

-----------------------------------------
--        ROTATION FUNCTIONS           --
-----------------------------------------
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Return number
-- Efflorescence duration left
local function Efflorescence()
    for i = 1, 5 do
        local active, totemName, startTime, duration, textureId  = GetTotemInfo(i)
        if active == true and textureId == 134222 then
            return startTime + duration - GetTime()
        end
    end
    return 0
end

-- Mana Management
local function IsSaveManaPhase()
    if not A.IsInPvP and A.GetToggle(2, "ManaManagement") and Unit(player):HasBuffs(A.Innervate.ID, true) == 0 then 
        for i = 1, MAX_BOSS_FRAMES do 
            if Unit("boss" .. i):IsExists() and not Unit("boss" .. i):IsDead() and Unit(player):PowerPercent() < Unit("boss" .. i):HealthPercent() then 
                return true 
            end 
        end 
    end 
    return Unit(player):PowerPercent() < 20 
end 
IsSaveManaPhase = A.MakeFunctionCachedStatic(IsSaveManaPhase)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    -- Barkskin
    local Barkskin = A.GetToggle(2, "Barkskin")
    if     Barkskin >= 0 and A.Barkskin:IsReady(player, nil, nil, true) and IsSchoolFree() and Unit(player):HealthPercent() <= 60 and
    (
        (     -- Auto 
            Barkskin >= 85 and 
            (
                Unit(player):HealthPercent() <= 50 or
                (                        
                    Unit(player):HealthPercent() < 70 
                )
            )
        ) or 
        (    -- Custom
            Barkskin < 85 and 
            Unit(player):HealthPercent() <= Barkskin
        )
    ) 
    then 
        return A.Barkskin
    end 
    
    -- Stoneform on defensive
    local Stoneform = A.GetToggle(2, "Stoneform")
    if     Stoneform >= 0 and A.Stoneform:IsRacialReadyP(player, nil, nil, true) and 
    (
        (     -- Auto 
            Stoneform >= 100 and 
            (
                (
                    not A.IsInPvP and                         
                    Unit(player):TimeToDieX(65) < 3 
                ) or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) 
        ) or 
        (    -- Custom
            Stoneform < 100 and 
            Unit(target):HealthPercent() <= Stoneform
        )
    ) 
    then 
        return A.Stoneform
    end     
    
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:AutoRacial(player, true, nil, true) and not A.IsInPvP and A.AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
end 
SelfDefensives = Action.MakeFunctionCachedDynamic(SelfDefensives)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.SkullBash:IsReadyByPassCastGCD(unit) or not A.SkullBash:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Interrupts spells
local function Interrupts(unit)
    if A.GetToggle(2, "TasteInterruptList") then
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, "TasteBFAContent", true, countInterruptGCD(unit))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end
    
    if castRemainsTime >= A.GetLatency() then
        -- MightyBash
        if useCC and A.MightyBash:IsReady(unit) and A.MightyBash:IsSpellLearned() and A.MightyBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            -- Notification                    
            Action.SendNotification("Mighty Bash interrupting on " .. unit, A.MightyBash.ID)
            return A.MightyBash
        end  
        
        if useRacial and A.QuakingPalm:AutoRacial(unit) then 
            return A.QuakingPalm
        end 
        
        if useRacial and A.Haymaker:AutoRacial(unit) then 
            return A.Haymaker
        end 
        
        if useRacial and A.WarStomp:AutoRacial(unit) then 
            return A.WarStomp
        end 
        
        if useRacial and A.BullRush:AutoRacial(unit) then 
            return A.BullRush
        end 
    end
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Return average DMG taken from all our current member team
-- DEPRECATED SEE FriendlyTeam:GetLastTimeDMGX(x, range)
local function FriendlyTeamReceivedLast5sec() 
    local total = 0
    local getmembersAll = HealingEngine.GetMembersAll()
    
    if #getmembersAll > 0 then 
        for i = 1, #getmembersAll do
            -- Avoid getting pet damage
            if Unit(getmembersAll[i].Unit):IsPlayer() then
                total = total + Unit(getmembersAll[i].Unit):GetLastTimeDMGX(5)
            end
        end
        
        avg = total / #getmembersAll
    end 
    return total
end
FriendlyTeamReceivedLast5sec = Action.MakeFunctionCachedDynamic(FriendlyTeamReceivedLast5sec)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
function FriendlyTeam:GetLastTimeDMGX(x, range)
    -- @return number, number, number
    -- [1] Average received damage latest 'x' seconds 
    -- [2] Summary received damage latest 'x' seconds 
    -- [3] Count of members valid for conditions
    -- Nill-able: range
    local ROLE                            = self.ROLE
    local lastDMG, members                = 0, 0
    local member
    
    if TeamCacheFriendly.Size <= 1 then 
        if Unit(player):Role(ROLE) then  
            lastDMG = Unit(player):GetLastTimeDMGX(x)
            return lastDMG, 1     
        end 
        
        return lastDMG, members
    end         
    
    if ROLE and TeamCacheFriendly[ROLE] then 
        for member in pairs(TeamCacheFriendly[ROLE]) do
            if Unit(member):InRange() and (not range or Unit(member):GetRange() <= range) then
                lastDMG = lastDMG + Unit(member):GetLastTimeDMGX(x)   
                members = members + 1
            end             
        end             
    else
        for i = 1, TeamCacheFriendly.MaxSize do
            member = TeamCacheFriendlyIndexToPLAYERs[i]                
            if member and Unit(member):InRange() and (not range or Unit(member):GetRange() <= range) then
                lastDMG = lastDMG + Unit(member):GetLastTimeDMGX(x)   
                members = members + 1
            end 
        end  
        
        if TeamCacheFriendly.Type ~= "raid" then
            lastDMG = lastDMG + Unit(player):GetLastTimeDMGX(x)  
            members = members + 1
        end 
    end      
    
    if lastDMG == 0 and members == 0 then 
        return 0, lastDMG, members
    else 
        return lastDMG / members, lastDMG, members
    end 
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function BurstBuffs()
    return 
    Unit("player"):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true)>0 or
    Unit("player"):HasBuffs("BurstHaste")>0 
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function noDamageCheck(unit)
    if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
        return true
    end
    if isCC(unit) then
        return true
    end
    if isCasting(302415, unit) then
        -- emmisary teleporting home
        return true
    end
    
    if hasBuff(263246, unit) then
        -- shields on first boss in temple
        return true
    end
    if hasBuff(260189, unit) then
        -- shields on last boss in MOTHERLODE
        return true
    end
    if hasBuff(261264, unit) or hasBuff(261265, unit) or hasBuff(261266, unit) then
        -- shields on witches in wm
        return true
    end
    
    if GetObjectID(thisUnit) == 155432 then
        --emmisaries to punt, dealt with seperately
        return true
    end
    return false --catchall
end
noDamageCheck = Action.MakeFunctionCachedDynamic(noDamageCheck)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Restor Druid 
local function CanAoEFlourish(pHP)   
    local total = 0
    local getmembersAll = HealingEngine.GetMembersAll()
    
    for i = 1, #getmembersAll do
        if getmembersAll[i].HP <= pHP and
        -- Rejuvenation
        Unit(getmembersAll[i].Unit):HasBuffs(774) > 0 and 
        (
            -- Wild Growth
            Unit(getmembersAll[i].Unit):HasBuffs(48438, true) > 0 or 
            -- Lifebloom or Regrowth or Germination
            Unit(getmembersAll[i].Unit):HasBuffs({33763, 8936, 155777}, true) > 0 
        )
        then
            total = total + 1
        end
    end
    return total >= #getmembersAll * 0.3
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- PvE
local function SootheAble(unit)
    -- https://questionablyepic.com/bfa-dungeon-debuffs/
    return Unit(unit):HasBuffs({
            228318, -- Raging (Raging Affix)
            255824, -- Fanatic's Rage (Dazar'ai Juggernaut)
            257476, -- Bestial Wrath (Irontide Mastiff)
            269976, -- Ancestral Fury (Shadow-Borne Champion)
            262092, -- Inhale Vapors (Addled Thug)
            272888, -- Ferocity (Ashvane Destroyer)
            259975, -- Enrage (The Sand Queen)
            265081, -- Warcry (Chosen Blood Matron)
            266209, -- Wicked Frenzy (Fallen Deathspeaker)
    }, true)>2
end

local fishfeast = 0
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local StunsBlackList = {
    -- Atal'Dazar
    [87318] = "Dazar'ai Colossus",
    [122984] = "Dazar'ai Colossus",
    [128455] = "T'lonja",
    [129553] = "Dinomancer Kish'o",
    [129552] = "Monzumi",
    -- Freehold
    [129602] = "Irontide Enforcer",
    [130400] = "Irontide Crusher",
    -- King's Rest
    [133935] = "Animated Guardian",
    [134174] = "Shadow-Borne Witch Doctor",
    [134158] = "Shadow-Borne Champion",
    [137474] = "King Timalji",
    [137478] = "Queen Wasi",
    [137486] = "Queen Patlaa",
    [137487] = "Skeletal Hunting Raptor",
    [134251] = "Seneschal M'bara",
    [134331] = "King Rahu'ai",
    [137484] = "King A'akul",
    [134739] = "Purification Construct",
    [137969] = "Interment Construct",
    [135231] = "Spectral Brute",
    [138489] = "Shadow of Zul",
    -- Shrine of the Storm
    [134144] = "Living Current",
    [136214] = "Windspeaker Heldis",
    [134150] = "Runecarver Sorn",
    [136249] = "Guardian Elemental",
    [134417] = "Deepsea Ritualist",
    [136353] = "Colossal Tentacle",
    [136295] = "Sunken Denizen",
    [136297] = "Forgotten Denizen",
    -- Siege of Boralus
    [129369] = "Irontide Raider",
    [129373] = "Dockhound Packmaster",
    [128969] = "Ashvane Commander",
    [138255] = "Ashvane Spotter",
    [138465] = "Ashvane Cannoneer",
    [135245] = "Bilge Rat Demolisher",
    -- Temple of Sethraliss
    [134991] = "Sandfury Stonefist",
    [139422] = "Scaled Krolusk Tamer",
    [136076] = "Agitated Nimbus",
    [134691] = "Static-charged Dervish",
    [139110] = "Spark Channeler",
    [136250] = "Hoodoo Hexer",
    [139946] = "Heart Guardian",
    -- MOTHERLODE!!
    [130485] = "Mechanized Peacekeeper",
    [136139] = "Mechanized Peacekeeper",
    [136643] = "Azerite Extractor",
    [134012] = "Taskmaster Askari",
    [133430] = "Venture Co. Mastermind",
    [133463] = "Venture Co. War Machine",
    [133436] = "Venture Co. Skyscorcher",
    [133482] = "Crawler Mine",
    -- Underrot
    [131436] = "Chosen Blood Matron",
    [133912] = "Bloodsworn Defiler",
    [138281] = "Faceless Corruptor",
    -- Tol Dagor
    [130025] = "Irontide Thug",
    -- Waycrest Manor
    [131677] = "Heartsbane Runeweaver",
    [135329] = "Matron Bryndle",
    [131812] = "Heartsbane Soulcharmer",
    [131670] = "Heartsbane Vinetwister",
    [135365] = "Matron Alma",
}
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local precast_spell_list = {
    --spell_id    , precast_time    ,    spell_name
    { 214652, 5, 'Acidic Fragments' },
    { 205862, 5, 'Slam' },
    { 259832, 1.5, 'Massive Glaive - Stormbound Conqueror (Warport Wastari, Zuldazar, for testing purpose only)' },
    { 218774, 5, 'Summon Plasma Spheres' },
    { 206949, 5, 'Frigid Nova' },
    { 206517, 5, 'Fel Nova' },
    { 207720, 5, 'Witness the Void' },
    { 206219, 5, 'Liquid Hellfire' },
    { 211439, 5, 'Will of the Demon Within' },
    { 209270, 5, 'Eye of Guldan' },
    { 227071, 5, 'Flame Crash' },
    { 233279, 5, 'Shattering Star' },
    { 233441, 5, 'Bone Saw' },
    { 235230, 5, 'Fel Squall' },
    { 231854, 5, 'Unchecked Rage' },
    { 232174, 5, 'Frosty Discharge' },
    { 230139, 5, 'Hydra Shot' },
    { 233264, 5, 'Embrace of the Eclipse' },
    { 236542, 5, 'Sundering Doom' },
    { 236544, 5, 'Doomed Sundering' },
    { 235059, 5, 'Rupturing Singularity' },
    { 288693, 3, 'Tormented Soul - Grave Bolt (Reaping affix)' },
    { 262347, 5, 'Static Pulse' },
    { 302420, 5, 'Queen\'s Decree: Hide' },
    { 260333, 7, 'Tantrum - Underrot 2nd boss' },
    { 255577, 5, 'Transfusion' }, -- https://www.wowhead.com/spell=255577/transfusion
    { 259732, 5, 'Festering Harvest' }, --https://www.wowhead.com/spell=259732/festering-harvest
    { 285388, 5, 'Vent Jets' }, --https://www.wowhead.com/spell=285388/vent-jets
    { 291626, 3, 'Cutting Beam' }, --https://www.wowhead.com/spell=291626/cutting-beam
    { 300207, 3, 'shock-coil' }, -- https://www.wowhead.com/spell=300207/shock-coil
    { 297261, 5, 'rumble' }, -- https://www.wowhead.com/spell=297261/rumble
    { 262347, 5, 'pulse' }, --https://www.wowhead.com/spell=262347/static-pulse
}
--end of dbm list
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local DebuffSniperList = {
    --junkyard
    { spellID = 298669, stacks = 0, secs = 1 }, -- Taze
    -- Uldir
    { spellID = 262313, stacks = 0, secs = 5 }, -- Malodorous Miasma
    { spellID = 262314, stacks = 0, secs = 3 }, -- Putrid Paroxysm
    { spellID = 264382, stacks = 0, secs = 1 }, -- Eye Beam
    { spellID = 264210, stacks = 0, secs = 5 }, -- Jagged Mandible
    { spellID = 265360, stacks = 0, secs = 5 }, -- Roiling Deceit
    { spellID = 265129, stacks = 0, secs = 5 }, -- Omega Vector
    { spellID = 266948, stacks = 0, secs = 5 }, -- Plague Bomb
    { spellID = 274358, stacks = 0, secs = 5 }, -- Rupturing Blood
    { spellID = 274019, stacks = 0, secs = 1 }, -- Mind Flay
    { spellID = 272018, stacks = 0, secs = 1 }, -- Absorbed in Darkness
    { spellID = 273359, stacks = 0, secs = 5 }, -- Shadow Barrage
    -- Freehold
    { spellID = 257437, stacks = 0, secs = 5 }, -- Poisoning Strike
    { spellID = 267523, stacks = 0, secs = 5 }, -- Cutting Surge
    { spellID = 256363, stacks = 0, secs = 5 }, -- Ripper Punch
    -- Shrine of the Storm
    { spellID = 264526, stacks = 0, secs = 5 }, -- Grasp from the Depths
    { spellID = 264166, stacks = 0, secs = 1 }, -- Undertow
    { spellID = 268214, stacks = 0, secs = 1 }, -- Carve Flesh
    { spellID = 276297, stacks = 0, secs = 5 }, -- Void Seed
    { spellID = 268322, stacks = 0, secs = 5 }, -- Touch of the Drowned
    -- Siege of Boralus
    { spellID = 256897, stacks = 0, secs = 5 }, -- Clamping Jaws
    { spellID = 273470, stacks = 0, secs = 3 }, -- Gut Shot
    { spellID = 275014, stacks = 0, secs = 5 }, -- Putrid Waters
    -- Tol Dagor
    { spellID = 258058, stacks = 0, secs = 1 }, -- Squeeze
    { spellID = 260016, stacks = 0, secs = 3 }, -- Itchy Bite
    { spellID = 260067, stacks = 0, secs = 5 }, -- Vicious Mauling
    { spellID = 258864, stacks = 0, secs = 5 }, -- Suppression Fire
    { spellID = 258917, stacks = 0, secs = 3 }, -- Righteous Flames
    { spellID = 256198, stacks = 0, secs = 5 }, -- Azerite Rounds: Incendiary
    { spellID = 256105, stacks = 0, secs = 1 }, -- Explosive Burst
    -- Waycrest Manor
    { spellID = 266035, stacks = 0, secs = 1 }, -- Bone Splinter
    { spellID = 260703, stacks = 0, secs = 1 }, -- Unstable Runic Mark
    { spellID = 260741, stacks = 0, secs = 1 }, -- Jagged Nettles
    { spellID = 264050, stacks = 0, secs = 3 }, -- Infected Thorn
    { spellID = 264556, stacks = 0, secs = 2 }, -- Tearing Strike
    { spellID = 264150, stacks = 0, secs = 1 }, -- Shatter
    { spellID = 265761, stacks = 0, secs = 1 }, -- Thorned Barrage
    { spellID = 263905, stacks = 0, secs = 1 }, -- Marking Cleave
    { spellID = 264153, stacks = 0, secs = 3 }, -- Spit
    { spellID = 278456, stacks = 0, secs = 3 }, -- Infest
    { spellID = 271178, stacks = 0, secs = 3 }, -- Ravaging Leap
    { spellID = 265880, stacks = 0, secs = 1 }, -- Dread Mark
    { spellID = 265882, stacks = 0, secs = 1 }, -- Lingering Dread
    { spellID = 264378, stacks = 0, secs = 5 }, -- Fragment Soul
    { spellID = 261438, stacks = 0, secs = 1 }, -- Wasting Strike
    { spellID = 261440, stacks = 0, secs = 1 }, -- Virulent Pathogen
    { spellID = 268202, stacks = 0, secs = 1 }, -- Death Lens
    -- Atal'Dazar
    { spellID = 253562, stacks = 0, secs = 3 }, -- Wildfire
    { spellID = 254959, stacks = 0, secs = 2 }, -- Soulburn
    { spellID = 255558, stacks = 0, secs = 5 }, -- Tainted Blood
    { spellID = 255814, stacks = 0, secs = 5 }, -- Rending Maul
    { spellID = 250372, stacks = 0, secs = 5 }, -- Lingering Nausea
    { spellID = 250096, stacks = 0, secs = 1 }, -- Wracking Pain
    { spellID = 256577, stacks = 0, secs = 5 }, -- Soulfeast
    -- King's Rest
    { spellID = 269932, stacks = 0, secs = 3 }, -- Gust Slash
    { spellID = 265773, stacks = 0, secs = 4 }, -- Spit Gold
    { spellID = 270084, stacks = 0, secs = 3 }, -- Axe Barrage
    { spellID = 270865, stacks = 0, secs = 3 }, -- Hidden Blade
    { spellID = 270289, stacks = 0, secs = 3 }, -- Purification Beam
    { spellID = 271564, stacks = 0, secs = 3 }, -- Embalming
    { spellID = 267618, stacks = 0, secs = 3 }, -- Drain Fluids
    { spellID = 270487, stacks = 0, secs = 3 }, -- Severing Blade
    { spellID = 270507, stacks = 0, secs = 5 }, -- Poison Barrage
    { spellID = 266231, stacks = 0, secs = 3 }, -- Severing Axe
    { spellID = 267273, stacks = 0, secs = 3 }, -- Poison Nova
    { spellID = 268419, stacks = 0, secs = 3 }, -- Gale Slash
    -- MOTHERLODE!!
    { spellID = 269298, stacks = 0, secs = 1 }, -- Widowmaker
    { spellID = 262347, stacks = 0, secs = 1 }, -- Static Pulse
    { spellID = 263074, stacks = 0, secs = 3 }, -- Festering Bite
    { spellID = 262270, stacks = 0, secs = 1 }, -- Caustic Compound
    { spellID = 262794, stacks = 0, secs = 1 }, -- Energy Lash
    { spellID = 259853, stacks = 0, secs = 3 }, -- Chemical Burn
    { spellID = 269092, stacks = 0, secs = 1 }, -- Artillery Barrage
    { spellID = 262348, stacks = 0, secs = 1 }, -- Mine Blast
    { spellID = 260838, stacks = 0, secs = 1 }, -- Homing Missile
    -- Temple of Sethraliss
    { spellID = 263371, stacks = 0, secs = 1 }, -- Conduction
    { spellID = 272657, stacks = 0, secs = 3 }, -- Noxious Breath
    { spellID = 267027, stacks = 0, secs = 1 }, -- Cytotoxin
    { spellID = 272699, stacks = 0, secs = 3 }, -- Venomous Spit
    { spellID = 268013, stacks = 0, secs = 5 }, -- Flame Shock
    -- Underrot
    { spellID = 265019, stacks = 0, secs = 1 }, -- Savage Cleave
    { spellID = 265568, stacks = 0, secs = 1 }, -- Dark Omen
    { spellID = 260685, stacks = 0, secs = 5 }, -- Taint of G'huun
    { spellID = 278961, stacks = 0, secs = 5 }, -- Decaying Mind
    { spellID = 260455, stacks = 0, secs = 1 }, -- Serrated Fangs
    { spellID = 273226, stacks = 0, secs = 1 }, -- Decaying Spores
    { spellID = 269301, stacks = 0, secs = 5 }, -- Putrid Blood
    -- all
    { spellID = 302421, stacks = 0, secs = 5 }, -- Queen's Decree
}
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local NeedSnipe = false
local function SetFriendlyToSnipe()
    local getmembersAll = A.HealingEngine.GetMembersAll()
    for i = 1, #getmembersAll do
        if Unit(getmembersAll[i].Unit):GetRange() <= 40 then
            for k, v in pairs(DebuffSniperList) do
                if Unit(getmembersAll[i].Unit):HasDeBuffs(v.spellID, true) > v.secs and 
                --Unit(getmembersAll[i].Unit):HasDeBuffsStacks(v.spellID, true) >= v.stacks and 
                Unit(getmembersAll[i].Unit):HasBuffs(A.Rejuvenation.ID, player, true) > 0 and
                -- Germination
                (
                    A.Germination:IsSpellLearned() and 
                    Unit(getmembersAll[i].Unit):HasBuffs(A.RejuvenationGermimation.ID, player, true) > 0 
                    or 
                    not A.Germination:IsSpellLearned()
                )                    
                then
                    -- Notification                    
                    Action.SendNotification("Healing snipe on " .. UnitName(getmembersAll[i].Unit), A.Regrowth.ID)
                    -- Global var
                    NeedSnipe = true
                    -- Force target
                    A.HealingEngine.SetTarget(getmembersAll[i].Unit, 3)
                end
            end
        end
    end
end
SetFriendlyToSnipe = Action.MakeFunctionCachedDynamic(SetFriendlyToSnipe)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local PredictHoTsList = {   --snipe list
    --Battle of Dazar'alor
    { spellID = 283572, targeted = true }, --"Sacred Blade"
    { spellID = 284578, targeted = true }, --"Penance"
    { spellID = 286988, targeted = true }, --Divine Burst"
    { spellID = 282036, targeted = true }, --"Fireball"
    { spellID = 282182, targeted = false }, --"Buster Cannon"
    --Uldir
    { spellID = 279669, targeted = false }, --"Bacterial Outbreak"
    { spellID = 279660, targeted = false }, --"Endemic Virus"
    { spellID = 274262, targeted = false }, --"Explosive Corruption"
    --Reaping
    { spellID = 288693, targeted = true }, --"Grave Bolt",
    --Atal'Dazar
    { spellID = 250096, targeted = true }, --"Wracking Pain"
    { spellID = 253562, targeted = true }, --"Wildfire"
    { spellID = 252781, targeted = true }, --"Unstable Hex"
    { spellID = 252923, targeted = true }, --"Venom Blast"
    { spellID = 253239, targeted = true }, -- Dazarai Juggernaut - Merciless Assault },
    { spellID = 256846, targeted = true }, --'Dinomancer Kisho - Deadeye Aim'},
    { spellID = 257407, targeted = true }, -- Rezan - Pursuit},
    --Kings Rest
    { spellID = 267618, targeted = true }, --"Drain Fluids"
    { spellID = 267308, targeted = true }, --"Lighting Bolt"
    { spellID = 270493, targeted = true }, --"Spectral Bolt"
    { spellID = 269973, targeted = true }, --"Deathly Chill"
    { spellID = 270923, targeted = true }, --"Shadow Bolt"
    { spellID = 272388, targeted = true }, --"Shadow Barrage"
    { spellID = 266231, targeted = true }, -- Kula the Butcher - Severing Axe},
    { spellID = 270507, targeted = true }, --  Spectral Beastmaster - Poison Barrage},
    { spellID = 265773, targeted = true }, -- The Golden Serpent - Spit Gold},
    { spellID = 270506, targeted = true }, -- Spectral Beastmaster - Deadeye Shot},
    { spellID = 265773, targeted = true }, -- https://www.wowhead.com/spell=270487/severing-blade
    { spellID = 268586, targeted = true }, -- https://www.wowhead.com/spell=268586/blade-combo
    --Free Hold
    { spellID = 259092, targeted = true }, --"Lightning Bolt"
    { spellID = 281420, targeted = true }, --"Water Bolt"
    { spellID = 257267, targeted = false }, --"Swiftwind Saber"
    { spellID = 257739, targeted = true }, -- Blacktooth Scrapper - Blind Rage},
    { spellID = 258338, targeted = true }, -- Captain Raoul - Blackout Barrel},
    { spellID = 256979, targeted = true }, -- Captain Eudora - Powder Shot},
    --Siege of Boralus
    { spellID = 272588, targeted = true }, --"Rotting Wounds"
    { spellID = 272827, targeted = false }, --"Viscous Slobber"
    { spellID = 272581, targeted = true }, -- "Water Spray"
    { spellID = 257883, targeted = false }, -- "Break Water"
    { spellID = 257063, targeted = true }, --"Brackish Bolt"
    { spellID = 272571, targeted = true }, --"Choking Waters"
    { spellID = 257641, targeted = true }, -- Kul Tiran Marksman - Molten Slug},
    { spellID = 272874, targeted = true }, -- Ashvane Commander - Trample},
    { spellID = 272581, targeted = true }, -- Bilge Rat Tempest - Water Spray},
    { spellID = 272528, targeted = true }, -- Ashvane Sniper - Shoot},
    { spellID = 272542, targeted = true }, -- Ashvane Sniper - Ricochet},
    -- Temple of Sethraliss
    { spellID = 263775, targeted = true }, --"Gust"
    { spellID = 268061, targeted = true }, --"Chain Lightning"
    { spellID = 272820, targeted = true }, --"Shock"
    { spellID = 263365, targeted = true }, --"https://www.wowhead.com/spell=263365/a-peal-of-thunder"
    { spellID = 268013, targeted = true }, --"Flame Shock"
    { spellID = 274642, targeted = true }, --"Lava Burst"
    { spellID = 268703, targeted = true }, --"Lightning Bolt"
    { spellID = 272699, targeted = true }, --"Venomous Spit"
    { spellID = 268703, targeted = true }, -- Charged Dust Devil - Lightning Bolt},
    { spellID = 272670, targeted = true }, -- Sandswept Marksman - Shoot},
    { spellID = 267278, targeted = true }, -- Static-charged Dervish - Electrocute},
    { spellID = 272820, targeted = true }, -- Spark Channeler - Shock},
    { spellID = 274642, targeted = true }, -- Hoodoo Hexer - Lava Burst},
    { spellID = 268061, targeted = true }, -- Plague Doctor - Chain Lightning},
    --Shrine of the Storm
    { spellID = 265001, targeted = true }, --"Sea Blast"
    { spellID = 268347, targeted = true }, --"Void Bolt"
    { spellID = 267969, targeted = true }, --"Water Blast"
    { spellID = 268233, targeted = true }, --"Electrifying Shock"
    { spellID = 268315, targeted = true }, --"Lash"
    { spellID = 268177, targeted = true }, --"Windblast"
    { spellID = 268273, targeted = true }, --"Deep Smash"
    { spellID = 268317, targeted = true }, --"Rip Mind"
    { spellID = 265001, targeted = true }, --"Sea Blast"
    { spellID = 274703, targeted = true }, --"Void Bolt"
    { spellID = 268214, targeted = true }, --"Carve Flesh"
    { spellID = 264166, targeted = true }, -- Aqusirr - Undertow},
    { spellID = 268214, targeted = true }, -- Runecarver Sorn - Carve Flesh},
    --Motherlode
    { spellID = 259856, targeted = true }, --"Chemical Burn"
    { spellID = 260318, targeted = true }, --"Alpha Cannon"
    { spellID = 262794, targeted = true }, --"Energy Lash"
    { spellID = 263202, targeted = true }, --"Rock Lance"
    { spellID = 262268, targeted = true }, --"Caustic Compound"
    { spellID = 263262, targeted = true }, --"Shale Spit"
    { spellID = 263628, targeted = true }, --"Charged Claw"
    { spellID = 268185, targeted = true }, -- Refreshment Vendor, Iced Spritzer},
    { spellID = 258674, targeted = true }, -- Off-Duty Laborer - Throw Wrench},
    { spellID = 276304, targeted = true }, -- Rowdy Reveler - Penny For Your Thoughts},
    { spellID = 263209, targeted = true }, -- Mine Rat - Throw Rock},
    { spellID = 263202, targeted = true }, -- Venture Co. Earthshaper - Rock Lance},
    { spellID = 262794, targeted = true }, -- Venture Co. Mastermind - Energy Lash},
    { spellID = 260669, targeted = true }, -- Rixxa Fluxflame - Propellant Blast},
    { spellID = 271456, targeted = true }, -- https://www.wowhead.com/spell=271456/drill-smash},
    --Underrot
    { spellID = 260879, targeted = true }, --"Blood Bolt"
    { spellID = 265084, targeted = true }, --"Blood Bolt"
    { spellID = 259732, targeted = false }, --"Festering Harvest"
    { spellID = 266209, targeted = false }, --"Wicked Frenzy"
    { spellID = 265376, targeted = true }, -- Fanatical Headhunter - Barbed Spear},
    { spellID = 265625, targeted = true }, -- Befouled Spirit - Dark Omen},
    --Tol Dagor
    { spellID = 257777, targeted = true }, --"Crippling Shiv"
    { spellID = 258150, targeted = true }, --"Salt Blast"
    { spellID = 258869, targeted = true }, --"Blaze"
    { spellID = 256039, targeted = true }, -- Overseer Korgus - Deadeye},
    { spellID = 185857, targeted = true }, -- Ashvane Spotter - Shoot},
    
    --work shop_
    { spellID = 294195, targeted = true }, --https://www.wowhead.com/spell=294195/arcing-zap
    { spellID = 293827, targeted = true }, --https://www.wowhead.com/spell=293827/giga-wallop
    { spellID = 292264, targeted = true }, -- https://www.wowhead.com/spell=292264/giga-zap
    --junk yard
    { spellID = 300650, targeted = true }, --https://www.wowhead.com/spell=300650/suffocating-smog
    { spellID = 299438, targeted = true }, --https://www.wowhead.com/spell=299438/sledgehammer
    { spellID = 300188, targeted = true }, -- https://www.wowhead.com/spell=300188/scrap-cannon#used-by-npc
    { spellID = 302682, targeted = true }, --https://www.wowhead.com/spell=302682/mega-taze
    
    --Waycrest Manor
    { spellID = 260701, targeted = true }, --"Bramble Bolt"
    { spellID = 260700, targeted = true }, --"Ruinous Bolt"
    { spellID = 260699, targeted = true }, --"Soul Bolt"
    { spellID = 261438, targeted = true }, --"Wasting Strike"
    { spellID = 266225, targeted = true }, --Darkened Lightning"
    { spellID = 273653, targeted = true }, --"Shadow Claw"
    { spellID = 265881, targeted = true }, --"Decaying Touch"
    { spellID = 264153, targeted = true }, --"Spit"
    { spellID = 278444, targeted = true }, --"Infest"
    { spellID = 167385, targeted = true }, --"Infest"
    { spellID = 263891, targeted = true }, -- Heartsbane Vinetwister - Grasping Thorns},
    { spellID = 264510, targeted = true }, -- Crazed Marksman - Shoot},
    { spellID = 260699, targeted = true }, -- Coven Diviner - Soul Bolt},
    { spellID = 260551, targeted = true }, -- Soulbound Goliath - Soul Thorns},
    { spellID = 260741, targeted = true }, -- Heartsbane Triad - Jagged Nettles},
    { spellID = 268202, targeted = true } -- Gorak Tul - Death Lens},
}
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local NeedPreHot = false
local function SetFriendlyToPreHot()
    local getmembersAll = A.HealingEngine.GetMembersAll()
    local _, EVENT, _, SourceGUID, _,_,_, DestGUID, _, _, _, SPELLID  = CombatLogGetCurrentEventInfo()
    
    for i = 1, #getmembersAll do
        if Unit(getmembersAll[i].Unit):GetRange() <= 40 then
            for k, v in pairs(PredictHoTsList) do
                -- Detected inc damage to pre hot
                if EVENT == "SPELL_CAST_START" and DestGUID == getmembersAll[i].GUID and SPELLID == v.spellID and
                Unit(getmembersAll[i].Unit):HasBuffs(A.Rejuvenation.ID, player, true) == 0 and
                -- Germination
                (
                    (
                        A.Germination:IsSpellLearned() and 
                        Unit(getmembersAll[i].Unit):HasBuffs(A.RejuvenationGermimation.ID, player, true) == 0 
                    )
                    or 
                    not A.Germination:IsSpellLearned()
                )                    
                then
                    -- Notification                    
                    Action.SendNotification("Big damage incoming : Prehot on " .. UnitName(getmembersAll[i].Unit), A.Rejuvenation.ID)
                    -- Global var
                    NeedPreHot = true
                    -- Force target
                    A.HealingEngine.SetTarget(getmembersAll[i].Unit, 3)
                end
            end
        end
    end
end
SetFriendlyToPreHot = Action.MakeFunctionCachedDynamic(SetFriendlyToPreHot)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local CC_CreatureTypeList = { "Beast", "Dragonkin" }
local StunsBlackList = {
    -- Atal'Dazar
    [87318] = "Dazar'ai Colossus",
    [122984] = "Dazar'ai Colossus",
    [128455] = "T'lonja",
    [129553] = "Dinomancer Kish'o",
    [129552] = "Monzumi",
    -- Freehold
    [129602] = "Irontide Enforcer",
    [130400] = "Irontide Crusher",
    -- King's Rest
    [133935] = "Animated Guardian",
    [134174] = "Shadow-Borne Witch Doctor",
    [134158] = "Shadow-Borne Champion",
    [137474] = "King Timalji",
    [137478] = "Queen Wasi",
    [137486] = "Queen Patlaa",
    [137487] = "Skeletal Hunting Raptor",
    [134251] = "Seneschal M'bara",
    [134331] = "King Rahu'ai",
    [137484] = "King A'akul",
    [134739] = "Purification Construct",
    [137969] = "Interment Construct",
    [135231] = "Spectral Brute",
    [138489] = "Shadow of Zul",
    -- Shrine of the Storm
    [134144] = "Living Current",
    [136214] = "Windspeaker Heldis",
    [134150] = "Runecarver Sorn",
    [136249] = "Guardian Elemental",
    [134417] = "Deepsea Ritualist",
    [136353] = "Colossal Tentacle",
    [136295] = "Sunken Denizen",
    [136297] = "Forgotten Denizen",
    -- Siege of Boralus
    [129369] = "Irontide Raider",
    [129373] = "Dockhound Packmaster",
    [128969] = "Ashvane Commander",
    [138255] = "Ashvane Spotter",
    [138465] = "Ashvane Cannoneer",
    [135245] = "Bilge Rat Demolisher",
    -- Temple of Sethraliss
    [134991] = "Sandfury Stonefist",
    [139422] = "Scaled Krolusk Tamer",
    [136076] = "Agitated Nimbus",
    [134691] = "Static-charged Dervish",
    [139110] = "Spark Channeler",
    [136250] = "Hoodoo Hexer",
    [139946] = "Heart Guardian",
    -- MOTHERLODE!!
    [130485] = "Mechanized Peacekeeper",
    [136139] = "Mechanized Peacekeeper",
    [136643] = "Azerite Extractor",
    [134012] = "Taskmaster Askari",
    [133430] = "Venture Co. Mastermind",
    [133463] = "Venture Co. War Machine",
    [133436] = "Venture Co. Skyscorcher",
    [133482] = "Crawler Mine",
    -- Underrot
    [131436] = "Chosen Blood Matron",
    [133912] = "Bloodsworn Defiler",
    [138281] = "Faceless Corruptor",
    -- Tol Dagor
    [130025] = "Irontide Thug",
    -- Waycrest Manor
    [131677] = "Heartsbane Runeweaver",
    [135329] = "Matron Bryndle",
    [131812] = "Heartsbane Soulcharmer",
    [131670] = "Heartsbane Vinetwister",
    [135365] = "Matron Alma",
    --mini bosses
    [161241] = "Voidweaver Mal'thir",
}
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function GetMobsBySpell(count, spellId, reaction)
    if reaction == "friendly" then 
        return 0
    end 
    return MultiUnits:GetBySpell(spellId, count)
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function GetMobsByRange(count, range, reaction)
    if reaction == "friendly" then 
        return 0
    end 
    return MultiUnits:GetByRange(range)
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function AoE(count, num, reaction) 
    if not reaction  then reaction = "enemy" end  
    if not num      then num = 40 end 
    
    local units 
    if num <= ACTION_CONST_CACHE_DEFAULT_NAMEPLATE_MAX_DISTANCE then
        units = GetMobsByRange(count, num, reaction)
    else 
        units = GetMobsBySpell(count, num, reaction)
    end                         
    
    if not count then
        return units or 0
    else
        return units and units >= count
    end    
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function PvPEntanglingRoots(unit)
    return
    Unit(unit):IsMelee() and
    not UnitIsUnit(unit, "target") and
    Unit(unit):HasBuffs("DamageBuffs") > 0 and
    A.EntanglingRoots:IsSpellInRange(unit) and
    (
        (
            Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) > 0
        ) or
        Unit(player):GetCurrentSpeed()==0
    ) 
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function HasEnoughRejuvenationApplied()    
    local currentRejuvenation = HealingEngine.GetBuffsCount(A.Rejuvenation.ID, 0, player, true)    
    return TeamCache.Friendly.Size and
    -- Arena
    (
        TeamCache.Friendly.Size <= 2 and
        currentRejuvenation >= 2
    ) or
    -- Dungeon
    (
        TeamCache.Friendly.Size <= 5 and
        currentRejuvenation >= 5
    ) or
    -- Raid or Battlegrounds
    (
        TeamCache.Friendly.Size > 5 and      
        currentRejuvenation >= TeamCache.Friendly.Size * 0.47
    )
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local function MaintainRejuvenation()
    if A.Rejuvenation:IsReady() then 
        local totalMembers = HealingEngine.GetMembersAll()         
        local MinRaidRejuvUnits = HealingEngine.GetMinimumUnits(6, 20)
        local MinPartyRejuvenationUnits = HealingEngine.GetMinimumUnits(3, 5)
        local currentMembers = TeamCache.Friendly.Size        
        local RejuvenationCount = HealingEngine.GetBuffsCount(A.Rejuvenation.ID, 0, player, true)
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------         
        -- Arena
        if (currentMembers <= 3) then    
            -- Get members without Rejuvenation active
            for i = 1, #totalMembers do 
                if Unit(totalMembers[i].Unit):GetRange() <= 40 and currentMembers > 5 and RejuvenationCount <= currentMembers then  
                    -- SetTarget on member missing buff
                    if Unit(totalMembers[i].Unit):HasBuffs(A.Rejuvenation.ID, player, true) == 0 then
                        HealingEngine.SetTarget(totalMembers[i].Unit)                                      
                    end
                    -- Notification                    
                    Action.SendNotification("Maintaining minimum rejuvenations : " .. RejuvenationCount .. "/" .. currentMembers, A.Rejuvenation.ID)                     
                end                
            end
            -- Party
        elseif currentMembers <= 5 then            
            -- Get members without Rejuvenation active
            for i = 1, #totalMembers do 
                if Unit(totalMembers[i].Unit):GetRange() <= 40 then 
                    if RejuvenationCount < 3 then
                        -- SetTarget on member missing buff
                        if Unit(totalMembers[i].Unit):HasBuffs(A.Rejuvenation.ID, player, true) == 0 then
                            HealingEngine.SetTarget(totalMembers[i].Unit)                                      
                        end
                        -- Notification                    
                        Action.SendNotification("Maintaining minimum rejuvenations : " .. RejuvenationCount .. "/3.", A.Rejuvenation.ID)
                    end                    
                end                
            end
            -- In Raid / Battlegrounds    
        else
            -- Get members without Rejuvenation active
            for i = 1, #totalMembers do 
                if Unit(totalMembers[i].Unit):GetRange() <= 40 and currentMembers > 5 and RejuvenationCount <= (currentMembers * 0.3) then  
                    -- SetTarget on member missing buff
                    if Unit(totalMembers[i].Unit):HasBuffs(A.Rejuvenation.ID, player, true) < 2 then
                        HealingEngine.SetTarget(totalMembers[i].Unit)                                      
                    end
                    -- Notification                    
                    Action.SendNotification("Maintaining minimum " .. A.GetSpellInfo(22812) .. " : " .. RejuvenationCount .. "/" .. round((currentMembers * 0.3), 0), A.Rejuvenation.ID)                     
                end                
            end
        end            
    end 
end
MaintainRejuvenation = Action.MakeFunctionCachedDynamic(MaintainRejuvenation)
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- Return valid members that can be healed
--@parameter IsPlayer : return only members that are real players
local function GetValidMembers(IsPlayer)
    local HealingEngineMembersALL = A.HealingEngine.GetMembersAll()
    if not IsPlayer then 
        return #HealingEngineMembersALL
    else 
        local total = 0 
        if #HealingEngineMembersALL > 0 then 
            for i = 1, #HealingEngineMembersALL do
                if Unit(HealingEngineMembersALL[i].Unit):IsPlayer() then
                    total = total + 1
                end
            end 
        end 
        return total 
    end 
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
local isForcedRejuvenation = false
local toStr = Action.toStr
function TR.ToggleForceRejuvenation(state)
    -- Note: For button use in UI 
    if state ~= nil then 
        isForcedRejuvenation = state
        Action.SendNotification("Enabled Force spread: " .. A.GetSpellInfo(A.Rejuvenation.ID), A.Rejuvenation.ID)
    else
        isForcedRejuvenation = not isForcedRejuvenation
        Action.SendNotification("Disabled Force spread: " .. A.GetSpellInfo(A.Rejuvenation.ID), A.Rejuvenation.ID)
    end  
    Action.Print("Force Rejuvenation: " .. toStr(isForcedRejuvenation))
end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    RotationsVariables()
    local isMoving = A.Player:IsMoving()
    local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
    local ReceivedLast5sec = FriendlyTeam("ALL"):GetLastTimeDMGX(5)
    local AVG_DMG = HealingEngine.GetIncomingDMGAVG()
    local AVG_HPS = HealingEngine.GetIncomingHPSAVG()
    local getmembersAll = HealingEngine.GetMembersAll()
    -- Smart Targeting functions
    SetFriendlyToSnipe()
    SetFriendlyToPreHot()
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
    -- EyeBeam protection channel
    local CanCast = true
    --local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    --local castName, castStartTime, castEndTime, notInterruptable, spellID, isChannel = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
    -- If we got Eyebeam or Azerite Beam or Fel barrage
    if inCombat and (spellID == A.Tranquility.ID) then 
        -- Get Remaining seconds left on current Cast
        if secondsLeft > 0 + A.GetPing() then
            CanCast = false
        else
            CanCast = true
        end
    end
    -- Showing icon PoolResource to make sure nothing else is read by GG
    if not CanCast then
        return A.PoolResource:Show(icon)
    end
     
		--######################################################################################################################################################################################################################################################
		--+++ Offensive Rotation +++
		--######################################################################################################################################################################################################################################################
    local function DamageRotation(unit)
        --##### Party HP Check #####
	--Set target to party member
		if CanCast and IsUnitEnemy(target) and
		TeamCache.Friendly.Size <= 5 and 
        (HealingEngine.GetBelowHealthPercentUnits(70) >= 1 or
		(A.Lifebloom:IsSpellInRange("focus") and A.Lifebloom:PredictHeal("target") and
		Unit("focus"):IsExists() and Unit("focus"):HealthPercent() <= 85 and Unit("focus"):HasBuffs(33763, player, true) == 0 and A.HealingEngine.GetBuffsCount(33763, 0, player, true) == 0))
		then
			return A.Darkflight:Show(icon) --bind as /tar player macro in game
		end	

	--Set target to enemy
		if CanCast and A.SolarWrath:IsReady(unit) and
            -- TargetTarget
		(
            Player:GetStance()==4 or
            Player:GetStance()==0
        ) and 	
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.SolarWrath:IsSpellInRange(targettarget)
            )
        then
            return A:Show(icon, ACTION_CONST_AUTOTARGET)
        end

		--[[Set target to enemy
		if CanCast and IsUnitFriendly(target) and
		TeamCache.Friendly.Size <= 5 and 
        HealingEngine.GetBelowHealthPercentUnits(75) < 1 and
		(Unit("focus"):IsExists() and Unit("focus"):HealthPercent() > 90)
		then
			return A:Show(icon, ACTION_CONST_AUTOTARGET)
		end]]
		
		--[[##### Prowl #####
        if A.Prowl:IsReady(player) and
        combatTime == 0 and
        A.FeralAffinity:IsSpellLearned() and -- Feral affility
        not Player:IsStealthed() and
        (
            -- Target
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) 
            )
        )
        then
            return A.Prowl:Show(icon)
        end]]
 
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
          --##### Cat Form #####
        if CanCast and A.FeralAffinity:IsSpellLearned() and Player:GetStance()==0 and combatTime > 0 and
        (
            -- Target
            (
                IsUnitEnemy(target) and
				A.Rake:IsSpellInRange(target) and
                Unit(target):HasDeBuffs(93402, true) > 3 and
                Unit(target):HasDeBuffs(8921, true) > 3			
            ) 		
        )
        then
            return A.CatForm:Show(icon)
        end      --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
        
        --##### Rake #####
        if A.Rake:IsReady(unit) and Unit(unit):IsBoss() and
        A.FeralAffinity:IsSpellLearned() and -- Feral affility 
        Player:GetStance()==2 and
        (
            Player:ComboPoints()<5 or
            Player:IsStealthed()
        ) and
        (    
            -- Target
            (
                
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.Rake:IsSpellInRange(target) and
                (
                    Unit(target):PT(155722, true, true) or
                    Player:IsStealthed()
                ) and
                A.Rake:AbsentImun(target, Temp.TotalAndPhys, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Rake:IsSpellInRange(targettarget) and            
                (                
                    Unit(targettarget):PT(155722, true, true) or
                    Player:IsStealthed()
                ) and
                A.Rake:AbsentImun(targettarget, Temp.TotalAndPhys, true)
                
            )    
        )
        then
            return A.Rake:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Swipe #####
        if A.Swipe:IsReady(player) and 
        A.FeralAffinity:IsSpellLearned() and -- Feral affility
        Player:GetStance()== 2 and
        Player:ComboPoints() < 5 and
        IsUnitEnemy(target) and
		AoE(3, 8) and
        Unit(target):CanInterract(8)
        then
            return A.Swipe:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Shred #####
        if A.Shred:IsReady(unit) and
        Player:GetStance()==2 and
        Player:ComboPoints()<5 and
        (    
            -- Target
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.Shred:IsSpellInRange(target) and
                A.Shred:AbsentImun(target, Temp.TotalAndPhys, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Shred:IsSpellInRange(targettarget) and
                A.Shred:AbsentImun(targettarget, Temp.TotalAndPhys, true)
            )
        )
        then
            return A.Shred:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
        
        --##### Rip #####
        if A.Rip:IsReady(unit) and Unit(unit):IsBoss() and
        Player:GetStance()==2 and
        Player:ComboPoints()>=5 and
        A.FeralAffinity:IsSpellLearned() and -- Feral affility
        (
            -- Target
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.Rip:IsSpellInRange(target) and
                Unit(target):PT(1079, true, true) and
                A.Rip:AbsentImun(target, Temp.TotalAndPhys, true)
            ) or 
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Rip:IsSpellInRange(targettarget) and
                Unit(targettarget):PT(1079, true, true) and
                A.Rip:AbsentImun(targettarget, Temp.TotalAndPhys, true)
            )
        )
        then
            return A.Rip:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
        
        --##### Ferocious Bite #####
        if A.FerociousBite:IsReady(unit) and 
        Player:GetStance()==2 and
        Player:ComboPoints()>=5 and
        (
            -- Target
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.FerociousBite:IsSpellInRange(target) and
                A.FerociousBite:AbsentImun(target, Temp.TotalAndPhys, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.FerociousBite:IsSpellInRange(targettarget) and
                A.FerociousBite:AbsentImun(targettarget, Temp.TotalAndPhys, true)
            )
        )
        then
            return A.FerociousBite:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Ironfur #####
        if A.Ironfur:IsReady(player) and 
        Player:GetStance()==1 and
        Unit(player):GetDMG(3)>0 and
        Unit(player):HasBuffs(A.Ironfur.ID, true)<=1
        then
            return A.Ironfur:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        ---##### Frenzied Regeneration #####
        if A.FrenziedRegeneration:IsReady(player) and
        Player:GetStance()==1 and
        A.GuardianAffinity:IsSpellLearned() and -- Guardian affility
        Unit(player):HasBuffs(A.FrenziedRegeneration.ID, true)<=0.1 and
        (
            (
                A.FrenziedRegeneration:GetSpellCharges()>=2 and
                Unit(player):Health()<=Unit(player):HealthMax()*0.9 
            ) or
            A.FrenziedRegeneration:PredictHeal("player")
        )
        then
            return A.FrenziedRegeneration:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
		
        --##### Mangle #####
        if A.Mangle:IsReady(unit) and 
        Player:GetStance()==1 and
        (
            -- Target
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.Mangle:IsSpellInRange(target) and
                A.Mangle:AbsentImun(target, Temp.TotalAndPhys, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Mangle:IsSpellInRange(targettarget) and
                A.Mangle:AbsentImun(targettarget, Temp.TotalAndPhys, true)
            )
        )
        then
            return A.Mangle:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Trash #####
        if A.Thrash:IsReady(player) and 
        Player:GetStance()==1 and
        A.GuardianAffinity:IsSpellLearned() and -- Guardian affility
        not (
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and
                not Unit(target):IsDead() and
                not IsUnitEnemy(target) 
            )
        ) and
        AoE(1, 8) and
        A.Thrash:AbsentImun(target, Temp.TotalAndPhys, true)
        then
            return A.Thrash:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
		
        --##### Sunfire #####
        if CanCast and A.Sunfire:IsReady(unit) and
        (
            Player:GetStance()==4 or
            Player:GetStance()==0
        ) and 
            -- Target
            (
                IsUnitEnemy(target) and
                A.Sunfire:IsSpellInRange(target) and
                Unit(target):PT(164815, true, true) and
                A.Sunfire:AbsentImun(target, Temp.TotalAndMag, true) and
                Unit(target):HasBuffs(48707, true) == 0 -- AMS
            )
		then
			return A.Sunfire:Show(icon)
		end
		
		--[[if CanCast and  A.Sunfire:IsReady(unit) and
        (
            Player:GetStance()==4 or
            Player:GetStance()==0
        ) and 
        (
            -- Target
            (
                IsUnitEnemy(target) and
                A.Sunfire:IsSpellInRange(target) and
                Unit(target):PT(164815, true, true) and
                A.Sunfire:AbsentImun(target, Temp.TotalAndMag, true) and
                Unit(target):HasBuffs(48707, true) == 0 -- AMS
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Sunfire:IsSpellInRange(targettarget) and
                Unit(targettarget):PT(164815, true, true) and
                A.Sunfire:AbsentImun(targettarget, Temp.TotalAndMag, true) and
                Unit(targettarget):HasBuffs(48707, true) == 0 -- AMS
            )
        )
        then
            return A.Sunfire:Show(icon)
        end]]
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
        --##### Moonfire #####
        if CanCast and A.Moonfire:IsReady(unit) and 
        (
            Player:GetStance()==4 or
            Player:GetStance()==0
        ) and 		
        (
            -- Target
            (        
                IsUnitEnemy(target) and
                A.Moonfire:IsSpellInRange(target) and
                Unit(target):PT(164812, true, true) and
                A.Moonfire:AbsentImun(target, Temp.TotalAndMag, true) and
                Unit(target):HasBuffs(48707, true) == 0 -- AMS
            ) 
			--[[or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and Unit(unit):IsBoss() and 
                IsUnitEnemy(targettarget) and 
                A.Moonfire:IsSpellInRange(targettarget) and
                Unit(targettarget):PT(164812, true, true) and
                A.Moonfire:AbsentImun(targettarget, Temp.TotalAndMag, true) and
                Unit(targettarget):HasBuffs(48707, true) == 0 -- AMS
            )]]
        )
        then
            return A.Moonfire:Show(icon)
        end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
		
        --[[##### Moonkin Form #####
        if CanCast and A.BalanceAffinity:IsSpellLearned() and Player:GetStance()==0 and combatTime > 0 and
        (
            -- Target
            (
                IsUnitEnemy(target)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget)
            )
        )
        then
            return A.Darkflight:Show(icon)
        end]]
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
		
        --[[##### Heart of the Wild #####
        if CanCast and A.HeartoftheWild:IsSpellLearned() and A.HeartoftheWild:IsReady(unit) and Player:GetStance() == 4 and Unit(unit):IsBoss() and combatTime > 0 and
		A.BalanceAffinity:IsSpellLearned() and
        (
            -- Target
            (
                IsUnitEnemy(target) and
                A.Starsurge:IsSpellInRange(target) and
                A.Starsurge:AbsentImun(target, Temp.TotalAndMag, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Starsurge:IsSpellInRange(targettarget) and
                A.Starsurge:AbsentImun(targettarget, Temp.TotalAndMag, true)
            )
        )
        then
            return A.WarStomp:Show(icon)
        end]]
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
		
        --##### Starsurge #####
        if A.Starsurge:IsReady(unit) and Player:GetStance()==4 and combatTime > 0 and Unit(player):GetCurrentSpeed()==0 and
        A.BalanceAffinity:IsSpellLearned() and
        (
            -- Target
            (
                IsUnitEnemy(target) and
                A.Starsurge:IsSpellInRange(target) and
                A.Starsurge:AbsentImun(target, Temp.TotalAndMag, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.Starsurge:IsSpellInRange(targettarget) and
                A.Starsurge:AbsentImun(targettarget, Temp.TotalAndMag, true)
            ) 
        )
        then
            return A.Starsurge:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Starfire #####
        if A.LunarStrike:IsReady(unit) and Player:GetStance()==4 and combatTime > 0 and Unit(player):GetCurrentSpeed()==0 and
        A.BalanceAffinity:IsSpellLearned() and not Unit(unit):IsBoss() and 
        (
            -- Target
            (
                IsUnitEnemy(target) and
                A.LunarStrike:IsSpellInRange(target) and
                A.LunarStrike:AbsentImun(target, Temp.TotalAndMag, true)
            ) or
            -- TargetTarget
            (
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.LunarStrike:IsSpellInRange(targettarget) and
                A.LunarStrike:AbsentImun(targettarget, Temp.TotalAndMag, true)
            ) 
        )
        then
            return A.LunarStrike:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
		--##### Wrath #####
        if CanCast and A.SolarWrath:IsReady(unit) and combatTime > 0 and Unit(player):GetCurrentSpeed()==0 and
        (
            Player:GetStance()==4 or
            Player:GetStance()==0
        ) and 
        (
            -- Target
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.SolarWrath:IsSpellInRange(target) and
                A.SolarWrath:AbsentImun(target, Temp.TotalAndMag, true)
            ) or
            -- TargetTarget
            (
                --not Unit(player):HasSpec(105) and -- Restor
                Unit(targettarget):IsExists() and 
                IsUnitEnemy(targettarget) and 
                A.SolarWrath:IsSpellInRange(targettarget) and
                A.SolarWrath:AbsentImun(targettarget, Temp.TotalAndMag, true)
            ) 
        )
        then
            return A.SolarWrath:Show(icon)
        end  
    end 
    DamageRotation = Action.MakeFunctionCachedDynamic(DamageRotation)
    
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
    local function HealingRotation(unit)
        -- Vars
        local useDispel, useShields, useHoTs, useUtils = HealingEngine.GetOptionsByUnitID(unit)
        local unitGUID = UnitGUID(unit)

		--######################################################################################################################################################################################################################################################
		--+++ Self Defensive +++
		--######################################################################################################################################################################################################################################################		
		          
        --##### Renewal #####
        if A.Renewal:IsReady(player) and Unit(player):HasBuffs(A.Ironbark.ID, true) == 0 and Unit(player):HasBuffs(A.Barkskin.ID, true) == 0 and Unit(player):HealthPercent() <= 30 then 
            return A.Renewal:Show(icon)
        end 		
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
        -- --##### Barkskin #####
        if A.Barkskin:IsReady(player) and Unit(player):HasBuffs(A.Ironbark.ID, true) == 0 and Unit(player):HasBuffs(A.Barkskin.ID, true) == 0 and  Unit(player):HealthPercent() <= 60 then 
            return A.Barkskin:Show(icon)
        end 
		
		--######################################################################################################################################################################################################################################################
		--+++ Utilities +++
		--######################################################################################################################################################################################################################################################	
		
        --##### Battle Ress #####
        if A.Rebirth:IsReady(unit) and
        A.Zone ~= "arena" and
        Unit(player):CombatTime() > 0 and
        Unit(player):GetCurrentSpeed() == 0 and
        ( 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and
                Unit("target"):IsDead() and
                Unit("target"):IsPlayer() and
                (UnitInRaid("target") or UnitInParty("target")) and
                A.Rebirth:IsSpellInRange("target")
            )
        )
        then
            return A.Rebirth:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------          
        --##### Ress Aoe #####
        if A.Revitalize:IsReady(player) and
        Unit(player):CombatTime()==0 and
        Unit(player):GetCurrentSpeed()==0 and
        (
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and
                Unit("target"):IsDead() and
                Unit("target"):IsPlayer() and
                (UnitInRaid("target") or UnitInParty("target")) and
                Unit("target"):GetRange()<=100
            )
        )
        then
            return A.Revitalize:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------          
        --##### Ress Single #####
        if A.Revive:IsReady(unit) and
        Unit(player):CombatTime()==0 and
        Unit(player):GetCurrentSpeed()==0 and
        (
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and
                Unit("target"):IsDead() and
                Unit("target"):IsPlayer() and
                not IsUnitEnemy("target") and
                A.Revive:IsSpellInRange("target")
            )
        )
        then
            return A.Revive:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------          
        --##### Dispel Sniper #####
        if A.NaturesCure:IsReady() then
            for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel") then  
                    HealingEngine.SetTarget(getmembersAll[i].Unit)                                                        
                end                
            end
        end        
        -- General Dispel
        if A.NaturesCure:IsReady(unit) and
        useDispel and
        (
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and        
                not IsUnitEnemy("target") and
                AuraIsValid(target, "UseDispel", "Dispel")
            )
        )
        then
            return A.NaturesCure:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------          
        --##### Soothe #####
        if A.Soothe:IsReady(unit) and
        (
            (    -- Target
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    not IsUnitEnemy("mouseover")
                ) and
                IsUnitEnemy("target") and     
                A.Soothe:IsSpellInRange("target") and
                (
                    (
                        A.IsInPvP and
                        select(2, UnitClass("target")) == "WARRIOR" and
                        Unit("target"):HasBuffs("Rage")>2
                    ) or 
                    (
                        not A.IsInPvP and
                        SootheAble("target")
                    )
                )
            ) or 
            (    -- Targettarget
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    not IsUnitEnemy("mouseover")
                ) and
                IsUnitEnemy("targettarget") and     
                A.Soothe:IsSpellInRange("targettarget") and
                (
                    (
                        A.IsInPvP and
                        select(2, UnitClass("targettarget")) == "WARRIOR" and
                        Unit("targettarget"):HasBuffs("Rage")>2
                    ) or 
                    (
                        not A.IsInPvP and
                        SootheAble("targettarget")
                    )
                )
            )
        )
        then
            return A.Soothe:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------          
        --##### Pvp MarkoftheWild #####
        if A.MarkoftheWild:IsReady(player) and
        combatTime == 0 and
        A.MarkoftheWild:GetSpellTimeSinceLastCast() > 2 and
        A.MarkoftheWild:IsSpellLearned() and
        ( 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and
                not Unit(target):IsDead() and
                not IsUnitEnemy(target) and
                Unit(target):HasDeBuffs(33786, true) == 0 and
                A.MarkoftheWild:IsSpellInRange(target) and
                Unit(target):PT(289318, nil, true)
            )
        )
        then
            return A.MarkoftheWild:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------          
        --##### Bear From against CC in pvp #####
        if A.BearForm:IsReady(player) and
        combatTime > 0 and
        (
            (
                Player:GetStance() == 0 and
                Unit(player):HasBuffs(A.IncarnationTreeofLife.ID, true) == 0 and    
                Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) == 0 and -- Incarnation
                EnemyTeam():IsReshiftAble() 
            ) or
            (                
                -- Boomkin silence with roots
                Unit(player):HasDeBuffs(78675, true) > 0 and
                Unit(player):HasDeBuffs("Rooted") > 0
            ) or
            (
                Unit(player):IsFocused("MELEE") and
                Unit(player):TimeToDie() < 5
            )
        )
        then
            return A.BearForm:Show(icon)
        end
		
		--######################################################################################################################################################################################################################################################
		--+++ Spreading Rejuvenation +++
		--######################################################################################################################################################################################################################################################
		
        --##### Rejuvenation Macro #####
        if CanCast and isForcedRejuvenation then
            TMW:RegisterCallback("TMW_ACTION_HEALINGENGINE_UNIT_UPDATE", function(callbackEvent, thisUnit, db, QueueOrder)
                    local HP            = thisUnit.HP
                    local MHP            = thisUnit.MHP
                    local DMG             = thisUnit.incOffsetDMG
                    local Role             = thisUnit.Role
                    local unitID         = thisUnit.Unit
                    local isSelf         = thisUnit.isSelf
                    
                    if Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) <= 1 then 
                        --QueueOrder.useRejuv = true -- that will skips check :HasBuffs(18, true) for other members and save performance because you can use shield only on one unit per GCD but loop refrehes every ~0.3 sec
                        HP = HP - 20
                        if HP < 40 then 
                            HP = 40 
                        end 
                    end 
                    
                    return HP
            end)
        end
        -- Macro Forced Rejuvenation
        if CanCast and isForcedRejuvenation and A.Rejuvenation:IsReady(unit) and Unit(unit):HasBuffs(A.Rejuvenation.ID, player, true) == 0 then  
            return A.Rejuvenation:Show(icon)
        end 

		--######################################################################################################################################################################################################################################################
		--+++ Burst Single Target +++
		--######################################################################################################################################################################################################################################################		

        --##### Trinket 1 #####
		local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.Trinket1:IsReady(unit) and A.Trinket1:GetItemCategory() ~= "DPS" and
		combatTime > 0 and Unit(target):HasBuffs(A.Ironbark.ID, true) == 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                Unit(target):HealthPercent() <= Stoneform/2
            )
        )
        then 
            return A.Trinket1:Show(icon)
        end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
        
        --##### Trinket 2 #####
		local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.Trinket2:IsReady(unit) and A.Trinket2:GetItemCategory() ~= "DPS" and
		combatTime > 0 and Unit(target):HasBuffs(A.Ironbark.ID, true) == 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                Unit(target):HealthPercent() <= Stoneform/2
            )
        )
        then 
            return A.Trinket2:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
		
        --##### Ironbark #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.Ironbark:IsReady(unit) and A.Ironbark:IsSpellInRange(target) and 
		combatTime > 0 and Unit(target):HasBuffs(A.Ironbark.ID, true) == 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                Unit(target):HealthPercent() <= Stoneform/2
            )
        )
        then 
            return A.Ironbark:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### VitalityConduit #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.VitalityConduit:IsReady(unit) and A.VitalityConduit:IsSpellInRange(target) and
		combatTime > 0 and Unit(target):HasBuffs(A.Ironbark.ID, true) == 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                Unit(target):HealthPercent() <= Stoneform
            )
        )
        then 
            return A.Shadowmeld:Show(icon)
        end

		--######################################################################################################################################################################################################################################################
		--+++ Burst Multi Target +++
		--######################################################################################################################################################################################################################################################

        --##### Tranquility #####
        if CanCast and A.BurstIsON(unit) and A.Tranquility:IsReady(player) and Unit(player):GetCurrentSpeed() == 0 and 
		combatTime > 0 and Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(60) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(50) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(60) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(50) >= 3
            )
        )
        then  
            return A.Tranquility:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Innervate with Incarnation Buff ##### 
        if CanCast and A.BurstIsON(unit) and A.Innervate:IsReady(player) and
		combatTime > 0  and Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) > 10 and
        not Unit(target):IsDead() and not IsUnitEnemy(target)
        then  
            return A.Innervate:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### IncarnationTreeofLife #####
        if CanCast and A.BurstIsON(unit) and A.IncarnationTreeofLife:IsSpellLearned() and A.IncarnationTreeofLife:IsReady(player) and
		combatTime > 0 and Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) == 0 and 
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(80) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(60) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(80) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(60) >= 3
            )
        )
        then  
            return A.IncarnationTreeofLife:Show(icon)
        end
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
        --##### Innervate #####
        if CanCast and A.BurstIsON(unit) and A.Innervate:IsReady(player) and
		combatTime > 0  and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(80) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(60) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(80) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(60) >= 3
            )
        )
        then  
            return A.Innervate:Show(icon)
        end
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Flourish #####
        if CanCast and A.BurstIsON(unit) and A.Flourish:IsSpellLearned() and A.Flourish:IsReady(player) and 
		combatTime > 0 and Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and A.LastPlayerCastID == A.WildGrowth.ID and
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(90) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(80) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(70) >= 3
            )
        )
        then   
            return A.Flourish:Show(icon)
        end                     

		--######################################################################################################################################################################################################################################################
		--+++ Healing Rotation +++
		--######################################################################################################################################################################################################################################################
   
        --##### Swiftmend with Soul of Forest Talent to increase Wild Growth #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.SouloftheForest:IsSpellLearned() and A.Swiftmend:IsReady(unit) and A.Swiftmend:IsSpellInRange(target) and 
		Unit(player):HasBuffs(114108, player, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 3
            )
        )
        then 
            return A.Swiftmend:Show(icon)
        end	
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Wild Growth #####
        if CanCast and A.WildGrowth:IsReady(unit) and A.WildGrowth:IsSpellInRange(target) and
		Unit(player):GetCurrentSpeed() == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                TeamCache.Friendly.Size > 5 and 
                A.LastPlayerCastID == A.Swiftmend.ID and 
				A.SouloftheForest:IsSpellLearned()
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 3
            )
        )
        then  
            return A.WildGrowth:Show(icon)
        end 
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Lifebloom on Player with Photosynthesis Talent to increase Aoe Healing #####
        if CanCast and A.Photosynthesis:IsSpellLearned() and A.Lifebloom:IsReady(player) and A.Lifebloom:IsSpellInRange(target) and
		Unit(player):HasBuffs(A.Lifebloom.ID, true) == 0 and not Unit("focus"):Role("HEALER") and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 10
            ) or
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 8
            ) or                    
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 6
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(95) >= 5
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(85) >= 4
            ) or                    
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(75) >= 3
            )
        )
        then          
            return A.Thorns:Show(icon)
        end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
        
        --##### Regrowth when ClearCasting or Innervate Buff #####
        if CanCast and A.Regrowth:IsReady(unit) and A.Regrowth:IsSpellInRange(target) and A.Regrowth:PredictHeal("target") and
		(Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) > 0 or Unit(player):GetCurrentSpeed() == 0) and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                Unit(target):HealthPercent() < 100 and Unit(player):HasBuffs(A.ClearCasting.ID, player, true) > 0
            ) or
            (
                Unit(target):HealthPercent() < 100 and Unit(player):HasBuffs(A.Innervate.ID, player, true) > 0
            ) 			
        )
        then  
            return A.Regrowth:Show(icon)
        end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  
		
        --##### Swiftmend #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.Swiftmend:IsReady(unit) and A.Swiftmend:IsSpellInRange(target) and A.Swiftmend:PredictHeal("target") and
        combatTime > 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0  and 
		not Unit(target):IsDead() and not IsUnitEnemy(target) and
        (
            (
                Unit(target):HealthPercent() <= Stoneform
            ) 
        )
        then  
            return A.Swiftmend:Show(icon)
        end		
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Cenarion Ward #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.CenarionWard:IsReady(unit) and A.CenarionWard:IsSpellInRange(target) and A.CenarionWard:PredictHeal("target") and
        combatTime > 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0 and 
		not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                Unit(target):HealthPercent() <= Stoneform
            )
        )
        then 
            return A.CenarionWard:Show(icon)
        end			
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Lifebloom #####
        if CanCast and A.Lifebloom:IsReady(unit) and A.Lifebloom:IsSpellInRange(target) and A.Lifebloom:PredictHeal("target") and
		Unit(target):HasBuffs(33763, player, true) == 0 and A.HealingEngine.GetBuffsCount(33763, 0, player, true) == 0 and not Unit("focus"):Role("HEALER") and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                 Unit(target):Role("TANK")
            )
        )
        then  
            return A.Lifebloom:Show(icon)
        end 	
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Germination #####
        if CanCast and A.Germination:IsSpellLearned() and A.Rejuvenation:IsReady(unit) and A.Rejuvenation:IsSpellInRange(target) and A.Rejuvenation:PredictHeal("target") and Unit(target):HasBuffs(A.Rejuvenation.ID, true, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                -- Party
               TeamCache.Friendly.Size <= 5 and Unit(target):HealthPercent() < 80 
            ) or
            (
                -- Raid
                TeamCache.Friendly.Size > 5 and Unit(target):HealthPercent() < 70 
            )
        )
        then 
            return A.Rejuvenation:Show(icon)
        end    
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Rejuvenation #####
        if CanCast and A.Rejuvenation:IsReady(unit) and A.Rejuvenation:IsSpellInRange(target) and A.Rejuvenation:PredictHeal("target") and Unit(target):HasBuffs(A.Rejuvenation.ID, true, true) == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                -- Party
               TeamCache.Friendly.Size <= 5 and Unit(target):HealthPercent() < 100
            ) or
            (
                -- Raid
                TeamCache.Friendly.Size > 5 and Unit(target):HealthPercent() < 90 
            )
        )
        then 
            return A.Rejuvenation:Show(icon)
        end 
        --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
        --##### Overgrowth #####
        if CanCast and A.Overgrowth:IsSpellLearned() and A.Overgrowth:IsReady(unit) and A.Overgrowth:IsSpellInRange(target) and A.Overgrowth:PredictHeal("target") and
        combatTime > 0 and Unit(target):HasBuffs(A.VitalityConduit.ID, true) == 0 and
		not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                Unit(target):HealthPercent() <= Stoneform/2
            )
        )
        then 
            return A.Overgrowth:Show(icon)
        end			
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Nourish #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.Nourish:IsSpellLearned() and A.Nourish:IsReady(unit) and A.Nourish:IsSpellInRange(target) and A.Nourish:PredictHeal("target") and
		Unit(unit):HasBuffs(A.Rejuvenation.ID, player, true) > 2 and Unit(player):GetCurrentSpeed() == 0 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                Unit(target):HealthPercent() <= Stoneform
            )
        )
        then 
            return A.Nourish:Show(icon)
        end     
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Regrowth #####
        local Stoneform = GetToggle(2, "Stoneform")
        if CanCast and A.Regrowth:IsReady(unit) and A.Regrowth:IsSpellInRange(target) and A.Regrowth:PredictHeal("target") and 
		(Unit(player):HasBuffs(A.IncarnationTreeofLifeBuff.ID, true) > 0 or Unit(player):GetCurrentSpeed() == 0) and Unit(target):HasBuffs(A.Rejuvenation.ID, player, true) >= 2 and
        not Unit(target):IsDead() and not IsUnitEnemy(target) and 
        (
            (
                Unit(target):HealthPercent() <= Stoneform
            )
        )
        then  
            return A.Regrowth:Show(icon)
        end 
        -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
		
        --##### Lifebloom Focus #####
        if CanCast and A.Lifebloom:IsReady(unit) and A.Lifebloom:IsSpellInRange("focus") and A.Lifebloom:PredictHeal("target") and
		Unit("focus"):IsExists() and Unit("focus"):HasBuffs(33763, player, true) == 0 and A.HealingEngine.GetBuffsCount(33763, 0, player, true) == 0
		then            
            return A.MarkoftheWild:Show(icon)
        end		
    end 
    HealingRotation = Action.MakeFunctionCachedDynamic(HealingRotation)


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
    -- Heal Target 
    if IsUnitFriendly(target) then 
        unit = target 
        
        if HealingRotation(unit) then 
            return true 
        end 
    end  
    
    -- DPS TargetTarget 
    if IsUnitEnemy(targettarget) then 
        unit = targettarget    
        
        if DamageRotation(unit) then 
            return true 
        end 
    end     
    
    -- DPS Target     
    if IsUnitEnemy(target) then 
        unit = target
        
        if DamageRotation(unit) then 
            return true 
        end 
    end     
    
end 

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end 

local function RotationPassive(icon)
    if not GetToggle(2, "UseRotationPassive") then 
        return 
    end 
    RotationsVariables()
    
    
    -- Passive Renewal
    if A.Renewal:IsReady(player) and Unit(player):HealthPercent() <= 30 and
    Unit(player):CombatTime()>0 and
    (
        --MacroSpells("Icon6", "Renewal") or
        (
            --deff_toggle and
            Unit(player):GetDMG()>0 and        
            (
                Unit(player):Health() <= Unit(player):HealthMax()*0.21 or
                (
                    A.IsInPvP and
                    Unit(player):UseDeff() and
                    (
                        FriendlyTeam("HEALER"):GetCC() >= 3 or
                        Unit(player):HasSpec(105) -- Restor
                    ) and
                    Unit(player):IsFocused() and
                    (
                        
                        Unit(player):TimeToDie()<=11 or
                        Unit(player):IsExecuted()            
                    )        
                )
            )        
        )    
    )
    then 
        return A.Renewal:Show(icon)
    end    
    
    
    -- Thorns Player
    if A.Thorns:IsReady(player) and 
    Unit(player):CombatTime()>0 and
    A.Thorns:IsSpellLearned() and
    (
        (
            --Thorns_toggle and
            not BurstBuffs() and
            Unit("player"):IsFocused("MELEE")
        ) 
    )
    then 
        return A.Thorns:Show(icon)
    end    
    
end 


-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end
-- [5] Trinket Rotation
-- No specialization trinket actions 
-- Passive 
--[[local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", 3355) > UnitCooldown:GetMaxDuration("arena", 3355) - 2 and
    UnitCooldown:IsSpellInFly("arena", 3355) and 
    Unit(player):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end ]]--


local function ArenaRotation(icon, unit)
    RotationsVariables()
    
    if A.IsInPvP and (A.Zone == "arena") and (unit == "arena1" or unit == "arena2" or unit == "arena3") and not Player:IsStealthed() and not Player:IsMounted() then
        
        -- EntanglingRoots Arena
        if A.EntanglingRoots:IsReady(unit) and 
        PvPEntanglingRoots(unit) and 
        Unit(unit):HasBuffs("Reflect") == 0 and
        Unit(unit):HasBuffs("CCMagicImun") == 0 and
        Unit(unit):HasBuffs("CCTotalImun") == 0
        then
            return A.EntanglingRoots
        end
        
        -- Soothe Arena
        if A.Soothe:IsReady(unit) and 
        --Soothe_toggle and
        not UnitIsUnit("target", unit) and  
        --not InLOS("arena1") and
        A.Soothe:IsSpellInRange(unit) and
        (
            (
                UnitClass(unit) == "WARRIOR" and
                Unit(unit):HasBuffs("Rage")>2
            ) or
            (
                PvPEnemyIsHealer(unit) and
                Unit(unit):HasBuffs("Reflect")>2        
            )
        )
        then
            return A.Soothe
        end
    end 
end 

local function PartyRotation(unit)
    RotationsVariables()
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end
    
    -- Dispel Party1
    if A.NaturesCure:IsReady(unit) and
    AuraIsValid(unit, "UseDispel", "Dispel")
    then
        return A.NaturesCure
    end
    
    -- Thorns Party1
    if A.Thorns:IsReady(unit) and
    Unit(player):CombatTime()>0 and
    A.Thorns:IsSpellLearned() and
    A.Thorns:IsSpellInRange(unit) and
    Unit(unit):HasDeBuffs(33786, true) == 0 and -- Cyclone
    --not InLOS("party1") and 
    (
        (
            --Thorns_toggle and
            not BurstBuffs() and
            Unit(unit):IsFocused("MELEE")
        ) 
    )
    then
        return A.Thorns
    end
    
    
end 

A[6] = function(icon)
    -- Call rotations variables
    RotationsVariables()
    
    -- StopCast OverHeal
    -- if Temp.LastPrimaryUnitID and CanStopCastingOverHeal() and StopCastOverHeal then 
    --     return A:Show(icon, ACTION_CONST_STOPCAST)
    --  end
    
    -- Stop Cast M+ Quake Affix
    if Unit(player):IsCastingRemains() > 0 and StopCastQuake and Unit(player):HasDeBuffs(A.Quake.ID) <= StopCastQuakeSec and Unit(player):HasDeBuffs(A.Quake.ID) > 0 then
        return A:Show(icon, ACTION_CONST_STOPCAST)
    end
    
    if RotationPassive(icon) then 
        return true 
    end 
    
    local Arena = ArenaRotation("arena1")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[7] = function(icon)
    if RotationPassive(icon) then 
        return true 
    end 
    
    local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end   
    
    local Arena = ArenaRotation("arena2")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[8] = function(icon)
    if RotationPassive(icon) then 
        return true 
    end 
    
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    
    local Arena = ArenaRotation("arena3")
    if Arena then 
        return Arena:Show(icon)
    end 
end

-------------------------------------------
-- [[ UI: QUEUE BASE ]] 
-------------------------------------------
local GameLocale = GetLocale()    
local Localization = {
    [GameLocale] = {},
    enUS          = {
        QERROR1 = "Already queued: ",
        QERROR2 = "Not available: ",
    },
    ruRU         = {
        QERROR1 = "Уже находится в очереди: ",
        QERROR2 = "Недоступно: ",
    },
}
local L = setmetatable(Localization[GameLocale], { __index = Localization.enUS })

local QB = {
    player                                 = {UnitID = "player",         Silence = false, Value = true, Auto = true, Priority = 1},
    target                                 = {UnitID = "target",         Silence = false, Value = true, Auto = true, Priority = 1},
    Cancel                                 = {Silence = false},
    IsQueuedObjects                        = function(...)
        local found 
        for i = 1, select("#", ...) do
            local object = select(i, ...)
            if object:IsQueued() then 
                found = true 
                A.Print(L.QERROR1 .. object:Info())
            end 
        end 
        
        return found 
    end,
    IsUnavailableObjects                = function(...)
        local found 
        for i = 1, select("#", ...) do
            local object = select(i, ...)
            if object:GetCooldown() > 0 then 
                found = true 
                A.Print(L.QERROR2 .. object:Info())
            end 
        end 
        
        return found 
    end,
}

function Action.QueueBase(name)
    
    if name == "BurstHealing" then     
        
        -- Note: Only for non GGL profiles and Action initializated
        -- Argument 'func' must be function which will return number (health percent), this function accepts same arguments what will has PerformByProfileHP and fires for each member through enumeration-loop, at the end of loop all members will be sorted by default (refference to A.HealingEngine.SortMembers)
        -- [1] member is @string refference for unitID 
        -- [2] memberhp is @number refference for health percent of member 
        -- [3] membermhp is @number refference for max health non-percent of member 
        -- [4] DMG is @number refference for Unit(member):GetRealTimeDMG() indicates for real time incoming damage, it has limit 15% of the max health per second and can't be higher
        -- Usage: 
        local HealingEngineQueueOrder = HealingEngine.Data.QueueOrder -- this is very useful @table which resets every full enumeration-loop (see example of use below)
        HealingEngine.SetPerformByProfileHP(
            function(member, memberhp, membermhp, DMG)
                if not HealingEngineQueueOrder.useRejuv and Unit(member):HasBuffs(A.Rejuvenation.ID, true) < 1 then 
                    HealingEngineQueueOrder.useRejuv = true -- that will skips check :HasBuffs(18, true) for other members and save performance because you can use shield only on one unit per GCD but loop refrehes every ~0.3 sec
                    --memberhp = memberhp - 20
                    if memberhp < 100 then 
                        memberhp = 100 
                    end 
                end 
                
                return memberhp
        end)
        
        -- Rejuvenation
        if A.Rejuvenation:IsReadyByPassCastGCDP("target") then  
            A.Rejuvenation:SetQueue(QB.target)        -- #1
        end 
        
        -- Check valid 
        --if QB.IsQueuedObjects(A.WildGrowth, A.Lifebloom) or QB.IsUnavailableObjects(A.Lifebloom) then 
        --     return 
        -- end         
        
        -- Cancel other queues 
        --A.CancelAllQueueForMeta(3)                                                       
        
        -- Force spread Rejuvenation        
        if not HasEnoughRejuvenationApplied() then
            if #HealingEngineMembersALL > 0 then 
                for i = 1, #HealingEngineMembersALL do
                    if A.Rejuvenation:IsReadyByPassCastGCD(HealingEngineMembersALL[i].Unit) and Unit(HealingEngineMembersALL[i].Unit):GetRange() < 40 and Unit(HealingEngineMembersALL[i].Unit):IsPlayer() and Unit(HealingEngineMembersALL[i].Unit):HasBuffs(A.Rejuvenation.ID, true, player) < GetGCD() + 0.1 then
                        A.HealingEngine.SetTarget(HealingEngineMembersALL[i].Unit)
                        --A.Rejuvenation:SetQueue(QB.target)        -- #0
                        A.Rejuvenation:SetQueue(HealingEngineMembersALL[i].Unit)
                        VarPoolForHealingBurst = true
                        -- Notification                    
                        Action.SendNotification("Force Spreading " .. A.GetSpellInfo(A.Rejuvenation.ID), A.Rejuvenation.ID)    
                    end
                end
            end 
        end
        
        -- WildGrowth
        if not A.WildGrowth:IsQueued() and A.WildGrowth:IsReadyByPassCastGCDP("target", nil, nil, true) and HasEnoughRejuvenationApplied() then  
            A.WildGrowth:SetQueue(QB.target)        -- #1
        end 
        
        -- Lifebloom on Player
        if not A.Lifebloom:IsQueued() and A.Lifebloom:IsReadyByPassCastGCDP("player", nil, nil, true) and HasEnoughRejuvenationApplied() then  
            A.HealingEngine.SetTarget("player")
            A.Lifebloom:SetQueue(QB.player)        -- #1
        end         
        
        -- Notification if all good        
        if HasEnoughRejuvenationApplied() then
            -- Notification        
            VarPoolForHealingBurst = false            
            Action.SendNotification("Spreading done !", A.Rejuvenation.ID)    
        end        
        
    end         
end 

