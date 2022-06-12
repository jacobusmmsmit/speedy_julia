using BenchmarkTools

# This is so each benchmark has time to complete. But even on my rather old
# laptop the whole thing completes in around a minute.
BenchmarkTools.DEFAULT_PARAMETERS.seconds = 60

const N = 10_000

@inline function f_inline(v, i)
    sqrt(1 + sum(v) * i)
end

@noinline function f_noinline(v, i)
    sqrt(1 + sum(v) * i)
end

function f_loopinside(v)
    for i in eachindex(v)
        v[i] = sqrt(1 + sum(v) * i)
    end
    return nothing
end

function f_inline(v)
    for i in eachindex(v)
        v[i] = sqrt(1 + sum(v) * i)
    end
    return nothing
end

function run_inline(v)
    for i in eachindex(v)
        v[i] = f_inline(v, i)
    end
    return nothing
end

function run_noinline(v)
    for i in eachindex(v)
        v[i] = f_noinline(v, i)
    end
    return nothing
end

function run_loopinside(v)
    f_loopinside(v)
    return nothing
end

bench_inline = @benchmark run_inline(v) samples = 1000 setup = (v = zeros(N))
bench_noinline = @benchmark run_noinline(v) samples = 1000 setup = (v = zeros(N))
bench_loopinside = @benchmark run_loopinside(v) samples = 1000 setup = (v = zeros(N))