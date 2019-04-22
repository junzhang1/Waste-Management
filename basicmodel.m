cd('C:\Users\ayushid\Desktop\Final Code\Basic Model')
addpath('C:\GAMS\win64\26.1')

Ni = 95;
Nj = 22;
Ns = 15;

i.name = 'i';
i.type = 'set';
i.val  = [linspace(1,Ni,Ni)]';

s.name = 's';
s.type = 'set';
s.val  = [linspace(1,Ns,Ns)]';

j.name = 'j';
j.type = 'set';
j.val  = [linspace(1,Nj,Nj)]';

T.name = 'T';
T.type = 'parameter';
T.val = csvread('waste.csv');
T.form = 'full';
T.dim = 2; 

% C.name = 'C';
% C.type = 'parameter';
% C.val = [];
% C.form = 'full';
% C.dim = 1;

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

wgdx ('basicmodel_inputs', i, j, s, T, XC, YC, XL, YL)

gams ('basicmodel.gms')

output_structure = struct('name','TL','form','full');
output = rgdx (strcat('basicmodel_output'), output_structure);
TL = output.val;
 
output_structure = struct('name','TD','form','full');
output = rgdx (strcat('basicmodel_output'), output_structure);
TD = output.val;
 
output_structure = struct('name','A','form','full');
output = rgdx (strcat('basicmodel_output'), output_structure);
A = output.val;

output_structure = struct('name','L','form','full');
output = rgdx (strcat('basicmodel_output'), output_structure);
L = output.val;
 
 
csvwrite('assignment.csv', A)
csvwrite('landfills.csv', L)
