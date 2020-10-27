-------------------------------
-- Taste TMW Action Rotation --
-------------------------------
local _G, setmetatable                            = _G, setmetatable
local A                                         = _G.Action
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
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local TR                                        = Action.TasteRotation
local pairs                                     = pairs
local Pet                                       = LibStub("PetLibrary")

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_PRIEST_SHADOW] = {
    -- Racial
    ArcaneTorrent                          = Action.Create({ Type = "Spell", ID = 50613 }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572 }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221 }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738 }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297 }),
    ArcanePulse                            = Action.Create({ Type = "Spell", ID = 260364 }),
    QuakingPalm                            = Action.Create({ Type = "Spell", ID = 107079 }),
    Haymaker                               = Action.Create({ Type = "Spell", ID = 287712 }), 
    WarStomp                               = Action.Create({ Type = "Spell", ID = 20549 }),
    BullRush                               = Action.Create({ Type = "Spell", ID = 255654 }),    
    GiftofNaaru                            = Action.Create({ Type = "Spell", ID = 59544 }),
    Shadowmeld                             = Action.Create({ Type = "Spell", ID = 58984 }), -- usable in Action Core 
    Stoneform                              = Action.Create({ Type = "Spell", ID = 20594 }), 
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744  }), -- not usable in APL but user can Queue it    
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589 }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752 }), -- not usable in APL but user can Queue it
    Darkflight                             = Create({ Type = "Spell", ID = 68992    }),
    -- Generics
    Shadowfiend                            = Action.Create({ Type = "Spell", ID = 34433 }),
    Mindbender                             = Action.Create({ Type = "Spell", ID = 200174 }),
    SurrenderToMadness                     = Action.Create({ Type = "Spell", ID = 193223 }),
    VampiricTouch                          = Action.Create({ Type = "Spell", ID = 34914 }),
    ShadowWordPain                         = Action.Create({ Type = "Spell", ID = 589 }),
    MindBlast                              = Action.Create({ Type = "Spell", ID = 8092 }),
    ShadowWordVoid                         = Action.Create({ Type = "Spell", ID = 205351 }),
    MindFlay                               = Action.Create({ Type = "Spell", ID = 15407 }),
    MindSear                               = Action.Create({ Type = "Spell", ID = 48045 }),
    VoidEruption                           = Action.Create({ Type = "Spell", ID = 228260 }),
    VoidBolt                               = Action.Create({ Type = "Spell", ID = 205448 }),
    DarkVoid                               = Action.Create({ Type = "Spell", ID = 263346 }),
    ShadowCrash                            = Action.Create({ Type = "Spell", ID = 205385 }),
    ShadowWordDeath                        = Action.Create({ Type = "Spell", ID = 32379 }),
    VoidTorrent                            = Action.Create({ Type = "Spell", ID = 263165 }),
    Misery                                 = Action.Create({ Type = "Spell", ID = 238558 }),
    Shadowform                             = Action.Create({ Type = "Spell", ID = 232698 }),
    ChorusofInsanity                       = Action.Create({ Type = "Spell", ID = 278661 }),
    LegacyOfTheVoid                        = Action.Create({ Type = "Spell", ID = 193225, Hidden = true }),
    ShadowformBuff                         = Action.Create({ Type = "Spell", ID = 232698, Hidden = true }),
    VoidformBuff                           = Action.Create({ Type = "Spell", ID = 194249, Hidden = true }),
    HarvestedThoughtsBuff                  = Action.Create({ Type = "Spell", ID = 288343, Hidden = true }),    
    VampiricTouchDebuff                    = Action.Create({ Type = "Spell", ID = 34914, Hidden = true }),
    ShadowWordPainDebuff                   = Action.Create({ Type = "Spell", ID = 589, Hidden = true }),
    WeakenedSoulDebuff                     = Action.Create({ Type = "Spell", ID = 6788, Hidden = true }),
    SearingDialogue                        = Action.Create({ Type = "Spell", ID = 272788, Hidden = true }),
    ThoughtHarvester                       = Action.Create({ Type = "Spell", ID = 288340, Hidden = true }),
    WhispersoftheDamned                    = Action.Create({ Type = "Spell", ID = 275722, Hidden = true }),
    DeathThroes                            = Action.Create({ Type = "Spell", ID = 278659, Hidden = true }),
    SpitefulApparitions                    = Action.Create({ Type = "Spell", ID = 277682, Hidden = true }),
    Damnation                              = Action.Create({ Type = "Spell", ID = 341374}),
    UnfurlingDarknessBuff                  = Action.Create({ Type = "Spell", ID = 341282}),
    SearingNightmare                       = Action.Create({ Type = "Spell", ID = 341385}),
    PsychicLink                            = Action.Create({ Type = "Spell", ID = 199484}),
    PowerInfusion                          = Action.Create({ Type = "Spell", ID = 10060}),
    DevouringPlague                        = Action.Create({ Type = "Spell", ID = 335467}),
	DarkThought							   = Action.Create({ Type = "Spell", ID = 341207, Hidden = true }),
