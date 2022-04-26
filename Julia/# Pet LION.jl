using PETLION
p = petlion(LCO)

sol = simulate(p, I=2, SOC=0, V_max=4.1)
simulate!(sol, p, 1800, V=:hold, I_min=1/20)