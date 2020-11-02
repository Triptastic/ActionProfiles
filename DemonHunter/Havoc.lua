--#####################################
--##### TRIP'S HAVOC DEMON HUNTER #####
--#####################################

--Full credit to Taste

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Azerite                                   = LibStub("AzeriteTraits")
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
local TR                                        = Action.TasteRotation
local pairs                                     = pairs
local Pet                                       = LibStub("PetLibrary")

--For Toaster
local Toaster																	= _G.Toaster
local GetSpellTexture 															= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DEMONHUNTER_HAVOC] = {
    -- Racial
    ArcaneTorrent                          = Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572      }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738     }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                            = Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                            = Action.Create({ Type = "Spell", ID = 107079     }),
    Haymaker                               = Action.Create({ Type = "Spell", ID = 287712     }), 
    WarStomp                               = Action.Create({ Type = "Spell", ID = 20549     }),
    BullRush                               = Action.Create({ Type = "Spell", ID = 255654     }),  
    GiftofNaaru                            = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                             = Action.Create({ Type = "Spell", ID = 58984    }), -- Used for HoA
    Stoneform                              = Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                            = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics
    MetamorphosisBuff                      = Action.Create({ Type = "Spell", ID = 162264 }),
    Metamorphosis                          = Action.Create({ Type = "Spell", ID = 191427 }),
    ChaoticTransformation                  = Action.Create({ Type = "Spell", ID = 288754 }),
    Demonic                                = Action.Create({ Type = "Spell", ID = 213410 }),
    EyeBeam                                = Action.Create({ Type = "Spell", ID = 198013 }),
    BladeDance                             = Action.Create({ Type = "Spell", ID = 188499 }),
    FelBarrage                             = Action.Create({ Type = "Spell", ID = 258925 }),
    EssenceBreak                              = Action.Create({ Type = "Spell", ID = 258860 }),
    Annihilation                           = Action.Create({ Type = "Spell", ID = 201427 }),
    EssenceBreakDebuff                        = Action.Create({ Type = "Spell", ID = 258860, Hidden = true      }),
    ChaosStrike                            = Action.Create({ Type = "Spell", ID = 162794 }),
    DeathSweep                             = Action.Create({ Type = "Spell", ID = 210152 }),
    RevolvingBlades                        = Action.Create({ Type = "Spell", ID = 279581 }),
    ImmolationAura                         = Action.Create({ Type = "Spell", ID = 258920 }),
    Felblade                               = Action.Create({ Type = "Spell", ID = 232893 }),
    FelRush                                = Action.Create({ Type = "Spell", ID = 195072 }),
    Netherwalk                             = Action.Create({ Type = "Spell", ID = 196555 }),
    DemonBlades                            = Action.Create({ Type = "Spell", ID = 203555 }),
    DemonsBite                             = Action.Create({ Type = "Spell", ID = 162243 }),
    ThrowGlaive                            = Action.Create({ Type = "Spell", ID = 185123 }),
    VengefulRetreat                        = Action.Create({ Type = "Spell", ID = 198793 }),
    LifebloodBuff                          = Action.Create({ Type = "Spell", ID = 295078 }),
    Momentum                               = Action.Create({ Type = "Spell", ID = 206476 }),
    PreparedBuff                           = Action.Create({ Type = "Spell", ID = 203650 }),
    FelMastery                             = Action.Create({ Type = "Spell", ID = 192939 }),
    BlindFury                              = Action.Create({ Type = "Spell", ID = 203550 }),
    FirstBlood                             = Action.Create({ Type = "Spell", ID = 206416 }),
    TrailofRuin                            = Action.Create({ Type = "Spell", ID = 258881 }),
    MomentumBuff                           = Action.Create({ Type = "Spell", ID = 208628 }),
	InnerDemon							   = Action.Create({ Type = "Spell", ID = 337313 }),
    FelEruption                            = Action.Create({ Type = "Spell", ID = 211881}),
    Blur                                   = Action.Create({ Type = "Spell", ID = 198589}),
    ConsumeMagic                           = Action.Create({ Type = "Spell", ID = 278326}),
    Darkness                               = Action.Create({ Type = "Spell", ID = 196718}),
	GlaiveTempest						   = Action.Create({ Type = "Spell", ID = 342817}),
    RecklessForceCounter                   = Action.Create({ Type = "Spell", ID = 298409}),
    RecklessForceCounter2                  = Action.Create({ Type = "Spell", ID = 302917}),
    ConcentratedFlameBurn                  = Action.Create({ Type = "Spell", ID = 295368}),
    --PickUpFragment                         = Action.Create({ Type = "Spell", ID =  }),
    EyesofRage                             = Action.Create({ Type = "Spell", ID = 278500 }),
    Imprison                               = Action.Create({ Type = "Spell", ID = 217832}),
	ImprisonImproved                       = Action.Create({ Type = "Spell", ID = 221527}),
    --ImprisonAntiFake                       = Action.Create({ Type = "Spell", ID = 217832, Desc = "[2] Kick", Hidden = true, QueueForbidden = true    }),
    Disrupt                                = Action.Create({ Type = "Spell", ID = 183752}),
    DisruptGreen                           = Action.Create({ Type = "SpellSingleColor", ID = 183752, Color = "GREEN", Desc = "[2] Kick", Hidden = true, QueueForbidden = true }),
    ChaosNova                              = Action.Create({ Type = "Spell", ID = 179057}),
    ChaosNovaGreen                           = Action.Create({ Type = "SpellSingleColor", ID = 179057, Color = "GREEN", Desc = "[1] CC", Hidden = true, QueueForbidden = true }),
    -- PvP
    ManaRift                               = Action.Create({ Type = "Spell", ID = 235903}),    -- Mana destroyer
    ManaBreak                              = Action.Create({ Type = "Spell", ID = 203704}),    -- Mana destroyer 2 :D
    RainfromAbove                          = Action.Create({ Type = "Spell", ID = 206803}), -- Better if Unit is LOS
    ReverseMagic                           = Action.Create({ Type = "Spell", ID = 205604}), -- Player + Friendly dispell and send back dispelled debuff to enemy
	Detainment                             = Action.Create({ Type = "Spell", ID = 205596}),
	Torment                                = Action.Create({ Type = "Spell", ID = 185245}), -- Taunt
	Tormentor                              = Action.Create({ Type = "Spell", ID = 207029}), -- Taunt PvP replace Torment
    -- Potions
    PotionofUnbridledFury                  = Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 
    BattlePotionOfAgility                  = Action.Create({ Type = "Potion", ID = 163223, QueueForbidden = true }),  
    SuperiorPotionofUnbridledFury          = Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }), 
	SuperiorSteelskinPotion                = Action.Create({ Type = "Potion", ID = 168501, QueueForbidden = true }), 
	AbyssalHealingPotion                   = Action.Create({ Type = "Potion", ID = 169451, QueueForbidden = true }),     
	PotionofFocusedResolve                 = Action.Create({ Type = "Potion", ID = 168506 }),
	SuperiorBattlePotionofStrength         = Action.Create({ Type = "Potion", ID = 168500 }),
	PotionofEmpoweredProximity             = Action.Create({ Type = "Potion", ID = 168529 }),
    -- Trinkets
    AzsharasFontofPower                    = Action.Create({ Type = "Trinket", ID = 169314 }),
    PocketsizedComputationDevice           = Action.Create({ Type = "Trinket", ID = 167555 }),
    RotcrustedVoodooDoll                   = Action.Create({ Type = "Trinket", ID = 159624 }),
    ShiverVenomRelic                       = Action.Create({ Type = "Trinket", ID = 168905 }),
    AquipotentNautilus                     = Action.Create({ Type = "Trinket", ID = 169305 }),
    TidestormCodex                         = Action.Create({ Type = "Trinket", ID = 165576 }),
    VialofStorms                           = Action.Create({ Type = "Trinket", ID = 158224 }),
    GalecallersBoon                        = Action.Create({ Type = "Trinket", ID = 159614 }),
    InvocationOfYulon                      = Action.Create({ Type = "Trinket", ID = 165568 }),
    LustrousGoldenPlumage                  = Action.Create({ Type = "Trinket", ID = 159617 }),
    LurkersInsidiousGift                   = Action.Create({ Type = "Trinket", ID = 167866 }),
    VigorTrinket                           = Action.Create({ Type = "Trinket", ID = 165572 }),
    AshvanesRazorCoral                     = Action.Create({ Type = "Trinket", ID = 169311 }),
    MalformedHeraldsLegwraps               = Action.Create({ Type = "Trinket", ID = 167835 }),
    HyperthreadWristwraps                  = Action.Create({ Type = "Trinket", ID = 168989 }),
    NotoriousAspirantsBadge                = Action.Create({ Type = "Trinket", ID = 167528 }),
    NotoriousGladiatorsBadge               = Action.Create({ Type = "Trinket", ID = 167380 }),
    SinisterGladiatorsBadge                = Action.Create({ Type = "Trinket", ID = 165058 }),
    SinisterAspirantsBadge                 = Action.Create({ Type = "Trinket", ID = 165223 }),
    DreadGladiatorsBadge                   = Action.Create({ Type = "Trinket", ID = 161902 }),
    DreadAspirantsBadge                    = Action.Create({ Type = "Trinket", ID = 162966 }),
    DreadCombatantsInsignia                = Action.Create({ Type = "Trinket", ID = 161676 }),
    NotoriousAspirantsMedallion            = Action.Create({ Type = "Trinket", ID = 167525 }),
    NotoriousGladiatorsMedallion           = Action.Create({ Type = "Trinket", ID = 167377 }),
    SinisterGladiatorsMedallion            = Action.Create({ Type = "Trinket", ID = 165055 }),
    SinisterAspirantsMedallion             = Action.Create({ Type = "Trinket", ID = 165220 }),
    DreadGladiatorsMedallion               = Action.Create({ Type = "Trinket", ID = 161674 }),
    DreadAspirantsMedallion                = Action.Create({ Type = "Trinket", ID = 162897 }),
    DreadCombatantsMedallion               = Action.Create({ Type = "Trinket", ID = 161811 }),
    IgnitionMagesFuse                      = Action.Create({ Type = "Trinket", ID = 159615 }),
    TzanesBarkspines                       = Action.Create({ Type = "Trinket", ID = 161411 }),
    AzurethosSingedPlumage                = Action.Create({ Type = "Trinket", ID = 161377 }),
    AncientKnotofWisdomAlliance            = Action.Create({ Type = "Trinket", ID = 161417 }),
    AncientKnotofWisdomHorde               = Action.Create({ Type = "Trinket", ID = 166793 }),
    ShockbitersFang                        = Action.Create({ Type = "Trinket", ID = 169318 }),
    NeuralSynapseEnhancer                  = Action.Create({ Type = "Trinket", ID = 168973 }),
    BalefireBranch                         = Action.Create({ Type = "Trinket", ID = 159630 }),
	GrongsPrimalRage                       = Action.Create({ Type = "Trinket", ID = 165574 }),
	BygoneBeeAlmanac                       = Action.Create({ Type = "Trinket", ID = 163936 }),
	RampingAmplitudeGigavoltEngine         = Action.Create({ Type = "Trinket", ID = 165580 }),
	VisionofDemise                         = Action.Create({ Type = "Trinket", ID = 169307 }),
	JesHowler                              = Action.Create({ Type = "Trinket", ID = 159627 }),
	GalecallersBeak                        = Action.Create({ Type = "Trinket", ID = 161379 }),
    DribblingInkpod                        = Action.Create({ Type = "Trinket", ID = 169319 }),
    MerekthasFang                          = Action.Create({ Type = "Trinket", ID = 158367 }),	
	GrongsPrimalRage                       = Action.Create({ Type = "Trinket", ID = 165574 }),
	BygoneBeeAlmanac                       = Action.Create({ Type = "Trinket", ID = 163936 }),
	RampingAmplitudeGigavoltEngine         = Action.Create({ Type = "Trinket", ID = 165580 }),
	VisionofDemise                         = Action.Create({ Type = "Trinket", ID = 169307 }),
	JesHowler                              = Action.Create({ Type = "Trinket", ID = 159627 }),
	GalecallersBeak                        = Action.Create({ Type = "Trinket", ID = 161379 }),
    DribblingInkpod                        = Action.Create({ Type = "Trinket", ID = 169319 }),
    RazdunksBigRedButton                   = Action.Create({ Type = "Trinket", ID = 159611 }),
    MerekthasFang                          = Action.Create({ Type = "Trinket", ID = 158367 }),
    KnotofAncientFuryAlliance              = Action.Create({ Type = "Trinket", ID = 161413 }),
    KnotofAncientFuryHorde                 = Action.Create({ Type = "Trinket", ID = 166795 }),
    FirstMatesSpyglass                     = Action.Create({ Type = "Trinket", ID = 158163 }),
    VialofAnimatedBlood                    = Action.Create({ Type = "Trinket", ID = 159625 }),
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    CyclotronicBlast                       = Action.Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                  = Action.Create({ Type = "Spell", ID = 295368, Hidden = true}),
    RazorCoralDebuff                       = Action.Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                    = Action.Create({ Type = "Spell", ID = 302565, Hidden = true     }),
    PoolResource                           = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    DummyTest                              = Action.Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon
	Quake                                  = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
}

