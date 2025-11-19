Ecs = require "ecs"


local component1 = Ecs.CreateComponent("position", {x=5,y=0})

for index, value in pairs(component1) do
    print(index)
    print(value)
end

print(component1.x)


local world = Ecs.CreateWorld()


local entity1 = Ecs.CreateEntity()


entity1:AttachComponent(component1)

world:AttachEntity(entity1)

print()
for key, value in pairs(world) do
    print(key)
end
print()

for key, value in pairs(world.position) do
    print(key)
    print(value)
end

print(entity1)


local function PrintPos(entity)
    print(entity.position.x)
    print(entity.position.y)
end

local system1 = Ecs.CreateSystem("position", PrintPos)


world:AttachSystem(system1)

print("using sysstems:")
world:UseSystems()