--    DevouringPlagueDebuff                  = Action.Create({ Type = "Spell", ID = 335467, Hidden = true}),
    -- PvP   
    Silence                                = Action.Create({ Type = "Spell", ID = 15487 }),    
    PsychicScream                          = Action.Create({ Type = "Spell", ID = 8122   }), -- Fear
    PsychicHorror                          = Action.Create({ Type = "Spell", ID = 64044 }), -- Fear + Disarm
    -- Covenant Abilities
    AscendedBlast                          = Action.Create({ Type = "Spell", ID = 325283}), 
    AscendedNova                           = Action.Create({ Type = "Spell", ID = 325020}), 
    BoonoftheAscended                      = Action.Create({ Type = "Spell", ID = 325013}), 
    --    BoonoftheAscendedBuff                  = Action.Create({ Type = "Spell", ID = 325013}), 
    FaeGuardians                           = Action.Create({ Type = "Spell", ID = 327661}), 
    Mindgames                              = Action.Create({ Type = "Spell", ID = 323673}), 
    UnholyNova                             = Action.Create({ Type = "Spell", ID = 324724}), 
    -- Conduit Effects
    DissonantEchoesBuff                    = Action.Create({ Type = "Spell", ID = 343144}), 
    -- Utilities 
    PowerWordFortitude                     = Action.Create({ Type = "Spell", ID = 21562 }),    -- Shield
    DispelMagic                            = Action.Create({ Type = "Spell", ID = 528,   }),    
    -- Defensives
    PowerWordShield                        = Action.Create({ Type = "Spell", ID = 17    }), 
    VampiricEmbrace                        = Action.Create({ Type = "Spell", ID = 15286 }),
    Dispersion                             = Action.Create({ Type = "Spell", ID = 47585 }),    
    -- Oils
    EmbalmersOil                           = Action.Create({ Type = "Spell", ID = 171286, QueueForbidden = true }), 
    ShadowcoreOil                          = Action.Create({ Type = "Spell", ID = 171285, QueueForbidden = true }),  
    -- Potions
    -- stats
    PotionofSpectralAgility                = Action.Create({ Type = "Potion", ID = 171270, QueueForbidden = true }), 
    PotionofSpectralIntellect              = Action.Create({ Type = "Potion", ID = 171273, QueueForbidden = true }), 
    PotionofSpectralStrength               = Action.Create({ Type = "Potion", ID = 171275, QueueForbidden = true }), 
    PotionofSpectralStamina                = Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }), 
    -- heal
    SpiritualHealingPotion                 = Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }), 
    SpiritualManaPotion                    = Action.Create({ Type = "Potion", ID = 171268, QueueForbidden = true }), 
    SpiritualRejuvenationPotion            = Action.Create({ Type = "Potion", ID = 171269, QueueForbidden = true }), 
    PotionofSpiritualClarity               = Action.Create({ Type = "Potion", ID = 171272, QueueForbidden = true }), 
    -- combat effects potions
    PotionofDeathlyFixation                = Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }), 
    PotionofEmpoweredExorcisms             = Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofPhantomFire                    = Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDivineAwakening                = Action.Create({ Type = "Potion", ID = 171350, QueueForbidden = true }),
    PotionofSacrificialAnima               = Action.Create({ Type = "Potion", ID = 176811, QueueForbidden = true }),
    -- utilities potions
    PotionofHardenedShadows                = Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofShadedSight                    = Action.Create({ Type = "Potion", ID = 171264, QueueForbidden = true }),
    PotionofSoulPurity                     = Action.Create({ Type = "Potion", ID = 171263, QueueForbidden = true }),
    PotionofSpecterSwiftness               = Action.Create({ Type = "Potion", ID = 171370, QueueForbidden = true }),
    PotionoftheHiddenSpirit                = Action.Create({ Type = "Potion", ID = 171266, QueueForbidden = true }),
    PotionofthePsychopompsSpeed            = Action.Create({ Type = "Potion", ID = 184090, QueueForbidden = true }),
    PotionofUnhinderedPassing              = Action.Create({ Type = "Potion", ID = 183823, QueueForbidden = true }),
    -- Nathria Trinkets
    SanguineVintage                        = Action.Create({ Type = "Trinket", ID = 184031 }),
    ManaboundMirror                        = Action.Create({ Type = "Trinket", ID = 184029 }),
    GluttonousSpike                        = Action.Create({ Type = "Trinket", ID = 184023 }),
    DreadfireVessel                        = Action.Create({ Type = "Trinket", ID = 184030 }),
    MemoryofPastSins                       = Action.Create({ Type = "Trinket", ID = 184025 }),
    ConsumptiveInfusion                    = Action.Create({ Type = "Trinket", ID = 184022 }),
    StoneLegionHeraldry                    = Action.Create({ Type = "Trinket", ID = 184027 }),
    BargastsLeash                          = Action.Create({ Type = "Trinket", ID = 184017 }),
    -- OP Dungeons Trinkets
    BloodSpatteredScale                    = Action.Create({ Type = "Trinket", ID = 179331 }),
    OverwhelmingPowerCrystal               = Action.Create({ Type = "Trinket", ID = 179342 }),
    SunbloodAmethyst                       = Action.Create({ Type = "Trinket", ID = 178826 }),
    PulsatingStoneheart                    = Action.Create({ Type = "Trinket", ID = 178825 }),
    BladedancersArmorKit                   = Action.Create({ Type = "Trinket", ID = 178862 }),  
    
    -- Legendaries
    PainbreakerPsalmChest                  = Action.Create({ Type = "Spell", ID = 173241 }),
    PainbreakerPsalmCloak                  = Action.Create({ Type = "Spell", ID = 173242 }),
    CalltotheVoidGloves                    = Action.Create({ Type = "Spell", ID = 173244 }),
    CalltotheVoidWrists                    = Action.Create({ Type = "Spell", ID = 173249 }),
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true }),-- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true }),-- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true }),    -- spell_magic_polymorphrabbit
    DummyTest                              = Action.Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon
	ConcentratedFlame					   = Action.Create({ Type = "Spell", ID = 295373, }),
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_PRIEST_SHADOW)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_PRIEST_SHADOW], { __index = Action })


------------------------------------------
---------------- VARIABLES ---------------
------------------------------------------
local VarDotsUp = false;
local VarAllDotsUp = false;
local VarMindSearCutoff = 1;
local VarSearingNightmareCutoff = false;
local PainbreakerEquipped = (A.PainbreakerPsalmChest:IsExists() or A.PainbreakerPsalmCloak:IsExists())
local CalltotheVoidEquipped = (A.CalltotheVoidGloves:IsExists() or A.CalltotheVoidWrists:IsExists())

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
        VarDotsUp = false
        VarAllDotsUp = false
        VarMindSearCutoff = 1
        VarSearingNightmareCutoff = false
end)

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local player = "player"

