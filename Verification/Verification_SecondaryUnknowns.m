clear,clc

incidences=[2,3,5;4,1,5;5,3,4;1,2,5];
node_coords=[0,0;100,0;100,100;0,100;50,50];
u_vec=[1,2,-1,3,-2,5,-4,3,2,0];
f_vec=[1,2,3,4,5,1,2,3,4,5];
E=[1e9,1e9,1e9,1e9];
nue=[0.25,0.25,0.25,0.25];
[strains,stresses,sigma1_angle] = SecondaryUnknowns(u_vec,f_vec,incidences,node_coords,E,nue);

%clear,clc

%incidences=[2,3,5;4,1,5;5,3,4;1,2,5];
%node_coords=[0,0;100,0;100,100;0,100;50,50];
%u_vec=[2,1,2,1,2,1,2,1,2,1];
%f_vec=[2,1,2,1,2,1,2,1,2,1];
%E=[1e9,1e9,1e9,1e9];
%nue=[0.25,0.25,0.25,0.25];
%[strains,stresses,sigma1_angle] = SecondaryUnknowns(u_vec,f_vec,incidences,node_coords,E,nue);
