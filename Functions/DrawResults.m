function DrawResults( showStressOr,plotProp,edgeBool )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%showStressOr=evalin('base','showStressOr');
val=plotProp(1);
siteAxes=plotProp(2);
kPa1=plotProp(3);
kPa2=plotProp(4);
kPa3=plotProp(5);
minimum=plotProp(6);
maximum=plotProp(7);
average=plotProp(8);
node_coords = evalin('base','node_coords');
incidences = evalin('base','incidences');
strains = evalin('base','strains');
stresses = evalin('base','stresses');
sigma1_angle = evalin('base','sigma1_angle');
plot_Edgedata = evalin('base','plot_Edgedata');
plot_Centredata = evalin('base','plot_Centredata');
u_vec = evalin('base','u_solved');
displacements=evalin('base','displacements');
A=evalin('base','A');
stressTrajectories=evalin('base','stressTrajectories');
excavations=evalin('base','excavations');
%set(handles.stressOr,'value',0)
cla reset
axes(siteAxes)
if val ~=1
    if edgeBool==1
        x = plot_Edgedata(:,1);
        y = plot_Edgedata(:,2);
        xlin = linspace(min(node_coords(:,1)),max(node_coords(:,1)),100);
        ylin = linspace(min(node_coords(:,2)),max(node_coords(:,2)),100);
        [X,Y] = meshgrid(xlin,ylin);
        colormap(jet(128))
        hold off
        z = plot_Edgedata(:,val+3);
        Z=griddata(x,y,z,X,Y,'linear');
        contourf(X,Y,Z,20,'edgecolor','none')
    elseif edgeBool==0
        x = plot_Centredata(:,1);
        y = plot_Centredata(:,2);
        xlin = linspace(min(node_coords(:,1)),max(node_coords(:,1)),100);
        ylin = linspace(min(node_coords(:,2)),max(node_coords(:,2)),100);
        [X,Y] = meshgrid(xlin,ylin);
        colormap(jet(128))
        hold off
        z = plot_Centredata(:,val+1);
        Z=griddata(x,y,z,X,Y,'linear');
        contourf(X,Y,Z,20,'edgecolor','none')
    else %constant strain triangles
        colormap(jet(128))
        hold off
        z=plot_Centredata(:,val+1);
        p=patch('Faces',incidences,'Vertices',node_coords,'FaceColor','b');
        set(p,'FaceColor','flat','FaceVertexCData',z,'CDataMapping','scaled');
    end
    colorbar()
    element_values=[stresses strains];
    
    %max, min, and avg parameters are taken from element values, not nodes(above)
    set(minimum,'String',min(element_values(:,val-1)));
    set(maximum,'String',max(element_values(:,val-1)));
    %Weighted average of parameter of interest based on elemental area:
    set(average,'String',(element_values(:,val-1))'*A/sum(A)); 
    if val <7
        set(kPa1,'string','Pa')
        set(kPa2,'string','Pa')
        set(kPa3,'string','Pa')
        set(kPa1,'visible','on')
        set(kPa2,'visible','on')
        set(kPa3,'visible','on')
    else
        set(kPa1,'visible','off')
        set(kPa2,'visible','off')
        set(kPa3,'visible','off')
    end
    hold on
    Draw(node_coords,incidences,siteAxes,0,0)
else
    set(kPa1,'string','m')
    set(kPa2,'string','m')
    set(kPa3,'string','m')
    set(kPa1,'visible','on')
    set(kPa2,'visible','on')
    set(kPa3,'visible','on')
    %calculate displacement magnitudes
    u_vec_mag=zeros(length(u_vec)/2,1);
    for i=1:length(u_vec)/2
        u_vec_mag(i)=sqrt(u_vec(i*2)*u_vec(i*2)+u_vec(i*2-1)*u_vec(i*2-1));
    end
    %set(minimum,'String',min(u_vec));
    %set(maximum,'String',max(u_vec));
    %set(average,'String',mean(u_vec));
    set(minimum,'String',min(u_vec_mag));
    set(maximum,'String',max(u_vec_mag));
    set(average,'String',mean(u_vec_mag)); 
    cla reset
    Draw([displacements(:,1) displacements(:,2)],incidences,siteAxes,0,0)
    axis([min(node_coords(:,1))-1 max(node_coords(:,1))+1 min(node_coords(:,2))-1 max(node_coords(:,2))+1]);
end

%draw stress orientation lines
if showStressOr==1 %Show orientations
    for i=1:length(incidences(:,1))
        line([stressTrajectories(i,1),stressTrajectories(i,2)],[stressTrajectories(i,3),stressTrajectories(i,4)],'color','black','linewidth',1);
        line([stressTrajectories(i,5),stressTrajectories(i,6)],[stressTrajectories(i,7),stressTrajectories(i,8)],'color','black','linewidth',1);
    end
end

%fill in excavations with white if displacements are not being plotted
if isempty(excavations)==0%not empty
    if val~=1
        numExc=max(excavations(:,1));
        exc=cell(1,numExc);
        for i=1:length(excavations(:,1))
            exc{excavations(i,1)}=[exc{excavations(i,1)};excavations(i,2),excavations(i,3)];
        end

        for i=1:numExc
            patch(exc{i}(:,1)',exc{i}(:,2)','white');
        end
    end
end
end

