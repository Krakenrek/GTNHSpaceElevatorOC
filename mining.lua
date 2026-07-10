local os = require("os")
local component = require("component")
local sides = require("sides")

local vector = require("vector")

local mining = {}

mining.static = {
    module_name = "projectmoduleminert",
    drone_name = "gtnhintergalactic:item.MiningDrone",
    voltage_names = {"LV", "MV", "HV", "EV", "IV", "LuV", "ZPM", "UV", "UHV", "UEV", "UIV", "UMV", "UXV"},
    ticks_per_second = 20,
    time_discount = {0.0, 0.1, 0.2, 0.3, 0.4},
    size_bonus = {0.004, 0.037, 0.125, 0.296, 0.578},
    meteors = {
        {name="Adamantium", min_module_tier=1, min_distance=5, max_distance=120, weight=300, min_drone_tier=4, max_drone_tier=7, min_size=30, max_size=120, duration=500, yield={["adamantium"]=80.64, ["antimony"]=51.2, ["bismuth"]=64.51, ["gallium"]=64.51, ["lithium"]=48.38, ["zinc"]=13.31}},
        {name="Aluminium", min_module_tier=1, min_distance=5, max_distance=20, weight=120, min_drone_tier=2, max_drone_tier=4, min_size=10, max_size=20, duration=50, yield={}},
        {name="Aluminium-Lanth Line", min_module_tier=1, min_distance=40, max_distance=120, weight=250, min_drone_tier=2, max_drone_tier=7, min_size=10, max_size=80, duration=500, yield={["arsenic"]=0.12, ["beryllium"]=0.23, ["bismuth"]=1.18, ["cerium"]=128.42, ["dysprosium"]=0.07, ["erbium"]=0.15, ["europium"]=191.6, ["gadolinium"]=437.52, ["germanium"]=0.15, ["hafnia"]=136.53, ["holmium"]=9.29, ["iodine"]=0.51, ["lanthanum"]=15.08, ["neodymium"]=27.14, ["niobium"]=0.21, ["phosphate"]=1667.19, ["phosphorous"]=0.27, ["samarium"]=874.7, ["silicon"]=0.3, ["sodium"]=0.28, ["strontium"]=0.28, ["sulfur"]=1.61, ["tantalum"]=0.31, ["tellurium"]=0.3, ["terbium"]=3.72, ["thorium"]=1693.46, ["uranium_235"]=958.28, ["uranium_238"]=2011.81, ["ytterbium"]=0.11, ["yttrium"]=0.36, ["zirconia"]=136.53, ["zirconium"]=15.58}},
        {name="Ardite/Cobalt", min_module_tier=1, min_distance=30, max_distance=100, weight=150, min_drone_tier=4, max_drone_tier=9, min_size=20, max_size=90, duration=1000, yield={["ardite"]=60.48, ["arsenic"]=4.16, ["cobalt"]=52.16, ["manyullyn"]=40.32, ["sulfur"]=4.16}},
        {name="Basic Magic", min_module_tier=1, min_distance=8, max_distance=24, weight=200, min_drone_tier=3, max_drone_tier=6, min_size=24, max_size=60, duration=100, yield={["infused_air"]=3.2, ["infused_earth"]=3.2, ["infused_entropy"]=3.2, ["infused_fire"]=3.2, ["infused_gold"]=22.4, ["infused_order"]=3.2, ["infused_water"]=3.2, ["shadow"]=22.4}},
        {name="Blue", min_module_tier=1, min_distance=20, max_distance=200, weight=250, min_drone_tier=3, max_drone_tier=8, min_size=10, max_size=50, duration=500, yield={["antimony"]=0.03, ["lapis"]=1016.83, ["nickel"]=0.03, ["quicklime"]=6.66, ["silicon"]=139.09, ["sodium"]=185.45, ["tin"]=0.03, ["vanadium"]=0.27}},
        {name="Cheese", min_module_tier=2, min_distance=90, max_distance=200, weight=10, min_drone_tier=5, max_drone_tier=13, min_size=1, max_size=30, duration=1000, yield={}},
        {name="Chrome", min_module_tier=1, min_distance=10, max_distance=20, weight=100, min_drone_tier=2, max_drone_tier=6, min_size=16, max_size=32, duration=50, yield={["chrome"]=163.36, ["magnesium"]=37.63, ["ruby"]=76.8}},
        {name="Clay", min_module_tier=1, min_distance=20, max_distance=100, weight=200, min_drone_tier=1, max_drone_tier=6, min_size=30, max_size=60, duration=800, yield={["lithium"]=16.0, ["sodium"]=32.0}},
        {name="Coal", min_module_tier=1, min_distance=1, max_distance=40, weight=200, min_drone_tier=1, max_drone_tier=7, min_size=30, max_size=120, duration=200, yield={["coal"]=1433.6, ["graphite"]=51.2, ["lignite"]=6.4}},
        {name="Copper", min_module_tier=1, min_distance=3, max_distance=12, weight=500, min_drone_tier=1, max_drone_tier=6, min_size=30, max_size=150, duration=200, yield={["cadmium"]=7.68, ["cobalt"]=40.96, ["sulfur"]=46.59}},
        {name="Cosmic", min_module_tier=2, min_distance=60, max_distance=100, weight=170, min_drone_tier=7, max_drone_tier=13, min_size=10, max_size=70, duration=500, yield={["bedrockium"]=87.68, ["black_plutonium"]=87.68, ["cosmic_neutronium"]=87.68, ["neutronium"]=87.68}},
        {name="Draconic", min_module_tier=2, min_distance=60, max_distance=200, weight=190, min_drone_tier=6, max_drone_tier=9, min_size=15, max_size=60, duration=600, yield={["draconium"]=209.66, ["draconium_awakened"]=80.64, ["electrum_flux"]=6.4}},
        {name="Draconic Core", min_module_tier=3, min_distance=50, max_distance=200, weight=1, min_drone_tier=9, max_drone_tier=11, min_size=1, max_size=1, duration=2000, yield={}},
        {name="Europium", min_module_tier=2, min_distance=40, max_distance=60, weight=150, min_drone_tier=7, max_drone_tier=13, min_size=40, max_size=120, duration=1000, yield={["borax"]=52.61, ["callisto_ice"]=135.17, ["europium"]=17.54, ["ledox"]=129.02}},
        {name="Everglades", min_module_tier=1, min_distance=110, max_distance=230, weight=100, min_drone_tier=7, max_drone_tier=9, min_size=10, max_size=20, duration=500, yield={["arsenic"]=0.38, ["beryllium"]=2.06, ["bismuth"]=0.74, ["cadmium"]=0.74, ["caesium"]=1.64, ["cerium"]=22.29, ["chrome"]=2.37, ["cobalt"]=0.08, ["dysprosium"]=0.65, ["erbium"]=1.37, ["gadolinium"]=2.03, ["germanium"]=1.45, ["iodine"]=2.02, ["lanthanum"]=1.41, ["manganese"]=0.36, ["neodymium"]=3.07, ["nether_quartz"]=2.7, ["nickel"]=15.98, ["niobium"]=0.13, ["phosphate"]=0.0, ["phosphorous"]=0.17, ["potassium"]=0.15, ["samarium"]=0.07, ["silicon"]=5.34, ["sodium"]=0.7, ["strontium"]=0.17, ["sulfur"]=5.19, ["tantalum"]=0.19, ["tellurium"]=5.48, ["thallium"]=5.67, ["thaumium"]=11.52, ["thorium"]=0.42, ["tin"]=0.13, ["uranium_235"]=0.78, ["ytterbium"]=3.14, ["yttrium"]=4.68, ["zirconium"]=6.47}},
        {name="Gem Ores", min_module_tier=1, min_distance=17, max_distance=40, weight=180, min_drone_tier=1, max_drone_tier=6, min_size=30, max_size=160, duration=100, yield={["beryllium"]=6.14, ["chrome"]=10.37, ["diamond"]=24.77, ["emerald"]=49.54, ["graphite"]=3.07, ["green_sapphire"]=38.4, ["nether_star"]=3.74, ["ruby"]=38.4, ["sapphire"]=57.98, ["thaumium"]=12.9}},
        {name="Holmium/Samarium", min_module_tier=2, min_distance=40, max_distance=80, weight=75, min_drone_tier=8, max_drone_tier=13, min_size=15, max_size=50, duration=500, yield={["cerium"]=4.56, ["holmium"]=35.07, ["lanthanum"]=1.97, ["neodymium"]=3.16, ["phosphate"]=6.58, ["samarium"]=107.58, ["strontium"]=35.07, ["thorium"]=7.98, ["tiberium"]=52.61}},
        {name="Ichorium", min_module_tier=3, min_distance=70, max_distance=100, weight=150, min_drone_tier=10, max_drone_tier=13, min_size=30, max_size=120, duration=1000, yield={["americium"]=17.54, ["desh"]=16.13, ["ichorium"]=48.38, ["iridium"]=15.36, ["meteoric_iron"]=76.8, ["nickel"]=16.13, ["thaumium"]=86.4}},
        {name="Indium", min_module_tier=2, min_distance=50, max_distance=90, weight=170, min_drone_tier=5, max_drone_tier=10, min_size=30, max_size=120, duration=500, yield={["antimony"]=0.02, ["cadmium"]=35.07, ["chrome"]=0.15, ["germanium"]=12.8, ["indium"]=210.43, ["manganese"]=0.03, ["nickel"]=0.02, ["quicklime"]=4.1, ["silver"]=0.05, ["tin"]=4.11, ["vanadium"]=0.13}},
        {name="Infinity Catalyst", min_module_tier=2, min_distance=70, max_distance=100, weight=150, min_drone_tier=8, max_drone_tier=13, min_size=30, max_size=120, duration=1000, yield={["cosmic_neutronium"]=105.22, ["infinity_catalyst"]=175.36, ["neutronium"]=70.14}},
        {name="Iron", min_module_tier=1, min_distance=1, max_distance=180, weight=600, min_drone_tier=1, max_drone_tier=7, min_size=30, max_size=150, duration=200, yield={["basalt"]=10.81, ["magnesium"]=0.29, ["nickel"]=30.15, ["potassium"]=0.1, ["silicon"]=0.29, ["sulfur"]=4.55, ["tin"]=18.2}},
        {name="Lanthanum", min_module_tier=2, min_distance=30, max_distance=230, weight=150, min_drone_tier=5, max_drone_tier=11, min_size=30, max_size=120, duration=500, yield={["lanthanum"]=35.07, ["orundum"]=52.61, ["silver"]=44.8, ["sulfur"]=9.41, ["trinium"]=24.19}},
        {name="Lead", min_module_tier=1, min_distance=5, max_distance=150, weight=220, min_drone_tier=1, max_drone_tier=8, min_size=30, max_size=100, duration=500, yield={["arsenic"]=80.64, ["barium"]=87.68, ["caesium"]=10.75, ["lithium"]=15.87, ["potassium"]=2.56, ["silver"]=3.84, ["tellurium"]=16.9}},
        {name="Lutetium", min_module_tier=1, min_distance=40, max_distance=240, weight=100, min_drone_tier=5, max_drone_tier=9, min_size=20, max_size=80, duration=500, yield={["arsenic"]=1.56, ["beryllium"]=2.96, ["bismuth"]=15.38, ["cerium"]=176.15, ["cinnabar"]=84.48, ["dysprosium"]=0.94, ["erbium"]=1.97, ["gadolinium"]=2.91, ["germanium"]=1.97, ["iodine"]=6.57, ["lanthanum"]=2.78, ["lutetium"]=16.13, ["neodymium"]=2.01, ["niobium"]=2.69, ["phosphate"]=0.09, ["phosphorous"]=3.57, ["redstone"]=704.0, ["samarium"]=1.44, ["silicon"]=3.94, ["sodium"]=3.61, ["strontium"]=3.61, ["sulfur"]=20.89, ["tantalum"]=52.42, ["tellurium"]=56.55, ["thorium"]=4.14, ["thulium"]=35.07, ["uranium_235"]=3.63, ["ytterbium"]=1.41, ["yttrium"]=4.66}},
        {name="Nether Ore", min_module_tier=1, min_distance=10, max_distance=100, weight=150, min_drone_tier=4, max_drone_tier=7, min_size=30, max_size=100, duration=1000, yield={["barium"]=0.67, ["certus_quartz"]=36.35, ["firestone"]=8.77, ["nether_quartz"]=99.84, ["quartzite"]=23.3, ["sulfur"]=49.06}},
        {name="Magnesium", min_module_tier=1, min_distance=10, max_distance=200, weight=250, min_drone_tier=4, max_drone_tier=9, min_size=10, max_size=80, duration=400, yield={["chrome"]=9.98, ["magnesium"]=58.78, ["manganese"]=38.4}},
        {name="Mysterious Crystal", min_module_tier=1, min_distance=65, max_distance=120, weight=220, min_drone_tier=5, max_drone_tier=13, min_size=30, max_size=60, duration=500, yield={["cerium"]=1.15, ["lanthanum"]=0.5, ["mysterious_crystal"]=238.69, ["mytryl"]=51.2, ["neodymium"]=0.8, ["oriharukon"]=16.13, ["phosphate"]=1.66, ["samarium"]=27.22, ["thorium"]=2.02}},
        {name="Naquadah", min_module_tier=1, min_distance=50, max_distance=150, weight=200, min_drone_tier=5, max_drone_tier=8, min_size=20, max_size=80, duration=1000, yield={["naquadah_oxide_mixture"]=70.14, ["naquadria_oxide_mixture"]=43.84, ["oxide_mixture"]=61.38}},
        {name="Nickel", min_module_tier=1, min_distance=5, max_distance=20, weight=170, min_drone_tier=1, max_drone_tier=5, min_size=20, max_size=40, duration=50, yield={["cobalt"]=24.06, ["iridium"]=31.15, ["nickel"]=293.8, ["osmium"]=3.11, ["palladium"]=64.37, ["platinum"]=100.12, ["potassium"]=46.21, ["rhodium"]=20.55, ["ruthenium"]=74.75, ["sulfur"]=80.63}},
        {name="Niobium", min_module_tier=1, min_distance=30, max_distance=160, weight=160, min_drone_tier=5, max_drone_tier=9, min_size=30, max_size=120, duration=500, yield={["niobium"]=105.22, ["quantium"]=64.51, ["ytterbium"]=48.38, ["yttrium"]=122.75}},
        {name="Phosphate", min_module_tier=1, min_distance=60, max_distance=250, weight=150, min_drone_tier=5, max_drone_tier=11, min_size=20, max_size=150, duration=500, yield={["phosphate"]=223.15, ["phosphorous"]=29.95, ["sulfur"]=96.77}},
        {name="PlatLine Dust", min_module_tier=3, min_distance=25, max_distance=200, weight=60, min_drone_tier=7, max_drone_tier=10, min_size=10, max_size=30, duration=500, yield={["iridium"]=9.6, ["osmium"]=3.2, ["palladium"]=12.8, ["platinum"]=24.32, ["rhodium"]=6.4, ["ruthenium"]=7.68}},
        {name="PlatLine Ore", min_module_tier=1, min_distance=10, max_distance=50, weight=130, min_drone_tier=3, max_drone_tier=7, min_size=20, max_size=40, duration=50, yield={["iridium"]=395.16, ["nickel"]=222.16, ["osmium"]=24.44, ["palladium"]=512.0, ["platinum"]=718.51, ["potassium"]=331.62, ["rhodium"]=147.44, ["ruthenium"]=536.43, ["sulfur"]=258.66}},
        {name="Quartz", min_module_tier=1, min_distance=20, max_distance=120, weight=230, min_drone_tier=2, max_drone_tier=7, min_size=20, max_size=80, duration=500, yield={["barium"]=2.69, ["certus_quartz"]=87.17, ["nether_quartz"]=149.76, ["quartzite"]=86.02, ["sulfur"]=2.69, ["vanadium"]=80.64}},
        {name="Salt", min_module_tier=1, min_distance=1, max_distance=250, weight=300, min_drone_tier=1, max_drone_tier=5, min_size=30, max_size=120, duration=200, yield={["borax"]=64.51, ["rock_salt"]=130.05, ["salt"]=218.62, ["saltpeter"]=500.74}},
        {name="Silicon", min_module_tier=2, min_distance=50, max_distance=250, weight=200, min_drone_tier=3, max_drone_tier=6, min_size=20, max_size=80, duration=500, yield={["mica"]=77.94, ["silicon"]=161.28, ["silicon_solar_grade"]=97.42}},
        {name="Tengam", min_module_tier=3, min_distance=20, max_distance=100, weight=50, min_drone_tier=10, max_drone_tier=13, min_size=5, max_size=100, duration=500, yield={["dilithium"]=1.75, ["neodymium"]=11.52, ["orundum"]=28.93, ["samarium"]=3.2, ["tengam"]=32.0, ["vanadium"]=56.45, ["ytterbium"]=36.29}},
        {name="Thaumium Dusts", min_module_tier=1, min_distance=10, max_distance=70, weight=150, min_drone_tier=3, max_drone_tier=6, min_size=20, max_size=50, duration=600, yield={["thaumium"]=38.4, ["void"]=25.6}},
        {name="Tin", min_module_tier=1, min_distance=2, max_distance=100, weight=400, min_drone_tier=1, max_drone_tier=5, min_size=50, max_size=200, duration=50, yield={["asbestos"]=14.85, ["magnesium"]=1.28, ["tin"]=309.12, ["zinc"]=8.45, ["zirconium"]=31.36}},
        {name="Tungsten-Titanium", min_module_tier=1, min_distance=60, max_distance=200, weight=100, min_drone_tier=1, max_drone_tier=6, min_size=30, max_size=70, duration=500, yield={["antimony"]=0.04, ["arsenic"]=0.16, ["beryllium"]=0.3, ["bismuth"]=1.54, ["cerium"]=17.69, ["chrome"]=0.4, ["dysprosium"]=0.09, ["erbium"]=0.2, ["gadolinium"]=0.29, ["germanium"]=0.2, ["iodine"]=0.66, ["lanthanum"]=0.28, ["manganese"]=18.3, ["molybdenum"]=22.27, ["neodymium"]=51.4, ["nickel"]=0.04, ["niobium"]=0.27, ["phosphate"]=4.1, ["phosphorous"]=0.36, ["rhenium"]=9.6, ["samarium"]=0.14, ["silicon"]=0.4, ["sodium"]=0.36, ["strontium"]=0.36, ["sulfur"]=2.1, ["tantalum"]=0.4, ["tellurium"]=0.4, ["thorium"]=0.42, ["tin"]=0.04, ["titanium"]=76.8, ["tungsten"]=76.8, ["uranium_235"]=0.36, ["vanadium"]=0.4, ["ytterbium"]=0.14, ["yttrium"]=0.47}},
        {name="Uranium-Plutonium", min_module_tier=1, min_distance=30, max_distance=70, weight=150, min_drone_tier=3, max_drone_tier=7, min_size=40, max_size=180, duration=400, yield={["plutonium_239"]=31.36, ["plutonium_241"]=32.26, ["thorium"]=0.9, ["uranium_235"]=51.03, ["uranium_238"]=46.55}},
    }
}

