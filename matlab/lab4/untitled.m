function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 12-Apr-2015 20:59:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)

    % Prepare the arm axes
    view(handles.axes_arm, [-50 -50 50]);
    axis(handles.axes_arm, [-10 10 -6 6 -6 8]);
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    
    global animation_position;
    animation_position = [0, 90, 0, -90, 90];

    % Create vertices for all the patches
    makeLink0(handles.axes_arm, [.5 .5 .5]);  % Doesn't move. No handles needed.
    % Save handles to the patch objects.
    % Save references to the vertices of each patch, make points 4x1 not 3x1.
    handles.user.link1Patch = makeLink1(handles.axes_arm, [.9 .9 .9]);
    handles.user.link1Vertices = get(handles.user.link1Patch, 'Vertices')';
    handles.user.link1Vertices(4,:) = ones(1, size(handles.user.link1Vertices,2));
    handles.user.link2Patch = makeLink2(handles.axes_arm, [.9 .9 .9]);
    handles.user.link2Vertices = get(handles.user.link2Patch, 'Vertices')';
    handles.user.link2Vertices(4,:) = ones(1, size(handles.user.link2Vertices,2));,...
    handles.user.link3Patch = makeLink3(handles.axes_arm, [.9 .9 .9]);
    handles.user.link3Vertices = get(handles.user.link3Patch, 'Vertices')';
    handles.user.link3Vertices(4,:) = ones(1, size(handles.user.link3Vertices,2));
    handles.user.link4Patch = makeLink4(handles.axes_arm, [.9 .9 .9]);
    handles.user.link4Vertices = get(handles.user.link4Patch, 'Vertices')';
    handles.user.link4Vertices(4,:) = ones(1, size(handles.user.link4Vertices,2));
    handles.user.link5Patch = makeLink5(handles.axes_arm, [.95 .95 0]);
    handles.user.link5Vertices = get(handles.user.link5Patch, 'Vertices')';
    handles.user.link5Vertices(4,:) = ones(1, size(handles.user.link5Vertices,2));
    
    % End: Code that can go into your GUI's opening function.    
    
    handles.user.connected = false;
    handles.user.connection = 0;
    
    handles.user.animation_speed = 0.2;
    
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to untitled (see VARARGIN)
    
    handles.user.render_timer = timer('BusyMode', 'drop', 'ExecutionMode', 'fixedRate', 'Period', 0.01, 'TimerFcn', {@render, handles});
    handles.user.move_timer = timer('BusyMode', 'queue', 'ExecutionMode', 'fixedRate', 'Period', 0.01, 'TimerFcn', {@tick, handles});
    start(handles.user.render_timer);
    start(handles.user.move_timer);
    
    updateJointsDisplay(handles);
    % Choose default command line output for untitled
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes untitled wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
function tick(~, ~, handles)
    global animation_position;
    
    desired_position = [...
        get(handles.slider_joint1, 'Value'),...
        get(handles.slider_joint2, 'Value'),...
        get(handles.slider_joint3, 'Value'),...
        get(handles.slider_joint4, 'Value'),...
        get(handles.slider_joint5, 'Value')];
    current_position = animation_position;
    
    allowable = ones(5, 1)' * get(handles.slider_speed, 'Value');
    
    diff = min(desired_position - current_position, allowable);
    diff = max(diff, -1*allowable);
    
    animation_position = animation_position + diff;
    
    
function render(~, ~, handles)
    updateArm('unused', handles);

