local component = require("component")

local pumping = {}

pumping.static = {
    module_name = "projectmodulepumpt",
    fluids = {
        ["chlorobenzene"] =     {planet = 2, gas = 1, rate = 896000},
        ["ender_goo"] =         {planet = 3, gas = 1, rate = 32000},
        ["very_heavy_oil"] =    {planet = 3, gas = 2, rate = 1400000},
        ["lava"] =              {planet = 3, gas = 3, rate = 1800000},
        ["natural_gas"] =       {planet = 3, gas = 4, rate = 1400000},
        ["sulfuric_acid"] =     {planet = 4, gas = 1, rate = 784000},
        ["molten_iron"] =       {planet = 4, gas = 2, rate = 896000},
        ["oil"] =               {planet = 4, gas = 3, rate = 1400000},
        ["heavy_oil"] =         {planet = 4, gas = 4, rate = 1792000},
        ["molten_lead"] =       {planet = 4, gas = 5, rate = 896000},
        ["raw_oil"] =           {planet = 4, gas = 6, rate = 1400000},
        ["light_oil"] =         {planet = 4, gas = 7, rate = 780000},
        ["carbon_dioxide"] =    {planet = 4, gas = 8, rate = 1680000},
        ["carbon_monoxide"] =   {planet = 5, gas = 1, rate = 4480000},
        ["helium-3"] =          {planet = 5, gas = 2, rate = 2800000},
        ["salt_water"] =        {planet = 5, gas = 3, rate = 2800000},
        ["helium"] =            {planet = 5, gas = 4, rate = 1400000},
        ["liquid_oxygen"] =     {planet = 5, gas = 5, rate = 896000},
        ["neon"] =              {planet = 5, gas = 6, rate = 32000},
        ["argon"] =             {planet = 5, gas = 7, rate = 32000},
        ["krypton"] =           {planet = 5, gas = 8, rate = 8000},
        ["methane"] =           {planet = 5, gas = 9, rate = 1792000},
        ["hydrogen_sulfide"] =  {planet = 5, gas = 10, rate = 392000},
        ["ethane"] =            {planet = 5, gas = 11, rate = 1194000},
        ["deuterium"] =         {planet = 6, gas = 1, rate = 1568000},
        ["tritium"] =           {planet = 6, gas = 2, rate = 240000},
        ["ammonia"] =           {planet = 6, gas = 3, rate = 240000},
        ["xenon"] =             {planet = 6, gas = 4, rate = 16000},
        ["ethylene"] =          {planet = 6, gas = 5, rate = 1792000},
        ["hydrofluoric_acid"] = {planet = 7, gas = 1, rate = 672000},
        ["fluorine"] =          {planet = 7, gas = 2, rate = 1792000},
        ["nitrogen"] =          {planet = 7, gas = 3, rate = 1792000},
        ["oxygen"] =            {planet = 7, gas = 4, rate = 1729000},
        ["hydrogen"] =          {planet = 8, gas = 1, rate = 1568000},
        ["liquid_air"] =        {planet = 8, gas = 2, rate = 875000},
        ["molten_copper"] =     {planet = 8, gas = 3, rate = 672000},
        ["unknown_liquid"] =    {planet = 8, gas = 4, rate = 672000},
        ["distilled_water"] =   {planet = 8, gas = 5, rate = 17920000},
        ["radon"] =             {planet = 8, gas = 6, rate = 64000},
        ["molten_tin"] =        {planet = 8, gas = 7, rate = 672000}
    },
    canonical_names = {
        ["chlorobenzene"] = "chlorobenzene",
        ["ender_goo"] = "endergoo",
        ["very_heavy_oil"] = "liquid_extra_heavy_oil",
        ["lava"] = "lava",
        ["natural_gas"] = "gas_natural_gas",
        ["sulfuric_acid"] = "sulfuricacid",
        ["molten_iron"] = "molten.iron",
        ["oil"] = "oil",
        ["heavy_oil"] = "liquid_heavy_oil",
        ["molten_lead"] = "molten.lead",
        ["raw_oil"] = "liquid_raw_oil",
        ["light_oil"] = "liquid_light_oil",
        ["carbon_dioxide"] = "carbondioxide",
        ["carbon_monoxide"] = "carbonmonoxide",
        ["helium-3"] = "helium-3",
        ["salt_water"] = "saltwater",
        ["helium"] = "helium",
        ["liquid_oxygen"] = "liquidoxygen",
        ["neon"] = "neon",
        ["argon"] = "argon",
        ["krypton"] = "krypton",
        ["methane"] = "methane",
        ["hydrogen_sulfide"] = "liquid_hydricsulfur",
        ["ethane"] = "ethane",
        ["deuterium"] = "deuterium",
        ["tritium"] = "tritium",
        ["ammonia"] = "ammonia",
        ["xenon"] = "xenon",
        ["ethylene"] = "ethylene",
        ["hydrofluoric_acid"] = "hydrofluoricacid_gt5u",
        ["fluorine"] = "fluorine",
        ["nitrogen"] = "nitrogen",
        ["oxygen"] = "oxygen",
        ["hydrogen"] = "hydrogen",
        ["liquid_air"] = "liquidair",
        ["molten_copper"] = "molten.copper",
        ["unknown_liquid"] = "unknowwater",
        ["distilled_water"] = "ic2distilledwater",
        ["radon"] = "radon",
        ["molten_tin"] = "molten.tin"
    },
    threads_per_tier = {1, 4, 16},
    parallels_per_tier = {4, 16, 64}
}

