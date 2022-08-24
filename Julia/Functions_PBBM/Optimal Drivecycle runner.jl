using PETLION, Plots, Statistics, DataFrames, .Search , .Drivecycles

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

case = 7 # p.θ[:l_p] p.θ[:ϵ_p] p.θ[:k_n] p.θ[c_max_p] p.θ[:ϵ_n] p.θ[:l_n] p.θ[:l_p]

            focus = OAT(case)[1]
            lb = OAT(case)[2]
            step = OAT(case)[3]
            ub = OAT(case)[4]
            name = OAT(case)[5]
            unit = OAT(case)[6]


        #Baseline GITT
        p.θ[:T₀] = p.θ[:T_amb] 
        soly_3 = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 2.5
        p.bounds.V_max = 4.2
        # GITT: 20 1C pulses followed by 2 hour rests
        @time for i in 1:20
            simulate!(soly_3, p, 720, I=-0.25)
            simulate!(soly_3, p, 4*3600,  I=:rest)
        end

        V_baseline_3 = soly_3.V
        T_prime_3 = plot(soly_3, :V, title = "GITT")
        Time_3 = soly_3.t
        Current_3 = soly_3.I

        T5 = scatter(title="Average Sensitivty $name GITT")
        T6 = scatter(title="Delta Sensitivty $name GITT")


        Sens_GITT = Float64[]
        Delta_V_GITT = Vector[]
        Voltage_GITT = Vector[]

        return1 = focus

         # Dependency for GITT
        @time for i in lb:step:ub
            p.θ[:ϵ_n] = i
            for k in 1:length(i)
            sol = "Sol_$k "
            sol = solution()
            @time Delta_V = GITT(i,sol,p,V_baseline_3)[1]
                Sens_Av = GITT(i,sol,p,V_baseline_3)[2]
                Variation = GITT(i,sol,p,V_baseline_3)[3]
                scatter!(T5,(i,Sens_Av),xlabel = "$name $unit", ylabel = "Average Variation (%)",  legend = false)
                scatter!(T6,(i,Variation),xlabel = "$name $unit",ylabel = "Delta Variation (%)", legend = false)
                push!(Sens_GITT ,Sens_Av)
                push!(Delta_V_GITT,Delta_V)
                push!(Voltage_GITT,resize!(sol.V,length(V_baseline_3)))
            end
        end

        Vx5 = plot(Time_3,Voltage_GITT, legend = false, ylabel = "Voltage (V)", xlabel = "Time (s)", title = "GITT OAT Voltage $name")
        ylims!(3,4.2)
        xlims!(0, maximum(Time_3))
        Vx6 = plot(Time_3,Delta_V_GITT, legend = false, ylabel = "Delta Voltage (V)", xlabel = "Time (s)", title = "GITT OAT Delta Voltage $name")
        ylims!(-0.5,0.5)
        xlims!(0, maximum(Time_3))
        print("case $name completed GITT")

        @show focus = return1

    #save plots
    png(T5,"Average Sensitivty $name GITT")
    png(T6,"Delta Sensitivty $name GITT")
    png(Vx5,"Voltage $name GITT")
    png(Vx6,"Delta Voltage $name GITT")

