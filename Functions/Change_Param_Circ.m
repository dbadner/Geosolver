function [Element_Param] = Change_Param_Circ(x1,y1,radius,Element_Param,E_set,nue_set,ecp)
    
    % Help Change_Param_Circ:
    %
    % Change_Param_Circ(x1,x2,y1,y2,Element_Param,E_set,nue_set,ecp)
    % 
    % x1,x2,y1,y2
    %       Rectangle definded by center poing [index 1] and point on
    %       circle [index 2]
    % ecp
    %       element center points of the mesh-elements
    % Element_Param
    %       consists of 2 vectors with element parameters
    %       1. column:  E - Young's Modulus
    %       2. column:  nue - Poisson's Ratio
    % E_set, nue_set
    %       Values to set if center point of element is in circle
    
    % calculate squared distance to ecp
    % radius_squared = (x2-x1)^2 + (y2-y1)^2;
    distance_squared = (ecp(:,1)-x1).^2 + (ecp(:,2)-y1).^2;
    
    % get logic vectors of 
    log = distance_squared < radius^2;
    idx = find(log);
    
    % change parameters
    Element_Param(idx,1) = E_set;
    Element_Param(idx,2) = nue_set;
    
end