mining.runtime = {}

-- ====================== MANAGEMENT =======================

function mining.reset(module)
    module.proxy.setWorkAllowed(false)

    module.me_interface.setInterfaceConfiguration()

    module.transposer.transferItem(sides.top, sides.bottom, 1, 1, 1)
end

function mining.apply(module, config)
    module.me_interface.setInterfaceConfiguration({
        name = mining.static.drone_name,
        damage = config.drone_tier - 1
    })

    while not module.transposer.transferItem(sides.bottom, sides.top, 1, 1, 1) do
        os.sleep(0.05)
    end

    module.me_interface.setInterfaceConfiguration()

    module.proxy.setParameter("distance", config.distance)

    module.proxy.setWorkAllowed(true)
end

function mining.reset_all()
    for _, module in ipairs(mining.runtime.modules) do
        mining.reset(module)
    end
end

-- ====================== CACHING =======================

function mining.create_range_pools()
    local range_pools = {}

    local critical_distances = {}

    for _, meteor in ipairs(mining.static.meteors) do
        critical_distances[meteor.min_distance] = true;
        critical_distances[meteor.max_distance + 1] = true;
    end

    for distance,  _ in pairs(critical_distances) do
        range_pools[distance] = {}
        for _, meteor in ipairs(mining.static.meteors) do
            if meteor.min_distance > distance or meteor.max_distance < distance then
                goto continue
            end
            table.insert(range_pools[distance], meteor)
            ::continue::
        end
    end

    return range_pools
