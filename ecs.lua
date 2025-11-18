-- ecs library

local ecs = {}


local idCounter = 0

local function uuid()
    idCounter = idCounter + 1
    return ("%08x-%04x"):format(idCounter, math.random(0, 0xFFFF))
end


--- Helper function for attaching components and more
--- @param tab table
--- @return table copy returns a new table with values from tab
local function copyTable(tab)
    if type(tab) ~= "table" then return tab end
    local copy = {}
    for k, v in pairs(tab) do
        copy[k] = copyTable(v)
    end
    return copy
end


--- All variables in the data table **must** be initialized with a default value
--- @param name string
--- @param data table
--- @return table component named name with variables from data
local function defCreateComponent(name, data)
    local component = {}
    component[name] = {}
    component[name]["tag"] = name

    for index, value in pairs(data) do
        component[name][index] = value
    end

    return component[name]
end

ecs.CreateComponent = defCreateComponent


--- copies the component table into the entity table
--- @param entity table
--- @param component table
local function defAttachComponent(entity, component)
    entity[component.tag] = copyTable(component)
end


--- Creates a new entity with a unique id
--- @return table entity a table with unique id value
local function defCreateEntity()
    local entity = {}

    entity.id = uuid()
    entity.AttachComponent = defAttachComponent

    return entity
end

ecs.CreateEntity = defCreateEntity

-- TODO remove this and only allow calling as a method from entity
ecs.AttachComponent = defAttachComponent


local function defAttachEntity(self, entity)
    table.insert(self.allEntities, entity)

    for key, value in pairs(entity) do
        if key == "id" then
            goto continue
        end

        if self[key] == nil then
            self[key] = {}
        end

        table.insert(self[key], entity)

        ::continue::
    end
end


local function defCreateSystem(tag, func)
    local system = {}

    system.tag = tag
    system.func = func 

    return system
end


ecs.CreateSystem = defCreateSystem


local function defAttachSystem(world, system)
    table.insert(world.allSystems, system)
end


local function defUseSystems(world)
    for _, system in pairs(world.allSystems) do
        for _, entity in pairs(world[system.tag]) do
            system.func(entity)
        end
    end
end


local function defCreateWorld()
    local world = {}

    world.allEntities = {}
    world.AttachEntity = defAttachEntity

    world.allSystems = {}
    world.AttachSystem = defAttachSystem

    world.UseSystems = defUseSystems

    return world
end

ecs.CreateWorld = defCreateWorld





return ecs