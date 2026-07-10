local config = {}
config.mining = {}
config.pumping = {}

local function single_item_get(name, meta)
    return function (items)
        local result = 0
        for _, item in ipairs(items) do
            if item.name ~= name then
                goto continue
            end
            if item.damage ~= meta then
                goto continue
            end
            result = item.size
            break
            ::continue::
        end
        return result
    end
end

local function sum_item_get(names, metas)
    return function(items)
        local result = 0
        for _, item in ipairs(items) do
            local found = false
            for i, name in ipairs(names) do
                if item.name == name and item.damage == metas[i] then
                    found = true
                    break
                end
            end
            if not found then
                goto continue
            end

            result = result + item.size
            ::continue::
        end
        return result
    end
end

config.delta = 60

config.storage_net_address = "f3a8db2a-5509-4827-8c59-3feb05d1a9e7"

config.mining = {
    drone_net_address = "66ed8c0f-e483-46cd-aa75-9f5385897c02",
    plasma_tier = 3,
    modules = {
        {
            module_address = "8783e41c-1842-4b63-acce-d46825acc86e",
            me_interface_address = "1785ab7d-56a7-4e2c-9233-8ee46737ea5d",
            transposer_address = "8521c0d0-2add-4497-83d1-2b0db2d0627a"
        },
        {
            module_address = "26e54c90-5bdb-4412-962a-a4081f42022b",
            me_interface_address = "ef554f51-b1aa-43a9-9ad5-a4be90402d88",
            transposer_address = "f042edf9-82b6-40ef-94de-1b360edac948"
        },
        {
            module_address = "6faeec34-620f-4a94-b114-2e67bd45f7c2",
            me_interface_address = "4df08124-4624-406e-a88a-b79ab563e37e",
            transposer_address = "fb671b40-b64c-4452-9812-bed199c55fe2"
        }
    },
    targets =
    {
        ["infinity_catalyst"] =
        {
            relative = 1,
            get_amount = single_item_get("gregtech:gt.metaitem.01", 2394)
        },
        ["silicon_solar_grade"] =
        {
            relative = 100,
            get_amount = single_item_get("gregtech:gt.metaitem.01", 2856)
        },
        -- Drills HV-EV
        ["titanium"] =
        {
            to_maintain = 1000000,
            mandatory = true,
            get_amount = single_item_get("gregtech:gt.metaitem.01", 2028)
        },
        -- Drills IV-LuV
        ["tungsten"] =
        {
            to_maintain = 1000000,
            mandatory = true,
            get_amount = single_item_get("gregtech:gt.metaitem.01", 2081)
        },
        -- Drills ZPM-UV
        ["naquadah_oxide_mixture"] =
        {
            to_maintain = 1000000,
            mandatory = true,
            get_amount = sum_item_get(
                {"bartworks:gt.bwMetaGenerateddust", "gregtech:gt.metaitem.01"},
                {10054, 2324}
            )
        },
        ["phosphorous"] =
        {
            to_maintain = 1000000,
            mandatory = true,
            get_amount = single_item_get("gregtech:gt.metaitem.01", 2021)
        },
        -- Drills UHV-UEV
        ["trinium"] =
        {
            to_maintain = 100000,
            mandatory = true,
            get_amount = single_item_get("gregtech:gt.metaitem.01", 2868)
        }
    }
}

config.pumping = {
    targets = {

    }
}

return config