end

function mining.calculate_effective_size(min_drone_tier, min_size, max_size, drone_tier)
    local lambda = mining.static.size_bonus[mining.runtime.plasma_tier]
    return min_size + lambda * (max_size - min_size) + 2 ^ (drone_tier - min_drone_tier) - 1
end

function mining.calculate_effective_duration(min_drone_tier, base_duration, drone_tier)
    local lambda = 1 - mining.static.time_discount[mining.runtime.plasma_tier]
    return base_duration * lambda / math.sqrt(drone_tier - min_drone_tier + 1)
end

function mining.calculate_yield(pool, module_tier, drone_tier)
    local yield = {}
    local time = 0.0

    for _, meteor in ipairs(pool) do
        if meteor.min_module_tier > module_tier then
            goto continue
        end
        if meteor.min_drone_tier > drone_tier or meteor.max_drone_tier < drone_tier then
            goto continue
        end

        local size = mining.calculate_effective_size(
            meteor.min_drone_tier,
            meteor.min_size,
            meteor.max_size,
            drone_tier
        )

        local duration = mining.calculate_effective_duration(
            meteor.min_drone_tier,
            meteor.duration,
            drone_tier
        )

        vector.linear_combine(yield, meteor.yield, 2 * module_tier * size * meteor.weight)
        time = time + duration * meteor.weight

        ::continue::
    end

    if time == 0.0 then
        return nil
    end

    return vector.divide(yield, time)
