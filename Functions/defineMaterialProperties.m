function varargout = defineMaterialProperties(varargin)
%GUI Initialization -- Automatically generated by Matlab
%===============================================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @defineMaterialProperties_OpeningFcn, ...
                   'gui_OutputFcn',  @defineMaterialProperties_OutputFcn, ...
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

function defineMaterialProperties_OpeningFcn(hObject, eventdata, handles, varargin)
%Set initial state for GUI, and bring in workspace variables
%===============================================================
set(handles.defineRectangle,'visible','off')
set(handles.defineCircle,'visible','off')
set(handles.properties,'visible','off')
set(handles.addLayer,'visible','off')
set(handles.selectShape,'visible','off')
set(handles.defaultNu,'enable','on')
set(handles.defaultE,'enable','on')
set(handles.exitGUI,'enable','off')
handles.counter = 0;
node_coords = evalin('base','node_coords');
incidences = evalin('base','incidences');
handles.Element_Param=zeros(length(incidences),2);

%Draw mesh from main GUI
%===============================================================
axes(handles.siteAxis)
Draw(node_coords,incidences,handles.siteAxis,0,0)
handles.output = hObject;
guidata(hObject, handles);

function selectShape_Callback(hObject, eventdata, handles)
% Controls what happens when a different shape is selected from
% the pull down menu. Different text boxes become available.
%===============================================================

val=get(hObject,'Value');
switch val
    case 1
        set(handles.defineRectangle,'visible','off')
        set(handles.defineCircle,'visible','off')
        set(handles.properties,'visible','off')
        set(handles.addLayer,'visible','off')
    case 2
        set(handles.defineCircle,'visible','off')
        set(handles.defineRectangle,'visible','on')
        set(handles.properties,'visible','on')
        set(handles.addLayer,'visible','on')
    case 3
        set(handles.defineRectangle,'visible','off')
        set(handles.defineCircle,'visible','on')
        set(handles.properties,'visible','on')
        set(handles.addLayer,'visible','on')
end

function addLayer_Callback(hObject, eventdata, handles)
% Controls what happens when the 'Add to Model' button is pushed.
% Stores inputted values, draws shape, assigns values to elements
%===============================================================

%Counter to cycle through colors
if handles.counter == 8
    handles.counter = 1;
else
    handles.counter=handles.counter+1;
end
guidata(hObject, handles);

% Collect material properties
Element_Param=evalin('base','Element_Param');
nue_set = str2double(get(handles.poissons,'String'));
E_set = str2double(get(handles.youngs,'String'))*1e6;
Gamma = str2double(get(handles.unitWeight,'String'))*1e3;
val=get(handles.selectShape,'Value');

% Get global variables from base-ws
node_coords = evalin('base','node_coords');
incidences = evalin('base','incidences');
% Calculate element center points 
ecp = Get_ecp(node_coords,incidences);
axes(handles.siteAxis)
colorList=['k', 'b','g', 'r', 'y', 'm', 'c', 'w'];
% Change Values and draw image
switch val
    case 1
    case 2 % rectangle
        xmax = str2double(get(handles.rectXmax,'String'));
        xmin = str2double(get(handles.rectXmin,'String'));
        ymax = str2double(get(handles.rectYmax,'String'));
        ymin = str2double(get(handles.rectYmin,'String'));
        Element_Param = Change_Param_Rec(xmax,xmin,ymax,ymin,Element_Param,E_set,nue_set,ecp);
        p=patch([xmin,xmin,xmax,xmax],[ymin,ymax,ymax,ymin],colorList(handles.counter));
        set(p,'FaceAlpha',0.25);
    case 3 % circle
        x1 = str2double(get(handles.circleCenterx,'String'));clc
        y1 = str2double(get(handles.circleCentery,'String'));
        radius = str2double(get(handles.circleRadius,'String'));
        theta=linspace(0,2*pi,100);  %<-- Credit to Sadik Hava <sadik.hava@gmail.com> May, 2010
        rho=ones(1,100)*radius;
        [x,y] = pol2cart(theta,rho);
        x=x+x1;
        y=y+y1;
        p=fill(x,y,colorList(handles.counter));
        set(p,'FaceAlpha',0.25);
        Element_Param = Change_Param_Circ(x1,y1,radius,Element_Param,E_set,nue_set,ecp);
end 
%handles.Element_Param=Element_Param;
assignin('base','Element_Param',Element_Param); 
assignin('base','Gamma',Gamma)
guidata(hObject, handles);

function exitGUI_Callback(hObject, eventdata, handles)
defaultNu = str2double(get(handles.defaultNu,'String'));
defaultE = str2double(get(handles.defaultE,'String'))*1e6;
Gamma = str2double(get(handles.unitWeight,'String'))*1e3;
if handles.counter==0
    Element_Param=handles.Element_Param;
    Element_Param=repmat([defaultE,defaultNu],length(handles.Element_Param),1);
    assignin('base','Element_Param',Element_Param);
end
close(handles.figure1)

function setDefaults_Callback(hObject, eventdata, handles)
defaultNu = str2double(get(handles.defaultNu,'String'));
defaultE = str2double(get(handles.defaultE,'String'))*1e6;
Gamma = str2double(get(handles.unitWeight,'String'))*1e3;
assignin('base','Gamma',Gamma)
if defaultE<=0
    msgbox('Young''s Modulus must be greater than zero')
    return
elseif defaultNu < 0 && defaultNu >= 0.5
    msgbox('Poisson''s Ratio must be between 0 and 0.49')
    return
else
    Element_Param=handles.Element_Param;
    Element_Param=repmat([defaultE,defaultNu],length(handles.Element_Param),1);
end
% handles.Element_Param=Element_Param;
assignin('base','Element_Param',Element_Param);
set(handles.defaultNu,'enable','off')
set(handles.defaultE,'enable','off')
set(handles.selectShape,'visible','on')
set(handles.exitGUI,'enable','on')


function reset_Callback(hObject, eventdata, handles)
close(handles.figure1)
defineMaterialProperties
set(handles.exitGUI,'enable','off')
%Automatically generated code for GUI components
%===============================================================
%===============================================================

function varargout = defineMaterialProperties_OutputFcn(hObject, eventdata, handles) 
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

function background_CreateFcn(hObject, eventdata, handles)
axes(hObject)
imshow('backgroundmat.png')

function siteAxis_CreateFcn(hObject, eventdata, handles)

function circleCenterx_Callback(hObject, eventdata, handles)

function circleCentery_Callback(hObject, eventdata, handles)

function circleRadius_Callback(hObject, eventdata, handles)

function rectXmax_Callback(hObject, eventdata, handles)

function rectXmin_Callback(hObject, eventdata, handles)

function rectYmax_Callback(hObject, eventdata, handles)

function rectYmin_Callback(hObject, eventdata, handles)

function poissons_Callback(hObject, eventdata, handles)

function defaultNu_Callback(hObject, eventdata, handles)

function defaultE_Callback(hObject, eventdata, handles)

% function reset_Callback(hObject, eventdata, handles)



function unitWeight_Callback(hObject, eventdata, handles)
% hObject    handle to unitWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of unitWeight as text
%        str2double(get(hObject,'String')) returns contents of unitWeight as a double


% --- Executes during object creation, after setting all properties.
function unitWeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unitWeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function background_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
