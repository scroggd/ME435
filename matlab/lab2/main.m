function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 18-Mar-2015 15:50:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);
    handles.user.robot = PlateLoaderSim(0);
    handles.user.move_state = [];

    handles.user.default_times = [60 20 30
    0 30 30
    30 0 30
    30 30 0
    30 20 60];
    set(handles.uitable_delays, 'Data', handles.user.default_times);
    
    %set_image('extended_bars.jpg', handles.axes_bars);
    set_image('robot_background.jpg', handles.axes_background, 0);
    set_image('gripper_closed_no_plate.jpg', handles.axes_gripper, 50);
    set_image('extended_bars.jpg', handles.axes_bars, 50);
    
    guidata(hObject, handles);
    r = handles.user.robot.getStatus();
    update_status(handles, r);
    update_sim_display(handles);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function update_status(handles, disp)
    set(handles.text_status, 'String', disp);

function move_key(handles, hObject, key)
    if(key == 'clr')
        handles.user.move_state = [];
    elseif( length(handles.user.move_state) == 0)
        handles.user.move_state = [key];
    else
        handles.user.move_state = [handles.user.move_state(1), key];
        guidata(hObject, handles);
        update_move_status(handles);
        
        r = handles.user.robot.movePlate(handles.user.move_state(1), handles.user.move_state(2));
        update_status(handles, r);
        update_sim_display(handles);
        handles.user.move_state = [];
        
        
    end
    update_move_status(handles);
    guidata(hObject, handles);
    
function update_move_status(handles)
    if(length(handles.user.move_state) == 0)
        disp = '';
    elseif(length(handles.user.move_state) == 1)
        disp = sprintf('Move from %i to ?', handles.user.move_state(1));
    else
        disp = sprintf('Moving from %i to %i', handles.user.move_state(1), handles.user.move_state(2));
    end
    
    set(handles.text_move_status, 'String', disp);
    
function update_sim_display(handles)
    xPos = handles.user.robot.xAxisPosition/6 - 0.05;
    
    if(handles.user.robot.isZAxisExtended)
        yPos = 0.3;
    else
        yPos = 0.7;
    end
    
    move_image(handles.axes_gripper, xPos, yPos);
    
    if(handles.user.robot.isGripperClosed)
        if(handles.user.robot.isPlatePresent)
            set_image('gripper_with_plate.jpg', handles.axes_gripper, 0);
        else
            set_image('gripper_closed_no_plate.jpg', handles.axes_gripper, 0);
        end
    else
        set_image('gripper_open_no_plate.jpg', handles.axes_gripper, 0);
    end
    
    if(handles.user.robot.isZAxisExtended)
        move_image(handles.axes_bars, xPos, 0.40);
    else
        move_image(handles.axes_bars, 1, 1);
    end
    
    
function shake(handles)
    inp = inputdlg({'Position', 'Iterations'});
    xaxis = str2num(char(inp(1)));
    reps = str2num(char(inp(2)));
    
    r = handles.user.robot.open();
    r = handles.user.robot.retract();
    r = handles.user.robot.x(xaxis);
    r = handles.user.robot.extend();
    r = handles.user.robot.close();
    r = handles.user.robot.retract();
    for i=1:reps
        r = handles.user.robot.extend();
        r = handles.user.robot.retract();
    end
    r = handles.user.robot.open();
    r = handles.user.robot.getStatus();
    update_status(handles, r);
    update_sim_display(handles);
    
        
        
        
% --- Executes on button press in pushbutton_xaxis_1.
function pushbutton_xaxis_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_xaxis_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.x(1);
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_xaxis_2.
function pushbutton_xaxis_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_xaxis_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.x(2);
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_xaxis_3.
function pushbutton_xaxis_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_xaxis_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
    r = handles.user.robot.x(3);
    update_status(handles, r);
    update_sim_display(handles);
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_xaxis_4.
function pushbutton_xaxis_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_xaxis_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.x(4);
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_xaxis_5.
function pushbutton_xaxis_5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_xaxis_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.x(5);
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_retract.
function pushbutton_retract_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_retract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.retract();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_extend.
function pushbutton_extend_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_extend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.extend();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_release.
function pushbutton_release_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_release (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.open();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_grip.
function pushbutton_grip_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_grip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.close();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.reset();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_move_1.
function pushbutton_move_1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_move_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pushbutton_move_2.
    move_key(handles, hObject, 1);


function pushbutton_move_2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_move_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    move_key(handles, hObject, 2);


% --- Executes on button press in pushbutton_move_3.
function pushbutton_move_3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_move_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    move_key(handles, hObject, 3);


% --- Executes on button press in pushbutton_move_4.
function pushbutton_move_4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_move_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    move_key(handles, hObject, 4);


% --- Executes on button press in pushbutton_move_5.
function pushbutton_move_5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_move_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    move_key(handles, hObject, 5);


% --- Executes on button press in pushbutton_move_clr.
function pushbutton_move_clr_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_move_clr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    move_key(handles, hObject, 'clr');


% --- Executes on button press in pushbutton_status.
function pushbutton_status_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    r = handles.user.robot.getStatus();
    update_status(handles, r);
    update_sim_display(handles);



function edit_com_select_Callback(hObject, eventdata, handles)
% hObject    handle to edit_com_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_com_select as text
%        str2double(get(hObject,'String')) returns contents of edit_com_select as a double


% --- Executes during object creation, after setting all properties.
function edit_com_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_com_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_com_open.
function pushbutton_com_open_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_com_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    port = str2num(char(get(handles.edit_com_select, 'String')));
    handles.user.robot = PlateLoader(port);
    guidata(hObject, handles);
    r = handles.user.robot.getStatus();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_com_close.
function pushbutton_com_close_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_com_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.robot = PlateLoaderSim(0);
    guidata(hObject, handles);
    r = handles.user.robot.getStatus();
    update_status(handles, r);
    update_sim_display(handles);


% --- Executes on button press in pushbutton_delays_set.
function pushbutton_delays_set_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_delays_set (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data = get(handles.uitable_delays, 'Data');
    handles.user.robot.setTimeValues(horzcat(zeros(5, 1), data, zeros(5, 1)));
    r = handles.user.robot.getStatus();
    update_status(handles, r);


% --- Executes on button press in pushbutton_delays_reset.
function pushbutton_delays_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_delays_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    handles.user.robot.resetDefaultTimes();
    set(handles.uitable_delays, 'Data', handles.user.default_times);
    r = handles.user.robot.getStatus();
    update_status(handles, r);


% --- Executes during object creation, after setting all properties.
function text_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_shake.
function pushbutton_shake_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_shake (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    shake(handles);
