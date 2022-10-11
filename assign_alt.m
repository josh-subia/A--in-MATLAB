function [alt] = assign_alt(xWP1,yWP1,xWP2,yWP2,alt1,alt2,reduced)
%given Waypoint 1, Waypoint 2, altitude 1, altitude 2,and Reduced optimal path
%calculate distances for reduced waypoints between WP1 and WP2 
%calculate altitude for each reduced waypoints 
%return altitude for reduced waypoints 

%Calculated Radial distances between waypoint 1 and 2 
dist = distance(xWP1,yWP1,reduced(:,1),reduced(:,2));


%Determines alt = m*dist+b line between two given points
x = [0 dist(length(dist))];
y = [alt1 alt2];
c = [[1; 1]  x(:)]\y(:);                % Calculate Parameter Vector
slope_m = c(2);
intercept_b = c(1);

alt = floor((slope_m.*dist) + intercept_b);
end 