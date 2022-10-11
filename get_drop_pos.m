function [latitude_drop,longitude_drop] = get_drop_pos(fname)
%given json file
%return:
% Location of UGV Drop Position

% Parse individual data for UGV Drop Pos

%Get json data into matlab 
fid = fopen(fname);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
val = jsondecode(str);

% Getting the Drop Pos 
Drop_Pos = val.airDropPos;

% Parse individual data of drop pos
% latitude 
latitude_drop = parse_data(1,Drop_Pos,'latitude');

% longitude
longitude_drop = parse_data(1,Drop_Pos,'longitude');

end 
