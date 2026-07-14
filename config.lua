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
            module_address = "de19959c-d8a5-4db7-a174-afd7cd029145",
            me_interface_address = "6fca4626-6ada-42c4-bf47-011d8a4bece7",
            transposer_address = "f7e1ab68-0b54-4bd1-8bad-5c63698f2457"
        },
        {
            module_address = "1ae218f6-82ce-46c2-9103-27be2f203bb9",
            me_interface_address = "d0affacf-b7d8-4412-aac1-d250e29126d6",
            transposer_address = "3b1b5be8-6024-4b1e-a5e5-083c3318b692"
        },
        {
            module_address = "b4fe535d-0e80-46b4-bd2f-d9ece2350d41",
            me_interface_address = "bae5ca79-b6de-43d1-8d69-a895561973fe",
            transposer_address = "97388e1d-69ac-4fe6-9ecf-0901b2d01882"
        },
        {
            module_address = "78519427-5e1d-42f6-a117-22cf31860a76",
            me_interface_address = "fad090d0-b96a-4866-91dc-1bb566d92cfe",
            transposer_address = "7ddc3bcd-e191-4e66-bd1a-d483fb2541a3"
        },
        {
            module_address = "5a864b64-44c8-499f-8233-f3923496a90",
            me_interface_address = "1df35ab7-6c96-4b4b-b273-0dbf8050c349",
            transposer_address = "b82aedfc-56c0-41ae-832b-90eefc3ec419"
        },
        {
            module_address = "99c6ea47-543a-4890-9f40-1eed1e804f61",
            me_interface_address = "8d9b295c-f6ae-42ec-84b5-ed9822f8e60b",
            transposer_address = "8bc67807-5c03-4b4b-a147-e0ce500041dc"
        },
        {
            module_address = "8f049f9c-7d2d-43d6-8c50-d09cb49a4431",
            me_interface_address = "6fc400be-fd7a-4c0c-b9a2-9742b9755873",
            transposer_address = "bb26331e-50b1-49e8-a485-0e52c6bbaca6"
        },
        {
            module_address = "98ecd3fc-3423-4a0d-ae47-c3157f4e2816",
            me_interface_address = "6a11adef-9470-4b14-bb3d-0df3c1a6057a",
            transposer_address = "4c2ee570-acb7-4b6d-8cc1-e7cfae553bef"
        },
        {
            module_address = "9c69ec46-7737-43bb-a625-827113870ce1",
            me_interface_address = "63c5d85a-1515-43bb-b4d6-0963509b1ae3",
            transposer_address = "d240ebd4-4a41-4ee2-ac3a-d4298332795f"
        },
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
        },
        {
            module_address = "e50e5f08-aab7-4fc6-b3e5-2af819bb08c6",
            me_interface_address = "cc54e3c8-a865-40af-bb8b-dcfa41e5847f",
            transposer_address = "670070d4-6e10-440d-b309-a1c12252d198"
        },
        {
            module_address = "37bc92f5-8524-445a-aec8-ec8e01e71a6d",
            me_interface_address = "b95840f1-806d-4663-ad67-4f0c59836f76",
            transposer_address = "c911e3a9-63a5-4d9b-8ed5-3e202d49b1de"
        },
        {
            module_address = "52784574-47b0-4587-a9ff-1dfc8f8b7de4",
            me_interface_address = "c5948aa1-8a46-4e9a-a337-13c3084c1df8",
            transposer_address = "77b7948a-77f9-4cf2-8c66-561ee02db346"
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
            relative = 5,
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
            to_maintain = 10000000,
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

local quantum_cell = 274877904896 - 1
local singularity_cell = 4611686018427385856 - 1

config.pumping =
{
    targets =
    {
        ["chlorobenzene"] =
        {
            to_maintain = quantum_cell
        },
        ["very_heavy_oil"] =
        {
            relative = 1
        },
        ["lava"] =
        {
            to_maintain = quantum_cell
        },
        ["sulfuric_acid"] =
        {
            to_maintain = quantum_cell,
            relative = 1
        },
        ["molten_iron"] =
        {
            relative = 1
        },
        ["oil"] =
        {
            to_maintain = quantum_cell
        },
        ["carbon_dioxide"] =
        {
            to_maintain = quantum_cell
        },
        ["carbon_monoxide"] =
        {
            to_maintain = quantum_cell
        },
        ["helium-3"] =
        {
            to_maintain = quantum_cell
        },
        ["salt_water"] =
        {
            relative = 1
        },
        ["helium"] =
        {
            to_maintain = quantum_cell
        },
        ["liquid_oxygen"] =
        {
            to_maintain = quantum_cell
        },
        ["neon"] =
        {
            to_maintain = quantum_cell / 2
        },
        ["argon"] =
        {
            to_maintain = quantum_cell / 4
        },
        ["krypton"] =
        {
            to_maintain = quantum_cell / 8
        },
        ["methane"] =
        {
            to_maintain = quantum_cell
        },
        ["deuterium"] =
        {
            to_maintain = quantum_cell
        },
        ["tritium"] =
        {
            to_maintain = quantum_cell / 2
        },
        ["ammonia"] =
        {
            to_maintain = quantum_cell
        },
        ["ethylene"] =
        {
            relative = 1
        },
        ["hydrofluoric_acid"] =
        {
            to_maintain = quantum_cell
        },
        ["fluorine"] =
        {
            to_maintain = quantum_cell
        },
        ["nitrogen"] =
        {
            to_maintain = quantum_cell,
            relative = 1
        },
        ["oxygen"] =
        {
            to_maintain = quantum_cell,
            relative = 1
        },
        ["hydrogen"] =
        {
            to_maintain = quantum_cell,
            relative = 1
        },
        ["liquid_air"] =
        {
            to_maintain = quantum_cell
        },
        ["molten_copper"] =
        {
            relative = 1
        },
        ["unknown_liquid"] =
        {
            to_maintain = quantum_cell
        },
        ["distilled_water"] =
        {
            to_maintain = quantum_cell
        },
        ["radon"] =
        {
            to_maintain = quantum_cell
        },
        ["molten_tin"] =
        {
            relative = 1
        }
    }
}

return config