end

function mining.load_cache()
    local cache = {}

    local range_pools = mining.create_range_pools()

    for module_tier = 1,3 do
        cache[module_tier] = {}
        for drone_tier = 1,13 do
            cache[module_tier][drone_tier] = {}
            for distance, pool in pairs(range_pools) do
                local yield = mining.calculate_yield(pool, module_tier, drone_tier)
                if yield == nil then
                    goto continue
                end
                cache[module_tier][drone_tier][distance] = vector.multiply(
                    yield,
                    mining.runtime.delta * mining.static.ticks_per_second
                )
                ::continue::
            end
        end
    end

    mining.runtime.cache = cache
end


-- ====================== SETUP =======================

function mining.load_modules(config)
    local modules = {}
    local modules_by_tier = {{}, {}, {}}

    for idx, module_config in ipairs(config.mining.modules) do
        local proxy = component.proxy(module_config.module_address)

        if not proxy then
            error("Failed to locate Mining Module from configuration at index " .. idx)
            goto continue
        end

        local tier = -1

        local name = proxy.getName()
        for i = 1,3 do
            if name ~= mining.static.module_name .. i then
                goto continue
            end
            tier = i
            break
            ::continue::
        end

        if tier < 0 then
            error("Failed to identify Mining Module from configuration at index" .. idx)
            goto continue
        end

        local me_interface_proxy = component.proxy(module_config.me_interface_address)

        if not me_interface_proxy then
            error("Failed to locate ME Interface from configuration at index " .. idx)
            goto continue
        end

        local transposer_proxy = component.proxy(module_config.transposer_address)

        if not transposer_proxy then
            error("Failed to locate Transposer from configuration at index " .. idx)
            goto continue
        end

        local module = {
            proxy = proxy,
            tier = tier,
            me_interface = me_interface_proxy,
            transposer = transposer_proxy
        }

        table.insert(modules, module)
        table.insert(modules_by_tier[tier], module)
        ::continue::
    end

    mining.runtime.modules = modules
    mining.runtime.modules_by_tier = modules_by_tier
