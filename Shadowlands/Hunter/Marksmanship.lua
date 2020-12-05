--######################################
--##### TRIP'S MARKSMANSHIP HUNTER #####
--######################################

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
Action[ACTION_CONST_HUNTER_MARKSMANSHIP] = {
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
    CallPet				    	= Action.Create({ Type = "Spell", ID = 883		}),	
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
    TranquilizingShot	    	= Action.Create({ Type = "Spell", ID = 19801	}),	
	
	--Marksmanship Spells
    AimedShot			    	= Action.Create({ Type = "Spell", ID = 19434	}),
    BindingShot			    	= Action.Create({ Type = "Spell", ID = 109248	}),	
    BurstingShot		    	= Action.Create({ Type = "Spell", ID = 186387	}),
    ConcussiveShot		    	= Action.Create({ Type = "Spell", ID = 5116		}),	
    CounterShot			    	= Action.Create({ Type = "Spell", ID = 147362	}),	
    Multishot			    	= Action.Create({ Type = "Spell", ID = 257620	}),
    RapidFire			    	= Action.Create({ Type = "Spell", ID = 257044	}),	
    Trueshot			    	= Action.Create({ Type = "Spell", ID = 288613	}),
    Lonewolf			    	= Action.Create({ Type = "Spell", ID = 155228, Hidden = true	}),
    PreciseShots		    	= Action.Create({ Type = "Spell", ID = 260240, Hidden = true	}),	
    PreciseShotsBuff	    	= Action.Create({ Type = "Spell", ID = 260242, Hidden = true	}),
    TrickShots			    	= Action.Create({ Type = "Spell", ID = 257621, Hidden = true	}),	
    TrickShotsBuff		    	= Action.Create({ Type = "Spell", ID = 257622, Hidden = true	}),	

	--Normal Talents
    MasterMarksman		    	= Action.Create({ Type = "Spell", ID = 260309, Hidden = true	}),
    MasterMarksmanDebuff	   	= Action.Create({ Type = "Spell", ID = 269576, Hidden = true	}),	
    SerpentSting		    	= Action.Create({ Type = "Spell", ID = 271788	}),	
    AMurderofCrows		    	= Action.Create({ Type = "Spell", ID = 131894	}),	
    CarefulAim			    	= Action.Create({ Type = "Spell", ID = 260228, Hidden = true	}),	
    Barrage			    		= Action.Create({ Type = "Spell", ID = 120360	}),	
    ExplosiveShot		    	= Action.Create({ Type = "Spell", ID = 212431	}),	
    Trailblazer			    	= Action.Create({ Type = "Spell", ID = 199921, Hidden = true	}),
    NaturalMending		    	= Action.Create({ Type = "Spell", ID = 270581, Hidden = true	}),	
    Camouflage			    	= Action.Create({ Type = "Spell", ID = 199483	}),	
    SteadyFocus			    	= Action.Create({ Type = "Spell", ID = 193533, Hidden = true	}),	
    Streamline			    	= Action.Create({ Type = "Spell", ID = 260367, Hidden = true	}),	
    ChimaeraShot		    	= Action.Create({ Type = "Spell", ID = 342049	}),	
    BorntobeWild		    	= Action.Create({ Type = "Spell", ID = 266921, Hidden = true	}),
    Posthaste			    	= Action.Create({ Type = "Spell", ID = 109215, Hidden = true	}),
    BindingShackles		    	= Action.Create({ Type = "Spell", ID = 321468, Hidden = true	}),
    LethalShots			    	= Action.Create({ Type = "Spell", ID = 260393, Hidden = true	}),	
    DeadEye				    	= Action.Create({ Type = "Spell", ID = 321460, Hidden = true	}),	
    DoubleTap			    	= Action.Create({ Type = "Spell", ID = 260402	}),	
    CallingtheShots		    	= Action.Create({ Type = "Spell", ID = 260404, Hidden = true	}),	
    LockandLoad			    	= Action.Create({ Type = "Spell", ID = 194595, Hidden = true	}),	
    LockandLoadBuff		    	= Action.Create({ Type = "Spell", ID = 194594, Hidden = true	}),	
    Volley				    	= Action.Create({ Type = "Spell", ID = 260243	}),	

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
	-- Marksmanship Legendaries


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

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_HUNTER_MARKSMANSHIP)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_HUNTER_MARKSMANSHIP], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"
local pet = "pet"

local VarCAExecute = false;

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

-- API - Spell
Pet:AddActionsSpells(254, {

	-- number accepted
	17253, -- Bite
	16827, -- Claw
	49966, -- Smack 
}, true)

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
    if not A.CounterShot:IsReadyByPassCastGCD(unit) or not A.CounterShot:AbsentImun(unit, Temp.TotalAndMagKick) then
	    return true
	end
end

