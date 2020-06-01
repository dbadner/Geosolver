function [ f_body ] = calcInitialForces(unit_weight,t,node_coords,incidences)
    %This function calculates the body y-force from each element and assigns
    %1/3 of it to each node touching each respective element
    n_nodes=length(node_coords(:,1));
    n_el=length(incidences(:,1));
    f_body=zeros(2*n_nodes,1);
    %loop through each element
    for i=1:n_el
        %calculate element area
        xi=node_coords(incidences(i,1),1);
        yi=node_coords(incidences(i,1),2);
        xj=node_coords(incidences(i,2),1);
        yj=node_coords(incidences(i,2),2);
        xm=node_coords(incidences(i,3),1);
        ym=node_coords(incidences(i,3),2);
        A=(xi*(yj-ym)+xj*(ym-yi)+xm*(yi-yj))/2;
        
        %element gravitational force
        Fy=unit_weight*A*t;
        
        %Add y-forces to f_body vector for each node of the element
        f_body(incidences(i,1)*2)=f_body(incidences(i,1)*2)-Fy/3;
        f_body(incidences(i,2)*2)=f_body(incidences(i,2)*2)-Fy/3;
        f_body(incidences(i,3)*2)=f_body(incidences(i,3)*2)-Fy/3;
    end
end

