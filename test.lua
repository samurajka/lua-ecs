Ecs = require "ecs"


local component1 = Ecs.CreateComponent("position", {x=5,y=0})

for index, value in pairs(component1) do
    print(index)
    print(value)
end

print(component1.x)
