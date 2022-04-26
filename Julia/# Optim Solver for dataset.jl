# Optim Solver for dataset
using Pkg

Pkg.add("Optim")

using PyBaMM

using Optim

include("D:\\5 Masters\\ENGR7019\\Git\\Physical_Based_Battery_Model\\# Importing CSV data into Julia.jl")

ParticleSwarm(Inf,Inf,3)