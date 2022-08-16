using PETLION, Plots, Statistics, DataFrames

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

case = 1 # p.θ[:l_p] p.θ[:ϵ_p] p.θ[:k_n] p.θ[c_max_p] p.θ[:ϵ_n] p.θ[:l_n] p.θ[:l_p]

            focus = OAT(case)[1]
            lb = OAT(case)[2]
            step = OAT(case)[3]
            ub = OAT(case)[4]
            name = OAT(case)[5]
            unit = OAT(case)[6]

        # Load the solution structure with an initial SOC of 1
        soly = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 3
        p.bounds.V_max = 4.2

        ## Baseline
        p.θ[:T₀] = p.θ[:T_amb] 
        # HPPC: 20 5C pulses followed by 1 hour rests
        @time for i in 1:9
            simulate!(soly, p, 10, I=-3) #Pulse Discharge
            simulate!(soly, p, 40, I=:rest) #Relax
            simulate!(soly, p, 10, I=3) #Pulse Charge
            simulate!(soly, p, 300, I=-1) #To remove 10% SOC
            simulate!(soly, p, 3600, I=:rest) #Hour Rest
        end

        V_baseline_1 = soly.V
        T_prime_1 = plot(soly, :V ,title = "HPPC Aggressive")
        Time_1 = soly.t
        Current_1 = soly.I

        T1 = scatter(title="Average Sensitivty $name HPPC Aggressive")
        T2 = scatter(title="Delta Sensitivty $name HPPC Aggressive")

        @show return1 = focus

        Sens_HPPC_5C = Float64[]
        Delta_V_HPPC_5C = Vector[]
        Voltage_HPPC_5C = Vector[]

        #5C HPPC
        @time for i in lb:step:ub
            p.θ[:l_p] = i
            for k in 1:length(i)
            sol = "Sol_$k "
            sol = solution()
            @time Delta_V = HPPC_5C(i,sol,p,V_baseline_1)[1]
                Sens_Av = HPPC_5C(i,sol,p,V_baseline_1)[2]
                Variation = HPPC_5C(i,sol,p,V_baseline_1)[3]
                scatter!(T1,(i,Sens_Av),xlabel = "$name $unit", ylabel = "Average Variation (%)",  legend = false)
                scatter!(T2,(i,Variation),xlabel = "$name $unit",ylabel = "Delta Variation (%)", legend = false)
                push!(Sens_HPPC_5C,Sens_Av)
                push!(Delta_V_HPPC_5C,Delta_V )
                push!(Voltage_HPPC_5C,resize!(sol.V,length(V_baseline_1)))
            end
        end

        Vx1 = plot(Time_1,Voltage_HPPC_5C, legend = false,ylabel = "Voltage (V)", xlabel = "Time (s)", title = "HPPC Agressive OAT Voltage $name")
        ylims!(3,4.2)
        xlims!(0, maximum(Time_1))
        Vx2 = plot(Time_1,Delta_V_HPPC_5C, legend = false,ylabel = "Delta Voltage (V)", xlabel = "Time (s)", title = "HPPC Agressive OAT Delta Voltage $name")
        ylims!(-1,1)
        xlims!(0, maximum(Time_1))

        print("case $name completed HPPC 5C")
        #Baseline at Higher C
        soly_2 = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 3
        p.bounds.V_max = 4.2

        p.θ[:T₀] = p.θ[:T_amb] 
        # HPPC: 20 5C pulses followed by 1 hour rests
        @time for i in 1:20
            simulate!(soly_2, p, 10, I=-0.96) #Pulse Discharge
            simulate!(soly_2, p, 40, I=:rest) #Relax
            simulate!(soly_2, p, 10, I=0.72) #Pulse Charge
            simulate!(soly_2, p, 820, I=-0.2) #To remove 10% SOC
            simulate!(soly_2, p, 3600,  I=:rest) #Hour Rest
        end

        V_baseline_2 = soly_2.V
        T_prime_2 = plot(soly_2, :V, title = "HPPC HVES Baseline")
        Time_2 = soly_2.t
        Current_2 = soly_2.I
        T3 = scatter(title="Average Sensitivty $name HPPC")
        T4 = scatter(title="Delta Sensitivty $name HPPC")

        @show return1 = focus

        Sens_HPPC = Float64[]
        Delta_V_HPPC = Vector[]
        Voltage_HPPC = Vector[]

         #HVES HPPC
        @time for i in lb:step:ub
            p.θ[:l_p] = i
            for k in 1:length(i)
            sol = "Sol_$k "
            sol = solution()
            @time Delta_V = HPPC_HVES(i,sol,p,V_baseline_2)[1]
                Sens_Av = HPPC_HVES(i,sol,p,V_baseline_2)[2]
                Variation = HPPC_HVES(i,sol,p,V_baseline_2)[3]
                scatter!(T3,(i,Sens_Av),xlabel = "$name $unit", ylabel = "Average Variation (%)",  legend = false)
                scatter!(T4,(i,Variation),xlabel = "$name $unit",ylabel = "Delta Variation (%)", legend = false)
                push!(Sens_HPPC,Sens_Av)
                push!(Delta_V_HPPC,Delta_V )
                push!(Voltage_HPPC,resize!(sol.V,length(V_baseline_2)))
            end
        end

        Vx3 = plot(Time_2,Voltage_HPPC,legend = false, ylabel = "Voltage (V)", xlabel = "Time (s)", title = "HPPC HVES OAT Voltage $name")
        ylims!(3,4.2)

        Vx4 = plot(Time_2,Delta_V_HPPC,legend = false, ylabel = "Delta Voltage (V)", xlabel = "Time (s)", title = "HPPC HVES OAT Delta Voltage $name")
        ylims!(-1,1)

        print("case $name completed HPPC")
         
        @show focus = return1

        #Baseline GITT
        p.θ[:T₀] = p.θ[:T_amb] 
        soly_3 = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 3
        p.bounds.V_max = 4.2
        # GITT: 20 1C pulses followed by 2 hour rests
        @time for i in 1:20
            simulate!(soly_3, p, 720, I=-0.25)
            simulate!(soly_3, p, 3600,  I=:rest)
        end

        V_baseline_3 = soly_3.V
        T_prime_3 = plot(soly_3, :V, title = "GITT")
        Time_3 = soly_3.t
        Current_3 = soly_3.I


        T5 = scatter(title="Average Sensitivty $name GITT")
        T6 = scatter(title="Delta Sensitivty $name GITT")

        @show return1 = focus

        Sens_GITT = Float64[]
        Delta_V_GITT = Vector[]
        Voltage_GITT = Vector[]

         # Dependency for GITT
        @time for i in lb:step:ub
            p.θ[:l_p] = i
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

        @show return1 = focus

    #save plots
    png(T1,"Average Sensitivty $name HPPC 5C")
    png(T2,"Delta Sensitivty $name HPPC 5C")
    png(T3,"Average Sensitivty $name HPPC")
    png(T4,"Delta Sensitivty $name HPPC")
    png(T5,"Average Sensitivty $name GITT")
    png(T6,"Delta Sensitivty $name GITT")
    png(Vx1,"Voltage $name HPPC 5C")
    png(Vx3,"Voltage $name HPPC")
    png(Vx5,"Voltage $name GITT")
    png(Vx2,"Delta Voltage $name HPPC 5C")
    png(Vx4,"Delta Voltage $name HPPC")
    png(Vx6,"Delta Voltage $name GITT")

