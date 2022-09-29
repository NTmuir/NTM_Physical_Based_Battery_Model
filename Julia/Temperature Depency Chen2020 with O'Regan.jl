using PETLION, Plots, Statistics

@time p = petlion(LCO;
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

