ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
Tracker.AllowDeferredLogicUpdate = true


CURRENT_INDEX = -1

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

Set = {}

function Set.new (t)
    local set = {}
    for _, l in ipairs(t) do set[l] = true end
    return set
end

function tableMerge(result, ...)
  for _, t in ipairs({...}) do
    for _, v in ipairs(t) do
      table.insert(result, v)
    end
  end
end

function onClear(slotData)
    Tracker.BulkUpdate = true
    CURRENT_INDEX = -1
    sd_options = slotData['options']

    -- Reset Locations
    for _, layoutLocationPath in pairs(LOCATION_MAPPING) do

        if  layoutLocationPath and layoutLocationPath[1] then
            
            for _,layoutLocationElement in pairs(layoutLocationPath) do
                local layoutLocationObject = Tracker:FindObjectForCode(layoutLocationElement)

                if layoutLocationObject then
                    if layoutLocationElement:sub(1, 1) == "@" then
                        layoutLocationObject.AvailableChestCount = layoutLocationObject.ChestCount
                    else
                        layoutLocationObject.Active = false
                    end
                end
            end
        end
    end

    -- Reset Items
    for _, layoutItemData in pairs(ITEM_MAPPING) do
        if layoutItemData[1] and layoutItemData[2] then
            local layoutItemObject = Tracker:FindObjectForCode(layoutItemData[1])

            if layoutItemObject then
                if layoutItemData[2] == "toggle" then
                    layoutItemObject.Active = false
                elseif layoutItemData[2] == "progressive" then
                    layoutItemObject.CurrentStage = 0
                    layoutItemObject.Active = false
                elseif layoutItemData[2] == "consumable" then
                    layoutItemObject.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: Unknown item type %s for code %s", layoutItemData[2], layoutItemData[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: Could not find object for code %s", layoutItemData[1]))
            end
        end
    end

    -- Reset Settings
    Tracker:FindObjectForCode("goal_option").Active = true
    Tracker:FindObjectForCode("goal_14_talisman").Active = false
    Tracker:FindObjectForCode("goal_40_orb").Active = false
    Tracker:FindObjectForCode("goal_64_orb").Active = false
    Tracker:FindObjectForCode("goal_100_percent").Active = false
    Tracker:FindObjectForCode("goal_10_tokens").Active = false
    Tracker:FindObjectForCode("goal_all_skillpoints").Active = false
    Tracker:FindObjectForCode("goal_epilogue").Active = false

    --Experiement with this stuff later
    -- print("DEBUG- Checked Location 0: " .. tostring(Archipelago.CheckedLocations[0]))
    -- print("DEBUG- Checked Location 1: " .. tostring(Archipelago.CheckedLocations[1]))
    -- print("DEBUG- Checked Location 2: " .. tostring(Archipelago.CheckedLocations[2]))
    -- print("DEBUG- Checked Location 3: " .. tostring(Archipelago.CheckedLocations[3]))
    -- print("DEBUG- Missing Location 0: " .. tostring(Archipelago.MissingLocations[0]))
    -- print("DEBUG- Missing Location 1: " .. tostring(Archipelago.MissingLocations[1]))
    -- print("DEBUG- Missing Location 2: " .. tostring(Archipelago.MissingLocations[2]))
    -- print("DEBUG- Missing Location 3: " .. tostring(Archipelago.MissingLocations[3]))
    --Archipelago.MissingLocations
    --Tracker:UiHint("ActivateTab", "Hint")

    --print("DEBUG----Slotdata: ") --debug
    --print(dump(slotData)) --debug
    --print("DEBUG- Goal: " .. tostring(sd_options['goal'])) --debug

    if sd_options['goal'] then
        local goalValue = sd_options['goal']
        local goalTrackerKey = nil
        local goalValueIndex = goalValue
        --print("DEBUG----goalValue: " .. goalValue) --debug

        if      goalValue == 0 then
            goalTrackerKey = "goal_ripto"
        elseif  goalValue == 1 then
            goalTrackerKey = "goal_14_talisman"
        elseif  goalValue == 2 then
            goalTrackerKey = "goal_40_orb"
        elseif  goalValue == 3 then
            goalTrackerKey = "goal_64_orb"
        elseif  goalValue == 4 then
            goalTrackerKey = "goal_100_percent"
        elseif  goalValue == 5 then
            goalTrackerKey = "goal_10_tokens"
        elseif  goalValue == 6 then
            goalTrackerKey = "goal_all_skillpoints"
        elseif  goalValue == 7 then
            goalTrackerKey = "goal_epilogue"
        end

        --print("DEBUG----goalTrackerKey: " .. goalTrackerKey) --debug
        if goalTrackerKey then
            --local goalTrackerObject = Tracker:FindObjectForCode(goalTrackerKey)
            Tracker:FindObjectForCode("goal_option").CurrentStage = goalValueIndex
            --goalTrackerObject.Active = true
        end
    end

    Tracker:FindObjectForCode("setting_enable_open_world").Active = false
    Tracker:FindObjectForCode("setting_open_world_level_unlocks").CurrentStage = 0
    Tracker:FindObjectForCode("setting_open_world_ability_and_warp_unlocks").Active = false
    Tracker:FindObjectForCode("setting_enable_25_pct_gem_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_50_pct_gem_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_75_pct_gem_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_gem_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_total_gem_checks").Active = false
    Tracker:FindObjectForCode("setting_max_total_gem_checks").CurrentStage = 0
    Tracker:FindObjectForCode("setting_enable_skillpoint_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_life_bottle_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_spirit_particle_checks").Active = false
    Tracker:FindObjectForCode("setting_enable_gemsanity").CurrentStage = 0
    Tracker:FindObjectForCode("setting_moneybags_settings").CurrentStage = 0
    Tracker:FindObjectForCode("setting_enable_progressive_sparx_health").CurrentStage = 0
    Tracker:FindObjectForCode("setting_enable_progressive_sparx_logic").Active = false
    Tracker:FindObjectForCode("setting_double_jump_ability").CurrentStage = 2
    Tracker:FindObjectForCode("setting_permanent_fireball_ability").CurrentStage = 2
    Tracker:FindObjectForCode("setting_logic_crush_early").CurrentStage = 0
    Tracker:FindObjectForCode("setting_logic_gulp_early").CurrentStage = 0
    Tracker:FindObjectForCode("setting_logic_ripto_early").CurrentStage = 0

    if sd_options['enable_open_world'] == 1 then
        Tracker:FindObjectForCode("setting_enable_open_world").Active = true
        Tracker:FindObjectForCode("setting_open_world_level_unlocks").AcquiredCount = sd_options['open_world_level_unlocks']
        if sd_options['open_world_ability_and_warp_unlocks'] == 1 then
            Tracker:FindObjectForCode("setting_open_world_ability_and_warp_unlocks").Active = true
        end
    end
    if sd_options['enable_25_pct_gem_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_25_pct_gem_checks").Active = true
    end
    if sd_options['enable_50_pct_gem_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_50_pct_gem_checks").Active = true
    end
    if sd_options['enable_75_pct_gem_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_75_pct_gem_checks").Active = true
    end
    if sd_options['enable_gem_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_gem_checks").Active = true
    end
    if sd_options['enable_total_gem_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_total_gem_checks").Active = true
        --print("DEBUG- Max total gems: " .. tostring(sd_options['max_total_gem_checks']))
        Tracker:FindObjectForCode("setting_max_total_gem_checks").AcquiredCount = sd_options['max_total_gem_checks']
    end
    if sd_options['enable_skillpoint_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_skillpoint_checks").Active = true
    end
    if sd_options['enable_life_bottle_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_life_bottle_checks").Active = true
    end
    if sd_options['enable_spirit_particle_checks'] == 1 then
        Tracker:FindObjectForCode("setting_enable_spirit_particle_checks").Active = true
    end
    if sd_options['enable_gemsanity'] ~= 0 then
        Tracker:FindObjectForCode("setting_enable_gemsanity").CurrentStage = sd_options['enable_gemsanity']
    end
    if sd_options['moneybags_settings'] ~= 0 then
        Tracker:FindObjectForCode("setting_moneybags_settings").CurrentStage = sd_options['moneybags_settings']
    end
    if sd_options['enable_progressive_sparx_health'] ~= 0 then
        Tracker:FindObjectForCode("setting_enable_progressive_sparx_health").CurrentStage = sd_options['enable_progressive_sparx_health']
        if sd_options['enable_progressive_sparx_health'] ~= 4 then
            if sd_options['enable_progressive_sparx_logic'] == 1 then
                Tracker:FindObjectForCode("setting_enable_progressive_sparx_logic").Active = true
            end
        end
    end
    if sd_options['double_jump_ability'] ~= 0 then
        Tracker:FindObjectForCode("setting_double_jump_ability").CurrentStage = sd_options['double_jump_ability']
    end
    if sd_options['permanent_fireball_ability'] ~= 0 then
        Tracker:FindObjectForCode("setting_permanent_fireball_ability").CurrentStage = sd_options['permanent_fireball_ability']
    end
    if sd_options['logic_crush_early'] ~= 0 then
        Tracker:FindObjectForCode("setting_logic_crush_early").CurrentStage = sd_options['logic_crush_early']
    end
    if sd_options['logic_gulp_early'] ~= 0 then
        Tracker:FindObjectForCode("setting_logic_gulp_early").CurrentStage = sd_options['logic_gulp_early']
    end
    if sd_options['logic_ripto_early'] ~= 0 then
        Tracker:FindObjectForCode("setting_logic_ripto_early").CurrentStage = sd_options['logic_ripto_early']
    end

    --GEMSANITY
    if sd_options['enable_gemsanity'] ~= 0 then
        --We are going to check if a value exists a LOT so much faster to make a set
        local gem_arr_combined = {}
        tableMerge(gem_arr_combined, Archipelago.CheckedLocations, Archipelago.MissingLocations)
        local gem_set_combined = Set.new(gem_arr_combined)
        
        local gem_codes = {
            --gem code base, first location ID , last location ID
            {"summer_forest_gem_",   1230009, 1230146},
            {"glimmer_gem_",         1231004, 1231136},
            {"idol_springs_gem_",    1232006, 1232154},
            {"colossus_gem_",        1233007, 1233143},
            {"hurricos_gem_",        1234007, 1234120},
            {"aquaria_towers_gem_",  1235008, 1235144},
            {"sunny_beach_gem_",     1236004, 1236121},
            {"autumn_plains_gem_",   1239007, 1239112},
            {"skelos_badlands_gem_", 1240010, 1240103},
            {"crystal_glacier_gem_", 1241005, 1241109},
            {"breeze_harbor_gem_",   1242005, 1242101},
            {"zephyr_gem_",          1243006, 1243140},
            {"scorch_gem_",          1245006, 1245130},
            {"shady_oasis_gem_",     1246004, 1246122},
            {"magma_cone_gem_",      1247009, 1247127},
            {"fracture_hills_gem_",  1248007, 1248121},
            {"winter_tundra_gem_",   1251005, 1251105},
            {"mystic_marsh_gem_",    1252005, 1252143},
            {"cloud_temples_gem_",   1253004, 1253114},
            {"robotica_farms_gem_",  1255003, 1255129},
            {"metropolis_gem_",      1256004, 1256129}
        }

        for _, gem in ipairs(gem_codes) do
            for i = gem[2], gem[3] do
                --Example  -->  Tracker:FindObjectForCode("summer_forest_gem_1").Active = gem_set_combined[1230009]
                Tracker:FindObjectForCode(gem[1] .. i - gem[2] + 1).Active = gem_set_combined[i]
            end
        end
    end

	PLAYER_ID = Archipelago.PlayerNumber or -1
	TEAM_NUMBER = Archipelago.TeamNumber or 0

    if Archipelago.PlayerNumber > -1 then
        HINTS_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID
        DATA_STORAGE_ID = "Spyro2_"..TEAM_NUMBER.."_"..PLAYER_ID

        if Highlight then
            Archipelago:SetNotify({HINTS_ID, DATA_STORAGE_ID})
            Archipelago:Get({HINTS_ID, DATA_STORAGE_ID})
        else
            Archipelago:SetNotify({DATA_STORAGE_ID})
            Archipelago:Get({DATA_STORAGE_ID})
        end
    end

    Tracker.BulkUpdate = false
end

function OnNotify(key, value, old_value)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onNotify: %s, %s, %s", key, dump(value), old_value))
	end

	if value == old_value then
		return
	end

	if key == HINTS_ID and Highlight then
		for _, hint in ipairs(value) do
			if not hint.found and hint.finding_player == Archipelago.PlayerNumber then
				UpdateHints(hint.location, hint.status)
			else
				ClearHints(hint.location)
			end
		end
	elseif key == DATA_STORAGE_ID and value ~= nil then
		for k, v in pairs(value) do
			if (DataStorageLocationTable[k]) then
				Tracker:FindObjectForCode(DataStorageLocationTable[k]).AvailableChestCount = v and 0 or 1
			elseif (DataStorageItemTable[k]) then
				Tracker:FindObjectForCode(DataStorageItemTable[k]).Active = v or false
			end
		end
		Tracker:FindObjectForCode(HiddenSetting).Active = not Tracker:FindObjectForCode(HiddenSetting).Active
	end
end

-- called when a location is hinted or the status of a hint is changed
function UpdateHints(locationID, status)
	if not Highlight then
		return
	end
	local locations = LOCATION_MAPPING[locationID]
	-- print("Hint", dump(locations), status)
	for _, location in ipairs(locations) do
		local section = Tracker:FindObjectForCode(location)
		---@cast section LocationSection
		if section then
			section.Highlight = PriorityToHighlight[status]
		else
			print(string.format("No object found for code: %s", location))
		end
	end
end

function ClearHints(locationID)
	if not Highlight then
		return
	end
	local locations = LOCATION_MAPPING[locationID]
	if (not locations) then
		return
	end
	for _, location in ipairs(locations) do
		local section = Tracker:FindObjectForCode(location)
		---@cast section LocationSection
		if section then
			section.Highlight = Highlight.None
		else
			print(string.format("No object found for code: %s", location))
		end
	end
end

function OnNotifyLaunch(key, value)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onNotifyLaunch: %s, %s", key, dump(value)))
	end
	OnNotify(key, value)
end

function onItem(index, itemId, itemName, playerNumber)
    if index <= CURRENT_INDEX then
        return
    end

    CURRENT_INDEX = index

    local itemObject = ITEM_MAPPING[itemId]
    
    if not itemObject or not itemObject[1] then
        return
    end

    local trackerItemObject = Tracker:FindObjectForCode(itemObject[1])

    if trackerItemObject then
        if itemObject[2] == "toggle" then
            trackerItemObject.Active = true
        elseif itemObject[2] == "progressive" then
            if trackerItemObject.Active then
                trackerItemObject.CurrentStage = trackerItemObject.CurrentStage + 1
            else
                trackerItemObject.Active = true
            end
        elseif itemObject[2] == "consumable" then
            trackerItemObject.AcquiredCount = trackerItemObject.AcquiredCount + trackerItemObject.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: Unknown item type %s for code %s", itemObject[2], itemObject[1]))
        end
    else
        print(string.format("onItem: Could not find object for code %s", itemObject[1]))
    end
    
    --GEMSANITY
    if sd_options['enable_gemsanity'] ~= 0 then
        Tracker.BulkUpdate = true
        --Check the math for aquired gems
        Tracker:FindObjectForCode("inventory_gems_summ").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_summ").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_summ").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_summ").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_summ").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_summ").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_summ").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_glim").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_glim").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_glim").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_glim").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_glim").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_glim").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_glim").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_idol").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_idol").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_idol").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_idol").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_idol").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_idol").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_idol").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_colo").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_colo").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_colo").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_colo").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_colo").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_colo").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_colo").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_hurr").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_hurr").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_hurr").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_hurr").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_hurr").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_hurr").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_hurr").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_aqua").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_aqua").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_aqua").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_aqua").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_aqua").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_aqua").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_aqua").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_sunn").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_sunn").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_sunn").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_sunn").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_sunn").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_sunn").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_sunn").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_autu").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_autu").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_autu").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_autu").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_autu").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_autu").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_autu").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_skel").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_skel").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_skel").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_skel").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_skel").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_skel").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_skel").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_crys").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_crys").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_crys").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_crys").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_crys").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_crys").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_crys").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_bree").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_bree").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_bree").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_bree").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_bree").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_bree").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_bree").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_zeph").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_zeph").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_zeph").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_zeph").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_zeph").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_zeph").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_zeph").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_scor").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_scor").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_scor").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_scor").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_scor").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_scor").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_scor").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_shad").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_shad").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_shad").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_shad").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_shad").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_shad").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_shad").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_magm").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_magm").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_magm").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_magm").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_magm").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_magm").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_magm").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_frac").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_frac").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_frac").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_frac").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_frac").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_frac").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_frac").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_wint").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_wint").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_wint").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_wint").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_wint").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_wint").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_wint").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_myst").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_myst").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_myst").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_myst").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_myst").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_myst").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_myst").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_clou").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_clou").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_clou").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_clou").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_clou").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_clou").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_clou").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_robo").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_robo").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_robo").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_robo").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_robo").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_robo").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_robo").AcquiredCount * 50)
        Tracker:FindObjectForCode("inventory_gems_metr").AcquiredCount = Tracker:FindObjectForCode("inventory_red_gems_metr").AcquiredCount + (Tracker:FindObjectForCode("inventory_green_gems_metr").AcquiredCount * 2) + (Tracker:FindObjectForCode("inventory_blue_gems_metr").AcquiredCount * 5) + (Tracker:FindObjectForCode("inventory_gold_gems_metr").AcquiredCount * 10) + (Tracker:FindObjectForCode("inventory_pink_gems_metr").AcquiredCount * 25) + (Tracker:FindObjectForCode("inventory_50_gems_metr").AcquiredCount * 50)
        Tracker.BulkUpdate = false
    end
