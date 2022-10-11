function [num_obs,latitude_obs,longitude_obs,radius_obs,height] = get_obs(fname)
%given json file
%return:
% Total number of Obstacles
% Parse individual data of Obstacles

%Get json data into matlab 
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

% Total number of obstacles
num_obs = size(val.stationaryObstacles);


% Getting just the Obstacles
for i = 1:num_obs(1)
Obstacles(i) = val.stationaryObstacles(i);
end

% Parse individual data of obstacles
% Order of obstacles is the order in the array 
% latitude 
latitude_obs = parse_data(num_obs,Obstacles,'latitude');
% longitude
longitude_obs = parse_data(num_obs,Obstacles,'longitude');
% radius
radius_obs = parse_data(num_obs,Obstacles,'radius'); %radius is in feet, MAP is in meters 
% height
height = parse_data(num_obs,Obstacles,'height'); %height in meters?? 


end 