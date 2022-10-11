function [num_WP,latitude_WP,longitude_WP,altitude] = get_WP(fname)
%given json file
%return:
% Total number of Waypoints
% Parse individual data of Waypoints

%Get json data into matlab 
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

% Total number of waypoints
num_WP = size(val.waypoints);


% Getting just the waypoints
for i = 1:num_WP(1)
Waypoints(i) = val.waypoints(i);
end

% Parse individual data of waypoints
% Order of waypoints is the order in the array 
% latitude 
latitude_WP = parse_data(num_WP(1),Waypoints,'latitude');
% longitude
longitude_WP = parse_data(num_WP(1),Waypoints,'longitude');
% altitude
altitude = parse_data(num_WP(1),Waypoints,'altitude');

end 