pumping.runtime = {}

-- ====================== MANAGE =======================

function pumping.reset(module)
    module.proxy.setWorkAllowed(false)
    module.proxy.setParameter("batch", math.ceil(pumping.runtime.delta / 10))

    for i = 1,pumping.static.threads_per_tier[module.tier] do
        module.proxy.setParameter("recipe" .. (i - 1) .. ".planetType", 0)
        module.proxy.setParameter("recipe" .. (i - 1) .. ".gasType", 0)
    end
end

function pumping.apply(module, thread, config)
    module.proxy.setParameter("recipe" .. (thread - 1) .. ".planetType", config.planet)
    module.proxy.setParameter("recipe" .. (thread - 1) .. ".gasType", config.gas)
end

function pumping.enable(module)
    module.proxy.setWorkAllowed(true)
end

function pumping.reset_all()
    for _, module in ipairs(pumping.runtime.modules) do
        pumping.reset(module)
    end
end

function pumping.enable_all()
    for _, module in ipairs(pumping.runtime.modules) do
        pumping.enable(module)
    end
end

-- ====================== SETUP =======================

function pumping.load_modules(config)
    local threads_per_tier = pumping.static.threads_per_tier

    local modules = {}
    local modules_by_tier = {{}, {}, {}}
    local threads_by_tier = {}
    
    for address in component.list("gt_machine") do
        local proxy = component.proxy(address)
        local name = proxy.getName()

        for tier = 1,3 do
            if name ~= pumping.static.module_name .. tier then
                goto continue
            end

            local module = {
                proxy = proxy,
                tier = tier
            }
                
            table.insert(modules, module)
            table.insert(modules_by_tier[tier], module)
            ::continue::
        end
    end

    for tier, modules in ipairs(modules_by_tier) do
        threads_by_tier[tier] = #modules * threads_per_tier[tier]
    end

    pumping.runtime.modules = modules
    pumping.runtime.modules_by_tier = modules_by_tier
    pumping.runtime.threads_by_tier = threads_by_tier
end

function pumping.load_targets(config)
    local targets = config.pumping.targets

    local mandatory_targets = {}
    local maintained_targets = {}
    local accumulate_targets = {}

    for fluid, data in pairs(targets) do
        if data.to_maintain then
            if data.mandatory then
                mandatory_targets[fluid] = data.to_maintain
            else
                maintained_targets[fluid] = data.to_maintain
            end
        end
        if data.relative then
            accumulate_targets[fluid] = data.relative
        end
    end

    pumping.runtime.targets = targets

    pumping.runtime.mandatory_targets = mandatory_targets
    pumping.runtime.maintained_targets = maintained_targets
    pumping.runtime.accumulate_targets = accumulate_targets
end

function pumping.load_cache(config)
    local cache = {}

    for fluid, data in pairs(pumping.static.fluids) do
        cache[fluid] = {}
        for tier = 1,3 do
            cache[fluid][tier] =
                data.rate *
                pumping.static.parallels_per_tier[tier] *
                pumping.runtime.delta
        end
    end

    pumping.runtime.cache = cache
end

function pumping.load(config)
    pumping.runtime.delta = config.delta

    pumping.runtime.storage_net = component.proxy(config.storage_net_address)

    if not pumping.runtime.storage_net then
        error("Failed to locate ME Interface from the storage subnet")
        return
    end
    pumping.load_modules(config)

    pumping.reset_all()

    pumping.load_targets(config)

    pumping.load_cache(config)
end

-- ====================== STORAGE =======================

function pumping.get_amounts()
    local amounts = {}

    for fluid in pairs(pumping.runtime.targets) do
        local data = pumping.runtime.storage_net.getFluidInNetwork(
            pumping.static.canonical_names[fluid]
        )

        amounts[fluid] = data and data.amount or 0
    end

    return amounts
end

-- ====================== PLANNING =======================

function pumping.get_fill_ratio(fluid, amounts, is_accumulate)
    local target = pumping.runtime.targets[fluid]

    if is_accumulate and target.relative then
        return amounts[fluid] / target.relative
    end

    return amounts[fluid] / target.to_maintain
end

