local os = require("os")

local event = require("event")
local term = require("term")
local thread = require("thread")

local config = require("config")

local mining = require("mining")
local pumping = require("pumping")

local function load(configuration)
    mining.load(configuration)
    pumping.load(configuration)
end

local main = thread.create(function()
    local status, error = pcall(load, config)

    if not status then
        print(error)
        return
    end

    local delta = config.delta

    while true do
        mining.plan()
        pumping.plan()

        os.sleep(delta)
    end
end)

local clean_up = thread.create(function()
    event.pull('interrupted')
    term.clear()

    print('Received Exit Command!')

    mining.reset_all()
    pumping.reset_all()

    main.kill()
    os.exit(0)
end)

thread.waitForAny({main, clean_up})
os.exit(0)