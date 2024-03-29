using Optim

function f(x::Vector)
    return (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
end

function g!(x::Vector, storage::Vector)
    storage[1] = -2.0 * (1.0 - x[1]) - 400.0 * (x[2] - x[1]^2) * x[1]
    storage[2] = 200.0 * (x[2] - x[1]^2)
end

function h!(x::Vector, storage::Matrix)
    storage[1, 1] = 2.0 - 400.0 * x[2] + 1200.0 * x[1]^2
    storage[1, 2] = -400.0 * x[1]
    storage[2, 1] = -400.0 * x[1]
    storage[2, 2] = 200.0
end


function fg!(x::Vector, storage)
    d1 = (1.0 - x[1])
    d2 = (x[2] - x[1]^2)
    storage[1] = -2.0 * d1 - 400.0 * d2 * x[1]
    storage[2] = 200.0 * d2
    return d1^2 + 100.0 * d2^2
end

using TimerOutputs
const to = TimerOutput()
    
f(x) = @timeit to "objective_function" f(x::V)

begin
reset_timer!(to)
@timeit to "Trust Region" begin
    result = optimize(objective_function,[0.0, 0.0],Optim.Options(show_trace = true, time_limit = 10))
end
show(to; allocations = false)
end

@elapsed res = optimize(f, g!, [0.0, 0.0], ParticleSwarm(),Optim.Options(show_trace = true, time_limit = 10))

Optim.minimizer(res)     

Optim.minimum(res)
