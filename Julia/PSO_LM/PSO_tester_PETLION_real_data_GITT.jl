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

x1 = OAT(1)[1]
lb1 = OAT(1)[2]
ub1 = OAT(1)[4]
rand1 = OAT(1)[7]

x2 = OAT(2)[1]
lb2 = OAT(2)[2]
ub2 = OAT(2)[4]
rand2 = OAT(2)[7]

x3 = OAT(3)[1]
lb3 = OAT(3)[2]
ub3 = OAT(3)[4]
rand3 = OAT(3)[7]

x4 = OAT(4)[1]
lb4 = OAT(4)[2]
ub4 = OAT(4)[4]
rand4 = OAT(4)[7]

x5 = OAT(5)[1]
lb5 = OAT(5)[2]
ub5 = OAT(5)[4]
rand5 = OAT(5)[7]

x6 = OAT(6)[1]
lb6 = OAT(6)[2]
ub6 = OAT(6)[4]
rand6 = OAT(6)[7]

function objective_function(x)
    @show p.θ[:l_p] = x[1]
    @show p.θ[:ϵ_p] = x[2]
    @show p.θ[:l_n]= x[3]
    @show p.θ[:k_n] = x[4]
    @show p.θ[:c_max_p] = x[5]
    @show p.θ[:ϵ_n] = x[6]

    sol = "Sol_$x"
    sol = solution()
    for i in 1:20
        simulate!(sol, p, 720, I=-0.25)
        simulate!(sol, p, 4*3600,  I=:rest)
    end #Simulate the same response from the baseline
    
    if maximum(sol.V) > 5 || minimum(sol.V) < 0 #Plausability check to change anything to NaN 
        NAN = zeros(length(sol.V))
        Delta_V = fill!(NAN,NaN)
    end
    
    Smooth_time_HVES_GITT = round.(Adjusted_Time_GITT)
    Smooth_time_PETLION_GITT = round.(sol.t)
    
    Array_Adjust = zeros(length(Adjusted_Time_GITT)-length(sol.t))
    Array_Adjust_NAN = fill!(Array_Adjust,1e11)
    
    PETLION_Time_GITT = append!(Smooth_time_PETLION_GITT ,Array_Adjust_NAN)
    PETLION_Voltage_GITT = append!(sol.V ,Array_Adjust_NAN)
    
    df_final_GITT_1 = DataFrame(Adjusted_Time_GITT = Smooth_time_HVES_GITT,Voltage_GITT = Voltage_GITT)
    df_final_GITT_2 = DataFrame(Adjusted_Time_GITT =Smooth_time_PETLION_GITT,PETLION_Voltage = sol.V)

    df_final_GITT = dropmissing(leftjoin(df_final_GITT_1,df_final_GITT_2, on= :Adjusted_Time_GITT))

    data_RMSE = Base.Matrix(df_final_GITT)

    Delta_V = data_RMSE[:,2] - data_RMSE[:,3]

    RMSE =  sqrt(mean((Delta_V.^2))) #RMSE for Baseline against simulated respsonse
    gx = [0.0]
    hx = [0.0]
    println(RMSE)
    return RMSE
end

println("objective_function loaded in")
    
@show result = optimize(objective_function,[lb1 lb2 lb3 lb4 lb5 lb6; ub1 ub2 ub3 ub4 ub5 ub6],PSO(N=20,information = Information(x_optimum=[rand1,rand2,rand3,rand4,rand5,rand6]),options=Options(debug = true,store_convergence = true,time_limit=3600.0)))

l_p_min = minimizer(result)[1]
ϵ_p_min = minimizer(result)[2]
l_n_min = minimizer(result)[3]
k_n_min = minimizer(result)[4]
c_max_p_min = minimizer(result)[5]
ϵ_n_min = minimizer(result)[6]

o = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

#PSO profile check
o.θ[:l_p] = l_p_min
o.θ[:ϵ_p] = ϵ_p_min
o.θ[:l_n]= l_n_min 
o.θ[:k_n] = k_n_min
o.θ[:c_max_p] = c_max_p_min
o.θ[:ϵ_n] = ϵ_n_min

        #Baseline GITT
        o.θ[:T₀] = o.θ[:T_amb] 
        soly_3 = solution()
        o.opts.outputs = (:t, :V, :I)
        o.opts.SOC = 1
        o.bounds.V_min = 2.5
        o.bounds.V_max = 4.2
        # GITT: 20 1C pulses followed by 2 hour rests
        @time for i in 1:20
            simulate!(soly_3, o, 720, I=-0.25)
            simulate!(soly_3, o, 4*3600,  I=:rest)
        end

        V_baseline_3 = soly_3.V
        T_prime_3 = plot(soly_3, :V, title = "GITT")
        Time_3 = soly_3.t
        Current_3 = soly_3.I


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
gif(animation, "anim- $name with real data convergence.gif", fps=30)