function [MAP,num_WP,x_WP,y_WP,n,m,altitude] = parse_all_data(fname)
    % Updated: 2/25/2021
    % Given File name 
    % Return location of each waypoint and MAP Matrix with obstacles and boundary lines added 
    % Number of waypoints and dimention of MAP Matrix
    % and UGV Drop pos

    %Gets Boundary Points Data
    [num_BP,latitude_BP,longitude_BP] = get_BP(fname);

%     %Gets Obstacle Data
%     [num_obs,latitude_obs,longitude_obs,radius_obs,height] = get_obs(fname);

    %Get Waypoint Data
    [num_WP,latitude_WP,longitude_WP,altitude] = get_WP(fname);

%     %Get UGV Drop Pos
%     [latitude_drop, longitude_drop] = get_drop_pos(fname);

%     %add UGV drop to waypoint path 
%     num_WP = [num_WP(1)+1,1];
%     latitude_WP(end+1) = latitude_drop;
%     longitude_WP(end+1) = longitude_drop;
%     altitude(end+1) = 100;

    %Longitude and Latitude Max and Mins
    Lat_min = min(latitude_BP);
    Lat_max = max(latitude_BP);
    Long_min = min(longitude_BP);
    Long_max = max(longitude_BP);

    %X = Long Y = Lat
    dist_Y = round((Lat_max - Lat_min),5); %change in 0.00001 is 1.1 m
    dist_X = round((Long_max - Long_min),5); %change in 0.00001 is 1.1 m

    %Scaled X and Y
    Scale_Factor = 100000;
    X = Scale_Factor*dist_X; %change in 1, is 1.1 m
    Y = Scale_Factor*dist_Y ;%change in 1, is 1.1 m

    %Mesh Size [n,m]
    n = X+1; m = Y+1; %need to add one because matlab indexes at 1 not zero

    %distance between each space in the matrix
    dx = X/(n-1); %change in 1 is 1.1 m
    dy = Y/(m-1); %change in 1 is 1.1 m

    %Initalize MAP //Edited for sparce function: Space set to 0 not 2 For MAP
    MAP=zeros(n,m);
    
    %convert GPs Cords to MAP matrix points
    %One is added because MATLAB indexes at 1, not Zero!!!
    x_BP = zeros(1,num_BP(1));
    y_BP = zeros(1,num_BP(1));
    for i = 1:num_BP(1)
        [x_BP(i),y_BP(i)] = GPS2MAP(longitude_BP(i),latitude_BP(i));
    end

%     %Converts Obstacles GPS cords to MAP Matrix cord
%     x_obs = zeros(1,num_obs(1));
%     y_obs = zeros(1,num_obs(1));
%     for i = 1:num_obs(1)
%     [x_obs(i),y_obs(i)] = GPS2MAP(longitude_obs(i),latitude_obs(i));
%     end

    %Converts WP GPS Cords to MAP Matrix Cords 
    x_WP = zeros(1,num_WP(1));
    y_WP = zeros(1,num_WP(1));
    for i = 1:num_WP(1)
        [x_WP(i),y_WP(i)] = GPS2MAP(longitude_WP(i),latitude_WP(i));
    end 

%     % % %LINE OF SIGHT AND HEIGHT TEST BELOW
%     for i=1:num_WP(1)-1 %Loop through every waypoint and next waypoint
%         for j=1:num_obs(1) %Loop through every obstacle 
%             radius_obs(j) = LOSTest(x_WP(i),y_WP(i),x_WP(i+1),y_WP(i+1),altitude(i),altitude(i+1),x_obs(j),y_obs(j),height(j),radius_obs(j));
%             if radius_obs(j)==0
%     %             fprintf("Waypoint(%d): %0.2f %02.f\tWaypoint(%d): %0.2f %0.2f\tObstacle(%d): %0.2f %0.2f\n",i,x_WP(i),y_WP(i),i+1,x_WP(i+1),y_WP(i+1),j,x_obs(j),y_obs(j));
%     %             fprintf("Deleted the Obstacle(%d) between Waypoint(%d) and Waypoint(%d)\n",j,i,i+1);
%             end
%         end
%     end

%     %Plots the obstacles in the MAP Matrix
%     for i = 1:num_obs(1)
%         MAP = MakeCircle(MAP,x_obs(i),y_obs(i),radius_obs(i));
%     end

    %Plots lines between boundary points on MAP Matrix
    %k is number of boundary points
    k = num_BP(1);
    for i = 1:k
        if i < k
            MAP = mapping_lines(MAP,x_BP(i),x_BP(i+1),y_BP(i),y_BP(i+1));
        elseif i == k %Closes boundary by plotting from last point to first point
            MAP = mapping_lines(MAP,x_BP(i),x_BP(1),y_BP(i),y_BP(1));
        end
    end
end 