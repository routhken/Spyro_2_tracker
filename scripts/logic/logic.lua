-- Core Functions
function has_not(item)
    return Tracker:ProviderCountForCode(item) == 0
end

function has(item)
    return Tracker:ProviderCountForCode(item) > 0
end

function has_at_least(item, amount)
    return Tracker:ProviderCountForCode(item) >= amount
end

-- Visibility Rules
function hasGoalRipto()
    return has("goal_ripto")
end

-- function hasGoalTalisman()
--     return has("goal_14_talisman")
-- end

-- function hasGoal40Orb()
--     return has("goal_40_orb")
-- end

function hasGoal64Orb()
    return has("goal_64_orb")
end

function hasGoal100Percent()
    return has("goal_100_percent")
end

function hasGoal10Token()
    return has("goal_10_tokens")
end

function hasGoalSkillpoint()
    return has("goal_all_skillpoints")
end

function hasGoalEpilogue()
    return has("goal_epilogue")
end

function hasOpenWorld()
    return has("setting_open_world")
end

function hasOpenAbilityAndWarps()
    return has("setting_open_world_ability_and_warp_unlocks")
end

function hasLevelLocks()
    return has("setting_level_lock")
end

function hasTotalGems()
    return has("setting_enable_total_gem_checks")
end

function hasMaxTotalAtLeast(amount)
    if has("setting_enable_total_gem_checks") then
        return has_at_least("setting_max_total_gem_checks",tonumber(amount))
    else
        return false
    end
end

function hasSkillPoints()
    return has("setting_enable_skillpoint_checks")
end

function hasSkillPointsGoal()
    return hasGoalSkillpoint() or hasGoalEpilogue()
end

function hasLifeBottles()
    return has("setting_enable_life_bottle_checks")
end

function hasSpiritParticles()
    return has("setting_enable_spirit_particle_checks")
end

function hasMoneybagsVanilla()
    return has("setting_moneybags_vanilla")
end

function hasDeathlink()
    return has("setting_deathlink")
end

-- function hasEarlyCrush()
--     return has("setting_logic_crush_early")
-- end

-- function hasEarlyGulp()
--     return has("setting_logic_gulp_early")
-- end

-- function hasEarlyRipto()
--     return has("setting_logic_ripto_early")
-- end

-- Accessibilty Rules
function hasCrushDefeated()
    return has("crush_defeated") or (hasOpenWorld() and hasOpenAbilityAndWarps())
end

function hasGulpDefeated()
    return has("gulp_defeated") or (hasOpenWorld() and hasOpenAbilityAndWarps())
end

function hasRiptoDefeated()
    return has("ripto_defeated")
end

function hasSwim()
    return has("swim") or hasRiptoDefeated()
end

function hasClimb()
    return has("climb") or hasRiptoDefeated()
end

function hasHeadbash()
    return has("headbash") or hasRiptoDefeated()
end

function hasDoubleJump()
    return has("double_jump")
end

function maxSparxHealth()
    if not has("setting_enable_progressive_sparx_logic") then
        return 3
    else
        return Tracker:FindObjectForCode("progressive_sparx").CurrentStage
    end
end

function canReachSummerSecondHalf()
    return hasSwim()
end

function canReachMetro()
    return has_at_least("orb",6)
end

function canReachAutumnSecondHalf()
    return hasClimb()
end

function canPassAutumnDoor()
    return (canReachAutumnSecondHalf() and has_at_least("orb",8))
end

function canReachWinterSecondHalf()
    return hasHeadbash()
end

function canReachRiptoDoor()
    return has_at_least("orb",Tracker:FindObjectForCode("setting_ripto_door_orbs").AcquiredCount)
end

function hasAquariaWall()
    return has("money_at_wall") or hasRiptoDefeated()
end

function hasAquariaSub()
    return has("money_at_sub") or hasRiptoDefeated()
end

function hasSOPortal()
    return has("money_so_portal") or hasRiptoDefeated()
end

function hasCGBridge()
    return has("money_cg_bridge") or hasRiptoDefeated()
end

function hasMCElevator()
    return has("money_mc_elevator") or hasRiptoDefeated()
end

function hasZPortal()
    return has("money_z_portal") or hasRiptoDefeated()
end

function hasISPortal()
    return has("money_is_portal") or hasRiptoDefeated()
end

function hasCSPortal()
    return has("money_cs_portal") or hasRiptoDefeated()
end