Action:CreateEssencesFor(ACTION_CONST_DEMONHUNTER_HAVOC)
local A = setmetatable(Action[ACTION_CONST_DEMONHUNTER_HAVOC], { __index = Action })

A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
        profileStop = false
end)

local player                                    = "player"
local PartyUnits
local Temp                                        = {
    TotalAndPhys                                = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                            = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                            = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                            = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                    = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                                    = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                                    = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                                    = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
}

local IsIndoors, UnitIsUnit = 
IsIndoors, UnitIsUnit    

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

local function InMelee(unit)
    -- @return boolean 
    return A.ChaosStrike:IsInRange(unit)
end 

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    -- @return boolean 
    local c = 0 
    for unit in pairs(ActiveUnitPlates) do 
        if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
            if InMelee(unit) then 
                c = c + 1
            elseif range then 
                local r = Unit(unit):GetRange()
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

local function num(val)
    if val then return 1 else return 0 end
end

-- EyeBeam Handler UI --
local function HandleEyeBeam()
    local choice = A.GetToggle(2, "EyeBeamMode")
    --print(choice) 
    local unit = "target"
    -- CDs ON
    if choice[1] then 
        return BurstIsON(unit) or false 
        -- AoE Only
    elseif choice[2] then
        -- also checks CDs
        if choice[1] then
            return (BurstIsON(unit) and GetByRange(2, 8) and A.GetToggle(2, "AoE")) or false
        else
            return (GetByRange(2, 8) and A.GetToggle(2, "AoE")) or false
        end
        -- Everytime
    elseif choice[3] then
        return A.EyeBeam:IsReady(unit) or false
    else
        return false
    end        
end

-- FelRush handler
local function UseMoves()
    return Action.GetToggle(2, "UseMoves") --or S.FelRush:Charges() == 2  
end


