--######################################
--###### TRIP'S DISCIPLINE PRIEST ######
--######################################

local _G, setmetatable                            = _G, setmetatable
local A                                         = _G.Action
local TMW 								= _G.TMW
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
local Utils                                        = Action.Utils
local TeamCache                                    = Action.TeamCache
local TeamCacheFriendly                         = TeamCache.Friendly
local TeamCacheFriendlyIndexToPLAYERs           = TeamCacheFriendly.IndexToPLAYERs
local TeamCacheFriendlyUNITs			= TeamCacheFriendly.UNITs 			-- unitID to GUID 
local TeamCacheFriendlyGUIDs			= TeamCacheFriendly.GUIDs 			-- GUID to unitID 
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
local HealingEngine 							= A.HealingEngine
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local UnitExists, UnitIsPlayer, UnitClass, UnitCreatureType, UnitInRange, UnitInRaid, UnitInParty, UnitGUID, UnitPower, UnitPowerMax = 
UnitExists, UnitIsPlayer, UnitClass, UnitCreatureType, UnitInRange, UnitInRaid, UnitInParty, UnitGUID, UnitPower, UnitPowerMax

--Toaster stuff
local Toaster						= _G.Toaster -- The Action _G.Toaster will be initilized first, then _G.Toaster will be replaced by original if Toaster addon will be loaded, but we will keep our local
local GetSpellTexture 				= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_PRIEST_DISCIPLINE] = { -- Register spells
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
    Darkflight                             = Action.Create({ Type = "Spell", ID = 68992 }),

	--Priest General
    DesperatePrayer                        = Action.Create({ Type = "Spell", ID = 19236 }),
	DispelMagic							   = Action.Create({ Type = "Spell", ID = 528 }),
	Fade								   = Action.Create({ Type = "Spell", ID = 586 }),
	LeapofFaith							   = Action.Create({ Type = "Spell", ID = 73325 }),
	Levitate							   = Action.Create({ Type = "Spell", ID = 1706 }),
	MassDispel							   = Action.Create({ Type = "Spell", ID = 32375 }),
	MindBlast							   = Action.Create({ Type = "Spell", ID = 8092 }),
	MindControl							   = Action.Create({ Type = "Spell", ID = 605 }),
	MindVision							   = Action.Create({ Type = "Spell", ID = 2096 }),
	PowerWordFortitude					   = Action.Create({ Type = "Spell", ID = 21562 }),
	PowerWordShield						   = Action.Create({ Type = "Spell", ID = 17 }),
	PsychicScream						   = Action.Create({ Type = "Spell", ID = 8122 }),
	Resurrection						   = Action.Create({ Type = "Spell", ID = 2006 }),
	ShackleUndead						   = Action.Create({ Type = "Spell", ID = 9484 }),
	ShadowWordDeath						   = Action.Create({ Type = "Spell", ID = 32379 }),
	ShadowWordPain						   = Action.Create({ Type = "Spell", ID = 589 }),	
	Smite								   = Action.Create({ Type = "Spell", ID = 585 }),
	FocusedWill							   = Action.Create({ Type = "Spell", ID = 45243, Hidden = true }),
	MindSoothe							   = Action.Create({ Type = "Spell", ID = 453 }),
	PowerInfusion						   = Action.Create({ Type = "Spell", ID = 10060 }),
	
	--Discipline Specific
	HolyNova							   = Action.Create({ Type = "Spell", ID = 132157 }), --possibly changes to ID 322112 at level 56?
	MassResurrection					   = Action.Create({ Type = "Spell", ID = 212036 }),
	MindSear							   = Action.Create({ Type = "Spell", ID = 48045 }),
	PainSuppression						   = Action.Create({ Type = "Spell", ID = 33206 }),
	Penance								   = Action.Create({ Type = "Spell", ID = 47540 }),
	PenanceDMG 							   = Action.Create({ Type = "Spell", ID = 47540, Texture = 23018, Hidden = true }),
	PowerWordBarrier					   = Action.Create({ Type = "Spell", ID = 62618 }),
	PowerWordRadiance					   = Action.Create({ Type = "Spell", ID = 194509 }),
	Purify								   = Action.Create({ Type = "Spell", ID = 527 }),
	Rapture								   = Action.Create({ Type = "Spell", ID = 47536 }),
	ShadowMend							   = Action.Create({ Type = "Spell", ID = 186263 }),
	Shadowfiend							   = Action.Create({ Type = "Spell", ID = 34433 }),
	Atonement							   = Action.Create({ Type = "Spell", ID = 81749, Hidden = true }),
	MasteryGrace						   = Action.Create({ Type = "Spell", ID = 271534, Hidden = true }),
	PoweroftheDarkSide					   = Action.Create({ Type = "Spell", ID = 198068, Hidden = true }),
	
	--Talents
	Castigation							   = Action.Create({ Type = "Spell", ID = 193134, Hidden = true }),
	TwistofFate							   = Action.Create({ Type = "Spell", ID = 265259, Hidden = true }),
	Schism								   = Action.Create({ Type = "Spell", ID = 214621 }),
	BodyandSoul							   = Action.Create({ Type = "Spell", ID = 64129, Hidden = true }),
	Masochism							   = Action.Create({ Type = "Spell", ID = 193063, Hidden = true }),
	AngelicFeather						   = Action.Create({ Type = "Spell", ID = 121536 }),
	ShieldDiscipline					   = Action.Create({ Type = "Spell", ID = 197045, Hidden = true }),
	Mindbender							   = Action.Create({ Type = "Spell", ID = 123040 }),
	PowerWordSolace						   = Action.Create({ Type = "Spell", ID = 129250 }),
	PsychicVoice						   = Action.Create({ Type = "Spell", ID = 196704, Hidden = true }),
	DominantMind						   = Action.Create({ Type = "Spell", ID = 205367, Hidden = true }),
	ShiningForce						   = Action.Create({ Type = "Spell", ID = 204263 }),
	SinsoftheMany						   = Action.Create({ Type = "Spell", ID = 280391, Hidden = true }),
	Contrition							   = Action.Create({ Type = "Spell", ID = 197419, Hidden = true }),
	ShadowCovenant						   = Action.Create({ Type = "Spell", ID = 314867 }),
	PurgetheWicked						   = Action.Create({ Type = "Spell", ID = 204197 }),
	DivineStar							   = Action.Create({ Type = "Spell", ID = 110744 }),
	Halo								   = Action.Create({ Type = "Spell", ID = 120517 }),
	Lenience							   = Action.Create({ Type = "Spell", ID = 238063, Hidden = true }),
	SpiritShell							   = Action.Create({ Type = "Spell", ID = 109964 }),
	Evangelism							   = Action.Create({ Type = "Spell", ID = 246287 }),
	
	--PvP Talents
	Purification						   = Action.Create({ Type = "Spell", ID = 196162, Hidden = true }),
	PurifiedResolve						   = Action.Create({ Type = "Spell", ID = 196439, Hidden = true }),
	Trinity								   = Action.Create({ Type = "Spell", ID = 214205, Hidden = true }),
	StrengthofSoul						   = Action.Create({ Type = "Spell", ID = 197535, Hidden = true }),
	UltimateRadiance					   = Action.Create({ Type = "Spell", ID = 236499, Hidden = true }),
	DomeofLight							   = Action.Create({ Type = "Spell", ID = 197590, Hidden = true }),
	Archangel							   = Action.Create({ Type = "Spell", ID = 197862 }),
	DarkArchangel						   = Action.Create({ Type = "Spell", ID = 197871 }),
	Thoughtsteal						   = Action.Create({ Type = "Spell", ID = 316262 }),
	SearingLight						   = Action.Create({ Type = "Spell", ID = 215768, Hidden = true }),
	
	--Misc
	WeakenedSoul						   = Action.Create({ Type = "Spell", ID = 6788, Hidden = true }),
	
	--Covenants to come
	
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_PRIEST_DISCIPLINE)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_PRIEST_DISCIPLINE], { __index = Action })

