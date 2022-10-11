function [Obs_rad] = LOSTest(x_WP1,y_WP1,x_WP2,y_WP2,alt_WP1,alt_WP2,x_OBS,y_OBS,height,radius)
%WP coordinates on X and Y axis and altitude on meters
WP1 = [x_WP1, y_WP1];
WP1_alt = alt_WP1;
WP2 = [x_WP2, y_WP2];
WP2_alt = alt_WP2;
buf = 9;%obstacle buffer %EDIT 4/24/2022 - Changed height buffer from 3 to 9 meters

    Obs = [x_OBS, y_OBS];
    
    %Add 9m buffer to obstacle height
    Obs_height = height + buf*3.281;
    %Convert from feet to meters
    Obs_rad = radius/3.281;
    % Formula found here: https://mathworld.wolfram.com/Circle-LineIntersection.html
    %Only works if Obstacle is between waypoints on x-axis, so we have to check for that too
    %Set Obstacle to (0,0) and move Waypoint accordingly

    WP1 = WP1-Obs;
    WP2 = WP2-Obs;
    Obs = Obs-Obs;
    WP12 = WP2-WP1; %distance between the waypoints
    normWP12 = norm(WP12);
    crossWP12 = WP1(1)*WP2(2)-WP1(2)*WP2(1); %Cross product of waypoints
    discriminant = ((Obs_rad+buf)^2)*(normWP12^2)-(crossWP12^2);

    %If the obstacle is between the x and y points of both waypoints
    if (min(WP1(1),WP2(1))<Obs(1)<max(WP1(1),WP2(1)))...
        &&(min(WP1(2),WP2(2))<Obs(2)<max(WP1(2),WP2(2)))
        if discriminant < 0
            doIntersect = false;
            %Convert radius back to feet
            radius_meters = Obs_rad;
            Obs_rad = radius_meters * 3.281;
        else
            doIntersect = true;
        end
    else
            doIntersect = false;
            %Convert radius back to feet
            radius_meters = Obs_rad;
            Obs_rad = radius_meters * 3.281;
    end

    if doIntersect
        %%height checker
        %find distance between two waypoints on 2-D plane
        distWP12 = norm(WP1-WP2);%sqrt((WP1(1)-WP2(1))^2+(WP1(2)-WP2(2))^2);
        %height difference between two waypoints
        alt_diffWP12 = abs(WP1_alt-WP2_alt);
        %slope of the line from WP1 to WP2 due to height
        m = alt_diffWP12/distWP12;
        %y = mx+b...b is the height of the lowest waypoint
        %The lowest waypoint is placed on x = 0 on the x-axis and
        %the highest waypoint is placed on x = distWP12 on the x-axis
        if WP1_alt<WP2_alt
            b = WP1_alt;
        else
            b = WP2_alt;
        end
        %check for distance between obstacle and lowest waypoint
        %The obstacle is placed at x = distLowWPObs on the x-axis
        if b == WP1_alt
            distLowWPObs = norm(abs(WP1-Obs));%sqrt((WP1(1)-Obs(1))^2+(WP1(2)-Obs(2))^2);
        else
            distLowWPObs = norm(abs(WP2-Obs));%sqrt((WP2(1)-Obs(1))^2+(WP2(2)-Obs(2))^2);
        end
        %get distance between the 2 walls of the obstacle and lowest waypoint
        %These values will be plugged into y = mx+b to find the altitude of
        %the flight path at the left and right obstacle walls
        distLeftWall_LowWP = distLowWPObs - Obs_rad - buf;
        distRightWall_LowWP = distLowWPObs + Obs_rad + buf;
        %check for height of the flight path at left and right walls
        alt_atWall_1 = m*distLeftWall_LowWP+b;
        alt_atWall_2 = m*distRightWall_LowWP+b;
        %Convert radius back to feet
        radius_meters = Obs_rad;
        Obs_rad = radius_meters * 3.281;
        %If the obstacle height is below the flight path at both the left
        %and right walls
        if Obs_height < alt_atWall_1 && Obs_height < alt_atWall_2
            %delete the obstacle
            %fprintf('Alt at Wall 1: %0.2f\tAlt at Wall 2:%0.2f\tObs_height:%d\n',alt_atWall_1,alt_atWall_2,Obs_height);
            disp('deleting the obstacle');
                Obs_rad = -18;%Account for the 15 meter buffer in MakeCircle
        else
            %do nothing
            %disp('going around obstacle');
        end
    end
end