    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A* ALGORITHM Demo
% Interactive A* search demo
% 04-26-2005
%   Copyright 2009-2010 The MathWorks, Inc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4/18/2020
% New: added do servo command
% Current:
% Test is for a 1417x1143 matrix 
% runs A* in the bounded area with obstacles
% inaccuracies of +/- 1.1m 
% combined all parsing data into a function that only needs the file name
% extracts optimal path using parallel computation 
% Reduce optimal path with reduced jaggity lines 
% Outputs: computation time, a plot of the total path, reduced optimal
% path, and waypoint file for Mission Planner
% Added UGV Drop pos 
% Results: Able to output waypoint file in the correct format
% Next Step: 
% 1. Testing in mission planner 
% 2. Could reduce more WPs 
%% Initialization of MAP Matrix with Boundary Points, Obstacles, and Waypoints
close all; clc;

tStart = tic; % start clock1 to calculate runtime

%Get json data into matlab 
fname = 'test.json'; 

%Given File name 
%Return location of each waypoint, MAP Matrix with obstacles and boundary lines added, and waypoint altitudes    
[MAP,num_WP,x_WP,y_WP,n,m,alt_WP] = parse_all_data(fname);

%EDIT: Sparsed MAP matrix 4/30/2022
%Sparsing the MAP matrix
% whos MAP
MAP=sparse(MAP);
% whos MAP
% %% A* function 
%Given the MAP Matrix and location of first and second point 
%Return optimal path between those two points in the MAP Matrix 


%Initialize 
Optimal_path = cell(1,num_WP(1)-1);
Timer = zeros(1,num_WP(1)-1);

%Initialize Waypoint Variables 
%Starting point
x_WP1 = zeros(1,num_WP(1)-1);
y_WP1 = zeros(1,num_WP(1)-1);
%End point
x_WP2 = zeros(1,num_WP(1)-1);
y_WP2 = zeros(1,num_WP(1)-1);
for i = 1:num_WP(1)-1
x_WP1(i) = x_WP(i);
y_WP1(i) = y_WP(i);
x_WP2(i) = x_WP(i+1);
y_WP2(i) = y_WP(i+1);
end 

%A Star
parfor i = 1:(num_WP(1)-1)
tic;    % start clock2 to calculate runtime
Optimal_path{i} = [x_WP1(i) y_WP1(i); x_WP2(i) y_WP2(i)];
Timer(i) = toc; % end clock2 to calculate runtime
fprintf('Elapsed time from waypoint %d to %d is %8.6f seconds\n',i,i+1,Timer(i));
end 
%% Visualization 
% %Plot the Optimal Path!
 figure(1)
 axis([1 n 1 m])
 grid on;
 hold on;
 ylabel('Latitude')
 xlabel('Longitude')
 
% %Plots visual dots for line boundary and obstacles
 for i = 1:n
     for j = 1:m
         if MAP(i,j) == -1
             plot(i+0.5,j+0.5,'r.'); %plots obstacles and boundary lines
         end
     end
 end
 
% %Visualization of the Optimal Path 
 for i = 1:num_WP(1)-1
      j=size(Optimal_path{1,i},1);
% %Plots starting point
      plot(Optimal_path{1,i}(j,1)+.5,Optimal_path{1,i}(j,2)+.5,'r.');
% %Plots end point
      plot(Optimal_path{1,i}(1,1)+.5,Optimal_path{1,i}(1,2)+.5,'r.');
      plot(Optimal_path{1,i}(:,1)+.5,Optimal_path{1,i}(:,2)+.5);
 end 

%% Reduce Redudant WPs 
Reduced_path = Optimal_path;
% for i = 1:num_WP(1)-1
% Reduced_path{i} = reduce_collinear_points(Optimal_path{1,i}(:,1)',Optimal_path{1,i}(:,2)');
% end 

%% Address Changing Altitudes
alt = cell(1,num_WP(1)-1);
for i = 1:num_WP(1)-1
alt{i} = assign_alt(x_WP1(i),y_WP1(i),x_WP2(i),y_WP2(i),alt_WP(i),alt_WP(i+1),Reduced_path{1,i});
end

%% Format Path for Waypoint file

%Combine all Reduced waypoints and altitudes 
Combined_Reduced = cat(1,Reduced_path{:});
total_num_WP = size(Combined_Reduced);

%Mission Planner reads waypoint files in meters
Combined_alt_ft = cat(1,alt{:});
%Convert ft to m
Combined_alt_m = Combined_alt_ft * 0.3048;


%Initialization 
longitude = zeros(total_num_WP);
latitude = zeros(total_num_WP);

%Convert MAP Matrix cords back to GPS cords
for i = 1:total_num_WP(1)
    [longitude(i), latitude(i)] = MAP2GPS(Combined_Reduced(i,1),Combined_Reduced(i,2));
end 
waypoints = zeros(length(Combined_Reduced),4);
%Orders waypoints into Waypoint file format 
for i = 1:1:total_num_WP(1)
    waypoints(i,:) = [i,latitude(i), longitude(i), Combined_alt_m(i)];
end

%% Servo 
servo_port_number = 3; % Change to the port that the drop box servoe is plugged into 
servo_PWM = 1500; %Choose values between 1000 and 2000 
servo = [total_num_WP(1)+1,servo_port_number,servo_PWM,0,0,0];
    

%% Print Waypoints into waypoint file format 
fileID = fopen('waypoint.waypoints','w');
fprintf(fileID, 'QGC WPL 110\n');
fprintf(fileID, '0 1 0 16 0 0 0 0 38.143181 -76.430619 0.000000 1\n');
fprintf(fileID, '%d 0 3 22 0.00000000 0.00000000 0.00000000 0.00000000 %8.5f %8.5f %f 1\n',waypoints(1,:)'); 
fprintf(fileID, '%d 0 3 16 0.00000000 0.00000000 0.00000000 0.00000000 %8.5f %8.5f %f 1\n',waypoints(2:(total_num_WP(1)-1),:)'); 
fprintf(fileID, '%d 0 3 16 0.00000000 0.00000000 0.00000000 0.00000000 %8.5f %8.5f %f 1\n',waypoints(total_num_WP(1),:)');
fprintf(fileID, '%d 0 3 183 %8.5f %8.5f 0.00000000 0.00000000 %8.5f %8.5f %f 1\n',servo(1,:)');
fclose(fileID);


%% End Time 
tEnd = toc(tStart); % end clock1 to calculate runtime
fprintf('Total time is %8.6f seconds\n',tEnd);





