%Orbit Propagator - 4th Year Project - Jacob Currie
%--------------------------------------------------------------------------
%INPUTS
%Start & End Date of Propogator
StartDate = juliandate(2021,1,1);       %FORMAT = (YEAR,MONTH,DAY)
EndDate = juliandate(2021,1,8);         %FORMAT = (YEAR,MONTH,DAY)
%--------------------------------------------------------------------------
%Inital Orbital Elements for Orbit Model 
semiaxis = linspace(25000e3,30000e3,11);          %Semi-major Axis  (metres)
ecc = linspace(0,0.6,11);                           %Eccentricity
ecc(1) = 0.001;                                 %LOWEST VALUE OF ECCENTRICITY (CANNOT BE ZERO!) (USE 0.0001 or other)
incl = linspace(55,65,6);                      %Orbit Inclination  (degrees)
nu = 0;                                         %Argument of Periapsis (Degrees)
raan = linspace(0,90,2);                    %Right angle of Ascending node (degrees
argp = linspace(0,90,2);                    %Argument of perigee (degrees)
%--------------------------------------------------------------------------
%Options for Orbit Model
EnableSRP = 1;                  %Enable Direct SRP Perturbation
EnableOblateness = 1;           %Enable J2 Oblateness Perturbation
EnableSunGravity  = 1;          %Enable Solar Gravity Perturbation
EnableMoonGravity = 1;          %Enable Lunar Gravity Perturbation
SRPAreaMassRatio = 1;           %Set Area/Mass Ratio for SRP (m2/kg)
%--------------------------------------------------------------------------
%Timespan for integrator (seconds)
Tspan = [StartDate.*86400 EndDate.*86400];  

%Setting ODE solver options and tolerances + Stop condition (StopEvent.m)
options = odeset('RelTol',1e-11,'AbsTol',1e-11,'Stats','on','Events',@StopEvent);
%Solver Settings
Setting = [EnableSRP, EnableOblateness, EnableSunGravity, EnableMoonGravity,SRPAreaMassRatio];

parfor eccLoop = 1:length(ecc)
    for axisLoop = 1:length(semiaxis)
        for incLoop = 1:length(incl)
            for raanLoop = 1:length(raan)
                for argpLoop = 1:length(argp)
                    for nuLoop = 1:length(nu)
                        %Compile Element Array for Data Save
                        Elements = [semiaxis(axisLoop),ecc(eccLoop),incl(incLoop),raan(raanLoop),argp(argpLoop),nu(nuLoop)];
                        %convert orbital elements to cartesian state vector
                        [rS, vS] = keplerian2ijk(semiaxis(axisLoop),ecc(eccLoop),incl(incLoop),raan(raanLoop),argp(argpLoop),nu(nuLoop));
                        rS = rS.*(10^-3);   %positon vector m to km
                        vS = vS.*(10^-3);   %velocity vector m/s to km/s
                        %Initial position and velocity state vector
                        Y0 = [vS(1) vS(2) vS(3) rS(1) rS(2) rS(3)];
%--------------------------------------------------------------------------
                    %ODE113 Integrator
                        [T,Y,~,~] = ode113(@(t,x) SatODEJ2(t,x,Setting), Tspan, Y0, options);
%--------------------------------------------------------------------------
                    %Save orbit Data to file
                        SaveOrbitData(T,Y,Setting,Elements);
                    end
                end
            end
        end
    end
end