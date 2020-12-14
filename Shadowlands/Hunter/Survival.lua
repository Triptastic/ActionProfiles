--##################################
--##### TRIP'S SURVIVAL HUNTER #####
--##################################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener									= Action.Listener
local Create									= Action.Create
local GetToggle									= Action.GetToggle
local SetToggle									= Action.SetToggle
local GetGCD									= Action.GetGCD
local GetCurrentGCD								= Action.GetCurrentGCD
local GetPing									= Action.GetPing
local ShouldStop								= Action.ShouldStop
local BurstIsON									= Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid								= Action.AuraIsValid
local InterruptIsValid							= Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils										= Action.Utils
local TeamCache									= Action.TeamCache
local EnemyTeam									= Action.EnemyTeam
local FriendlyTeam								= Action.FriendlyTeam
local LoC										= Action.LossOfControl
local Player									= Action.Player
local Pet                                       = LibStub("PetLibrary") 
local MultiUnits								= Action.MultiUnits
local UnitCooldown								= Action.UnitCooldown
local Unit										= Action.Unit 
local IsUnitEnemy								= Action.IsUnitEnemy
local IsUnitFriendly							= Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_HUNTER_SURVIVAL] = {
	--Racial 
    ArcaneTorrent				= Action.Create({ Type = "Spell", ID = 50613	}),
    BloodFury					= Action.Create({ Type = "Spell", ID = 20572	}),
    Fireblood					= Action.Create({ Type = "Spell", ID = 265221	}),
    AncestralCall				= Action.Create({ Type = "Spell", ID = 274738	}),
    Berserking					= Action.Create({ Type = "Spell", ID = 26297	}),
    ArcanePulse             	= Action.Create({ Type = "Spell", ID = 260364	}),
    QuakingPalm           		= Action.Create({ Type = "Spell", ID = 107079	}),
    Haymaker           			= Action.Create({ Type = "Spell", ID = 287712	}), 
    BullRush           			= Action.Create({ Type = "Spell", ID = 255654	}),    
    WarStomp        			= Action.Create({ Type = "Spell", ID = 20549	}),
    GiftofNaaru   				= Action.Create({ Type = "Spell", ID = 59544	}),
    Shadowmeld   				= Action.Create({ Type = "Spell", ID = 58984    }),
    Stoneform 					= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks					= Action.Create({ Type = "Spell", ID = 312411	}),
    WilloftheForsaken			= Action.Create({ Type = "Spell", ID = 7744		}),   
    EscapeArtist				= Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself			= Action.Create({ Type = "Spell", ID = 59752    }),
    LightsJudgment				= Action.Create({ Type = "Spell", ID = 255647   }), 	
	
	--Hunter General
    ArcaneShot			    	= Action.Create({ Type = "Spell", ID = 185358	}),
    AspectoftheCheetah	    	= Action.Create({ Type = "Spell", ID = 186257	}),	
    AspectoftheTurtle	    	= Action.Create({ Type = "Spell", ID = 186265	}),
    CallPet				    	= Action.Create({ Type = "Spell", ID = 883, Texture = 136		}),	
    Disengage			    	= Action.Create({ Type = "Spell", ID = 781		}),	
    EagleEye			    	= Action.Create({ Type = "Spell", ID = 6197		}),	
    Exhilaration		    	= Action.Create({ Type = "Spell", ID = 109304	}),	
    EyesoftheBeast		    	= Action.Create({ Type = "Spell", ID = 321297	}),	
    FeignDeath			    	= Action.Create({ Type = "Spell", ID = 5384		}),	
    Fetch				    	= Action.Create({ Type = "Spell", ID = 125050	}),
    Flare				    	= Action.Create({ Type = "Spell", ID = 1543		}),
    FreezingTrap		    	= Action.Create({ Type = "Spell", ID = 187650	}),	
    HuntersMark			    	= Action.Create({ Type = "Spell", ID = 257284	}),
    KillShot			    	= Action.Create({ Type = "Spell", ID = 53351	}),
    MastersCall			    	= Action.Create({ Type = "Spell", ID = 272682	}),
    Misdirection		    	= Action.Create({ Type = "Spell", ID = 34477	}),	
    MendPet				    	= Action.Create({ Type = "Spell", ID = 982		}),		
    ScareBeast			    	= Action.Create({ Type = "Spell", ID = 1513		}),	
    SteadyShot			    	= Action.Create({ Type = "Spell", ID = 56641	}),	
    TarTrap				    	= Action.Create({ Type = "Spell", ID = 187698	}),
    TarTrapDebuff		    	= Action.Create({ Type = "Spell", ID = 135299, Hidden = true	}),	
    TranquilizingShot	    	= Action.Create({ Type = "Spell", ID = 19801	}),		
	
	--Survival Spells
    AspectoftheEagle	    	= Action.Create({ Type = "Spell", ID = 186289	}),
    Carve				    	= Action.Create({ Type = "Spell", ID = 187708	}),
    CoordinatedAssault	    	= Action.Create({ Type = "Spell", ID = 266779	}),
    Harpoon				    	= Action.Create({ Type = "Spell", ID = 190925	}),
    Intimidation		    	= Action.Create({ Type = "Spell", ID = 19577	}),
    KillCommand			    	= Action.Create({ Type = "Spell", ID = 259489	}),
    Muzzle				    	= Action.Create({ Type = "Spell", ID = 187707	}),
    RaptorStrike		    	= Action.Create({ Type = "Spell", ID = 186270	}),
    SerpentSting		    	= Action.Create({ Type = "Spell", ID = 259491	}),
    WildfireBomb		    	= Action.Create({ Type = "Spell", ID = 259495	}),	
    WildfireBombDebuff	    	= Action.Create({ Type = "Spell", ID = 269747, Hidden = true	}),
    ShrapnelBomb				= Action.Create({ Type = "Spell", ID = 270335, Texture = 269747     }),
    ShrapnelBombDebuff			= Action.Create({ Type = "Spell", ID = 270339, Hidden = true 	}),
    InternalBleeding			= Action.Create({ Type = "Spell", ID = 270343, Hidden = true 	}),	
    PheromoneBomb				= Action.Create({ Type = "Spell", ID = 270323, Texture = 269747     }),
    PheromoneBombDebuff			= Action.Create({ Type = "Spell", ID = 270323, Hidden = true	}),	
    VolatileBomb				= Action.Create({ Type = "Spell", ID = 271045, Texture = 269747     }),	
    VolatileBombDebuff			= Action.Create({ Type = "Spell", ID = 270323, Hidden = true    }),

	--Normal Talents
    VipersVenom			    	= Action.Create({ Type = "Spell", ID = 268501, Hidden = true	}),
    VipersVenomBuff		    	= Action.Create({ Type = "Spell", ID = 268252, Hidden = true	}),	
    TermsofEngagement	    	= Action.Create({ Type = "Spell", ID = 265895, Hidden = true	}),
    AlphaPredator		    	= Action.Create({ Type = "Spell", ID = 269737, Hidden = true	}),
    GuerrillaTactics	    	= Action.Create({ Type = "Spell", ID = 264332, Hidden = true	}),
    HydrasBite			    	= Action.Create({ Type = "Spell", ID = 260241, Hidden = true	}),	
    Butchery			    	= Action.Create({ Type = "Spell", ID = 212436	}),	
    Trailblazer			    	= Action.Create({ Type = "Spell", ID = 199921, Hidden = true	}),	
    NaturalMending		    	= Action.Create({ Type = "Spell", ID = 270581, Hidden = true	}),	
    Camouflage			    	= Action.Create({ Type = "Spell", ID = 199483	}),	
    Bloodseeker			    	= Action.Create({ Type = "Spell", ID = 260248, Hidden = true	}),	
    SteelTrap			    	= Action.Create({ Type = "Spell", ID = 162488	}),	
    AMurderofCrows		    	= Action.Create({ Type = "Spell", ID = 131894	}),
    BornToBeWild		    	= Action.Create({ Type = "Spell", ID = 266921, Hidden = true	}),	
    Posthaste			    	= Action.Create({ Type = "Spell", ID = 109215, Hidden = true	}),	
    BindingShot			    	= Action.Create({ Type = "Spell", ID = 109248	}),	
    TipoftheSpear			   	= Action.Create({ Type = "Spell", ID = 260285, Hidden = true	}),	
    TipoftheSpearBuff		   	= Action.Create({ Type = "Spell", ID = 260286, Hidden = true	}),		
    MongooseBite		    	= Action.Create({ Type = "Spell", ID = 259387	}),
    MongooseFury		    	= Action.Create({ Type = "Spell", ID = 259388, Hidden = true	}),	
    FlankingStrike		    	= Action.Create({ Type = "Spell", ID = 269751	}),
    BirdsofPrey			    	= Action.Create({ Type = "Spell", ID = 260331, Hidden = true	}),	
    WildfireInfusion	    	= Action.Create({ Type = "Spell", ID = 271014, Hidden = true	}),	
    Chakrams			    	= Action.Create({ Type = "Spell", ID = 259391	}),	

	--PvP Talents
	--Add later

	
	-- Covenant Abilities
    ResonatingArrow				= Action.Create({ Type = "Spell", ID = 308491	}),
    SummonSteward				= Action.Create({ Type = "Spell", ID = 324739	}),
    FlayedShot					= Action.Create({ Type = "Spell", ID = 324149	}),
    DoorofShadows				= Action.Create({ Type = "Spell", ID = 300728	}),
    DeathChakram				= Action.Create({ Type = "Spell", ID = 325028	}),
    Fleshcraft					= Action.Create({ Type = "Spell", ID = 331180	}),
    WildSpirits					= Action.Create({ Type = "Spell", ID = 328231	}),
    Soulshape					= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker						= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits

	

	-- Legendaries
	-- General Legendaries
    NesingwarysTrappingApparatus	= Action.Create({ Type = "Spell", ID = 336743	}),		
	-- Survival Legendaries
    LatentPoisonDebuff			= Action.Create({ Type = "Spell", ID = 273289	}),	


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
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),   
};

