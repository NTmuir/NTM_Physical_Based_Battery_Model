using CSV, DataFrames, LinearAlgebra, Plots

# Extracting data for GITT

df = CSV.read(

data_GITT = Base.Matrix(df)