end

function mining.load_drones(config)
    local drone_net = component.proxy(config.mining.drone_net_address)
    local drones = {}

    if not drone_net then
        error("Failed to locate ME Interface from the drone subnet")
        return
    end

    for _, itemstack in ipairs(drone_net.getItemsInNetwork()) do
        if itemstack.name ~= mining.static.drone_name then
            goto continue
        end
        drones[itemstack.damage + 1] = itemstack.size;
        ::continue::
    end

    for tier = 1,13 do
        if drones[tier] then
            goto continue
        end
        drones[tier] = 0
        ::continue::
    end

    mining.runtime.drone_net = drone_net
    mining.runtime.drones = drones
end

function mining.load_targets(config)
    local targets = config.mining.targets

    local mandatory_targets = {}
    local maintained_targets = {}
    local accumulate_targets = {}

    for resource, data in pairs(targets) do
        if data.to_maintain then
            if data.mandatory then
                mandatory_targets[resource] = data.to_maintain
            else
                maintained_targets[resource] = data.to_maintain
            end
        end
        if data.relative then
            accumulate_targets[resource] = data.relative
        end
    end

    mining.runtime.targets = targets

    mining.runtime.mandatory_targets = mandatory_targets
    mining.runtime.maintained_targets = maintained_targets
    mining.runtime.accumulate_targets = accumulate_targets
