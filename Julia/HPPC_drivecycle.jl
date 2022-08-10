using PETLION, Plots, Statistics, DataFrames

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

# Load the solution structure with an initial SOC of 1
soly6 = solution()
p.opts.outputs = (:t, :V, :I)
p.opts.SOC = 1
p.bounds.V_min = 3

## Baseline
p.θ[:T₀] = p.θ[:T_amb] 
# HPPC: 9 5C pulses followed by 1 hour rests
@time for i in 1:10
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
Tx4 = scatter(title="RMSE D_s")
return1 = p.θ[:D_s]

Data1 = Float64[]
Data2 = Vector[]
Data3 = Vector[]
Soc = Vector[]
RMSE = Vector[]

return1 = p.θ[:D_s]

# Dependency
for i in 1e-10:1e-11:10e-10
    @time p.θ[:D_s] = i
    for k in 1:length(i)
       sol = "Sol_$k "
       print(sol) 
       sol = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 3
        for j in 1:10
            simulate!(sol, p, 10, I=-5) #Pulse Discharge
            simulate!(sol, p, 40, I=:rest) #Relax
            simulate!(sol, p, 10, I=5) #Pulse Charge
            simulate!(sol, p, 300, I=-1) #To remove 10% SOC
            simulate!(sol, p, 3600,  I=:rest) #Hour Rest
        end
        Delta_V1 = V_baseline - resize!(sol.V,length(V_baseline))
         if maximum(sol.V) > 5
            Delta_V1 = zeros(length(V_baseline))
            print(i)
        end
        Sens_Av1 = mean((Delta_V1/V_baseline).*100)
    Sens_max1 = maximum((Delta_V1/V_baseline).*100)
    Sens_min1 = minimum((Delta_V1/V_baseline).*100)
    Variation1 = Sens_max1 - Sens_min1
    scatter!(Tx2,(i,Sens_Av1),xlabel = "m^2s^-1",ylabel = "Average Variation (%)",  legend = false)
    scatter!(Tx3,(i,Variation1),xlabel = "m^2s^-1",ylabel = "Delta Variation (%)", legend = false)
    push!(Data1,Sens_Av1)
    push!(Data2,Delta_V1 )
    push!(Data3,resize!(sol.V,length(V_baseline)))
    end
end

# Post Plots for sweeps

Vx1 = plot(soly6.t,Data3)
ylims!(3,4.2)
xlims!(0, 32000)
Vx2 = plot(soly6.t,Data2, legend = false)
ylims!(-0.2,0.2)
xlims!(0, 32000)

#RMSE calculation

p.θ[:D_s] = return1

T2 = scatter(title="Average Sensistivty l_p")
T3 = scatter(title="Delta Sensistivty l_p")

return2 = p.θ[:l_p]

