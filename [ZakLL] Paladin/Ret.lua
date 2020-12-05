local _G, setmetatable, pairs, type, math    = _G, setmetatable, pairs, type, math
local math_random                            = math.random

local TMW                                     = _G.TMW 

local Action                                 = _G.Action

local CONST                                 = Action.Const
local Listener                                 = Action.Listener
local Create                                 = Action.Create
local GetToggle                                = Action.GetToggle
local SetToggle                                = Action.SetToggle
local GetLatency                            = Action.GetLatency
local GetGCD                                = Action.GetGCD
local GetCurrentGCD                            = Action.GetCurrentGCD
local BurstIsON                                = Action.BurstIsON
local AuraIsValid                            = Action.AuraIsValid
local InterruptIsValid                        = Action.InterruptIsValid
local Print                                    = Action.Print
local toStr                                    = Action.toStr

local EnemyTeam                                = Action.EnemyTeam
local FriendlyTeam                            = Action.FriendlyTeam
local LoC                                     = Action.LossOfControl
local Player                                = Action.Player 
local MultiUnits                            = Action.MultiUnits
local UnitCooldown                            = Action.UnitCooldown
local Unit                                    = Action.Unit 
local IsUnitEnemy                            = Action.IsUnitEnemy
local IsUnitFriendly                        = Action.IsUnitFriendly
local ActiveUnitPlates                        = MultiUnits:GetActiveUnitPlates()
local DetermineCountGCDs                     = Action.DetermineCountGCDs

local GroupNeedPeel                            = Action.GroupNeedPeel

local Azerite                                 = LibStub("AzeriteTraits")

local ACTION_CONST_PALADIN_RETRIBUTION        = CONST.PALADIN_RETRIBUTION
local ACTION_CONST_AUTOTARGET                = CONST.AUTOTARGET
local ACTION_CONST_SPELLID_FREEZING_TRAP    = CONST.SPELLID_FREEZING_TRAP
local ACTION_CONST_CACHE_DEFAULT_TIMER        = _G.ACTION_CONST_CACHE_DEFAULT_TIMER


local IsIndoors, UnitIsUnit, UnitIsPlayer    = _G.IsIndoors, _G.UnitIsUnit, _G.UnitIsPlayer

