function [strains,stresses,sigma1_angle] = SecondaryUnknowns(u_vec,f_vec,incidences,node_coords,E,nue )
%[x_strains,y_strains,xy_strains,x_stress,y_stress,xy_stress,sigma1,sigma3,sigma1_dir] = 
%This function determines secondary unknowns, including horizontal strains,
%vertical strains, shear strain, vertical stress, horizontal stress, shear stress, maximum principle
%stress, minimum principle stress, and principle stress orientation
%Returns 3 matrices:
    %strains cols: x strain, y strain, shear strain
    %stresses cols: x stress, y stress, shear stress, sigma 1, sigma 3
    %sigma1_angle: angle of sigma 1 CCW from the positive x-direction (radians)
    
    n_nodes=length(node_coords(:,1));
    n_el=length(incidences(:,1));
    
    ue=zeros(6,1);
    strains=[];
    stresses=[];
    %strains=zeros(n_el,3);
    
    %loop through each element
    for i=1:n_el
        %recalculate matrix B for element i
        xi=node_coords(incidences(i,1),1);
        yi=node_coords(incidences(i,1),2);
        xj=node_coords(incidences(i,2),1);
        yj=node_coords(incidences(i,2),2);
        xm=node_coords(incidences(i,3),1);
        ym=node_coords(incidences(i,3),2);
        
        beta_i=yj-ym;
        beta_j=ym-yi;
        beta_m=yi-yj;
        gamma_i=xm-xj;
        gamma_j=xi-xm;
        gamma_m=xj-xi;

        A=(xi*(yj-ym)+xj*(ym-yi)+xm*(yi-yj))/2;

        B=1/2/A*[beta_i,0,beta_j,0,beta_m,0;0,gamma_i,0,gamma_j,0,gamma_m;gamma_i,beta_i,gamma_j,beta_j,gamma_m,beta_m];
        
        D=E(i)/(1+nue(i))/(1-2*nue(i))*[1-nue(i),nue(i),0;nue(i),1-nue(i),0;0,0,(1-2*nue(i))/2];
        
        %populate displacement vector for element i
        ue(1)=u_vec(incidences(i,1)*2-1);
        ue(2)=u_vec(incidences(i,1)*2);
        ue(3)=u_vec(incidences(i,2)*2-1);
        ue(4)=u_vec(incidences(i,2)*2);
        ue(5)=u_vec(incidences(i,3)*2-1);
        ue(6)=u_vec(incidences(i,3)*2);
        
        %calculate strains for element i
        %x-strain,y-strain,shear-strain
        strains=[strains,B*ue];
        stresses=[stresses,D*B*ue];
    end
    
    %transpose secondary unknown matrices to have 3 columns, and n_el rows
    %strain cols: x strain, y strain, shear strain
    strains=strains';
    stresses=-stresses';
    
    %calculate principle stresses
    for i=1:n_el
        sigma1(i)=.5*(stresses(i,1)+stresses(i,2))+sqrt(.25*(stresses(i,1)-stresses(i,2))^2+stresses(i,3)^2);
        sigma3(i)=.5*(stresses(i,1)+stresses(i,2))-sqrt(.25*(stresses(i,1)-stresses(i,2))^2+stresses(i,3)^2);
        sigma1_angle(i)=.5*atan(2*stresses(i,3)/(stresses(i,1)-stresses(i,2)));
    end
    %stresses cols: x stress, y stress, shear stress, sigma 1, sigma 3
    stresses=[stresses,sigma1',sigma3'];
    %angle of sigma 1 CCW from the positive x-direction (radians)
    sigma1_angle=sigma1_angle';
end

