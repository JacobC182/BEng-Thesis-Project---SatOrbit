function SaveOrbitData(TimeArray,OrbitArray,Setting,Elements)
%Function that takes orbit propagator results, initial conditions and
%parameters, and saves to a convenient file for later analysis
%--------------------------------------------------------------------------
%Splitting up Solver Results
%using n to only carry forward every 8th state vector for saving
n = floor(linspace(1,size(TimeArray,1),size(TimeArray,1)/100));
TimeArray = TimeArray(n,1);
PositionX = OrbitArray(n,4);
PositionY = OrbitArray(n,5);
PositionZ = OrbitArray(n,6);
VelocityX = OrbitArray(n,1);
VelocityY = OrbitArray(n,2);
VelocityZ = OrbitArray(n,3);
%TimeArray = [TimeArray(1),TimeArray(end)];
%Splitting up Orbital Elements
SemiAxis = Elements(1);
Eccentricity = Elements(2);
Inclination = Elements(3);
RAAN = Elements(4);
ArgumentPeriapsis = Elements(5);
TrueAnomaly = Elements(6);
%Splitting up Simulation Settings
SRPEnabled = Setting(1);
OblatenessEnabled = Setting(2);
SunGravityEnabled = Setting(3);
MoonGravityEnabled = Setting(4);
SRPAreaMassRatio = Setting(5);
%Creating Tables
DataTable = table(TimeArray, PositionX, PositionY, PositionZ, VelocityX, VelocityY, VelocityZ);
SettingTable = table(SRPEnabled, OblatenessEnabled, SunGravityEnabled, MoonGravityEnabled, SRPAreaMassRatio);
ElementTable = table(SemiAxis, Eccentricity, Inclination, RAAN, ArgumentPeriapsis, TrueAnomaly);
%This code checks for existing filenames so as to not overwrite data
UniqueFound = 0;
FileNo = 1;
while UniqueFound == 0
    if isfile(['OrbitData' num2str(FileNo) '.txt'])
        FileNo = FileNo + 1;
    else
        UniqueFound = 1;
    end
end
%Creates next Unique Filename, files are saved as "OrbitDataX"
%X is an integer = 1, increasing until a unique filename is found
FileName = ['OrbitData' num2str(FileNo) '.txt'];
MetaFileName = ['OrbitMetaData' num2str(FileNo) '.txt'];
SettingFileName = ['SettingsData' num2str(FileNo) '.txt'];
%Save Initial conditions to file, creating file
writetable(ElementTable, MetaFileName);
%Save Model Settings to file, creating file
writetable(SettingTable, SettingFileName);
%Save Solver results to file, creating file
writetable(DataTable, FileName);
end