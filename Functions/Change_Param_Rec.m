function [Element_Param] = Change_Param_Rec(x1,x2,y1,y2,Element_Param,E_set,nue_set,ecp)
    
    % Help Change_Param_Rec:
    %
    % Change_Param_Rec(x1,x2,y1,y2,Element_Param,E_set,nue_set,ecp)
    % 
    % x1,x2,y1,y2
    %       Rectangle definded by two points (opposite edges)
    % ecp
    %       element center points of the mesh-elements
    % Element_Param
    %       consists of 2 vectors with element parameters
    %       1. column:  E - Young's Modulus
    %       2. column:  nue - Poisson's Ratio
    % E_set, nue_set
    %       Values to set if center point of element is in rectangle
    
    
    % make x1 and y1 the smaller elements
    if x1>x2
        m=x2;
        x2=x1;
        x1=m;
        clear m
    end
    if y1>y2
        m=y2;
        y2=y1;
        y1=m;
        clear m
    end
    
    % get logic vectors of 
    log_x1 = ecp(:,1) > x1;
    log_x2 = ecp(:,1) < x2;
    
    log_y1 = ecp(:,2) > y1;
    log_y2 = ecp(:,2) < y2;
    
    log = log_x1 .* log_x2 .* log_y1 .* log_y2;
    idx = find(log);
    
    % change parameters
    Element_Param(idx,1) = E_set;
    Element_Param(idx,2) = nue_set;
    
    
end