
-- components
function PositionComponent(x,y)
    local component = {}
    component.position = {}

    component.position.x = x or 0
    component.position.y = y or 0

    return component.position
end

function NameComponent(name)
    local component = {}
    component.name = {}

    component.name.name = name
    
    return component.name
end


-- entities
function BoxEntity(x,y)
    local entity = {}

    entity.position = PositionComponent(x,y)

    return entity
end

function PlayerEntity(x,y,name)
    local entity = {}

    entity.position = PositionComponent(x,y)
    entity.name = NameComponent(name)

    return entity
end


-- systems
function PrintPositionSystem()
    local system = {}
    system.tag = "position"
    system.func = function (entity)
        print(entity.position.x)
        print(entity.position.y)
    end

    return system
end

function PrintNameSystem()
    local system = {}
    system.tag = "name"
    system.func = function (entity)
        print(entity.name.name)
    end
    
    return system
end

-- world
function CreateWorld()
    local world = {}
    world.entities = {}
    world.systems = {}

    world.AddEntity = function (self,entity)
        table.insert(self.entities,entity)
    end

    world.AddSystem = function (self, system)
        table.insert(self.systems, {tag = system.tag, func = system.func})        
    end

    world.UseSystems = function (self)
        for _, entity in ipairs(self.entities) do
            for _, system in ipairs(self.systems) do
                if entity[system.tag] then
                    system.func(entity)
                end
            end
        end
    end

    return world
end

local world = CreateWorld()

world:AddEntity(PlayerEntity(1,2,"Pepa"))
world:AddEntity(BoxEntity(4,6))

world:AddSystem(PrintPositionSystem())
world:AddSystem(PrintNameSystem())

world:UseSystems()