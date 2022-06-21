mutable struct Thing
    x
end
t = Thing(10)
@show t.x # prints t.x = 10
function change_argument(thing)
    thing.x += 1
    return nothing
end
change_argument(t)
@show t.x # prints t.x = 11
function change_object(thing)
    thing = Thing(thing.x + 1)
    return nothing
end
change_object(t)
@show t.x; # prints t.x = 11 NOT t.x = 12