
function OAT(case)

    if case == 1 #l_p
        variable = p.θ[:l_p]
        lb = 35e-5
        step = 1e-5
        ub = 79e-5
        name = "l_p"
        unit = "m"
    elseif case == 2 #ϵ_p
        variable = p.θ[:ϵ_p]
        lb = 0.3
        step = 0.001
        ub = 0.5
        name = "ϵ_p"
        unit = "dimensionless"
    elseif case == 3 #l_n
        variable = p.θ[:l_n]
        lb = 6e-5
        step = 1e-6
        ub = 20e-5
        name = "l_n"
        unit = "m"
    elseif case == 4 #k_n
        variable = p.θ[:k_n]
        lb = 1e-11
        step =1e-12
        ub = 20e-11
        name = "k_n"
        unit = "m^2 s^-1"
    elseif case ==5  #c_max_p   
        variable = p.θ[:c_max_p]
        lb = 4.8e4
        step = 100
        ub = 5.2e4
        name = "c_max_p"
        unit = "mol m^-3"
    else case == 6 #   
        variable = p.θ[:ϵ_n]
        lb = 0.2
        step = 0.001
        ub = 0.5 
        name = "ϵ_n"
        unit = "dimensionless"
    end   
return variable, lb, step, ub, name, unit
end





