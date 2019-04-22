cd('/Users/zhangjun/Desktop/DecisionAnalytics/project/Model_with_transfer_stations')
addpath('C:\GAMS\win64\26.1')

Ni = 95;
Nj = 22;
%Ns = 15;
Nk = 84;

i.name = 'i';
i.type = 'set';
i.val  = [linspace(1,Ni,Ni)]';

%s.name = 's';
%s.type = 'set';
%s.val  = [linspace(1,Ns,Ns)]';

j.name = 'j';
j.type = 'set';
j.val  = [linspace(1,Nj,Nj)]';

k.name = 'k';
k.type = 'set';
k.val  = [linspace(1,Nk,Nk)]';

T.name = 'T';
T.type = 'parameter';
T.val = csvread('waste_new.csv');
T.form = 'full';
T.dim = 1; 

C.name = 'C';
C.type = 'parameter';
C.val = [4000000];
C.form = 'full';
C.dim = 1;

P.name = 'P';
P.type = 'parameter';
P.val = [4000000];
P.form = 'full';
P.dim = 1;

XC.name = 'XC';
XC.type = 'parameter';
XC.val = csvread('center_locations_x.csv');
XC.form = 'full';
XC.dim = 1;

YC.name = 'YC';
YC.type = 'parameter';
YC.val = csvread('center_locations_y.csv');
YC.form = 'full';
YC.dim =1;

XL.name = 'XL';
XL.type = 'parameter';
XL.val = csvread('landfill_locations_x.csv');
XL.form = 'full';
XL.dim = 1;

YL.name = 'YL';
YL.type = 'parameter';
YL.val = csvread('landfill_locations_y.csv');
YL.form = 'full';
YL.dim =1;

XT.name = 'XT';
XT.type = 'parameter';
XT.val = csvread('transfer_station_locations_x.csv');
XT.form = 'full';
XT.dim = 1;

YT.name = 'YT';
YT.type = 'parameter';
YT.val = csvread('transfer_station_locations_y.csv');
YT.form = 'full';
YT.dim =1;

%DIK.name = 'DIK';
%DIK.type = 'parameter';
%DIK.val = csvread('distance_ik.csv');
%DIK.form = 'full';
%DIK.dim = 2;

% DIJ.name = 'DIJ';
% DIJ.type = 'parameter';
% DIJ.val = csvread('distance_ij.csv');
% DIJ.form = 'full';
% DIJ.dim = 2;
% 
% DKJ.name = 'DKJ';
% DKJ.type = 'parameter';
% DKJ.val = csvread('distance_kj.csv');
% DKJ.form = 'full';
% DKJ.dim = 2;

wgdx ('model_with_stations_inputs', i, j,k, T, XC, YC, XL, YL, XT,YT,C,P)

gams ('model_with_transfer_stations.gms')

output_structure = struct('name','B','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
B = output.val;
 
output_structure = struct('name','L','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
L = output.val;
 
output_structure = struct('name','TD','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
TD = output.val;

output_structure = struct('name','TL','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
TL = output.val;

output_structure = struct('name','TS','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
TS = output.val;

output_structure = struct('name','N','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
N = output.val;

output_structure = struct('name','M','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
M = output.val;

output_structure = struct('name','O','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
O = output.val;

output_structure = struct('name','A','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
A = output.val;

output_structure = struct('name','D','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
D = output.val;

output_structure = struct('name','W','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
W = output.val;

output_structure = struct('name','T','form','full');
output = rgdx (strcat('model_transfer_stations_output'), output_structure);
T = output.val;
 
 
csvwrite('landfills_built.csv', L)
csvwrite('transfer_stations_built.csv', B)
csvwrite('total_distance.csv',TD)
csvwrite('station_landfill_assignment.csv',M)
csvwrite('site_station_assignment.csv',N)
csvwrite('site_landfill_assignment.csv',O)
csvwrite('amount_site_station.csv',A)
csvwrite('amount_station_landfill.csv',D)
csvwrite('amount_site_landfill.csv',W)
csvwrite('trash_from_model.csv',T)














