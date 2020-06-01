function [ Centroids ] = calcCentrePoints( incidences,node_coords )
%This function calculates the centroid of each element, and returns an
%array of centroid x and y values corresponding to the incidence list

Centroids=zeros(length(incidences(:,1)),2);

for i=1:length(incidences(:,1))
    xi=node_coords(incidences(i,1),1);
    yi=node_coords(incidences(i,1),2);
    xj=node_coords(incidences(i,2),1);
    yj=node_coords(incidences(i,2),2);
    xm=node_coords(incidences(i,3),1);
    ym=node_coords(incidences(i,3),2);
    Centroids(i,1)=(xi+xj+xm)/3;
    Centroids(i,2)=(yi+yj+ym)/3;
end


end