local player = "player"
local targettarget = "targettarget"
local target = "target"
local mouseover = "mouseover"

Toaster:Register("TripToast", function(toast, ...) -- Register Toaster
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

local function IsSchoolHolyFree() -- Holy locked
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "HOLY") == 0
end 

local function IsSchoolShadowFree() -- Shadow locked
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function IsSchoolFireFree() -- Fire locked
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "FIRE") == 0
end 

function HealingEngine.GetMembersAll()
	-- @return array table of all select able units 
	return SortedUnitIDs 
end 

local function GetValidMembers(IsPlayer) -- Get Friendly Group Members
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

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isStrictlyEqual, isCheckEqual, isCheckCombat) -- Range check function
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

local function SelfDefensives() -- Defensives
    if Unit(player):CombatTime() == 0 then  
        return 
    end
    
    local DesperatePrayer = A.GetToggle(2, "DesperatePrayer")
    if    DesperatePrayer >= 0 and A.DesperatePrayer:IsReady(player) and 
    (
        (     -- Auto 
            DesperatePrayer >= 100 and 
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
            DesperatePrayer < 100 and 
            Unit(player):HealthPercent() <= DesperatePrayer
        )
    ) 
    then 
        return A.DesperatePrayer
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

--- ======= ACTION LISTS =======
A[3] = function(icon, isMulti) -- Single target icon displayer

