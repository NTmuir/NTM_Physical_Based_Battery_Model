using CSV, DataFrames, LinearAlgebra, Plots

# Extracting data for GITT

df_GITT = CSV.read("Julia/LGM50 PBBM Validation/210129_LGM50_GITT_Channel_3_Wb_1.CSV", DataFrame)

function GITT_Grab(df_GITT, Time_3,V_baseline_3,Current_3)


    df_GITT = filter([:Step_Index] => (Step_Index) -> Step_Index > 5 && Step_Index < 9,df)


    data_GITT = Base.Matrix(df_GITT)

    #Preallocate Data Frames for data_GITT

    Test_time = data_GITT[:,3]
    Start_Test = minimum(Test_time)
    Finish_Test = maximum(Test_time)
    
    
    Adjusted_Time = Test_time - Vector{Float64}(Start_Test*ones(length(Test_time)))
    
    
    Step_time = data_GITT[:,4]
    Cycle_Index = data_GITT[:,5]
    Step_Index = data_GITT[:,6]
    Current = Vector{Float64}(data_GITT[:,7])
    Voltage = data_GITT[:,8]
    C_rate = Current ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    GITT1 = plot(Adjusted_Time,Voltage, label = "GITT Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "GITT Comparsion from HVES to PETLION in Voltage")
    
    # PETLION Baseline of LGM50 Chen2020
    plot!(GITT1,Time_3,V_baseline_3, label = "PETLION Measured Voltage")
    
    GITT2 = plot(Adjusted_Time,C_rate, label = "GITT Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "GITT Comparsion from HVES to PETLION in C-rate")
    
    #PETLION Baseline of LGM50 Chen2020
    plot!(GITT2, Time_3,soly_3.I, label = "PETLION Measured C-rate")

    return GITT1, GITT2
end

df_HPPC = CSV.read("Julia/LGM50 PBBM Validation/210209_LGM50_HPPC_1C_25C_Channel_3_Wb_1.CSV", DataFrame)

function HPPC_grab(df_HPPC, Time_2,V_baseline_2,Current_2)
    df_HPPC = filter([:Step_Index] => (Step_Index) -> Step_Index > 8.9 && Step_Index < 19,df_HPPC)


    data_HPPC = Base.Matrix(df_HPPC)

    #Preallocate Data Frames for data_HPPC

    Test_time = data_HPPC[:,3]
    Start_Test = minimum(Test_time)
    Finish_Test = maximum(Test_time)


    Adjusted_Time = Test_time - Vector{Float64}(Start_Test*ones(length(Test_time)))


    Step_time = data_HPPC[:,4]
    Cycle_Index = data_HPPC[:,5]
    Step_Index = data_HPPC[:,6]
    Current = Vector{Float64}(data_HPPC[:,10])
    Voltage = data_HPPC[:,11]
    C_rate = Current ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    HPPC1 = plot(Adjusted_Time,Voltage, label = "HPPC Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "HPPC Comparsion from HVES to PETLION in Voltage")

    # PETLION Baseline of LGM50 Chen2020
    plot!(HPPC1,Time_2,V_baseline_2, label = "PETLION Measured Voltage")

    HPPC2 = plot(Adjusted_Time,C_rate, label = "HPPC Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "HPPC Comparsion from HVES to PETLION in C-rate")

    #PETLION Baseline of LGM50 Chen2020
    plot!(HPPC2, Time_2,soly_2.I, label = "PETLION Measured C-rate")
    
    return HPPC1, HPPC2
end