function hasIdolSpringsAccess()
    if hasLevelLocks() and (not has("idol_springs_unlock")) then
        return false
    end
    return true
end

function hasColossusAccess()
    if hasLevelLocks() and (not has("colossus_unlock")) then
        return false
    end
    return true
end

function hasHurricosAccess()
    if not canReachSummerSecondHalf() then
        return false
    end
    if hasLevelLocks() and (not has("hurricos_unlock")) then
        return false
    end
    return true
end

function hasAquariaTowersAccess()
    if (not canReachSummerSecondHalf()) or (not hasAquariaWall()) or (not (maxSparxHealth() >= 1)) then
        return false
    end
    if hasLevelLocks() and (not has("aquaria_towers_unlock")) then
        return false
    end
    return true
end

function hasSunnyBeachAccess()
    if not canReachSummerSecondHalf() then
        return false
    end
    if hasLevelLocks() and (not has("sunny_beach_unlock")) then
        return false
    end
    return true
end

function hasOceanSpeedwayAccess()
    if (not canReachSummerSecondHalf()) or (not has_at_least("orb",3)) then
        return false
    end
    if hasLevelLocks() and (not has("ocean_speedway_unlock")) then
        return false
    end
    return true
end

function hasCrushAccess()
    if hasOpenWorld() then -- or has("setting_logic_crush_early_on") or (has("setting_logic_crush_early_with_dj") and has("setting_double_jump_ability_vanilla")) then
        return (canReachSummerSecondHalf() and (maxSparxHealth() >= 1))
    -- elseif has("setting_logic_crush_early_with_dj") then
    --     return (canReachSummerSecondHalf() and (maxSparxHealth() >= 1) and hasDoubleJump() and has_at_least("summer_talisman",6))
    else
        return (canReachSummerSecondHalf() and (maxSparxHealth() >= 1) and has_at_least("summer_talisman",6))
    end
end

function hasAutumnPlainsAccess()
    if not (hasOpenWorld() and hasOpenAbilityAndWarps()) and not hasCrushDefeated() then
        return false
    end
    return true
end

function hasSkelosBadlandsAccess()
    if (not hasAutumnPlainsAccess()) or (not (maxSparxHealth() >= 2)) then
        return false
    end
    if hasLevelLocks() and (not has("skelos_badlands_unlock")) then
        return false
    end
    return true
end

function hasCrystalGlacierAccess()
    if not hasAutumnPlainsAccess() then
        return false
    end
    if hasLevelLocks() and (not has("crystal_glacier_unlock")) then
        return false
    end
    return true
end

function hasBreezeHarborAccess()
    if not hasAutumnPlainsAccess() then
        return false
    end
    if hasLevelLocks() and (not has("breeze_harbor_unlock")) then
        return false
    end
    return true
end

function hasZephyrAccess()
    if (not hasAutumnPlainsAccess()) or (not hasZPortal()) then
        return false
    end
    if hasLevelLocks() and (not has("zephyr_unlock")) then
        return false
    end
    return true
end

function hasMetroSpeedwayAccess()
    if (not hasAutumnPlainsAccess()) or (not canReachMetro()) then
        return false
    end
    if hasLevelLocks() and (not has("metro_speedway_unlock")) then
        return false
    end
    return true
end

function hasScorchAccess()
    if (not hasAutumnPlainsAccess()) or (not canReachAutumnSecondHalf()) then
        return false
    end
    if hasLevelLocks() and (not has("scorch_unlock")) then
        return false
    end
    return true
end

function hasShadyOasisAccess()
    if (not hasAutumnPlainsAccess()) or (not canPassAutumnDoor()) or (not hasSOPortal()) then
        return false
    end
    if hasLevelLocks() and (not has("shady_oasis_unlock")) then
        return false
    end
    return true
end

function hasMagmaConeAccess()
    if (not hasAutumnPlainsAccess()) or (not canPassAutumnDoor()) then
        return false
    end
    if hasLevelLocks() and (not has("magma_cone_unlock")) then
        return false
    end
    return true
end

function hasFractureHillsAccess()
    if (not hasAutumnPlainsAccess()) or (not canReachAutumnSecondHalf()) then
        return false
    end
    if hasLevelLocks() and (not has("fracture_hills_unlock")) then
        return false
    end
    return true
end

function hasIcySpeedwayAccess()
    if (not hasAutumnPlainsAccess()) or (not canPassAutumnDoor()) or (not hasISPortal()) then
        return false
    end
    if hasLevelLocks() and (not has("icy_speedway_unlock")) then
        return false
    end
    return true
