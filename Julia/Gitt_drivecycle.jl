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

# Load the solution structure with an initial SOC of 0
sol = solution()
p.opts.outputs = (:t, :V, :I)
p.opts.SOC = 0


# Baseline
p.θ[:T₀] = p.θ[:T_amb] 
# GITT: 20 1C pulses followed by 2 hour rests
@time for i in 1:20
    simulate!(sol, p, 3600/20, I=1)
    simulate!(sol, p, 2*3600,  I=:rest)
end

V_baseline = sol.V
T_prime = plot(sol, :V)


T = scatter(title="Average Sensistivty Temperature")
T1 = scatter(title="Delta Sensistivty Temperature")

return1 = p.θ[:T₀]

# Temperature dependency
for i in 233.15:0.1:373.15
    p.θ[:T₀] = i
    temp = round(i - 273.15)
    @time for i in 1:20
        simulate!(sol1, p, 3600/20, I=1)
        simulate!(sol1, p, 2*3600,  I=:rest)
    end
    Delta_V1 = V_baseline - resize!(sol1.V,length(V_baseline))
    Sens_Av1 = mean((Delta_V1/V_baseline).*100)
    Sens_max1 = maximum((Delta_V1/V_baseline).*100)
    Sens_min1 = minimum((Delta_V1/V_baseline).*100)
    Variation1 = Sens_max1 - Sens_min1
    scatter!(T,(temp,Sens_Av1),xlabel = "Temperature (degC)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T1,(temp,Variation1),xlabel = "Temperature (degC)",ylabel = "Average Variation (%)", legend = false)
end 

p.θ[:T₀] = return1