------------------------------------------
-------------- COMMON PREAPL -------------
------------------------------------------
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
    VampiricTouchDelay                      = 0,
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function InRange(unit)
    -- @return boolean 
    return A.VampiricTouch:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isStrictlyEqual, isCheckEqual, isCheckCombat)
    -- @return boolean 
    local c = 0 
    
    if isStrictlySuperior == nil then
        isStrictlySuperior = false
    end
    
    if isStrictlyInferior == nil then
        isStrictlyInferior = false
    end    
    
    if isStrictlyEqual == nil then
        isStrictlyEqual = false
    end
    
    for unit in pairs(ActiveUnitPlates) do 
        if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
            if InRange(unit) then 
                c = c + 1
            elseif range then 
                local r = Unit(unit):GetRange()
                if r > 0 and r <= range then 
                    c = c + 1
                end 
            end 
            -- Strictly superior than >
            if isStrictlySuperior and not isStrictlyInferior and not isStrictlyEqual then
                if c > count then
                    return true
                end
            end
            
            -- Strictly inferior <
            if isStrictlyInferior and not isStrictlySuperior and not isStrictlyEqual then
                if c < count then
                    return true
                end
            end
            
            -- Strictly equal ==
            if not isStrictlyInferior and not isStrictlySuperior and isStrictlyEqual then
                if c == count then
                    return true
                end
            end    
            
            -- Classic >=
            if not isStrictlyInferior and not isStrictlySuperior and not isStrictlyEqual then
                if c >= count then 
                    return true 
                end 
            end
        end 
        
    end
    
end  
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- InsanityThreshold
local function InsanityThreshold()
    return A.LegacyOfTheVoid:IsSpellLearned() and 60 or 90
end

-- ExecuteRange
local function ExecuteRange()
    return 20
end

-- DotsUp
local function DotsUp(unitID, all)
    if all then
        return (Unit(unitID):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.DevouringPlague.ID, true) > 0)
    else
        return (Unit(unitID):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 0 and Unit(unitID):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 0)
    end
end

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Silence:IsReadyByPassCastGCD(unit) or not A.Silence:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)
    if A.GetToggle(2, "TasteInterruptList") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, "TasteBFAContent", true, countInterruptGCD(unit))
    else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end
    
    if castRemainsTime >= A.GetLatency() then
        -- Silence
        if useKick and A.Silence:IsReady(unit) and A.Silence:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
            -- Notification                    
            Action.SendNotification("Silence interrupting...", A.Silence.ID)
            return A.Silence
        end 
        
        -- Fear Disarm
        if useCC and A.PsychicHorror:IsReady(unit) and A.PsychicHorror:AbsentImun(unit, Temp.TotalAndMagKick, true) and Unit(unit):IsControlAble("stun", 0) then 
            -- Notification                    
            Action.SendNotification("Psychic Horror interrupting...", A.PsychicHorror.ID)
            return A.PsychicHorror              
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

-- Defensives
local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then  
        return 
    end
    
    local VampiricEmbrace = A.GetToggle(2, "VampiricEmbrace")
    if    VampiricEmbrace >= 0 and A.VampiricEmbrace:IsReady(player) and 
    (
        (     -- Auto 
            VampiricEmbrace >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 80 and 
                    Unit(player):TimeToDieX(20) < 8 
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
            ) and 
            Unit(player):HasBuffs("DeffBuffs") == 0
        ) or 
        (    -- Custom
            VampiricEmbrace < 100 and 
            Unit(player):HealthPercent() <= VampiricEmbrace
        )
    ) 
    then 
        return A.VampiricEmbrace
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Multidot Handler UI --
local function HandleMultidots()
    local choice = Action.GetToggle(2, "AutoDotSelection")
    
    if choice == "In Raid" then
        if IsInRaid() then
            return true
        else
            return false
        end
    elseif choice == "In Dungeon" then 
        if IsInGroup() then
            return true
        else
            return false
        end
    elseif choice == "In PvP" then     
        if A.IsInPvP then 
            return true
        else
            return false
        end        
    elseif choice == "Everywhere" then 
        return true
    else
        return false
    end
    --print(choice)
end

-- Insanity Drain 
local function InsanityDrain()
    return (Unit(player):HasBuffs(A.VoidformBuff.ID, true) > 0) and (math.ceil(5 + Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) * 0.68)) or 0
end

--[[ CritCds
local function CritCds(unit)
    use_item,name=azsharas_font_of_power
    if A.AzsharasFontofPower:IsReady(player) then
    return A.AzsharasFontofPower
end

-- use_item,effect_name=cyclotronic_blast
if A.CyclotronicBlast:IsReady(unit) then
    return A.CyclotronicBlast
end

-- the_unbound_force
if A.TheUnboundForce:AutoHeartOfAzerothP(unit, true) and Action.GetToggle(1, "HeartOfAzeroth") then
    return A.TheUnboundForce
end
end
CritCds = A.MakeFunctionCachedStatic(CritCds)]]