end

function mining.load(config)
    mining.runtime.delta = config.delta
    mining.runtime.plasma_tier = config.mining.plasma_tier

    mining.load_modules(config)
    mining.reset_all()

    mining.load_drones(config)

    mining.runtime.storage_net = component.proxy(config.storage_net_address)

    if not mining.runtime.storage_net then
        error("Failed to locate ME Interface from the storage subnet")
        return
    end

    mining.load_targets(config)

    mining.load_cache()
end

-- ====================== MIN-MAXING =======================

function mining.get_amounts()
    local storage_net = mining.runtime.storage_net
    local targets = mining.runtime.targets

    local amounts = {}

    local items = storage_net.getItemsInNetwork()

    for material, target_data in pairs(targets) do
        amounts[material] = target_data.get_amount(items)
    end

    return amounts
end

function mining.find_optimal_configuration(amounts, modules, drones)
    local cache = mining.runtime.cache
    local mandatory = mining.runtime.mandatory_targets
    local maintained = mining.runtime.maintained_targets
    local accumulate = mining.runtime.accumulate_targets

    local result = {
        is_working = false,
        module_tier = 1,
        drone_tier = 1,
        distance = 0,
        yield = {}
    }

    local function find_active_targets()
        local active = {}

        for resource, to_maintain in pairs(mandatory) do
            if (amounts[resource] or 0) < to_maintain then
                active[resource] = to_maintain
            end
        end

        if next(active) then
            return active
        end

        for resource, to_maintain in pairs(maintained) do
            if (amounts[resource] or 0) < to_maintain then
                active[resource] = to_maintain
            end
        end

        if next(active) then
            return active
        end

        return accumulate
    end

    local active_targets = find_active_targets()

    if next(active_targets) == nil then
        return result
    end

    local function score_configuration(yield)
        local best = math.huge

        for resource, data in pairs(active_targets) do
            local current = amounts[resource] or 0
            local projected = current + (yield[resource] or 0)

            local value

            value = projected / data

            if value < best then
                best = value
            end
        end

        return best
    end

    local best_score = -math.huge

    for module_tier, module_count in ipairs(modules) do
        if module_count <= 0 then
            goto continue
        end

        for drone_tier, distance_data in ipairs(cache[module_tier]) do
            if drones[drone_tier] <= 0 then
                goto continue
            end
           
            for distance, yield in pairs(distance_data) do
                local score = score_configuration(yield)

                if score <= best_score then
                    goto continue
                end

                best_score = score
                
                result = {
                    is_working = true,
                    module_tier = module_tier,
                    drone_tier = drone_tier,
                    distance = distance,
                    yield = yield
                }
                ::continue::
            end
            ::continue::
        end
        ::continue::
    end

    return result
end

function mining.plan()
    local modules = mining.runtime.modules
    local modules_by_tier = mining.runtime.modules_by_tier

    local not_allocated = {}

    for tier, modules in ipairs(modules_by_tier) do
        not_allocated[tier] = #modules
    end

    local virtual_amounts = mining.get_amounts()
    local virtual_drones = vector.copy(mining.runtime.drones)

    mining.reset_all()

    for _ = 1, #modules do
        local config = mining.find_optimal_configuration(virtual_amounts, not_allocated, virtual_drones)

        if not config.is_working then
            print("Nothing to do anymore")
            break
        end

        not_allocated[config.module_tier] = not_allocated[config.module_tier] - 1

        local offset = #modules_by_tier[config.module_tier] - not_allocated[config.module_tier] + 1
        mining.apply(modules_by_tier[config.module_tier][offset], config)

        virtual_drones[config.drone_tier] = virtual_drones[config.drone_tier] - 1

        vector.add(virtual_amounts, config.yield)

        print(
            "Selected - Tier: " .. config.module_tier ..
            " Drone: " .. mining.static.voltage_names[config.drone_tier] ..
            " Distance: " .. config.distance
        )

        ::continue::
    end
end

return mining