-- [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    return 
    Action.IsUnitEnemy(unit) and  
    Unit(unit):GetRange() <= 7 and 
    A.ChaosNovaGreen:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    if     A.ChaosNovaGreen:IsReady(nil, nil, nil, true) and 
    (
        AntiFakeStun("mouseover") or 
        AntiFakeStun("target") or 
        (
            not Action.IsUnitEnemy("mouseover") and 
            not Action.IsUnitEnemy("target") and                     
            (
                (Action.IsInPvP and EnemyTeam():PlayersInRange(1, 5)) or 
                (not Action.IsInPvP and GetByRange(1, 5))
            )
        )
    )
    then 
        return A.ChaosNovaGreen:Show(icon)         
    end                                                                     
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if Action.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif Action.IsUnitEnemy("target") then 
        unit = "target"
    end 
    
    if unit then         
        local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
        if castLeft > 0 then             
            -- Disrupt
            if not notKickAble and A.DisruptGreen:IsReady(unit, nil, nil, true) and A.DisruptGreen:AbsentImun(unit, Temp.TotalAndPhysKick, true) then
                return A.DisruptGreen:Show(icon)                                                  
            end 
            
            -- Imprison
            if A.Imprison:IsReady(unit, nil, nil, true) and A.Imprison:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):IsControlAble("incapacitate", 0) then
                return A.Imprison:Show(icon)                  
            end            
            
            -- Racials 
            if A.QuakingPalm:IsRacialReadyP(unit, nil, nil, true) then 
                return A.QuakingPalm:Show(icon)
            end 
            
            if A.Haymaker:IsRacialReadyP(unit, nil, nil, true) then 
                return A.Haymaker:Show(icon)
            end 
            
            if A.WarStomp:IsRacialReadyP(unit, nil, nil, true) then 
                return A.WarStomp:Show(icon)
            end 
            
            if A.BullRush:IsRacialReadyP(unit, nil, nil, true) then 
                return A.BullRush:Show(icon)
            end                         
        end 
    end                                                                                 
end

-- Multidot Handler UI --
local function HandleDarkness()
    local choice = Action.GetToggle(2, "DarknessMode")
    
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

-- Fel Blade UI --
local function HandleFelBlade()
    local choice = Action.GetToggle(2, "FelBladeMode")
    
    if choice == "AUTO" then
        -- Add protection for raid
        if not IsInRaid() then
            return true
            -- IF in Raid but in range of current target.
        elseif IsInRaid() and InMelee(unit) then
            return true
        else
            return false
        end
    elseif choice == "PVP" then 
        if A.IsInPvP then 
            return true
        end    
    else
        return false
    end
    
end

-- Auto Darkness Handler
local function CanDarkness()
    if A.Darkness:IsReady(player) then 
        -- Darkness
        local AutoDarkness = A.GetToggle(2, "AutoDarkness")
        local DarknessUnits = A.GetToggle(2, "DarknessUnits")
        local DarknessUnitsHP = A.GetToggle(2, "DarknessUnitsHP")    
        local DarknessUnitsTTD = A.GetToggle(2, "DarknessUnitsTTD")
        local totalMembers = HealingEngine.GetMembersAll()
		
        -- Auto Counter
        if DarknessUnits > 1 then 
            DarknessUnits = HealingEngine.GetMinimumUnits(1)
            -- Reduce size in raid by 20%
            if DarknessUnits > 5 then 
                DarknessUnits = DarknessUnits - (#totalMembers * 0.2)
            end 
            -- If user typed counter higher than max available members 
        elseif DarknessUnits >= TeamCache.Friendly.Size then 
            DarknessUnits = TeamCache.Friendly.Size
        end 
        
        if DarknessUnits < 3 and not A.IsInPvP then 
            return false 
        end 
        
        local counter = 0 
        for i = 1, #totalMembers do 
            -- Auto HP 
            if DarknessUnitsHP >= 100 and totalMembers[i].HP <= 30 then 
                counter = counter + 1
            end 
            
            -- Auto TTD 
            if DarknessUnitsTTD >= 100 and Unit(totalMembers[i].Unit):TimeToDie() <= 5 then 
                counter = counter + 1
            end 
            
            -- Custom HP 
            if DarknessUnitsHP < 100 and totalMembers[i].HP <= DarknessUnitsHP then 
                counter = counter + 1
            end
            
            -- Custom TTD 
            if DarknessUnitsTTD < 100 and Unit(totalMembers[i].Unit):TimeToDie() <= DarknessUnitsTTD then 
                counter = counter + 1
            end             
            
            if counter >= DarknessUnits then 
                return true 
            end 
        end 
    end 
    return false 
end 
CanDarkness = A.MakeFunctionCachedStatic(CanDarkness)

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
    
    -- Darkness
    if   AutoDarkness and HandleDarkness and CanDarkness() then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Darkness!", "Using Defensive Darkness!", A.Darkness.ID)
        return A.Darkness
    end
    
    -- Netherwalk
    local Netherwalk = A.GetToggle(2, "Netherwalk")
    if     Netherwalk >= 0 and A.Netherwalk:IsReady(player) and 
    (
        (     -- Auto 
            Netherwalk >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            Netherwalk < 100 and 
            Unit(player):HealthPercent() <= Netherwalk
        )
    ) 
    then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Netherwalk!", "Using Defensive Netherwalk!", A.Netherwalk.ID)
        return A.Netherwalk
    end
    
    -- Blur
    local Blur = A.GetToggle(2, "Blur")
    if     Blur >= 0 and A.Blur:IsReady(player) and 
    (
        (     -- Auto 
            Blur >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            Blur < 100 and 
            Unit(player):HealthPercent() <= Blur
        )
    ) 
    then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Blur!", "Using Defensive Blur!", A.Blur.ID)
        return A.Blur
    end
    
    -- HealingPotion
    local AbyssalHealingPotion = A.GetToggle(2, "AbyssalHealingPotionHP")
    if     AbyssalHealingPotion >= 0 and A.AbyssalHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            AbyssalHealingPotion >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 20 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.20 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            AbyssalHealingPotion < 100 and 
            Unit(player):HealthPercent() <= AbyssalHealingPotion
        )
    ) 
    then 
        return A.AbyssalHealingPotion
    end 
    
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
    
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Disrupt:IsReadyByPassCastGCD(unit) or not A.Disrupt:AbsentImun(unit, Temp.TotalAndMagKick) then
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
        -- Disrupt
        if useKick --and not notInterruptable 
		and A.Disrupt:IsReady(unit) 
		then 
            return A.Disrupt
        end
		
        -- Imprison    
        if useCC and not A.Disrupt:IsReady(unit) and A.Imprison:IsReady(unit) and A.GetToggle(2, "ImprisonAsInterrupt") then 
            -- Notification                    
            --Action.SendNotification("CC : Imprison", A.Imprison.ID)        
            return A.Imprison              
        end 
		
        -- Fel Eruption
        if useCC and A.FelEruption:IsSpellLearned() and A.FelEruption:IsReady(unit) and not A.Disrupt:IsReady(unit) and A.FelEruption:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true) then 
            -- Notification                    
            --Action.SendNotification("CC : Fel Eruption", A.FelEruption.ID)
            return A.FelEruption              
        end 
    
        -- Chaos Nova    
        if useCC and not A.Disrupt:IsReady(unit) and A.ChaosNova:IsReady(unit) and GetByRange(2, 13) and A.ChaosNova:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true) then 
            -- Notification                    
            --Action.SendNotification("CC : Chaos Nova", A.ChaosNova.ID)        
            return A.ChaosNova              
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

-- ExpectedCombatLength
local function ExpectedCombatLength()
    local BossTTD = 0
    if not A.IsInPvP then 
        for i = 1, MAX_BOSS_FRAMES do 
            if Unit("boss" .. i):IsExists() and not Unit("boss" .. i):IsDead() then 
                BossTTD = Unit("boss" .. i):TimeToDie()
            end 
        end 
    end 
    return BossTTD
end 
ExpectedCombatLength = A.MakeFunctionCachedStatic(ExpectedCombatLength)

local profileStop = false

local function ShouldDelayEyeBeam()
	local CurrentChannelTime = Action.GetSpellDescription(198013)[3]
		
    -- Check for M+ Quake Affix
    if Unit(player):HasDeBuffs(A.Quake.ID) > 0 and Unit(player):HasDeBuffs(A.Quake.ID) <= CurrentChannelTime + A.GetGCD() then
        return true
    end
end

local function ShouldDelayFelBarrage()
	local CurrentChannelTime = Action.GetSpellDescription(258925)[3]
		
    -- Check for M+ Quake Affix
    if Unit(player):HasDeBuffs(A.Quake.ID) > 0 and Unit(player):HasDeBuffs(A.Quake.ID) <= CurrentChannelTime + A.GetGCD() then
        return true
    end
end

