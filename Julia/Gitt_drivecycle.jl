using PETLION, Plots

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :AD, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

# Load the solution structure with an initial SOC of 0
soly1 = solution()
p.opts.outputs = (:t, :V, :I)
p.opts.SOC = 0


# Baseline
p.θ[:T₀] = p.θ[:T_amb] 
# GITT: 20 1C pulses followed by 2 hour rests
@time for i in 1:20
    simulate!(soly1, p, 3600/20, I=1)
    simulate!(soly1, p, 2*3600,  I=:rest)
end

V_baseline = soly1.V
T_prime = plot(soly1, :V)


Tx = scatter(title="Average Sensistivty Temperature")
Tx1 = scatter(title="Delta Sensistivty Temperature")

return1 = p.θ[:D_s]

# Dependency
for i in 1e-10:1e-10:10e-10
    @time p.θ[:D_s] = i;
    for k in 1:length(i)
       sol = "Sol_$k "
       print(sol) 
       sol = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 0
        @time for j in 1:20
        simulate!(sol, p, 3600/20, I=1)
        simulate!(sol, p, 2*3600,  I=:rest)
        end
    Delta_V1 = V_baseline - resize!(sol.V,length(V_baseline))
    Sens_Av1 = mean((Delta_V1/V_baseline).*100)
    Sens_max1 = maximum((Delta_V1/V_baseline).*100)
    Sens_min1 = minimum((Delta_V1/V_baseline).*100)
    Variation1 = Sens_max1 - Sens_min1
    scatter!(Tx,(i,Sens_Av1),xlabel = "Meh",ylabel = "Average Variation (%)",  legend = false)
    scatter!(Tx1,(i,Variation1),xlabel = "Meh",ylabel = "Average Variation (%)", legend = false)
    print(i) 
    end
end 

p.θ[:D_s] = return1

return2 = p.θ[:D_n] 

Tx2 = scatter(title="Average Sensistivty Temperature")
Tx3 = scatter(title="Delta Sensistivty Temperature")

# Dependency
for i in 1e-10:1e-10:10e-10
    @time p.θ[:D_n] = i;
    for k in 1:length(i)
       sol = "Sol1_$k "
       print(sol) 
       sol = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 0
        @time for j in 1:20
        simulate!(sol, p, 3600/20, I=1)
        simulate!(sol, p, 2*3600,  I=:rest)
        end
    Delta_V1 = V_baseline - resize!(sol.V,length(V_baseline))
    Sens_Av1 = mean((Delta_V1/V_baseline).*100)
    Sens_max1 = maximum((Delta_V1/V_baseline).*100)
    Sens_min1 = minimum((Delta_V1/V_baseline).*100)
    Variation1 = Sens_max1 - Sens_min1
    scatter!(Tx2,(i,Sens_Av1),xlabel = "Meh",ylabel = "Average Variation (%)",  legend = false)
    scatter!(Tx3,(i,Variation1),xlabel = "Meh",ylabel = "Average Variation (%)", legend = false)
    print(i) 
    end
end 

p.θ[:D_s] = return2

return3 = p.θ[:D_p] 

Tx4 = scatter(title="Average Sensistivty Temperature")
Tx5 = scatter(title="Delta Sensistivty Temperature")

# Dependency
@time for i in 1e-10:1e-11:10e-10
    @time p.θ[:D_p] = i;
    for k in 1:length(i)
       sol = "Sol2_$k "
       print(sol) 
       sol = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 0
        @time for j in 1:20
        simulate!(sol, p, 3600/20, I=1)
        simulate!(sol, p, 2*3600,  I=:rest)
        end
        Delta_V1 = V_baseline - resize!(sol.V,length(V_baseline))
        Sens_Av1 = mean((Delta_V1/V_baseline).*100)
        Sens_max1 = maximum((Delta_V1/V_baseline).*100)
        Sens_min1 = minimum((Delta_V1/V_baseline).*100)
        Variation1 = Sens_max1 - Sens_min1
        scatter!(Tx4,(i,Sens_Av1),xlabel = "Meh",ylabel = "Average Variation (%)",  legend = false)
        scatter!(Tx5,(i,Variation1),xlabel = "Meh",ylabel = "Average Variation (%)", legend = false)
        print(i) 
    end
end 
current()
p.θ[:D_s] = return3