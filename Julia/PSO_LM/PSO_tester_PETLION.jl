using Optim, PETLION, .Drivecycles

# Hard Limits
max_itr = 10
itr = 0

x0 = [p.θ[:l_p]]


function f(x::Vector)
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

while itr < max_itr
    println(itr)
    
    result = optimize(f,[0.0, 2.0], ParticleSwarm())

    Optim.minimizer(res)     

    Optim.minimum(res)

    global itr +=1
    print(itr)
end