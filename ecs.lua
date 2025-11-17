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


--- Creates a new entity with a unique id
--- @return table entity a table with unique id value
local function defCreateEntity()
    return {id=uuid()}
end

ecs.CreateEntity = defCreateEntity


--- copies the component table into the entity table
--- @param entity table
--- @param component table
local function defAttachComponent(entity, component)
    entity[component.tag] = copyTable(component)
end

ecs.AttachComponent = defAttachComponent


return ecs