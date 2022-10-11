function [num_BP,latitude_BP,longitude_BP] = get_BP(fname)
%given json file
%return:
% Total number of Boundary points
% Parse individual data of Boundary Points

%Get json data into matlab 
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

% Total number of Boundary points 
num_BP = size(val.flyZones.boundaryPoints);


% Getting just the Boundary Points
for i = 1:num_BP(1)
Boundary_Points(i) = val.flyZones.boundaryPoints(i);
end

% Parse individual data of Boundary Points
% Order of Boundary Points is the order in the array 
% latitude 
latitude_BP = parse_data(num_BP,Boundary_Points,'latitude');
% longitude
longitude_BP = parse_data(num_BP,Boundary_Points,'longitude');

end 