Action[ACTION_CONST_PALADIN_RETRIBUTION] = {
    -- Racial
    ArcaneTorrent                             = Create({ Type = "Spell", ID = 50613                                                                             }),
    BloodFury                                 = Create({ Type = "Spell", ID = 20572                                                                              }),
    Fireblood                                   = Create({ Type = "Spell", ID = 265221                                                                             }),
    AncestralCall                              = Create({ Type = "Spell", ID = 274738                                                                             }),
    Berserking                                = Create({ Type = "Spell", ID = 26297                                                                            }),
    ArcanePulse                                  = Create({ Type = "Spell", ID = 260364                                                                            }),
    QuakingPalm                                  = Create({ Type = "Spell", ID = 107079                                                                             }),
    Haymaker                                  = Create({ Type = "Spell", ID = 287712                                                                             }), 
    WarStomp                                  = Create({ Type = "Spell", ID = 20549                                                                             }),
    BullRush                                  = Create({ Type = "Spell", ID = 255654                                                                             }),    
    BagofTricks                               = Create({ Type = "Spell", ID = 312411                                                                             }),    
    GiftofNaaru                               = Create({ Type = "Spell", ID = 59544                                                                            }),
    LightsJudgment                               = Create({ Type = "Spell", ID = 255647                                                                            }),
    Shadowmeld                                  = Create({ Type = "Spell", ID = 58984                                                                            }), -- usable in Action Core 
    Stoneform                                  = Create({ Type = "Spell", ID = 20594                                                                            }), 
    WilloftheForsaken                          = Create({ Type = "Spell", ID = 7744                                                                            }), -- usable in Action Core 
    EscapeArtist                              = Create({ Type = "Spell", ID = 20589                                                                            }), -- usable in Action Core 
    EveryManforHimself                          = Create({ Type = "Spell", ID = 59752                                                                            }), -- usable in Action Core  
    Regeneratin                                  = Create({ Type = "Spell", ID = 291944                                                                            }), -- not usable in APL but user can Queue it
    -- CrownControl    
    Repentance                                = Create({ Type = "Spell", ID = 20066, isTalent = true, isRepentance = true                                    }),
    BlindingLight                            = Create({ Type = "Spell", ID = 115750, isTalent = true, isBlinding = true                                    }),
    HammerofJustice                            = Create({ Type = "Spell", ID = 853, isHammer = true                                                        }),
    HammerofJusticeGreen                    = Create({ Type = "SpellSingleColor", ID = 853, Color = "GREEN", Desc = "[1] CC", QueueForbidden = true        }),
    Rebuke                                    = Create({ Type = "Spell", ID = 96231, isRebuke = true                                                        }),
    RebukeGreen                                = Create({ Type = "SpellSingleColor", ID = 6552, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true    }),
    -- Supportive     
    Taunt                                      = Create({ Type = "Spell", ID = 62124, Desc = "[6] PvP Pets Taunt", QueueForbidden = true                    }),
    BlessingofSanctuary                        = Create({ Type = "Spell", ID = 210256, isTalent = true                                                        }), -- PvP Talent
    BlessingofFreedom                        = Create({ Type = "Spell", ID = 1044                                                                        }),
    BlessingofSacrifice                        = Create({ Type = "Spell", ID = 6940                                                                        }),
    Redemption                                = Create({ Type = "Spell", ID = 7328                                                                        }),
    FlashofLight                            = Create({ Type = "Spell", ID = 19750                                                                        }),
    -- Self Defensives
    ShieldofVengeance                        = Create({ Type = "Spell", ID = 184662                                                                        }),
    DivineShield                            = Create({ Type = "Spell", ID = 642                                                                            }),
    BlessingofProtection                    = Create({ Type = "Spell", ID = 1022                                                                        }),
    CleanseToxins                            = Create({ Type = "Spell", ID = 213644                                                                        }),
    WordofGlory                                = Create({ Type = "Spell", ID = 85673                                                                        }),
    -- Burst
    AvengingWrath                            = Create({ Type = "Spell", ID = 31884                                                                        }),
    -- Rotation
    CrusaderStrike                            = Create({ Type = "Spell", ID = 35395                                                                        }),
    DivineToll                                = Create({ Type = "Spell", ID =    304971                                                                        }),
    WakeofAshes                                = Create({ Type = "Spell", ID = 255937                                                                        }),
    HammerofWrath                            = Create({ Type = "Spell", ID = 24275                                                                        }),
    Consecration                            = Create({ Type = "Spell", ID = 205228                                                                        }),
    ExecutionSentence                        = Create({ Type = "Spell", ID = 343527, isTalent = true                                                        }), -- Talent 1/3
    FinalReckoning                            = Create({ Type = "Spell", ID = 343721, isTalent = true                                                        }), -- Talent 7/3
    Seraphim                                = Create({ Type = "Spell", ID = 152262, isTalent = true                                                        }), -- Talent 7/3
    Crusade                                    = Create({ Type = "Spell", ID = 231895, isTalent = true                                                        }), -- Talent 7/2
    HolyAvenger                                = Create({ Type = "Spell", ID = 105809, isTalent = true                                                        }), -- Talent 7/2
    -- Convenant
    VanquishersHammer                        = Create({ Type = "Spell", ID = 328204                                                                        }),    
    
    
    
    BladeofJustice                         = Create({ Type = "Spell", ID = 184575 }),
    Judgment                               = Create({ Type = "Spell", ID = 20271 }),
    ExecutionSentenceDebuff                = Create({ Type = "Spell", ID = 267799 }),
    DivineStorm                            = Create({ Type = "Spell", ID = 53385 }),
    TemplarsVerdict                        = Create({ Type = "Spell", ID = 85256 }),
    
    
    
    
    
    -- Movememnt    
    Charge                                    = Create({ Type = "Spell", ID = 100                                                                                }),
    Intervene                                = Create({ Type = "Spell", ID = 3411                                                                            }),
    HeroicLeap                                = Create({ Type = "Spell", ID = 6544                                                                            }),
    -- Items
    PotionofUnbridledFury                     = Create({ Type = "Potion",  ID = 169299                                                                         }), 
    GalecallersBoon                          = Create({ Type = "Trinket", ID = 159614                                                                         }),    
    LustrousGoldenPlumage                    = Create({ Type = "Trinket", ID = 159617                                                                         }),    
    PocketsizedComputationDevice             = Create({ Type = "Trinket", ID = 167555                                                                         }),    
    AshvanesRazorCoral                       = Create({ Type = "Trinket", ID = 169311                                                                         }),    
    AzsharasFontofPower                      = Create({ Type = "Trinket", ID = 169314                                                                         }),    
    RemoteGuidanceDevice                     = Create({ Type = "Trinket", ID = 169769                                                                         }),    
    WrithingSegmentofDrestagath              = Create({ Type = "Trinket", ID = 173946                                                                         }),    
    DribblingInkpod                          = Create({ Type = "Trinket", ID = 169319                                                                         }),
    CorruptedAspirantsMedallion                = Create({ Type = "Trinket", ID = 184058                                                                         }),
    -- Gladiator Badges/Medallions
    DreadGladiatorsMedallion                 = Create({ Type = "Trinket", ID = 161674                                                                         }),    
    DreadCombatantsInsignia                  = Create({ Type = "Trinket", ID = 161676                                                                         }),    
    DreadCombatantsMedallion                 = Create({ Type = "Trinket", ID = 161811, Hidden = true                                                         }),    -- Game has something incorrect with displaying this
    DreadGladiatorsBadge                     = Create({ Type = "Trinket", ID = 161902                                                                         }),    
    DreadAspirantsMedallion                  = Create({ Type = "Trinket", ID = 162897                                                                         }),    
    DreadAspirantsBadge                      = Create({ Type = "Trinket", ID = 162966                                                                         }),    
    SinisterGladiatorsMedallion              = Create({ Type = "Trinket", ID = 165055                                                                         }),    
    SinisterGladiatorsBadge                  = Create({ Type = "Trinket", ID = 165058                                                                         }),    
    SinisterAspirantsMedallion               = Create({ Type = "Trinket", ID = 165220                                                                         }),    
    SinisterAspirantsBadge                   = Create({ Type = "Trinket", ID = 165223                                                                         }),    
    NotoriousGladiatorsMedallion             = Create({ Type = "Trinket", ID = 167377                                                                         }),    
    NotoriousGladiatorsBadge                 = Create({ Type = "Trinket", ID = 167380                                                                         }),    
    NotoriousAspirantsMedallion              = Create({ Type = "Trinket", ID = 167525                                                                         }),    
    NotoriousAspirantsBadge                  = Create({ Type = "Trinket", ID = 167528                                                                         }),    
    -- LegendaryPowers
    CadenceofFujieda                        = Create({ Type = "Spell", ID = 335555, Hidden = true                                                             }),
    -- Hidden
    EmpyreanPowerBuff                        = Create({ Type = "Spell", ID = 326732, Hidden = true                                                             }), -- Simcraft
    EmpyreanPowerBuffAZ                        = Create({ Type = "Spell", ID = 286393, Hidden = true                                                             }), -- Simcraft
    JudgmentDebuff                            = Create({ Type = "Spell", ID = 197277, Hidden = true                                                             }), -- Simcraft
    DivinePurposeBuff                        = Create({ Type = "Spell", ID = 223819, Hidden = true                                                             }), -- Simcraft
    ForbearanceDebuff                        = Create({ Type = "Spell", ID = 25771, Hidden = true                                                             }), -- Simcraft
    SelflessHealer                        = Create({ Type = "Spell", ID = 114250, Hidden = true                                                             }),
    -- Hidden  PvP Debuffs
    TouchOfDeathDebuff                        = Create({ Type = "Spell", ID = 115080, Hidden = true                                                            }),
    KarmaDebuff                                = Create({ Type = "Spell", ID = 122470, Hidden = true                                                            }),
    VendettaDebuff                            = Create({ Type = "Spell", ID = 79140, Hidden = true                                                            }),
    SolarBeamDebuff                            = Create({ Type = "Spell", ID = 78675, Hidden = true                                                            }),
    IntimidatingShoutDebuff                    = Create({ Type = "Spell", ID = 5246, Hidden = true                                                                }),
    SmokeBombDebuff                            = Create({ Type = "Spell", ID = 76577, Hidden = true                                                            }),
    BlindDebuff                                = Create({ Type = "Spell", ID = 2094, Hidden = true                                                                }),
    GarroteDebuff                            = Create({ Type = "Spell", ID = 1330, Hidden = true                                                                }),
}

--Action:CreateCovenantsFor(ACTION_CONST_PALADIN_RETRIBUTION)
Action:CreateEssencesFor(ACTION_CONST_PALADIN_RETRIBUTION)
local A = setmetatable(Action[ACTION_CONST_PALADIN_RETRIBUTION], { __index = Action })