function updateArm(hObject, handles)
    global animation_position;
    % TODO: Make sure the handles.user.jointAngles values are set.

    % TODO: Create the five homogeneous transformation matrices.
    [A1, A2, A3, A4, A5] = makeHomogeneousTransformations(...
        animation_position(1),...
        animation_position(2),...
        animation_position(3),...
        animation_position(4),...
        animation_position(5));

    T0_1 = A1;
    T0_2 = T0_1 * A2;
    T0_3 = T0_2 * A3;
    T0_4 = T0_3 * A4;
    T0_5 = T0_4 * A5;

    % Use the T matricies to transform the patch vertices
    link1verticesWRTground = T0_1 * handles.user.link1Vertices;
    link2verticesWRTground = T0_2 * handles.user.link2Vertices;
    link3verticesWRTground = T0_3 * handles.user.link3Vertices;
    link4verticesWRTground = T0_4 * handles.user.link4Vertices;
    link5verticesWRTground = T0_5 * handles.user.link5Vertices;

    % Update the patches with the new vertices
    set(handles.user.link1Patch,'Vertices', link1verticesWRTground(1:3,:)');
    set(handles.user.link2Patch,'Vertices', link2verticesWRTground(1:3,:)');
    set(handles.user.link3Patch,'Vertices', link3verticesWRTground(1:3,:)');
    set(handles.user.link4Patch,'Vertices', link4verticesWRTground(1:3,:)');
    set(handles.user.link5Patch,'Vertices', link5verticesWRTground(1:3,:)');


    % Optional code (if you want to display the XYZ of the gripper).
    % Update x, y, and z using the gripper (end effector) origin.
    dhOrigin = [0 0 0 1]';
    gripperWRTground = T0_5 * dhOrigin;

function serialWrite(handles, text)
    if(handles.user.connected)
        fprintf(handles.user.connection, text);
    end
    
    fprintf('Serial: %s\n', text);


function updateJointsDisplay(handles)
    v1 = round(get(handles.slider_joint1, 'Value'));
    v2 = round(get(handles.slider_joint2, 'Value'));
    v3 = round(get(handles.slider_joint3, 'Value'));
    v4 = round(get(handles.slider_joint4, 'Value'));
    v5 = round(get(handles.slider_joint5, 'Value'));
    set(handles.text_joint_display, 'String', sprintf('%i %i %i %i %i', v1, v2, v3, v4, v5));
    serialWrite(handles, sprintf('POSITION %i %i %i %i %i', v1, v2, v3, v4, v5));
    serialWrite(handles, sprintf('GRIPPER %i', round(get(handles.slider_gripper, 'Value'))));
    updateArm('unused', handles);
    
function initSlider(hObject, min, max)
    set(hObject, 'Max', max);
    set(hObject, 'Min', min);
    set(hObject, 'SliderStep', [1/(max-min), 10/(max-min)]);
    set(hObject, 'Value', (max+min)/2);

% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_joint1_Callback(hObject, eventdata, handles)
    updateJointsDisplay(handles);
% hObject    handle to slider_joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_joint1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    initSlider(hObject, -90, 90);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint2_Callback(hObject, eventdata, handles)
    updateJointsDisplay(handles);
% hObject    handle to slider_joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_joint2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    initSlider(hObject, 0, 180);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint3_Callback(hObject, eventdata, handles)
    updateJointsDisplay(handles);
% hObject    handle to slider_joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_joint3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    initSlider(hObject, -90, 90);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint5_Callback(hObject, eventdata, handles)
    updateJointsDisplay(handles);
% hObject    handle to slider_joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_joint5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    initSlider(hObject, 0, 180);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_joint4_Callback(hObject, eventdata, handles)
    updateJointsDisplay(handles);
% hObject    handle to slider_joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_joint4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_joint4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    initSlider(hObject, -180, 0);
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_gripper_Callback(hObject, eventdata, handles)
    updateJointsDisplay(handles);
% hObject    handle to slider_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_gripper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_gripper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    initSlider(hObject, -25, 75);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_com_Callback(hObject, eventdata, handles)
% hObject    handle to edit_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_com as text
%        str2double(get(hObject,'String')) returns contents of edit_com as a double


% --- Executes during object creation, after setting all properties.
function edit_com_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_com (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_open.
function pushbutton_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.connection = serial(get(handles.edit_com, 'String'), 'Baudrate', 9600);
    fopen(handles.user.connection);
    handles.user.connected = true;


% --- Executes on button press in pushbutton_close.
function pushbutton_close_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.connected = false;
    handles.user.connection = 0;


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    stop(handles.user.render_timer);
    stop(handles.user.move_timer);
% Hint: delete(hObject) closes the figure
delete(hObject);

3
% --- Executes on slider movement.
function slider_speed_Callback(hObject, eventdata, handles)
% hObject    handle to slider_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
