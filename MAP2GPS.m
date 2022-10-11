function [Long,Lat] = MAP2GPS(x,y)
%given MAP Matrix Points: X and Y
%return GPS cord:long and lat

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


%convert MAP Matrix Points back to GPS Cords
%One is subtracted because MATLAB indexes at 1, not Zero!!!

Long = ((x-1)/Scale_Factor_X)+Long_min;
Lat = ((y-1)/Scale_Factor_Y)+Lat_min;

end 