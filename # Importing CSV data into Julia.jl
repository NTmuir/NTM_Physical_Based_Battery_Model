# Importing CSV data into Julia 
Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("LinearAlgebra")
Pkg.add("Plots")

using CSV, DataFrames, LinearAlgebra, Pkg , Plots
 


    df = CSV.read("C:\\Users\\muirn\\Documents\\OBR\\Test_Data\\Test Data\\Segment 4\\220303 - Module Testing\\cellvoltages_2022-03-03-15-29-23.csv", DataFrame)


data = Base.Matrix(df)

time_array = 1:length(data[:,1]) 

#Cell_data
    Cell_1 = data[:,63];
    Cell_2 = data[:,64];
    Cell_3 = data[:,65];
    Cell_4 = data[:,66];
    Cell_5 = data[:,67];
    Cell_6 = data[:,68];
    Cell_7 = data[:,69];
    Cell_8 = data[:,70];
    Cell_9 = data[:,71];
    Cell_10 = data[:,72];
    Cell_11 = data[:,73];
    Cell_12 = data[:,74];
    Cell_13 = data[:,75];
    Cell_14 = data[:,76];
    Cell_15 = data[:,77];
    Cell_16 = data[:,78];
    Cell_17 = data[:,79];
    Cell_18 = data[:,80];
    Cell_19 = data[:,81];
    Cell_20 = data[:,82];
    Cell_21 = data[:,83];
    Cell_22 = data[:,84];    
    Cell_23 = data[:,85];
    Cell_24 = data[:,86];

#plotting of cell data

#figure_1
     plot(time_array,Cell_1)
     plot!(time_array,Cell_2)
     plot!(time_array,Cell_3)
     plot!(time_array,Cell_4)
     plot!(time_array,Cell_5)
     plot!(time_array,Cell_6)
     plot!(time_array,Cell_7)
     plot!(time_array,Cell_8)
     plot!(time_array,Cell_9)
     plot!(time_array,Cell_10)
     plot!(time_array,Cell_11)
     plot!(time_array,Cell_12)



     