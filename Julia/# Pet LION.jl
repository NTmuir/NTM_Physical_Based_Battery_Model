using PETLION, Plots
@time p = petlion(LCO;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

for i in 233.15:10:373.15
    p.θ[:T₀] = i
    temp = round(i - 273.15)
    @time sol = simulate(p,1800,I=2,SOC=0,V_max=4.1,outputs=:all)
    plot1 = plot!(sol.t,sol.V; label= ("$temp degC"),title = "Temperature with Terminal Voltage (LCO)", xlabel = "Time(s)", ylabel="Voltage (V)", legend = :topright)
end 
current()