local A = setmetatable(Action[ACTION_CONST_HUNTER_SURVIVAL], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"
local pet = "pet"


A.Listener:Add("ROTATION_VARS", "PLAYER_REGEN_ENABLED", function()
  VarCAExecute = false
end)

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
}

local GameLocale = GetLocale()    
local PetLocalization = {
    [GameLocale] = {},
    ruRU = {
	    SPIRITBEAST = "Дух зверя",
		TENACITY = "Упорство",
		FEROCITY = "Свирепость",
		CUNNING = "Хитрость",
	},
    enGB = {
    	SPIRITBEAST = "Spirit Beast",
		TENACITY = "Tenacity",
		FEROCITY = "Ferocity",
		CUNNING = "Cunning",
	},
    enUS = {
    	SPIRITBEAST = "Spirit Beast",
		TENACITY = "Tenacity",
		FEROCITY = "Ferocity",
		CUNNING = "Cunning",
	},
    deDE = {
	    SPIRITBEAST = "Geisterbestie",
		TENACITY = "Hartnäckigkeit",
		FEROCITY = "Wildheit",
		CUNNING = "Gerissenheit",
	},
    esES = {
    	SPIRITBEAST = "Bestia espíritu",
		TENACITY = "Tenacidad",
		FEROCITY = "Ferocidad",
		CUNNING = "Astucia",
	},
    esMX = {
	    SPIRITBEAST = "Bestia espíritu",
		TENACITY = "Tenacidad",
		FEROCITY = "Ferocidad",
		CUNNING = "Astucia",
	},
    frFR = {
	    SPIRITBEAST = "Esprit de bête",
		TENACITY = "Tenacité",
		FEROCITY = "Férocité",
		CUNNING = "Ruse",
	},
    itIT = {
	    SPIRITBEAST = "Bestia Eterea",
		TENACITY = "Tenacia",
		FEROCITY = "Ferocia",
		CUNNING = "Scaltrezza",
	},
    ptBR = {
    	SPIRITBEAST = "Fera Espiritual",
		TENACITY = "Tenacidade",
		FEROCITY = "Ferocidade",
		CUNNING = "Astúcia",
	},
    koKR = {
    	SPIRITBEAST = "야수 정령",
		TENACITY = "끈기",
		FEROCITY = "야성",
		CUNNING = "교활",
	},
    zhCN = {
	    SPIRITBEAST = "灵魂兽",
		TENACITY = "坚韧",
		FEROCITY = "狂野",
		CUNNING = "狡诈",
	},
    zhTW = {
	    SPIRITBEAST = "靈獸",
		TENACITY = "",
		FEROCITY = "",
		CUNNING = "",
	},
}
local LP = setmetatable(PetLocalization[GameLocale], { __index = PetLocalization.enUS })

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
	
    -- Exhilaration
    local Exhilaration = GetToggle(2, "ExhilarationHP")
    if     Exhilaration >= 0 and A.Exhilaration:IsReady(player) and 
    (
        (     -- Auto 
            Exhilaration >= 100 and 
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
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            Exhilaration < 100 and 
            Unit(player):HealthPercent() <= Exhilaration
        )
    ) 
    then 
        return A.Exhilaration
    end

	
    -- AspectoftheTurtle
    local AspectoftheTurtle = GetToggle(2, "Turtle")
    if     AspectoftheTurtle >= 0 and A.AspectoftheTurtle:IsReady(player) and 
    (
        (     -- Auto 
            AspectoftheTurtle >= 100 and 
            (
                -- HP lose per sec >= 30
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 30 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.30 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
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
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            AspectoftheTurtle < 100 and 
            Unit(player):HealthPercent() <= AspectoftheTurtle
        )
    ) 
    then
        return A.AspectoftheTurtle
    end     
	
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady(player, true) and not A.IsInPvP and A.AuraIsValid(player, "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Muzzle:IsReadyByPassCastGCD(unit) or not A.Muzzle:AbsentImun(unit, Temp.TotalAndMagKick) then
	    return true
	end
end

-- Interrupts spells
local function Interrupts(unit)
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
	
	if castRemainsTime >= A.GetLatency() then
        if useKick and not notInterruptable and A.Muzzle:IsReady(unit) then 
            return A.Muzzle
        end
    end
end


-- Offensive dispel rotation
local function PurgeDispelMagic(unitID)
	local CurrentCreatureFamily = UnitCreatureFamily("pet") 
	
	-- SpiritShock
	if A.TranquilizingShot:IsReady(unitID) and (Action.AuraIsValid(unit, "UseExpelEnrage", "Enrage") or Action.AuraIsValid(unit, "UseDispel", "Magic")) then
		return A.TranquilizingShot:Show(icon)
    end

end
PurgeDispelMagic = A.MakeFunctionCachedDynamic(PurgeDispelMagic)

local function InRange(unit)
	-- @return boolean 
	return A.ArcaneShot:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isCheckEqual, isCheckCombat)
	-- @return boolean 
	local c = 0 
	
	if isStrictlySuperior == nil then
	    isStrictlySuperior = false
	end

	if isStrictlyInferior == nil then
	    isStrictlyInferior = false
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
			if isStrictlySuperior and not isStrictlyInferior then
			    if c > count then
				    return true
				end
			end
			
			-- Stryctly inferior <
			if isStrictlyInferior and not isStrictlySuperior then
			    if c < count then
			        return true
				end
			end
			
			-- Classic >=
			if not isStrictlyInferior and not isStrictlySuperior then
			    if c >= count then 
				    return true 
			    end 
			end
		end 
		
	end
	
end  
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)


