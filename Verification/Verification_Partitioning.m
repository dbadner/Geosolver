n_nodes = 2;

K_g = [2 -1 0 -1;-1 2 -1 0;0 -1 2 -1;-1 0 -1 2];
% K_g = [2 -1 0 0;-1 2 -1 0;0 -1 2 -1;0 0 -1 2];

% f = [0 0 0 0]';
% fx_set = [];
% fy_set = [];
% u = [1 1 1 1]';

f = [1 0 1 0]';
fx_set = [1 2];
fy_set = [];
u = [0 0 0 0]'; 

[f_solved,u_solved] = Solve_With_Partitioning(K_g2,fx_set,fy_set,f,u,n_nodes)

e = f_solved - K_g * u_solved