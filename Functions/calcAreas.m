function [ A ] = calcAreas( incidences,node_coords )
%This function calculates the area of each element and returns an array of
%areas corresponding to the incidence list

A=zeros(length(incidences(:,1)),1);
%loop through each element
    for i=1:length(incidences(:,1))
        xi=node_coords(incidences(i,1),1);
        yi=node_coords(incidences(i,1),2);
        xj=node_coords(incidences(i,2),1);
        yj=node_coords(incidences(i,2),2);
        xm=node_coords(incidences(i,3),1);
        ym=node_coords(incidences(i,3),2);
        A(i)=(xi*(yj-ym)+xj*(ym-yi)+xm*(yi-yj))/2;
    end


end

