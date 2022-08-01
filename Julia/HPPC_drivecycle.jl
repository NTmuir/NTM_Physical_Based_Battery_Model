using PETLION, Plots, Statistics, DataFrames

@time p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = true, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

# Load the solution structure with an initial SOC of 1
soly6 = solution()
p.opts.outputs = (:t, :V, :I)
p.opts.SOC = 1


# Baseline
p.θ[:T₀] = p.θ[:T_amb] 
# HPPC: 9 5C pulses followed by 1 hour rests
@time for i in 1:9
    simulate!(soly6, p, 10, I=-5) #Pulse Discharge
    simulate!(soly6, p, 40, I=:rest) #Relax
    simulate!(soly6, p, 10, I=5) #Pulse Charge
    simulate!(soly6, p, 300, I=-1) #To remove 10% SOC
    simulate!(soly6, p, 3600,  I=:rest) #Hour Rest
end

V_baseline = soly6.V
T_prime = plot(soly6, :V)


Tx2 = scatter(title="Average Sensitivty D_s")
Tx3 = scatter(title="Delta Sensitivty D_s")

return1 = p.θ[:D_s]

Data1 = Float64[]
Data2 = Vector[]
Data3 = Vector[]
# Dependency
for i in 1e-10:1e-11:10e-10
    @time p.θ[:D_s] = i;
    for k in 1:length(i)
       sol = "Sol_$k "
       print(sol) 
       sol = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        @time for j in 1:9
            simulate!(sol, p, 10, I=-5) #Pulse Discharge
            simulate!(sol, p, 40, I=:rest) #Relax
            simulate!(sol, p, 10, I=5) #Pulse Charge
            simulate!(sol, p, 300, I=-1) #To remove 10% SOC
            simulate!(sol, p, 3600,  I=:rest) #Hour Rest
        end
        Delta_V1 = V_baseline - resize!(sol.V,length(V_baseline))
    Sens_Av1 = mean((Delta_V1/V_baseline).*100)
    Sens_max1 = maximum((Delta_V1/V_baseline).*100)
    Sens_min1 = minimum((Delta_V1/V_baseline).*100)
    Variation1 = Sens_max1 - Sens_min1
    scatter!(Tx2,(i,Sens_Av1),xlabel = "m^2s^-1",ylabel = "Average Variation (%)",  legend = false)
    scatter!(Tx3,(i,Variation1),xlabel = "m^2s^-1",ylabel = "Delta Variation (%)", legend = false)
    push!(Data1,Sens_Av1)
    push!(Data2,Delta_V1 )
    push!(Data3,sol.V)
    print(i) 
    end
end 

Vx1 = plot(soly6.t,Data3,legend = false)
ylims!(3,4.2)
xlims!(0, 32000)
Vx2 = plot(soly6.t,Data2,legend = false)
ylims!(-0.2,0.2)
xlims!(0, 32000)
p.θ[:D_s] = return1