end

function hasGulpAccess()
    if hasOpenWorld() then -- or has("setting_logic_gulp_early_on") or (has("setting_logic_gulp_early_with_dj") and has("setting_double_jump_ability_vanilla")) then
        return (canPassAutumnDoor() and (maxSparxHealth() >= 2))
    -- elseif has("setting_logic_gulp_early_with_dj") then
    --     return (canPassAutumnDoor() and (maxSparxHealth() >= 2) and hasDoubleJump() and has_at_least("summer_talisman",6) and has_at_least("autumn_talisman",8))
    else
        return (canPassAutumnDoor() and (maxSparxHealth() >= 2) and has_at_least("summer_talisman",6) and has_at_least("autumn_talisman",8))
    end
end

function hasWinterTundraAccess()
    if not (hasOpenWorld() and hasOpenAbilityAndWarps()) and not hasGulpDefeated() then
        return false
    end
    return true
end

function hasMysticMarshAccess()
    if not hasWinterTundraAccess() then
        return false
    end
    if hasLevelLocks() and (not has("mystic_marsh_unlock")) then
        return false
    end
    return true
end

function hasCloudTemplesAccess()
    if (not hasWinterTundraAccess()) or (not has_at_least("orb",15)) then
        return false
    end
    if hasLevelLocks() and (not has("cloud_temples_unlock")) then
        return false
    end
    return true
end

function hasCanyonSpeedwayAccess()
    if (not hasWinterTundraAccess()) or (not hasCSPortal()) then
        return false
    end
    if hasLevelLocks() and (not has("canyon_speedway_unlock")) then
        return false
    end
    return true
end

function hasRoboticaFarmsAccess()
    if (not hasWinterTundraAccess()) or (not canReachWinterSecondHalf()) then
        return false
    end
    if hasLevelLocks() and (not has("robotica_farms_unlock")) then
        return false
    end
    return true
end

function hasMetropolisAccess()
    if (not hasWinterTundraAccess()) or (not canReachWinterSecondHalf()) or (not has_at_least("orb",25)) then
        return false
    end
    if hasLevelLocks() and (not has("metropolis_unlock")) then
        return false
    end
    return true
end

function hasRiptoAccess()
    if (not hasWinterTundraAccess()) then
        return false
    -- end
    -- if has("setting_logic_ripto_early_on") or (has("setting_logic_ripto_early_with_dj") and has("setting_double_jump_ability_vanilla")) then
    --     return (canReachWinterSecondHalf() and (maxSparxHealth() >= 3))
    -- elseif has("setting_logic_ripto_early_with_dj") then
    --     return (canReachWinterSecondHalf() and (maxSparxHealth() >= 3) and hasDoubleJump() and has_at_least("orb",40))
    else
        return (canReachWinterSecondHalf() and (maxSparxHealth() >= 3) and canReachRiptoDoor())
    end
end

function hasDragonShoresAccess()
    if (not hasRiptoDefeated()) then
        return false
    end
    if (not has_at_least("orb",55)) or (not canReachTotalGemCount(8000)) then
        return false
    end
    if hasLevelLocks() and (not has("aquaria_towers_unlock")) then
        return false
    end
    return true
end

function reachableGemCountSummerForest()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        reachable_gems = 155
        if hasSwim() then
            reachable_gems = reachable_gems + 221
            if hasAquariaWall() then
                reachable_gems = reachable_gems + 14
            end
            if hasClimb() then
                reachable_gems = reachable_gems + 10
            end
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_summ")
    end
    return reachable_gems
end

function reachableGemCountGlimmer()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        reachable_gems = 353
        if hasClimb() then
            reachable_gems = reachable_gems + 47
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_glim")
    end
    return reachable_gems
end

function reachableGemCountIdolSprings()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasIdolSpringsAccess() then
            return 0
        end
        reachable_gems = 298
        if hasSwim() then
            reachable_gems = reachable_gems + 102
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_idol")
    end
    return reachable_gems
end

function reachableGemCountColossus()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasColossusAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_colo")
    end
    return reachable_gems
end

function reachableGemCountHurricos()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasHurricosAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_hurr")
    end
    return reachable_gems
end

function reachableGemCountAquariaTowers()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasAquariaTowersAccess() then
            return 0
        end
        reachable_gems = 127
        if hasAquariaSub() then
            reachable_gems = reachable_gems + 273
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_aqua")
    end
    return reachable_gems
end