local player                                 = "player"
local target                                = "target" 
local Temp                                     = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                        = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                 = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMagPhys                            = {"TotalImun", "DamageMagicImun", "DamagePhysImun"},
    DisablePhys                                = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    IsSlotTrinketBlocked                    = {
        [A.AshvanesRazorCoral.ID]            = true,
        [A.CorruptedAspirantsMedallion.ID]    = true,
    },
    BoPDebuffsPvP                            = {A.TouchOfDeathDebuff.ID, A.KarmaDebuff.ID},
    -- Hex, Polly, Repentance, Blind, Wyvern Sting, Ring of Frost, Paralysis, Freezing Trap, Mind Control
    BoSDebuffsPvP                            = {51514, 118, 20066, 2094, 19386, 82691, 115078, 3355, 605}
}

function Action:IsSuspended(delay, reset)
    -- @return boolean
    -- Returns true if action should be delayed before use, reset argument is a internal refresh cycle of expiration future time
    if (self.expirationSuspend or 0) + reset <= TMW.time then
        self.expirationSuspend = TMW.time + delay
    end 
    
    return self.expirationSuspend > TMW.time
end

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "HOLY") == 0
end 

local function InMelee(unitID)
    -- @return boolean
    return A.CrusaderStrike:IsInRange(unitID)
end

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean
    local c = 0
    for unitID in pairs(ActiveUnitPlates) do
        if (not isCheckEqual or not UnitIsUnit(target, unitID)) and (not isCheckCombat or Unit(unitID):CombatTime() > 0) and not Unit(unitID):IsExplosives() and not Unit(unitID):IsTotem() then
            if InMelee(unitID) then
                c = c + 1
            elseif range then
                local r = Unit(unitID):GetRange()
                if r > 0 and r <= range then
                    c = c + 1
                end
            end
            
            if c >= count then
                return true
            end
        end
    end
end
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

local function countInterruptGCD(unitID)
    -- returns @boolean
    if not A.Rebuke:IsReadyByPassCastGCD(unitID) or not A.Rebuke:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
        return true 
    end 
end

local BurstPhase = {}
local btn_PrepareBurst = false
Action.PrepareBurst = function(self, ...)
    btn_PrepareBurst = not btn_PrepareBurst
    if not btn_PrepareBurst then 
        wipe(BurstPhase)
    end
    Print("Prepare  Burst: " .. toStr[btn_PrepareBurst])
end

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unitID) 
    return 
    IsUnitEnemy(unitID) and  
    Unit(unitID):GetRange() <= 20 and 
    Unit(unitID):IsControlAble("stun") and 
    A.HammerofJusticeGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    if     A.HammerofJusticeGreen:IsReady(nil, true, nil, true) and AntiFakeStun("target")
    then 
        return A.HammerofJusticeGreen:Show(icon)         
    end                                                                     
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unitID
    if IsUnitEnemy("mouseover") then 
        unitID = "mouseover"
    elseif IsUnitEnemy("target") then 
        unitID = "target"
    end 
    
    if unitID then         
        local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
        if castLeft > 0 then             
            if not notKickAble and A.RebukeGreen:IsReady(unitID, nil, nil, true) and A.RebukeGreen:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then
                return A.RebukeGreen:Show(icon)                                                  
            end 
            
            if A.HammerofJusticeGreen:IsReady(unitID, nil, nil, true) and Unit(unitID):IsControlAble("stun") and A.HammerofJusticeGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
                return A.HammerofJusticeGreen:Show(icon)                  
            end 
            
            -- Racials 
            if A.QuakingPalm:IsRacialReadyP(unitID, nil, nil, true) then 
                return A.QuakingPalm:Show(icon)
            end 
            
            if A.Haymaker:IsRacialReadyP(unitID, nil, nil, true) then 
                return A.Haymaker:Show(icon)
            end 
            
            if A.WarStomp:IsRacialReadyP(unitID, nil, nil, true) then 
                return A.WarStomp:Show(icon)
            end 
            
            if A.BullRush:IsRacialReadyP(unitID, nil, nil, true) then 
                return A.BullRush:Show(icon)
            end                         
        end 
    end                                                                                 
end


local function SelfDefensives()
    -- DivineShield
    local DivineShield = GetToggle(2, "DivineShield")
    if     DivineShield >= 0 and A.DivineShield:IsReady(player) and 
    (
        (     -- Auto 
            DivineShield >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 25 and 
                    Unit(player):TimeToDieX(5) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 20 and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or 
        (    -- Custom
            DivineShield < 100 and 
            Unit(player):HealthPercent() <= DivineShield
        )
    ) 
    then 
        return A.DivineShield
    end
    
    -- BlessingofProtection
    local BlessingofProtection = GetToggle(2, "BlessingofProtection")
    if BlessingofProtection >= 0 and A.BlessingofProtection:IsReady(player) and
    (
        (    -- Auto
            BlessingofProtection >=  100 and
            (
                (
                    not A.IsInPvP and
                    Unit(player):HealthPercent() < 30 and
                    Unit(player):TimeToDieX(20) < 3 and 
                    Unit(player):GetRealTimeDMG(3) > 0 and
                    Unit(player):HasBuffs("DeffBuffs") == 0
                ) or
                (
                    A.IsInPvP and                        
                    (
                        (    -- Defensive
                            Unit(player):HealthPercent() < 35 and
                            Unit(player):GetRealTimeDMG(3) > 0 and
                            Unit(player):IsFocused("MELEE", true) and
                            Unit(player):HasBuffs("DeffBuffs") == 0
                        ) or
                        (    -- Disarmed
                            Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 10 and
                            LoC:Get("DISARM") > 4.5
                        ) or
                        (    -- PvP Debuffs (Touch of Death, Karma, Vendetta
                            Unit(player):HasDeBuffs(Temp.BoPDebuffsPvP) > 4 or
                            Unit(player):HasDeBuffs(A.VendettaDebuff.ID) > 15
                        )
                    )
                )
            )
        ) or 
        (    -- Custom
            BlessingofProtection < 100 and 
            Unit(player):HealthPercent() <= BlessingofProtection
        )
    ) 
    then 
        return A.BlessingofProtection
    end
    
    -- ShieldofVengeance
    local ShieldofVengeance = GetToggle(2, "ShieldofVengeance")
    if ShieldofVengeance >= 0 and A.ShieldofVengeance:IsReady(player) and
    (
        (     -- Auto 
            ShieldofVengeance >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 40 and 
                    Unit(player):TimeToDieX(20) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 40 and
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or 
        (    -- Custom
            ShieldofVengeance < 100 and 
            Unit(player):HealthPercent() <= ShieldofVengeance
        )
    ) 
    then 
        return A.ShieldofVengeance
    end
    
    -- WordofGlory
    local WordofGlory = GetToggle(2, "WordofGlory")
    if WordofGlory >= 0 and A.WordofGlory:IsReady(player) and Unit(player):HasBuffsStacks(A.SelflessHealer.ID, true) < 4 and
    (
        WordofGlory >= 100 and
        (
            not A.IsInPvP and
            (
                (
                    IsInRaid() and 
                    Unit(player):HealthPercent() < 20
                ) or 
                (
                    A.InstanceInfo.KeyStone > 1 and 
                    Unit(player):HealthPercent() < 40
                ) or 
                (
                    not IsInRaid() and
                    A.InstanceInfo.KeyStone < 2 and
                    Unit(player):HealthPercent() < 75
                )
            ) or
            (
                A.IsInPvP and
                (
                    Unit(player):HasBuffs("DamageBuffs") > 0 and 
                    Unit(player):HealthPercent() < 40 or
                    Unit(player):HealthPercent() <  60
                )
            )
        ) or 
        (    -- Custom
            WordofGlory < 100 and 
            Unit(player):HealthPercent() <= WordofGlory
        )
    )
    then
        return A.WordofGlory
    end
	
    -- Selfless Healer
    local WordofGlory = GetToggle(2, "WordofGlory")
    if WordofGlory >= 0 and A.WordofGlory:IsReady(player) and Unit(player):HasBuffsStacks(A.SelflessHealer.ID, true) >= 4 and
    (
        WordofGlory >= 100 and
        (
            not A.IsInPvP and
            (
                (
                    IsInRaid() and 
                    Unit(player):HealthPercent() < 20
                ) or 
                (
                    A.InstanceInfo.KeyStone > 1 and 
                    Unit(player):HealthPercent() < 40
                ) or 
                (
                    not IsInRaid() and
                    A.InstanceInfo.KeyStone < 2 and
                    Unit(player):HealthPercent() < 75
                )
            ) or
            (
                A.IsInPvP and
                (
                    Unit(player):HasBuffs("DamageBuffs") > 0 and 
                    Unit(player):HealthPercent() < 40 or
                    Unit(player):HealthPercent() <  60
                )
            )
        ) or 
        (    -- Custom
            WordofGlory < 100 and 
            Unit(player):HealthPercent() <= WordofGlory
        )
    )
    then
        return A.FlashofLight
    end	
    
    -- Stoneform (On Deffensive)
    local Stoneform = GetToggle(2, "Stoneform")
    if     Stoneform >= 0 and A.Stoneform:IsRacialReadyP(player) and 
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
                            Unit(player):IsFocused()                                 
                        )
                    )
                )
            ) 
        ) or 
        (    -- Custom
            Stoneform < 100 and 
            Unit(player):HealthPercent() <= Stoneform
        )
    ) 
    then 
        return A.Stoneform
    end
    
    -- Stoneform (Self Dispel)
    if not A.IsInPvP and A.Stoneform:IsRacialReady(player, true) and AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end