--#####################
--##### VARIABLES #####
--#####################

    local isMoving = A.Player:IsMoving()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local CanCast = true
    local TotalCast, CurrentCastLeft, CurrentCastDone = Unit(player):CastTime()
    local _, castStartedTime, castEndTime = Unit(player):IsCasting()
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()
    local getmembersAll = HealingEngine.GetMembersAll()
	local PenDMG = A.GetToggle(2, "PenanceWorkMode") ~= "HEAL"
	local PenHEAL = A.GetToggle(2, "PenanceWorkMode") ~= "DMG"
	local AoE = A.GetToggle(2, "AoE")
	local PWSHP = A.GetToggle(2, "PowerWordShieldHP")
	local PWSTank = A.GetToggle(2, "PWSWorkMode") ~= "SELF"
	local PWSSelf = A.GetToggle(2, "PWSWorkMode") ~= "TANK"
	local PWSAll = A.GetToggle(2, "PWSWorkMode") == "ALL"
	local ShieldTank = A.GetToggle(2, "ShieldTank")
	local SMendNoAtone = A.GetToggle(2, "ShadowMendHPNoAtone")
	local SMendAtone = A.GetToggle(2, "ShadowMendHPWithAtone")
	local PenanceHeal = A.GetToggle(2, "PenanceHeal")
	local RadianceHP = A.GetToggle(2, "RadianceHP")
	local RadianceMembers = A.GetToggle(2, "RadianceMembers")
	local ShadowCovHP = A.GetToggle(2, "ShadowCovHP")
	local ShadowCovMembers = A.GetToggle(2, "ShadowCovMembers")
	local ShadowCovAtone = A.GetToggle(2, "ShadowCovAtone")
	local UsePurify = A.GetToggle(2, "UsePurify")
    if not CanCast then -- Pooling Icon if can't cast
        return A.PoolResource:Show(icon)
    end
	
