function [x,y] = GPS2MAP(long,lat)
%given GPS cord:long and lat, convert to MAP Matrix
%return MAP Matrix Points: X and Y

%Get json data into matlab
fname = 'test.json';
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

% Total number of Boundary points
num_BP = size(val.flyZones.boundaryPoints);

% Getting just the Obstacles
for i = 1:num_BP(1)
    Boundary_Points(i) = val.flyZones.boundaryPoints(i);
end

% Parse individual data of BP
% In Order of BP is the order in the array
% latitude
latitude = parse_data(num_BP,Boundary_Points,'latitude');

% longitude
longitude = parse_data(num_BP,Boundary_Points,'longitude');

GPS(:,1) = latitude;
GPS(:,2) = longitude;

%Longitude and Latitude Max and Mins of BP
Lat_min = min(latitude);
Lat_max = max(latitude);
Long_min = min(longitude);
Long_max = max(longitude);

%Scaling Factor
Scale_Factor_X = 100000;
Scale_Factor_Y = 100000;

%convert GPS Cord to MAP matrix points
%One is added because MATLAB indexes at 1, not Zero!!!

y = floor((round((lat - Lat_min),5)*Scale_Factor_Y))+1; %change in 1 is 1.1 m
x = floor((round((long - Long_min),5)*Scale_Factor_X))+1; %change in 1 is 1.1 m

end