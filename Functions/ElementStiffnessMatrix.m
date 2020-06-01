function [Ke] = ElementStiffnessMatrix(coords_node_i,coords_node_j,coords_node_m,E,nue,t)
%function accepts 3 sets of node coordinates, a Poisson Ratio and a Young's
%Modulus for a given element, and returns a 6x6 element stiffness matrix

% alpha_i = coords_node_j(1)*coords_node_m(2) - coords_node_j(2)*coords_node_m(1);
% alpha_j = coords_node_i(2)*coords_node_m(1) - coords_node_i(1)*coords_node_m(2);
% alpha_m = coords_node_i(1)*coords_node_j(2) - coords_node_i(2)*coords_node_j(1);
beta_i  = coords_node_j(2) - coords_node_m(2);
beta_j  = coords_node_m(2) - coords_node_i(2);
beta_m  = coords_node_i(2) - coords_node_j(2);
gamma_i = coords_node_m(1) - coords_node_j(1);
gamma_j = coords_node_i(1) - coords_node_m(1);
gamma_m = coords_node_j(1) - coords_node_i(1);

A = (coords_node_i(1)*(coords_node_j(2)-coords_node_m(2))+coords_node_j(1)*(coords_node_m(2)-coords_node_i(2))+coords_node_m(1)*(coords_node_i(2)-coords_node_j(2)))/2;

B = 1/2/A*[beta_i,0,beta_j,0,beta_m,0;0,gamma_i,0,gamma_j,0,gamma_m;gamma_i,beta_i,gamma_j,beta_j,gamma_m,beta_m];

D = E/(1+nue)/(1-2*nue)*[1-nue,nue,0;nue,1-nue,0;0,0,(1-2*nue)/2];

Ke = t*A*transpose(B)*D*B;