--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
    local profileStop = false
    local DBM = Action.GetToggle(1, "BossMods")
    local HeartOfAzeroth = Action.GetToggle(1, "HeartOfAzeroth")
    local Racial = Action.GetToggle(1, "Racial")
    local Potion = Action.GetToggle(1, "Potion")
    local UnbridledFuryAuto = GetToggle(2, "UnbridledFuryAuto")
    local UnbridledFuryTTD = GetToggle(2, "UnbridledFuryTTD")
    local UnbridledFuryWithBloodlust = GetToggle(2, "UnbridledFuryWithBloodlust")
    local UnbridledFuryHP = GetToggle(2, "UnbridledFuryHP")
    local UnbridledFuryWithExecute = GetToggle(2, "UnbridledFuryWithExecute")
    local FocusedAzeriteBeamTTD = GetToggle(2, "FocusedAzeriteBeamTTD")
    local FocusedAzeriteBeamUnits = GetToggle(2, "FocusedAzeriteBeamUnits")
    -- Multidots var
    local MissingShadowWordPain = MultiUnits:GetByRangeMissedDoTs(MultiDotDistance, 5, A.ShadowWordPain.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local MissingVampiricTouch = MultiUnits:GetByRangeMissedDoTs(MultiDotDistance, 5, A.VampiricTouch.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local AppliedShadowWordPain = MultiUnits:GetByRangeAppliedDoTs(MultiDotDistance, 5, A.ShadowWordPain.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local AppliedVampiricTouch = MultiUnits:GetByRangeAppliedDoTs(MultiDotDistance, 5, A.VampiricTouch.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    local ShadowWordPainToRefresh = MultiUnits:GetByRangeDoTsToRefresh(MultiDotDistance, 5, A.ShadowWordPain.ID, 6, 5)
    local VampiricTouchToRefresh = MultiUnits:GetByRangeDoTsToRefresh(MultiDotDistance, 5, A.VampiricTouch.ID, 6, 5)
    -- Trinkets vars
    local Trinket1IsAllowed, Trinket2IsAllowed = TR:TrinketIsAllowed()
    local TrinketsAoE = GetToggle(2, "TrinketsAoE")
    local TrinketsMinTTD = GetToggle(2, "TrinketsMinTTD")
    local TrinketsUnitsRange = GetToggle(2, "TrinketsUnitsRange")
    local TrinketsMinUnits = GetToggle(2, "TrinketsMinUnits")
    
    
    local InsanityDrain = InsanityDrain()
    local VoidFormActive = Unit(player):HasBuffs(A.VoidformBuff.ID, true) > 0
    -- Azerite beam protection channel
    local CanCast = true
    local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    local _, castStartedTime, castEndTime = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
    -- Ensure all channel and cast are really safe
    -- Double protection with check on current casts and also timestamp of the cast
    if (spellID == A.FocusedAzeriteBeam.ID) then 
        if (CurrentCastLeft > 0 or secondsLeft > 0 or isChannel) then
            if TMW.time < castEndTime then            
                CanCast = false
            else
                CanCast = true
            end
        end
    end
    -- Showing icon PoolResource to make sure nothing else is read by GG
    if not CanCast then
        return A.PoolResource:Show(icon)
    end
    
    ------------------------------------
    ---------- DUMMY DPS TEST ----------
    ------------------------------------
    local DummyTime = GetToggle(2, "DummyTime")
    if DummyTime > 0 then
        local unit = "target"
        local endtimer = 0
        
        if Unit(unit):IsExists() and Unit(unit):IsDummy() then
            if Unit(player):CombatTime() >= (DummyTime * 60) then
                StopAttack()
                endtimer = TMW.time
                --ClearTarget() -- Protected ? 
                -- Notification                    
                Action.SendNotification(DummyTime .. " Minutes Dummy Test Concluded - Profile Stopped", A.DummyTest.ID)            
                
                if endtimer < TMW.time + 5 then
                    profileStop = true
                    --return A.DummyTest:Show(icon)
                end
            end
        end
    end
    if Temp.VampiricTouchDelay == 0 and A.VampiricTouch:IsSpellInCasting() then
        Temp.VampiricTouchDelay = 15
    end
    
    if Temp.VampiricTouchDelay > 0 then
        --    print(Temp.ImmolateDelay)
        Temp.VampiricTouchDelay = Temp.VampiricTouchDelay - 1
    end
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
        
        -- variable,name=mind_blast_targets,op=set,value=floor((4.5+azerite.whispers_of_the_damned.rank)%(1+0.27*azerite.searing_dialogue.rank))
        VarMindBlastTargets = math.floor ((4.5 + A.WhispersoftheDamned:GetAzeriteRank()) / (1 + 0.27 * A.SearingDialogue:GetAzeriteRank()))
        
        -- variable,name=swp_trait_ranks_check,op=set,value=(1-0.07*azerite.death_throes.rank+0.2*azerite.thought_harvester.rank)*(1-0.09*azerite.thought_harvester.rank*azerite.searing_dialogue.rank)
        VarSwpTraitRanksCheck = (1 - 0.07 * A.DeathThroes:GetAzeriteRank() + 0.2 * A.ThoughtHarvester:GetAzeriteRank()) * (1 - 0.09 * A.ThoughtHarvester:GetAzeriteRank() * A.SearingDialogue:GetAzeriteRank())
        
        -- variable,name=vt_trait_ranks_check,op=set,value=(1-0.04*azerite.thought_harvester.rank-0.05*azerite.spiteful_apparitions.rank)
        VarVtTraitRanksCheck = (1 - 0.04 * A.ThoughtHarvester:GetAzeriteRank() - 0.05 * A.SpitefulApparitions:GetAzeriteRank())
        
        -- variable,name=vt_mis_trait_ranks_check,op=set,value=(1-0.07*azerite.death_throes.rank-0.03*azerite.thought_harvester.rank-0.055*azerite.spiteful_apparitions.rank)*(1-0.027*azerite.thought_harvester.rank*azerite.searing_dialogue.rank)
        VarVtMisTraitRanksCheck = (1 - 0.07 * A.DeathThroes:GetAzeriteRank() - 0.03 * A.ThoughtHarvester:GetAzeriteRank() - 0.055 * A.SpitefulApparitions:GetAzeriteRank()) * (1 - 0.027 * A.ThoughtHarvester:GetAzeriteRank() * A.SearingDialogue:GetAzeriteRank())
        
        -- variable,name=vt_mis_sd_check,op=set,value=1-0.014*azerite.searing_dialogue.rank
        VarVtMisSdCheck = 1 - 0.014 * A.SearingDialogue:GetAzeriteRank()
        
        -- variable,name=dots_up,op=set,value=dot.shadow_word_pain.ticking&dot.vampiric_touch.ticking
        VarDotsUp = (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 0)
        
        -- CritCds
--        local CritCd = CritCds(unit)
        
        -- Interrupt Handler          
        local unit = "target"
        local useKick, useCC, useRacial = Action.InterruptIsValid(unit, "TargetMouseover")    
        local Trinket1IsAllowed, Trinket2IsAllowed = TR.TrinketIsAllowed()
        
        -- Interrupt
        local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end 
        
        -- DispelMagic 
        if A.DispelMagic:IsReady(unit, nil, nil, true) and A.DispelMagic:AbsentImun(unit, Temp.TotalAndMagKick) and A.AuraIsValid(unit, "UseDispel", "Dispel") then 
            return A.DispelMagic:Show(icon)
        end 
 
		--actions.main+=/devouring_plague,target_if=(refreshable|insanity>75)&!variable.pi_or_vf_sync_condition&(!talent.searing_nightmare.enabled|(talent.searing_nightmare.enabled&!variable.searing_nightmare_cutoff))
		if A.DevouringPlague:IsReady(unit) and ((Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) == 0 or Unit(unit):HasDeBuffs(A.DevouringPlague.ID, true) < 3) or Player:Insanity() > 75) and A.VoidEruption:GetCooldown() > 0 then
			return A.DevouringPlague:Show(icon)
		end	
 
        --[[ potion
        if A.PotionofUnbridledFury:IsReady(unit) and Action.GetToggle(1, "Potion") and UnbridledFuryAuto
        and 
        (
            (UnbridledFuryWithBloodlust and Unit(player):HasHeroism())
            or
            (UnbridledFuryWithExecute and Unit(unit):HealthPercent() <= 30)
        )
        and Unit(unit):TimeToDie() > UnbridledFuryTTD
        then
            -- Notification                    
            Action.SendNotification("Burst: Potion of Unbridled Fury", A.PotionofUnbridledFury.ID)    
            return A.PotionofUnbridledFury:Show(icon)
        end]]
        
        --Precombat
        if combatTime == 0 and not profileStop and Unit(unit):IsExists() and unit ~= "mouseover" then
            -- flask
            -- food
            -- augmentation
            -- snapshot_stats
            
            --[[ potion
            if A.PotionofUnbridledFury:IsReady(unit) and Action.GetToggle(1, "Potion") then
                return A.PotionofUnbridledFury:Show(icon)
            end]]
            
            -- shadowform,if=!buff.shadowform.up
            if A.Shadowform:IsReady(unit) and Unit(player):HasBuffsDown(A.ShadowformBuff.ID, true) then
                return A.Shadowform:Show(icon)
            end
            
            --[[ use_item,name=azsharas_font_of_power
            if A.AzsharasFontofPower:IsReady(player) then
                return A.AzsharasFontofPower:Show(icon)
            end]]
           
			
            -- mind_blast,if=spell_targets.mind_sear<2|azerite.thought_harvester.rank=0
            if A.MindBlast:IsReady(unit) and (GetByRange(2, 40, false, true) or A.ThoughtHarvester:GetAzeriteRank() == 0) then
                return A.MindBlast:Show(icon)
            end
            
            -- vampiric_touch
            if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 and Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0 then
                return A.VampiricTouch:Show(icon)
            end
            
        end
        
        -- Burst Phase
        if BurstIsON(unit) and unit ~= "mouseover" and inCombat and not profileStop and CanCast then
            
            --[[memory_of_lucid_dreams,if=(buff.voidform.stack>20&insanity<=50)|buff.voidform.stack>(26+7*buff.bloodlust.up)|(InsanityDrain*((gcd.max*2)+action.mind_blast.cast_time))>insanity
			if CanCast and A.MemoryofLucidDreams:IsReady(unit) and A.VitalityConduit:IsSpellInRange(target) and 
            (
                (Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 20 and Player:Insanity() <= 50) 
                or 
                Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > (26 + 7 * num(Unit(player):HasHeroism())) 
                or 
                (InsanityDrain * ((A.GetGCD() * 2) + A.MindBlast:GetSpellCastTime())) > Player:Insanity()
            )
            then
                return A.Darkflight:Show(icon)
            end
            -- racials
            if A.BloodFury:AutoRacial(unit, nil, nil, true) then 
                return A.BloodFury:Show(icon)
            end 
            
            if A.Fireblood:AutoRacial(unit, nil, nil, true) then 
                return A.Fireblood:Show(icon)
            end 
            
            if A.AncestralCall:AutoRacial(unit, nil, nil, true) then 
                return A.AncestralCall:Show(icon)
            end 
            
            if A.Berserking:AutoRacial(unit, nil, nil, true) then 
                return A.Berserking:Show(icon)
            end 
            
            -- blood_of_the_enemy
            if A.BloodoftheEnemy:AutoHeartOfAzerothP(unit, true) and Action.GetToggle(1, "HeartOfAzeroth") then
                return A.Darkflight:Show(icon)
            end
            
            -- guardian_of_azeroth,if=buff.voidform.stack>15
            if A.GuardianofAzeroth:AutoHeartOfAzerothP(unit, true) and Action.GetToggle(1, "HeartOfAzeroth") and (Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 15) then
                return A.Darkflight:Show(icon)
            end
            
            -- focused_azerite_beam,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
            if A.FocusedAzeriteBeam:AutoHeartOfAzeroth(unit, true) and CanCast and BurstIsON(unit) and UseHeartOfAzeroth 
            and (GetByRange(FocusedAzeriteBeamUnits, 30) or Unit(unit):IsBoss()) and Unit(unit):TimeToDie() >= FocusedAzeriteBeamTTD
            then
                -- Notification                    
                Action.SendNotification("Stop moving!! Focused Azerite Beam", A.FocusedAzeriteBeam.ID)                 
                return A.Darkflight:Show(icon)
            end
            
            -- purifying_blast,if=spell_targets.mind_sear>=2|raid_event.adds.in>60
            if A.PurifyingBlast:AutoHeartOfAzerothP(unit, true) and Action.GetToggle(1, "HeartOfAzeroth") and (MultiUnits:GetByRange(40) >= 2 or 10000000000 > 60) then
                return A.Darkflight:Show(icon)
            end]]
            
            -- concentrated_flame,line_cd=6,if=time<=10|(buff.chorus_of_insanity.stack>=15&buff.voidform.up)|full_recharge_time<gcd|target.time_to_die<5

            
            -- ripple_in_space
            if A.RippleinSpace:AutoHeartOfAzerothP(unit, true) and Action.GetToggle(1, "HeartOfAzeroth") then
                return A.Darkflight:Show(icon)
            end
            
            -- reaping_flames
            if A.ReapingFlames:AutoHeartOfAzerothP(unit, true) then
                return A.Darkflight:Show(icon)
            end
            
            -- worldvein_resonance
            if A.WorldveinResonance:AutoHeartOfAzerothP(unit, true) and Action.GetToggle(1, "HeartOfAzeroth") then
                return A.Darkflight:Show(icon)
            end
            
            -- Mindbender/Shadowfiend at 19 or more stacks, or if the target will die in less than 15s.
            if A.Shadowfiend:IsReady(unit) and Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 18 and Unit(unit):IsBoss() then
                return A.Shadowfiend:Show(icon)
            end    
            
            --[[ call_action_list,name=crit_cds,if=(buff.voidform.up&buff.chorus_of_insanity.stack>20)|azerite.chorus_of_insanity.rank=0
            if CritCd and 
            (
                (VoidFormActive and Unit(player):HasBuffsStacks(A.ChorusofInsanity.ID, true) > 20) 
                or 
                A.ChorusofInsanity:GetAzeriteRank() == 0
            )
            then
                return CritCd:Show(icon)
            end]]
            
            -- use_items
            
            -- Non SIMC Custom Trinket1
            if A.Trinket1:IsReady(unit) and Trinket1IsAllowed and    
            (
                TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
                or
                not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD                     
            )
            then 
                return A.Trinket1:Show(icon)
            end         
            
            -- Non SIMC Custom Trinket2
            if A.Trinket2:IsReady(unit) and Trinket2IsAllowed and        
            (
                TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
                or
                not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD                     
            )
            then
                return A.Trinket2:Show(icon)     
            end    
            
        end
        
        -- MULTI TARGET
        
        -- run_action_list,name=cleave,if=active_enemies>1
        if inCombat and GetByRange(1, 40, true) then
            
            -- Auto Multidot
            if Unit(unit):TimeToDie() >= 10  
            and Action.GetToggle(2, "AoE") and Action.GetToggle(2, "AutoDot") and HandleMultidots() and  
            (
                (
                    (MissingVampiricTouch > 0 and MissingVampiricTouch < 5) 
                    or 
                    (VampiricTouchToRefresh > 0 and VampiricTouchToRefresh < 5) 
                ) 
                and Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) > 5 and Unit(unit):HasDeBuffs(A.VampiricTouch.ID, true) > 5 
            ) 
            and MultiUnits:GetByRange(MultiDotDistance) > 1 and MultiUnits:GetByRange(MultiDotDistance) <= 5
            then
                return A:Show(icon, ACTION_CONST_AUTOTARGET)
            end    

			if A.ConcentratedFlame:IsReady(unit) and VarDotsUp and not VoidFormActive then
                return A.Darkflight:Show(icon)
            end
            
            -- void_eruption
            if A.VoidEruption:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Player:Insanity() >= InsanityThreshold() and not VoidFormActive and not isMoving then
                return A.VoidEruption:Show(icon)
            end        
            
            --[[ dark_ascension,if=buff.voidform.down
            if A.DarkAscension:IsReady(unit) and not VoidFormActive then
                return A.DarkAscension:Show(icon)
            end]]
 
			--MindBlast bypass MindFlay channel
			if A.MindBlast:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Unit("player"):HasBuffs(A.DarkThought.ID, true) > 0 then
                return A.MindBlast:Show(icon)
            end

            -- vampiric_touch
            if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Temp.VampiricTouchDelay == 0 and (Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0 and Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) < 3) then
                return A.VampiricTouch:Show(icon)
            end
 
            -- vampiric_touch,if=!ticking&azerite.thought_harvester.rank>=1
            if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 and (Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) == 0 and A.ThoughtHarvester:GetAzeriteRank() >= 1) then
                return A.VampiricTouch:Show(icon)
            end
            
            -- mind_sear,if=buff.harvested_thoughts.up
            if A.MindSear:IsReady(unit) and VarDotsUp and not isMoving and A.VoidBolt:GetCooldown() >= A.GetGCD() and Unit(player):HasBuffs(A.HarvestedThoughtsBuff.ID, true) > 0 then
                return A.MindSear:Show(icon)
            end
            
            -- void_bolt
            if VoidFormActive and
            (
                (A.GetToggle(2, "SpellsTiming") and A.VoidBolt:GetCooldown() <= A.GetGCD() + A.GetCurrentGCD() + A.GetPing() + (TMW.UPD_INTV or 0) + ACTION_CONST_CACHE_DEFAULT_TIMER) 
                or
                (A.VoidBolt:IsReady(unitID, nil, nil, A.GetToggle(2, "ByPassSpells")))
            )
            then
                return A.VoidBolt:Show(icon)
            end        
            
            -- shadow_crash,if=(raid_event.adds.in>5&raid_event.adds.duration<2)|raid_event.adds.duration>2
            if A.ShadowCrash:IsReady(player) and not VoidFormActive and GetByRange(2, 40) then
                return A.ShadowCrash:Show(icon)
            end
            
            -- shadow_word_death,target_if=target.time_to_die<3|buff.voidform.down
            if A.ShadowWordDeath:IsReady(unit) then
                if Unit(unit):TimeToDie() < 3 or not VoidFormActive then
                    return A.ShadowWordDeath:Show(icon) 
                end
            end
            
            -- surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
            if A.SurrenderToMadness:IsReady(unit) and (Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 10 + (10 * num(Unit(player):HasHeroism()))) then
                return A.SurrenderToMadness:Show(icon)
            end
            
            -- dark_void,if=raid_event.adds.in>10&(dot.shadow_word_pain.refreshable|target.time_to_die>30)
            if A.DarkVoid:IsReady(unit) and (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 5 or Unit(unit):TimeToDie() > 30) then
                return A.DarkVoid:Show(icon)
            end
            
            -- mindbender
            if A.Mindbender:IsReady(unit) then
                return A.Mindbender:Show(icon)
            end
            
            -- mind_blast,target_if=spell_targets.mind_sear<variable.mind_blast_targets
            if A.MindBlast:IsReady(unit) then
                if GetByRange(VarMindBlastTargets, 40, false, true) then
                    return A.MindBlast:Show(icon) 
                end
            end
            
            -- shadow_word_pain,target_if=refreshable&target.time_to_die>((-1.2+3.3*spell_targets.mind_sear)*variable.swp_trait_ranks_check*(1-0.012*azerite.searing_dialogue.rank*spell_targets.mind_sear)),if=!talent.misery.enabled
            if A.ShadowWordPain:IsReady(unit) and
            (
                Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 5
                and 
                Unit(unit):TimeToDie() > ((num(true) - 1.2 + 3.3 * MultiUnits:GetByRange(40)) * VarSwpTraitRanksCheck * (1 - 0.012 * A.SearingDialogue:GetAzeriteRank() * MultiUnits:GetByRange(40)))
            )
            and (not A.Misery:IsSpellLearned()) 
            then                
                return A.ShadowWordPain:Show(icon) 
            end
            
            -- vampiric_touch,target_if=refreshable,if=target.time_to_die>((1+3.3*spell_targets.mind_sear)*variable.vt_trait_ranks_check*(1+0.10*azerite.searing_dialogue.rank*spell_targets.mind_sear))
            if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 then
                if (Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) < 5) and 
                (
                    Unit(unit):TimeToDie() > ((1 + 3.3 * MultiUnits:GetByRange(40)) * VarVtTraitRanksCheck * (1 + 0.10 * A.SearingDialogue:GetAzeriteRank() * MultiUnits:GetByRange(40)))
                )
                then
                    return A.VampiricTouch:Show(icon) 
                end
            end
            
            -- vampiric_touch,target_if=dot.shadow_word_pain.refreshable,if=(talent.misery.enabled&target.time_to_die>((1.0+2.0*spell_targets.mind_sear)*variable.vt_mis_trait_ranks_check*(variable.vt_mis_sd_check*spell_targets.mind_sear)))
            if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 then
                if (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 5) and 
                (
                    (
                        A.Misery:IsSpellLearned() 
                        and 
                        Unit(unit):TimeToDie() > ((1.0 + 2.0 * MultiUnits:GetByRange(40)) * VarVtMisTraitRanksCheck * (VarVtMisSdCheck * MultiUnits:GetByRange(40)))
                    )
                )
                then
                    return A.VampiricTouch:Show(icon) 
                end
            end
            
            -- void_torrent,if=buff.voidform.up
            if A.VoidTorrent:IsReady(unit) and VoidFormActive then
                return A.VoidTorrent:Show(icon)
            end
            
            -- mind_sear,target_if=spell_targets.mind_sear>1,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2
            if A.MindSear:IsReady(unit) and not isMoving and MultiUnits:GetActiveEnemies() > 2 and 
            (
                VarDotsUp 
                or 
                Unit(unit):TimeToDie() < 6
            )
            then 
                return A.MindSear:Show(icon)         
            end             
            
            -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks<=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
            if A.MindFlay:IsReady(unit) and not isMoving and MultiUnits:GetActiveEnemies() <= 2 and 
            (
                VarDotsUp 
                or 
                Unit(unit):TimeToDie() < 6
            )
            then 
                return A.MindFlay:Show(icon)         
            end     
            
            -- shadow_word_pain
            if A.ShadowWordPain:IsReady(unit) and A.Misery:IsSpellLearned() then
                return A.ShadowWordPain:Show(icon)
            end
            
        end
        
        --Single Target
        
        -- run_action_list,name=single,if=active_enemies=1
        if inCombat and GetByRange(1, 40, false, false, true) then
 
			if A.ConcentratedFlame:IsReady(unit) and VarDotsUp and not VoidFormActive then
                return A.Darkflight:Show(icon)
            end
 
            -- void_eruption
            if A.VoidEruption:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Player:Insanity() >= InsanityThreshold() and not VoidFormActive and not isMoving then
                return A.VoidEruption:Show(icon)
            end        
            
            --[[ dark_ascension,if=buff.voidform.down
            if A.DarkAscension:IsReady(unit) and (not VoidFormActive) then
                return A.DarkAscension:Show(icon)
            end]]
            
            -- void_bolt
            if VoidFormActive and
            (
                (A.GetToggle(2, "SpellsTiming") and A.VoidBolt:GetCooldown() <= A.GetGCD() + A.GetCurrentGCD() + A.GetPing() + (TMW.UPD_INTV or 0) + ACTION_CONST_CACHE_DEFAULT_TIMER) 
                or
                (A.VoidBolt:IsReady(unitID, nil, nil, A.GetToggle(2, "ByPassSpells")))
            )
            then
                return A.VoidBolt:Show(icon)
            end

			--MindBlast bypass MindFlay channel
			if A.MindBlast:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Unit("player"):HasBuffs(A.DarkThought.ID, true) > 0 then
                return A.MindBlast:Show(icon)
            end

            -- vampiric_touch
            if A.VampiricTouch:IsReady(unit, nil, nil, A.GetToggle(2, "ByPassSpells")) and Temp.VampiricTouchDelay == 0 and (Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) > 0 and Unit("player"):HasBuffs(A.UnfurlingDarknessBuff.ID, true) < 3) then
                return A.VampiricTouch:Show(icon)
            end
            
            -- call_action_list,name=cds
            --  if (true) then
            --      local ShouldReturn = Cds(unit); if ShouldReturn then return ShouldReturn; end
            --  end
            
            -- mind_sear,if=buff.harvested_thoughts.up&cooldown.void_bolt.remains>=1.5&azerite.searing_dialogue.rank>=1
            if A.MindSear:IsReady(unit) and (Unit(player):HasBuffs(A.HarvestedThoughtsBuff.ID, true) > 0 and A.VoidBolt:GetCooldown() >= 1.5 and A.SearingDialogue:GetAzeriteRank() >= 1) then
                return A.MindSear:Show(icon)
            end
            
            -- shadow_word_death,if=target.time_to_die<3|cooldown.shadow_word_death.charges=2|(cooldown.shadow_word_death.charges=1&cooldown.shadow_word_death.remains<gcd.max)
            if A.ShadowWordDeath:IsReady(unit) and 
            (
                Unit(unit):TimeToDie() < 3 
                or 
                A.ShadowWordDeath:GetSpellCharges() == 2 
                or 
                (A.ShadowWordDeath:GetSpellCharges() == 1 and A.ShadowWordDeath:GetCooldown() < A.GetGCD())
            )
            then
                return A.ShadowWordDeath:Show(icon)
            end
            
            -- surrender_to_madness,if=buff.voidform.stack>10+(10*buff.bloodlust.up)
            if A.SurrenderToMadness:IsReady(unit) and (Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 10 + (10 * num(Unit(player):HasHeroism()))) then
                return A.SurrenderToMadness:Show(icon)
            end
            
            -- dark_void,if=raid_event.adds.in>10
            if A.DarkVoid:IsReady(unit) and not isMoving and not VoidFormActive and Unit(unit):IsBoss() then
                return A.DarkVoid:Show(icon)
            end
            
            --[[ power_word_shield
            if A.PowerWordShield:IsReady(player) and Unit(player):HasDeBuffs(A.WeakenedSoulDebuff.ID) == 0 and Player:PrevGCD(1, A.ShadowWordDeath) then 
                return A.PowerWordShield:Show(icon)
            end]]
            
            -- mindbender,if=talent.mindbender.enabled|(buff.voidform.stack>18|target.time_to_die<15)
            if A.Mindbender:IsReady(unit) and 
            (
                A.Mindbender:IsSpellLearned() 
                or 
                (
                    Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 18 
                    or 
                    Unit(unit):TimeToDie() < 15
                )
            )
            then
                return A.Mindbender:Show(icon)
            end
            
            -- shadow_word_death,if=!buff.voidform.up|(cooldown.shadow_word_death.charges=2&buff.voidform.stack<15)
            if A.ShadowWordDeath:IsReady(unit) and 
            (
                not VoidFormActive 
                or
                (A.ShadowWordDeath:GetSpellCharges() == 2 and Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) < 15)
            )
            then
                return A.ShadowWordDeath:Show(icon)
            end
            
            -- shadow_crash,if=(raid_event.adds.in>5&raid_event.adds.duration<2)|raid_event.adds.duration>2
            if A.ShadowCrash:IsReady(player) and VarDotsUp and not VoidFormActive then
                return A.ShadowCrash:Show(icon)
            end    
            
            -- mind_blast,if=variable.dots_up&((raid_event.movement.in>cast_time+0.5&raid_event.movement.in<4)|!talent.shadow_word_void.enabled|buff.voidform.down|buff.voidform.stack>14&(insanity<70|charges_fractional>1.33)|buff.voidform.stack<=14&(insanity<60|charges_fractional>1.33))
            if A.MindBlast:IsReady(unit) and 
            (
                VarDotsUp and 
                (
                    not A.ShadowWordVoid:IsSpellLearned() 
                    or 
                    not VoidFormActive 
                    or 
                    Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) > 14 and 
                    (
                        Player:Insanity() < 70 
                        or 
                        A.MindBlast:GetSpellChargesFrac() > 1.33
                    ) 
                    or 
                    Unit(player):HasBuffsStacks(A.VoidformBuff.ID, true) <= 14 and 
                    (
                        Player:Insanity() < 60 
                        or 
                        A.MindBlast:GetSpellChargesFrac() > 1.33
                    )
                )
            )
            then
                return A.MindBlast:Show(icon)
            end
            
            -- void_torrent,if=dot.shadow_word_pain.remains>4&dot.vampiric_touch.remains>4&buff.voidform.up
            if A.VoidTorrent:IsReady(unit) and 
            (
                Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) > 4 
                and
                Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) > 4 
                and 
                VoidFormActive
            )
            then
                return A.VoidTorrent:Show(icon)
            end
            
            -- shadow_word_pain,if=refreshable&target.time_to_die>4&!talent.misery.enabled&!talent.dark_void.enabled
            if A.ShadowWordPain:IsReady(unit) and (Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 5 and Unit(unit):TimeToDie() > 4 and not A.Misery:IsSpellLearned() and not A.DarkVoid:IsSpellLearned() or (isMoving and (not VoidFormActive or A.VoidBolt:GetCooldown() >= A.GetGCD()))) then
                return A.ShadowWordPain:Show(icon)
            end
            
            -- vampiric_touch,if=refreshable&target.time_to_die>6|(talent.misery.enabled&dot.shadow_word_pain.refreshable)
            if A.VampiricTouch:IsReady(unit) and Temp.VampiricTouchDelay == 0 and not Player:IsCasting(A.VampiricTouch) and 
            (
                Unit(unit):HasDeBuffs(A.VampiricTouchDebuff.ID, true) < 5 and Unit(unit):TimeToDie() > 6 
                or 
                (A.Misery:IsSpellLearned() and Unit(unit):HasDeBuffs(A.ShadowWordPainDebuff.ID, true) < 5)
            )
            then
                return A.VampiricTouch:Show(icon)
            end
            
            -- mind_flay,chain=1,interrupt_immediate=1,interrupt_if=ticks>=2&(cooldown.void_bolt.up|cooldown.mind_blast.up)
            -- need proper ticks count here 
            if A.MindFlay:IsReady(unit) then
                return A.MindFlay:Show(icon)
            end
            
            -- shadow_word_pain
            if A.ShadowWordPain:IsReady(unit) and isMoving then
                return A.ShadowWordPain:Show(icon)
            end
            
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

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end
-- [5] Trinket Rotation
-- No specialization trinket actions 
-- Passive 
local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", 3355) > UnitCooldown:GetMaxDuration("arena", 3355) - 2 and
    UnitCooldown:IsSpellInFly("arena", 3355) and 
    Unit(player):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 
local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then  
            -- Interrupt
            local Interrupt = Interrupts(unit)
            if Interrupt then 
                return Interrupt:Show(icon)
            end    
        end
    end 
end 
local function PartyRotation(unit)
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end
    
end 

A[6] = function(icon)
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    --  local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end 
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    -- local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    return ArenaRotation(icon, "arena3")
end

