clear all; clc;
x = 1417;
y = 1143;
z = 220;
MAP = zeros(x,y);
whos MAP
MAP = sparse(MAP);
whos MAP
MAP = zeros(x,y,z);
whos MAP
% Half accuracy
% MAP = zeros(floor(x/2),floor(y/2),floor(z/2));
% whos MAP
% % MAP = sparse(MAP);
