using BenchmarkTools
import Base.+

mutable struct vec3{T}
    x::T
    y::T
    z::T
end

(+)(a::vec3, b::vec3) = vec3(a.x + b.x, a.y + b.y, a.z + b.z)

function add_ooplace()
    a = vec3(1, 0, 0) + vec3(0, 1, 0) + vec3(0, 0, 1)
end

function add_inplace()
    b = vec3(1, 0, 0)
    b += vec3(0, 1, 0)
    b += vec3(0, 0, 1)
end

function main()
    b1 = @benchmark add_ooplace()
    b2 = @benchmark add_inplace()
    return b1, b2
end
b1, b2 = main()
b1
b2

# The internal representation of the functions are different:
@code_lowered add_ooplace()
# CodeInfo(
# 1 ─ %1 = Main.vec3(1, 0, 0)
# │   %2 = Main.vec3(0, 1, 0)
# │   %3 = Main.vec3(0, 0, 1)
# │   %4 = %1 + %2 + %3       
# │        a = %4
# └──      return %4
# )

@code_lowered add_inplace()
# CodeInfo(
# 1 ─      b = Main.vec3(1, 0, 0)
# │   %2 = b
# │   %3 = Main.vec3(0, 1, 0)    
# │        b = %2 + %3
# │   %5 = b
# │   %6 = Main.vec3(0, 0, 1)
# │   %7 = %5 + %6
# │        b = %7
# └──      return %7
# )
# )

# But as soon as type inference kicks in, the generic instructions are replaced
# with their actual implementations:
@code_typed add_ooplace()
# CodeInfo(
# 1 ─ %1 = Base.add_int(1, 0)::Int64
# │   %2 = Base.add_int(0, 1)::Int64
# │   %3 = Base.add_int(0, 0)::Int64
# │   %4 = Base.add_int(%1, 0)::Int64
# │   %5 = Base.add_int(%2, 0)::Int64
# │   %6 = Base.add_int(%3, 1)::Int64
# │   %7 = %new(vec3{Int64}, %4, %5, %6)::vec3{Int64}
# └──      return %7
# ) => vec3{Int64}

@code_typed add_inplace()
# CodeInfo(
# 1 ─ %1 = Base.add_int(1, 0)::Int64
# │   %2 = Base.add_int(0, 1)::Int64
# │   %3 = Base.add_int(0, 0)::Int64
# │   %4 = Base.add_int(%1, 0)::Int64
# │   %5 = Base.add_int(%2, 0)::Int64
# │   %6 = Base.add_int(%3, 1)::Int64
# │   %7 = %new(vec3{Int64}, %4, %5, %6)::vec3{Int64}
# └──      return %7
# ) => vec3{Int64}