using Optim, PETLION

# Hard Limits
max_itr = 10
itr = 0

x0 = p.θ[:l_p]

y1 = 10

y2 = 100

 #Baseline GITT
 p.θ[:T₀] = p.θ[:T_amb] 
 soly_3 = solution()
 p.opts.outputs = (:t, :V, :I)
 p.opts.SOC = 1
 p.bounds.V_min = 2.5
 p.bounds.V_max = 4.2
 # GITT: 20 1C pulses followed by 2 hour rests
 @time for i in 1:20
     simulate!(soly_3, p, y1, I=-0.25)
     simulate!(soly_3, p, y2,  I=:rest)
 end

 V_baseline_3 = soly_3.V


function objective_function(x)
    p.θ[:l_p] = x[1]
    sol = "Sol_$x "
    sol = solution()
    p.opts.outputs = (:t, :V, :I)
    p.opts.SOC = 1
    p.bounds.V_min = 2.5
    p.bounds.V_max = 4.2
    for j in 1:20
        simulate!(sol, p, y1, I=-0.25)
        simulate!(sol, p, y2,  I=:rest)
    end
    Delta_V = V_baseline_3 - resize!(sol.V,length(V_baseline_3))    
    if maximum(sol.V) > 5 || minimum(sol.V) < 0
        NAN = zeros(length(V_baseline_3))
        Delta_V = fill!(NAN,NaN)
        println("$i is bad")
    end
    RMSE = sqrt.(sum.(Delta_V^.2) / length(Delta_V))
    return RMSE
end


    println(itr)
    
    @show result = optimize(objective_function,[0.0, .0])

    Optim.minimizer(res)     

    Optim.minimum(res)

    global itr +=1
    print(itr)