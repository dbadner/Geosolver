function varargout = finiteElementResults(varargin)
%GUI Initialization -- Automatically generated by Matlab
%===============================================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @finiteElementResults_OpeningFcn, ...
    'gui_OutputFcn',  @finiteElementResults_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function finiteElementResults_OpeningFcn(hObject, eventdata, handles, varargin)
%Set initial state for GUI, and bring in workspace variables
%===============================================================
node_coords = evalin('base','node_coords');
incidences = evalin('base','incidences');
Element_Param = evalin('base','Element_Param');
u_vec = evalin('base','u_solved');
f_vec = evalin('base','f_solved');
err=evalin('base','err');
set(handles.kPa1,'visible','off')
set(handles.kPa2,'visible','off')
set(handles.kPa3,'visible','off')
edgeBool = 1;
%Draw mesh from main GUI
%===============================================================
axes(handles.siteAxes)
Draw(node_coords,incidences,handles.siteAxes,0,0)
handles.output = hObject;
guidata(hObject, handles);
[strains,stresses,sigma1_angle] = SecondaryUnknowns(u_vec,f_vec,incidences,node_coords,Element_Param(:,1),Element_Param(:,2));
A=calcAreas(incidences,node_coords);
showStressOr=0;
%calculate the centroids of each element
centroids=calcCentrePoints(incidences,node_coords);
x = centroids(:,1);
y = centroids(:,2);
for n = 1:length(node_coords(:,1))
    found1 = find(incidences(:,1)==n);
    found2 = find(incidences(:,2)==n);
    found3 = find(incidences(:,3)==n);
    borderingElements = [found1;found2;found3];
    avgXstress = mean(stresses([borderingElements],1));
    avgYstress = mean(stresses([borderingElements],2));
    avgShearstress = mean(stresses([borderingElements],3));
    avgSigma1 = mean(stresses([borderingElements],4));
    avgSigma3 = mean(stresses([borderingElements],5));
    avgXstrain = mean(strains([borderingElements],1));
    avgYstrain = mean(strains([borderingElements],2));
    avgShearstrain = mean(strains([borderingElements],3));
    newX = node_coords(n,1)+u_vec(n*2-1);
    newY = node_coords(n,2)+u_vec(n*2);
    displacements(n,:) = [newX newY];
    plot_Edgedata (n,:) = [node_coords(n,1) node_coords(n,2) newX newY avgXstress avgYstress avgShearstress avgSigma1 avgSigma3 avgXstrain avgYstrain avgShearstrain];
end
    plot_Centredata = [x y  stresses(:,1) stresses(:,2) stresses(:,3) stresses(:,4) stresses(:,5) strains(:,1) strains(:,2) strains(:,3)];
    
plotProp=[1,handles.siteAxes,handles.kPa1,handles.kPa2,handles.kPa3,handles.minimum,handles.maximum,handles.average];
%show error
set(handles.error,'String',err);

%calculate values for stress orientation lines
stressTrajectories=zeros(length(incidences(:,1)),8);%[S1x1,S1x2,S1y1,S1y2,S2x1,S2x2,S2y1,S2y2]xn_el
maxstress=max(abs(stresses(:,4))); %finds the maximum of sigma 1
%set the max length as a function of the area of the smallest element
maxLength=sqrt(mean(A));

for i=1:length(incidences(:,1))
        %determine length of each part of the tensor
        S1Length=stresses(i,4)/maxstress*maxLength;
        S3Length=stresses(i,5)/maxstress*maxLength;
        %check for negative stresses and assign 0 length in that case
        if (S1Length<0) 
            S1Length=0;
        end
        if (S3Length<0) 
            S3Length=0;
        end
        %temporary rotation by 90 degrees - debug
        S1dx=S1Length/2*cos(sigma1_angle(i)+pi/2);
        S1dy=S1Length/2*sin(sigma1_angle(i)+pi/2);
        S1X=[centroids(i,1)-S1dx;centroids(i,1)+S1dx];
        S1Y=[centroids(i,2)-S1dy;centroids(i,2)+S1dy];
        S3dx=S3Length/2*cos(sigma1_angle(i));
        S3dy=S3Length/2*sin(sigma1_angle(i));
        S3X=[centroids(i,1)-S3dx;centroids(i,1)+S3dx];
        S3Y=[centroids(i,2)-S3dy;centroids(i,2)+S3dy];
        stressTrajectories(i,:)=[S1X',S1Y',S3X',S3Y'];
end

assignin('base','strains',strains);
assignin('base','stresses',stresses);
assignin('base','sigma1_angle',sigma1_angle);
assignin('base','plot_Centredata',plot_Centredata);
assignin('base','plot_Edgedata',plot_Edgedata);
assignin('base','A',A);
assignin('base','showStressOr',showStressOr);
assignin('base','plotProp',plotProp);
assignin('base','stressTrajectories',stressTrajectories);
assignin('base','displacements',displacements)
assignin('base','edgeBool',edgeBool)

DrawResults(showStressOr,plotProp,edgeBool);

function pickPlot_Callback(hObject, eventdata, handles)
% Controls what happens when a different plot is selected from
% the pull down menu. Different text boxes become available.
%===============================================================

