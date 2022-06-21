using BenchmarkTools

function mysum(v::Vector{T}) where {T}
    t = T(0)
    for x in v
        t += x
    end
    return t
end

function mysum_simd(v::Vector{T}) where {T}
    t = T(0)
    @simd for x in v
        t += x
    end
    return t
end

function main()
    myvector = collect(1.0:1.0:1000.0)
    b1 = @benchmark mysum($myvector)
    b1_simd = @benchmark mysum_simd($myvector)

    myf32vector = Float32.(myvector)
    b2 = @benchmark mysum($myf32vector)
    b2_simd = @benchmark mysum_simd($myf32vector)

    myf16vector = Float16.(myvector)
    b3 = @benchmark mysum($myf16vector)
    b3_simd = @benchmark mysum_simd($myf16vector)
    b1, b1_simd, b2, b2_simd, b3, b3_simd
end

benchmark_res = main()
# Float64
benchmark_res[1] # Slow
benchmark_res[2] # Fast
# Float32
benchmark_res[3] # As slow as [1]
benchmark_res[4] # Faster than [2]
# Float16
benchmark_res[5] # Painfully slow
benchmark_res[6] # Just as painfully slow

# BenchmarkTools.Trial: 10000 samples with 10 evaluations.
#  Range (min … max):  1.100 μs …  22.200 μs  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     1.110 μs               ┊ GC (median):    0.00%
#  Time  (mean ± σ):   1.240 μs ± 541.397 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

#   █▅▆▃▃                                                       ▁
#   █████▆▃▇█▆▅▄▅▃▄▃▃▃▅▄▄▅▁▄▃▄▄▃▄▃▅▁▃▄▁▅███▇█▄▄▁▃▆▇▆▅▄▄▇█▇▇▇▅▅▆ █
#   1.1 μs       Histogram: log(frequency) by time      3.22 μs <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 10000 samples with 972 evaluations.
#  Range (min … max):  75.103 ns …  2.788 μs  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     79.835 ns              ┊ GC (median):    0.00%
#  Time  (mean ± σ):   86.205 ns ± 44.236 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

#   █ ▇▆▂▃▅▂▁▁▁▁▁      ▂                                        ▁
#   █▇██████████████▇▇▇██▇██▇▇▇▇▆▆▇▆▆▇▆▆▆▆▅▆▇▆▆▆▆▆▅▆▅▄▆▅▄▆▄▅▅▄▅ █
#   75.1 ns      Histogram: log(frequency) by time       184 ns <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 10000 samples with 10 evaluations.
#  Range (min … max):  1.100 μs … 129.020 μs  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     1.180 μs               ┊ GC (median):    0.00%
#  Time  (mean ± σ):   1.292 μs ±   1.530 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

#   ▇▇█▄▄                                                       ▂
#   ██████▄█▆▅▅▄▅▅▅▄▃▅▄▁▅▄▅▄▅▃▃▃▄▄▃▃▃▄▆▆▆██▇▆▄▃▃▇▇▇▄▄▆▇▇▇█▇▄▄▆▆ █
#   1.1 μs       Histogram: log(frequency) by time      3.28 μs <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 10000 samples with 991 evaluations.
#  Range (min … max):  40.969 ns … 715.641 ns  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     43.895 ns               ┊ GC (median):    0.00%
#  Time  (mean ± σ):   48.524 ns ±  20.361 ns  ┊ GC (mean ± σ):  0.00% ± 0.00%

#   ▇ █▆▅▃     ▁ ▁▁▂▁ ▁▁▁          ▁                             ▂
#   █▁█████▇▇▆▆█▇█████████▇█▇▇▆▇▇███▇▇▇▇▇▇▇▅▆▇▇▆▆▇▆▇▆▅▅▅▆▄▆▅▅▆▆▅ █
#   41 ns         Histogram: log(frequency) by time       113 ns <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 10000 samples with 6 evaluations.
#  Range (min … max):  6.300 μs … 61.333 μs  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     6.717 μs              ┊ GC (median):    0.00%
#  Time  (mean ± σ):   7.150 μs ±  2.311 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

#   █ █▁▂▃ ▂         ▁  ▁                                      ▁
#   █▇████▆█▆▆▅▄████▆█▆████▆▅▆▅▆▆▅▄▅▇▅█▆▆▆▆▅▅▅▄▄▅▅▆▅▄▄▃▆▅▅▅▄▅▄ █
#   6.3 μs       Histogram: log(frequency) by time     16.6 μs <

#  Memory estimate: 0 bytes, allocs estimate: 0.

# BenchmarkTools.Trial: 10000 samples with 6 evaluations.
#  Range (min … max):  6.317 μs … 637.850 μs  ┊ GC (min … max): 0.00% … 0.00%
#  Time  (median):     6.733 μs               ┊ GC (median):    0.00%
#  Time  (mean ± σ):   7.561 μs ±   7.550 μs  ┊ GC (mean ± σ):  0.00% ± 0.00%

#   ▇▇█▅▆▂▃       ▁▂ ▁▁▁          ▁                             ▂
#   █████████████████████▆▇▆▇▇▇▇█████▇▇▇▇▇▆▆▆▆▆▅▇▇▇▆▁▅▅▄▅▄▄▄▄▄▅ █
#   6.32 μs      Histogram: log(frequency) by time      18.3 μs <

#  Memory estimate: 0 bytes, allocs estimate: 0.