end


function onLocation(locationId, locationName)
    local locationObject = LOCATION_MAPPING[locationId]

    if not locationObject or not locationObject[1] then
        return
    end

    for _,layoutLocationElement in pairs(locationObject) do

        local trackerLocationObject = Tracker:FindObjectForCode(layoutLocationElement)

        if trackerLocationObject then
            if layoutLocationElement:sub(1, 1) == "@" then
                trackerLocationObject.AvailableChestCount = trackerLocationObject.AvailableChestCount - 1
            else
                trackerLocationObject.Active = false
            end
        else
            print(string.format("onLocation: Could not find object for code %s", layoutLocationElement))
        end
    end
end


Archipelago:AddClearHandler("Clear", onClear)
Archipelago:AddItemHandler("Item", onItem)
Archipelago:AddLocationHandler("Location", onLocation)
Archipelago:AddSetReplyHandler("notify handler", OnNotify)
Archipelago:AddRetrievedHandler("notify launch handler", OnNotifyLaunch)

PriorityToHighlight = {}
if Highlight then
	PriorityToHighlight = {
		[0] = Highlight.Unspecified,
		[10] = Highlight.NoPriority,
		[20] = Highlight.Avoid,
		[30] = Highlight.Priority,
		[40] = Highlight.None -- found
	}
end