function reachableGemCountSunnyBeach()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasSunnyBeachAccess() then
            return 0
        end
        reachable_gems = 380
        if hasClimb() then
            reachable_gems = reachable_gems + 20
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_sunn")
    end
    --print("DEBUG- Sunny Beach reachable gems: " .. tostring(reachable_gems))
    return reachable_gems
end

function reachableGemCountOceanSpeedway()
    local reachable_gems = 0
    if not hasOceanSpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_ocea")
    end
    return reachable_gems
end

function reachableGemCountAutumnPlains()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasAutumnPlainsAccess() then
            return 0
        end
        reachable_gems = 118
        if canReachMetro() then
            reachable_gems = reachable_gems + 22
        end
        if canReachAutumnSecondHalf() then
            reachable_gems = reachable_gems + 51
        end
        if canPassAutumnDoor() then
            reachable_gems = reachable_gems + 202
            if hasSOPortal() then
                reachable_gems = reachable_gems + 7
            end
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_autu")
    end
    return reachable_gems
end

function reachableGemCountSkelosBadlands()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasSkelosBadlandsAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_skel")
    end
    return reachable_gems
end

function reachableGemCountCrystalGlacier()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasCrystalGlacierAccess() then
            return 0
        end
        reachable_gems = 245
        if hasCGBridge() then
            reachable_gems = reachable_gems + 155
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_crys")
    end
    return reachable_gems
end

function reachableGemCountBreezeHarbor()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasBreezeHarborAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_bree")
    end
    return reachable_gems
end

function reachableGemCountZephyr()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasZephyrAccess() then
            return 0
        end
        reachable_gems = 284
        if hasClimb() then
            reachable_gems = reachable_gems + 116
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_zeph")
    end
    return reachable_gems
end

function reachableGemCountMetroSpeedway()
    local reachable_gems = 0
    if not hasMetroSpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_mesp")
    end
    return reachable_gems
end

function reachableGemCountScorch()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasScorchAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_scor")
    end
    return reachable_gems
end

function reachableGemCountShadyOasis()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasShadyOasisAccess() then
            return 0
        end
        reachable_gems = 380
        if hasHeadbash() then
            reachable_gems = reachable_gems + 20
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_shad")
    end
    return reachable_gems
end

function reachableGemCountMagmaCone()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasMagmaConeAccess() then
            return 0
        end
        reachable_gems = 295
        if hasMCElevator() then
            reachable_gems = reachable_gems + 105
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_magm")
    end
    return reachable_gems
end

function reachableGemCountFractureHills()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasFractureHillsAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_frac")
    end
    return reachable_gems
end

function reachableGemCountIcySpeedway()
    local reachable_gems = 0
    if not hasIcySpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_icys")
    end
    return reachable_gems
end

function reachableGemCountWinterTundra()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasWinterTundraAccess() then
            return 0
        end
        reachable_gems = 139
        if hasHeadbash() then
            reachable_gems = reachable_gems + 254
            if canReachRiptoDoor() then
                reachable_gems = reachable_gems + 7
            end
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_wint")
    end
    return reachable_gems
end

function reachableGemCountMysticMarsh()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasMysticMarshAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_myst")
    end
    return reachable_gems
end

function reachableGemCountCloudTemples()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasCloudTemplesAccess() then
            return 0
        end
        reachable_gems = 375
        if hasHeadbash() then
            reachable_gems = reachable_gems + 25
        end
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_clou")
    end
    return reachable_gems
end

function reachableGemCountCanyonSpeedway()
    local reachable_gems = 0
    if not hasCanyonSpeedwayAccess() then
        return 0
    -- elseif has("setting_enable_gemsanity_off") then
    --     reachable_gems = 400
    else
        reachable_gems = 400 --Tracker:ProviderCountForCode("inventory_gems_cany")
    end
    return reachable_gems
end

function reachableGemCountRoboticaFarms()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasRoboticaFarmsAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_robo")
    end
    return reachable_gems
end

function reachableGemCountMetropolis()
    local reachable_gems = 0
    if has("setting_enable_gemsanity_off") then
        if not hasMetropolisAccess() then
            return 0
        end
        reachable_gems = 400
    else
        reachable_gems = Tracker:ProviderCountForCode("inventory_gems_metr")
    end
    return reachable_gems
end

