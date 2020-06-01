function [ fx_set,fy_set,f,u ] = defineBoundaryConditions( node_coords,BCxmin,BCxmax,BCymin,BCymax,axes )
%Defines the four boundary conditions used in the program
    %fx_set - list of nodes where force in X is fixed
    %fx_set - list of nodes where force in Y is fixed
    %f - list of forces associated with each node
    %u - list of displacements associated with each node
    %fx_min, fx_max - nodes at the boundaries
    
    dx_min = find(node_coords(:,1)==BCxmin);
    dx_max = find(node_coords(:,1)==BCxmax);
    dy_min = find(node_coords(:,2)==BCymin);
    dy_max = find(node_coords(:,2)==BCymax);
    %All y-forces are set by element weight
    
    logi = ones(1,length(node_coords(:,1)));
    logi(dx_min) = 0;
    logi(dx_max) = 0;
    logi(dy_min) = 0;
    logi(dy_max) = 0;
    fx_set = find(logi);
    logi = ones(1,length(node_coords(:,1)));
    logi(dy_min) = 0;
    fy_set = find(logi);
%     fy_set = find( (node_coords(:,2)~=BCxmin) + (node_coords(:,2)~=BCxmax) + ...
%         (node_coords(:,2)~=BCymin) + (node_coords(:,2)~=BCymax ))
    %If f and u are column vectors, alternating x and y forces
    f = zeros(length(node_coords(:,1))*2,1);
    u = zeros(length(node_coords(:,1))*2,1);
    f(fx_set*2-1)=1;
    f(fy_set*2)=1;


    
    
  
%     hold on
%     for i=1:length(dx_min);
%        plot(axes,node_coords((dx_min(i)),1),node_coords(dx_min(i),2),'s','MarkerSize',BCymax/12,'MarkerFaceColor','r','MarkerEdgeColor','k');
%     end
%     for i=1:length(dx_max);
%        plot(axes,node_coords((dx_max(i)),1),node_coords(dx_max(i),2),'s','MarkerSize',BCymax/12,'MarkerFaceColor','r','MarkerEdgeColor','k');
%     end
%     for i=1:length(dy_min);
%        plot(axes,node_coords((dy_min(i)),1),node_coords(dy_min(i),2),'s','MarkerSize',BCymax/12,'MarkerFaceColor','r','MarkerEdgeColor','k');
%     end
%     for i=1:length(fy_set);
%        plot(axes,node_coords((fy_set(i)),1),node_coords(fy_set(i),2)+.01*BCymax,'v','MarkerSize',BCymax/10,'MarkerFaceColor','r','MarkerEdgeColor','k');
%     end
end

