--#########################################
--##### TRIP'S VENGEANCE DEMON HUNTER #####
--#########################################

local _G, setmetatable                          = _G, setmetatable
local A                                         = _G.Action
local Covenant                                  = _G.LibStub("Covenant")
local TMW                                       = _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON                              = Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local AuraIsValidByPhialofSerenity              = A.AuraIsValidByPhialofSerenity
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster                                   = _G.Toaster
local GetSpellTexture                           = _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DEMONHUNTER_VENGEANCE] = {
    -- Racial
    ArcaneTorrent                    = Action.Create({ Type = "Spell", ID = 50613    }),
    BloodFury                        = Action.Create({ Type = "Spell", ID = 20572    }),
    Fireblood                        = Action.Create({ Type = "Spell", ID = 265221    }),
    AncestralCall                    = Action.Create({ Type = "Spell", ID = 274738    }),
    Berserking                       = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                      = Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                      = Action.Create({ Type = "Spell", ID = 107079    }),
    Haymaker                         = Action.Create({ Type = "Spell", ID = 287712    }), 
    WarStomp                         = Action.Create({ Type = "Spell", ID = 20549    }),
    BullRush                         = Action.Create({ Type = "Spell", ID = 255654    }),  
    GiftofNaaru                      = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                       = Action.Create({ Type = "Spell", ID = 58984    }), -- Used for HoA
    Stoneform                        = Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                      = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                = Action.Create({ Type = "Spell", ID = 7744    }), -- not usable in APL but user can Queue it   
    EscapeArtist                     = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself               = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    
    -- Demon Hunter General
    ConsumeMagic                     = Action.Create({ Type = "Spell", ID = 278326    }),
    Disrupt                          = Action.Create({ Type = "Spell", ID = 183752    }),
    DisruptGreen                     = Action.Create({ Type = "SpellSingleColor", ID = 183752, Color = "GREEN", Desc = "[2] Kick", Hidden = true, QueueForbidden = true    }),    
    ImmolationAura                   = Action.Create({ Type = "Spell", ID = 258920    }),
    Imprison                         = Action.Create({ Type = "Spell", ID = 217832    }),
    Metamorphosis                    = Action.Create({ Type = "Spell", ID = 191427    }),
    MetamorphosisBuff                = Action.Create({ Type = "Spell", ID = 162264    }),
    SpectralSight                    = Action.Create({ Type = "Spell", ID = 188501    }),
    ThrowGlaive                      = Action.Create({ Type = "Spell", ID = 185123    }),
    Torment                          = Action.Create({ Type = "Spell", ID = 185245    }),
    ChaosBrand                       = Action.Create({ Type = "Spell", ID = 255260, Hidden = true    }),
    DemonicWards                     = Action.Create({ Type = "Spell", ID = 278386, Hidden = true    }),
    ShatteredSouls                   = Action.Create({ Type = "Spell", ID = 178940, Hidden = true    }),
    DemonSoul                        = Action.Create({ Type = "Spell", ID = 163073, Hidden = true    }),
    
    -- Vengeance Specific
    DemonSpikes                      = Action.Create({ Type = "Spell", ID = 344866    }),
    DemonSpikesBuff                  = Action.Create({ Type = "Spell", ID = 203819    }),
    FieryBrand                       = Action.Create({ Type = "Spell", ID = 344867    }),
    FieryBrandDebuff                 = Action.Create({ Type = "Spell", ID = 207771, Hidden = true    }),
    InfernalStrike                   = Action.Create({ Type = "Spell", ID = 189110    }),
    Shear                            = Action.Create({ Type = "Spell", ID = 344859    }),
    SigilofFlame                     = Action.Create({ Type = "Spell", ID = 204596    }),
    SigilofMisery                    = Action.Create({ Type = "Spell", ID = 207684    }),
    SigilofSilence                   = Action.Create({ Type = "Spell", ID = 202137    }),
    SoulCleave                       = Action.Create({ Type = "Spell", ID = 344862    }),
    FelDevastation                   = Action.Create({ Type = "Spell", ID = 212084    }),
    MasteryFelBlood                  = Action.Create({ Type = "Spell", ID = 203747, Hidden = true    }),
    RevelinPain                      = Action.Create({ Type = "Spell", ID = 343014, Hidden = true    }),    
    ThickSkin                        = Action.Create({ Type = "Spell", ID = 320380, Hidden = true    }),
    SoulFragments                    = Action.Create({ Type = "Spell", ID = 203981, Hidden = true    }),
    
    -- Normal Talents
    AbyssalStrike                    = Action.Create({ Type = "Spell", ID = 207550, Hidden = true    }),
    AgonizingFlames                  = Action.Create({ Type = "Spell", ID = 207548, Hidden = true    }),
    Felblade                         = Action.Create({ Type = "Spell", ID = 232893    }),    
    FeastofSouls                     = Action.Create({ Type = "Spell", ID = 207697, Hidden = true    }),    
    Fallout                          = Action.Create({ Type = "Spell", ID = 227174, Hidden = true    }),    
    BurningAlive                     = Action.Create({ Type = "Spell", ID = 207739, Hidden = true    }),    
    InfernalArmor                    = Action.Create({ Type = "Spell", ID = 320331, Hidden = true    }),    
    CharredFlesh                     = Action.Create({ Type = "Spell", ID = 336639, Hidden = true    }),    
    SpiritBomb                       = Action.Create({ Type = "Spell", ID = 247454    }),
    SpiritBombDebuff                 = Action.Create({ Type = "Spell", ID = 247456, Hidden = true    }),    
    SoulRending                      = Action.Create({ Type = "Spell", ID = 217996, Hidden = true    }),    
    FeedtheDemon                     = Action.Create({ Type = "Spell", ID = 218612, Hidden = true    }),
    Fracture                         = Action.Create({ Type = "Spell", ID = 263642    }),
    ConcentratedSigils               = Action.Create({ Type = "Spell", ID = 207666, Hidden = true    }),
    QuickenedSigils                  = Action.Create({ Type = "Spell", ID = 209281, Hidden = true    }),
    SigilofChains                    = Action.Create({ Type = "Spell", ID = 202138    }),
    VoidReaver                       = Action.Create({ Type = "Spell", ID = 268175, Hidden = true    }),    
    Demonic                          = Action.Create({ Type = "Spell", ID = 321453, Hidden = true    }),
    SoulBarrier                      = Action.Create({ Type = "Spell", ID = 263648    }),
    LastResort                       = Action.Create({ Type = "Spell", ID = 209258, Hidden = true    }),
    RuinousBulwark                   = Action.Create({ Type = "Spell", ID = 326853, Hidden = true    }),
    BulkExtraction                   = Action.Create({ Type = "Spell", ID = 320341    }),    
    
    -- PvP Talents
    CleansedByFlame                  = Action.Create({ Type = "Spell", ID = 205625, Hidden = true    }),
    EverlastingHunt                  = Action.Create({ Type = "Spell", ID = 205656, Hidden = true    }),
    JaggedSpikes                     = Action.Create({ Type = "Spell", ID = 205627, Hidden = true    }),
    IllidansGrasp                    = Action.Create({ Type = "Spell", ID = 205630    }),    
    SigilMastery                     = Action.Create({ Type = "Spell", ID = 211489, Hidden = true    }),
    Tormentor                        = Action.Create({ Type = "Spell", ID = 207029    }),    
    DemonicTrample                   = Action.Create({ Type = "Spell", ID = 205629    }),    
    ReverseMagic                     = Action.Create({ Type = "Spell", ID = 205604    }),    
    Detainment                       = Action.Create({ Type = "Spell", ID = 205596, Hidden = true    }),    
    
    -- Covenant Abilities
    ElysianDecree                    = Action.Create({ Type = "Spell", ID = 306830    }),
    SummonSteward                    = Action.Create({ Type = "Spell", ID = 324739    }),
    SinfulBrand                      = Action.Create({ Type = "Spell", ID = 317009    }),
    DoorofShadows                    = Action.Create({ Type = "Spell", ID = 300728    }),
    FoddertotheFlame                 = Action.Create({ Type = "Spell", ID = 329554    }),
    Fleshcraft                       = Action.Create({ Type = "Spell", ID = 331180    }),
    TheHunt                          = Action.Create({ Type = "Spell", ID = 323639    }),
    Soulshape                        = Action.Create({ Type = "Spell", ID = 310143    }),
    Flicker                          = Action.Create({ Type = "Spell", ID = 324701    }),
    
    -- Conduits
    SoulFurnace                      = Action.Create({ Type = "Spell", ID = 339423, Hidden = true    }),
    DemonMuzzle                      = Action.Create({ Type = "Spell", ID = 339587, Hidden = true    }),    
    RoaringFire                      = Action.Create({ Type = "Spell", ID = 339644, Hidden = true    }),        
    ExposedWound                     = Action.Create({ Type = "Spell", ID = 339229, Hidden = true    }),    
    RepeatDecree                     = Action.Create({ Type = "Spell", ID = 339895, Hidden = true    }),    
    IncreasedScrutiny                = Action.Create({ Type = "Spell", ID = 340028, Hidden = true    }),
    BroodingPool                     = Action.Create({ Type = "Spell", ID = 340063, Hidden = true    }),    
    UnnaturalMalice                  = Action.Create({ Type = "Spell", ID = 344358, Hidden = true    }),
    FelDefender                      = Action.Create({ Type = "Spell", ID = 338671, Hidden = true    }),    
    ShatteredRestoration             = Action.Create({ Type = "Spell", ID = 338793, Hidden = true    }),
    ViscousInk                       = Action.Create({ Type = "Spell", ID = 338682, Hidden = true    }),
    DemonicParole                    = Action.Create({ Type = "Spell", ID = 339048, Hidden = true    }),
    FelfireHaste                     = Action.Create({ Type = "Spell", ID = 338799, Hidden = true    }),
    LostinDarkness                   = Action.Create({ Type = "Spell", ID = 339149, Hidden = true    }),
    RavenousConsumption              = Action.Create({ Type = "Spell", ID = 338835, Hidden = true    }),    
    
    -- Legendaries
    -- General Legendaries
    CollectiveAnguish                = Action.Create({ Type = "Spell", ID = 337504, Hidden = true    }),
    DarkestHour                      = Action.Create({ Type = "Spell", ID = 337539, Hidden = true    }),    
    DarkglareBoon                    = Action.Create({ Type = "Spell", ID = 337534, Hidden = true    }),
    FelBombardment                   = Action.Create({ Type = "Spell", ID = 337775, Hidden = true    }),
    --Vengeance Legendaries
    FelFlameFortification            = Action.Create({ Type = "Spell", ID = 337545, Hidden = true    }),
    FierySoul                        = Action.Create({ Type = "Spell", ID = 337547, Hidden = true    }),
    RazelikhsDefilement              = Action.Create({ Type = "Spell", ID = 337544, Hidden = true    }),    
    SpiritoftheDarknessFlame         = Action.Create({ Type = "Spell", ID = 337541, Hidden = true    }),        
    
    --Anima Powers - to add later...
    
    -- Trinkets
    SlimyCosumptiveOrgan             = Action.Create({ Type = "Trinket", ID = 178770       }),
    SlimyStacks                       = Action.Create({ Type = "Spell", ID = 334511    }),
    DarkmoonDeckVoracity             = Action.Create({ Type = "Trinket", ID = 173087    }),
    DMVoracity6                      = Action.Create({ Type = "Spell", ID = 311489    }),
    DMVoracity7                      = Action.Create({ Type = "Spell", ID = 311488    }),
    DMVoracity8                      = Action.Create({ Type = "Spell", ID = 311490    }),
    
    -- Potions
    PotionofUnbridledFury            = Action.Create({ Type = "Potion", ID = 169299    }),     
    SuperiorPotionofUnbridledFury    = Action.Create({ Type = "Potion", ID = 168489    }),
    PotionofSpectralAgility          = Action.Create({ Type = "Potion", ID = 171270    }),
    PotionofSpectralStamina          = Action.Create({ Type = "Potion", ID = 171274    }),
    PotionofEmpoweredExorcisms       = Action.Create({ Type = "Potion", ID = 171352    }),
    PotionofHardenedShadows          = Action.Create({ Type = "Potion", ID = 171271    }),
    PotionofPhantomFire              = Action.Create({ Type = "Potion", ID = 171349    }),
    PotionofDeathlyFixation          = Action.Create({ Type = "Potion", ID = 171351    }),
    SpiritualHealingPotion           = Action.Create({ Type = "Item", ID = 171267       }),      
    PhialofSerenity                  = Action.Create({ Type = "Item", ID = 177278       }),
    
    -- Misc
    Channeling                       = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                      = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                         = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                     = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    Quake                            = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
}

