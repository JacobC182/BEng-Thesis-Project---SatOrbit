//----------------------------------------------------------------------------------------//
Read-me file for the MATLAB Orbit Propagator - Jacob Currie - 2021

This software was developed as part of a dissertation for partial fulfillment of an
honours degree at the University of Strathclyde. The final Dissertation detailing the
in-depth development of the dynamical model used, as well as the possibilities of
simulation, and detailed postprocessed results examples, is also included.

//----------------------------------------------------------------------------------------//
-Description-
This project encompasses an orbit propagation software system, capable of simulating the
orbit of space debris, satellites, or any other hypothetical body, around Earth, in a
geocentric reference frame.

The model propagates orbits using the MATLAB numerical integration function ODE113,
allowing for settings adjustments to be made following the MATLAB documentation for the
ODE113 integator function.

-Requirements-
This model is implemented in MATLAB R2020b and requires this software or a newer version
to run.

This software also makes use of and requires the following optional MATLAB Add-On's:
1. Aerospace Toolbox
2. AerospaceBlockset
3. Aerospace Blockset CubeSat Simulation Library
4.Parallel Computing Toolbox

For very large and long simulations a very large amount of computing power is
recommended, otherwise the computation time will be very long.

The total file size may also grow very large when computing a large amount of orbits
the precision of the saved output can be adjusted to reduce file size, detailed below.

-Model Capabilities-
The dynamical model used to compute orbits around earth is capable of accounting for
the most significant sources of orbital perturbation, present in the real orbital space
around earth. Included are the following:
1.The Earth's oblateness (causes orbital precession)
2.Lunar Gravity
3.Solar Gravity
4.Direct Solar Radiation Pressure (Simplified)

The properties of the satellite can be adjusted to simulate different sizes of solar
radiation contact area. This is done by adjusting its area to mass ratio value.

-Files Included-
Main.m - This is the MAIN script that is used to run the software and compute orbits!
			Use this file to start simulating orbits for different configurations.
				
					//This, along with the looping variant "MainLoop" should
					//be all you need to propagate orbits with this software.

SatODE.m - This is the dynamical model that allows for computation, it contains the
			equations that allow for the propagation of orbits, this file wont
			need any adjustment.
			
MainLoop.m - While the Main.m allows simulation of a single orbit, this allows for the
			simulation of a range of orbits as a batch, however this requires a large
			amount of computing power, this script utilises multiple CPU cores to
			distribute the load and speed up computation time, a fast, high core-count
			CPU will help with this.
			
StopEvent.m - This is a stop condition function for the software, allowing for the
			simulation to be terminated if the satellite satisfies a certain condition.
			EG. if the satellite leaves earths orbit or performs re-entry.
			
SaveOrbitData.m - This function handles the file saving of the model, does not require
			and alteration.
			
The functions and files written to aid in testing and
validation of the model and creation of the project,
and to create the postprocessed results similar to those
shown in the dissertation paper, are not included.

-Outputs-
The software outputs the results in the form of a numbered, delimited text file
accompanied by a matching metadata file containing the initial conditions and settings
of the model.

The output results are an array of the position and velocity value of the satellite, at
very small discrete time intervals, which can be used to describe the satellites orbital
state at any time inside the simulation time.

-Inputs/Configuration-

All inputs and simulation controls are configured inside the Main.m or MainLoop.m scripts.
all values (input and output) are with respect to a geocentric reference frame.

The initial conditions of the simulated object, can be defined either with traditional
XYZ coordinates, or using the Keplerian system of orbital elements.

The Simulation Start and End time can be set here also.

The perturbing influences offered by the model can be switched on and off here,
(Oblateness, Sun/Moon Gravity, Solar Radiation)

If using the MainLoop.m function to simulate many orbits at once, the range of initial
conditions, as well as the resolution of the discrete gaps between the range of conditions
can be configured here.

To compute results and the run a simulation, configure the Main/Mainloop script as desired
and use the MATLAB "Run" button, if using the MainLoop script, allow for the startup of
the MATLAB parallel pool, configure your parallel pool settings
following MATLAB's documentaton.