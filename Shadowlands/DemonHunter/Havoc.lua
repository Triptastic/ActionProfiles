--#####################################
--##### TRIP'S HAVOC DEMON HUNTER #####
--#####################################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
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
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DEMONHUNTER_HAVOC] = {
    -- Racial
    ArcaneTorrent					= Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury						= Action.Create({ Type = "Spell", ID = 20572      }),
    Fireblood						= Action.Create({ Type = "Spell", ID = 265221     }),
    AncestralCall					= Action.Create({ Type = "Spell", ID = 274738     }),
    Berserking						= Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse						= Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm						= Action.Create({ Type = "Spell", ID = 107079     }),
    Haymaker						= Action.Create({ Type = "Spell", ID = 287712     }), 
    WarStomp						= Action.Create({ Type = "Spell", ID = 20549     }),
    BullRush						= Action.Create({ Type = "Spell", ID = 255654     }),  
    GiftofNaaru						= Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld						= Action.Create({ Type = "Spell", ID = 58984    }), -- Used for HoA
    Stoneform						= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks						= Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken				= Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist					= Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself				= Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it

	-- Demon Hunter General
    ConsumeMagic					= Action.Create({ Type = "Spell", ID = 278326	}),
    Disrupt							= Action.Create({ Type = "Spell", ID = 183752	}),
    DisruptGreen					= Action.Create({ Type = "SpellSingleColor", ID = 183752, Color = "GREEN", Desc = "[2] Kick", Hidden = true, QueueForbidden = true	}),	
    ImmolationAura					= Action.Create({ Type = "Spell", ID = 258920	}),
    Imprison						= Action.Create({ Type = "Spell", ID = 217832	}),
    Metamorphosis					= Action.Create({ Type = "Spell", ID = 191427	}),
    MetamorphosisBuff				= Action.Create({ Type = "Spell", ID = 162264, Hidden = true	}),
	SpectralSight					= Action.Create({ Type = "Spell", ID = 188501	}),
    ThrowGlaive						= Action.Create({ Type = "Spell", ID = 185123 	}),
	Torment							= Action.Create({ Type = "Spell", ID = 185245	}),
	ChaosBrand						= Action.Create({ Type = "Spell", ID = 255260, Hidden = true	}),
	DemonicWards					= Action.Create({ Type = "Spell", ID = 278386, Hidden = true	}),
	ShatteredSouls					= Action.Create({ Type = "Spell", ID = 178940, Hidden = true	}),
	DemonSoul						= Action.Create({ Type = "Spell", ID = 163073, Hidden = true	}),
	
	-- Havoc Specific
    BladeDance						= Action.Create({ Type = "Spell", ID = 188499	}),
    DeathSweep                      = Action.Create({ Type = "Spell", ID = 210152	}),	
    Blur							= Action.Create({ Type = "Spell", ID = 198589	}),
    ChaosNova                       = Action.Create({ Type = "Spell", ID = 179057	}),
    ChaosNovaGreen                  = Action.Create({ Type = "SpellSingleColor", ID = 179057, Color = "GREEN", Desc = "[1] CC", Hidden = true, QueueForbidden = true	}),	
    ChaosStrike						= Action.Create({ Type = "Spell", ID = 162794	}),
    Annihilation                    = Action.Create({ Type = "Spell", ID = 201427	}),	
    Darkness						= Action.Create({ Type = "Spell", ID = 196718	}),	
    DemonsBite						= Action.Create({ Type = "Spell", ID = 162243	}),
    EyeBeam							= Action.Create({ Type = "Spell", ID = 198013	}),	
    FelRush							= Action.Create({ Type = "Spell", ID = 195072	}),
    VengefulRetreat					= Action.Create({ Type = "Spell", ID = 198793	}),
	MasteryDemonicPresence			= Action.Create({ Type = "Spell", ID = 185164, Hidden = true	}),		
	FuriousGaze						= Action.Create({ Type = "Spell", ID = 343311, Hidden = true	}),
	FuriousGazeBuff					= Action.Create({ Type = "Spell", ID = 343312, Hidden = true	}),
	
	-- Normal Talents
    BlindFury						= Action.Create({ Type = "Spell", ID = 203550, Hidden = true	}),	
    DemonicAppetite					= Action.Create({ Type = "Spell", ID = 206478, Hidden = true	}),
    Felblade						= Action.Create({ Type = "Spell", ID = 232893	}),
    InsatiableHunger				= Action.Create({ Type = "Spell", ID = 258876, Hidden = true	}),
    BurningHatred					= Action.Create({ Type = "Spell", ID = 320374, Hidden = true	}),
    DemonBlades						= Action.Create({ Type = "Spell", ID = 203555, Hidden = true	}),
    TrailofRuin						= Action.Create({ Type = "Spell", ID = 258881, Hidden = true	}),
    UnboundChaos					= Action.Create({ Type = "Spell", ID = 347461, Hidden = true	}),
	InnerDemon						= Action.Create({ Type = "Spell", ID = 337313, Hidden = true	}),
    GlaiveTempest					= Action.Create({ Type = "Spell", ID = 342817	}),
    SoulRending						= Action.Create({ Type = "Spell", ID = 204909, Hidden = true	}),
    DesperateInstincts				= Action.Create({ Type = "Spell", ID = 205411, Hidden = true	}),
    Netherwalk						= Action.Create({ Type = "Spell", ID = 196555	}),
    CycleofHatred					= Action.Create({ Type = "Spell", ID = 258887, Hidden = true	}),
    FirstBlood						= Action.Create({ Type = "Spell", ID = 206416, Hidden = true	}),
    EssenceBreak					= Action.Create({ Type = "Spell", ID = 258860	}),
    EssenceBreakDebuff				= Action.Create({ Type = "Spell", ID = 320338, Hidden = true	}),	
    UnleashedPower					= Action.Create({ Type = "Spell", ID = 206477, Hidden = true	}),
    MasteroftheGlaive				= Action.Create({ Type = "Spell", ID = 203556, Hidden = true	}),
    FelEruption						= Action.Create({ Type = "Spell", ID = 211881	}),	
    Demonic							= Action.Create({ Type = "Spell", ID = 213410, Hidden = true	}),
    Momentum						= Action.Create({ Type = "Spell", ID = 206476, Hidden = true	}),
    MomentumBuff					= Action.Create({ Type = "Spell", ID = 208628, Hidden = true	}),
	Prepared						= Action.Create({ Type = "Spell", ID = 203650, Hidden = true	}),
    FelBarrage						= Action.Create({ Type = "Spell", ID = 258925	}),

	-- PvP Talents
    CleansedByFire					= Action.Create({ Type = "Spell", ID = 205625, Hidden = true	}),
    ReverseMagic					= Action.Create({ Type = "Spell", ID = 205604	}),
    EyeofLeotheras					= Action.Create({ Type = "Spell", ID = 206649	}),
    ManaRift						= Action.Create({ Type = "Spell", ID = 235903	}),
    DemonicOrigins					= Action.Create({ Type = "Spell", ID = 235893, Hidden = true	}),
    RainfromAbove					= Action.Create({ Type = "Spell", ID = 206803	}),
	Detainment						= Action.Create({ Type = "Spell", ID = 205596, Hidden = true	}),
    ManaBreak						= Action.Create({ Type = "Spell", ID = 203704	}),
    MortalRush						= Action.Create({ Type = "Spell", ID = 328725, Hidden = true	}),
    CoverofDarkness					= Action.Create({ Type = "Spell", ID = 227635, Hidden = true	}),
    UnendingHatred					= Action.Create({ Type = "Spell", ID = 213480, Hidden = true	}),	

	-- Covenant Abilities
    ElysianDecree					= Action.Create({ Type = "Spell", ID = 306830	}),
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    SinfulBrand						= Action.Create({ Type = "Spell", ID = 317009	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    FoddertotheFlame				= Action.Create({ Type = "Spell", ID = 329554	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    TheHunt							= Action.Create({ Type = "Spell", ID = 323639	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits
    DancingWithFate					= Action.Create({ Type = "Spell", ID = 339228, Hidden = true	}),
    RelentlessOnslaught				= Action.Create({ Type = "Spell", ID = 339151, Hidden = true	}),
    GrowingInferno					= Action.Create({ Type = "Spell", ID = 339231, Hidden = true	}),
    SerratedGlaive					= Action.Create({ Type = "Spell", ID = 339230, Hidden = true	}),
    ExposedWound					= Action.Create({ Type = "Spell", ID = 339229, Hidden = true	}),	
    RepeatDecree					= Action.Create({ Type = "Spell", ID = 339895, Hidden = true	}),	
    IncreasedScrutiny				= Action.Create({ Type = "Spell", ID = 340028, Hidden = true	}),
    BroodingPool					= Action.Create({ Type = "Spell", ID = 340063, Hidden = true	}),	
    UnnaturalMalice					= Action.Create({ Type = "Spell", ID = 344358, Hidden = true	}),
    FelDefender						= Action.Create({ Type = "Spell", ID = 338671, Hidden = true	}),	
    ShatteredRestoration			= Action.Create({ Type = "Spell", ID = 338793, Hidden = true	}),
    ViscousInk						= Action.Create({ Type = "Spell", ID = 338682, Hidden = true	}),
    DemonicParole					= Action.Create({ Type = "Spell", ID = 339048, Hidden = true	}),
    FelfireHaste					= Action.Create({ Type = "Spell", ID = 338799, Hidden = true	}),
    LostinDarkness					= Action.Create({ Type = "Spell", ID = 339149, Hidden = true	}),
    RavenousConsumption				= Action.Create({ Type = "Spell", ID = 338835, Hidden = true	}),	
	
	-- Legendaries
	-- General Legendaries
    CollectiveAnguish				= Action.Create({ Type = "Spell", ID = 337504, Hidden = true	}),
    DarkestHour						= Action.Create({ Type = "Spell", ID = 337539, Hidden = true	}),	
    DarkglareBoon					= Action.Create({ Type = "Spell", ID = 337534, Hidden = true	}),
    FelBombardment					= Action.Create({ Type = "Spell", ID = 337775, Hidden = true	}),
	--Havoc Legendaries
    BurningWound					= Action.Create({ Type = "Spell", ID = 346279, Hidden = true	}),
    ChaosTheory						= Action.Create({ Type = "Spell", ID = 337551, Hidden = true	}),
    ChaosTheoryBuff					= Action.Create({ Type = "Spell", ID = 337551, Hidden = true	}),	
    DarkerNature					= Action.Create({ Type = "Spell", ID = 346264, Hidden = true	}),
    ErraticFelCore					= Action.Create({ Type = "Spell", ID = 337685, Hidden = true	}),	

	--Anima Powers - to add later...
	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury	= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralAgility			= Action.Create({ Type = "Potion", ID = 171270, QueueForbidden = true }),
    PotionofSpectralStamina			= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms		= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows			= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire				= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation			= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion			= Action.Create({ Type = "Item", ID = 171267, QueueForbidden = true }),
	AbyssalHealingPotion			= Action.Create({ Type = "Item", ID = 169451, QueueForbidden = true }),
	PhialofSerenity				    = Action.Create({ Type = "Item", ID = 177278 }),
	
	
    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
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

-- Darkness Handler --
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
    if AutoDarkness and HandleDarkness and CanDarkness() then 
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

    -- HealingPotion
    local SpiritualHealingPotion = A.GetToggle(2, "SpiritualHealingPotionHP")
    if     SpiritualHealingPotion >= 0 and A.SpiritualHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            SpiritualHealingPotion >= 100 and 
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
            SpiritualHealingPotion < 100 and 
            Unit(player):HealthPercent() <= SpiritualHealingPotion
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
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
	if castRemainsTime >= A.GetLatency() then
        -- Disrupt
		if useKick and not notInterruptable and A.Disrupt:IsReady(unitID) and A.Disrupt:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
			return A.Disrupt
		end 

        if useCC and A.Imprison:IsReady(unit, nil, nil, true) and A.Imprison:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):IsControlAble("incapacitate", 0) and A.GetToggle(2, "ImprisonAsInterrupt") then
            return A.Imprison                 
        end   
		
        -- Fel Eruption
        if useCC and A.FelEruption:IsTalentLearned() and A.FelEruption:IsReady(unit) and not A.Disrupt:IsReady(unit) and A.FelEruption:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true) then 
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
    local EyeBeamTTD = A.GetToggle(2, "EyeBeamTTD")
    local EyeBeamRange = A.GetToggle(2, "EyeBeamRange")
    local FocusedAzeriteBeamTTD = A.GetToggle(2, "FocusedAzeriteBeamTTD")
    local FocusedAzeriteBeamUnits = A.GetToggle(2, "FocusedAzeriteBeamUnits")    
    local FelBladeRange = A.GetToggle(2, "FelBladeRange")
    local FelBladeFury = A.GetToggle(2, "FelBladeFury")       
    local ImprisonAsInterrupt = A.GetToggle(2, "ImprisonAsInterrupt")          
    local HandleDarkness = HandleDarkness()
    local Fury = Player:Fury()
    local FuryDeficit = Player:FuryDeficit()
    local ImmolationAuraPrePull = Action.GetToggle(2, "ImmolationAuraPrePull")
	local UseMovement = Action.GetToggle(2, "UseMoves")
	local PotionReady = A.GetToggle(1, "Potion") and ((A.PotionofSpectralAgility:IsReady(player) and A.PotionofSpectralAgility:IsExists()) or (A.PotionofUnbridledFury:IsReady(player) and A.PotionofUnbridledFury:IsExists()) or (A.PotionofEmpoweredExorcisms:IsReady(player) and A.PotionofEmpoweredExorcisms:IsExists()) or (A.PotionofPhantomFire:IsReady(player) and A.PotionofPhantomFire:IsExists())  or (A.PotionofDeathlyFixation:IsReady(player) and A.PotionofDeathlyFixation:IsExists()))
	
	--Potions
	local AutoPotionSelect = Action.GetToggle(2, "AutoPotionSelect")
	local PotionTrue = Action.GetToggle(1, "Potion")
	local PotionHeroOnly = Action.GetToggle(2, "PotionHeroOnly")
	local PotionTTD = Unit("target"):TimeToDie() > Action.GetToggle(2, "PotionTTD")
	local PotionMetaOnly = Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and A.GetToggle(2, "PotionMetaOnly")
	
	
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
    
    -- Start Rotation
    local function EnemyRotation(unit)     

		--#####################
		--##### VARIABLES #####
		--#####################

		--actions+=/variable,name=blade_dance,value=talent.first_blood.enabled|spell_targets.blade_dance1>=(3-(talent.trail_of_ruin.enabled+buff.metamorphosis.up))|runeforge.chaos_theory&buff.chaos_theory.down
		VarBladeDance = A.FirstBlood:IsTalentLearned() or (MultiUnits:GetByRange(8, 3) >= (3 - num(A.TrailofRuin:IsTalentLearned()) + num(Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 0))) or (Player:HasLegendaryCraftingPower(A.ChaosTheory) and Unit(player):HasBuffs(A.ChaosTheoryBuff.ID, true) == 0)

		--actions+=/variable,name=pooling_for_meta,value=!talent.demonic.enabled&cooldown.metamorphosis.remains<6&fury.deficit>30		
        VarPoolingForMeta = not A.Demonic:IsTalentLearned() and A.Metamorphosis:GetCooldown() < 6 and FuryDeficit > 30         
		
		--actions+=/variable,name=pooling_for_blade_dance,value=variable.blade_dance&(fury<75-talent.first_blood.enabled*20)           
        VarPoolingForBladeDance = VarBladeDance and (Fury < 75 - (num(A.FirstBlood:IsTalentLearned())*20))       
		
        -- actions+=/variable,name=pooling_for_eye_beam,value=talent.demonic.enabled&!talent.blind_fury.enabled&cooldown.eye_beam.remains<(gcd.max*2)&fury.deficit>20
        VarPoolingForEyeBeam = A.Demonic:IsTalentLearned() and (not A.BlindFury:IsTalentLearned()) and A.EyeBeam:GetCooldown() < (A.GetGCD() * 2) and FuryDeficit > 20
		
		--[[ Low Pooling for Eye Beam
		VarLowPoolForEyeBeam = A.Demonic:IsTalentLearned() and not A.BlindFury:IsTalentLearned() and A.EyeBeam:GetCooldown() < (A.GetGCD() * 2) and FuryDeficit > 75]]
        
		-- actions+=/variable,name=waiting_for_essence_break,value=talent.essence_break.enabled&!variable.pooling_for_blade_dance&!variable.pooling_for_meta&cooldown.essence_break.up
        VarWaitingForEssenceBreak = A.EssenceBreak:IsTalentLearned() and (not VarPoolingForBladeDance) and (not VarPoolingForMeta) and A.EssenceBreak:GetCooldown() < 1          
        
		-- actions+=/variable,name=waiting_for_momentum,value=talent.momentum.enabled&!buff.momentum.up
        VarWaitingForMomentum = A.Momentum:IsTalentLearned() and Unit(player):HasBuffs(A.MomentumBuff.ID, true) == 0
		
		--VengefulRetreat + Fel Rush combo ----- this actually sucks... Vengeful Retreat jumps back further than Fel Rush dashes forward
		MovementComboReady = Unit("target"):GetRange() <= 2 and inCombat and A.VengefulRetreat:IsReady("player") and A.FelRush:IsReady("player") and Unit("player"):HasBuffs(A.InnerDemon.ID, true) > 0  and UseMovement
		MovementComboSoon = Unit("target"):GetRange() <= 2 and inCombat and A.VengefulRetreat:GetCooldown() < 3 and A.FelRush:GetCooldown() < 3 and (Unit("player"):HasBuffs(A.InnerDemon.ID, true) > 0 or (A.ImmolationAura:GetCooldown() <= 2 and A.UnboundChaos:IsTalentLearned()))  and UseMovement
		
        --#########################
		--##### NOTIFICATIONS #####
		--#########################
		
		--Announce Movement Combo soon
		if MovementComboSoon
		then
			A.Toaster:SpawnByTimer("TripToast", 0, "Movement Combo Ready!", "Get prepared!", A.VengefulRetreat.ID)
		end
		
		--Announce Vengeful Retreat for Prepared buff
		if inCombat and A.VengefulRetreat:GetCooldown() < 3 and A.Momentum:IsTalentLearned() and A.Felblade:GetCooldown() < 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Vengeful Retreat!", "Gonna backflip soon! Get ready!", A.VengefulRetreat.ID)
		end	
		
		--Announce Fel Rush
		if inCombat and A.FelRush:GetSpellChargesFrac() > 1.8 and A.Momentum:IsTalentLearned() then
			A.Toaster:SpawnByTimer("TripToast", 0, "Fel Rush!", "Gonna dash like a madman! Get ready!", A.FelRush.ID)
		end
		
		--##########################
		--##### MOVEMENT COMBO ##### -- Actual garbage in game - need to revisit this.
		--##########################
		
		-- unbound chaos
		if MovementComboReady and A.EyeBeam:GetCooldown() > 3 and ((BurstIsON(unit) and A.Metamorphosis:GetCooldown() > 5) or not BurstIsON(unit))
		then
			return A.VengefulRetreat:Show(icon)
		end	
		
		if A.FelRush:IsReady("player") and inCombat and Unit("target"):GetRange() >= 10 and Unit("player"):HasBuffs(A.InnerDemon.ID, true) > 0 and UseMovement then
			return A.FelRush:Show(icon)
		end		
		
		--#####################
		--##### UTILITIES #####
		--#####################
		
        -- Purge
        if inCombat and A.ArcaneTorrent:AutoRacial(unitID, true) and AuraIsValid(unit, "UsePurge", "Dispel") then 
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
        if inCombat and CanCast and Interrupt then 
            return Interrupt:Show(icon)
        end 
        
        -- Custom Katherine tentacle handler
        if inCombat and UnitName(unit) == "Twisted Appendage" and A.DemonsBite:IsReady(unit) and not A.DemonBlades:IsTalentLearned() and CanCast then
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
		
		
		--#####################
		--##### PRECOMBAT #####
		--#####################
		
        --Precombat
		
		local function PrecombatCall()

            -- immolation_aura
            if A.ImmolationAura:IsReady(unit) and A.UnboundChaos:IsTalentLearned() then
                return A.ImmolationAura:Show(icon)
            end    
            
            -- Arcane Torrent dispell or if FuryDeficit >= 30
            if A.ArcaneTorrent:IsRacialReady(unit) and BurstIsON(unit) and Action.GetToggle(1, "Racial") and (Pull > 0.1 and Pull <= 2 or not Action.GetToggle(1, "BossMods")) 
            then
                return A.ArcaneTorrent:Show(icon)
            end           
            
            -- Failsafe if nothing else is ready.
            if A.DemonsBite:IsReady(unit) then
                return A.DemonsBite:Show(icon)
            end
		
		end
                       
          
		--##################### 
		--##### COOLDOWNS #####
		--#####################
		  
		local function CooldownCall()
			--actions.cooldown=metamorphosis,if=!(talent.demonic.enabled|variable.pooling_for_meta)&(!covenant.venthyr.enabled|!dot.sinful_brand.ticking)|target.time_to_die<25
			if A.Metamorphosis:IsReady(unit) and (not (A.Demonic:IsTalentLearned() or VarPoolingForMeta)) and (Player:GetCovenant() ~= 2 or Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0) and not Action.GetToggle(2, "PotionMetaOnly") then
				return A.Metamorphosis:Show(icon)
			end		
			
			if A.Metamorphosis:IsReady(unit) and (not (A.Demonic:IsTalentLearned() or VarPoolingForMeta)) and (Player:GetCovenant() ~= 2 or Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0) and PotionReady then
				return A.Metamorphosis:Show(icon)
			end					
			--actions.cooldown+=/metamorphosis,if=talent.demonic.enabled&(!azerite.chaotic_transformation.enabled&level<54|(cooldown.eye_beam.remains>20&(!variable.blade_dance|cooldown.blade_dance.remains>gcd.max)))&(!covenant.venthyr.enabled|!dot.sinful_brand.ticking)
			if A.Metamorphosis:IsReady(unit) and A.EyeBeam:GetCooldown() > 20 and (not VarBladeDance or A.BladeDance:GetCooldown() > A.GetGCD()) and (Player:GetCovenant() ~= 2 or Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0) and not Action.GetToggle(2, "PotionMetaOnly") then
				return A.Metamorphosis:Show(icon)
			end 
			
			if A.Metamorphosis:IsReady(unit) and A.EyeBeam:GetCooldown() > 20 and (not VarBladeDance or A.BladeDance:GetCooldown() > A.GetGCD()) and (Player:GetCovenant() ~= 2 or Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0) and PotionReady then
				return A.Metamorphosis:Show(icon)
			end 			

			--Trinket 1
            if A.Trinket1:IsReady(unit) then
                return A.Trinket1:Show(icon)    
            end
            
			--Trinket 2
            if A.Trinket2:IsReady(unit) then
                return A.Trinket2:Show(icon)    
            end
		
			--actions.cooldown+=/potion,if=buff.metamorphosis.remains>25|target.time_to_die<60
			-- Unbridled Fury
            if A.PotionofUnbridledFury:IsReady(unit) and AutoPotionSelect == "UnbridledFuryPot" and PotionTrue and ((Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and PotionMetaOnly) or (PotionHeroOnly and Unit("player"):HasHeroism())) and PotionTTD
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofUnbridledFury.ID)  
                return A.PotionofUnbridledFury:Show(icon)
            end

			-- Spectral Agility
            if A.PotionofSpectralAgility:IsReady(unit) and AutoPotionSelect == "SpectralAgilityPot" and PotionTrue and ((Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and PotionMetaOnly) or (PotionHeroOnly and Unit("player"):HasHeroism())) and PotionTTD
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofSpectralAgility.ID)  
                return A.PotionofSpectralAgility:Show(icon)
            end

			-- Empowered Exorcisms
            if A.PotionofEmpoweredExorcisms:IsReady(unit) and AutoPotionSelect == "EmpoweredExorcismsPot" and PotionTrue and ((Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and PotionMetaOnly) or (PotionHeroOnly and Unit("player"):HasHeroism())) and PotionTTD
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofEmpoweredExorcisms.ID)  
                return A.PotionofEmpoweredExorcisms:Show(icon)
            end

			-- Phantom Fire
            if A.PotionofPhantomFire:IsReady(unit) and AutoPotionSelect == "PhantomFirePot" and PotionTrue and ((Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and PotionMetaOnly) or (PotionHeroOnly and Unit("player"):HasHeroism())) and PotionTTD
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofPhantomFire.ID)  
                return A.PotionofPhantomFire:Show(icon)
            end

			-- Deathly Fixation
            if A.PotionofDeathlyFixation:IsReady(unit) and AutoPotionSelect == "DeathlyFixationPot" and PotionTrue and ((Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) > 25 and PotionMetaOnly) or (PotionHeroOnly and Unit("player"):HasHeroism())) and PotionTTD
            then
                -- Notification                    
                A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofDeathlyFixation.ID)  
                return A.PotionofDeathlyFixation:Show(icon)
            end	
		
		end


		--#################### 
		--##### COVENANT #####
		--####################
		
		local function CovenantCall()
			
			--actions.cooldown+=/sinful_brand,if=!dot.sinful_brand.ticking
			if A.SinfulBrand:IsReady(unit) and Unit(unit):HasDeBuffs(A.SinfulBrand.ID, true) == 0 and not Player:PrevGCD(1, A.Metamorphosis) then
				return A.SinfulBrand:Show(icon)
			end	
			
			--actions.cooldown+=/the_hunt,if=!talent.demonic.enabled&!variable.waiting_for_momentum|buff.furious_gaze.up
			if A.TheHunt:IsReady(unit) and ((not A.Demonic:IsTalentLearned() and not VarWaitingForMomentum) or Unit(player):HasBuffs(A.FuriousGazeBuff.ID, true) > 0) then
				return A.TheHunt:Show(icon)
			end	

			--Fleshcraft
			if A.Fleshcraft:IsReady(player) and Player:IsStayingTime() > 0.5 and Unit("player"):CombatTime() > 0 and (Unit("player"):IsExecuted() or (Unit("player"):HealthPercent() <= 40 and Unit("player"):TimeToDie() < 8)) then 
			A.Toaster:SpawnByTimer("TripToast", 0, "Fleshcraft!", "Using Fleshcraft defensively! Don't move!", A.Fleshcraft.ID)			
				return A.Fleshcraft:Show(icon)
			end 
			
			--actions.cooldown+=/fodder_to_the_flame
			if A.FoddertotheFlame:IsReady(unit) then
			A.Toaster:SpawnByTimer("TripToast", 0, "Fodder to the Flame!", "You've spawned a demon! Kill it!", A.FoddertotheFlame.ID)			
				return A.FoddertotheFlame:Show(icon)
			end	
			
			--actions.cooldown+=/elysian_decree
			if A.ElysianDecree:IsReady(player) and Player:IsStayingTime() > 0.5 and A.MultiUnits:GetByRange(5, 3) >= 2 and Unit(unit):TimeToDie() > 5 then
				return A.ElysianDecree:Show(icon)
			end	

			--actions.cooldown+=/elysian_decree
			if A.ElysianDecree:IsReady(player) and Player:IsStayingTime() > 0.5 and Unit(unit):GetRange() <= 5 and Unit(unit):IsBoss() then
				return A.ElysianDecree:Show(icon)
			end					
		
		end

		--################################## 
		--##### ESSENCE BREAK ROTATION #####
		--##################################		

		local function EssenceBreakCall()	
		
			--actions.essence_break=essence_break,if=fury>=80&(cooldown.blade_dance.ready|!variable.blade_dance)
			if A.EssenceBreak:IsReady(unitID) and Fury >= 80 and (A.BladeDance:IsReady(unit) or not VarBladeDance) then
				return A.EssenceBreak:Show(icon)
			end
			
			--actions.essence_break+=/death_sweep,if=variable.blade_dance&debuff.essence_break.up
			if A.DeathSweep:IsReady(unitID) and VarBladeDance and Unit(unit):HasDeBuffs(A.EssenceBreakDebuff.ID, true) > 0 and Unit(unit):GetRange() <= 8 then
				return A.DeathSweep:Show(icon)
			end	
			
			--actions.essence_break+=/blade_dance,if=variable.blade_dance&debuff.essence_break.up
			if A.BladeDance:IsReady(unitID) and VarBladeDance and Unit(unit):HasDeBuffs(A.EssenceBreakDebuff.ID, true) > 0 and Unit(unit):GetRange() <= 8 then
				return A.BladeDance:Show(icon)
			end	
			
			--actions.essence_break+=/annihilation,if=debuff.essence_break.up
			if A.Annihilation:IsReady(unit) and Unit(unit):HasDeBuffs(A.EssenceBreakDebuff.ID, true) > 0 then
				return A.Annihilation:Show(icon)
			end
			
			--actions.essence_break+=/chaos_strike,if=debuff.essence_break.up
			if A.ChaosStrike:IsReady(unit) and Unit(unit):HasDeBuffs(A.EssenceBreakDebuff.ID, true) > 0 then
				return A.ChaosStrike:Show(icon)
			end	
		
		end

		--############################ 
		--##### DEMONIC ROTATION #####
		--############################

		local function DemonicCall()
		
			--[[actions.demonic=fel_rush,if=(talent.unbound_chaos.enabled&buff.unbound_chaos.up)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
			if A.FelRush:IsReady(unitID, true) and (A.UnboundChaos:IsTalentLearned() and Unit(player):HasBuffs(A.InnerDemon.ID, true) > 0) and A.FelRush:GetSpellCharges() > 1 and UseMovement then
				return A.FelRush:Show(icon)
			end]]
			
			--[[Pseudo EssenceBreak
			if A.EssenceBreak:IsReady(player) and Unit(unit):HasDeBuffs(A.EssenceBreak.ID, true) == 0 then
				return A.EssenceBreak:Show(icon)
			end	]]
			
			--actions.demonic+=/death_sweep,if=variable.blade_dance
			if A.DeathSweep:IsReady(unit) and VarBladeDance and Unit(unit):GetRange() <= 8 then
				return A.DeathSweep:Show(icon)
			end
			
			--actions.demonic+=/glaive_tempest,if=active_enemies>desired_targets|raid_event.adds.in>10
			if A.GlaiveTempest:IsReady(unit) and Player:IsStayingTime() > 0.5 and (A.MultiUnits:GetByRange(5) >= 2 or (Unit(unit):IsBoss() and Unit(unit):GetRange() <= 5)) then
				return A.GlaiveTempest:Show(icon)
			end	
			
			--actions.demonic+=/throw_glaive,if=conduit.serrated_glaive.enabled&cooldown.eye_beam.remains<6&!buff.metamorphosis.up&!debuff.exposed_wound.up
			if A.ThrowGlaive:IsReady(unit) and A.SerratedGlaive:IsSoulbindLearned() and A.EyeBeam:GetCooldown() < 6 and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0 and Unit(unit):HasDeBuffs(A.ExposedWound.ID, true) == 0 then
				return A.ThrowGlaive:Show(icon)
			end	
			
			--actions.demonic+=/eye_beam,if=raid_event.adds.up|raid_event.adds.in>25
            if A.EyeBeam:IsReady(unitID, true) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and A.Demonic:IsSpellLearned() and HandleEyeBeam() and Unit(unit):GetRange() <= EyeBeamRange and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)               
                return A.EyeBeam:Show(icon)
            end    
			--actions.demonic+=/blade_dance,if=variable.blade_dance&!cooldown.metamorphosis.ready&(cooldown.eye_beam.remains>(5-azerite.revolving_blades.rank*3)|(raid_event.adds.in>cooldown&raid_event.adds.in<25))
			if A.BladeDance:IsReady(unitID) and VarBladeDance and ((not A.Metamorphosis:IsReadyByPassCastGCD() and BurstIsON(unit)) or not BurstIsON(unit)) and A.EyeBeam:GetCooldown() > 5 and Unit(unit):GetRange() <= 8 then
				return A.BladeDance:Show(icon)
			end	
			
			--actions.demonic+=/immolation_aura
			if A.ImmolationAura:IsReady(unitID, true) then
				return A.ImmolationAura:Show(icon)
			end	
			
			--actions.demonic+=/annihilation,if=!variable.pooling_for_blade_dance
			if A.Annihilation:IsReady(unit) and not VarPoolingForBladeDance then
				return A.Annihilation:Show(icon)
			end	
			
			--actions.demonic+=/felblade,if=fury.deficit>=40
			if A.Felblade:IsReady(unit) and Fury <= FelBladeFury and Unit(unit):GetRange() <= FelBladeRange and HandleFelBlade() then
				return A.Felblade:Show(icon)
			end	
			--actions.demonic+=/chaos_strike,if=!variable.pooling_for_blade_dance&!variable.pooling_for_eye_beam
			if A.ChaosStrike:IsReady(unit) and not VarPoolingForBladeDance and not VarLowPoolForEyeBeam then
				return A.ChaosStrike:Show(icon)
			end	
			
			--[[actions.demonic+=/fel_rush,if=talent.demon_blades.enabled&!cooldown.eye_beam.ready&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
			if A.FelRush:IsReady(unitID, true) and UseMovement and A.DemonBlades:IsTalentLearned() and A.EyeBeam:GetCooldown() > 0 and A.FelRush:GetSpellCharges() > 1 then
				return A.FelRush:Show(icon)
			end	]]
			--actions.demonic+=/demons_bite,target_if=min:debuff.burning_wound.remains,if=runeforge.burning_wound.equipped&debuff.burning_wound.remains<4
			if A.DemonsBite:IsReady(unit) and Player:HasLegendaryCraftingPower(A.BurningWound) and Unit(unit):HasDeBuffs(A.BurningWound.ID, true) < 4 then
				return A.DemonsBite:Show(icon)
			end	
			
			--actions.demonic+=/demons_bite
			if A.DemonsBite:IsReady(unit) then
				return A.DemonsBite:Show(icon)
			end	
			
			--actions.demonic+=/throw_glaive,if=buff.out_of_range.up
			if A.ThrowGlaive:IsReady(unit) and Unit(unit):GetRange() >= 8 then
				return A.ThrowGlaive:Show(icon)
			end
			
			--actions.demonic+=/fel_rush,if=movement.distance>15|buff.out_of_range.up
			--This can cause problems... Best to leave for now
			
			--actions.demonic+=/vengeful_retreat,if=movement.distance>15
			--Can also cause problems.
			
			--actions.demonic+=/throw_glaive,if=talent.demon_blades.enabled	
			if A.ThrowGlaive:IsReady(unit) and A.DemonBlades:IsTalentLearned() then
				return A.ThrowGlaive:Show(icon)
			end			
		
		end

		--###########################
		--##### NORMAL ROTATION #####
		--###########################

		local function NormalCall()
		
			if A.Felblade:IsReady(unit) and (A.LastPlayerCastID == A.VengefulRetreat.ID or A.LastPlayerCastID == A.FelRush.ID) and Unit(unit):GetRange() > 5 then
				return A.Felblade:Show(icon)
			end	
		
			if A.LastPlayerCastID == A.VengefulRetreat.ID then
				if A.Felblade:IsReady(unit) and A.FelRush:GetSpellChargesFrac() < 1.8 then
					return A.Felblade:Show(icon)
				elseif A.FelRush:IsReady(unitID, true) then
					return A.FelRush:Show(icon)
				end
			end
		
			--actions.normal=vengeful_retreat,if=talent.momentum.enabled&buff.prepared.down&time>1
			if A.VengefulRetreat:IsReady(unitID) and CanCast and UseMovement and A.Momentum:IsTalentLearned() and Unit(player):HasBuffs(A.Prepared.ID, true) == 0 and inCombat and Unit(unit):GetRange() <= 5 and (A.Felblade:GetCooldown() < 1 or A.FelRush:GetSpellChargesFrac() > 1.8) then
				return A.VengefulRetreat:Show(icon)
			end	
			
			--actions.normal+=/fel_rush,if=(variable.waiting_for_momentum|talent.unbound_chaos.enabled&buff.unbound_chaos.up)&(charges=2|(raid_event.movement.in>10&raid_event.adds.in>10))
			if A.FelRush:IsReady(unitID, true) and UseMovement and inCombat and (VarWaitingForMomentum or (A.UnboundChaos:IsTalentLearned() and Unit(player):HasBuffs(A.InnerDemon.ID, true) > 0)) and A.FelRush:GetSpellChargesFrac() > 1.8 then
				return A.FelRush:Show(icon)
			end

			--[[Pseudo EssenceBreak
			if A.EssenceBreak:IsReady(player) and Unit(unit):HasDeBuffs(A.EssenceBreak.ID, true) == 0 then
				return A.EssenceBreak:Show(icon)
			end	]]
			
			--actions.normal+=/fel_barrage,if=active_enemies>desired_targets|raid_event.adds.in>30
			if A.FelBarrage:IsReady(unitID, true) and MultiUnits:GetByRange(8) >= 2 then
				return A.FelBarrage:Show(icon)
			end			
			
			--actions.normal+=/death_sweep,if=variable.blade_dance
			if A.DeathSweep:IsReady(unitID) and VarBladeDance and Unit(unit):GetRange() <= 8 then
				return A.DeathSweep:Show(icon)
			end	
			
			--actions.normal+=/immolation_aura
			if A.ImmolationAura:IsReady(unitID, true) then
				return A.ImmolationAura:Show(icon)
			end	
			--actions.normal+=/glaive_tempest,if=!variable.waiting_for_momentum&(active_enemies>desired_targets|raid_event.adds.in>10)
			if A.GlaiveTempest:IsReady(unit) and Player:IsStayingTime() > 0.5 and (not VarWaitingForMomentum) and (A.MultiUnits:GetByRange(5) >= 2 or Unit(unit):IsBoss()) then
				return A.GlaiveTempest:Show(icon)
			end	
			
			--actions.normal+=/throw_glaive,if=conduit.serrated_glaive.enabled&cooldown.eye_beam.remains<6&!buff.metamorphosis.up&!debuff.exposed_wound.up
			if A.ThrowGlaive:IsReady(unit) and A.SerratedGlaive:IsSoulbindLearned() and A.EyeBeam:GetCooldown() < 6 and Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0 and Unit(unit):HasDeBuffs(A.ExposedWound.ID, true) == 0 then
				return A.ThrowGlaive:Show(icon)
			end	 
			
			--actions.normal+=/eye_beam,if=active_enemies>1&(!raid_event.adds.exists|raid_event.adds.up)&!variable.waiting_for_momentum
            if A.EyeBeam:IsReady(unitID, true) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and HandleEyeBeam() and Unit(unit):GetRange() <= EyeBeamRange and MultiUnits:GetByRange(5) >= 2 and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) and not VarWaitingForMomentum then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)               
                return A.EyeBeam:Show(icon)
            end    
			
			--actions.normal+=/blade_dance,if=variable.blade_dance
			if A.BladeDance:IsReady(unitID) and VarBladeDance and Unit(unit):GetRange() <= 8 then
				return A.BladeDance:Show(icon)
			end	
			
			--actions.normal+=/felblade,if=fury.deficit>=40
			if A.Felblade:IsReady(unit) and Fury <= FelBladeFury and Unit(unit):GetRange() <= FelBladeRange and HandleFelBlade() then
				return A.Felblade:Show(icon)
			end	
			--actions.normal+=/annihilation,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30|buff.metamorphosis.remains<5)&!variable.pooling_for_blade_dance&!variable.waiting_for_essence_break
			if A.Annihilation:IsReady(unit) and (A.DemonBlades:IsTalentLearned() or not VarWaitingForMomentum or FuryDeficit < 30 or Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) < 5) and not VarPoolingForBladeDance and not VarWaitingForEssenceBreak then
				return A.Annihilation:Show(icon)
			end	
			
			--actions.normal+=/chaos_strike,if=(talent.demon_blades.enabled|!variable.waiting_for_momentum|fury.deficit<30)&!variable.pooling_for_meta&!variable.pooling_for_blade_dance&!variable.waiting_for_essence_break
			if A.ChaosStrike:IsReady(unit) and (A.DemonBlades:IsTalentLearned() or not VarWaitingForMomentum or FuryDeficit < 30) and not VarPoolingForMeta and not VarPoolingForBladeDance and not VarWaitingForEssenceBreak then
				return A.ChaosStrike:Show(icon)
			end
			
			--actions.normal+=/eye_beam,if=!talent.blind_fury.enabled&!variable.waiting_for_essence_break&raid_event.adds.in>cooldown
            if A.EyeBeam:IsReady(unitID, true) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and HandleEyeBeam() and Unit(unit):GetRange() <= EyeBeamRange and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) and not A.BlindFury:IsTalentLearned() and not VarWaitingForEssenceBreak then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)               
                return A.EyeBeam:Show(icon)
            end    
			
			
			--actions.normal+=/eye_beam,if=talent.blind_fury.enabled&raid_event.adds.in>cooldown
            if A.EyeBeam:IsReady(unitID, true) and not ShouldDelayEyeBeam() and not Unit(unit):IsDead() and HandleEyeBeam() and A.BlindFury:IsTalentLearned() and Unit(unit):GetRange() <= EyeBeamRange and (Unit(unit):TimeToDie() > EyeBeamTTD or Unit(unit):IsBoss()) then
                -- Notification                    
				A.Toaster:SpawnByTimer("TripToast", 0, "Eye Beam!", "Stop moving!", A.EyeBeam.ID)               
                return A.EyeBeam:Show(icon)
            end			
			
			--actions.normal+=/demons_bite,target_if=min:debuff.burning_wound.remains,if=runeforge.burning_wound.equipped&debuff.burning_wound.remains<4
			if A.DemonsBite:IsReady(unit) and Player:HasLegendaryCraftingPower(A.BurningWound) and Unit(unit):HasDeBuffs(A.BurningWound.ID, true) < 4 then
				return A.DemonsBite:Show(icon)
			end				
			
			--actions.normal+=/demons_bite
			if A.DemonsBite:IsReady(unit) then
				return A.DemonsBite:Show(icon)
			end	
			
			--actions.normal+=/fel_rush,if=!talent.momentum.enabled&raid_event.movement.in>charges*10&talent.demon_blades.enabled
			if A.FelRush:IsReady(unitID, true) and UseMovement and inCombat and not A.Momentum:IsTalentLearned() and A.FelRush:GetSpellCharges() > 1 and A.DemonBlades:IsTalentLearned() then
				return A.FelRush:Show(icon)
			end
			
			--actions.normal+=/felblade,if=movement.distance>15|buff.out_of_range.up
			if A.Felblade:IsReady(unit) and Fury <= FelBladeFury and Unit(unit):GetRange() <= FelBladeRange and HandleFelBlade() then
				return A.Felblade:Show(icon)
			end	
			
			--actions.normal+=/fel_rush,if=movement.distance>15|(buff.out_of_range.up&!talent.momentum.enabled)
			--No.
			
			--actions.normal+=/vengeful_retreat,if=movement.distance>15
			--Still no.
			
			--actions.normal+=/throw_glaive,if=talent.demon_blades.enabled		
			if A.ThrowGlaive:IsReady(unit) and A.DemonBlades:IsTalentLearned() then
				return A.ThrowGlaive:Show(icon)
			end	
		
		end


		--#############################
		--##### ACTION LIST CALLS #####
		--#############################

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
		
		--Precombat
        if not inCombat and Unit(unit):IsExists() then
			return PrecombatCall()
		end
		
		if inCombat and Unit(unit):GetRange() > 10 and A.Felblade:IsReady(unit) then
			return A.Felblade:Show(icon)
		end	
		
		--actions+=/call_action_list,name=cooldown,if=gcd.remains=0
		if inCombat and BurstIsON(unit) and CooldownCall() then
			return true
		end	
		
		--Covenant Call
		if inCombat and A.GetToggle(1, "Covenant") and CovenantCall() and Unit("target"):TimeToDie() > 8 then
			return true
		end
		
		--actions+=/pick_up_fragment,if=demon_soul_fragments>0
		
		--actions+=/pick_up_fragment,if=fury.deficit>=35&(!azerite.eyes_of_rage.enabled|cooldown.eye_beam.remains>1.4)

		
		--actions+=/throw_glaive,if=buff.fel_bombardment.stack=5&(buff.immolation_aura.up|!buff.metamorphosis.up)
		if A.ThrowGlaive:IsReady(unit) and Unit(player):HasBuffsStacks(A.FelBombardment.ID, true) > 4 and (Unit(player):HasBuffs(A.ImmolationAura.ID, true) > 0 or Unit(player):HasBuffs(A.MetamorphosisBuff.ID, true) == 0) then
			return A.ThrowGlaive:Show(icon)
		end 
		
		--actions+=/call_action_list,name=essence_break,if=talent.essence_break.enabled&(variable.waiting_for_essence_break|debuff.essence_break.up)
		if VarWaitingForEssenceBreak or Unit(unit):HasDeBuffs(A.EssenceBreakDebuff.ID, true) > 0 then
			if EssenceBreakCall() then
				return true
			end
		end
		
		--actions+=/run_action_list,name=demonic,if=talent.demonic.enabled
		if A.Demonic:IsTalentLearned() then
			return DemonicCall()
		end	
		
		--actions+=/run_action_list,name=normal		
        if not A.Demonic:IsTalentLearned() then
			return NormalCall()
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
A[4] = nil

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
                A.FelEruption:IsTalentLearned() and
                A.FelEruption:GetCooldown() <= GetCurrentGCD() and
                A.FelEruption:IsInRange(unit) and
                A.ManaRift:IsTalentLearned() and
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
                A.ManaRift:IsTalentLearned() and
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
			local CurrentImprison = A.Detainment:IsTalentLearned() and A.ImprisonImproved or A.Imprison   			
			if CurrentImprison:IsReady(unit) and
                not UnitIsUnit(unit, "target") and
                Unit("player"):HasBuffs(206803, true) == 0 and -- Rain from above
                CurrentImprison:GetCooldown() == 0 and
                CurrentImprison:IsInRange(unit) and 
                (
                   (
                        (
                            -- Detainment
                            A.Detainment:IsTalentLearned() or
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
                        not A.Tormentor:IsTalentLearned() and
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
                        A.Tormentor:IsTalentLearned() and
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
