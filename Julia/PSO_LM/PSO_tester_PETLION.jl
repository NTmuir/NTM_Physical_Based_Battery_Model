using PETLION, Statistics,Metaheuristics,Plots

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

case = 1

            println("Case $case starting")

                x0 = OAT(case)[1]
                lb = OAT(case)[2]
                step = OAT(case)[3]
                ub = OAT(case)[4]
                name = OAT(case)[5]
                unit = OAT(case)[6]


println("Starting Baseline")
#Baseline 
p.θ[:T₀] = p.θ[:T_amb] 
soly_3 = solution()
p.opts.outputs = (:t, :V, :I)
p.opts.SOC = 1
p.bounds.V_min = 2.5
p.bounds.V_max = 4.2
@time for i in 1:20
    simulate!(soly_3, p, 720, I=-0.25)
    simulate!(soly_3, p, 4*3600,  I=:rest)
end
V_baseline_3 = soly_3.V
println("Baseline complete")

function objective_function(x)
    p.θ[:l_p] = x[1]
    sol = "Sol_$x "
    sol = solution()
    @time for i in 1:20
        simulate!(sol, p, 720, I=-0.25)
        simulate!(sol, p, 4*3600,  I=:rest)
    end#Simulate the same response from the baselin 
    Delta_V = V_baseline_3 - resize!(sol.V,length(V_baseline_3)) #    
    if maximum(sol.V) > 5 || minimum(sol.V) < 0 #Plausability check to change anything to NaN 
        NAN = zeros(length(V_baseline_3))
        Delta_V = fill!(NAN,NaN)
    end
    RMSE =  sqrt(mean((Delta_V.^2))) #RMSE for Baseline against simulated respsonse
    gx = [0.0]
    hx = [0.0]
    println(RMSE)
    return RMSE
end

println("objective_function loaded in")
    
@show result = optimize(objective_function,[lb lb; ub ub],PSO(options=Options(debug = true,store_convergence = true,iterations=1000,time_limit = 120)))

PSO_min = minimizer(result)[1]

@show Error = ((x0 - PSO_min)/x0) * 100

f_calls, best_f_value = convergence(result)

animation = @animate for i in 1:length(result.convergence)
    l = @layout [a b]
    p = plot( layout=l)

    X = positions(result.convergence[i])
    scatter!(p[1], X[:,1], X[:,2], label="", xlim=(0, ub), ylim=(0,ub+0.1*ub), title="Population")
    x = minimizer(result.convergence[i])
    scatter!(p[1], x[1:1], x[2:2], label="")

    # convergence
    plot!(p[2], xlabel="Generation", ylabel="fitness", title="Gen $name: $i")
    plot!(p[2], 1:length(best_f_value), best_f_value, label=false)
    plot!(p[2], 1:i, best_f_value[1:i], lw=3, label=false)
    x = minimizer(result.convergence[i])
    scatter!(p[2], [i], [minimum(result.convergence[i])], label=false)
end

# save in different formats
gif(animation, "anim- $name convergence.gif", fps=30)