# Physical_Based_Battery_Model
MSc repository for a PSO Optimisation for a DFN model coded in Julia (PETLION.jl x Metaheurtics.jl)

See the running code section about how to run Julia code - Julia 1.6.4 or later required

Thesis is attached [here](https://github.com/NTmuir/NTM_Physical_Based_Battery_Model/blob/main/17053998_Artifically%20Informed%20Data%20Driven%20Physics%20Based%20Battery%20Model%20Parameterisation%20with%20Particle%20Swarm%20Optimisation%20method%20for%20the%20LGM50%20dataset_ENGR7019.pdf)

# Background
This project looks into the data-driven techniques used for improving Physical Battery Models (PBM). Inorder to create a PBM there are 26 parameters which drive the output of terminal voltage for a cell using a DFN model. The cost and time required to obtain these values experimentally is significant and still does come short on truely fitting OCV in high dynamic cases, so being able to optimise these experimentally obtained values can improve the fitness of terminal voltage.

These 26 parameters have different levels of sensitivty for how they impact terminal voltage behaviour, so understanding the strongest parameters to target can help reduce the computational speed to get a high fitting result.

The Particle Swarm Optimisation (PSO) uses artifical lives of a population of particles to hone into the global optimal result for a specified objective function (Voltage RMSE). 

# Methodology
A One at Time (OAT) Sensitivity Analysis was conducted to ensure the 6 strongest parameters to build into the PSO, in where it would prove RMSE is suitable for an optimiser. The overall method for combining the DFN to PSO is presented below:

![image](https://user-images.githubusercontent.com/83457561/193078851-1ab98247-ca2f-4123-8cbb-ebf1ea1043a6.png)

# Results - OAT SI
The RMSE Terminal Voltage for 6 strongest parameters are below which shows good reduced RMSE to Chen2020 Identified Parameters with PETLION 

![image](https://user-images.githubusercontent.com/83457561/193079668-b34700b3-d4f3-4478-966e-d831176ee6ec.png)

Which presented the following rank of Sensitivity Index(SI)

![image](https://user-images.githubusercontent.com/83457561/193080663-7427bd54-905d-446f-b764-7185e69c4b0e.png)

This confirms that Cathode Thickness (Lp) is the most Sensitive to Terminal Voltage Response.

# Results - PSO DFN (Virtual Model Validation)
Running a simulation where it is comparing with a PETLION Baseline of a GITT cycle where it is solely optimising Lp, the PSO can minise RMSE to accurately reproduce the value of Lp without the prior information of the value.  

![anim- l_p convergence](https://user-images.githubusercontent.com/83457561/193082319-eb46452d-946e-41b1-beaa-c4453798516d.gif)


This was repeated on the 6 parameters and shows clearly the PSO can idenitify parameters when doing one parameter at a time with just virtual data.

![image](https://user-images.githubusercontent.com/83457561/193084237-f3dbbe20-3ee3-42ac-b4ce-d7d2b8f8b199.png)

Now the challenge is to do with a data-driven approach!
# Results - PSO DFN (Real Data Validation)
This was fed with the WLTP drive cycle with all 6 parameters as unknowns to show how robust it is at fitting OCV and adapting parameters to achieve this, below shows a comparison of the Chen2020 response to the PSO driven respsonse:

![image](https://user-images.githubusercontent.com/83457561/193083366-2ab0efb3-ecda-4ed0-a529-c63e68b47022.png)

This yielded a 38% improvement in fitness of RMSE voltage which is clearly evident in capturing more of the dynamics! Summarized below is the change in parameter values:

![image](https://user-images.githubusercontent.com/83457561/193083768-0be65a26-8a90-42e7-95b7-aeb3dd61dc2d.png)

# Running Code (Temporary)
Post submission will make a package for all the functions under a new branch!

To obtain the PETLION library of the LGM50
```julia
import Pkg; Pkg.add("https://github.com/NTmuir/PETLION.jl.git")
```
To add the PSO package see [Metaheuristics.jl](https://github.com/jmejia8/Metaheuristics.jl) to add package

Then load the OAT.jl function and Run PSO_tester_PETLION_real_data_WLTP.jl

To see validation data run DriveCycle Comparison.jl

# References 

[PBM tool orgin](https://github.com/MarcBerliner/PETLION.jl)

[PSO tool orgin](https://github.com/jmejia8/Metaheuristics.jl)

