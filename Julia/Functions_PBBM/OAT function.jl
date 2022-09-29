module Search

    function OAT(case)

        if case == 1 #l_p
            variable = p.θ[:l_p]
            lb = 6e-5
            step = 1e-6
            ub = 10e-5
            name = "l_p"
            unit = "(m)"
            rand = 9.1e-5
        elseif case == 2 #ϵ_p
            variable = p.θ[:ϵ_p]
            lb = 0.3
            step = 0.001
            ub = 0.5
            name = "ϵ_p"
            unit = "(dimensionless)"
            rand = 0.421
        elseif case == 3 #l_n
            variable = p.θ[:l_n]
            lb = 6e-5
            step = 1e-6
            ub = 10e-5
            name = "l_n"
            unit = "(m)"
            rand = 7e-5
        elseif case == 4 #k_n
            variable = p.θ[:k_n]
            lb = 2.5e-11
            step =1e-12
            ub = 10e-11
            name = "k_n"
            unit = "(m^2.5 mol^ s)"
            rand = 3e-11
        elseif case ==5  #c_max_p   
            variable = p.θ[:c_max_p]
            lb = 4.8e4
            step = 10
            ub = 5.2e4
            name = "c_max_p"
            unit = "(mol m^-3)"
            rand = 48741
        elseif case == 6 # ϵ_n  
            variable = p.θ[:ϵ_n]
            lb = 0.2
            step = 0.001
            ub = 0.4 
            name = "ϵ_n"
            unit = "(dimensionless)"
            rand = 0.37
        elseif case == 7 #T₀
            variable = p.θ[:T₀]
            lb = 233.15
            step = 1
            ub = 328.15
            name = "Temperature"
            unit = "(K)"
        else case == 8 #T₀
            variable = p.θ[:T_amb]
            lb = 233.15
            step = 10
            ub = 328.15
            name = "Ambient Temperature"
            unit = "(K)"
    end     
    return variable, lb, step, ub, name, unit,rand
    end
end




