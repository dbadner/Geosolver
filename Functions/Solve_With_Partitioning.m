function [f_solved,u_solved,err] = Solve_With_Partitioning(K_g,fx_set,fy_set,f,u,n_nodes)
    
    % SOLVE (function)
    % 
    %   Input:
    %   K_g       -   global stiffness matrix
    %   fx_set    -   vector of nodes, in which fx is set
    %   fy_set    -   vector of nodes, in which fy is set
    %   f         -   vector of forces (boundary condition)
    %                  forces that are not set by boundary conditions can be
    %                  set arbitrairily in the vector, but they have to be in
    %   u         -   vector of constraints (boundary condition)
    %                  constraints that are not set by boundary conditions can be
    %                  set arbitrairily in the vector, but they have to be in
    %   n_nodes   -   number of nodes
    % 
    %   Output:
    %   f_solved  -   whole f vector including calculated values and boundary
    %                  conditions
    %   u_solved  -   whole u vector including calculated values and boundary
    %                  conditions
    
    % tranlation input vectors
    idx_fx_set = fx_set * 2 -1;
    idx_fy_set = fy_set * 2;
    idx_f_set = sort([idx_fx_set idx_fy_set]);
    
    % determine number of elements
    n_fx_set    = length(idx_fx_set);
    n_fy_set    = length(idx_fy_set);
    n_f_set     = n_fx_set + n_fy_set;
    
    % assemble change matrix
    X = zeros(n_f_set,n_f_set);                 % prelocate
    to_f_set_idx = 1;
    to_u_set_idx = n_f_set + 1;
    for from = 1:n_nodes*2
        if sum(from == idx_f_set)             % if fixed
            X( to_f_set_idx , from ) = 1;
            to_f_set_idx = to_f_set_idx + 1;
        else                                    % if not fixed
            X( to_u_set_idx , from ) = 1;
            to_u_set_idx = to_u_set_idx + 1;
        end
    end
    
    % apply change
    K_changed = X * K_g * X';
    f_rearranged = X * f;
    u_rearranged = X * u;
    
    % partition
    K_ff = K_changed( 1:n_f_set , 1:n_f_set );
    K_fu = K_changed( 1:n_f_set , n_f_set+1:end);
    K_uf = K_changed( n_f_set+1:end , 1:n_f_set );
    K_uu = K_changed( n_f_set+1:end , n_f_set+1:end );
    
    f_f = f_rearranged(1:n_f_set);
    u_u = u_rearranged(n_f_set+1:end);
    
    % solve equations
    u_f = K_ff^(-1) * ( f_f - K_fu * u_u );
    f_u = K_uf * u_f + K_uu * u_u;
    
    %calculate error resulting from solved displacements (by subtracting
    %forces)
    e = K_ff*u_f-f_f;
    %calculate root of the sum of the squared error
    err=sqrt(e'*e/length(u_f));
    
    % put results together and restore original order with K^-1
    f_solved = X^(-1) * [f_f;f_u];
    u_solved = X^(-1) * [u_f;u_u];
    
end

