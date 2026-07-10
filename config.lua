local self = {}
self.mining = {}
self.pumping = {}

self.delta = 60

self.storage_net_address = "f3a8db2a-5509-4827-8c59-3feb05d1a9e7"

self.mining = {
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
    targets = {

    }
}

self.pumping = {
    targets = {

    }
}

return self