end

-- What and how to interrupt
local function Interrupts(unitID)
    local useKick, useCC, useRacial, notInterruptable, castRemainsTime
    local isMythicPlus    = false
    if GetToggle(2, "ZakLLInterrupts") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        isMythicPlus = true
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID, "ZakLLInterrupts", true, countInterruptGCD(unitID))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime = InterruptIsValid(unitID,  nil, nil, countInterruptGCD(unitID))
    end
    
    -- Can waste interrupt action due delays caused by ping, interface input 
    if castRemainsTime < GetLatency() then 
        return 
    end 
    
    if useKick and not notInterruptable and A.Rebuke:IsReady(unitID) and A.Rebuke:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
        return A.Rebuke
    end         
    
    if useRacial and A.QuakingPalm:AutoRacial(unitID) then 
        return A.QuakingPalm
    end 
    
    if useRacial and A.Haymaker:AutoRacial(unitID) then 
        return A.Haymaker
    end 
    
    if useRacial and A.WarStomp:AutoRacial(unitID) then 
        return A.WarStomp
    end 
    
    if useRacial and A.BullRush:AutoRacial(unitID) then 
        return A.BullRush
    end      
    
    if useCC and A.HammerofJustice:IsReady(unitID) and (Unit(unitID):IsControlAble("stun") or isMythicPlus) and A.HammerofJustice:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun, true) then
        return A.HammerofJustice     
    end
end

-- Usage of trinkets
local function UseItems(unitID)
    if A.Trinket1:IsReady(unitID) and A.Trinket1:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket1.ID] and A.Trinket1:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket1
    end 
    
    if A.Trinket2:IsReady(unitID) and A.Trinket2:GetItemCategory() ~= "DEFF" and not Temp.IsSlotTrinketBlocked[A.Trinket2.ID] and A.Trinket2:AbsentImun(unitID, Temp.TotalAndMagPhys) then 
        return A.Trinket2
    end     
end

