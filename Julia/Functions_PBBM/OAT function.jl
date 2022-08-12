using PETLION

function OAT(case)
    if case == p.θ[:l_p] #l_p
        focus = p.θ[:l_p]
        lb = 35e-5
        step = 1e-5
        ub = 79e-5
        name = "l_p"
    elseif case == p.θ[:ϵ_p] #ϵ_p
        focus = p.θ[:ϵ_p]
        lb = 0.3
        step = 0.01
        ub = 0.5
        name = "ϵ_p"
    elseif case == p.θ[:l_n] #l_n
        focus = p.θ[:l_n]
        lb = 6e-5
        step = 1e-5
        ub = 20e-5
        name = "l_n"
    elseif case == p.θ[:k_n] #k_n
        focus = p.θ[:k_n]
        lb = 1e-11
        step =1e-11
        ub = 20e-11
        name = "k_n"
    elseif case == p.θ[:c_max_p]  #c_max_p   
        focus = p.θ[c_max_p]
        lb = 4.8e4
        step = 1e3
        ub = 5.2e4
        name = "c_max_p"
    else case == p.θ[:ϵ_n] #   
        focus = p.θ[:ϵ_n]
        lb = 0.3
        step = 0.01
        ub = 0.5 
        name = "ϵ_n"
    end   
return focus, lb, step, ub, name
end