-- Interrupts spells
local function Interrupts(unit)
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
	
	if castRemainsTime >= A.GetLatency() then
        -- CounterShot
        if useKick and not notInterruptable and A.CounterShot:IsReady(unit) then 
            return A.CounterShot
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


-- Offensive dispel rotation
local function PurgeDispellMagic(unit)
	local CurrentCreatureFamily = UnitCreatureFamily("pet") 
	
	-- SpiritShock
	if A.TranquilizingShot:IsReady(unit) and not ShouldStop and (Action.AuraIsValid(unit, "UseExpelEnrage", "Enrage") or Action.AuraIsValid(unit, "UseDispel", "Magic")) then
		return A.TranquilizingShot:Show(icon)
    end

end
PurgeDispellMagic = A.MakeFunctionCachedDynamic(PurgeDispellMagic)

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

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 


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
	local MendPet = Action.GetToggle(2, "MendPet")
	local DBM = Action.GetToggle(1, "BossMods")

	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
	
		--#####################
		--##### PRECOMBAT #####
		--#####################	
		
		local function Precombat(unit)
		
			--actions.precombat+=/tar_trap,if=runeforge.soulforge_embers
			--actions.precombat+=/double_tap,precast_time=10,if=!covenant.kyrian&(!talent.volley|active_enemies<2)
			if A.DoubleTap:IsReady(player) and DBM and Pull > 1 and Pull <= 10 and Player:GetCovenant() ~= 1 and (not A.Volley:IsTalentLearned() or MultiUnits:GetActiveEnemies() < 2) then
				return A.DoubleTap:Show(icon)
			end		
			
			--actions.precombat+=/aimed_shot,if=active_enemies<3
			if A.AimedShot:IsReady(unit) and not isMoving and MultiUnits:GetActiveEnemies() < 3 then
				return A.AimedShot:Show(icon)
			end		
			
			--actions.precombat+=/steady_shot,if=active_enemies>2
			if A.SteadyShot:IsReady(unit) and MultiUnits:GetActiveEnemies() > 2 then
				return A.SteadyShot:Show(icon)
			end				
		
		end

		--#####################
		--##### COOLDOWNS #####
		--#####################	
		
		local function Cooldowns(unit)
			--actions.cds=berserking,if=buff.trueshot.up|target.time_to_die<13
			if A.Berserking:IsReady(player) and (Unit(player):HasBuffs(A.Trueshot.ID, true) > 0 or (Unit(target):TimeToDie() < 13 and Unit(target):IsBoss())) then
				return A.Berserking:Show(icon)
			end			
			
			--actions.cds+=/blood_fury,if=buff.trueshot.up|target.time_to_die<16
			if A.BloodFury:IsReady(player) and (Unit(player):HasBuffs(A.Trueshot.ID, true) > 0 or (Unit(target):TimeToDie() < 16 and Unit(target):IsBoss())) then
				return A.BloodFury:Show(icon)
			end					
			
			--actions.cds+=/ancestral_call,if=buff.trueshot.up|target.time_to_die<16
			if A.AncestralCall:IsReady(player) and (Unit(player):HasBuffs(A.Trueshot.ID, true) > 0 or (Unit(target):TimeToDie() < 16 and Unit(target):IsBoss())) then
				return A.AncestralCall:Show(icon)
			end					
			
			--actions.cds+=/fireblood,if=buff.trueshot.up|target.time_to_die<9
			if A.Fireblood:IsReady(player) and (Unit(player):HasBuffs(A.Trueshot.ID, true) > 0 or (Unit(target):TimeToDie() < 9 and Unit(target):IsBoss())) then
				return A.Fireblood:Show(icon)
			end					
			
			--actions.cds+=/lights_judgment,if=buff.trueshot.down
			if A.LightsJudgment:IsReady(unit) and Unit(player):HasBuffs(A.Trueshot.ID, true) == 0 then
				return A.LightsJudgment:Show(icon)
			end			
			
			--actions.cds+=/bag_of_tricks,if=buff.trueshot.down
			if A.BagofTricks:IsReady(unit) and Unit(player):HasBuffs(A.Trueshot.ID, true) == 0 then
				return A.BagofTricks:Show(icon)
			end					
			
			--actions.cds+=/potion,if=buff.trueshot.up&buff.bloodlust.up|buff.trueshot.up&target.health.pct<20|target.time_to_die<26
			
		end

		--########################
		--##### SINGLETARGET #####
		--########################	
		
		local function SingleTarget(unit)
			--actions.st=steady_shot,if=talent.steady_focus&(prev_gcd.1.steady_shot&buff.steady_focus.remains<5|buff.steady_focus.down)
			if A.SteadyShot:IsReady(unit) and A.SteadyFocus:IsTalentLearned() and (
			
			--actions.st+=/kill_shot
			--actions.st+=/double_tap,if=covenant.kyrian&cooldown.resonating_arrow.remains<gcd|!covenant.kyrian&(cooldown.aimed_shot.up|cooldown.rapid_fire.remains>cooldown.aimed_shot.remains)
			--actions.st+=/flare,if=tar_trap.up&runeforge.soulforge_embers
			--actions.st+=/tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
			--actions.st+=/explosive_shot
			--actions.st+=/wild_spirits
			--actions.st+=/flayed_shot
			--actions.st+=/death_chakram,if=focus+cast_regen<focus.max
			--actions.st+=/volley,if=buff.precise_shots.down|!talent.chimaera_shot|active_enemies<2
			--actions.st+=/a_murder_of_crows
			--actions.st+=/resonating_arrow
			--actions.st+=/trueshot,if=buff.precise_shots.down|buff.resonating_arrow.up|buff.wild_spirits.up|buff.volley.up&active_enemies>1
			--actions.st+=/aimed_shot,target_if=min:(dot.serpent_sting.remains<?action.serpent_sting.in_flight_to_target*dot.serpent_sting.duration),if=buff.precise_shots.down|(buff.trueshot.up|full_recharge_time<gcd+cast_time)&(!talent.chimaera_shot|active_enemies<2)|buff.trick_shots.remains>execute_time&active_enemies>1
			--actions.st+=/rapid_fire,if=focus+cast_regen<focus.max&(buff.trueshot.down|!runeforge.eagletalons_true_focus)&(buff.double_tap.down|talent.streamline)
			--actions.st+=/chimaera_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
			--actions.st+=/arcane_shot,if=buff.precise_shots.up|focus>cost+action.aimed_shot.cost
			--actions.st+=/serpent_sting,target_if=min:remains,if=refreshable&target.time_to_die>duration
			--actions.st+=/barrage,if=active_enemies>1
			--actions.st+=/rapid_fire,if=focus+cast_regen<focus.max&(buff.double_tap.down|talent.streamline)
			--actions.st+=/steady_shot
		end

actions.trickshots=steady_shot,if=talent.steady_focus&in_flight&buff.steady_focus.remains<5
actions.trickshots+=/double_tap,if=covenant.kyrian&cooldown.resonating_arrow.remains<gcd|cooldown.rapid_fire.remains<cooldown.aimed_shot.full_recharge_time|!(talent.streamline&runeforge.surging_shots)|!covenant.kyrian
actions.trickshots+=/tar_trap,if=runeforge.soulforge_embers&tar_trap.remains<gcd&cooldown.flare.remains<gcd
actions.trickshots+=/flare,if=tar_trap.up&runeforge.soulforge_embers
actions.trickshots+=/explosive_shot
actions.trickshots+=/wild_spirits
actions.trickshots+=/resonating_arrow
actions.trickshots+=/volley
actions.trickshots+=/barrage
actions.trickshots+=/trueshot
actions.trickshots+=/rapid_fire,if=buff.trick_shots.remains>=execute_time&runeforge.surging_shots&buff.double_tap.down
actions.trickshots+=/aimed_shot,target_if=min:(dot.serpent_sting.remains<?action.serpent_sting.in_flight_to_target*dot.serpent_sting.duration),if=buff.trick_shots.remains>=execute_time&(buff.precise_shots.down|full_recharge_time<cast_time+gcd|buff.trueshot.up)
actions.trickshots+=/death_chakram,if=focus+cast_regen<focus.max
actions.trickshots+=/rapid_fire,if=buff.trick_shots.remains>=execute_time
actions.trickshots+=/multishot,if=buff.trick_shots.down|buff.precise_shots.up&focus>cost+action.aimed_shot.cost&(!talent.chimaera_shot|active_enemies>3)
actions.trickshots+=/chimaera_shot,if=buff.precise_shots.up&focus>cost+action.aimed_shot.cost&active_enemies<4
actions.trickshots+=/kill_shot,if=buff.dead_eye.down
actions.trickshots+=/a_murder_of_crows
actions.trickshots+=/flayed_shot
actions.trickshots+=/serpent_sting,target_if=min:dot.serpent_sting.remains,if=refreshable
actions.trickshots+=/multishot,if=focus>cost+action.aimed_shot.cost
actions.trickshots+=/steady_shot

		--actions=auto_shot
		--actions+=/counter_shot,line_cd=30,if=runeforge.sephuzs_proclamation|soulbind.niyas_tools_poison|(conduit.reversal_of_fortune&!runeforge.sephuzs_proclamation)
		--actions+=/use_items
		--actions+=/call_action_list,name=cds
		--actions+=/call_action_list,name=st,if=active_enemies<3
		--actions+=/call_action_list,name=trickshots,if=active_enemies>2
        
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

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil
