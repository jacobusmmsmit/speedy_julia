using BenchmarkTools
using StructArrays

function f(b, sa)
    b && push!(sa, (a=rand(),))
    return nothing
end

function g()
    sa = StructArray{typeof((a=0.0,))}(undef, 0)
    for _ in 1:10^6
        f(true, sa)
    end
    return nothing
end

@benchmark g()

function f(b, sa)
    b && push!(sa, (a=rand(),))
end

@benchmark g()

function f(b, sa)
    b ? push!(sa, (a=rand(),)) : (a = 0.0,)
end

@benchmark g()