function canReachGemCount(area, amount)
    local reachable_gems = 0
    if area == "summer_forest" then
        reachable_gems = reachableGemCountSummerForest()
    elseif area == "glimmer" then
        reachable_gems = reachableGemCountGlimmer()
    elseif area == "idol_springs" then
        reachable_gems = reachableGemCountIdolSprings()
    elseif area == "colossus" then
        reachable_gems = reachableGemCountColossus()
    elseif area == "hurricos" then
        reachable_gems = reachableGemCountHurricos()
    elseif area == "aquaria_towers" then
        reachable_gems = reachableGemCountAquariaTowers()
    elseif area == "sunny_beach" then
        reachable_gems = reachableGemCountSunnyBeach()
    elseif area == "ocean_speedway" then
        reachable_gems = reachableGemCountOceanSpeedway()
    elseif area == "autumn_plains" then
        reachable_gems = reachableGemCountAutumnPlains()
    elseif area == "skelos_badlands" then
        reachable_gems = reachableGemCountSkelosBadlands()
    elseif area == "crystal_glacier" then
        reachable_gems = reachableGemCountCrystalGlacier()
    elseif area == "breeze_harbor" then
        reachable_gems = reachableGemCountBreezeHarbor()
    elseif area == "zephyr" then
        reachable_gems = reachableGemCountZephyr()
    elseif area == "metro_speedway" then
        reachable_gems = reachableGemCountMetroSpeedway()
    elseif area == "scorch" then
        reachable_gems = reachableGemCountScorch()
    elseif area == "shady_oasis" then
        reachable_gems = reachableGemCountShadyOasis()
    elseif area == "magma_cone" then
        reachable_gems = reachableGemCountMagmaCone()
    elseif area == "fracture_hills" then
        reachable_gems = reachableGemCountFractureHills()
    elseif area == "icy_speedway" then
        reachable_gems = reachableGemCountIcySpeedway()
    elseif area == "winter_tundra" then
        reachable_gems = reachableGemCountWinterTundra()
    elseif area == "mystic_marsh" then
        reachable_gems = reachableGemCountMysticMarsh()
    elseif area == "cloud_temples" then
        reachable_gems = reachableGemCountCloudTemples()
    elseif area == "canyon_speedway" then
        reachable_gems = reachableGemCountCanyonSpeedway()
    elseif area == "robotica_farms" then
        reachable_gems = reachableGemCountRoboticaFarms()
    elseif area == "metropolis" then
        reachable_gems = reachableGemCountMetropolis()
    end

    if reachable_gems >= tonumber(amount) then
        return true
    else
        return false
    end
end

function canReachTotalGemCount(amount)
    local reachable_gems = 0
    reachable_gems = reachable_gems + reachableGemCountSummerForest()
    reachable_gems = reachable_gems + reachableGemCountGlimmer()
    reachable_gems = reachable_gems + reachableGemCountIdolSprings()
    reachable_gems = reachable_gems + reachableGemCountColossus()
    reachable_gems = reachable_gems + reachableGemCountHurricos()
    reachable_gems = reachable_gems + reachableGemCountAquariaTowers()
    reachable_gems = reachable_gems + reachableGemCountSunnyBeach()
    reachable_gems = reachable_gems + reachableGemCountOceanSpeedway()
    reachable_gems = reachable_gems + reachableGemCountAutumnPlains()
    reachable_gems = reachable_gems + reachableGemCountSkelosBadlands()
    reachable_gems = reachable_gems + reachableGemCountCrystalGlacier()
    reachable_gems = reachable_gems + reachableGemCountBreezeHarbor()
    reachable_gems = reachable_gems + reachableGemCountZephyr()
    reachable_gems = reachable_gems + reachableGemCountMetroSpeedway()
    reachable_gems = reachable_gems + reachableGemCountScorch()
    reachable_gems = reachable_gems + reachableGemCountShadyOasis()
    reachable_gems = reachable_gems + reachableGemCountMagmaCone()
    reachable_gems = reachable_gems + reachableGemCountFractureHills()
    reachable_gems = reachable_gems + reachableGemCountIcySpeedway()
    reachable_gems = reachable_gems + reachableGemCountWinterTundra()
    reachable_gems = reachable_gems + reachableGemCountMysticMarsh()
    reachable_gems = reachable_gems + reachableGemCountCloudTemples()
    reachable_gems = reachable_gems + reachableGemCountCanyonSpeedway()
    reachable_gems = reachable_gems + reachableGemCountRoboticaFarms()
    reachable_gems = reachable_gems + reachableGemCountMetropolis()

    if reachable_gems >= tonumber(amount) then
        return true
    else
        return false
    end
end