-- To create essences use next code:
A:CreateEssencesFor(ACTION_CONST_DEMONHUNTER_VENGEANCE)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_DEMONHUNTER_VENGEANCE], { __index = Action })


local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"
local mouseover = "mouseover"
------------------------------------------
-------------- COMMON PREAPL -------------
------------------------------------------
local Temp = {
    TotalAndPhys                     = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                       = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                 = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun              = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun         = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                      = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                  = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                      = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                       = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
    AuraTaunt                        = {A.Torment.ID},
    InfernalStrikeDelay              = 0,
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

--Register Toaster
Toaster:Register("TripToast", function(toast, ...)
        local title, message, spellID = ...
        toast:SetTitle(title or "nil")
        toast:SetText(message or "nil")
        if spellID then 
            if type(spellID) ~= "number" then 
                error(tostring(spellID) .. " (spellID) is not a number for TripToast!")
                toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
            else 
                toast:SetIconTexture((GetSpellTexture(spellID)))
            end 
        else 
            toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
        end 
        toast:SetUrgencyLevel("normal") 
end)

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Disrupt:IsReadyByPassCastGCD(unit) or not A.Disrupt:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)
    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    local EnemiesCasting = MultiUnits:GetByRangeCasting(30, 5, true, "TargetMouseover")
    
    if castRemainsTime >= A.GetLatency() then    
        
        -- Sigil of Chains (Snare)
        if useCC and A.SigilofChains:IsReady(player) and A.SigilofChains:IsTalentLearned() and MultiUnits:GetByRange(10, 4) >= 3 and not Unit(unit):IsBoss() then
            return A.SigilofChains              
        end 
        
        -- Sigil of Misery (Disorient)
        if useCC and A.SigilofMisery:IsReady(player) and EnemiesCasting > 1 and A.SigilofMisery:AbsentImun(unit, Temp.TotalAndCC, true) and not Unit(unit):IsBoss() then 
            return A.SigilofMisery              
        end 
        
        -- Sigil of Silence (Silence)
        if useKick and (not A.Disrupt:IsReady(unit) or EnemiesCasting > 1) and A.SigilofSilence:IsReady(player) and A.SigilofSilence:AbsentImun(unit, Temp.TotalAndCC, true) and not Unit(unit):IsBoss() then 
            return A.SigilofSilence              
        end 
        
        -- Imprison
        if useCC and A.Imprison:IsReady(unit, nil, nil, true) and A.Imprison:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):IsControlAble("incapacitate", 0) then
            return A.Imprison                 
        end   
        
        -- Disrupt
        if useKick and A.Disrupt:IsReady(unit) and not notInterruptable and A.Disrupt:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
            return A.Disrupt
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

