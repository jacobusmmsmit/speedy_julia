function switch(n)
    m = n ≤ 0.1 ? 0.0 :
        n ≤ 0.6 ? 1.0 :
        n ≤ 0.8 ? 1.1 :
        n ≤ 1.0 ? 1.2 :
        n ≤ 1.3 ? 1.35 :
        2.2        #=otherwise=#
    m
end

println("Let block")
let
    n = 1.1
    @code_native switch(n) # Long
end

println("Const argument")
begin
    const a = 1.1
    @code_native switch(a) # Long
end

function boundary()
    a = 1.1
    switch(a)
end

println("Using boundary")
@code_native boundary()