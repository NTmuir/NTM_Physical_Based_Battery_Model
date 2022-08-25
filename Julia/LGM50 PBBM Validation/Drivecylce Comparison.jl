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

    CSV.write("Julia/LGM50 PBBM Validation/CSV Exports/GITT.csv",df_final_GITT)


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

    #Data conditioning 

    Smooth_time_PETLION_HPPC = round.(Time_2)
    Smooth_time_HVES_HPPC = round.(Adjusted_Time_HPPC)
    
    #Fill arrays with NaN to post process

    Array_Adjust = zeros(length(Adjusted_Time_HPPC)-length(Time_2))
    Array_Adjust_NAN = fill!(Array_Adjust,1e11)
    PETLION_Time_HPPC = append!(Smooth_time_PETLION_HPPC ,Array_Adjust_NAN)
    PETLION_Voltage_HPPC = append!(V_baseline_2 ,Array_Adjust_NAN)
    df_final_HPPC_1 = DataFrame(Adjusted_Time_HPPC = Smooth_time_HVES_HPPC,Voltage_HPPC = Voltage_HPPC)
    df_final_HPPC_2 = DataFrame(Adjusted_Time_HPPC=Smooth_time_PETLION_HPPC,PETLION_Voltage = V_baseline_2)

    df_final_HPPC = dropmissing(leftjoin(df_final_HPPC_1,df_final_HPPC_2, on= :Adjusted_Time_HPPC))

    plot(df_final_HPPC.Adjusted_Time_HPPC,df_final_HPPC.Voltage_HPPC)
    plot!(df_final_HPPC.Adjusted_Time_HPPC,df_final_HPPC.PETLION_Voltage)


    CSV.write("Julia/LGM50 PBBM Validation/CSV Exports/HPPC.csv",df_final_HPPC)
    
    

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
    Voltage_WLTP = Vector{Float64}(data_WLTP[:,10])
    C_rate_WLTP = Current_WLTP ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    WLTP1 = plot(Adjusted_Time_WLTP,Voltage_WLTP, label = "WLTP Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "WLTP Comparsion from HVES to PETLION in Voltage")

    # PETLION Baseline of LGM50 Chen2020
    plot!(WLTP1,Time_4,V_baseline_4, label = "PETLION Measured Voltage")

    WLTP2 = plot(Adjusted_Time_WLTP,C_rate_WLTP, label = "WLTP Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "WLTP Comparsion from HVES to PETLION in C-rate")

    #PETLION Baseline of LGM50 Chen2020
    plot!(WLTP2, Time_4,Current_4, label = "PETLION Measured C-rate")

    #Data Conditioning 

    Smooth_time_PETLION_WLTP = round.(Time_4)
    Smooth_time_HVES_WLTP = round.(Adjusted_Time_WLTP)
    
    #Fill arrays with NaN to post process

    Array_Adjust = zeros(abs(length(Adjusted_Time_WLTP)-length(Time_4)))
    Array_Adjust_NAN = fill!(Array_Adjust,1e11)
    HVES_Time_WLTP = append!(Smooth_time_HVES_WLTP ,Array_Adjust_NAN) #HVES is smaller than PETLION
    HVES_Voltage_WLTP = append!(Voltage_WLTP,Array_Adjust_NAN)
    df_final_WLTP_1 = DataFrame(Adjusted_Time_WLTP = Smooth_time_HVES_WLTP,Voltage_WLTP = HVES_Voltage_WLTP)
    df_final_WLTP_2 = DataFrame(Adjusted_Time_WLTP =Smooth_time_PETLION_WLTP,PETLION_Voltage = V_baseline_4)

    df_final_WLTP = dropmissing(leftjoin(df_final_WLTP_1,df_final_WLTP_2, on= :Adjusted_Time_WLTP))

    plot(df_final_WLTP.Adjusted_Time_WLTP,df_final_WLTP.Voltage_WLTP)
    plot!(df_final_WLTP.Adjusted_Time_WLTP,df_final_WLTP.PETLION_Voltage)


    CSV.write("Julia/LGM50 PBBM Validation/CSV Exports/WLTP.csv",df_final_WLTP)

    #CC-CV

    df_CCCV = CSV.read("Julia/LGM50 PBBM Validation/201204-LGM50-Conditioning-Charge+Discharge_Cycle2_Channel_1_Wb_1.CSV", DataFrame)


    df_CCCV = filter([:Step_Index] => (Step_Index) -> Step_Index > 5.9 && Step_Index < 7.1,df_CCCV)


    data_CCCV = Base.Matrix(df_CCCV)

    #Preallocate Data Frames for data_CCCV

    Test_time = data_CCCV[:,3]
    Start_Test = minimum(Test_time)
    Finish_Test = maximum(Test_time)


    Adjusted_Time_CCCV = Test_time - Vector{Float64}(Start_Test*ones(length(Test_time)))


    Step_time = data_CCCV[:,4]
    Cycle_Index = data_CCCV[:,5]
    Step_Index = data_CCCV[:,6]
    Current_CCCV = Vector{Float64}(data_CCCV[:,7])
    Voltage_CCCV = Vector{Float64}(data_CCCV[:,8])
    C_rate_CCCV = Current_CCCV ./ 5 #~5Ah for LGM50

    #Comparison Plot of LGM50 Vs PETLION

    CCCV1 = plot(Adjusted_Time_CCCV,Voltage_CCCV, label = "CCCV Measured Voltage",xlabel = "Time (s)",ylabel = "Voltage (V)",title = "CCCV Comparsion from HVES to PETLION in Voltage")

    # PETLION Baseline of LGM50 Chen2020
    plot!(CCCV1,Time_5,V_baseline_5, label = "PETLION Measured Voltage")

    CCCV2 = plot(Adjusted_Time_CCCV,C_rate_CCCV, label = "CCCV Measured C-rate",xlabel = "Time (s)",ylabel = "C-rate",title = "CCCV Comparsion from HVES to PETLION in C-rate")

    #PETLION Baseline of LGM50 Chen2020
    plot!(CCCV2, Time_5,Current_5, label = "PETLION Measured C-rate")

    #Data Conditioning 

    Smooth_time_PETLION_CCCV = round.(Time_5)
    Smooth_time_HVES_CCCV = round.(Adjusted_Time_CCCV)
    
    #Fill arrays with NaN to post process

    Array_Adjust = zeros(abs(length(Adjusted_Time_CCCV)-length(Time_5)))
    Array_Adjust_NAN = fill!(Array_Adjust,1e11)
    HVES_Time_CCCV = append!(Smooth_time_HVES_CCCV ,Array_Adjust_NAN) #HVES is smaller than PETLION
    HVES_Voltage_CCCV = append!(Voltage_CCCV,Array_Adjust_NAN)
    df_final_CCCV_1 = DataFrame(Adjusted_Time_CCCV = Smooth_time_HVES_CCCV,Voltage_CCCV = HVES_Voltage_CCCV)
    df_final_CCCV_2 = DataFrame(Adjusted_Time_CCCV =Smooth_time_PETLION_CCCV,PETLION_Voltage = V_baseline_5)

    df_final_CCCV = dropmissing(leftjoin(df_final_CCCV_1,df_final_CCCV_2, on= :Adjusted_Time_CCCV))

    plot(df_final_CCCV.Adjusted_Time_CCCV,df_final_CCCV.Voltage_CCCV)
    plot!(df_final_CCCV.Adjusted_Time_CCCV,df_final_CCCV.PETLION_Voltage)


    CSV.write("Julia/LGM50 PBBM Validation/CSV Exports/CCCV.csv",df_final_CCCV)


