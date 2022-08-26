using PETLION, Plots, Statistics, DataFrames

p = petlion(Chen2020;
N_p = 10, # discretizations in the cathode
N_s = 10, # discretizations in the separator
N_n = 10, # discretizations in the anode
N_r_p = 10, # discretizations in the solid cathode particles
N_r_n = 10, # discretizations in the solid anode particles
temperature = false, # temperature enabled or disabled
jacobian = :symbolic, # :AD (automatic-differenation) for convenience or :symbolic for speed
)

        # Load the solution structure with an initial SOC of 1
        soly = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 2.5
        p.bounds.V_max = 4.2

        ## Baseline
        p.θ[:T₀] = p.θ[:T_amb] 
        # HPPC: 20 5C pulses followed by 1 hour rests
        @time for i in 1:9
            simulate!(soly, p, 10, I=-3) #Pulse Discharge
            simulate!(soly, p, 40, I=:rest) #Relax
            simulate!(soly, p, 10, I=3) #Pulse Charge
            simulate!(soly, p, 300, I=-1) #To remove 10% SOC
            simulate!(soly, p, 3600, I=:rest) #Hour Rest
        end

        V_baseline_1 = soly.V
        T_prime_1 = plot(soly, :V ,title = "HPPC Aggressive")
        Time_1 = soly.t
        Current_1 = soly.I

        
        #Baseline at Higher C
        soly_2 = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 2.5
        p.bounds.V_max = 4.2

        p.θ[:T₀] = p.θ[:T_amb] 
        # HPPC: 20 5C pulses followed by 1 hour rests
        @time for i in 1:20
            simulate!(soly_2, p, 10, I=-0.96) #Pulse Discharge
            simulate!(soly_2, p, 40, I=:rest) #Relax
            simulate!(soly_2, p, 10, I=0.72) #Pulse Charge
            simulate!(soly_2, p, 820, I=-0.2) #To remove 10% SOC
            simulate!(soly_2, p, 3600,  I=:rest) #Hour Rest
        end

        V_baseline_2 = soly_2.V
        T_prime_2 = plot(soly_2, :V, title = "HPPC HVES Baseline")
        Time_2 = soly_2.t
        Current_2 = soly_2.I
       

        
        #Baseline GITT
        p.θ[:T₀] = p.θ[:T_amb] 
        soly_3 = solution()
        p.opts.outputs = (:t, :V, :I)
        p.opts.SOC = 1
        p.bounds.V_min = 2.5
        p.bounds.V_max = 4.2
        # GITT: 20 1C pulses followed by 2 hour rests
        @time for i in 1:20
            simulate!(soly_3, p, 720, I=-0.25)
            simulate!(soly_3, p, 4*3600,  I=:rest)
        end

        V_baseline_3 = soly_3.V
        T_prime_3 = plot(soly_3, :V, title = "GITT")
        Time_3 = soly_3.t
        Current_3 = soly_3.I


        #Baseline WLTP
         p.θ[:T₀] = p.θ[:T_amb] 
        soly_4 = solution()
        p.opts.outputs = (:t, :V, :I)
            p.opts.SOC = 1
            p.bounds.V_min = 2.5
          p.bounds.V_max = 4.2
          for j in 1:length(Adjusted_Time_WLTP)
              @time simulate!(soly_4,p,0.5,I =C_rate_WLTP[j])
           end
            V_baseline_4 = soly_4.V
           T_prime_4 = plot(soly_4,:V, title = "WLTP Baseline")
            Time_4 = soly_4.t
            Current_4 = soly_4.I  

        #Standard CC-CV 
        p.θ[:T₀] = p.θ[:T_amb] 
        soly_5 = solution()
        p.opts.SOC = 1
        p.bounds.V_min = 2.5
        p.opts.outputs = (:t, :V, :I)
        for j in 1:length(Adjusted_Time_CCCV)
            @time simulate!(soly_5,p,1,I=C_rate_CCCV[j])
            println(j)
         end
        V_baseline_5 = soly_5.V
        T_prime_5 = plot(soly_5,:V, title = "WLTP Baseline")
        Time_5 = soly_5.t
        Current_5 = soly_5.I  
        