local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end  
    
    if not Player:IsStealthed() then     
        -- Healthstone | AbyssalHealingPotion
        local Healthstone = GetToggle(1, "HealthStone") 
        if Healthstone >= 0 then 
            if A.HS:IsReady(player) then                     
                if Healthstone >= 100 then -- AUTO 
                    if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then
                        A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)                        
                        return A.HS
                    end 
                elseif Unit(player):HealthPercent() <= Healthstone then 
                    A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)                
                    return A.HS                             
                end
            elseif A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.SpiritualHealingPotion:IsReady(player) then 
                if Healthstone >= 100 then -- AUTO 
                    if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 and Unit(player):HealthDeficit() >= A.SpiritualHealingPotion:GetItemDescription()[1] then
                        A.Toaster:SpawnByTimer("TripToast", 0, "Health Potion!", "Using Health Potion!", A.SpiritualHealingPotion.ID)                    
                        return A.AbyssalHealingPotion
                    end 
                elseif Unit(player):HealthPercent() <= Healthstone then
                    A.Toaster:SpawnByTimer("TripToast", 0, "Health Potion!", "Using Health Potion!", A.SpiritualHealingPotion.ID)                
                    return A.AbyssalHealingPotion                         
                end                
            end 
        end
        
        -- PhialofSerenity
        if A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.PhialofSerenity:IsReady(player) then 
            -- Healing 
            local PhialofSerenityHP, PhialofSerenityOperator, PhialofSerenityTTD = GetToggle(2, "PhialofSerenityHP"), GetToggle(2, "PhialofSerenityOperator"), GetToggle(2, "PhialofSerenityTTD")
            if PhialofSerenityOperator == "AND" then 
                if (PhialofSerenityHP <= 0 or Unit(player):HealthPercent() <= PhialofSerenityHP) and (PhialofSerenityTTD <= 0 or Unit(player):TimeToDie() <= PhialofSerenityTTD) then 
                    return A.PhialofSerenity
                end 
            else
                if (PhialofSerenityHP > 0 and Unit(player):HealthPercent() <= PhialofSerenityHP) or (PhialofSerenityTTD > 0 and Unit(player):TimeToDie() <= PhialofSerenityTTD) then 
                    return A.PhialofSerenity
                end 
            end 
            
            -- Dispel 
            if AuraIsValidByPhialofSerenity() then 
                return A.PhialofSerenity    
            end 
        end 
    end
    
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
    
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
    local SoulFragments = Unit("player"):HasBuffsStacks(A.SoulFragments.ID, true)
    local PotionTrue = Action.GetToggle(1, "Potion")
    local MetaHP = Action.GetToggle(2, "MetamorphosisHP")
    local FelDevDMG = Action.GetToggle(2, "FelDevastationDMG")
    local FelDevHP = Action.GetToggle(2, "FelDevHP")
    local Raz = Action.GetToggle(2, "Raz")
    local DemonSpikes1HP = Action.GetToggle(2, "DemonSpikes1HP")
    local DemonSpikes2HP = Action.GetToggle(2, "DemonSpikes2HP")    
    local Trinket1IsAllowed = Action.GetToggle(1, "Trinkets")[1]
    local Trinket2IsAllowed = Action.GetToggle(1, "Trinkets")[2]
    local MissingSpiritBomb = Unit("target"):HasDeBuffs(A.SpiritBombDebuff.ID, true) < 3
    
    if Temp.InfernalStrikeDelay == 0 and Unit(player):IsCasting() == A.InfernalStrike:Info()  then
        Temp.InfernalStrikeDelay = 90
    end
    
    if Temp.InfernalStrikeDelay > 0 then
        Temp.InfernalStrikeDelay = Temp.InfernalStrikeDelay - 1
    end
    
    
    local function EnemyRotation(unit)    
        
        local function PullSomething()
            
            if A.ThrowGlaive:IsReady(unit) then
                return A.ThrowGlaive:Show(icon)
            end    
            
        end
        
        local function CovenantCall()
            
            --actions.cooldown+=/sinful_brand,if=!dot.sinful_brand.ticking
            if A.SinfulBrand:IsReady(unit) and Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0 and not Player:PrevGCD(1, A.Metamorphosis) then
                return A.SinfulBrand:Show(icon)
            end    
            
            --actions.cooldown+=/the_hunt
            if A.TheHunt:IsReady(unit) then
                return A.TheHunt:Show(icon)
            end    
            
            --Fleshcraft
            if A.Fleshcraft:IsReady(player) and Player:IsStayingTime() > 0.5 and Unit("player"):CombatTime() > 0 and (Unit("player"):IsExecuted() or (Unit("player"):HealthPercent() <= 40 and Unit("player"):TimeToDie() < 8)) then 
                A.Toaster:SpawnByTimer("TripToast", 0, "Fleshcraft!", "Using Fleshcraft defensively! Don't move!", A.Fleshcraft.ID)            
                return self.Fleshcraft:Show(icon)
            end 
            
            --actions.cooldown+=/fodder_to_the_flame
            if A.FoddertotheFlame:IsReady(unit) then
                A.Toaster:SpawnByTimer("TripToast", 0, "Fodder to the Flame!", "You've spawned a demon! Kill it!", A.FoddertotheFlame.ID)            
                return A.FoddertotheFlame:Show(icon)
            end    
            
            --actions.cooldown+=/elysian_decree
            if A.ElysianDecree:IsReady(player) and Player:IsStayingTime() > 0.2 and MultiUnits:GetByRange(5, 2) >= 2 and Unit(unit):TimeToDie() >= 5 then
                return A.ElysianDecree:Show(icon)
            end    
            
            --actions.cooldown+=/elysian_decree
            if A.ElysianDecree:IsReady(player) and Player:IsStayingTime() > 0.2 and Unit(unit):GetRange() <= 5 and Unit(unit):IsBoss() then
                return A.ElysianDecree:Show(icon)
            end        
            
            --actions.cooldown+=/elysian_decree
            if A.ElysianDecree:IsReady(player) and Player:IsStayingTime() > 0.2 and Unit(unit):GetRange() <= 5 and Raz then
                return A.ElysianDecree:Show(icon)
            end                
            
        end
        
        
        --Damage Rotation
        local function DamageRotation()
            
            if A.Felblade:IsReady(unit) and A.Felblade:IsTalentLearned() and Player:FuryDeficit() >= 40 then
                return A.Felblade:Show(icon)
            end    
            
            --Immolation Aura if souls not capped
            if A.ImmolationAura:IsReady(unit) and ((SoulFragments <= 4 and A.Fallout:IsTalentLearned()) or not A.Fallout:IsTalentLearned()) and Player:Fury() <= 80 then
                return A.ImmolationAura:Show(icon)
            end
            
            --Infernal Strike if about to cap charges, range check for casting @player
            if A.InfernalStrike:IsReady("player") and Temp.InfernalStrikeDelay == 0 and A.InfernalStrike:GetSpellCharges() > 1 and Unit("target"):GetRange() <= 6 and not Unit(player):InVehicle() then 
                return A.InfernalStrike:Show(icon)
            end
            
            --Fiery Brand on cooldown
            if A.FieryBrand:IsReady(unit) and Unit(unit):TimeToDie() >= 8 then 
                return A.FieryBrand:Show(icon)
            end    
            
            --Fracture if need fury/souls
            if A.Fracture:IsReady(unit) and (SoulFragments <= 4 or Player:Fury() < 30) then
                return A.Fracture:Show(icon)
            end    
            
            --Spirit Bomb if four or more souls
            if A.SpiritBomb:IsReady(unit) and A.SpiritBomb:IsTalentLearned() and SoulFragments >= 4 then
                return A.SpiritBomb:Show(icon)
            end
            
            --Sigil of Flame (try not to overlap with Sigil from Abyssal Strike talent)
            if A.SigilofFlame:IsReady("player") and not (A.AbyssalStrike:IsSpellLearned() and A.InfernalStrike:GetSpellTimeSinceLastCast() < 4) and not Unit(player):InVehicle() and not Raz and Unit("target"):GetRange() <= 10 then
                return A.SigilofFlame:Show(icon)
            end        
            
            --Fel Devastation on cooldown
            if A.FelDevastation:IsReady("player") and Unit("target"):GetRange() <= 15 and FelDevDMG then
                return A.FelDevastation:Show(icon)
            end
            
            --Soul Cleave Spirit Bomb Build
            if A.SoulCleave:IsReady(unit) and Player:Fury() >= 30 and (SoulFragments == 0 and A.SpiritBomb:IsTalentLearned()) then
                return A.SoulCleave:Show(icon)
            end
            
            --Soul Cleave Fiery Brand and other Builds
            if A.SoulCleave:IsReady(unit) and Player:Fury() >= 30 and (SoulFragments >= 1 and not A.SpiritBomb:IsTalentLearned()) then
                return A.SoulCleave:Show(icon)
            end
            
            --Shear
            if A.Shear:IsReady(unit) and not A.Fracture:IsTalentLearned() then
                return A.Shear:Show(icon)
            end
            
            --Throw Glaive
            if A.ThrowGlaive:IsReady(unit) then
                return A.ThrowGlaive:Show(icon)
            end    
            
        end 
        
        local function DefenseRotation()
            
            if A.Metamorphosis:IsReady(unit) and Unit("player"):HasBuffs(A.Metamorphosis.ID, true) == 0 and Unit(player):HealthPercent() <= MetaHP then
                return A.Metamorphosis:Show(icon)
            end    
            
            if A.DemonSpikes:IsReady("player") and Unit("player"):HasBuffs(A.DemonSpikesBuff.ID, true) == 0 and A.DemonSpikes:GetSpellCharges() > 1.9 and Unit("player"):HasBuffs(A.Metamorphosis.ID, true) == 0 and (A.LastPlayerCastID ~= A.DemonSpikes.ID) and Unit(player):HealthPercent() <= DemonSpikes1HP then
                return A.DemonSpikes:Show(icon)
            end
            
            if A.DemonSpikes:IsReady("player") and Unit("player"):HasBuffs(A.DemonSpikesBuff.ID, true) == 0 and A.DemonSpikes:GetSpellCharges() >= 1 and Unit("player"):HasBuffs(A.Metamorphosis.ID, true) == 0 and (A.LastPlayerCastID ~= A.DemonSpikes.ID) and Unit(player):HealthPercent() <= DemonSpikes2HP then
                return A.DemonSpikes:Show(icon)
            end            
            
            if A.SoulBarrier:IsReady(unit) and ((A.SpiritBomb:IsTalentLearned() and SoulFragments < 3) or (not A.SpiritBomb:IsTalentLearned() and SoulFragments >= 5)) then
                return A.SoulBarrier:Show(icon)
            end
            
            --Fel Devastation on cooldown
            if A.FelDevastation:IsReady("player") and Unit("player"):HasBuffs(A.Metamorphosis.ID, true) and Unit("target"):GetRange() <= 15 and Unit(player):HealthPercent() <= FelDevHP then
                return A.FelDevastation:Show(icon)
            end            
            
            if A.PotionofHardenedShadows:IsReady(unit) and AutoPotionSelect == "HardenedShadowsPot" and PotionTrue and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0 and
            (
                IsInDanger 
                or                 
                -- HP lose per sec >= 40
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 40 
                or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.40 
                or 
                -- TTD 
                Unit("player"):TimeToDieX(15) < 3 
            )              
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Ouch!", "Using Defensive Potion!", A.PotionofHardenedShadows.ID)  
                return A.PotionofHardenedShadows:Show(icon)
            end    
            
        end
        
        
        local function Utilities()
            
            -- Interrupt
            local Interrupt = Interrupts(unit)
            if Interrupt then 
                return Interrupt:Show(icon)
            end
            
            -- Purge
            -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
            -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
            if A.ConsumeMagic:IsReady(unit) and Action.AuraIsValid(unit, "Dispel", "UseDispel") then
                return A.ConsumeMagic:Show(icon)
            end  
            
            if inCombat and A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UseDispel", "MagicMovement") then
                return A.ConsumeMagic:Show(icon)
            end
            if inCombat and A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UseDispel", "PurgeHigh") then
                return A.ConsumeMagic:Show(icon)
            end
            if inCombat and A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UseDispel", "PurgeLow") then
                return A.ConsumeMagic:Show(icon)
            end
            
            -- Auto Taunt (without target switching)
            if A.Torment:IsReady(unit, true, nil, nil, nil) and not Unit(unit):IsBoss() and not Unit(unit):IsDummy() and Unit(unit):GetRange() <= 30 and ( Unit("targettarget"):InfoGUID() ~= Unit("player"):InfoGUID() and Unit("targettarget"):InfoGUID() ~= nil ) then 
                return A.Torment:Show(icon)
            end 
            
            -- Trinkets
            local slot1 = "Trinket0Slot"
            local slot2 = "Trinket1Slot"
            local slot1ID = GetInventorySlotInfo(slot1)
            local slot2ID = GetInventorySlotInfo(slot2)
            local trinket1ID = GetInventoryItemID("Player", slot1ID)
            local trinket2ID = GetInventoryItemID("Player", slot2ID)
            local GoodVoracity = Unit("player"):HasBuffs(A.DMVoracity8.ID, true) > 0 or Unit("player"):HasBuffs(A.DMVoracity7.ID, true) > 0 or Unit("player"):HasBuffs(A.DMVoracity6.ID, true) > 0 
            local Gluttonous = Unit("Player"):HasBuffsStacks(A.SlimyStacks.ID, true) >= 1
            
            -- Trinket1
            -- check Trinket1 Ready and Allowed ready
            if A.Trinket1:IsReady(unitID) and Trinket1IsAllowed then
                --check Trinket 1 DarkmoonDeckVoracity
                if trinket1ID == 173087 then
                    if GoodVoracity then
                        return A.Trinket1:Show(icon)
                    end
                    --check Trinket 1 SlimyCosumptiveOrgan 
                elseif trinket1ID == 178770 then
                    if Gluttonous and Unit(player):HealthPercent() <= 80 then
                        return A.Trinket1:Show(icon)
                    end
                    --if nothing show Trinket 1
                else    
                    return A.Trinket1:Show(icon)
                end
            end
            
            -- Trinket2
            -- check Trinket2 Ready and Allowed ready
            if A.Trinket2:IsReady(unitID) and Trinket2IsAllowed then
                --check Trinket 2 DarkmoonDeckVoracity
                if trinket2ID == 173087 then
                    if GoodVoracity then
                        return A.Trinket2:Show(icon)
                    end
                    --check Trinket 2 SlimyCosumptiveOrgan 
                elseif trinket2ID == 178770 then
                    if Gluttonous and Unit(player):HealthPercent() <= 80 then
                        return A.Trinket2:Show(icon)
                    end
                    --if nothing show Trinket 2
                else    
                    return A.Trinket2:Show(icon)
                end
            end   
        end 
		
        if DefenseRotation(unit) and inCombat then
            return true
        end
        
        if Utilities(unit) and inCombat then
            return true
        end
        
        if CovenantCall(unit) and inCombat and A.GetToggle(1, "Covenant") and Unit("target"):TimeToDie() > 8 then
            return true
        end    
        
        if DamageRotation(unit) and inCombat then
            return true
        end        
        
        if PullSomething(unit) then
            return true
        end
        
    end 
    
    -- End on EnemyRotation()
    
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unit = "mouseover"
        if EnemyRotation(unit) then 
            return true 
        end 
    end 
    
    -- Target  
    if A.IsUnitEnemy("target") then 
        unit = "target"
        if EnemyRotation(unit) then 
            return true
        end 
        
    end
end
-- Finished

