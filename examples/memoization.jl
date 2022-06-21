using Memoize
using BenchmarkTools

function fib(n)
    if n == zero(n)
        return zero(n)
    elseif n == one(n)
        return one(n)
    else
        return mfib(n - 1) + mfib(n - 2)
    end
end

@memoize function mfib(n)
    if n == zero(n)
        return zero(n)
    elseif n == one(n)
        return one(n)
    else
        return mfib(n - 1) + mfib(n - 2)
    end
end

function fib_iter(n)
    a, b = zero(n), one(n)
    for _ in 1:n
        a, b = b, a + b
    end
    return a
end

# Memoization speeds up this function...
@benchmark fib(20) # Median 125.622 ns
@benchmark mfib(20) # Median 23.594 ns

# but a better implementation speeds it up even more
@benchmark mfib(50) # Median 26.908 ns
@benchmark fib_iter(50) # Median: 1.5 ns