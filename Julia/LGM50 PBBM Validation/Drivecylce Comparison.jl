using CSV, DataFrames, LinearAlgebra, Plots, Statistics

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

    GITT1 = plot(Adjusted_Time_GITT,Voltage_GITT, label = "GITT Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "GITT Comparsion from HVES to PETLION in Voltage")
    
    # PETLION Baseline of LGM50 Chen2020
    plot!(GITT1,Time_3,V_baseline_3, label = "PETLION Measured Voltage")
    
    GITT2 = plot(Adjusted_Time_GITT,C_rate_GITT, label = "GITT Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "GITT Comparsion from HVES to PETLION in C-rate")
    
    #PETLION Baseline of LGM50 Chen2020
    plot!(GITT2, Time_3,soly_3.I, label = "PETLION Measured C-rate")




#HPPC
df_HPPC = CSV.read("Julia/LGM50 PBBM Validation/210209_LGM50_HPPC_1C_25C_Channel_3_Wb_1.CSV", DataFrame)



    df_HPPC = filter([:Step_Index] => (Step_Index) -> Step_Index > 8.9 && Step_Index < 19,df_HPPC)


    data_HPPC = Base.Matrix(df_HPPC)

    #Preallocate Data Frames for data_HPPC

    Test_time = data_HPPC[:,3]
    Start_Test = minimum(Test_time)
    Finish_Test = maximum(Test_time)


    Adjusted_Time_HPPC = Test_time - Vector{Float64}(Start_Test*ones(length(Test_time)))


    Step_time = data_HPPC[:,4]
    Cycle_Index = data_HPPC[:,5]
    Step_Index = data_HPPC[:,6]
    Current_HPPC = Vector{Float64}(data_HPPC[:,10])
    Voltage_HPPC = data_HPPC[:,11]
    C_rate_HPPC = Current_HPPC ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    HPPC1 = plot(Adjusted_Time_HPPC,Voltage_HPPC, label = "HPPC Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "HPPC Comparsion from HVES to PETLION in Voltage")

    # PETLION Baseline of LGM50 Chen2020
    plot!(HPPC1,Time_2,V_baseline_2, label = "PETLION Measured Voltage")

    HPPC2 = plot(Adjusted_Time_HPPC,C_rate_HPPC, label = "HPPC Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "HPPC Comparsion from HVES to PETLION in C-rate")

    #PETLION Baseline of LGM50 Chen2020
    plot!(HPPC2, Time_2,soly_2.I, label = "PETLION Measured C-rate")
    
    
    

    # Stat
    

#WLTP
df_WLTP = CSV.read("Julia/LGM50 PBBM Validation/210224_LGM50_WLTP3B_25c_Channel_2_Wb_1.CSV", DataFrame)


    df_WLTP = filter([:Step_Index] => (Step_Index) -> Step_Index > 8.9 && Step_Index < 10.1,df_WLTP)


    data_WLTP = Base.Matrix(df_WLTP)

    #Preallocate Data Frames for data_WLTP

    Test_time = data_WLTP[:,3]
    Start_Test = minimum(Test_time)
    Finish_Test = maximum(Test_time)


    Adjusted_Time_WLTP = Test_time - Vector{Float64}(Start_Test*ones(length(Test_time)))


    Step_time = data_WLTP[:,4]
    Cycle_Index = data_WLTP[:,5]
    Step_Index = data_WLTP[:,6]
    Current_WLTP = Vector{Float64}(data_WLTP[:,9])
    Voltage_WLTP = data_WLTP[:,10]
    C_rate_WLTP = Current_WLTP ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    WLTP1 = plot(Adjusted_Time_WLTP,Voltage_WLTP, label = "WLTP Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "WLTP Comparsion from HVES to PETLION in Voltage")

    # PETLION Baseline of LGM50 Chen2020
    plot!(WLTP1,Time_4,V_baseline_4, label = "PETLION Measured Voltage")

    WLTP2 = plot(Adjusted_Time_WLTP,C_rate_WLTP, label = "WLTP Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "WLTP Comparsion from HVES to PETLION in C-rate")

    #PETLION Baseline of LGM50 Chen2020
    plot!(WLTP2, Time_4,Current_4, label = "PETLION Measured C-rate")
