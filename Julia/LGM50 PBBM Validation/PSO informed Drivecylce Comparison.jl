using CSV, DataFrames, LinearAlgebra, Plots, Statistics


    p.θ[:l_p] = 6.81538073229544e-5
    p.θ[:ϵ_p] = 0.33499104045541106
    p.θ[:l_n] = 8.519809670083905e-5
    p.θ[:k_n] = 2.0e-10
    p.θ[:c_max_p] = 51762.642078427125
    p.θ[:ϵ_n] = 0.2500172374812859


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

# Extracting data for GITT
df_GITT = CSV.read("Julia/LGM50 PBBM Validation/210129_LGM50_GITT_Channel_3_Wb_1.CSV", DataFrame)




    df_GITT = filter([:Step_Index] => (Step_Index) -> Step_Index > 5 && Step_Index < 9,df_GITT)


    data_GITT = Base.Matrix(df_GITT)

    #Preallocate Data Frames for data_GITT

    Test_time = data_GITT[:,3]
    Start_Test = minimum(Test_time)
    Finish_Test = maximum(Test_time)
    
    
    Adjusted_Time_GITT = Test_time - Vector{Float64}(Start_Test*ones(length(Test_time)))
    
    
    Step_time = data_GITT[:,4]
    Cycle_Index = data_GITT[:,5]
    Step_Index = data_GITT[:,6]
    Current_GITT = Vector{Float64}(data_GITT[:,7])
    Voltage_GITT = Vector{Float64}(data_GITT[:,8])
    C_rate_GITT = Current_GITT ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    GITT1 = plot(Adjusted_Time_GITT,Voltage_GITT, label = "GITT Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "GITT Comparsion from HVES to PSO in Voltage")
    
    # PETLION Baseline of LGM50 Chen2020
    plot!(GITT1,Time_3,V_baseline_3, label = "PSO estimated Voltage")
    
    GITT2 = plot(Adjusted_Time_GITT,C_rate_GITT, label = "GITT Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "GITT Comparsion from HVES to PETLION in C-rate")
    
    #PETLION Baseline of LGM50 Chen2020
    plot!(GITT2, Time_3,soly_3.I, label = "PETLION Measured C-rate")

    #Data conditioning 

    Smooth_time_PETLION_GITT = round.(Time_3)
    Smooth_time_HVES_GITT = round.(Adjusted_Time_GITT)
    
    #Fill arrays with NaN to post process

    Array_Adjust = zeros(length(Adjusted_Time_GITT)-length(Time_3))
    Array_Adjust_NAN = fill!(Array_Adjust,1e11)
    PETLION_Time_GITT = append!(Smooth_time_PETLION_GITT ,Array_Adjust_NAN)
    PETLION_Voltage_GITT = append!(V_baseline_3 ,Array_Adjust_NAN)
    df_final_GITT_1 = DataFrame(Adjusted_Time_GITT = Smooth_time_HVES_GITT,Voltage_GITT = Voltage_GITT)
    df_final_GITT_2 = DataFrame(Adjusted_Time_GITT =Smooth_time_PETLION_GITT,PETLION_Voltage = V_baseline_3)

    df_final_GITT = dropmissing(leftjoin(df_final_GITT_1,df_final_GITT_2, on= :Adjusted_Time_GITT))

    plot(df_final_GITT.Adjusted_Time_GITT,df_final_GITT.Voltage_GITT)
    plot!(df_final_GITT.Adjusted_Time_GITT,df_final_GITT.PETLION_Voltage)

    data_RMSE = Base.Matrix(df_final_GITT)

    Delta_V = data_RMSE[:,2] - data_RMSE[:,3]

    RMSE =  sqrt(mean((Delta_V.^2)))

    CSV.write("Julia/LGM50 PBBM Validation/CSV Exports/GITT_PSO.csv",df_final_GITT)


#HPPC


