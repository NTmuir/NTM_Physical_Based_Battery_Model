using PETLION, Plots, Statistics, DataFrames, ProgressBars

println("Starting PETLION")

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

println("Starting Baseline")


println("Baseline complete")


case = 4

            println("Case $case starting")

                focus = OAT(case)[1]
                lb = OAT(case)[2]
                step = OAT(case)[3]
                ub = OAT(case)[4]
                name = OAT(case)[5]
                unit = OAT(case)[6]

                OAT_Array = lb:step:ub
            

            T5 = scatter(title="Average Sensitivty $name GITT")
            T6 = scatter(title="Delta Sensitivty $name GITT")


            Sens_GITT = Float64[]
            Delta_V_GITT = Vector[]
            Voltage_GITT = Vector[]
            RMSE_GITT = Float64[]

            return1 = focus

            # Dependency for GITT
            @time for i in ProgressBar(lb:step:ub)
                itr = 1
                    while itr <= length(i)
                    p.θ[:k_n] = i
                    for k in 1:length(i)
                    sol = "Sol_$k "
                    sol = solution()
                    @time Delta_V = GITT(itr,sol,p,V_baseline_3)[1]
                        #Sens_Av = GITT(itr,sol,p,V_baseline_3)[2]
                        #Variation = GITT(itr,sol,p,V_baseline_3)[3]
                        RMSE = GITT(itr,sol,p,V_baseline_3)[4]
                        #scatter!(T5,(i,Sens_Av),xlabel = "$name $unit", ylabel = "Average Variation (%)",  legend = false)
                        #scatter!(T6,(i,Variation),xlabel = "$name $unit",ylabel = "Delta Variation (%)", legend = false)
                        #push!(Sens_GITT ,Sens_Av)
                        push!(RMSE_GITT,RMSE)
                        push!(Delta_V_GITT,Delta_V)
                        push!(Voltage_GITT,resize!(sol.V,length(V_baseline_3)))
                        itr += 1
                    end
                
                end
            end

            Vx5 = plot(Time_3,Voltage_GITT, legend = false, ylabel = "Voltage (V)", xlabel = "Time (s)", title = "GITT OAT Voltage $name")
            ylims!(3,4.2)
            xlims!(0, maximum(Time_3))
            Vx6 = plot(Time_3,Delta_V_GITT, legend = false, ylabel = "Delta Voltage (V)", xlabel = "Time (s)", title = "GITT OAT Delta Voltage $name")
            ylims!(-0.25,0.25)
            xlims!(0, maximum(Time_3))
            RMSE3 = scatter(OAT_Array,(RMSE_GITT).*1000, legend = false,ylabel = "RMSE Voltage (mV)", xlabel = "$name $unit", title = "GITT OAT RMSE Voltage $name")
            RMSE3 = vline!([focus])
            print("case $name completed GITT")

            @show focus = return1

        #save plots
        png(T5,"Average Sensitivty $name GITT")
        png(T6,"Delta Sensitivty $name GITT")
        png(Vx5,"Voltage $name GITT")
        png(Vx6,"Delta Voltage $name GITT")
        png(RMSE3,"RMSE $name GITT")

        p = petlion(Chen2020;
                    N_p = 10, # discretizations in the cathode
                    N_s = 10, # discretizations in the separator
                    N_n = 10, # discretizations in the anode
                    N_r_p = 10, # discretizations in the solid cathode particles
                    N_r_n = 10, # discretizations in the solid anode particles
                    temperature = false, # temperature enabled or disabled
                    jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
                                )

        T3 = scatter(title="Average Sensitivty $name HPPC")
        T4 = scatter(title="Delta Sensitivty $name HPPC")
        
        Sens_HPPC = Float64[]
        Delta_V_HPPC = Vector[]
        Voltage_HPPC = Vector[]
        RMSE_HPPC = Float64[]

         #HVES HPPC
        @time for i in ProgressBar(lb:step:ub)
            itr = 1
                while itr <= length(i)
                p.θ[:k_n] = i
                for k in 1:length(i)
                sol = "Sol_$k "
                sol = solution()
                @time Delta_V = HPPC_HVES(itr,sol,p,V_baseline_2)[1]
                    #Sens_Av = HPPC_HVES(itr,sol,p,V_baseline_2)[2]
                    #Variation = HPPC_HVES(itr,sol,p,V_baseline_2)[3]
                    RMSE = HPPC_HVES(itr,sol,p,V_baseline_2)[4]
                    # scatter!(T3,(i,Sens_Av),xlabel = "$name $unit", ylabel = "Average Variation (%)",  legend = false)
                    # scatter!(T4,(i,Variation),xlabel = "$name $unit",ylabel = "Delta Variation (%)", legend = false)
                    #push!(Sens_HPPC,Sens_Av)
                    push!(RMSE_HPPC,RMSE)
                    push!(Delta_V_HPPC,Delta_V )
                    push!(Voltage_HPPC,resize!(sol.V,length(V_baseline_2)))
                    itr += 1
                   
            end
        end
    end

        Vx3 = plot(Time_2,Voltage_HPPC,legend = false, ylabel = "Voltage (V)", xlabel = "Time (s)", title = "HPPC HVES OAT Voltage $name")
        ylims!(3,4.2)

        Vx4 = plot(Time_2,Delta_V_HPPC,legend = false, ylabel = "Delta Voltage (V)", xlabel = "Time (s)", title = "HPPC HVES OAT Delta Voltage $name")
        ylims!(-0.25,0.25)

        RMSE2 = scatter(OAT_Array,(RMSE_HPPC).*1000, legend = false,ylabel = "RMSE Voltage (mV)", xlabel = "$name $unit", title = "HPPC HVES OAT RMSE Voltage $name")
        RMSE2 = vline!([focus])

        RMSE_combined = scatter(RMSE3,OAT_Array,(RMSE_HPPC).*1000, legend = false,ylabel = "RMSE Voltage (mV)", xlabel = "$name $unit", title = "HPPC and GITT OAT RMSE Voltage $name")
        png(T4,"Delta Sensitivty $name HPPC")
        png(T3,"Average Sensitivty $name HPPC")
        png(Vx3,"Voltage $name HPPC")
        png(Vx4,"Delta Voltage $name HPPC")
        png(RMSE2,"RMSE $name HPPC")
        png(RMSE_combined, "RMSE $name Combined")



        print("case $name completed HPPC")

        println("Case $case finish")