-- [3] Single Rotation
A[3] = function(icon)
    local EnemyRotation, FriendlyRotation
    local isMoving             = Player:IsMoving()                    -- @boolean 
    local inCombat             = Unit(player):CombatTime()            -- @number 
    local inAoE                = GetToggle(2, "AoE")                -- @boolean 
    local inMelee             = false                                -- @boolean 
    local isSchoolFree        = IsSchoolFree()
    
    
    -- Defensive
    if inCombat > 0 then 
        local SelfDefensive = SelfDefensives()
        if SelfDefensive then 
            return SelfDefensive:Show(icon)
        end
    end
    
    function EnemyRotation(unitID)    
        --Print('I am in enemy rotation')
        -- Variables        
        local isBurst            = BurstIsON(unitID)
        inMelee                 = A.CrusaderStrike:IsInRange(unitID)
        
        -- Check if target is explosive or totem for dont use AoE spells 
        if Unit(unitID):IsExplosives() or (A.Zone ~= "none" and Unit(unitID):IsTotem()) then
            inAoE = false
        end
        
        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then 
            return A.ArcaneTorrent:Show(icon)
        end             
        
        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then 
            return Interrupt:Show(icon)
        end
        
        -- Kill Totem
        -- Try to kill totem with Heroic Throw first if range limitations allow it
        -- When melee prioritize overpower over slam to kill it
        if Unit(unitID):IsTotem() then
            
            
        end
        
        -- [[ Finishers ]] 
        local function Finishers()
            local varDSCastable =
            (
                Unit(player):HasBuffs(A.EmpyreanPowerBuff.ID, true) > 0 or
                Unit(player):HasBuffs(A.EmpyreanPowerBuffAZ.ID, true) > 0
            ) and
            Unit(unitID):HasDeBuffs(A.JudgmentDebuff.ID, true) == 0 and
            Unit(player):HasBuffs(A.DivinePurposeBuff.ID, true) == 0 or
            (
                inAoE and
                GetByRange(2, 8)
            )
            
            if A.Seraphim:IsReady(unitID) and 
            (
                (
                    (    --(!talent.crusade.enabled&buff.avenging_wrath.up|cooldown.avenging_wrath.remains>25)
                        not A.Crusade:IsSpellLearned() and
                        Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or
                        A.AvengingWrath:GetCooldown() > 25 or
                        not isBurst
                    ) or
                    (    --(buff.crusade.up|cooldown.crusade.remains>25)
                        Unit(player):HasBuffs(A.Crusade.ID, true) > 0 or
                        A.Crusade:GetCooldown() > 25 or
                        not isBurst
                    )
                ) and
                (    --(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains<10)
                    not A.FinalReckoning:IsSpellLearned() or
                    A.FinalReckoning:GetCooldown() < 10 or
                    not isBurst
                ) and
                (    --(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains<10)
                    not A.ExecutionSentence:IsSpellLearned() or 
                    A.ExecutionSentence:GetCooldown() < 10 or
                    not isBurst
                )
            ) and A.Seraphim:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.Seraphim:Show(icon)
            end
            
            --vanquishers_hammer
            if A.VanquishersHammer:IsReady(unitID) and 
            (
                (    --(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10|debuff.final_reckoning.up)&
                    not A.FinalReckoning:IsSpellLearned() or
                    A.FinalReckoning:GetCooldown() > GetGCD() * 10 or
                    Unit(unitID):HasDeBuffs(A.FinalReckoning.ID, true) > 0 or
                    not isBurst
                ) and
                (    -- (!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10|debuff.execution_sentence.up)
                    not A.ExecutionSentence:IsSpellLearned() or
                    A.ExecutionSentence:GetCooldown() > GetGCD() * 10 or
                    Unit(unitID):HasDeBuffs(A.ExecutionSentence.ID, true) > 0 or
                    not isBurst
                ) or
                (    --spell_targets.divine_storm>=2
                    inAoE and
                    GetByRange(2, 8) or
                    not inAoE
                )
            ) and A.VanquishersHammer:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.VanquishersHammer:Show(icon)
            end
            
            --execution_sentence,if=spell_targets.divine_storm<=3&((!talent.crusade.enabled|buff.crusade.down&cooldown.crusade.remains>10)|&
            if A.ExecutionSentence:IsReady(unitID) and 
            (
                (
                    inAoE and 
                    not GetByRange(4, 8) or
                    not inAoE
                ) and
                (
                    (    --(!talent.crusade.enabled|buff.crusade.down&cooldown.crusade.remains>10)
                        not A.Crusade:IsSpellLearned() or
                        Unit(player):HasBuffs(A.Crusade.ID, true) == 0 and
                        A.Crusade:GetCooldown() > 10 or
                        not isBurst
                    ) or
                    -- buff.crusade.stack>=3|cooldown.avenging_wrath.remains>10|debuff.final_reckoning.up)
                    Unit(player):HasBuffsStacks(A.Crusade.ID, true) >= 3 or
                    A.AvengingWrath:GetCooldown() > 10 or
                    not isBurst or
                    Unit(unitID):HasDeBuffs(A.FinalReckoning.ID, true) > 0
                )
            ) and A.ExecutionSentence:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.ExecutionSentence:Show(icon)
            end
            
            --divine_storm,if=variable.ds_castable&!buff.vanquishers_hammer.up&
            if A.DivineStorm:IsReady(unitID, true) and InMelee(unitID) and varDSCastable and Unit(player):HasBuffs(A.VanquishersHammer.ID, true) == 0 and
            (
                (    --(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
                    not A.Crusade:IsSpellLearned() or
                    A.Crusade:GetCooldown() > GetGCD() * 3 or
                    not isBurst
                ) and
                (    --(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3|spell_targets.divine_storm>=3)
                    not A.ExecutionSentence:IsSpellLearned() or
                    A.ExecutionSentence:GetCooldown() > GetGCD() * 3 or
                    inAoE and
                    GetByRange(3, 8)
                ) or --spell_targets.divine_storm>=2
                inAoE and
                GetByRange(2, 8) and
                (    --(talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.crusade.up&buff.crusade.stack<10)
                    A.HolyAvenger:IsSpellLearned() and
                    A.HolyAvenger:GetCooldown() < GetGCD() * 3 or
                    Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and
                    Unit(player):HasBuffsStacks(A.Crusade.ID, true) < 10 or
                    not isBurst
                )
            ) and A.DivineStorm:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.DivineStorm:Show(icon)
            end
            
            --/templars_verdict
            if A.TemplarsVerdict:IsReady(unitID) and 
            (
                (    --(!talent.crusade.enabled|cooldown.crusade.remains>gcd*3)
                    not A.Crusade:IsSpellLearned() or
                    A.Crusade:GetCooldown() > GetGCD() * 3 or
                    not isBurst
                ) and
                (    --(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*3&spell_targets.divine_storm<=3)
                    not A.ExecutionSentence:IsSpellLearned() or
                    A.ExecutionSentence:GetCooldown() > GetGCD() * 3 or
                    inAoE and
                    not GetByRange(4, 8)
                ) and
                (    --(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*3)
                    not A.FinalReckoning:IsSpellLearned() or
                    A.FinalReckoning:GetCooldown() > GetGCD() * 3 or
                    not isBurst
                ) or
                --talent.holy_avenger.enabled&cooldown.holy_avenger.remains<gcd*3|buff.holy_avenger.up|buff.crusade.up&buff.crusade.stack<10|buff.vanquishers_hammer.up
                A.HolyAvenger:IsSpellLearned() and
                A.HolyAvenger:GetCooldown() < GetGCD() * 3 and
                isBurst or
                Unit(player):HasBuffs(A.HolyAvenger.ID, true) > 0 or 
                Unit(player):HasBuffs(A.Crusade.ID, true) > 0 and
                Unit(player):HasBuffsStacks(A.Crusade.ID, true) < 10
            ) and A.TemplarsVerdict:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.TemplarsVerdict:Show(icon)
            end
        end
        
        -- [[ Generators ]] 
        local function Generators() 
            --divine_toll,if=!debuff.judgment.up&
            if A.DivineToll:IsReady() and Unit(unitID):HasDeBuffs(A.JudgmentDebuff.ID, true) == 0 and 
            (
                (    --(holy_power<=2|holy_power<=4&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))
                    Player:HolyPower() <= 2 or
                    Player:HolyPower() <= 4 and
                    (
                        A.BladeofJustice:GetCooldown() > GetGCD() * 2 or 
                        Unit(unitID):HasDeBuffs(A.ExecutionSentence.ID, true) > 0 or 
                        Unit(unitID):HasDeBuffs(A.FinalReckoning.ID, true) > 0
                    )
                ) and
                (    --(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10)
                    not A.FinalReckoning:IsSpellLearned() or
                    A.FinalReckoning:GetCooldown() > GetGCD() * 10
                ) and
                (    --(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10)
                    not A.ExecutionSentence:IsSpellLearned() or
                    A.ExecutionSentence:GetCooldown() > GetGCD() * 10
                )
            ) and A.DivineToll:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.DivineToll:Show(icon)
            end
            
            --/wake_of_ashes
            if A.WakeofAshes:IsReady(unitID) and Unit(unitID):GetRange() <= 3 and
            (
                (    --(holy_power=0|holy_power<=2&(cooldown.blade_of_justice.remains>gcd*2|debuff.execution_sentence.up|debuff.final_reckoning.up))
                    Player:HolyPower() == 0 or
                    Player:HolyPower() <= 2 and
                    (
                        A.BladeofJustice:GetCooldown() > GetGCD() * 2 or 
                        Unit(unitID):HasDeBuffs(A.ExecutionSentence.ID, true) > 0 or 
                        Unit(unitID):HasDeBuffs(A.FinalReckoning.ID, true) > 0
                    )
                ) and
                (    --(!talent.final_reckoning.enabled|cooldown.final_reckoning.remains>gcd*10)
                    not A.FinalReckoning:IsSpellLearned() or
                    A.FinalReckoning:GetCooldown() > GetGCD() * 10
                ) and
                (    --(!talent.execution_sentence.enabled|cooldown.execution_sentence.remains>gcd*10)
                    not A.ExecutionSentence:IsSpellLearned() or
                    A.ExecutionSentence:GetCooldown() > GetGCD() * 10
                )
            ) and A.WakeofAshes:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.WakeofAshes:Show(icon)
            end
            
            --blade_of_justice,if=holy_power<=3
            if A.BladeofJustice:IsReady(unitID) and Player:HolyPower() <= 3 and A.BladeofJustice:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.BladeofJustice:Show(icon)
            end
            
            --hammer_of_wrath,if=holy_power<=4
            if A.HammerofWrath:IsReady(unitID) and Player:HolyPower() <= 4 and A.HammerofWrath:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.HammerofWrath:Show(icon)
            end
            
            --judgment,if=!debuff.judgment.up&
            if A.Judgment:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.JudgmentDebuff.ID, true) == 0 and
            (    --(holy_power<=2|holy_power<=4&cooldown.blade_of_justice.remains>gcd*2)
                Player:HolyPower() <= 2 or
                Player:HolyPower() <= 4 and
                A.BladeofJustice:GetCooldown() > GetGCD() * 2
            ) and A.Judgment:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.Judgment:Show(icon)
            end
            
            --crusader_strike,if=cooldown.crusader_strike.charges_fractional>=1.75&(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
            if A.CrusaderStrike:IsReady(unitID) and A.CrusaderStrike:GetSpellChargesFrac() >= 1.75 and
            (    --(holy_power<=2|holy_power<=3&cooldown.blade_of_justice.remains>gcd*2|holy_power=4&cooldown.blade_of_justice.remains>gcd*2&cooldown.judgment.remains>gcd*2)
                Player:HolyPower() <= 2 or
                Player:HolyPower() <= 3 and
                A.BladeofJustice:GetCooldown() > GetGCD() * 2 or
                Player:HolyPower() == 4 and
                A.BladeofJustice:GetCooldown() > GetGCD() * 2 and
                A.Judgment:GetCooldown() > GetGCD() * 2
            ) and A.CrusaderStrike:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.CrusaderStrike:Show(icon)
            end
            
            --finishers
            if Finishers() then
                return true
            end
            
            --/crusader_strike,if=holy_power<=4
            if A.CrusaderStrike:IsReady(unitID) and Player:HolyPower() <= 4 and A.CrusaderStrike:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.CrusaderStrike:Show(icon)
            end
            
            --consecration,if=time_to_hpg>gcd
            if A.Consecration:IsReady(unitID, true) and InMelee(unitID) and A.Consecration:AbsentImun(unitID, Temp.TotalAndPhys) then
                return A.Consecration:Show(icon)
            end
        end
        
        -- [[ CDs ]]
        local function CDs()            
            --lights_judgment
            if A.LightsJudgment:AutoRacial(unitID) then
                return A.LightsJudgment:Show(icon)
            end
            
            --avenging_wrath
            if A.AvengingWrath:IsReady(player) and 
            (    --(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)
                Player:HolyPower() >= 4 and 
                inCombat < 5 or
                Player:HolyPower() >= 3 and
                inCombat > 5 or
                A.HolyAvenger:IsSpellLearned() and
                A.HolyAvenger:GetCooldown() == 0
            ) then
                return A.AvengingWrath:Show(icon)
            end
            
            --crusade
            if A.Crusade:IsReady(player) and
            (    --(holy_power>=4&time<5|holy_power>=3&time>5|talent.holy_avenger.enabled&cooldown.holy_avenger.remains=0)
                Player:HolyPower() >= 4 and 
                inCombat < 5 or
                Player:HolyPower() >= 3 and
                inCombat > 5 or
                A.HolyAvenger:IsSpellLearned() and
                A.HolyAvenger:GetCooldown() == 0
            ) then
                return A.Crusade:Show(icon)
            end
            
            --holy_avenger,if=time_to_hpg=0&()
            if A.HolyAvenger:IsReady(player) and
            (
                (    --(buff.avenging_wrath.up|buff.crusade.up)
                    Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or
                    Unit(player):HasBuffs(A.Crusade.ID, true) > 0
                ) or
                ( --(buff.avenging_wrath.down&cooldown.avenging_wrath.remains>40|buff.crusade.down&cooldown.crusade.remains>40)
                    Unit(player):HasBuffs(A.AvengingWrath.ID, true) == 0 and
                    A.AvengingWrath:GetCooldown() > 40 or 
                    Unit(player):HasBuffs(A.Crusade.ID, true) == 0 and
                    A.Crusade:GetCooldown() > 40
                )
            ) then
                return A.HolyAvenger:Show(icon)
            end
            
            --final_reckoning,if=holy_power>=3&cooldown.avenging_wrath.remains>gcd&time_to_hpg=0&(!talent.seraphim.enabled|buff.seraphim.up)
            if A.FinalReckoning:IsReady(player) and InMelee(unitID) and
            (
                Player:HolyPower() >= 3 and
                A.AvengingWrath:GetCooldown() > GetGCD() and
                (
                    not A.Seraphim:IsSpellLearned() or
                    Unit(player):HasBuffs(A.Seraphim.ID, true) > 0
                )
            ) then
                return A.FinalReckoning:Show(icon)
            end
            
            local Item = UseItems(unitID)
            if Item and (Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.Crusade.ID, true) > 0) then
                return Item:Show(icon)
            end
        end
        
        -- CDs
        if isBurst and (not A.IsInPvP or UnitIsPlayer(unitID)) and CDs() then 
            return true 
        end
        
        --Finishers
        if 
        (--holy_power>=5|buff.holy_avenger.up|debuff.final_reckoning.up|debuff.execution_sentence.up|buff.memory_of_lucid_dreams.up|buff.seething_rage.up
            Player:HolyPower() >= 5 or
            Unit(player):HasBuffs(A.HolyAvenger.ID, true) > 0 or
            Unit(unitID):HasDeBuffs(A.FinalReckoning.ID, true) > 0 or
            Unit(unitID):HasDeBuffs(A.ExecutionSentence.ID, true) > 0
        ) and Finishers() then
            return true
        end
        
        --Generators
        if Generators() then
            return true
        end
        
        -- [[ Misc - Supportive ]]
        -- BlessingofFreedom
        if isSchoolFree and not inMelee and A.BlessingofFreedom:IsReady(player) then 
            if LoC:Get("ROOT") > 0 then 
                return A.BlessingofFreedom:Show(icon)
            end 
            
            local cUnitSpeed = Unit(player):GetCurrentSpeed()
            if cUnitSpeed > 0 and cUnitSpeed < 64 then 
                return A.BlessingofFreedom:Show(icon)
            end 
        end
        
        -- CleanseToxins
        if isSchoolFree and A.CleanseToxins:IsReady(player) and AuraIsValid(player, "UseDispel", "Dispel") then 
            return A.CleanseToxins:Show(icon)
        end
        
        -- GiftofNaaru
        if A.GiftofNaaru:AutoRacial(player) and Unit(player):TimeToDie() < 10 then 
            return A.GiftofNaaru:Show(icon)
        end
    end
    
    function FriendlyRotation(unitID)
        -- Purge
        if A.ArcaneTorrent:AutoRacial(unitID) then 
            return A.ArcaneTorrent:Show(icon)
        end
        
        -- Out of combat
        -- Redemption        
        if inCombat == 0 and not isMoving and isSchoolFree and A.Redemption:IsReady(unitID) and Unit(unitID):IsDead() and Unit(unitID):IsPlayer() then 
            return A.Redemption:Show(icon)
        end
        
        -- CleanseToxins
        if isSchoolFree and A.CleanseToxins:IsReady(unitID) and AuraIsValid(unitID, "UseDispel", "Dispel") and A.CleanseToxins:AbsentImun(unitID) then
            return A.CleanseToxins:Show(icon)
        end
        
        -- [[ Misc - Supportive ]]
        -- BlessingofFreedom
        if isSchoolFree and not inMelee and A.BlessingofFreedom:IsReady(unitID) then 
            if LoC:Get("ROOT") > 0 then 
                return A.BlessingofFreedom:Show(icon)
            end 
            
            local cUnitSpeed = Unit(unitID):GetCurrentSpeed()
            if cUnitSpeed > 0 and cUnitSpeed < 64 then 
                return A.BlessingofFreedom:Show(icon)
            end 
        end
        
        -- GiftofNaaru 
        if A.GiftofNaaru:AutoRacial(unitID) then 
            return A.GiftofNaaru:Show(icon)
        end
        
        -- WordofGlory
        if isSchoolFree and not isMoving and A.WordofGlory:IsReady(unitID) and Unit(unitID):HealthPercent() < 50 and (UnitIsUnit(unitID, player) or A.WordofGlory:AbsentImun(unitID)) then 
            return A.WordofGlory:Show(icon)
        end
        
        -- FlashofLight
        if isSchoolFree and not isMoving and A.FlashofLight:IsReady(unitID) and (UnitIsUnit(unitID, player) or (A.FlashofLight:PredictHeal(unitID) and A.FlashofLight:AbsentImun(unitID))) then 
            return A.FlashofLight:Show(icon)
        end
        
        -- FlashofLight
        -- Force cast 
        if A.IsInPvP and isSchoolFree and inCombat > 0 and not isMoving and A.FlashofLight:IsReady(unitID) and (UnitIsUnit(unitID, player) or A.FlashofLight:AbsentImun(unitID)) and Unit(unitID):GetRealTimeDMG() > 0 then 
            return A.FlashofLight:Show(icon)
        end
    end
    
    if IsUnitFriendly("mouseover") and FriendlyRotation("mouseover") then 
        return true             
    end
    
    -- Target
    if IsUnitEnemy(target) and EnemyRotation(target) then 
        return true 
    end
    if IsUnitFriendly(target) and FriendlyRotation(target) then 
        return true 
    end
