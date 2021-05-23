function ODE = SatODEJ2(t,x,Setting)
%Function defining Satellite motion ODE's
%ODE's define rate of change of position and velocity of the satellite
%--------------------------------------------------------------------------
%Defining Notation
%t = Current integrator timestep
%x(1) = velSATx
%x(2) = velSATy
%x(3) = velSATz
%x(4) = posSATx
%x(5) = posSATy
%x(6) = posSATz
%--------------------------------------------------------------------------
%Defining universal constants
mE = 5.9724.*(10.^24);    %Earth mass KG
mS = 1988500.*(10.^24);   %Sun mass KG
mM = 0.07346.*(10.^24);   %Moon mass KG
G = (6.67430.*(10.^-20));   %Gravitational Constant (km3)
u = G.*mE;                  %u = GM
J2 = 0.00108263;            %J2 Coefficient
R = 6378.137;               %Equatorial Earth Radius (km)
%--------------------------------------------------------------------------
%Ephemeris Data
T = ((t./86400) - 2451545) ./ 36525;
%Moon
%Almanac Coefficients
a = [0, 6.29, -1.27, 0.66, 0.21, -0.19, -0.11];
b = [218.32, 135, 259.3, 235.7, 269.9, 357.5, 106.5];
c = [481267.881, 477198.87, -413335.36, 890534.22, 954397.74, 35999.05, 966404.03];
d = [0, 5.13, 0.28, -0.28, -0.17, 0, 0];
e = [0, 93.3, 220.2, 318.3,  217.6, 0, 0];
f  =[0, 483202.03, 960400.89, 6003.15, -407332.21, 0, 0];
g = [0.9508, 0.0518, 0.0095, 0.0078, 0.0028, 0, 0];
h = [0, 135, 259.3, 253.7, 269.9, 0, 0];
k = [0, 477198.87, -413335.38, 890534.22, 954397.70, 0, 0];
%Lunar ecliptic Longitude
eLon = b(1) + c(1).*T + a(2).*sind(b(2)+c(2).*T) + a(3).*sind(b(3)+c(3).*T) + a(4).*sind(b(4)+c(4).*T) + a(5).*sind(b(5)+c(5).*T) + a(6).*sind(b(6)+c(6).*T) + a(7).*sind(b(7)+c(7).*T);
eLon = mod(eLon,360);
%Lunar ecliptic Latitude
eLat = d(2).*sind(e(2) + f(2).*T) + d(3).*sind(e(3) + f(3).*T) + d(4).*sind(e(4) + f(4).*T) + d(5).*sind(e(5) + f(5).*T);
eLat = mod(eLat,360);
%Obliquity to Ecliptic plane
eps = 23.439 - 0.00130042.*T;
%Horizontal Parallax
HP = g(1) + g(2).*cosd(h(2)+k(2).*T) + g(3).*cosd(h(3)+k(3).*T) + g(4).*cosd(h(4)+k(4).*T) + g(5).*cosd(h(5)+k(5).*T);
HP = mod(HP,360);
%Moon distance from Earth (magnitude)
MoonPos = R./sind(HP);
%Position of moon relative to earth in geocentric frame
Pmoon = [cosd(eLat).*cosd(eLon);
        cosd(eps).*cosd(eLat).*sind(eLon) - sind(eps).*sind(eLat);
        sind(eps).*cosd(eLat).*sind(eLon) + cosd(eps).*sind(eLat)];
RealMoonPos = MoonPos.*Pmoon;
%Sun
n = T.*36525;
%Mean Solar Longitude
SunLon = mod((280.459 + 0.98564736.*n),360);
%Mean Solar Anomaly
SunAno = mod((357.529 + 0.98560023.*n),360);
%Apparent Solar ecliptic Longitude
SunEcl = mod(( SunLon + 1.915.*sind(SunAno) + 0.02.*sind(2.*SunAno)),360 );
%Solar obliquity
SunObl = 23.439 - (3.56.*10.^-7).*n;
%Distance from Sun to Earth
SunPos = (1.00014 - 0.01671.*cosd(SunAno) - 0.00014.*cosd(2.*SunAno)).*149597870.691; %Convert from AU to km
%Position of Sun relative to earth in geocentric frame
Psun = [cosd(SunEcl)
        sind(SunEcl).*cosd(SunObl)
        sind(SunEcl).*sind(SunObl)];
%--------------------------------------------------------------------------
%SRP Algorithim - [Direct Cannonball Approximation Used]
RealSunPos = SunPos.*Psun;

a = (x(4)-RealSunPos(1)).^2 + (x(5)-RealSunPos(2)).^2 + (x(6)-RealSunPos(3)).^2;
b = 2 .* ( (x(4)-RealSunPos(1)).*RealSunPos(1) + (x(5)-RealSunPos(2)).*RealSunPos(2) + (x(6)-RealSunPos(3)).*RealSunPos(3) );
c = RealSunPos(1).^2 + RealSunPos(2).^2 + RealSunPos(3).^2 - R.^2;

D = (b.^2) - 4 .* a .* c;

if D < 0
    Shadow = 1;
else
    Shadow = 0;
end
%constants
Sconstant = 1367; %solar constant (w/m2)
Lc = 299792000; %speed of light (m/s)
%parameters
AMratio = Setting(5);     %Area-to-Mass Ratio (specific to satellite)
Crf = 2;            %Coefficient of reflectivity
%SRP unit direction vector
dSRP = (x(4:6) - RealSunPos)./(norm(x(4:6) - RealSunPos));
%SRP resulting acceleration formula (Magnitude)
SRP = (Shadow).*(Sconstant./Lc) .* Crf .* AMratio;
SRP = (SRP./1e3).*dSRP;
%--------------------------------------------------------------------------
%Calculating radius/distance (magnitude of state vector)
r = norm(x(4:6));
%Unit state vector
rd = ( x(4:6) )./r;
%Calculating position from Satellite to Sun
SunSatPos = -(x(4:6) - RealSunPos);
MoonSatPos = -(x(4:6) - RealMoonPos);

aEarth = -G.*(mE./(r.^2)).*rd;      %Acceleration due to spherical Earth

%Acceleration due to Sun
aSun = (-G.*mS).*( (SunSatPos./((sqrt(sum(SunSatPos.^2))).^3)) - (RealSunPos./(SunPos.^3)) );

%Acceleration due to Moon
aMoon = (-G.*mM) .* ( (MoonSatPos./(sqrt(sum(MoonSatPos.^2))).^3) - (RealMoonPos./MoonPos.^3) );

%J2 Perturbing Acceleration
aJ2 = (3/2).*( (J2.*u.*(R.^2))./(r.^4) ).*[(x(4)./r).*((5.*(x(6).^2)./(r.^2))-1);
                                            (x(5)./r).*((5.*(x(6).^2)./(r.^2))-1);
                                            (x(6)./r).*((5.*(x(6).^2)./(r.^2))-3)];
%Return ODE
ODE = [(aEarth + aJ2.*Setting(2) + aSun.*Setting(3) + aMoon.*Setting(4) + SRP.*Setting(1) );
        x(1:3)];
end