function pumping.fix_sort(list, amounts, is_accumulate)
    if #list == 0 then
        return list
    end

    local first = list[1]
    local target = pumping.runtime.targets[first]

    if not is_accumulate and amounts[first] >= target.to_maintain then
        table.remove(list, 1)
        return list
    end

    local i = 2

    while i <= #list and
        pumping.get_fill_ratio(list[i], amounts, is_accumulate) <
        pumping.get_fill_ratio(first, amounts, is_accumulate) do

        list[i - 1] = list[i]
        i = i + 1
    end

    list[i - 1] = first

    return list
end

function pumping.find_active_targets(amounts)
    local mandatory = pumping.runtime.mandatory_targets
    local maintained = pumping.runtime.maintained_targets
    local accumulate = pumping.runtime.accumulate_targets

    local active = {}

    for fluid, to_maintain in pairs(mandatory) do
        if amounts[fluid] < to_maintain then
            table.insert(active, fluid)
        end
    end

    if #active > 0 then
        return active, false
    end

    for fluid, to_maintain in pairs(maintained) do
        if amounts[fluid] < to_maintain then
            table.insert(active, fluid)
        end
    end

    if #active > 0 then
        return active, false
    end

    for fluid, _ in pairs(accumulate) do
        table.insert(active, fluid)
    end

    return active, true
end

function pumping.find_optimal_tier(fluid, deficit, unallocated_threads)
    local rates = pumping.runtime.cache[fluid]

    local tier = 3

    while tier > 1 do
        if unallocated_threads[tier] > 0 and rates[tier] <= deficit then
            return tier
        end

        tier = tier - 1
    end

    if unallocated_threads[1] > 0 and rates[1] <= deficit then
        return 1
    end

    local best_tier = nil
    local best_overflow = math.huge

    for tier = 1,3 do
        if unallocated_threads[tier] > 0 then
            local overflow = rates[tier] - deficit

            if overflow < best_overflow then
                best_overflow = overflow
                best_tier = tier
            end
        end
    end

    return best_tier
end

function pumping.plan()
    pumping.reset_all()

    local amounts = pumping.get_amounts()

    local fluids = pumping.static.fluids
    local targets = pumping.runtime.targets
    
    local threads_per_tier = pumping.static.threads_per_tier
    local modules_by_tier = pumping.runtime.modules_by_tier
    local threads_by_tier = pumping.runtime.threads_by_tier

    local cache = pumping.runtime.cache

    local unallocated_threads_by_tier = {}
    local allocated_threads_by_tier = {0, 0, 0}

    local unallocated_threads_total = 0

    for tier = 1,3 do
        unallocated_threads_by_tier[tier] = threads_by_tier[tier]
        unallocated_threads_total = unallocated_threads_total + threads_by_tier[tier]
    end

    local virtual_amounts = {}
    local is_accumulate = false
    local virtual_storage = amounts

    while unallocated_threads_total > 0 do
        if #virtual_amounts == 0 then
            virtual_amounts, is_accumulate = pumping.find_active_targets(virtual_storage)

            if #virtual_amounts == 0 then
                break
            end

            table.sort(virtual_amounts, function(a, b)
                return pumping.get_fill_ratio(a, virtual_storage, is_accumulate)
                 < pumping.get_fill_ratio(b, virtual_storage, is_accumulate)
            end)
        end

        local fluid = virtual_amounts[1]
        local target = targets[fluid]

        local deficit

        if is_accumulate then
            if #virtual_amounts == 1 then
                deficit = math.huge
            else
                local next_fluid = virtual_amounts[2]

                deficit =
                (
                    pumping.get_fill_ratio(next_fluid, virtual_storage, true)
                    - pumping.get_fill_ratio(fluid, virtual_storage, true)
                ) * target.relative
            end
        else
            deficit = target.to_maintain - virtual_storage[fluid]
        end

        local tier = pumping.find_optimal_tier(
            fluid,
            deficit,
            unallocated_threads_by_tier
        )

        if tier == nil then
            break
        end

        local config = fluids[fluid]

        unallocated_threads_by_tier[tier] =
            unallocated_threads_by_tier[tier] - 1
        unallocated_threads_total =
            unallocated_threads_total - 1

        local allocated = allocated_threads_by_tier[tier]
        allocated_threads_by_tier[tier] = allocated + 1

        local threads_per_module = threads_per_tier[tier]
        local module_index = math.floor(allocated / threads_per_module) + 1
        local thread_index = allocated % threads_per_module + 1

        pumping.apply(
            modules_by_tier[tier][module_index],
            thread_index,
            config
        )

        if thread_index == threads_per_module then
            pumping.enable(modules_by_tier[tier][module_index])
        end

        virtual_storage[fluid] =
            virtual_storage[fluid] + cache[fluid][tier]

        pumping.fix_sort(virtual_amounts, virtual_storage, is_accumulate)
    end

    for tier = 1,3 do
        local threads_per_module = threads_per_tier[tier]
        local allocated = allocated_threads_by_tier[tier]

        if allocated % threads_per_module ~= 0 then
            local module_index = math.floor(allocated / threads_per_module) + 1
            pumping.enable(modules_by_tier[tier][module_index])
        end
    end
end

return pumping
