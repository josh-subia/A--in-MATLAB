%function for mapping lines between two points on the MAP matrix
function [MAP] = mapping_lines(MAP,x1,x2,y1,y2)
% Given:
% MAP, the matrix of the map
% x1, x2, X cords of two points
% y1, y2, Y cords of two points
% Return MAP Matrix with boudary lines

%Initialize
Y_val_upper = zeros(x1,x2);
Y_val_lower = zeros(x1,x2);
X_val_upper = zeros(y1,y2);
X_val_lower = zeros(y1,y2);
%Determines y = m*x+b line between two given points
x = [x1 x2];
y = [y1 y2];
c = [[1; 1]  x(:)]\y(:);                % Calculate Parameter Vector
slope_m = c(2);
intercept_b = c(1);

%plots a line between (x1,y1) and (x2,y2) using Y values
if x1 < x2
    a = x1:x2;
elseif x1 > x2
    a = x2:x1;
end
for j = a
    Y_val_upper(j) = ceil(slope_m*j + intercept_b);
    Y_val_lower(j) = floor(slope_m*j + intercept_b);
    %plots the upper bound and lower bound of the line between two
    %points
    if Y_val_lower(j) == 0
        Y_val_lower(j) = 1;
    end
    MAP(j,Y_val_upper(j)) = -1;
    MAP(j,Y_val_lower(j)) = -1;
end

%plots a line between (x1,y1) and (x2,y2) using X values
if y1 < y2
    b = y1:y2;
elseif y1 > y2
    b = y2:y1;
end
for i = b
    X_val_upper(i) = ceil((i-intercept_b)/slope_m);
    X_val_lower(i) = floor((i-intercept_b)/slope_m);
    %plots the upper bound and lower bound of the line between two
    %points
    if X_val_lower(i) == 0
        X_val_lower(i) = 1;
    end
    MAP(X_val_upper(i),i) = -1;
    MAP(X_val_lower(i),i) = -1;
end

end