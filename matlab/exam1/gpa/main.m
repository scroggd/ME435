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

% Last Modified by GUIDE v2.5 23-Mar-2015 11:16:51

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


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_c1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c1 as text
%        str2double(get(hObject,'String')) returns contents of edit_c1 as a double


% --- Executes during object creation, after setting all properties.
function edit_c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_c2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c2 as text
%        str2double(get(hObject,'String')) returns contents of edit_c2 as a double


% --- Executes during object creation, after setting all properties.
function edit_c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_c3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c3 as text
%        str2double(get(hObject,'String')) returns contents of edit_c3 as a double


% --- Executes during object creation, after setting all properties.
function edit_c3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_c4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c4 as text
%        str2double(get(hObject,'String')) returns contents of edit_c4 as a double


% --- Executes during object creation, after setting all properties.
function edit_c4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c1.
function popupmenu_c1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c1


% --- Executes during object creation, after setting all properties.
function popupmenu_c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    populate_dropdown(hObject);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c2.
function popupmenu_c2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c2


% --- Executes during object creation, after setting all properties.
function popupmenu_c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    populate_dropdown(hObject);

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c3.
function popupmenu_c3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c3


% --- Executes during object creation, after setting all properties.
function popupmenu_c3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    populate_dropdown(hObject);

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_c4.
function popupmenu_c4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_c4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_c4


% --- Executes during object creation, after setting all properties.
function popupmenu_c4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_c4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    populate_dropdown(hObject);

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_update.
function pushbutton_update_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    menus = [handles.popupmenu_c1, handles.popupmenu_c2, handles.popupmenu_c3, handles.popupmenu_c4];
    texts = [handles.edit_c1, handles.edit_c2, handles.edit_c3, handles.edit_c4];
    
    creditsTotal = 0;
    qualityPointsTotal = 0;
    
    for i=1:length(menus)
        [quality_points, credits] = getGradePoints(menus(i), texts(i));
        creditsTotal = creditsTotal + credits;
        qualityPointsTotal = qualityPointsTotal + quality_points;
    end
    
    if creditsTotal == 0
        gpa = 0;
    else
        gpa = qualityPointsTotal/creditsTotal;
    end
    
    set(handles.text_gpa, 'String', sprintf('%4.3f', gpa));
    

function [gradePoints, creditHours] = getGradePoints(popupmenuHandle, editHandle)
popupmenuContents = cellstr(get(popupmenuHandle, 'String'));
gradeString = popupmenuContents{get(popupmenuHandle, 'Value')};
creditHours = str2double(get(editHandle, 'String'));
if strcmp(gradeString, 'A')
    gradePoints = 4 * creditHours;
elseif strcmp(gradeString, 'B+')
    gradePoints = 3.5 * creditHours;
elseif strcmp(gradeString, 'B')
    gradePoints = 3 * creditHours;
elseif strcmp(gradeString, 'C+')
    gradePoints = 2.5 * creditHours;
elseif strcmp(gradeString, 'C')
    gradePoints = 2 * creditHours;
elseif strcmp(gradeString, 'D+')
    gradePoints = 1.5 * creditHours;
elseif strcmp(gradeString, 'D')
    gradePoints = 1 * creditHours;
elseif strcmp(gradeString, 'F')
    gradePoints = 0;
end
    
function populate_dropdown( handle )
%POPULATE_DROPDOWN Summary of this function goes here
%   Detailed explanation goes here
    set(handle, 'String', {'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'});
        