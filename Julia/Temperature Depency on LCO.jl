using PETLION, Plots, Statistics

@time p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = true, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

# Baseline
p.θ[:T₀] = p.θ[:T_amb] 
@time sol = simulate(p,1500,I=2,SOC=0,outputs=:all)

V_baseline = sol.V


T = scatter(title="Average Sensistivty Temperature")
T1 = scatter(title="Delta Sensistivty Temperature")

return1 = p.θ[:T₀]

# Temperature dependency
for i in 233.15:0.1:373.15
    p.θ[:T₀] = i
    temp = round(i - 273.15)
    @time sol1 = simulate(p,1500,I=2,SOC=0,outputs=:all)
    Delta_V1 = V_baseline - resize!(sol1.V,length(V_baseline))
    Sens_Av1 = mean((Delta_V1/V_baseline).*100)
    Sens_max1 = maximum((Delta_V1/V_baseline).*100)
    Sens_min1 = minimum((Delta_V1/V_baseline).*100)
    Variation1 = Sens_max1 - Sens_min1
    scatter!(T,(temp,Sens_Av1),xlabel = "Temperature (degC)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T1,(temp,Variation1),xlabel = "Temperature (degC)",ylabel = "Average Variation (%)", legend = false)
end 

p.θ[:T₀] = return1

T2 = scatter(title="Average Sensistivty l_p")
T3 = scatter(title="Delta Sensistivty l_p")

return2 = p.θ[:l_p]

# Cathode thickness
for j in 35e-5:1e-6:79e-5
    p.θ[:l_p] = j
    @time sol2 = simulate(p,1500,I=2,SOC=0,outputs=:all)
    Delta_V2 = V_baseline - resize!(sol2.V,length(V_baseline))
    Sens_Av2 = mean((Delta_V2/V_baseline).*100)
    Sens_max2 = maximum((Delta_V2/V_baseline).*100)
    Sens_min2 = minimum((Delta_V2/V_baseline).*100)
    Variation2 = Sens_max2 - Sens_min2
    scatter!(T2,(j,Sens_Av2),xlabel = "thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T3,(j,Variation2),xlabel = "thickness (um)",ylabel = "Average Variation (%)",  legend = false)
end 

p.θ[:l_p] = return2

T4 = scatter(title="Average Sensistivty ϵ_p")
T5 = scatter(title="Delta Sensistivty ϵ_p")

return3 = p.θ[:ϵ_p]

#Cathode Active Material Volume
for k in 0.35:0.001:0.5
    p.θ[:ϵ_p] = k
    @time sol3 = simulate(p,1500,I=2,SOC=0,outputs=:all)
    Delta_V3 = V_baseline - resize!(sol3.V,length(V_baseline))
    Sens_Av3 = mean((Delta_V3/V_baseline).*100)
    Sens_max3 = maximum((Delta_V3/V_baseline).*100)
    Sens_min3 = minimum((Delta_V3/V_baseline).*100)
    Variation3 = Sens_max3 - Sens_min3
    scatter!(T4,(k,Sens_Av3),xlabel = "Dimensionless",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T5,(k,Variation3),xlabel = "Dimensionless",ylabel = "Average Variation (%)",  legend = false)
end 

p.θ[:ϵ_p] = return3

T006 = scatter(title="Average Sensistivty l_n")
T007 = scatter(title="Delta Sensistivty l_n")

return4 = p.θ[:l_n]

#Anode thickness
for l in 6e-5:1e-6:20e-5
    p.θ[:l_n] = l
    @time sol4 = simulate(p,1500,I=2,SOC=0,outputs=:all)
    Delta_V4 = V_baseline - resize!(sol4.V,length(V_baseline))
    Sens_Av4 = mean((Delta_V4/V_baseline).*100)
    Sens_max4 = maximum((Delta_V4/V_baseline).*100)
    Sens_min4 = minimum((Delta_V4/V_baseline).*100)
    Variation4 = Sens_max4 - Sens_min4
    scatter!(T006,(l,Sens_Av4),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T007,(l,Variation4),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
end 

p.θ[:l_n] = return4

T8 = scatter(title="Average Sensistivty k_n")
T9 = scatter(title="Delta Sensistivty k_n")

return5 = p.θ[:k_n]

#Anode reaction rate
for u in 1e-11:1e-12:20e-11
    p.θ[:k_n] = u
    @time sol5 = simulate(p,1500,I=2,SOC=0,outputs=:all)
    Delta_V5 = V_baseline - resize!(sol5.V,length(V_baseline))
    Sens_Av5 = mean((Delta_V5/V_baseline).*100)
    Sens_max5 = maximum((Delta_V5/V_baseline).*100)
    Sens_min5 = minimum((Delta_V5/V_baseline).*100)
    Variation5 = Sens_max5 - Sens_min5
    scatter!(T8,(u,Sens_Av5),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T9,(u,Variation5),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
end 

p.θ[:k_n] = return5




