function Draw(node_coords,incidences,axes,numElOn,numNodesOn)
    % plot nodes
    plot(axes,node_coords(:,1),node_coords(:,2),'.','LineWidth',6,'color','k');
    handles.figure_input = gcf;
    handles.axes_input = gca;
    hold on;
    n = length(node_coords(:,1));
    axis([min(node_coords(:,1))-1 max(node_coords(:,1))+1 min(node_coords(:,2))-1 max(node_coords(:,2))+1]);
    p=patch('Faces',incidences,'Vertices',node_coords,'FaceColor','w');
    set(p,'FaceAlpha',0)
    %scale font size
    if (numNodesOn ||numElOn)
    fSize=10; %default
    l=length(incidences(:,1));
    if (l<50)
        fSize=10;
    elseif (l<100)
        fSize=8;
    elseif (l<200)
        fSize=7;
    else
        fSize=6;
    end
    end
    if numNodesOn
        % plot node numbers
        for i=1:n
            text(node_coords(i,1)+.1,node_coords(i,2)+.5,num2str(i),'FontSize',fSize);
        end
    end
    if numElOn
        % plot edge numbers
        for i=1:length(incidences(:,1))
            x = mean(node_coords([incidences(i,:)],1));
            y = mean(node_coords([incidences(i,:)],2));
            text(x,y,num2str(i),...
            'HorizontalAlignment','center',... 
            'EdgeColor',[.7 .9 .7],...
            'Margin',1,'FontSize',fSize);
        end
    end
end