local function ShouldDelayFocusedAzeriteBeam()
    local CurrentCastTime = Unit("player"):CastTime(295258)
	local CurrentChannelTime = Action.GetSpellDescription(295258)[2]
		
    -- Check for M+ Quake Affix
    if Unit(player):HasDeBuffs(A.Quake.ID) > 0 and Unit(player):HasDeBuffs(A.Quake.ID) <= CurrentCastTime + CurrentChannelTime + A.GetGCD() then
        return true
    end
end

-----------------------------------------
--                 ROTATION  
-----------------------------------------

-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local Pull = A.BossMods:GetPullTimer()	
--    local HoABossOnly = A.GetToggle(2, "HoABossOnly")
    local EyeBeamTTD = A.GetToggle(2, "EyeBeamTTD")
    local EyeBeamRange = A.GetToggle(2, "EyeBeamRange")
    local FocusedAzeriteBeamTTD = A.GetToggle(2, "FocusedAzeriteBeamTTD")
    local FocusedAzeriteBeamUnits = A.GetToggle(2, "FocusedAzeriteBeamUnits")    
    local FelBladeRange = A.GetToggle(2, "FelBladeRange")
    local FelBladeFury = A.GetToggle(2, "FelBladeFury")    
    local FelBladeOutOfRange = A.GetToggle(2, "FelBladeOutOfRange")    
    local ImprisonAsInterrupt = A.GetToggle(2, "ImprisonAsInterrupt")    
    local BladeDancePoolSeconds = A.GetToggle(2, "BladeDancePoolSeconds")        
    local ExpectedCombatLength = ExpectedCombatLength()
    local HandleDarkness = HandleDarkness()
    local Fury = Player:Fury()
    local FuryDeficit = Player:FuryDeficit()
    local UnbridledFuryAuto = A.GetToggle(2, "UnbridledFuryAuto")
    local UnbridledFuryTTD = A.GetToggle(2, "UnbridledFuryTTD")
    local UnbridledFuryWithSecondMeta = A.GetToggle(2, "UnbridledFuryWithSecondMeta")
    local UnbridledFuryWithBloodlust = A.GetToggle(2, "UnbridledFuryWithBloodlust")
    local UnbridledFuryHP = A.GetToggle(2, "UnbridledFuryHP")
    local UnbridledFuryWithExecute = A.GetToggle(2, "UnbridledFuryWithExecute")
    local UseHeartOfAzeroth = Action.GetToggle(1, "HeartOfAzeroth")
    local SyncBladeDanceDeathSweepWithEyeBeam = Action.GetToggle(2, "SyncBladeDanceDeathSweepWithEyeBeam")
    local ImmolationAuraPrePull = Action.GetToggle(2, "ImmolationAuraPrePull")
    local AzsharasFontofPowerPrePull = Action.GetToggle(2, "AzsharasFontofPowerPrePull")
    local UnbridledFuryPrePull = Action.GetToggle(2, "UnbridledFuryPrePull")
    local ArcaneTorrentPrePull = Action.GetToggle(2, "ArcaneTorrentPrePull")
    local Trinket1IsAllowed, Trinket2IsAllowed = TR.TrinketIsAllowed()
    -- EyeBeam protection channel
    local CanCast = true
    --local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    --local castName, castStartTime, castEndTime, notInterruptable, spellID, isChannel = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
    -- If we got Eyebeam or Azerite Beam or Fel barrage
    if inCombat and (spellID == A.EyeBeam.ID or spellID == A.FocusedAzeriteBeam.ID or spellID == A.FelBarrage.ID) then 
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
    
    ------------------------------------
    ---------- DUMMY DPS TEST ----------
    ------------------------------------
    local DummyTime = GetToggle(2, "DummyTime")
    if DummyTime > 0 then
        local unit = "target"
        local endtimer = 0
        
        if Unit(unit):IsExists() and Unit(unit):IsDummy() then
            if Unit("player"):CombatTime() >= (DummyTime * 60) then
                StopAttack()
                endtimer = TMW.time
                --ClearTarget() -- Protected ? 
                -- Notification                    
                --Action.SendNotification(DummyTime .. " Minutes Dummy Test Concluded - Profile Stopped", A.DummyTest.ID)
				A.Toaster:SpawnByTimer("TripToast", 0, "Dummy Test Concluded!", DummyTime .. " minutes passed. Stopping profile.", A.DummyTest.ID)				
                
                if endtimer < TMW.time + 5 then
                    profileStop = true
                    --return A.DummyTest:Show(icon)
                end
            end
        end
    end    
    --print(A.DBM_GetTimer("test"))
    if A.DBM_GetTimer("test") > 0 and A.DBM_GetTimer("test") < 5 then
        -- Notification                    
        --Action.SendNotification("DBM Test Adds Spawn in: ".. round(A.DBM_GetTimer("test"), 0), A.DummyTest.ID)
		A.Toaster:SpawnByTimer("TripToast", 0, "DBM Test!", "Adds spawning in: ".. round(A.DBM_GetTimer("test"), 0), A.DummyTest.ID)		
    end


    
    -- Start Rotation
    local function EnemyRotation(unit)     

		VarBladeDance = A.FirstBlood:IsSpellLearned() or GetByRange(8, 3 - num(A.TrailofRuin:IsSpellLearned()))
        VarPoolingMeta = not A.Demonic:IsSpellLearned() and A.Metamorphosis:GetCooldown() < 6 and FuryDeficit > 30       
        -- variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30          
        VarPoolingForMeta = not A.Demonic:IsSpellLearned() and A.Metamorphosis:GetCooldown() < 6 and Fury < 90          
        -- variable,name=pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)            
        VarPoolingForBladeDance = VarBladeDance and (Fury < 75 - num(A.FirstBlood:IsSpellLearned())*20)       
        -- variable,name=pooling_for_eye_beam,value=talent.demonic.enabled&!talent.blind_fury.enabled&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
        VarPoolingForEyeBeam = A.Demonic:IsSpellLearned() and not A.BlindFury:IsSpellLearned() and A.EyeBeam:GetCooldown() < (A.GetGCD() * 2) and FuryDeficit > 20
		-- Low Pooling for Eye Beam
		VarLowPoolForEyeBeam = A.Demonic:IsSpellLearned() and not A.BlindFury:IsSpellLearned() and A.EyeBeam:GetCooldown() < (A.GetGCD() * 2) and FuryDeficit > 75
        -- variable,name=waiting_for_dark_slash,value=talent.dark_slash.enabled&!variable.pooling_for_blade_dance&!variable.pooling_for_meta&cooldown.dark_slash.up
        VarWaitingForEssenceBreak = A.EssenceBreak:IsSpellLearned() and not VarPoolingForBladeDance and not VarPoolingForMeta and A.EssenceBreak:GetCooldown() == 0          
        -- variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
        VarWaitingForMomentum = A.Momentum:IsSpellLearned() and Unit(player):HasBuffs(A.MomentumBuff.ID, true) == 0
		--VengefulRetreat + Fel Rush combo
		MovementComboReady = Unit("target"):GetRange() <= 2 and inCombat and A.VengefulRetreat:IsReady("player") and A.FelRush:IsReady("player") and Unit("player"):HasBuffs(A.InnerDemon.ID, true) > 0  and A.GetToggle(2, "UseMoves")
		MovementComboSoon = Unit("target"):GetRange() <= 2 and inCombat and A.VengefulRetreat:GetCooldown() < 3 and A.FelRush:GetCooldown() < 3 and Unit("player"):HasBuffs(A.InnerDemon.ID, true) > 0  and A.GetToggle(2, "UseMoves")
		
        
		--Announce Movement Combo soon
		if MovementComboSoon
		then
			A.Toaster:SpawnByTimer("TripToast", 0, "Movement Combo Ready!", "Get prepared!", A.VengefulRetreat.ID)
		end
		
				-- unbound chaos
		if MovementComboReady and A.EyeBeam:GetCooldown() > 3 and A.Metamorphosis:GetCooldown() > 5
		then
			return A.VengefulRetreat:Show(icon)
		end	
		
		if A.FelRush:IsReady("player") and inCombat and Unit("target"):GetRange() >= 10 and Unit("player"):HasBuffs(A.InnerDemon.ID, true) > 0 and A.GetToggle(2, "UseMoves") then
			return A.FelRush:Show(icon)
		end		
		
        -- Purge
        if inCombat and A.ArcaneTorrent:AutoRacial(unit) and AuraIsValid(unit, "UsePurge", "Dispel") then 
            return A.ArcaneTorrent:Show(icon)
        end             
        
        -- Dispell
        --if A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "Dispel") then
        --    return A.ConsumeMagic:Show(icon)
        --end
        if inCombat and A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "MagicMovement") then
            return A.ConsumeMagic:Show(icon)
        end
        if inCombat and A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "PurgeHigh") then
            return A.ConsumeMagic:Show(icon)
        end
        if inCombat and A.ConsumeMagic:IsReady(unit) and not Unit(unit):IsBoss() and not IsInRaid() and AuraIsValid(unit, "UsePurge", "PurgeLow") then
            return A.ConsumeMagic:Show(icon)
        end
        
        -- Imprison CrowdControl PvP
        if inCombat and Action.ImprisonIsReady(unit) then
            return A.Imprison:Show(icon)
        end  
        
        -- Interrupts
        local Interrupt = Interrupts(unit)
        if inCombat and Interrupt then 
            return Interrupt:Show(icon)
        end 
        
        -- pick_up_fragment,if=fury.deficit>=35&(!azerite.eyes_of_rage.enabled|cooldown.eye_beam.remains>1.4)
        if inCombat and FuryDeficit <= 35 and (A.EyesofRage:GetAzeriteRank() > 0 or A.EyeBeam:GetCooldown() < 1.4) then
            -- Notification                    
            --Action.SendNotification("Don't take Soul Fragment !!!", A.EyesofRage.ID)
        end
        
        -- Custom Katherine tentacle handler
        if inCombat and UnitName(unit) == "Twisted Appendage" and A.DemonsBite:IsReady(unit) and not A.DemonBlades:IsSpellLearned() and CanCast then
            return A.DemonsBite:Show(icon)
        end
        
        -- Explosives or Totems
        if inCombat and (Unit(unit):IsExplosives() or Unit(unit):IsTotem()) and not Unit(unit):IsDummy() and CanCast then
            
            -- Annihilation
            if A.Annihilation:IsReady(unit) then 
                return A.Annihilation:Show(icon)
            end
            
            -- ChaosStrike
            if A.ChaosStrike:IsReady(unit) then 
                return A.ChaosStrike:Show(icon)
            end    
            
            -- Demons Bite
            if A.DemonsBite:IsReady(unit) then 
                return A.DemonsBite:Show(icon)
            end            
        end
        
        --Precombat
        if not inCombat and Unit(unit):IsExists() then
            
            -- use_item,name=azsharas_font_of_power
            if A.AzsharasFontofPower:IsReady(player) and (Pull > 0.1 and Pull <= AzsharasFontofPowerPrePull) then
                -- Notification                    
			A.Toaster:SpawnByTimer("TripToast", 0, "Azshara's Font of Power!", "Channeling for Pre-Pull!", A.AzsharasFontofPower.ID) 
                return A.AzsharasFontofPower:Show(icon)
            end
            
            -- immolation_aura
            if A.ImmolationAura:IsReady(player) and ((Pull > 0.1 and Pull <= ImmolationAuraPrePull) or not Action.GetToggle(1, "BossMods")) then
                -- Notification                    
			--A.Toaster:SpawnByTimer("TripToast", 0, "Immolation Aura PrePull!", "Unbound Chaos ready if talented.", A.ImmolationAura.ID)
                return A.ImmolationAura:Show(icon)
            end    
            
            -- Arcane Torrent dispell or if FuryDeficit >= 30
            if A.ArcaneTorrent:IsRacialReady(unit) and BurstIsON(unit) and Action.GetToggle(1, "Racial") and (Pull > 0.1 and Pull <= ArcaneTorrentPrePull or not Action.GetToggle(1, "BossMods")) 
            then
                -- Notification                    
                --Action.SendNotification("Prepull: Arcane Torrent", A.ArcaneTorrent.ID) 
                return A.ArcaneTorrent:Show(icon)
            end    
            
            --[[ PotionofUnbridledFury
            if A.PotionofUnbridledFury:IsReady(unit) and Action.GetToggle(1, "Potion") and (Pull > 0.1 and Pull <= UnbridledFuryPrePull) then
                -- Notification                    
                Action.SendNotification("Using pre pot", A.PotionofUnbridledFury.ID) 
                return A.PotionofUnbridledFury:Show(icon)
            end]]    
            
            --[[ guardian_of_azeroth,if=(buff.metamorphosis.up&cooldown.metamorphosis.ready)|buff.metamorphosis.remains>25|target.time_to_die<=30
            if A.GuardianofAzeroth:AutoHeartOfAzeroth(unit) and BurstIsON(unit) and (Action.GetToggle(1, "Racial") and Pull > 0.1 and Pull <= 1.5 or not Action.GetToggle(1, "BossMods"))
            then
                -- Notification                    
                Action.SendNotification("Prepull: Guardian of Azeroth", A.GuardianofAzeroth.ID) 
                return A.GuardianofAzeroth:Show(icon)
            end   ]]         
            
            -- use_item,name=azsharas_font_of_power
            if A.DemonsBite:IsReady(unit) and not A.Demonic:IsSpellLearned() and not A.DemonBlades:IsSpellLearned() and ((Pull > 0.1 and Pull <= 1) or not Action.GetToggle(1, "BossMods")) then
                return A.DemonsBite:Show(icon)
            end
            
            -- eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
            if A.EyeBeam:IsReady(unit) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and A.Demonic:IsSpellLearned() and HandleEyeBeam() and ((Pull > 0.1 and Pull <= 1) or not Action.GetToggle(1, "BossMods")) then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)               
                return A.EyeBeam:Show(icon)
            end            
        end
                
        -- Burst Phase
        if BurstIsON(unit) and unit ~= "mouseover" and inCombat and not profileStop then
            -- metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta|target.time_to_die<25
            if A.Metamorphosis:IsReady(player) and CanCast and combatTime > 3 and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0 and 
            (
                not A.Demonic:IsSpellLearned() 
                or
                (Unit(unit):IsBoss() and Unit(unit):TimeToDie() < 25)
            )
            then
                -- Notification                    
                --Action.SendNotification("Burst: Metamorphosis", A.Metamorphosis.ID)                
                return A.Metamorphosis:Show(icon)
            end    
            
            -- metamorphosis,if=talent.demonic.enabled&(!azerite.chaotic_transformation.enabled|(cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)))
            if A.Metamorphosis:IsReady(player) and CanCast and   
            (
                A.Demonic:IsSpellLearned() and 
                (
                    A.ChaoticTransformation:GetAzeriteRank() == 0 and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0
                    or
                    A.ChaoticTransformation:GetAzeriteRank() > 0 and A.EyeBeam:GetCooldown() > 0 and A.LastPlayerCastName == A.DeathSweep:Info()
                )
            )
            then
                -- Notification                    
                --Action.SendNotification("Burst: Metamorphosis", A.Metamorphosis.ID)
                return A.Metamorphosis:Show(icon)
            end
            
            
            -- potion,if=buff.metamorphosis.remains>25|target.time_to_die<60
            if A.PotionofUnbridledFury:IsReady(unit) and CanCast and Action.GetToggle(1, "Potion") and UnbridledFuryAuto
            and 
            (
                (Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and UnbridledFuryWithSecondMeta)
                or
                (UnbridledFuryWithBloodlust and Unit("player"):HasHeroism())
                or
                (UnbridledFuryWithExecute and Unit(unit):HealthPercent() <= 30)
            )
            and Unit(unit):TimeToDie() > UnbridledFuryTTD
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Unbridled Fury!", "Using Unbridled Fury potion!", A.PotionofUnbridledFury.ID)  
                return A.PotionofUnbridledFury:Show(icon)
            end
            
            -- use_item,name=galecallers_boon,if=!talent.fel_barrage.enabled|cooldown.fel_barrage.ready
            if A.GalecallersBoon:IsReady(unit) and CanCast and (not A.FelBarrage:IsSpellLearned() or A.FelBarrage:GetCooldown() == 0) then
                return A.GalecallersBoon:Show(icon)
            end
            
            -- use_item,effect_name=cyclotronic_blast,if=buff.metamorphosis.up&buff.memory_of_lucid_dreams.down&(!variable.blade_dance|!cooldown.blade_dance.ready)
            if A.CyclotronicBlast:IsReady(unit) and CanCast and (Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) and Unit(player):HasBuffs(A.MemoryofLucidDreamsBuff.ID, true) == 0 and (not VarBladeDance or not A.BladeDance:GetCooldown() == 0)) then
                return A.CyclotronicBlast:Show(icon)
            end
            
            -- use_item,name=ashvanes_razor_coral,if=debuff.razor_coral_debuff.down|(debuff.conductive_ink_debuff.up|buff.metamorphosis.remains>20)&target.health.pct<31|target.time_to_die<20
            if A.AshvanesRazorCoral:IsReady(unit)  
            and (
                Unit(unit):HasDeBuffsStacks(A.RazorCoralDebuff.ID, true) == 0 and CanCast
                or 
                (
                    (
                        (
                            Unit(unit):HealthPercent() < 31 and CanCast and Unit(unit):HasDeBuffsStacks(A.RazorCoralDebuff.ID, true) > 10 and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 8 
                        )
                        or 
                        (
                            Unit(unit):HealthPercent() < 31 and CanCast and Unit(unit):HasDeBuffs(A.ConductiveInkDebuff.ID, true) > 0 and Unit(unit):HasDeBuffsStacks(A.RazorCoralDebuff.ID, true) > 0
                        )
                    )
                )
            ) 
            then
                -- Notification                    
                --Action.SendNotification("Trinket: Ashvanes Razor Coral", A.AshvanesRazorCoral.ID)
                return A.AshvanesRazorCoral:Show(icon)
            end
            
            -- use_item,name=azsharas_font_of_power,if=cooldown.metamorphosis.remains<10|cooldown.metamorphosis.remains>60
            if A.AzsharasFontofPower:IsReady(player) and CanCast and (A.Metamorphosis:GetCooldown() < 10 or A.Metamorphosis:GetCooldown() > 60) then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Azshara's Font of Power!", "Stop moving!", A.AzsharasFontofPower.ID)              
                return A.AzsharasFontofPower:Show(icon)
            end
            
            -- use_items,if=buff.metamorphosis.up
            -- call_action_list,name=essences
            --[[if Essences(unit) then
                return true
            end]] 
			
			-- guardian_of_azeroth
			if A.GuardianofAzeroth:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end
			
			-- focused_azerite_beam
			if A.FocusedAzeriteBeam:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end
			
			-- memory_of_lucid_dreams
			if A.MemoryofLucidDreams:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end
			
			-- blood_of_the_enemy
			if A.BloodoftheEnemy:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end
			
			-- purifying_blast
			if A.PurifyingBlast:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end
			
			--[[ ripple_in_space
			if A.RippleInSpace:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
				return A.Shadowmeld:Show(icon)
			end]]
			
			-- concentrated_flame,line_cd=6
			if A.ConcentratedFlame:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end
			
			-- reaping_flames
			if A.ReapingFlames:IsReady(unit) and CanCast and BurstIsON(unit) then
				return A.Shadowmeld:Show(icon)
			end

            
            -- bag_of_tricks
            if A.BagofTricks:AutoRacial(unit) and CanCast and Action.GetToggle(1, "Racial") and BurstIsON(unit) then
                return A.BagofTricks:Show(icon)
            end
            
            -- Non SIMC Custom Trinket1
            if A.Trinket1:IsReady(unit) and Trinket1IsAllowed and CanCast then        
                if BurstIsON(unit) then 
                    return A.Trinket1:Show(icon)
                end         
            end
            
            -- Non SIMC Custom Trinket2
            if A.Trinket2:IsReady(unit) and Trinket2IsAllowed and CanCast then        
                if BurstIsON(unit) then 
                    return A.Trinket2:Show(icon)
                end     
            end
            
        end

        --[[ concentrated_flame,if=(!dot.concentrated_flame_burn.ticking&!action.concentrated_flame.in_flight|full_recharge_time<gcd.max)
        if A.ConcentratedFlame:AutoHeartOfAzeroth(unit, true)  and UseHeartOfAzeroth 
		and (
		        (Unit(unit):HasDeBuffs(A.ConcentratedFlameBurn.ID, true) == 0 and not A.ConcentratedFlame:IsSpellInFlight() or A.ConcentratedFlame:GetSpellChargesFullRechargeTime() < A.GetGCD())
		    ) then
            return A.ConcentratedFlame:Show(icon)
        end
			
		-- reaping_flames
        if A.ReapingFlames:AutoHeartOfAzeroth(unit, true) and UseHeartOfAzeroth then
            return A.ReapingFlames:Show(icon)
        end]]
        
		
        -- Demonic build
        if A.Demonic:IsSpellLearned() and not profileStop and inCombat then
			
			-- death_sweep,if=variable.blade_dance
            if A.DeathSweep:IsReadyByPassCastGCD(player) and Unit(unit):GetRange() < 6 and CanCast and VarBladeDance and not Unit(unit):IsTotem()
            then
                return A.DeathSweep:Show(icon)
            end   
            
            -- eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
            if A.EyeBeam:IsReady(unit) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and CanCast and HandleEyeBeam() and Unit(unit):GetRange() <= EyeBeamRange and 
            (
                Unit(unit):TimeToDie() > EyeBeamTTD 
                or 
                Unit(unit):IsBoss()
            ) 
            then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)                 
                return A.EyeBeam:Show(icon)
            end    
            
            -- blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>(5-azerite.revolving_blades.rank*3)|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
            if A.BladeDance:IsReadyByPassCastGCD(player) and Unit(unit):GetRange() < 6 and CanCast and VarBladeDance and not Unit(unit):IsTotem() and
            (
                -- AUTO
                (
                    BladeDancePoolSeconds >= 15 and
                    (
                        (A.EyeBeam:GetCooldown() > (9 / (1 + Player:HastePct() * 0.01)) and SyncBladeDanceDeathSweepWithEyeBeam) 
                    )                
                ) 
                or  
                -- MANUAL
                (
                    BladeDancePoolSeconds < 15 and
                    (A.EyeBeam:GetCooldown() > BladeDancePoolSeconds and SyncBladeDanceDeathSweepWithEyeBeam)
                )
                -- DISABLED NO SYNC
                or 
                (
                    not SyncBladeDanceDeathSweepWithEyeBeam    and A.EyeBeam:GetCooldown() > 0
                )
                -- DISABLED EYE BEAM
                or
                (
                    HandleEyeBeam() == false
                )
            )            
            then
                --(BladeDancePool and A.EyeBeam:GetCooldown() < A.BladeDance:GetCooldown() * BladeDancePoolSeconds)  
                -- EyeBeam cooldown < Blade Dance Cooldown = stop using Blade Dance
                return A.BladeDance:Show(icon)
            end 

			-- immolation_aura
            if A.ImmolationAura:IsReady(player) and CanCast and FuryDeficit > 20 then
                return A.ImmolationAura:Show(icon)
            end 
            
            -- annihilation,if=!variable.pooling_for_blade_dance
            if A.Annihilation:IsReadyByPassCastGCD(unit) and CanCast and not VarPoolingForBladeDance then
                return A.Annihilation:Show(icon)
            end
            
            -- felblade,if=fury.deficit>=40
            if A.Felblade:IsReady(unit) and HandleFelBlade() and Unit(unit):GetRange() <= FelBladeRange and CanCast and A.Felblade:IsSpellLearned() and Fury < FelBladeFury then
                return A.Felblade:Show(icon)
            end
            
            -- chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
            if A.ChaosStrike:IsReady(unit) and CanCast and not VarPoolingForBladeDance and 
			(
					(HandleEyeBeam() ~= false and not VarPoolingForEyeBeam)
					or
					(HandleEyeBeam() == false and not VarLowPoolForEyeBeam)
			) then
                return A.ChaosStrike:Show(icon)
            end    
            
            -- demons_bite
            if A.DemonsBite:IsReady(unit) and CanCast and not A.DemonBlades:IsSpellLearned() then
                return A.DemonsBite:Show(icon)
            end    
            
            -- felblade,if=movement.distance>15|buff.out_of_range.up
            if A.Felblade:IsReady(unit) and HandleFelBlade() and CanCast and Unit(unit):GetRange() > 10 and FelBladeOutOfRange and A.Felblade:IsSpellLearned() and not A.Momentum:IsSpellLearned() then
                return A.Felblade:Show(icon)
            end
            
            -- throw_glaive,if=buff.out_of_range.up
            if A.ThrowGlaive:IsReady(unit) and CanCast and Unit(unit):GetRange() > 15 and A.ThrowGlaive:GetSpellCharges() > 1 and not A.Momentum:IsSpellLearned() then
                return A.ThrowGlaive:Show(icon)
            end
            
            -- throw_glaive,if=talent.demon_blades.enabled
            if A.ThrowGlaive:IsReady(unit) and CanCast and (A.DemonBlades:IsSpellLearned() or A.ThrowGlaive:GetSpellCharges() > 1) then
                return A.ThrowGlaive:Show(icon)
            end
			
            -- throw_glaive,manual two charges
            if A.ThrowGlaive:IsReady(unit) and CanCast and A.ThrowGlaive:GetSpellCharges() == 2 then
                return A.ThrowGlaive:Show(icon)
            end
            
        end
        
        -- Normal build
        if not A.Demonic:IsSpellLearned() and not profileStop and inCombat then

            -- fel_barrage,if=((!cooldown.eye_beam.up|buff.metamorphosis.up)&raid_event.adds.in>30)|active_enemies>desired_targets
            if A.FelBarrage:IsReady(unit) and not ShouldDelayFelBarrage() and CanCast and 
            (
                (
                    (A.EyeBeam:GetCooldown() > 0 or Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 0)
                ) 
                or 
                GetByRange(1, 40)
            ) 
            then
                return A.FelBarrage:Show(icon)
            end
			
			-- death_sweep,if=variable.blade_dance
            if A.DeathSweep:IsReadyByPassCastGCD(unit) and InMelee(unit) and CanCast and not Unit(unit):IsTotem() and VarBladeDance then
                return A.DeathSweep:Show(icon)
            end
			
            -- immolation_aura
            if A.ImmolationAura:IsReady(player) and CanCast and FuryDeficit > 10 then
                return A.ImmolationAura:Show(icon)
            end
 
			-- glaive_tempest,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>10)
			if A.GlaiveTempest:IsReady(player) and not VarWaitingForMomentum and GetByRange(3,8) then
				return A.GlaiveTempest:Show(icon)
			end	
            
			-- eye_beam,if=active_enemies>1&(!raid_event.adds.exists|raid_event.adds.up)&!variable.waiting_for_momentum
            if A.EyeBeam:IsReady(unit) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and CanCast and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) and Unit(unit):GetRange() <= EyeBeamRange and not Unit(unit):IsTotem() and HandleEyeBeam()  then
                -- Notification                    
                Action.SendNotification("Stop moving!! Using Eye Beam", A.EyeBeam.ID)               
                return A.EyeBeam:Show(icon)
            end
			
			-- blade_dance,if=variable.blade_dance
            if A.BladeDance:IsReady(unit) and InMelee(unit) and CanCast and not Unit(unit):IsTotem() and VarBladeDance then
                return A.BladeDance:Show(icon)
            end
			
			
            -- felblade,if=fury.deficit>=40
            if A.Felblade:IsReady(unit) and HandleFelBlade() and Unit(unit):GetRange() <= FelBladeRange and A.Felblade:IsSpellLearned() and Fury < FelBladeFury then
                return A.Felblade:Show(icon)
            end
			
			-- eye_beam,if=!talent.blind_fury.enabled&!variable.waiting_for_essence_break&raid_event.adds.in>cooldown
            if A.EyeBeam:IsReady(unit) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and CanCast and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) and Unit(unit):GetRange() <= EyeBeamRange and not Unit(unit):IsTotem() and HandleEyeBeam() and (not A.BlindFury:IsSpellLearned() and not VarWaitingForEssenceBreak) then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)                
                return A.EyeBeam:Show(icon)
            end
            
            -- annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance&!variable.waiting_for_essence_break
            if A.Annihilation:IsReadyByPassCastGCD(unit) and CanCast and 
            (
                (
                    A.DemonBlades:IsSpellLearned()  
                    or
                    Fury >= 40 
                    or
                    Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) < 5
                )
                and not VarPoolingForBladeDance and not VarWaitingForEssenceBreak
            ) 
            then
                return A.Annihilation:Show(icon)
            end
            
            -- chaos_strike
            if A.ChaosStrike:IsReady(unit) and CanCast and (Fury > 40) then
                return A.ChaosStrike:Show(icon)
            end
            
            -- eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown
            if A.EyeBeam:IsReady(unit) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and CanCast and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) and Unit(unit):GetRange() <= EyeBeamRange and not Unit(unit):IsTotem() and HandleEyeBeam() and A.BlindFury:IsSpellLearned() then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)                
                return A.EyeBeam:Show(icon)
            end
            
            -- demons_bite
            if A.DemonsBite:IsReady(unit) and CanCast and not A.DemonBlades:IsSpellLearned() then
                return A.DemonsBite:Show(icon)
            end
            
            -- felblade,if=movement.distance>15|buff.out_of_range.up
            if A.Felblade:IsReady(unit) and HandleFelBlade() and Unit(unit):GetRange() > 7 and FelBladeOutOfRange and CanCast and A.Felblade:IsSpellLearned() and (Unit(unit):GetRange() > 15) and not A.Momentum:IsSpellLearned() then
                return A.Felblade:Show(icon)
            end
            
            -- throw_glaive,if=buff.out_of_range.up
            if A.ThrowGlaive:IsReady(unit) and CanCast and (Unit(unit):GetRange() > 15) and A.ThrowGlaive:GetSpellCharges() > 1 and not A.Momentum:IsSpellLearned() then
                return A.ThrowGlaive:Show(icon)
            end
            
            -- throw_glaive,if=talent.demon_blades.enabled
            if A.ThrowGlaive:IsReady(unit) and CanCast and (A.DemonBlades:IsSpellLearned() or A.ThrowGlaive:GetSpellCharges() == 2) then
                return A.ThrowGlaive:Show(icon)
            end
        end

        -- PvP Rotation
        local function RotationPvP(unit)
            -- Disrupt
            if useKick and A.Disrupt:IsReady(unit) and A.Disrupt:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
                return A.Disrupt:Show(icon)
            end
            
            -- PvP Manarift if debuff Imprison < ManaRift cast time (2.5sec)
            if A.ManaRift:IsReady("player") and Unit(unit):HasDeBuffs(A.Imprison.ID, true) > 0 and Unit(unit):HasDeBuffs(A.Imprison.ID, true) <= 2.5 then
                return A.ManaRift:Show(icon)
            end    
            
            -- PvP Manarift if debuff FelEruption < ManaRift cast time (2.5sec)
            if A.ManaRift:IsReady("player") and Unit(unit):HasDeBuffs(A.FelEruption.ID, true) > 0 and Unit(unit):HasDeBuffs(A.FelEruption.ID, true) <= 2.5 then
                return A.ManaRift:Show(icon)
            end        
            
            -- Imprison Casting BreakAble CC
            if A.ImprisonIsReady(unit) and Unit(unit):IsHealer() and not Unit(unit):InLOS() then
                return A.Imprison:Show(icon)
            end 
            
            -- PvP Reverse Magic
            if A.ReverseMagic:IsReady(unit) and Unit(player):HasDeBuffs("DamageDeBuffs") > 2 then
                return A.ReverseMagic:Show(icon)
            end
            
            -- PvP Rain from Above
            if A.RainfromAbove:IsReady(player) and Unit(unit):InLOS() and (Unit(unit):HealthPercent() <= 70 or Unit(player):HealthPercent() <= 30 or Unit(player):IsFocused()) then
                return A.RainfromAbove:Show(icon)
            end
        end
        
        -- PvP Rotation call
        if A.IsInPvP and RotationPvP(unit) then 
            return true
        end
        
        
    end
    
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive and CanCast then 
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
        local Caster = UnitCooldown:Getunit("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 

local function ArenaRotation(unit)

    local useKick, useCC, useRacial = A.InterruptIsValid(unit, "PvP")
	local combatTime = Unit("player"):CombatTime()
	
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if unit == "arena1" or unit == "arena2" or unit == "arena3" then 
			
			-- Interrupt
   		    local Interrupt = Interrupts(unit)
  		    if Interrupt then 
  		        return Interrupt:Show(icon)
  		    end	
			
            -- Fel Eruption
            if A.FelEruption:IsReady(unit) and
                A.FelEruption:IsSpellLearned() and
                A.FelEruption:GetCooldown() <= GetCurrentGCD() and
                A.FelEruption:IsInRange(unit) and
                A.ManaRift:IsSpellLearned() and
                A.ManaRift:IsInRange(unit) and
                A.ManaRift:GetCooldown() <= GetGCD() + GetCurrentGCD() and
                Unit(unit):IsHealer() and
                Player:Fury() >= 60 and
                (
                    Unit(unit):GetCurrentSpeed() > 0 or
                    Unit(unit):InCC() == 0
                ) and
                Unit(unit):HasBuffs("TotalImun") == 0 and
                Unit(unit):HasBuffs("DamageMagicImun") == 0 and
                Unit(unit):HasBuffs("CCTotalImun") == 0 and
                Unit(unit):HasBuffs("CCMagicImun") == 0 and
                Unit(unit):HasBuffs("Reflect") == 0
            then
			    return A.FelEruption
		    end			
			
            -- Mana Rift
			if A.ManaRift:IsReady(unit) and
                A.ManaRift:IsSpellLearned() and
                A.ManaRift:GetCooldown() <= GetCurrentGCD() and
                A.ManaRift:IsInRange(unit) and
                Unit(unit):IsHealer() and
                (
                    (
                       Unit(unit):GetCurrentSpeed() > 0 and
                       Unit(unit):GetCurrentSpeed() <= 40
                    ) or
                    Unit(unit):HasDeBuffs("Stuned") > 1.5 or  
                    (
                        Unit(unit):HasDeBuffs("Rooted") > 1.5 and
                        Unit(unit):GetRealTimeDMG() == 0
                    ) or
                    (
                        select(2, Unit(unit):CastTime()) >= 1.5 and   
                        -- MW
                        not Unit(unit):HasSpec(270) and
                        Unit(unit):GetCurrentSpeed() == 0
                    )
                ) and
                Unit(unit):HasBuffs("TotalImun") == 0 and
                Unit(unit):HasBuffs("DamageMagicImun") == 0 and
                --Unit(unit):HasBuffs("CCTotalImun") == 0 and
                --Unit(unit):HasBuffs("CCMagicImun") == 0 and
                Unit(unit):HasBuffs("Reflect") == 0
            then
			    return A.ManaRift
		    end	
			
            -- Imprison
			local CurrentImprison = A.Detainment:IsSpellLearned() and A.ImprisonImproved or A.Imprison   			
			if CurrentImprison:IsReady(unit) and
                not UnitIsUnit(unit, "target") and
                Unit("player"):HasBuffs(206803, true) == 0 and -- Rain from above
                CurrentImprison:GetCooldown() == 0 and
                CurrentImprison:IsInRange(unit) and 
                (
                   (
                        (
                            -- Detainment
                            A.Detainment:IsSpellLearned() or
                            Unit(unit):GetRealTimeDMG() == 0
                        ) and
                        Unit(unit):HasBuffs("DamageBuffs") > 4 and        
                        Unit(unit):HasDeBuffs("Incapacitated") == 0 and
                        Unit(unit):HasDeBuffs("Disoriented") == 0 and
                        Unit(unit):HasDeBuffs("Stuned") == 0 and
                        Unit(unit):HasDeBuffs("Fear") == 0
                    ) or
                    (
                        (
                            -- Sniper Shot						
                            select(3, Unit(unit):CastTime(203155)) >= 50 or
                            -- Chaos Bolt 
                            select(3, Unit(unit):CastTime(116858)) >= 50 or
                            -- Greatest Pyroblast
                            select(3, Unit(unit):CastTime(203286)) >= 50
                        ) and
                        Unit(unit  .. "target"):Health()<=Unit(unit  .. "target"):HealthMax()*0.6
                    ) or
                    (
                        -- Stop chain CC
                        FriendlyTeam("HEALER"):GetCC() > 0 and
                        FriendlyTeam("HEALER"):GetCC() < 1.8 and
						Unit(unit):MultiCast() > 0
                    )
                ) and
                Unit(unit):HasBuffs("TotalImun") == 0 and
                Unit(unit):HasBuffs("DamageMagicImun") == 0 and
                Unit(unit):HasBuffs("CCTotalImun") == 0 and
                Unit(unit):HasBuffs("CCMagicImun") == 0 and
                Unit(unit):HasBuffs("Reflect") == 0
            then
                return CurrentImprison
            end
             
            -- Imprison Casting BreakAble CC
            if A.ImprisonIsReady(unit) and Unit(unit):IsHealer() then
                return A.Imprison
            end 
			
        end
		
        -- PvP PvE Taunt Mouseover and Pets
        if A.Torment:IsReady("mouseover") and
        (
            (
                Unit("player"):HasSpec(581) and -- Vengeance
                A.GetToggle(2, "mouseover") and
                Action.IsUnitEnemy("mouseover") and
                (
                    (
                        not A.Tormentor:IsSpellLearned() and
                        not Unit("mouseover"):IsPlayer() and
                        CombatTime("mouseover") > 0 and
                        A.Torment:GetCooldown() == 0 and
                        A.Torment:IsInRange("mouseover") and						
                        not Unit("player"):IsTanking("mouseover") and
                        (
                            not Unit("mouseover"):IsExists() or
							not Unit("mouseover"):Role("TANK")
                        ) and
                        (
                            A.Zone ~= "none" or
                            combatTime == 0            
                        )
                    ) or
                    (
                        A.Tormentor:IsSpellLearned() and
                        Unit("mouseover"):IsPlayer() and
                        A.Tormentor:GetCooldown() == 0 and
                        A.Tormentor:IsInRange("mouseover")
                    )
                ) and
                A.Torment:AbsentImun(unit, Temp.TotalAndPhys)
            ) 
			or
            (
                -- Pet Taunt
                A.Zone == "arena" and
                Unit("player"):HasSpec(577) and -- Havoc      
                Unit("player"):HasBuffs(206803, true) == 0 and
                (
                    not Unit("player"):IsFocused() or
                    Unit("player"):GetRealTimeDMG() == 0 or
                    FriendlyTeam("HEALER"):GetCC() > 0
                ) and
                Unit("player"):HasDeBuffs("Rooted") > GetGCD() and
                A.Torment:IsReady("mouseover") and
                EnemyTeam():IsTauntPetAble(281854)				
            )
        )
        then
            return A.Torment
        end	
		
    end 
end 

A[6] = function(icon)
    local Arena = ArenaRotation("arena1")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[7] = function(icon)
    local Arena = ArenaRotation("arena2")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[8] = function(icon)  
    local Arena = ArenaRotation("arena3")
    if Arena then 
        return Arena:Show(icon)
    end 
end
