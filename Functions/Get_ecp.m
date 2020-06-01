function [ecp] = Get_ecp(node_coords,incidences)
    
    % Help Get_ecp
    % 
    % calculates the element center point of triangle elements in a mesh
    % 2 column vectors ecp = [x_center,y_center]
    
    ecp = zeros(length(incidences),2);
    
    for i=1:length(incidences)
        
        idx = incidences(i,:);
        ecp(i,1) = (node_coords(idx(1),1)+node_coords(idx(2),1)+node_coords(idx(3),1))/3;
        ecp(i,2) = (node_coords(idx(1),2)+node_coords(idx(2),2)+node_coords(idx(3),2))/3;
        
    end
    
end