end 

A[4] = nil
A[5] = nil 

-- Passive 
local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) > UnitCooldown:GetMaxDuration("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) - 2 and 
    UnitCooldown:IsSpellInFly("arena", ACTION_CONST_SPELLID_FREEZING_TRAP) and 
    Unit(player):GetDR("incapacitate") > 0 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", ACTION_CONST_SPELLID_FREEZING_TRAP)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 

local function ArenaRotation(icon, unitID)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then             
        -- Note: "arena1" is just identification of meta 6
        if unitID == "arena1" and (Unit(player):GetDMG() == 0 or not Unit(player):IsFocused("DAMAGER")) then                 
            -- PvP Pet Taunt        
            if A.Taunt:IsReady() and EnemyTeam():IsTauntPetAble(A.Taunt.ID) then 
                -- Freezing Trap 
                if FreezingTrapUsedByEnemy() then 
                    return A.Taunt:Show(icon)
                end 
                
                -- Casting BreakAble CC
                if EnemyTeam():IsCastingBreakAble(0.25) then 
                    return A.Taunt:Show(icon)
                end 
                
                -- Try avoid something totally random at opener (like sap / blind)
                if Unit(player):CombatTime() <= 5 and (Unit(player):CombatTime() > 0 or Unit("target"):CombatTime() > 0 or MultiUnits:GetByRangeInCombat(40, 1) >= 1) then 
                    return A.Taunt:Show(icon) 
                end 
                
                -- Roots if not available freedom 
                if LoC:Get("ROOT") > 0 then 
                    return A.Taunt:Show(icon) 
                end 
            end 
        end
        
        -- Interrupt - Rebuke (checkbox "useKick" for Interrupts tab in "PvP" and "Heal" categories)
        if A.Rebuke:CanInterruptPassive(unitID) then 
            return A.Rebuke:Show(icon) 
        end
        
        -- Interrupt - HammerofJustice (checkbox "useCC" for Interrupts tab in "PvP" and "Heal" categories)
        if A.HammerofJustice:CanInterruptPassive(unitID, countInterruptGCD(unitID)) then 
            return A.HammerofJustice:Show(icon) 
        end 
        
        -- AutoSwitcher
        if unitID == "arena1" and GetToggle(1, "AutoTarget") and IsUnitEnemy(target) and not A.AbsentImun(nil, target, Temp.TotalAndPhys) and MultiUnits:GetByRangeInCombat(12, 2) >= 2 then 
            return A:Show(icon, ACTION_CONST_AUTOTARGET)
        end
    end 
end 

local function PartyRotation(icon, unitID)
    local isSchoolFree = IsSchoolFree()
    
    -- Return 
    if not isSchoolFree or Player:IsStealthed() or Player:IsMounted() then 
        return 
    end 
    
    -- CleanseToxins
    if A.CleanseToxins:IsReadyByPassCastGCD(unitID) and AuraIsValid(unitID, "UseDispel", "Dispel") and not Unit(unitID):InLOS() and A.CleanseToxins:AbsentImun(unitID) then                         
        return A.CleanseToxins:Show(icon) 
    end
    
    -- BlessingofProtection
    if A.BlessingofProtection:IsReadyByPassCastGCD(unitID) and not Unit(unitID):InLOS() and
    (
        A.IsInPvP and
        ( 
            (    -- Deffensive
                Unit(unitID):HealthPercent() < 30 and
                Unit(unitID):GetRealTimeDMG(3) > 0 and
                (
                    FriendlyTeam("HEALER"):GetCC() >= 3 or
                    Unit(unitID):TimeToDieX(10) < 3
                ) and 
                Unit(unitID):HasBuffs("DeffBuffs") == 0
            ) or
            (    -- Healer Help
                Unit(unitID):Role("HEALER") and 
                (
                    -- Blind
                    Unit(unitID):HasDeBuffs(A.BlindDebuff.ID) >= 3.5 or
                    (
                        (
                            Unit(unitID):HasDeBuffs("Stuned") >= 4 or
                            -- Garrote
                            Unit(unitID):HasDeBuffs(A.GarroteDebuff) >= 2.5
                        ) and
                        (
                            A.BlessingofSanctuary:GetCooldown() > 0 or
                            not A.BlessingofSanctuary:IsSpellLearned()
                        )
                    )                    
                ) and
                Unit(unitID):HasBuffs("DeffBuffs") <= GetGCD() + GetCurrentGCD() + GetLatency() and
                Unit(unitID):IsFocused("MELEE", true)
            ) or
            (    -- DPS Help
                Unit(unitID):HasBuffs("DamageBuffs") > 4 and Unit(unitID):Role("DAMAGER") and
                (
                    Unit(unitID):Role("MELEE") and
                    Unit(unitID):HasDeBuffs("Disarmed") > 4.5
                ) or
                (    -- Blind
                    Unit(unitID):HasDeBuffs(A.BlindDebuff.ID) >= 3.5 or
                    --Intimidating Shout
                    Unit(unitID):HasDeBuffs(A.IntimidatingShoutDebuff.ID) >= 3.2 and
                    (
                        A.BlessingofSanctuary:GetCooldown() > 0 or
                        not A.BlessingofSanctuary:IsSpellLearned()
                    )
                )
            ) or
            (    -- PvP Debuffs (Touch of Death, Karma, Vendetta
                Unit(unitID):HasDeBuffs(Temp.BoPDebuffsPvP) > 4 or
                Unit(unitID):HasDeBuffs(A.VendettaDebuff.ID) > 15
            )
        )
    ) then
        return A.BlessingofProtection:Show(icon)
    end
    
    -- BlessingofSacrifice
    if A.BlessingofSacrifice:IsReadyByPassCastGCD(unitID) and not Unit(unitID):InLOS() and Unit(player):HealthPercent() > Unit(unitID):HealthPercent() * 1.5 and Unit(unitID):HasBuffs(A.BlessingofProtection.ID) == 0 and Unit(unitID):GetRealTimeDMG() > 0 and
    (
        Unit(unitID):HealthPercent() < 10 or
        Unit(unitID):TimeToDie() < 10 and
        (
            Unit(unitID):HealthPercent() < 30  and
            (
                Unit(unitID):GetDMG() * 100 / Unit(unitID):HealthMax() >= 35 or
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.20
            )
        )
    ) and Unit(unitID):HasBuffs("DeffBuffs") == 0 and A.BlessingofSacrifice:AbsentImun(unitID) then
        return A.BlessingofSacrifice:Show(icon) 
    end
    
    -- BlessingofSanctuary
    if A.BlessingofSanctuary:IsReadyByPassCastGCD(unitID) and not Unit(unitID):InLOS() and
    (
        (
            Unit(unitID):HasDeBuffs("Stuned") > 3.5 or
            Unit(unitID):HasDeBuffs("Fear") > 3.5  or
            (
                Unit(unitID):HasDeBuffs("Silenced") > 3.5 and
                Unit(unitID):HasDeBuffs(A.SolarBeamDebuff.ID) == 0
            )
        ) or 
        (
            Unit(unitID):HasDeBuffs(Temp.BoPDebuffsPvP) == 0 or
            A.BlessingofProtection:GetCooldown() > 0 or 
            Unit(unitID):HasDeBuffs(A.ForbearanceDebuff.ID) > 1 and 
            (
                (
                    Unit(unitID):HasDeBuffs(A.IntimidatingShoutDebuff.ID) > 3.5 and
                    not Unit(unitID):IsFocused()
                ) or
                Unit(unitID):HasDeBuffs("PhysStuned") > 3.5 and
                (
                    Unit(unitID):HasBuffs("DamageBuffs") > 3.5 or
                    (
                        Unit(unitID):HasDeBuffs(A.SmokeBombDebuff.ID) > 0 and
                        Unit(unitID):IsFocused("MELEE", true)
                    )
                )
            ) and Unit(unitID):HasDeBuffs(Temp.BoSDebuffsPvP) <= GetCurrentGCD()
        )
    ) and A.BlessingofSanctuary:AbsentImun(unitID) then
        return A.BlessingofSanctuary:Show(icon) 
    end
    
    -- BlessingofFreedom
    if A.BlessingofFreedom:IsReadyByPassCastGCD(unitID) and not Unit(player, 5):HasFlags() and (Unit(unitID):IsFocused(nil, true) or (Unit(unitID):IsMelee() and Unit(unitID):HasBuffs("DamageBuffs") > 0)) and not Unit(unitID):InLOS() and A.BlessingofFreedom:AbsentImun(unitID) then
        if Unit(unitID):HasDeBuffs("Rooted") > GetGCD() then 
            return A.BlessingofFreedom:Show(icon) 
        end 
        
        local cMoving = Unit(unitID):GetCurrentSpeed()
        if cMoving > 0 and cMoving < 64 then -- 64 because unitID can moving backward 
            return A.BlessingofFreedom:Show(icon) 
        end 
    end
end

A[6] = function(icon)    
    if PartyRotation(icon, UnitExists("raid1") and "raid1" or "party1") then
        return true 
    end
    
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    if PartyRotation(icon, UnitExists("raid2") and "raid2" or "party2") then
        return true 
    end
    
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    return ArenaRotation(icon, "arena3")
end

