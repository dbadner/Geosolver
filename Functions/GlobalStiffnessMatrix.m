function [ global_stiffness_matrix ] = GlobalStiffnessMatrix(element_stiffness_matrices,incidences,n_nodes,n_el)
%This function uses the matrix of element stiffness matrices (6x6x#nodes),
%the incidence list, and the node coordinates list to create and return the
%global stiffness matrix

%fill global stiffness matrix with zeros
global_stiffness_matrix = zeros(n_nodes*2:n_nodes*2);

%loop through each element stiffness matrix to build the global matrix
for i=1:n_el
    %loop through each row of the element stiffness matrix 'i'
    for row=1:6
        %find the index of the appropriate row in the global stiffness
        %matrix
        switch row
            case 1
                row_global = incidences(i,1)*2-1;
            case 2
                row_global = incidences(i,1)*2;
            case 3
                row_global = incidences(i,2)*2-1;
            case 4
                row_global = incidences(i,2)*2;
            case 5
                row_global = incidences(i,3)*2-1;
            case 6
                row_global = incidences(i,3)*2;
        end    
        
        %loop through each column entry in the current row 'row'
        for col=1:6
            %find the index of the appropriate row in the global stiffness
            %matrix
            switch col
                case 1
                    col_global = incidences(i,1)*2-1;
                case 2
                    col_global = incidences(i,1)*2;
                case 3
                    col_global = incidences(i,2)*2-1;
                case 4
                    col_global = incidences(i,2)*2;
                case 5
                    col_global = incidences(i,3)*2-1;
                case 6
                    col_global = incidences(i,3)*2;
            end  
            %adds current entry in the element stiffness matrix to
            %current value in appropriate global stiffness matrix entry
            global_stiffness_matrix(row_global,col_global)=global_stiffness_matrix(row_global,col_global)+element_stiffness_matrices(row,col,i);
        end
    end
end

end