# Cathode thickness
for i in 35e-5:1e-6:79e-5
    @time p.θ[:l_p] = i
    for k in 1:length(i)
        sol = "Sol_$k "
        print(sol) 
        sol = solution()
         p.opts.outputs = (:t, :V, :I)
         p.opts.SOC = 1
         p.bounds.V_min = 3
         for j in 1:10
             simulate!(sol, p, 10, I=-5) #Pulse Discharge
             simulate!(sol, p, 40, I=:rest) #Relax
             simulate!(sol, p, 10, I=5) #Pulse Charge
             simulate!(sol, p, 300, I=-1) #To remove 10% SOC
             simulate!(sol, p, 3600,  I=:rest) #Hour Rest
         end
         Delta_V2 = V_baseline - resize!(sol.V,length(V_baseline))
          if maximum(sol.V) > 5
             Delta_V2 = zeros(length(V_baseline))
             print(i)
         end
        Sens_Av2 = mean((Delta_V2/V_baseline).*100)
    Sens_max2 = maximum((Delta_V2/V_baseline).*100)
    Sens_min2 = minimum((Delta_V2/V_baseline).*100)
    Variation2 = Sens_max2 - Sens_min2
    scatter!(T2,(i,Sens_Av2),xlabel = "thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T3,(i,Variation2),xlabel = "thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    end
end 

p.θ[:l_p] = return2

T4 = scatter(title="Average Sensistivty ϵ_p")
T5 = scatter(title="Delta Sensistivty ϵ_p")

return3 = p.θ[:ϵ_p]

#Cathode Active Material Volume
for i in 0.35:0.001:0.5
    @time p.θ[:ϵ_p] = i
    for k in 1:length(i)
        sol = "Sol_$k "
        print(sol) 
        sol = solution()
         p.opts.outputs = (:t, :V, :I)
         p.opts.SOC = 1
         p.bounds.V_min = 3
         for j in 1:10
             simulate!(sol, p, 10, I=-5) #Pulse Discharge
             simulate!(sol, p, 40, I=:rest) #Relax
             simulate!(sol, p, 10, I=5) #Pulse Charge
             simulate!(sol, p, 300, I=-1) #To remove 10% SOC
             simulate!(sol, p, 3600,  I=:rest) #Hour Rest
         end
         Delta_V3 = V_baseline - resize!(sol.V,length(V_baseline))
          if maximum(sol.V) > 5
             Delta_V3 = zeros(length(V_baseline))
             print(i)
         end
    Sens_Av3 = mean((Delta_V3/V_baseline).*100)
    Sens_max3 = maximum((Delta_V3/V_baseline).*100)
    Sens_min3 = minimum((Delta_V3/V_baseline).*100)
    Variation3 = Sens_max3 - Sens_min3
    scatter!(T4,(i,Sens_Av3),xlabel = "Dimensionless",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T5,(i,Variation3),xlabel = "Dimensionless",ylabel = "Average Variation (%)",  legend = false)
    end 
end

p.θ[:ϵ_p] = return3

T6 = scatter(title="Average Sensistivty l_n")
T7 = scatter(title="Delta Sensistivty l_n")

return4 = p.θ[:l_n]

#Anode thickness
for i in 6e-5:1e-6:20e-5
    @time p.θ[:l_n] = i
    for k in 1:length(i)
        sol = "Sol_$k "
        print(sol) 
        sol = solution()
         p.opts.outputs = (:t, :V, :I)
         p.opts.SOC = 1
         p.bounds.V_min = 3
         for j in 1:10
             simulate!(sol, p, 10, I=-5) #Pulse Discharge
             simulate!(sol, p, 40, I=:rest) #Relax
             simulate!(sol, p, 10, I=5) #Pulse Charge
             simulate!(sol, p, 300, I=-1) #To remove 10% SOC
             simulate!(sol, p, 3600,  I=:rest) #Hour Rest
         end
         Delta_V4 = V_baseline - resize!(sol.V,length(V_baseline))
          if maximum(sol.V) > 5
             Delta_V4 = zeros(length(V_baseline))
             print(i)
         end
    Sens_Av4 = mean((Delta_V4/V_baseline).*100)
    Sens_max4 = maximum((Delta_V4/V_baseline).*100)
    Sens_min4 = minimum((Delta_V4/V_baseline).*100)
    Variation4 = Sens_max4 - Sens_min4
    scatter!(T6,(i,Sens_Av4),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T7,(i,Variation4),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    end
end 

p.θ[:l_n] = return4

T8 = scatter(title="Average Sensistivty k_n")
T9 = scatter(title="Delta Sensistivty k_n")

return5 = p.θ[:k_n]

#Anode reaction rate
for i in 1e-11:1e-12:20e-11
    @time p.θ[:k_n] = i
    for k in 1:length(i)
        sol = "Sol_$k "
        print(sol) 
        sol = solution()
         p.opts.outputs = (:t, :V, :I)
         p.opts.SOC = 1
         p.bounds.V_min = 3
         for j in 1:10
             simulate!(sol, p, 10, I=-5) #Pulse Discharge
             simulate!(sol, p, 40, I=:rest) #Relax
             simulate!(sol, p, 10, I=5) #Pulse Charge
             simulate!(sol, p, 300, I=-1) #To remove 10% SOC
             simulate!(sol, p, 3600,  I=:rest) #Hour Rest
         end
         Delta_V5 = V_baseline - resize!(sol.V,length(V_baseline))
          if maximum(sol.V) > 5
             Delta_V5 = zeros(length(V_baseline))
             print(i)
         end
    Sens_Av5 = mean((Delta_V5/V_baseline).*100)
    Sens_max5 = maximum((Delta_V5/V_baseline).*100)
    Sens_min5 = minimum((Delta_V5/V_baseline).*100)
    Variation5 = Sens_max5 - Sens_min5
    scatter!(T8,(i,Sens_Av5),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    scatter!(T9,(i,Variation5),xlabel = "Thickness (um)",ylabel = "Average Variation (%)",  legend = false)
    end
end 

p.θ[:k_n] = return5

