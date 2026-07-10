local component = require("component")

local self = {}

self.static = {
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
        ["distilled_water"] = "ic2distilliedwater",
        ["radon"] = "radon",
        ["molten_tin"] = "molten.tin"
    },
    threads_per_tier = {1, 4, 16},
    parallels_per_tier = {4, 16, 64},
    comparator = function(a, b)
        return a.amount / a.limit < b.amount / b.limit
    end
}

self.runtime = {}

-- ====================== MANAGE =======================

function self.reset(module)
    module.proxy.setWorkAllowed(false)
end

function self.apply(module, thread, config)
    module.proxy.setParameter("recipe" .. thread .. ".planetType", config.planet)
    module.proxy.setParameter("recipe" .. thread .. ".gasType", config.gas)
end

function self.enable(module)
    module.proxy.setWorkAllowed(true)
end

function self.reset_all()
    for _, module in ipairs(self.runtime.modules) do
        self.reset(module)
    end
end

function self.enable_all()
    for _, module in ipairs(self.runtime.modules) do
        self.enable(module)
    end
end

-- ====================== SETUP =======================

function self.load_modules(config)
    local threads_per_tier = self.static.threads_per_tier

    local modules = {}
    local modules_by_tier = {{}, {}, {}}
    local threads_by_tier = {}
    
    for address in component.list("gt_machine") do
        local proxy = component.proxy(address)
        local name = proxy.getName()

        for tier = 1,3 do
            if name ~= self.static.module_name .. tier then
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

    self.runtime.modules = modules
    self.runtime.modules_by_tier = modules_by_tier
    self.runtime.threads_by_tier = threads_by_tier
end

function self.load_targets(config)
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

    self.runtime.targets = targets

    self.runtime.mandatory_targets = mandatory_targets
    self.runtime.maintained_targets = maintained_targets
    self.runtime.accumulate_targets = accumulate_targets
end

function self.load_cache(config)
    local cache = {}

    for fluid, data in pairs(self.static.fluids) do
        cache[fluid] = {}
        for tier = 1,3 do
            cache[fluid][tier] =
                data.rate *
                self.static.parallels_per_tier[tier] *
                self.runtime.delta
        end
    end

    self.runtime.cache = cache
end

function self.load(config)
    self.runtime.delta = config.delta

    self.runtime.storage_net = component.proxy(config.storage_net_address)

    if not self.runtime.storage_net then
        error("Failed to locate ME Interface from the storage subnet")
        return
    end
    self.load_modules(config)

    self.reset_all()

    self.load_targets(config)

    self.load_cache(config)
end

-- ====================== STORAGE =======================

function self.get_amounts()
    local amounts = {}

    for fluid, target_data in pairs(self.runtime.targets) do
        local data = self.runtime.storage_net.getFluidInNetwork(self.static.canonical_names[fluid])
        
        local amount = 0

        if data then
            amount = data.amount
        end
        
        table.insert(amounts, {
            fluid = fluid,
            amount = amount,
            limit = target_data.limit
        })
        ::continue::
    end
    return amounts
end

-- ====================== PLANNING =======================

function self.fix_sort(list)
    if #list == 0 then
        return list
    end

    local first = list[1]

    if first.amount >= first.limit then
        table.remove(list, 1)
        return list
    end

    local i = 2

    while i <= #list and self.static.comparator(list[i], first) do
        list[i - 1] = list[i]
        i = i + 1
    end

    list[i - 1] = first

    return list
end

function self.find_active_targets(amounts)
    local mandatory = self.runtime.mandatory_targets
    local maintained = self.runtime.maintained_targets
    local accumulate = self.runtime.accumulate_targets

    local active = {}

    for fluid, to_maintain in pairs(mandatory) do
        if (amounts[fluid] or 0) < to_maintain then
            active[fluid] = to_maintain
        end
    end

    if next(active) then
        return active
    end

    for fluid, to_maintain in pairs(maintained) do
        if (amounts[fluid] or 0) < to_maintain then
            active[fluid] = to_maintain
        end
    end

    if next(active) then
        return active
    end

    return accumulate
end

function self.find_optimal_tier(fluid, deficit, unallocated_threads)
    local rates = self.runtime.cache[fluid]

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

function self.plan()
    self.reset_all()

    local amounts = self.get_amounts()

    local fluids = self.static.fluids

    local threads_per_tier = self.static.threads_per_tier
    local modules_by_tier = self.runtime.modules_by_tier
    local threads_by_tier = self.runtime.threads_by_tier

    local cache = self.runtime.cache

    local unallocated_threads_by_tier = {}
    local allocated_threads_by_tier = {0, 0, 0}

    local unallocated_threads_total = 0

    for tier = 1,3 do
        unallocated_threads_by_tier[tier] = threads_by_tier[tier]
        unallocated_threads_total = unallocated_threads_total + threads_by_tier[tier]
    end

    local virtual_amounts = {}

    while unallocated_threads_total > 0 do
        if #virtual_amounts == 0 then
            local active_targets = self.find_active_targets(amounts)

            if next(active_targets) == nil then
                break
            end

            for fluid, limit in pairs(active_targets) do
                local current_amount = amounts[fluid] or 0
                if current_amount < limit then
                    table.insert(virtual_amounts, {
                        fluid = fluid,
                        amount = current_amount,
                        limit = limit
                    })
                end
            end

            if #virtual_amounts == 0 then
                break
            end

            table.sort(virtual_amounts, self.static.comparator)
        end

        local selected = virtual_amounts[1]

        local tier = self.find_optimal_tier(
            selected.fluid,
            selected.limit - selected.amount,
            unallocated_threads_by_tier
        )

        if tier == nil then
            break
        end

        local config = fluids[selected.fluid]

        unallocated_threads_by_tier[tier] = unallocated_threads_by_tier[tier] - 1
        unallocated_threads_total = unallocated_threads_total - 1

        local allocated = allocated_threads_by_tier[tier]
        allocated_threads_by_tier[tier] = allocated + 1

        local threads_per_module = threads_per_tier[tier]
        local module_index = math.floor(allocated / threads_per_module) + 1
        local thread_index = allocated % threads_per_module + 1

        self.apply(
            modules_by_tier[tier][module_index],
            thread_index,
            config
        )

        selected.amount = selected.amount + cache[selected.fluid][tier]

        self.fix_sort(virtual_amounts)
    end

    self.enable_all()
end

return self