--########################	
--##### DMG ROTATION #####
--########################
		
	local function DamageRotation(unit) -- Damage rotation
	
		if A.ShadowWordDeath:IsReady(unit) and Unit(targettarget):HealthPercent() <= 20 then
			return A.ShadowWordDeath:Show(icon)
		end	
		
		if A.ShadowWordPain:IsReady(unit) and not A.PurgetheWicked:IsTalentLearned() and (Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) == 0 or Unit(unit):HasDeBuffs(A.ShadowWordPain.ID, true) < 5) then
			return A.ShadowWordPain:Show(icon)
		end	
		
		if A.PurgetheWicked:IsReady(unit) and (Unit(unit):HasDeBuffs(A.PurgetheWicked.ID, true) == 0 or Unit(unit):HasDeBuffs(A.PurgetheWicked.ID, true) < 5) then
			return A.PurgetheWicked:Show(icon)
		end	
		
		if A.Schism:IsReady(unit) and not isMoving then
			return A.Schism:Show(icon)
		end

		if A.Halo:IsReady(player) and not isMoving then
			return A.Halo:Show(icon)
		end
		
		if A.DivineStar:IsReady(player) and Unit(unit):GetRange() <= 24 then
			return A.DivineStar:Show(icon)
		end	
		
		if A.MindBlast:IsReady(unit) and not isMoving then
			return A.MindBlast:Show(icon)
		end

		if A.PowerWordSolace:IsReady(unit) then
			return A.PowerWordSolace:Show(icon)
		end

		if A.Penance:IsReady(unit) and PenDMG then
			return A.PenanceDMG:Show(icon)
		end	
		
		if A.MindSear:IsReady(unit) and MultiUnits:GetActiveEnemies() >= 2 and AoE and not isMoving then
			return A.MindSear:Show(icon)
		end				
		
		if A.Smite:IsReady(unit) and not isMoving then
			return A.Smite:Show(icon)
		end
	
		if A.MindSear:IsReady(unit) and not isMoving then
			return A.MindSear:Show(icon)
		end	
	
	end


	--############################	
	--##### HEALING ROTATION #####
	--############################

	local function HealingRotation(unit)


		--Healing Engine Purify Target
		if A.Purify:IsReady() and UsePurify then
			for i = 1, #getmembersAll do 
				if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel") then
					if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
					HealingEngine.SetTarget(getmembersAll[i].Unit) 
					break
                    else HealingEngine.SetTarget(getmembersAll[i].Unit)
					end
				end				
			end
		end

		--Purify
		if CanCast and A.Purify:IsReady(unit) and A.Purify:AbsentImun(unit) and A.AuraIsValid(unit, "UseDispel", "Dispel") and Unit(unit):TimeToDie() > 5 then 
			return A.Purify:Show(icon)
		end 

		--Power Word: Radiance
		if A.PowerWordRadiance:IsReady(unit) and not isMoving and HealingEngine.GetBelowHealthPercentUnits(RadianceHP, 40) > RadianceMembers and HealingEngine.GetBuffsCount(194384, 1) <= 4 then
			return A.PowerWordRadiance:Show(icon)
		end	
		
		--Shadow Covenant
		if A.ShadowCovenant:IsReady(unit) and HealingEngine.GetBelowHealthPercentUnits(ShadowCovHP, 30) > ShadowCovMembers and HealingEngine.GetBuffsCount(194384, 5) >= ShadowCovAtone then
			return A.ShadowCovenant:Show(icon)
		end	

		--Penance Heal
		if A.Penance:IsReady(unit) and Unit(unit):HealthPercent() <= PenanceHeal and PenHEAL then
			return A.Penance:Show(icon)
		end	
	
		--ShadowMend with Atonement
		if A.ShadowMend:IsReady(unit) and not isMoving and Unit(unit):HealthPercent() <= SMendAtone and Unit(unit):HasBuffs(A.Atonement.ID, true) > 0 then
			return A.ShadowMend:Show(icon)
		end	

		--ShadowMend without Atonement
		if A.ShadowMend:IsReady(unit) and not isMoving and Unit(unit):HealthPercent() <= SMendNoAtone and Unit(unit):HasBuffs(A.Atonement.ID, true) == 0 then
			return A.ShadowMend:Show(icon)
		end	

		--PW:S Tank on cooldown
		if A.PowerWordShield:IsReady(unit) and ShieldTank and Unit(unit):IsTank() and Unit(unit):HasDeBuffs(A.WeakenedSoul.ID, true) == 0 then
			return A.PowerWordShield:Show(icon)
		end	
	
		--PW:S
		if A.PowerWordShield:IsReady(unit) and Unit(unit):HasDeBuffs(A.WeakenedSoul.ID, true) == 0 and Unit(unit):HasBuffs(A.PowerWordShield.ID, true) == 0 and Unit(unit):HasBuffs(A.Atonement.ID, true) < 2 and Unit(unit):HealthPercent() <= PWSHP and (PWSAll or (UnitIsUnit("target", "player") and PWSSelf) or (Unit(unit):IsTank() and PWSTank)) then 
			return A.PowerWordShield:Show(icon)
		end		
	
	end

	--#############################
	--##### MAIN ACTION CALLS #####
	--#############################
	
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
	-- Friendly Mouseover
    if A.IsUnitFriendly(mouseover) then 
        unit = mouseover  
		
        if HealingRotation(unit) then 
            return true 
        end             
    end
	
    -- Heal Target 
    if A.IsUnitFriendly(target) then 
        unit = target 
		
        if HealingRotation(unit) then 
            return true 
        end 
    end    
	
    -- Enemy Mouseover 
    if A.IsUnitEnemy(mouseover) then 
        unit = mouseover	
		
        if DamageRotation(unit) then 
            return true 
        end 
    end 
    
    -- DPS Target     
    if A.IsUnitEnemy(target) then 
        unit = target
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 

    -- DPS targettarget     
    if A.IsUnitEnemy(targettarget) then 
        unit = targettarget
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 

		
end 
    
    -- End of Rotation

A[4] = nil -- AoE icon display

A[5] = nil -- Trinket icon display

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