local WildfireInfusions = {
  A.ShrapnelBomb,
  A.PheromoneBomb,
  A.VolatileBomb,
}

local function CurrentWildfireInfusion()
    if A.WildfireInfusion:IsTalentLearned() then
        for _, infusion in pairs(WildfireInfusions) do
            if infusion:IsTalentLearned() then 
			    return infusion 
			end
        end
    end
    return A.WildfireBomb
end


A[3] = function(icon, isMulti)

	--Function Remaps
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
	local combatTime = Unit(player):CombatTime()
	local Focus = Player:Focus()
	local FocusMax = Player:FocusMax() 
	local SerpentStingRefreshable = Unit(target):HasDeBuffs(A.SerpentSting.ID, true) < 2
	local WildfireBomb = CurrentWildfireInfusion()
	local TarTrapActive = Player:GetDeBuffsUnitCount(A.TarTrapDebuff.ID) >= 1
	local WildfireBombTicking = Unit(target):HasDeBuffs(A.WildfireBombDebuff.ID, true) > 0 or Unit(target):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0 or Unit(target):HasDeBuffs(A.PheromoneBombDebuff.ID) > 0 or Unit(target):HasDeBuffs(A.VolatileBombDebuff.ID, true) > 0
	
	--Toggle Remaps
	local UseAoE = Action.GetToggle(2, "AoE")	
	local MendPet = Action.GetToggle(2, "MendPet")		
	local UseCovenant = Action.GetToggle(1, "Covenant")
	local Nesingwarys = Action.GetToggle(2, "Nesingwarys")
	local Rylakstalkers = Action.GetToggle(2, "Rylakstalkers")
	local Embers = Action.GetToggle(2, "Embers")	
	local UseRacial = Action.GetToggle(1, "Racial")
	local EagleRange = Action.GetToggle(2, "EagleRange")
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)

		--#####################
		--##### APBOP #####
		--#####################	
		
		local function APBOP(unitID)
		
			--actions.apbop=wild_spirits
			if A.WildSpirits:IsReady(player) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.WildSpirits:Show(icon)
			end
			
			--actions.apbop+=/flanking_strike,if=focus+cast_regen<focus.max
			if A.FlankingStrike:IsReady(unitID) and A.FlankingStrike:IsTalentLearned() and (Focus + 30 < FocusMax) then
				return A.FlankingStrike:Show(icon)
			end
			
			--actions.apbop+=/flayed_shot
			if A.FlayedShot:IsReady(unitID) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.FlayedShot:Show(icon)
			end
			
			--actions.apbop+=/death_chakram,if=focus+cast_regen<focus.max
			if A.DeathChakram:IsReady(unitID) and UseCovenant and (Focus + 21 < FocusMax) and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.DeathChakram:Show(icon)
			end
			
			--actions.apbop+=/kill_shot
			if A.KillShot:IsReady(unitID) then
				return A.KillShot:Show(icon)
			end
			
			--actions.apbop+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 0 and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) < 1.5 * A.GetGCD() then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.apbop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 0 and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) < 1.5 * A.GetGCD() then
				return A.RaptorStrike:Show(icon)
			end			
			
			--actions.apbop+=/flanking_strike,if=focus+cast_regen<focus.max
			if A.FlankingStrike:IsReady(unitID) and A.FlankingStrike:IsTalentLearned() and (Focus + 30 < FocusMax) then
				return A.FlankingStrike:Show(icon)
			end			
			
			--actions.apbop+=/wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&(full_recharge_time<gcd|!dot.wildfire_bomb.ticking&buff.mongoose_fury.remains>full_recharge_time-1*gcd|!dot.wildfire_bomb.ticking&!buff.mongoose_fury.remains)|time_to_die<18&!dot.wildfire_bomb.ticking
			if WildfireBomb:IsReady(unitID) and not WildfireBombTicking and ((WildfireBomb:GetSpellChargesFullRechargeTime() < A.GetGCD() or not WildfireBombTicking and Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0) or ((Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) and not WildfireBombTicking)) then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.apbop+=/steel_trap,if=focus+cast_regen<focus.max
			if A.SteelTrap:IsReady(player) and A.SteelTrap:IsTalentLearned() then
				return A.SteelTrap:Show(icon)
			end
			
			--actions.apbop+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up&buff.mongoose_fury.remains<focus%(action.mongoose_bite.cost-cast_regen)*gcd
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0 and Unit(player):HasBuffs(A.MongooseFury.ID, true) < (Focus / (A.MongooseBite:GetSpellPowerCost() * A.GetGCD())) then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.apbop+=/kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<gcd&focus+cast_regen<focus.max&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
			if A.KillCommand:IsReady(unitID) and A.KillCommand:GetSpellChargesFullRechargeTime() < A.GetGCD() and (Focus + 15 < FocusMax) and ((Nesingwarys and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0) or not Nesingwarys) then
				return A.KillCommand:Show(icon)
			end
			
			--actions.apbop+=/serpent_sting,target_if=min:remains,if=dot.serpent_sting.refreshable&!buff.mongoose_fury.remains
			if A.SerpentSting:IsReady(unitID) and SerpentStingRefreshable and Unit(player):HasBuffs(A.MongooseFury.ID, true) == 0 then
				return A.SerpentSting:Show(icon)
			end
			--actions.apbop+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(buff.mongoose_fury.stack<5|focus<action.mongoose_bite.cost)&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
			if A.KillCommand:IsReady(unitID) and (Focus + 15 < FocusMax) and (Unit(player):HasBuffsStacks(A.MongooseFury.ID, true) < 5 or Focus < A.MongooseBite:GetSpellPowerCost()) and ((Nesingwarys and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0) or not Nesingwarys) then
				return A.KillCommand:Show(icon)
			end
			
			--actions.apbop+=/a_murder_of_crows
			if A.AMurderofCrows:IsReady(unitID) and A.AMurderofCrows:IsTalentLearned() then
				return A.AMurderofCrows:Show(icon)
			end
			
			--actions.apbop+=/resonating_arrow
			if A.ResonatingArrow:IsReady(player) and UseCovenant and Unit(unitID):TimeToDie() > 8 then
				return A.ResonatingArrow:Show(icon)
			end
			
			--actions.apbop+=/coordinated_assault
			if A.CoordinatedAssault:IsReady(player) and A.BurstIsON(unitID) then
				return A.CoordinatedAssault:Show(icon)
			end
			
			--actions.apbop+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max|buff.coordinated_assault.up
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and (Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0 or (Focus + 15 > FocusMax) or Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 0) then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.apbop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() then
				return A.RaptorStrike:Show(icon)
			end
			
			--actions.apbop+=/wildfire_bomb,if=!ticking
			if WildfireBomb:IsReady(unitID) and not WildfireBombTicking then
				return A.WildfireBombDebuff:Show(icon)
			end
			
		end

		--################
		--##### APST #####
		--################	
		
		local function APST(unitID)

			--actions.apst=death_chakram,if=focus+cast_regen<focus.max
			if A.DeathChakram:IsReady(unitID) and UseCovenant and (Focus + 21 < FocusMax) and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.DeathChakram:Show(icon)
			end		
			
			--actions.apst+=/serpent_sting,target_if=min:remains,if=!dot.serpent_sting.ticking&target.time_to_die>7
			if A.SerpentSting:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) == 0 and Unit(unitID):TimeToDie() > 7 then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.apst+=/flayed_shot
			if A.FlayedShot:IsReady(unitID) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.FlayedShot:Show(icon)
			end			
			
			--actions.apst+=/resonating_arrow
			if A.ResonatingArrow:IsReady(player) and UseCovenant and Unit(unitID):TimeToDie() > 8 then
				return A.ResonatingArrow:Show(icon)
			end			
			
			--actions.apst+=/wild_spirits
			if A.WildSpirits:IsReady(player) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.WildSpirits:Show(icon)
			end			
			
			--actions.apst+=/coordinated_assault
			if A.CoordinatedAssault:IsReady(unitID) and A.BurstIsON(unitID) then
				return A.CoordinatedAssault:Show(icon)
			end
			
			--actions.apst+=/kill_shot
			if A.KillShot:IsReady(unitID) and A.BurstIsON(unitID) then
				return A.KillShot:Show(icon)
			end
			
			--actions.apst+=/flanking_strike,if=focus+cast_regen<focus.max
			if A.FlankingStrike:IsReady(unitID) and A.FlankingStrike:IsTalentLearned() and (Focus + 30 < FocusMax) then
				return A.FlankingStrike:Show(icon)
			end
			
			--actions.apst+=/a_murder_of_crows
			if A.AMurderofCrows:IsReady(unitID) and A.AMurderofCrows:IsTalentLearned() then
				return A.AMurderofCrows:Show(icon)
			end
			--actions.apst+=/wildfire_bomb,if=full_recharge_time<gcd|focus+cast_regen<focus.max&(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&!buff.mongoose_fury.up&focus+cast_regen<focus.max-action.kill_command.cast_regen*3)|time_to_die<10
			if WildfireBomb:IsReady(unitID) and (WildfireBomb:GetSpellChargesFullRechargeTime() < A.GetGCD() or ((A.VolatileBomb:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) > 0 and SerpentStingRefreshable) or (A.PheromoneBomb:IsTalentLearned() and Unit(player):HasBuffs(A.MongooseFury.ID, true) == 0 and Focus < (FocusMax - 45)) or Unit(unitID):TimeToDie() < 10)) then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.apst+=/carve,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped
			if A.Carve:IsReady(player) and not A.Butchery:IsTalentLearned() and MultiUnits:GetByRange(5, 2) > 1 and not Rylakstalkers then
				return A.Carve:Show(icon)
			end
			--actions.apst+=/butchery,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped&cooldown.wildfire_bomb.full_recharge_time>spell_targets&(charges_fractional>2.5|dot.shrapnel_bomb.ticking)
			if A.Butchery:IsReady(player) and A.Butchery:IsTalentLearned() and MultiUnits:GetByRange(5, 2) > 1 and not Rylakstalkers and WildfireBomb:GetSpellChargesFullRechargeTime() > MultiUnits:GetByRange(5, 5) and (A.Butchery:GetSpellChargesFrac() > 2.5 or Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0) then
				return A.Butchery:Show(icon)
			end
			
			--actions.apst+=/steel_trap,if=focus+cast_regen<focus.max
			if A.SteelTrap:IsReady(player) and A.SteelTrap:IsTalentLearned() then	
				return A.SteelTrap:Show(icon)
			end
			--actions.apst+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up&buff.mongoose_fury.remains<focus%(action.mongoose_bite.cost-cast_regen)*gcd&!buff.wild_spirits.remains|buff.mongoose_fury.remains&next_wi_bomb.pheromone
			if A.MongooseBite:IsReady(unitID) and ((Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0 and Unit(player):HasBuffs(A.MongooseFury.ID, true) < (Focus / (A.MongooseBite:GetSpellPowerCost() * A.GetGCD())) and A.WildSpirits:GetSpellTimeSinceLastCast() < 15) or (Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0 and A.PheromoneBomb:IsTalentLearned())) then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.apst+=/kill_command,target_if=min:bloodseeker.remains,if=full_recharge_time<gcd&focus+cast_regen<focus.max
			if A.KillCommand:IsReady(unitID) and A.KillCommand:GetSpellChargesFullRechargeTime() < A.GetGCD() and (Focus + 15 < FocusMax) then
				return A.KillCommand:Show(icon)
			end
			
			--actions.apst+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3|dot.shrapnel_bomb.ticking
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() and (Unit(player):HasBuffsStacks(A.TipoftheSpearBuff.ID, true) > 2 or Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0) then
				return A.RaptorStrike:Show(icon)
			end
			
			--actions.apst+=/mongoose_bite,if=dot.shrapnel_bomb.ticking
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0 then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.apst+=/serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>7
			if A.SerpentSting:IsReady(unitID) and SerpentStingRefreshable and Unit(unitID):TimeToDie() > 7 then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.apst+=/wildfire_bomb,if=next_wi_bomb.shrapnel&focus>action.mongoose_bite.cost*2&dot.serpent_sting.remains>5*gcd
			if WildfireBomb:IsReady(unitID) and A.ShrapnelBomb:IsTalentLearned() and (Focus > (A.MongooseBite:GetSpellPowerCost() * 2)) and Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) > 5 * A.GetGCD() then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.apst+=/chakrams
			if A.Chakrams:IsReady(unitID) and A.Chakrams:IsTalentLearned() then
				return A.Chakrams:Show(icon)
			end
			
			--actions.apst+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max
			if A.KillCommand:IsReady(unitID) and (Focus + 15 < FocusMax) then
				return A.KillCommand:Show(icon)
			end
			
			--actions.apst+=/wildfire_bomb,if=runeforge.rylakstalkers_confounding_strikes.equipped
			if WildfireBomb:IsReady(unitID) and Rylakstalkers then
				return A.WildfireBombDebuff:Show(icon)
			end
			--actions.apst+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max-15|dot.shrapnel_bomb.ticking|buff.wild_spirits.remains
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and (Unit(unitID):HasBuffs(A.MongooseFury.ID, true) > 0 or Focus > FocusMax - 15 or Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0 or A.WildSpirits:GetSpellTimeSinceLastCast() < 15) then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.apst+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() then
				return A.RaptorStrike:Show(icon)
			end
			
			--actions.apst+=/wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel&focus>50
			if WildfireBomb:IsReady(unitID) and ((A.VolatileBomb:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) > 0) or A.PheromoneBomb:IsTalentLearned() or (A.ShrapnelBomb:IsTalentLearned() and Focus > 50)) then
				return A.WildfireBombDebuff:Show(icon)
			end
		end
		
		--###############
		--##### BOP #####
		--###############

		local function BOP(unitID)

			--actions.bop=serpent_sting,target_if=min:remains,if=buff.vipers_venom.remains&buff.vipers_venom.remains<gcd
			if A.SerpentSting:IsReady(unitID) and Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) > 0 and Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) < A.GetGCD() then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.bop+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&buff.nesingwarys_trapping_apparatus.up
			if A.KillCommand:IsReady(unitID) and Focus + 15 < FocusMax and Unit(player):HasBuffs(A.NesingwarysTrappingApparatus.ID, true) > 0 then
				return A.KillCommand:Show(icon)
			end
			
			--actions.bop+=/wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&full_recharge_time<gcd
			if A.WildfireBomb:IsReady(unitID) and Focus + Player:FocusCastRegen(A.WildfireBomb:GetSpellCastTime()) < FocusMax and not WildfireBombTicking and A.WildfireBomb:GetSpellChargesFullRechargeTime() < A.GetGCD() then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.bop+=/wild_spirits
			if A.WildSpirits:IsReady(player) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.WildSpirits:Show(icon)
			end				
			
			--actions.bop+=/flanking_strike,if=focus+cast_regen<focus.max
			if A.FlankingStrike:IsReady(unitID) and A.FlankingStrike:IsTalentLearned() and Focus + Player:FocusCastRegen(A.FlankingStrike:GetSpellCastTime()) < FocusMax then
				return A.FlankingStrike:Show(icon)
			end
			
			--actions.bop+=/flayed_shot
			if A.FlayedShot:IsReady(unitID) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.FlayedShot:Show(icon)
			end				
			
			--actions.bop+=/death_chakram,if=focus+cast_regen<focus.max
			if A.DeathChakram:IsReady(unitID) and UseCovenant and (Focus + 21 < FocusMax) and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.DeathChakram:Show(icon)
			end				
			
			--actions.bop+=/kill_shot
			if A.KillShot:IsReady(unitID) then
				return A.KillShot:Show(icon)
			end
			
			--actions.bop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 0 and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) < 1.5 * A.GetGCD() then
				return A.RaptorStrike:Show(icon)
			end		
			
			--actions.bop+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.coordinated_assault.up&buff.coordinated_assault.remains<1.5*gcd
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 0 and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) < 1.5 * A.GetGCD() then
				return A.MongooseBite:Show(icon)
			end					
			
			--actions.bop+=/a_murder_of_crows
			if A.AMurderofCrows:IsReady(unitID) and A.AMurderofCrows:IsTalentLearned() then
				return A.AMurderofCrows:Show(icon)
			end
			
			--actions.bop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffsStacks(A.TipoftheSpearBuff.ID, true) > 2 then
				return A.RaptorStrike:Show(icon)
			end						
			--actions.bop+=/wildfire_bomb,if=focus+cast_regen<focus.max&!ticking&(full_recharge_time<gcd|!dot.wildfire_bomb.ticking&buff.mongoose_fury.remains>full_recharge_time-1*gcd|!dot.wildfire_bomb.ticking&!buff.mongoose_fury.remains)|time_to_die<18&!dot.wildfire_bomb.ticking
			if A.WildfireBomb:IsReady(unitID) and Focus + Player:FocusCastRegen(A.WildfireBomb:GetSpellCastTime()) < FocusMax and not WildfireBombTicking and (A.WildfireBomb:GetSpellChargesFullRechargeTime() < A.GetGCD() or (not WildfireBombTicking and Unit(player):HasBuffs(A.MongooseFury.ID, true) > (A.WildfireBomb:GetSpellChargesFullRechargeTime() - 1) * A.GetGCD()) or not WildfireBombTicking and Unit(player):HasBuffs(A.MongooseFury.ID, true) == 0) or Unit(unit):TimeToDie() < 18 and not WildfireBombTicking then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.bop+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&!runeforge.nessingwarys_trapping_apparatus.equipped|focus+cast_regen<focus.max&((runeforge.nessingwarys_trapping_apparatus.equipped&!talent.steel_trap.enabled&cooldown.freezing_trap.remains&cooldown.tar_trap.remains)|(runeforge.nessingwarys_trapping_apparatus.equipped&talent.steel_trap.enabled&cooldown.freezing_trap.remains&cooldown.tar_trap.remains&cooldown.steel_trap.remains))|focus<action.mongoose_bite.cost
			if A.KillCommand:IsReady(unitID) and (Focus + 15 < FocusMax and not Nesingwarys) or (Focus + 15 < FocusMax and ((Nesingwarys and not A.SteelTrap:IsTalentLearned() and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0) or (Nesingwarys and A.SteelTrap:IsTalentLearned() and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0 and A.SteelTrap:GetCooldown() > 0)) or Focus < A.MongooseBite:GetSpellPowerCost()) then
				return A.KillCommand:Show(icon)
			end
			
			--actions.bop+=/steel_trap,if=focus+cast_regen<focus.max
			if A.SteelTrap:IsReady(unitID) and A.SteelTrap:IsTalentLearned() and Focus + Player:FocusCastRegen(A.SteelTrap:GetSpellCastTime()) < FocusMax then
				return A.SteelTrap:Show(icon)
			end
			
			--actions.bop+=/serpent_sting,target_if=min:remains,if=buff.vipers_venom.up&refreshable|dot.serpent_sting.refreshable&!buff.coordinated_assault.up
			if A.SerpentSting:IsReady(unitID) and ((Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) > 0 and SerpentStingRefreshable) or (SerpentStingRefreshable and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) == 0)) then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.bop+=/resonating_arrow
			if A.ResonatingArrow:IsReady(player) and UseCovenant and Unit(unitID):TimeToDie() > 8 then
				return A.ResonatingArrow:Show(icon)
			end				
			
			--actions.bop+=/coordinated_assault,if=!buff.coordinated_assault.up
			if A.CoordinatedAssault:IsReady(player) and A.BurstIsON(unitID) and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) == 0 then
				return A.CoordinatedAssault:Show(icon)
			end
			
			--actions.bop+=/mongoose_bite,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max|buff.coordinated_assault.up
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and (Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0 or Focus + 15 > FocusMax or Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 0) then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.bop+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
			if A.RaptorStrike:IsReady(unitID) then
				return A.RaptorStrike:Show(icon)
			end
			
			--actions.bop+=/wildfire_bomb,if=dot.wildfire_bomb.refreshable
			if A.WildfireBomb:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.WildfireBombDebuff.ID, true) < 2 then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.bop+=/serpent_sting,target_if=min:remains,if=buff.vipers_venom.up
			if A.SerpentSting:IsReady(unitID) and Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) > 0 then
				return A.SerpentSting:Show(icon)
			end
		
		end

		--#####################
		--##### COOLDOWNS #####
		--#####################

		local function Cooldowns(unitID)
		
			--actions.cds=harpoon,if=talent.terms_of_engagement.enabled&focus<focus.max
			if A.Harpoon:IsReady(player) and A.TermsofEngagement:IsTalentLearned() and Focus < FocusMax then
				return A.Harpoon:Show(icon)
			end
			
			--actions.cds+=/blood_fury,if=cooldown.coordinated_assault.remains>30
			if A.BloodFury:IsReady(player) and UseRacial and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 30 then
				return A.BloodFury:Show(icon)
			end
			
			--actions.cds+=/ancestral_call,if=cooldown.coordinated_assault.remains>30
			if A.AncestralCall:IsReady(player) and UseRacial and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 30 then
				return A.AncestralCall:Show(icon)
			end
			
			--actions.cds+=/fireblood,if=cooldown.coordinated_assault.remains>30
			if A.Fireblood:IsReady(player) and UseRacial and Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 30 then
				return A.Fireblood:Show(icon)
			end			
			
			--actions.cds+=/lights_judgment
			if A.LightsJudgment:IsReady(unitID) and UseRacial then
				return A.LightsJudgment:Show(icon)
			end
			
			--actions.cds+=/bag_of_tricks,if=cooldown.kill_command.full_recharge_time>gcd
			if A.BagofTricks:IsReady(unitID) and UseRacial and A.KillCommand:GetSpellChargesFullRechargeTime() > A.GetGCD() then
				return A.BagofTricks:Show(icon)
			end
			
			--actions.cds+=/berserking,if=cooldown.coordinated_assault.remains>60|time_to_die<13
			if A.Berserking:IsReady(player) and UseRacial and (Unit(player):HasBuffs(A.CoordinatedAssault.ID, true) > 60 or Unit(unitID):TimeToDie() < 13) then
				return A.Berserking:Show(icon)
			end				
			
			--actions.cds+=/muzzle
			--actions.cds+=/potion,if=target.time_to_die<60|buff.coordinated_assault.up
			--actions.cds+=/steel_trap,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus+cast_regen<focus.max
			if A.SteelTrap:IsReady(player) and A.SteelTrap:IsTalentLearned() and Nesingwarys and Focus + Player:FocusCastRegen(A.SteelTrap:GetSpellCastTime()) < FocusMax then
				return A.SteelTrap:Show(icon)
			end
			
			--actions.cds+=/freezing_trap,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus+cast_regen<focus.max
			if A.FreezingTrap:IsReady(player) and Nesingwarys and Focus + Player:FocusCastRegen(A.FreezingTrap:GetSpellCastTime()) < FocusMax then
				return A.FreezingTrap:Show(icon)
			end			
			
			--actions.cds+=/tar_trap,if=runeforge.nessingwarys_trapping_apparatus.equipped&focus+cast_regen<focus.max|focus+cast_regen<focus.max&runeforge.soulforge_embers.equipped&tar_trap.remains<gcd&cooldown.flare.remains<gcd&(active_enemies>1|active_enemies=1&time_to_die>5*gcd)
			if A.TarTrap:IsReady(player) and Nesingwarys and Focus + Player:FocusCastRegen(A.TarTrap:GetSpellCastTime()) < FocusMax and Embers and TarTrapActive and A.Flare:GetCooldown() < A.GetGCD() and (MultiUnits:GetByRange(5, 2) > 1 or (MultiUnits:GetByRange(5, 2) == 1 and Unit(unitID):TimeToDie() > 5 * A.GetGCD())) then
				return A.TarTrap:Show(icon)
			end
			
			--actions.cds+=/flare,if=focus+cast_regen<focus.max&tar_trap.up&runeforge.soulforge_embers.equipped&time_to_die>4*gcd
			if A.Flare:IsReady(player) and Focus + Player:FocusCastRegen(A.Flare:GetSpellCastTime()) < FocusMax and TarTrapActive and Embers and Unit(unitID):TimeToDie() > (4 * A.GetGCD()) then
				return A.Flare:Show(icon)
			end
			
			--actions.cds+=/kill_shot,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
			if A.KillShot:IsReady(unitID) and MultiUnits:GetByRange(5, 2) == 1 and Unit(unitID):TimeToDie() < (Focus / (A.MongooseBite:GetSpellPowerCost() * A.GetGCD())) then
				return A.KillShot:Show(icon)
			end
			
			--actions.cds+=/mongoose_bite,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and MultiUnits:GetByRange(5, 2) == 1 and Unit(unitID):TimeToDie() < (Focus / (A.MongooseBite:GetSpellPowerCost() * A.GetGCD())) then
				return A.MongooseBite:Show(icon)
			end
			
			--actions.cds+=/raptor_strike,if=active_enemies=1&target.time_to_die<focus%(action.mongoose_bite.cost-cast_regen)*gcd
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() and MultiUnits:GetByRange(5, 2) == 1 and Unit(unitID):TimeToDie() < (Focus / (A.MongooseBite:GetSpellPowerCost() * A.GetGCD())) then
				return A.RaptorStrike:Show(icon)
			end			

		
		end	

		--##################
		--##### CLEAVE #####
		--##################

		local function Cleave(unitID)
		
			--actions.cleave=serpent_sting,target_if=min:remains,if=talent.hydras_bite.enabled&buff.vipers_venom.remains&buff.vipers_venom.remains<gcd
			if A.SerpentSting:IsReady(unitID) and A.HydrasBite:IsTalentLearned() and Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) > 0 and Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) < A.GetGCD() then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.cleave+=/wild_spirits
			if A.WildSpirits:IsReady(player) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.WildSpirits:Show(icon)
			end				
			
			--actions.cleave+=/resonating_arrow
			if A.ResonatingArrow:IsReady(player) and UseCovenant and Unit(unitID):TimeToDie() > 8 then
				return A.ResonatingArrow:Show(icon)
			end					
			
			--actions.cleave+=/wildfire_bomb,if=full_recharge_time<gcd
			if WildfireBomb:IsReady(unitID) and WildfireBomb:GetSpellChargesFullRechargeTime() < A.GetGCD() then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.cleave+=/chakrams
			if A.Chakrams:IsReady(unitID) then
				return A.Chakrams:Show(icon)
			end
			
			--actions.cleave+=/butchery,if=dot.shrapnel_bomb.ticking&(dot.internal_bleeding.stack<2|dot.shrapnel_bomb.remains<gcd)
			if A.Butchery:IsReady(player) and A.Butchery:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0 and (Unit(unitID):HasDeBuffsStacks(A.InternalBleeding.ID, true) < 2 or Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) < A.GetGCD()) then
				return A.Butchery:Show(icon)
			end	
			
			--actions.cleave+=/carve,if=dot.shrapnel_bomb.ticking
			if A.Carve:IsReady(player) and not A.Butchery:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.ShrapnelBomb.ID, true) > 0 then
				return A.Carve:Show(icon)
			end
			
			--actions.cleave+=/death_chakram,if=focus+cast_regen<focus.max
			if A.DeathChakram:IsReady(unitID) and UseCovenant and (Focus + 21 < FocusMax) and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.DeathChakram:Show(icon)
			end					
			
			--actions.cleave+=/coordinated_assault
			if A.CoordinatedAssault:IsReady(player) and A.BurstIsON(unitID) then
				return A.CoordinatedAssault:Show(icon)
			end
			
			--actions.cleave+=/butchery,if=charges_fractional>2.5&cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
			if A.Butchery:IsReady(player) and A.Butchery:IsTalentLearned() and A.Butchery:GetSpellChargesFrac() > 2.5 and WildfireBomb:GetSpellChargesFullRechargeTime() > (MultiUnits:GetByRange(5, 5) / 2) then
				return A.Butchery:Show(icon)
			end
			
			--actions.cleave+=/flanking_strike,if=focus+cast_regen<focus.max
			if A.FlankingStrike:IsReady(unitID) and A.FlankingStrike:IsTalentLearned() and Focus + 30 < FocusMax then
				return A.FlankingStrike:Show(icon)
			end
			
			--actions.cleave+=/carve,if=cooldown.wildfire_bomb.full_recharge_time>spell_targets%2&talent.alpha_predator.enabled
			if A.Carve:IsReady(unitID) and not A.Butchery:IsTalentLearned() and A.WildfireBomb:GetSpellChargesFullRechargeTime() > (MultiUnits:GetByRange(5, 5) / 2) and A.AlphaPredator:IsTalentLearned() then
				return A.Carve:Show(icon)
			end
			
			--actions.cleave+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&full_recharge_time<gcd&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
			if A.KillCommand:IsReady(unitID) and A.KillCommand:GetSpellChargesFullRechargeTime() < A.GetGCD() and (Focus + 15 < FocusMax) and ((Nesingwarys and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0) or not Nesingwarys) then
				return A.KillCommand:Show(icon)
			end			
			
			--actions.cleave+=/wildfire_bomb,if=!dot.wildfire_bomb.ticking
			if WildfireBomb:IsReady(unitID) and not WildfireBombTicking then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.cleave+=/butchery,if=(!next_wi_bomb.shrapnel|!talent.wildfire_infusion.enabled)&cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
			if A.Butchery:IsReady(player) and A.Butchery:IsTalentLearned() and (not A.ShrapnelBomb:IsTalentLearned() or not A.WildfireInfusion:IsTalentLearned()) and A.WildfireBomb:GetSpellChargesFullRechargeTime() > MultiUnits:GetByRange(5, 5) / 2 then
				return A.Butchery:Show(icon)
			end
			
			--actions.cleave+=/carve,if=cooldown.wildfire_bomb.full_recharge_time>spell_targets%2
			if A.Carve:IsReady(player) and not A.Butchery:IsTalentLearned() and A.WildfireBomb:GetSpellChargesFullRechargeTime() > MultiUnits:GetByRange(5, 5) / 2 then
				return A.Carve:Show(icon)
			end			
			
			--actions.cleave+=/kill_shot
			if A.KillShot:IsReady(unitID) then
				return A.KillShot:Show(icon)
			end
			
			--actions.cleave+=/flayed_shot
			--actions.apbop+=/flayed_shot
			if A.FlayedShot:IsReady(unitID) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.FlayedShot:Show(icon)
			end
			
			--actions.cleave+=/a_murder_of_crows
			if A.AMurderofCrows:IsReady(unitID) and A.AMurderofCrows:IsTalentLearned() then
				return A.AMurderofCrows:Show(icon)
			end
			
			--actions.cleave+=/steel_trap
			if A.SteelTrap:IsReady(player) and A.SteelTrap:IsTalentLearned() then
				return A.SteelTrap:Show(icon)
			end
			
			--actions.cleave+=/serpent_sting,target_if=min:remains,if=refreshable&talent.hydras_bite.enabled&target.time_to_die>8
			if A.SerpentSting:IsReady(unitID) and SerpentStingRefreshable and A.HydrasBite:IsTalentLearned() and Unit(unitID):TimeToDie() > 8 then
				return A.SerpentSting:Show(icon)
			end	
			
			--actions.cleave+=/carve
			if A.Carve:IsReady(player) and not A.Butchery:IsTalentLearned() then
				return A.Carve:Show(icon)
			end	
			--actions.cleave+=/kill_command,target_if=focus+cast_regen<focus.max&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
			if A.KillCommand:IsReady(unitID) and (Focus + 15 < FocusMax) and ((Nesingwarys and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0) or not Nesingwarys) then
				return A.KillCommand:Show(icon)
			end				
			
			--actions.cleave+=/serpent_sting,target_if=min:remains,if=refreshable
			if A.SerpentSting:IsReady(unitID) and SerpentStingRefreshable then
				return A.SerpentSting:Show(icon)
			end	
			
			--actions.cleave+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() then
				return A.MongooseBite:Show(icon)
			end			
			
			--actions.cleave+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() then
				return A.RaptorStrike:Show(icon)
			end			
			
		end

		--#########################
		--##### SINGLE TARGET #####
		--#########################

		local function SingleTarget(unitID)
		
			--actions.st=flayed_shot
			if A.FlayedShot:IsReady(unitID) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.FlayedShot:Show(icon)
			end			
			
			--actions.st+=/wild_spirits
			if A.WildSpirits:IsReady(player) and UseCovenant and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.WildSpirits:Show(icon)
			end				
			
			--actions.st+=/resonating_arrow
			if A.ResonatingArrow:IsReady(player) and UseCovenant and Unit(unitID):TimeToDie() > 8 then
				return A.ResonatingArrow:Show(icon)
			end					
			
			--actions.st+=/serpent_sting,target_if=min:remains,if=buff.vipers_venom.up&buff.vipers_venom.remains<gcd|!ticking
			if A.SerpentSting:IsReady(unitID) and ((Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) > 0 and Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) < A.GetGCD()) or Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) == 0) then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.st+=/death_chakram,if=focus+cast_regen<focus.max
			if A.DeathChakram:IsReady(unitID) and UseCovenant and (Focus + 21 < FocusMax) and (Unit(unitID):IsBoss() or Unit(unitID):TimeToDie() > 8) then
				return A.DeathChakram:Show(icon)
			end				
			
			--actions.st+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack,if=buff.tip_of_the_spear.stack=3
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() and Unit(player):HasBuffsStacks(A.TipoftheSpearBuff.ID, true) > 2 then
				return A.RaptorStrike:Show(icon)
			end			
			
			--actions.st+=/coordinated_assault
			if A.CoordinatedAssault:IsReady(player) and A.BurstIsON(unitID) then
				return A.CoordinatedAssault:Show(icon)
			end	
			
			--actions.st+=/kill_shot
			if A.KillShot:IsReady(unitID) then
				return A.KillShot:Show(icon)
			end
			
			--actions.st+=/wildfire_bomb,if=full_recharge_time<gcd&focus+cast_regen<focus.max|(next_wi_bomb.volatile&dot.serpent_sting.ticking&dot.serpent_sting.refreshable|next_wi_bomb.pheromone&focus+cast_regen<focus.max-action.kill_command.cast_regen*3&!buff.mongoose_fury.remains)
			if WildfireBomb:IsReady(unitID) and ((WildfireBomb:GetSpellChargesFullRechargeTime() < A.GetGCD() and Focus + Player:FocusCastRegen(WildfireBomb:GetSpellCastTime()) < FocusMax) or (A.VolatileBomb:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) > 0 and SerpentStingRefreshable) or (A.PheromoneBomb:IsTalentLearned() and Focus + Player:FocusCastRegen(WildfireBomb:GetSpellCastTime()) < (FocusMax - 45) and Unit(player):HasBuffs(A.MongooseFury.ID, true) == 0)) then
				return A.WildfireBombDebuff:Show(icon)
			end
			
			--actions.st+=/steel_trap,if=focus+cast_regen<focus.max
			if A.SteelTrap:IsReady(player) and A.SteelTrap:IsTalentLearned() and Focus + Player:FocusCastRegen(A.SteelTrap:GetSpellCastTime()) < FocusMax then
				return A.SteelTrap:Show(icon)
			end
			
			--actions.st+=/flanking_strike,if=focus+cast_regen<focus.max
			if A.FlankingStrike:IsReady(unitID) and A.FlankingStrike:IsTalentLearned() and Focus + Player:FocusCastRegen(A.FlankingStrike:GetSpellCastTime()) < FocusMax then
				return A.FlankingStrike:Show(icon)
			end
			
			--actions.st+=/kill_command,target_if=min:bloodseeker.remains,if=focus+cast_regen<focus.max&(runeforge.nessingwarys_trapping_apparatus.equipped&cooldown.freezing_trap.remains&cooldown.tar_trap.remains|!runeforge.nessingwarys_trapping_apparatus.equipped)
			if A.KillCommand:IsReady(unitID) and (Focus + 15 < FocusMax) and ((Nesingwarys and A.FreezingTrap:GetCooldown() > 0 and A.TarTrap:GetCooldown() > 0) or not Nesingwarys) then
				return A.KillCommand:Show(icon)
			end				
			
			--actions.st+=/carve,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped
			if A.Carve:IsReady(player) and not A.Butchery:IsTalentLearned() and MultiUnits:GetByRange(5, 2) > 1 and not Rylakstalkers then
				return A.Carve:Show(icon)
			end	
			--actions.st+=/butchery,if=active_enemies>1&!runeforge.rylakstalkers_confounding_strikes.equipped&cooldown.wildfire_bomb.full_recharge_time>spell_targets&(charges_fractional>2.5|dot.shrapnel_bomb.ticking)
			if A.Butchery:IsReady(player) and A.Butchery:IsTalentLearned() and MultiUnits:GetByRange(5, 2) > 1 and not Rylakstalkers and WildfireBomb:GetSpellChargesFullRechargeTime() > MultiUnits(5, 5) and (A.Butchery:GetSpellChargesFrac() > 2.5 or Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0) then
				return A.Butchery:Show(icon)
			end	
			
			--actions.st+=/a_murder_of_crows
			if A.AMurderofCrows:IsReady(unitID) then	
				return A.AMurderofCrows:Show(icon)
			end	
			
			--actions.st+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=dot.shrapnel_bomb.ticking|buff.mongoose_fury.stack=5
			if A.MongooseBite:IsReady(unitID) and (Unit(unitID):HasDeBuffs(A.ShrapnelBombDebuff.ID, true) > 0 or Unit(player):HasBuffsStacks(A.MongooseFury.ID, true) > 4) then
				return A.MongooseBite:Show(icon)
			end	
			
			--actions.st+=/serpent_sting,target_if=min:remains,if=refreshable|buff.vipers_venom.up
			if A.SerpentSting:IsReady(unitID) and (SerpentStingRefreshable or Unit(player):HasBuffs(A.VipersVenomBuff.ID, true) > 0) then
				return A.SerpentSting:Show(icon)
			end
			
			--actions.st+=/wildfire_bomb,if=next_wi_bomb.shrapnel&dot.serpent_sting.remains>5*gcd|runeforge.rylakstalkers_confounding_strikes.equipped
			if WildfireBomb:IsReady(unitID) and ((A.ShrapnelBomb:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) > (5 * A.GetGCD())) or Rylakstalkers) then
				return A.WildfireBombDebuff:Show(icon)
			end	
			
			--actions.st+=/chakrams
			if A.Chakrams:IsReady(unitID) and A.Chakrams:IsTalentLearned() then
				return A.Chakrams:Show(icon)
			end	
			
			--actions.st+=/mongoose_bite,target_if=max:debuff.latent_poison_injection.stack,if=buff.mongoose_fury.up|focus+action.kill_command.cast_regen>focus.max-15|dot.shrapnel_bomb.ticking
			if A.MongooseBite:IsReady(unitID) and A.MongooseBite:IsTalentLearned() and (Unit(player):HasBuffs(A.MongooseFury.ID, true) > 0 or Focus > FocusMax - 15 or Unit(unitID):HasDeBuffs(A.ShrapnelBomb.ID, true) > 0) then
				return A.MongooseBite:Show(icon)
			end	
			
			--actions.st+=/raptor_strike,target_if=max:debuff.latent_poison_injection.stack
			if A.RaptorStrike:IsReady(unitID) and not A.MongooseBite:IsTalentLearned() then
				return A.RaptorStrike:Show(icon)
			end	
			
			--actions.st+=/wildfire_bomb,if=next_wi_bomb.volatile&dot.serpent_sting.ticking|next_wi_bomb.pheromone|next_wi_bomb.shrapnel
			if WildfireBomb:IsReady(unitID) and A.VolatileBomb:IsTalentLearned() and (Unit(unitID):HasDeBuffs(A.SerpentSting.ID, true) > 0 or A.PheromoneBomb:IsTalentLearned() or A.ShrapnelBomb:IsTalentLearned()) then
				return A.WildfireBombDebuff:Show(icon)
			end	
			
		end

		--Summon Pet OOC
		if not inCombat and A.CallPet:IsReady(player) and not Pet:IsActive() then
            return A.CallPet:Show(icon)
        end
		
		--Mend Pet
		if A.MendPet:IsReady(player) and Unit(pet):HealthPercent() < MendPet and Pet:IsActive() then
			return A.MendPet:Show(icon)
		end

		--Tranq Shot
		if A.TranquilizingShot:IsReady(unitID) and (Action.AuraIsValid(unit, "UseExpelEnrage", "Enrage") or Action.AuraIsValid(unit, "UseDispel", "Magic")) then
			return A.TranquilizingShot:Show(icon)
		end

		--Aspect of the Eagle
		if A.AspectoftheEagle:IsReady(player) and Unit(unitID):GetRange() >= EagleRange and inCombat then
			return A.AspectoftheEagle:Show(icon)
		end
		
		--actions+=/call_action_list,name=cds
		if A.BurstIsON(unitID) and inCombat then
			if Cooldowns(unitID) then
				return true
			end
		end
		
		--actions+=/call_action_list,name=bop,if=active_enemies<3&!talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
		if MultiUnits:GetByRange(5, 3) < 3 and not A.AlphaPredator:IsTalentLearned() and not A.WildfireInfusion:IsTalentLearned() then
			if BOP(unitID) then
				return true
			end
		end
		
		--actions+=/call_action_list,name=apbop,if=active_enemies<3&talent.alpha_predator.enabled&!talent.wildfire_infusion.enabled
		if MultiUnits:GetByRange(5, 3) < 3 and A.AlphaPredator:IsTalentLearned() and not A.WildfireInfusion:IsTalentLearned() then
			if APBOP(unitID) then
				return true
			end
		end
		
		--actions+=/call_action_list,name=apst,if=active_enemies<3&talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
		if MultiUnits:GetByRange(5, 3) < 3 and A.AlphaPredator:IsTalentLearned() and A.WildfireInfusion:IsTalentLearned() then
			if APST(unitID) then
				return true
			end
		end
		
		--actions+=/call_action_list,name=st,if=active_enemies<3&!talent.alpha_predator.enabled&talent.wildfire_infusion.enabled
		if MultiUnits:GetByRange(5, 3) < 3 and not A.AlphaPredator:IsTalentLearned() and A.WildfireInfusion:IsTalentLearned() then
			if SingleTarget(unitID) then
				return true
			end
		end		
		
		--actions+=/call_action_list,name=cleave,if=active_enemies>2
		if MultiUnits:GetByRange(5, 3) > 2 and UseAoE then
			if Cleave(unitID) then
				return true
			end
		end		
		
		--actions+=/arcane_torrent		
		if A.ArcaneTorrent:IsReady(player) and AutoRacial then
			return A.ArcaneTorrent:Show(icon)
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
        unitID = "mouseover"
        if EnemyRotation(unitID) then 
            return true 
        end 
    end 

    -- Target  
    if A.IsUnitEnemy("target") then 
        unitID = "target"
        if EnemyRotation(unitID) then 
            return true
        end 

    end
end
-- Finished

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil
