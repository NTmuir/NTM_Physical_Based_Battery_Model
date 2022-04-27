using Optim

 
function weight(x,args...)
    H, d, t = x  # all in inches
    B, rho, E, P = args
    return rho*2*pi*d*t*sqrt((B/2)^2 + H^2)
end
    
function stress(x,args...)
    H, d, t = x  # all in inches
    B, rho, E, P = args
    return (P*sqrt((B/2)^2 + H^2))/(2*t*pi*d*H)
end

function buckling_stress(x,args...)
    H, d, t = x  # all in inches
    B, rho, E, P = args
    return (pi^2*E*(d^2 + t^2))/(8*((B/2)^2 + H^2))
end

function deflection(x, args...)
    H, d, t = x  # all in inches
    B, rho, E, P = args
    return (P*sqrt((B/2)^2 + H^2)^3)/(2*t*pi*d*H^2*E)
end

function mycons(x,args)
    strs = stress(x,args)
    buck = buckling_stress(x,args)
    defl = deflection(x,args)
    return [100 - strs, buck - strs, 0.25 - defl]
end

B = 60  # inches
rho = 0.3  # lb/in^3
E = 30000  # kpsi
P = 66  # lb (force)
args = (B, rho, E, P)
lb = [10, 1, 0.01]
ub = [30, 3, 0.25]
pso = ParticleSwarm(lb, ub, 100)

result_1 = optimize(weight,mycons,pso)