plotSelect=get(hObject,'Value');
showStressOr = evalin('base','showStressOr');
plotProp = evalin('base','plotProp');
plotProp(1)=plotSelect;
%plotProp=[plotSelect,handles.siteAxes,handles.kPa1,handles.kPa2,handles.kPa3,handles.minimum,handles.maximum,handles.average];
DrawResults( showStressOr,plotProp,evalin('base','edgeBool' ))
assignin('base','plotProp',plotProp);


% --- Executes on button press in stressOr.
function stressOr_Callback(hObject, eventdata, handles)

showStressOr=get(hObject,'Value');
plotProp = evalin('base','plotProp');
DrawResults(showStressOr,plotProp,evalin('base','edgeBool' ));
assignin('base','showStressOr',showStressOr);


%Automatically generated code for GUI components
%===============================================================
%===============================================================


function varargout = finiteElementResults_OutputFcn(hObject, eventdata, handles)
% Optional output to Matlab interface
% varargout{1} = handles.output

function selectShape_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function circleCenterx_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function circleRadius_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rectXmax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rectXmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rectYmax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rectYmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function poissons_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function youngs_Callback(hObject, eventdata, handles)

function youngs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function circleCentery_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function defaultNu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function defaultE_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function siteAxes_CreateFcn(hObject, eventdata, handles)
    
function background_CreateFcn(hObject, eventdata, handles)
% axes(hObject)
% imshow('backgroundmat.png')


% --- Executes on selection change in pickPlot.



% --- Executes during object creation, after setting all properties.
function pickPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pickPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function average_CreateFcn(hObject, eventdata, handles)
% hObject    handle to average (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function minimum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minimum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function maximum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maximum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on key press with focus on stressOr and none of its controls.
function stressOr_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stressOr (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uipanel6.
function uipanel6_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel6 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'elementCentres'
        edgeBool = 0;
    case 'nodalAverages'
        edgeBool = 1;
    case 'constantStrain'
        edgeBool = 2;
end
DrawResults( evalin('base','showStressOr'),evalin('base','plotProp'),edgeBool)
assignin('base','edgeBool',edgeBool)


% --- Executes on button press in output.
function output_Callback(hObject, eventdata, handles)
% generate output file upon button click
node_coords = evalin('base','node_coords');
incidences = evalin('base','incidences');
Element_Param = evalin('base','Element_Param');
strains = evalin('base','strains');
stresses = evalin('base','stresses');
Gamma=evalin('base','Gamma');
f_solved=evalin('base','f_solved');
u_solved=evalin('base','u_solved');
err=evalin('base','err');
%calculate centroids
centroids=calcCentrePoints(incidences,node_coords);
[fileName,pathName] = uiputfile('*.txt');
address = strcat(pathName, fileName);
fileID = fopen(address,'w');
%fileID = fopen('Output.txt','w');
fprintf(fileID,'%s\r\n','INCIDENCE_LIST');
fprintf(fileID,'%8s%8s%8s%8s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s%12s\r\n','El-#','Node-i','Node-j','Node-m','Centroid-x','Centroid-y','Stiffness','Poisson','Unit-Wt','x-Strain','y-Strain','xy-Strain','x-Stress','y-Stress','xy-Stress','Sigma-1','Sigma-3' );
for i=1:length(incidences(:,1))
    fprintf(fileID,'%8.0f',i);
    fprintf(fileID,'%8.0f',incidences(i,1));
    fprintf(fileID,'%8.0f',incidences(i,2));
    fprintf(fileID,'%8.0f',incidences(i,3));
    fprintf(fileID,'%12.2f',centroids(i,1));
    fprintf(fileID,'%12.2f',centroids(i,2));
    fprintf(fileID,'%12.3e',Element_Param(i,1));
    fprintf(fileID,'%12.3e',Element_Param(i,2));
    fprintf(fileID,'%12.3e',Gamma);
    fprintf(fileID,'%12.3e',strains(i,1));
    fprintf(fileID,'%12.3e',strains(i,2));
    fprintf(fileID,'%12.3e',strains(i,3));
    fprintf(fileID,'%12.3e',stresses(i,1));
    fprintf(fileID,'%12.3e',stresses(i,2));
    fprintf(fileID,'%12.3e',stresses(i,3));
    fprintf(fileID,'%12.3e',stresses(i,4));
    fprintf(fileID,'%12.3e\r\n',stresses(i,5));
end
fprintf(fileID,'\r\n%s\r\n','NODE_LIST');
fprintf(fileID,'%8s%8s%8s%12s%12s%12s%12s\r\n', 'Node-#', 'x','y','x-Force','y-Force','x-Disp','y-Disp');
for i=1:length(node_coords(:,1))
    fprintf(fileID,'%8.0f',i);
    fprintf(fileID,'%8.0f',node_coords(i,1));
    fprintf(fileID,'%8.0f',node_coords(i,2));
    fprintf(fileID,'%12.3e',f_solved(i*2-1));
    fprintf(fileID,'%12.3e',f_solved(i*2));
    fprintf(fileID,'%12.3e',u_solved(i*2-1));
    fprintf(fileID,'%12.3e\r\n',u_solved(i*2));
end
fprintf(fileID,'\r\n%12s%12.3e','RMS u-ERROR:',err);
fclose(fileID);
