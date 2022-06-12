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

# Results on my machine:
# BenchmarkTools.Trial: 1000 samples with 1 evaluation.
#  Range (min … max):  11.846 ms … 70.800 ms  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     13.133 ms              ┊ GC (median):    0.00%
#  Time  (mean ± σ):   13.981 ms ±  3.571 ms  ┊ GC (mean ± σ):  0.00% ± 0.00%

#      ▅█▅     
#   ▂▄▇████▆▆▅▄▄▄▄▄▄▃▃▂▂▃▂▃▂▂▂▂▂▂▂▁▂▂▂▂▂▁▂▁▁▂▁▂▁▂▁▁▁▁▁▂▂▂▁▂▂▁▁▂ ▃
#   11.8 ms         Histogram: frequency by time          25 ms <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 1000 samples with 1 evaluation.
#  Range (min … max):  11.907 ms … 43.540 ms  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     13.493 ms              ┊ GC (median):    0.00%
#  Time  (mean ± σ):   14.033 ms ±  2.290 ms  ┊ GC (mean ± σ):  0.00% ± 0.00%

#    ▁▃███▄▂▁    ▂▁▁
#   ▃████████▆██████▇▇▅▄▄▃▃▃▃▃▃▂▂▁▂▂▁▂▂▁▂▁▂▁▂▁▁▁▂▁▁▁▁▁▁▁▁▁▂▁▁▂▂ ▄
#   11.9 ms         Histogram: frequency by time        23.5 ms <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 1000 samples with 1 evaluation.
#  Range (min … max):  11.689 ms …  17.169 ms  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     12.694 ms               ┊ GC (median):    0.00%
#  Time  (mean ± σ):   12.769 ms ± 588.351 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

#            ▁▄▃▃▂▅█▅▆▆▆▇▅▁▁
#   ▂▂▃▂▄▄▇█████████████████▇█▆▅▄▄▃▄▄▃▃▃▃▂▁▃▃▁▂▂▁▂▁▂▁▁▃▁▂▂▂▂▂▂▃▃ ▄
#   11.7 ms         Histogram: frequency by time         15.1 ms <

#  Memory estimate: 0 bytes, allocs estimate: 0.