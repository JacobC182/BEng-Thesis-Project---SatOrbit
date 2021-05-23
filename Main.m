%Orbit Propagator - 4th Year Project - Jacob Currie
%--------------------------------------------------------------------------
%INPUTS
%Start & End Date of Propogator
StartDate = juliandate(1964,1,1);       %FORMAT = (YEAR,MONTH,DAY)
EndDate = juliandate(1964,1,6);         %FORMAT = (YEAR,MONTH,DAY)
%--------------------------------------------------------------------------
%INITIAL CONDITIONS
%Inital Orbital Elements for Orbit Model 
semiaxis = 10085.44e3;          %Semi-major Axis                (metres)
ecc = 0.025422;                  %Eccentricity
incl = 88.3924;                  %Orbit Inclination              (degrees)
raan = 45.38124;                  %Right Angle of Ascending Node  (degrees)
argp = 227.493;                  %Argument of Periapsis          (degrees)
nu = 343.4268;                    %Periapsis to Position Angle    (degrees)
%--------------------------------------------------------------------------
%Options for Orbit Model
EnableSRP = 1;                  %Enable Direct SRP Perturbation
EnableOblateness = 1;           %Enable J2 Oblateness Perturbation
EnableSunGravity  = 1;          %Enable Solar Gravity Perturbation
EnableMoonGravity = 1;          %Enable Lunar Gravity Perturbation
SRPAreaMassRatio = 1;           %Set Area/Mass Ratio for SRP (A/m2)
%--------------------------------------------------------------------------
%Timespan for integrator (seconds)
Tspan = [StartDate.*86400 EndDate.*86400];  
%convert orbital elements to cartesian state vector
[rS, vS] = keplerian2ijk(semiaxis,ecc,incl,raan,argp,nu);
rS = rS.*(10^-3);   %positon vector m to km
vS = vS.*(10^-3);   %velocity vector m/s to km/s
%Initial position and velocity state vector
Y0 = [vS(1) vS(2) vS(3) rS(1) rS(2) rS(3)];
%Setting ODE solver options and tolerances + Stop condition (StopEvent.m)
options = odeset('RelTol',1e-11,'AbsTol',1e-11,'Stats','on','Events',@StopEvent);
%Solver Settings
Setting = [EnableSRP, EnableOblateness, EnableSunGravity, EnableMoonGravity,SRPAreaMassRatio];
%Compile Element Array for Data Save
Elements = [semiaxis,ecc,incl,raan,argp,nu];
%--------------------------------------------------------------------------
%ODE113 Integrator
[T,Y,~,~] = ode113(@(t,x) SatODEJ2(t,x,Setting), Tspan, Y0, options);
%--------------------------------------------------------------------------
%Saving Orbit Data
SaveOrbitData(T,Y,Setting,Elements);