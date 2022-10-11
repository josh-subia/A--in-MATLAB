function MAP = MakeCircle(MAP,centerX,centerY,radius_ft)
%Given MAP Matrix, position of circle and radius of circle(ft)
%Return MAP Matrix with Circle obstacles

%first convert radius (ft) to radius (m)
%Making two circles to reudce the amount of obstacles points in A* 

%Add 3 m buffer to obstacles
%Buffer changed from 15 to 18 4/24/2022
Buffer = 15;

%Inner Circle
radius_m1 = (radius_ft/3.281);

%Outter Circle
radius_m2 = (radius_ft/3.281)+Buffer;


% Create a logical image of a circle with specified
% diameter, center, and image size.
% First create the image.
imageSizeX = 1417;
imageSizeY = 1143;
[columnsInImage ,rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
circlePixels1 = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius_m1.^2;
circlePixels2 = (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius_m2.^2;
% circlePixels is a 2D "logical" array.

%Convert logical array to double
Circle1 = double(circlePixels1)';
Circle2 = double(circlePixels2)';

%Transfer Circle to MAP Matrix
%Makes Outter Cricle 
for i = 1:imageSizeX
    for j = 1:imageSizeY
        if Circle2(i,j) == 1
            MAP(i,j) = -1;
        elseif MAP(i,j) ~= -1
            MAP(i,j) = 0;
        end
    end
end

%Makes Inner Circle
for i = 1:imageSizeX
    for j = 1:imageSizeY
        if Circle1(i,j) == 1
            MAP(i,j) = 2;
        elseif MAP(i,j) ~= -1 
            MAP(i,j) = 0;
        end
    end
end

end
