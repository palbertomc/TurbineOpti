% TurbineOpti
% Copyright (C) 2019  J. Bergh
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program. If not, see <http://www.gnu.org/licenses/>.

function varargout = TurbineOpti(varargin)

% TURBINEOPTI MATLAB code for TurbineOpti.fig
%      TURBINEOPTI, by itself, creates a new TURBINEOPTI or raises the existing
%      singleton*.
%
%      H = TURBINEOPTI returns the handle to a new TURBINEOPTI or the handle to
%      the existing singleton*.
%
%      TURBINEOPTI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TURBINEOPTI.M with the given input arguments.
%
%      TURBINEOPTI('Property','Value',...) creates a new TURBINEOPTI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TurbineOpti_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TurbineOpti_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TurbineOpti

% Last Modified by GUIDE v2.5 16-Oct-2014 16:46:04

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TurbineOpti_OpeningFcn, ...
                   'gui_OutputFcn',  @TurbineOpti_OutputFcn, ...
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before TurbineOpti is made visible.
function TurbineOpti_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TurbineOpti (see VARARGIN)

%clc;

% Choose default command line output for TurbineOpti
handles.output = hObject;

% Set handles for main global and local optimisation loops
handles.stop_now = 0;
handles.iga = 0;

handles.previous_run = 0;
handles.hifilocaloptimisation = 0;

set(handles.pushbutton24,'String','DE');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TurbineOpti wait for user response (see UIRESUME)
% uiwait(handles.TurbineOpti);

% --- Outputs from this function are returned to the command line.
function varargout = TurbineOpti_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Turbine / CFD parameters

function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

handles.R0 = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

str = get(hObject,'String');
val = get(hObject,'Value');

switch str{val};
    case 'rotor'
        handles.bladetype = 'rotor';
        set(handles.text40,'String','0.202');
        set(handles.text41,'String','20');
    case 'NGV'
        handles.bladetype = 'NGV';
        set(handles.text40,'String','0.2025');
        set(handles.text41,'String','30');
    case 'S2'
        handles.bladetype = 'S2';
        set(handles.text40,'String','0.2025');
        set(handles.text41,'String','30');
end

handles.blade_height = str2double(get(handles.text40,'String'));
handles.no_blades = str2double(get(handles.text41,'String'));
handles.blade_angle = (360/(handles.no_blades*2));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double

handles.RPM = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

handles.V_inlet = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double

handles.T_ref = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double

handles.P_ref = str2double(get(hObject,'String'));
handles.operating_pressure = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, ~, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double

handles.torque_corr = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double

handles.t_model = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

str = get(hObject,'String');
val = get(hObject,'Value');
handles.endwall_type = str(val);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set miscellaneous defaults
set(handles.edit12,'String','0.142');
set(handles.edit16,'String','2300');
set(handles.edit18,'String','21.38');
set(handles.edit19,'String','25');
set(handles.edit20,'String','86431');
set(handles.edit21,'String','-1.67');
set(handles.edit22,'String','k-omega SST');
set(handles.edit1,'String','/home/jonathan/Dropbox/linux_code_gui/');
set(handles.edit4,'String','/home/jonathan/Desktop/test/');
set(handles.edit2,'String','/home/jonathan/Dropbox/linux_code_gui/turbine_data/');
set(handles.edit3,'String','/home/jonathan/Dropbox/linux_code_gui/reference/');
set(handles.edit6,'String','45');
set(handles.edit7,'String','1');
set(handles.edit8,'String','0.5');
set(handles.edit9,'String','3.5');
set(handles.edit11,'String','4');
set(handles.edit28,'String','150');
set(handles.edit29,'String','0');
set(handles.edit39,'String','1');
set(handles.edit30,'String','100');
set(handles.edit40,'String','jonathan');
set(handles.edit42,'String','16');
set(handles.edit41,'String','1');
set(handles.edit31,'String','');

set(handles.edit51,'String','10000');
set(handles.edit52,'String','2.5e-9');
set(handles.edit53,'String','100');

% Set default blade type (rotor,blade_height,no_blades)
set(handles.popupmenu1,'Val',2);
set(handles.text40,'String','0.202');
set(handles.text41,'String','20');

% Set default endwall type (annular)
set(handles.popupmenu3,'Val',2);

% Set default variogram (gaussian, ph=-2- NB. changed to 1.9)
set(handles.popupmenu6,'Val',2);
set(handles.text39,'String','1.9');

% Set default optimiser type (Differential Evolution)
set(handles.popupmenu8,'Val',2);

% Set default kriging model optimiser algorithm
set(handles.pushbutton24,'String','DE');

% Load variables with defaults
handles.R0 = str2double(get(handles.edit12,'String'));
handles.RPM = str2double(get(handles.edit16,'String'));
handles.V_inlet = str2double(get(handles.edit18,'String'));
handles.T_ref = str2double(get(handles.edit19,'String'));
handles.P_ref = str2double(get(handles.edit20,'String'));
handles.operating_pressure = str2double(get(handles.edit20,'String'));
handles.torque_correction = str2double(get(handles.edit21,'String'));
handles.t_model = get(handles.edit22,'String');
handles.base_dir = get(handles.edit1,'String');
handles.work_dir = get(handles.edit4,'String');
handles.turbine_dir = get(handles.edit2,'String');
handles.reference_data_directory = get(handles.edit3,'String');
handles.maxphase = str2double(get(handles.edit6,'String'));
handles.harmonicshi = str2double(get(handles.edit7,'String'));
handles.harmonicslo = str2double(get(handles.edit8,'String'));
handles.heighthi = str2double(get(handles.edit9,'String'));
handles.no_lines = str2double(get(handles.edit11,'String'));
handles.maxit = str2double(get(handles.edit28,'String'));
handles.mincost = str2double(get(handles.edit29,'String'));
handles.span_avg = str2double(get(handles.edit30,'String'));
handles.Ph = str2double(get(handles.text39,'String'));
handles.blade_height = str2double(get(handles.text40,'String'));
handles.no_blades = str2double(get(handles.text41,'String'));
handles.wake_tolerance = str2double(get(handles.edit39,'String'));
handles.username = get(handles.edit40,'String');
handles.ncores = str2double(get(handles.edit42,'String'));
handles.CFDcostfuncno = str2double(get(handles.edit41,'String'));
handles.kriging_data_dir = get(handles.edit31,'String');
handles.kriging_theta_dir = get(handles.edit45,'String');
handles.kriging_fitting_iterations = str2double(get(handles.edit33,'String'));

handles.localoptimisermaxit = str2double(get(handles.edit51,'String'));
handles.NM_tolerance = str2double(get(handles.edit52,'String'));
handles.local_span_avg = str2double(get(handles.edit53,'String'));

str = get(handles.popupmenu1,'String');
val = get(handles.popupmenu1,'Val');
handles.blade_type = str{val};
handles.blade_angle = (360/(handles.no_blades*2));

str = get(handles.popupmenu3,'String');
val = get(handles.popupmenu3,'Val');
handles.endwall_type = str{val};

str = get(handles.popupmenu6,'String');
val = get(handles.popupmenu6,'Val');
handles.variogram_type = str{val};

str = get(handles.popupmenu8,'String');
val = get(handles.popupmenu8,'Val');
handles.optimiser_type = str{val};

str = get(handles.pushbutton24,'String');
handles.optimiseMLEtype = str;

handles.previous_run = 0;
handles.hifilocaloptimisation = 0;

%handles.f = ones(75,1);

% Save handles struct
guidata(hObject,handles);

%END - Turbine / CFD parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%WORKING DIRECTORIES

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.base_dir = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

handles.turbine_dir = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

handles.reference_data_dir = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

handles.work_dir = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (exist(handles.work_dir,'dir'))
    
    cd(handles.work_dir);
    
else
    
    mkdir(handles.work_dir);
    cd(handles.work_dir);
    
end

%END - Working directories
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Endwall parameters

function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

handles.maxphase = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

handles.harmonicshi = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double

handles.harmonicslo = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

handles.heighthi = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double

handles.no_lines = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%END - Endwall parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Optimiser parameters

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8

str = get(handles.popupmenu8,'String');
val = get(handles.popupmenu8,'Val');
handles.optimiser_type = str{val};

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles,'optimiser_type')
    
    warndlg('Warning - No optimiser selected','Warning');

elseif (strcmp(handles.optimiser_type,'DE') == 1)

    dlg_title = 'DE parameters';
    prompt = {'Population size','Scaling factor (F)','Crossover probability (Cr)','EIfunc'};
    def = {'48','0.8','0.8','costfuncEI1'};
    optinput = inputdlg(prompt,dlg_title,1,def);
    
    handles.popsize = str2double(optinput{1});
    handles.F = str2double(optinput{2});
    handles.Cr = str2double(optinput{3});
    handles.EIfunc = optinput{4};

    set(handles.edit44,'String',sprintf('Popsize: %g \tF: %g \nCr: %g \t\tEI: %s',handles.popsize,handles.F,handles.Cr,handles.EIfunc));

elseif (strcmp(handles.optimiser_type,'GA') == 1)
    
    dlg_title = 'GA parameters';
    prompt = {'Population size','Mutation rate','Selection rate','Selection routine','EIfunc'};
    def = {'48','0.2','0.5','artificial','costfuncWB2'};
    optinput = inputdlg(prompt,dlg_title,1,def);
    
    handles.popsize = str2double(optinput{1});
    handles.mutation_rate = str2double(optinput{2});
    handles.selection_rate = str2double(optinput{3});
    handles.selection_routine = optinput{4};
    handles.EIfunc = optinput{5};
    
    set(handles.edit44,'String',sprintf('Popsize: %g \tMutrate: %g \nSelec rate: %g \nSelec type: %s \tEI: %s',handles.popsize,handles.mutation_rate,...
        handles.selection_rate,handles.selection_routine,handles.EIfunc));
else
    
    warndlg('Warning - Unknown optimiser type','Warning');

end

guidata(hObject,handles);

function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double

handles.maxit = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double

handles.mincost = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double

handles.span_avg = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%END - Optimser parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - RUN menu

% --- Executes when selected object is changed in uipanel10.
function uipanel10_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel10 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag')
    case 'radiobutton3'
        handles.previous_run = 0;
        set(handles.edit38,'BackgroundColor',[0.702 0.702 0.702]);
        set(handles.edit38,'String','');
        handles.iga = 0;
    case 'radiobutton4'
        handles.previous_run = 1;
        set(handles.edit38,'BackgroundColor',[1 1 1]);
        input = inputdlg('Generation to start from','Start Generation',1,{'0'});
        set(handles.edit38,'String',input);      
        handles.iga = str2double(input);
end

guidata(hObject,handles);

function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double

handles.iga = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTER MAIN ROUTINE CODE HERE

% Set misc variables
minc = 99999; meanc = 99999;

% Create local variables for guidata variables for use in optimisation loop
X = handles.X; Y = handles.Y;
theta = handles.theta; f = handles.f;
Ph = handles.Ph; popsize = handles.popsize;
Cr = handles.Cr; F = handles.F; EIfunc = handles.EIfunc;
iters = 0; dbmax = handles.dbmax;

% Construct required model structs
endwall_model = struct('maxphase',handles.maxphase,'harmonicshi',handles.harmonicshi,'harmonicslo',...
                        handles.harmonicslo,'heighthi',handles.heighthi,'no_lines',handles.no_lines,...
                        'npar',handles.npar,'endwall_type',handles.endwall_type);

blade_model = struct('blade_type',handles.blade_type,'R0',handles.R0,'no_blades',handles.no_blades,...
                        'blade_max',handles.blade_height,'blade_angle',handles.blade_angle);

cfd_model = struct('operating_pressure',handles.operating_pressure,'torque_correction',handles.torque_correction,...
                    'T_ref',handles.T_ref,'P_ref',handles.P_ref,'V_inlet',handles.V_inlet,'t_model',handles.t_model,...
                    'span_avg',handles.span_avg,'wake_tolerance',handles.wake_tolerance,'RPM',handles.RPM);

dir_model = struct('work_dir',handles.work_dir,'turbine_dir',handles.turbine_dir,...
                    'reference_data_directory',handles.reference_data_directory,'base_dir',handles.base_dir);

resource_model = struct('username',handles.username,'CFDcostfuncno',handles.CFDcostfuncno,...
                        'ncores',handles.ncores);

fmodel = struct('maxit',handles.kopt_maxit,'npar',handles.npar,...
    'varhi',handles.kopt_varhi,'varlo',handles.kopt_varlo,...
    'popsize',handles.kopt_popsize,'Ph',handles.Ph,'X',handles.X,...
    'Y',handles.Y,'f',handles.f,'objfunc',@costfunclogMLE);

% Get plot axes for various plots
axes(handles.axes1); a1 = gca; grid on;
axes(handles.axes3); a3 = gca; grid on;
axes(handles.axes4); a4 = gca; grid on;
axes(handles.axes5); a5 = gca; grid on;
axes(handles.axes6); a6 = gca; grid on;
axes(handles.axes7); a7 = gca; grid on;

GUIhandles = ancestor(hObject,'figure');

% Calculate initial kriging model parameters
A = calcXK(X);
R = calcRrevised(A,theta,Ph);
beta = calcBeta(f,R,Y);
        
if (strcmp(handles.optimiser_type,'DE') == 1)
    
    % Run DE routine
    
    if (handles.previous_run == 1)
        
        %Starting iga is the last full iteration run i.e. start from run xx
        iga = handles.iga;
        minY = handles.minY;
                
    else
        iga = 0;
        minY = [];
    end
   
    while (iga < handles.maxit)
        
        % Check for BREAK buttom push (by reloading handles.stop_now)
        handles = guidata(hObject);
       
        if (handles.stop_now == 1)
            break
        end
        
        % Initialise
        iga = iga + 1;
        x = generatePar8(endwall_model,popsize);
        
        % Reset inner loop counter
        inner_loop_iterations = 0;
        
        % Start inner loop optimisation
        while (inner_loop_iterations <= 5000)
            
            % Run inner iterations
            v = mutateVec(x,F);
            u = crossOver(v,x,Cr);
            [x,y] = selectVec(EIfunc,u,x,X,Y,theta,Ph,R,beta,f,endwall_model);
            
            % Check inner loop convergence
            if ((inner_loop_iterations > 1000) && (abs(max(y) - min(y))/abs(max(y) + eps) * 100) <= 1)                     
                break;          
            end
            inner_loop_iterations = inner_loop_iterations + 1;
        end
        
        % Extract minimum vector and check constraints satisifed
        [~,yind] = min(y);
        xopt = x(yind,:);

        c_flag = checkConstraints8(endwall_model,xopt);
        
        if (c_flag == 1)
            
            set(handles.txtInfo,'String',sprintf('Inner loop iterations: %g \n\tConstraint(s) violated',inner_loop_iterations));
            fprintf('Inner loop iterations: %g \n\tConstraint(s) violated',inner_loop_iterations);     
            
        else
            
            set(handles.txtInfo,'String',sprintf('Inner loop iterations: %g \n\tAll constraint(s) satisfied',inner_loop_iterations));
            fprintf('Inner loop iterations: %g \n\tAll constraint(s) satisfied',inner_loop_iterations);    
            
        end
        
        % Run meshing and CFD routines
        createGeometry8normal(blade_model,dir_model,resource_model,xopt,iga,GUIhandles);
        [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model,GUIhandles);

        if ((meshstatus == 1) || (cfdstatus == 1))
            [~,hostname] = system('hostname');
            sendMail('bergh.jonathan@gmail.com','Mesh or CFD failed',sprintf('Either the mesher or CFD run has failed on %s',hostname));
            set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
            fprintf('\nManually create mesh and/or run CFD simulation\n');
            pause;
        end
       
        [newX,newY,unsteady] = processModel(cfd_model,blade_model,endwall_model,dir_model,xopt,iga,resource_model.CFDcostfuncno,GUIhandles);
        
        if (unsteady == 1)    
            [~,hostname] = system('hostname');
            sendMail('bergh.jonathan@gmail.com','UNSTEADINESS DETECTED',sprintf('CFD run has produced an unsteady result on %s',hostname));
            set(handles.txtInfo,'String','NB. CFD run has produced an unsteady result - please check workspace');
            fprintf('\nPlease manually inspect unsteady CFD result\n');
            pause;
        end
        
        cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
        
        % Rebuild kriging database
        [X,Y] = addData(X,Y,newX,newY);
        
        % Rebuild fmodel database
        f = fxConstant(X);        
        fmodel.f = f;
        fmodel.X = X;
        fmodel.Y = Y;
        
        % Refit kriging model
        if (handles.optimiseMLEtype == 'GA')
    
            [theta,MLE,k_iga,telapsed] = optimiseMLEGA(fmodel,GUIhandles);
    
        else
    
            [theta,MLE,k_iga,telapsed] = optimiseMLEDE(fmodel,0.0001,GUIhandles);
    
        end
                        
        % Crossvalidate
        [y,stdR] = crossValidate(X,Y,theta,Ph,f);
        [RMSE,max_error] = calcMSE(y(:,1),Y);

        % Re-calculate kriging model
        A = calcXK(X);
        [R,condR] = calcRrevised(A,theta,Ph);
        beta = calcBeta(f,R,Y);

        % Write fit info to screen
        set(handles.text47,'String',max_error);
        set(handles.text48,'String',RMSE);
        set(handles.txtInfo,'String',sprintf('Fitting results ... \n    IGA: %g \n    MLE: %g \n    Telapsed: %.2f secs\n    cond(R): %g (cond(R) -> inf = bad)\n\n    Theta: %s'...
                             ,k_iga,MLE,telapsed,condR,mat2str(theta,8)));
                         
        fprintf('\nFitting results ... \n    IGA: %g \n    MLE: %g \n    Telapsed: %.2f secs\n    cond(R): %g (cond(R) -> inf = bad)\n\n Theta: %s'...
                             ,k_iga,MLE,telapsed,condR,mat2str(theta,8));

        % Plot diagnostics
        % Predicted y vs Actual Y
        axes(handles.axes6);
        plot(y,Y,'ob',linspace(min(min(y),min(Y)),max(max(y),max(Y)),100),linspace(min(min(y),min(Y)),max(max(y),max(Y)),100),'-k');
        axis([min(min(y),min(Y)) max(max(y),max(Y)) min(min(y),min(Y)) max(max(y),max(Y))]);
        xlabel('Predicted y'); ylabel('Actual Y');
        grid on;

        % Standardised residual
        axes(handles.axes4);
        plot(y,stdR,'ob',linspace(min(min(y),min(Y)),max(max(y),max(Y)),2),[3 3],'--b',linspace(min(min(y),min(Y)),max(max(y),max(Y)),2),[-3 -3],'--b');
        axis([min(min(y),min(Y)) max(max(y),max(Y)) min(min(stdR),-3.5) max(max(stdR),3.5)]);
        xlabel('Predicted y'); ylabel('Standardised Residual');
        grid on;

        % Q-Q plot
        axes(handles.axes5);
        ystdR = sort(stdR); x = calcQPos(ystdR); x = calcNormInv(x);
        plot(x,ystdR,'ob',linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),'-k');
        axis([min(min(x),min(ystdR)) max(max(x),max(ystdR)) min(min(x),min(ystdR)) max(max(x),max(ystdR))]);
        xlabel('Standard Normal Quantile'); ylabel('Standardised Residual');
        grid on;
        
        % Calculate data base statistics
        [Yopt,~] = min(Y(dbmax+1:end));
        
        % Plot overall optimisation progress
        axes(handles.axes1);
        minY(iga) = Yopt; iters = 1:1:iga;
        plot(iters,minY,'o-b');
        xlabel('Outer iterations'); ylabel('Objective function');
        grid on;
        
        % Check outer loop convergence
        if ((abs(min(y)) / abs(min(Y))) * 100 <= 0.1)                
            break;         
        end
        
        % Save temp XY and theta data files %% To save us from load shedding
        save(sprintf('XY_temp'),'X','Y','minY','dbmax');
        save(sprintf('thetas_temp'),'theta');
        
    end
    
elseif (strcmp(handles.optimiser_type,'GA') == 1)
    
    % Run GA routine
      
    warndlg('GA optimisation code not implemented, choose another optimiser');
%     if (datalink == 1)
%         import
%     end
%     curve(par,popsize)
%     run(popsize)
%     importfile(popsize)
%     if (datalink ==1)
%         export
%     end
%     mutate(popsize)
%     cleanup(popsize)
    
else
   
    % DO NOTHING
    
end

% Update / reset handles parameters
handles.X = X;
handles.Y = Y;
handles.f = f;
handles.theta = theta;
handles.iga = iga;
handles.stop_now = 0;
handles.minY = minY;

% Save handles data
guidata(hObject,handles);

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.stop_now = 1;

% Save guidata
guidata(hObject,handles);

%END - RUN menu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Start - LOCAL OPTIMISER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Local optimisation controls

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dlg_title = 'NM parameters';
prompt = {'Reflection (rho)','Shrinkage (sigma)','Constraction (gamma)','Expansion (psi)','Vertex scaling constant (C)'};
def = {'1','0.5','0.5','2','0.1'};
localoptinput = inputdlg(prompt,dlg_title,1,def);

handles.rho = str2double(localoptinput{1});
handles.sigma = str2double(localoptinput{2});
handles.gamma = str2double(localoptinput{3});
handles.psi = str2double(localoptinput{4});
handles.C = str2double(localoptinput{5});

set(handles.edit50,'String',sprintf('Rho: %g \t\tSigma: %g \nGamma: %g \tPsi: %g\nC: %g',handles.rho,handles.sigma,handles.gamma,handles.psi,handles.C));

guidata(hObject,handles);

function edit51_Callback(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit51 as text
%        str2double(get(hObject,'String')) returns contents of edit51 as a double

handles.localoptimisermaxit = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit52_Callback(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit52 as text
%        str2double(get(hObject,'String')) returns contents of edit52 as a double

handles.NM_tolerance = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double

handles.local_span_avg = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in uipanel19.
function uipanel19_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel19 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

switch get(eventdata.NewValue,'Tag')
    case 'radiobutton5'
        handles.hifilocaloptimisation = 0;
    case 'radiobutton6'
        handles.hifilocaloptimisation = 1;
end

guidata(hObject,handles);

% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Construct required model structs
endwall_model = struct('maxphase',handles.maxphase,'harmonicshi',handles.harmonicshi,'harmonicslo',...
                        handles.harmonicslo,'heighthi',handles.heighthi,'no_lines',handles.no_lines,...
                        'npar',handles.npar,'endwall_type',handles.endwall_type);

blade_model = struct('blade_type',handles.blade_type,'R0',handles.R0,'no_blades',handles.no_blades,...
                        'blade_max',handles.blade_height,'blade_angle',handles.blade_angle);

cfd_model = struct('operating_pressure',handles.operating_pressure,'torque_correction',handles.torque_correction,...
                    'T_ref',handles.T_ref,'P_ref',handles.P_ref,'V_inlet',handles.V_inlet,'t_model',handles.t_model,...
                    'span_avg',handles.span_avg,'wake_tolerance',handles.wake_tolerance,'RPM',handles.RPM);

dir_model = struct('work_dir',handles.work_dir,'turbine_dir',handles.turbine_dir,...
                    'reference_data_directory',handles.reference_data_directory,'base_dir',handles.base_dir);

resource_model = struct('username',handles.username,'CFDcostfuncno',handles.CFDcostfuncno,...
                        'ncores',handles.ncores);
                    
NM_model = struct('rho',handles.rho,'sigma',handles.sigma,...
                  'gamma',handles.gamma,'psi',handles.psi,'npar',handles.npar);
                    
%%% MAIN Nelder-Mead ROUTINE - START
GUIhandles = ancestor(hObject,'figure');

% Create local variables for guidata variables for use in optimisation loop
X = handles.X; Y = handles.Y;
theta = handles.theta; f = handles.f;
Ph = handles.Ph; minY = handles.minY;
dbmax = handles.dbmax;

% Calculate initial kriging model parameters
A = calcXK(X);
R = calcRrevised(A,theta,Ph);
beta = calcBeta(f,R,Y);

% Generate starting simplex for best vector in 'X'
[~,ind] = min(minY); simplex = zeros(handles.npar+1,handles.npar);
for row=1:1:handles.npar+1
  simplex(row,:) = transpose(X(:,dbmax+ind));               		
end

vector_matrix = ones(handles.npar+1,handles.npar);
vector_matrix(2:handles.npar+1,:) = vector_matrix(2:handles.npar+1,:) + handles.C*eye(handles.npar);
simplex = simplex.*vector_matrix;

% Find last generation no. (i.e. iga) in work_dir
for i = 1:5000
    if (~(exist(sprintf('Generation_%.1f',i),'dir')));
        iga = i-1;
        break;
    end   
end

% Calculate cost of starting simplex
iga = iga + 1;
fprintf('\n*** Generation: %.1f **********************************************************\n',iga);
fprintf('\nCalculating cost of starting simplex ... \n');
    
if (handles.hifilocaloptimisation == 1)
           
    for count = 1:1:handles.npar+1
        
        c_flag = checkConstraints8(endwall_model,simplex(count,:));
        createGeometry8(blade_model,dir_model,resource_model,simplex(count,:),iga+count/10,GUIhandles); 
        [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga+count/10,resource_model,GUIhandles);

        if ((meshstatus == 1) || (cfdstatus == 1))
            sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
            set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
            fprintf('\nManually create mesh and/or run CFD simulation\n');
            pause;
        end

        [~,fsimplex(count,1)] = processModel(cfd_model,blade_model,endwall_model,dir_model,simplex(count,:),iga+count/10,resource_model.CFDcostfuncno,GUIhandles);     
        cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
            
        if (c_flag == 1)
            
            fsimplex(count,1) = fsimplex(count,1)^2;
            
        end

    end
else
    for count = 1:1:handles.npar+1

        c_flag = checkConstraints8(endwall_model,simplex(count,:));
                                       
        r = calcRvec(simplex(count,:)',X,theta,Ph);
        [fsimplex(count,1),~] = predict(r,R,Y,beta,f);
        
        if (c_flag == 1)
            
            fsimplex(count,1) = fsimplex(count,1)^2;
            
        end
    end
end

fsimplex

% Records no of initial function evaluations and iteration no.
nfeval = handles.npar + 1; iteration = 1;

% Calculate simplex costs and statistics
minf(iteration) = min(fsimplex);        
mean = 0; num = 0;

for counter = 1:1:(handles.npar+1) 
    mean = mean + fsimplex(counter,1);
    num = num + 1;
end

meanf(iteration) = mean / num;

% Sort starting simplex vertices by cost
[fsimplex,index] = sort(fsimplex)   
simplex = simplex(index,:);
    
% Start iterations
converged = 0; diverged = 0;
while (~(converged) && ~(diverged))
    
    iga = iga + 1;
    fprintf('\n*** Generation: %.1f Trying reflection ****************************************\n',iga);
    
    % Start with Reflection
    x_r = simplexReflection(simplex,NM_model);
    
    if (handles.hifilocaloptimisation == 1) 
    
        createGeometry8(blade_model,dir_model,resource_model,x_r,iga,GUIhandles); 
        c_flag = checkConstraints8(endwall_model,x_r);
        
        [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model,GUIhandles);

        if ((meshstatus == 1) || (cfdstatus == 1))
            sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
            set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
            fprintf('\nManually create mesh and/or run CFD simulation\n');
            pause;
        end

        [x_r,f_r] = processModel(cfd_model,blade_model,endwall_model,dir_model,x_r,iga,resource_model.CFDcostfuncno,GUIhandles);
        cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
        
        if (c_flag == 1)            
            
            f_r = f_r^2;
            
        end
        
    else
        
        c_flag = checkConstraints8(endwall_model,x_r);
                
        r = calcRvec(x_r',X,theta,Ph);
        [f_r,~] = predict(r,R,Y,beta,f);
        
        if (c_flag == 1)
            
            f_r = f_r^2;
            
        end     
    end
    
    % Increment nfeval counter
    nfeval = nfeval + 1;                    
          
    % Test reflection point, accept if between fsimplex(1) and fsimplex(npar)
    if ((fsimplex(1) <= f_r) && (f_r <= fsimplex(handles.npar)))
              
       iteration = iteration + 1;
       
       fprintf('\nREFLECTION ... ');
       fprintf('\nVertex cost: %.4f\n',f_r);
       
       simplex(handles.npar+1,:) = x_r
       fsimplex(handles.npar+1) = f_r
       
       % Calculate simplex costs and stats
       minf(iteration) = min(min(f_r),min(minf));
       mean = 0; num = 0;

       for counter=1:1:(handles.npar)
       
           mean = mean + fsimplex(counter,1);
           num = num + 1;
           
       end

       meanf(iteration) = (mean + f_r) / (num + 1);
              
    % If cost of reflection is smaller than cheapest vertex point, try simplex expansion
    elseif (f_r < fsimplex(1))           
       
       iga = iga + 1;
       fprintf('\n*** Generation: %.1f Trying expansion *****************************************\n',iga);

       % Expansion
       x_e = simplexExpansion(simplex,NM_model);  % compute expansion vertex
        
       if (handles.hifilocaloptimisation == 1)
                     
           createGeometry8(blade_model,dir_model,resource_model,x_e,iga,GUIhandles); 
           c_flag = checkConstraints8(endwall_model,x_e);       
               
           [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model,GUIhandles);

           if ((meshstatus == 1) || (cfdstatus == 1))
                sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
                set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
                fprintf('\nManually create mesh and/or run CFD simulation\n');
                pause;
           end

           [x_e,f_e] = processModel(cfd_model,blade_model,endwall_model,dir_model,x_e,iga,resource_model.CFDcostfuncno,GUIhandles);
           cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
           
           if (c_flag == 1)
                               
               f_e = f_e^2;
               
           end
          
       else
           
           c_flag = checkConstraints8(endwall_model,x_e);
             
           r = calcRvec(x_e',X,theta,Ph);
           [f_e,~] = predict(r,R,Y,beta,f);
                
           if (c_flag == 1)
               
               f_e = f_e^2;
               
           end  
       end
           
       % Increment nfeval counter
       nfeval = nfeval + 1;            
              
            % Test expanded point, accept if smaller than reflection point
            if (f_e < f_r)
                
                iteration = iteration+1;
                
                fprintf('\nEXPANSION ... ');
                fprintf('\nVertex cost: %.4f\n',f_e);
                
                simplex(handles.npar+1,:) = x_e
                fsimplex(handles.npar+1) = f_e
                                
                % Calculate simplex costs
                minf(iteration) = min(min(f_e),min(minf));
                mean = 0; num = 0;

                for counter=1:1:(handles.npar) 
                                       
                    mean = mean + fsimplex(counter,1);
                    num = num + 1;
                   
                end

                meanf(iteration) = (mean + f_e)/(num+1);
                                
            else % Else, if not smaller than reflection point, use reflection vertex
                
                iteration = iteration + 1;
                
                fprintf('\nREFLECTION ... ');
                fprintf('\nVertex cost: %.4f\n',f_r);
                
                simplex(handles.npar+1,:) = x_r
                fsimplex(handles.npar+1) = f_r
 
                % Calculate simplex costs
                minf(iteration) = min(min(f_r),min(minf));
                mean = 0; num = 0;

                for counter=1:1:(handles.npar) 
                    
                    mean = mean + fsimplex(counter,1);
                    num = num + 1;
                    
                end

                meanf(iteration) = (mean + f_r) / (num+1);
                                
            end
            
    % Else, if reflection vertex is between worst and second worst point, try contraction (outside)
    elseif ((fsimplex(handles.npar) <= f_r) && (f_r < fsimplex(handles.npar+1)))
                
        iga = iga + 1;
        fprintf('\n*** Generation: %.1f Trying contraction (outside) *****************************\n',iga);

        % Contraction (outside)
        x_c = simplexContractionO(simplex,NM_model);  % compute contraction vertex (outside)
        
        if (handles.hifilocaloptimisation == 1)
            
            createGeometry8(blade_model,dir_model,resource_model,x_c,iga,GUIhandles);
            c_flag = checkConstraints8(endwall_model,x_c);
                
            [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model,GUIhandles);

            if ((meshstatus == 1) || (cfdstatus == 1))
                sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
                set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
                fprintf('\nManually create mesh and/or run CFD simulation\n');
                pause;
            end

            [x_c,f_c] = processModel(cfd_model,blade_model,endwall_model,dir_model,x_c,iga,resource_model.CFDcostfuncno,GUIhandles);
            cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
            
            if (c_flag == 1)
                
                f_c = f_c^2;
                
            end
        else
            
            c_flag = checkConstraints8(endwall_model,x_c);
                          
            r = calcRvec(x_c',X,theta,Ph);
            [f_c,~] = predict(r,R,Y,beta,f);
                
            if (c_flag == 1)
                
                f_c = f_c^2;
                
            end
        end
          
        % Increment nfeval counter
        nfeval = nfeval + 1;            
               
        % Test contracted point, if smaller than f_r, accept the point
        if (f_c <= f_r)
            
            iteration = iteration+1;
            
            fprintf('\nCONTRACTION (outside) ... ');
            fprintf('\nVertex cost: %.4f\n',f_c);
            
            simplex(handles.npar+1,:) = x_c
            fsimplex(handles.npar+1) = f_c
          
            % Calculate simplex costs
            minf(iteration) = min(min(f_c),min(minf));
            mean = 0; num = 0;

            for counter=1:1:(handles.npar) 
                
                mean = mean + fsimplex(counter,1);
                num = num + 1;
                
            end

            meanf(iteration) = (mean+f_c) / (num+1);
                                                
            % Save system log
            %filename = ['Iter_' int2str(iteration)];
            %save(filename, 'simplex', 'minf', 'meanf','nfeval','iteration','ndim','iga');
            
        % Else, if not smaller, try shrink    
        else
                   
            iga = iga + 1;
            fprintf('\n*** Generation: %.1f Trying shrink ********************************************\n',iga);
            
            % Shrink
            x_s = simplexShrink(simplex,NM_model);       % compute new vertices for all simplex points except best
            
            if (handles.hifilocaloptimisation == 1)
                              
                for count = 1:1:handles.npar+1
                                                        
                    createGeometry8(blade_model,dir_model,resource_model,x_s(count,:),iga+count/10,GUIhandles);
                    c_flag = checkConstraints8(endwall_model,simplex(count,:));
                        
                    [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga+count/10,resource_model,GUIhandles);

                    if ((meshstatus == 1) || (cfdstatus == 1))
                        sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
                        set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
                        fprintf('\nManually create mesh and/or run CFD simulation\n');
                        pause;
                    end

                    [~,fsimplex(count,1)] = processModel(cfd_model,blade_model,endwall_model,dir_model,x_s(count,:),iga+count/10,resource_model.CFDcostfuncno,GUIhandles);
                    cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
                        
                    if (c_flag == 1)
                        
                        fsimplex(count,1) = fsimplex(count,1)^2;
                        
                    end
                
                end
                
            else
                
                for count = 1:1:handles.npar+1
                    
                    c_flag = checkConstraints8(endwall_model,simplex(count,:));
                                        
                    r = calcRvec(x_s(count,:)',X,theta,Ph);
                    [fsimplex(count,1),~] = predict(r,R,Y,beta,f);
                        
                    if (c_flag == 1)
                        
                        fsimplex(count,1) = fsimplex(count,1)^2;
                        
                    end   
                end
            end
          
            % Increment nfeval counter
            nfeval = nfeval + (handles.npar + 1);
            
            iteration = iteration + 1;
            
            fprintf('\nSHRINK ... ');
            fprintf('\nVertex costs: %.4f\n',fsimplex);
            
            simplex = x_s
            fsimplex
            
            % Calculate simplex costs
            minf(iteration) = min(min(fsimplex),min(minf));
            mean = 0; num = 0;

            for counter=1:1:(handles.npar+1) 
                
                mean = mean + fsimplex(counter,1);
                num = num + 1;
                
            end

            meanf(iteration) = mean / num;
            
        end
                
    else
        % Else, if reflected point worse than all existing points, try contraction (inside)
        
        iga = iga + 1;
        fprintf('\n*** Generation: %.1f Trying contraction (inside) ******************************\n',iga);

        % Contraction (inside)
        x_c = simplexContractionI(simplex,NM_model); % compute contraction vertex (inside)
        
        if (handles.hifilocaloptimisation == 1)
            
            createGeometry8(blade_model,dir_model,resource_model,x_c,iga,GUIhandles);
            c_flag = checkConstraints8(endwall_model,x_c);   
                
            [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model,GUIhandles);

            if ((meshstatus == 1) || (cfdstatus == 1))
                sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
                set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
                fprintf('\nManually create mesh and/or run CFD simulation\n');
                pause;
            end

            [x_c,f_c] = processModel(cfd_model,blade_model,endwall_model,dir_model,x_c,iga,resource_model.CFDcostfuncno,GUIhandles);
            cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
                
            if (c_flag == 1)
                
                f_c = f_c^2;
            
            end
        else
            
            c_flag = checkConstraints8(endwall_model,x_c);

            r = calcRvec(x_c',X,theta,Ph);
            [f_c,~] = predict(r,R,Y,beta,f);
                
            if (c_flag == 1)
                
                f_c = f_c^2;
                
            end 
        end
                        
        % Increment nfeval counter
        nfeval = nfeval + 1;              
                    
        % Test contracted point, accept if smaller than worst point
        if (f_c < fsimplex(handles.npar+1))
            
            iteration = iteration + 1;
            
            fprintf('\nCONTRACTION (inside) ... ');
            fprintf('\nVertex cost: %.4f\n',f_c);
            
            simplex(handles.npar+1,:) = x_c
            fsimplex(handles.npar+1) = f_c
              
            % Calculate minmum vertex cost
            minf(iteration) = min(min(f_c),min(minf));
            mean = 0; num = 0;

            for counter=1:1:(handles.npar) 
                
                mean = mean + fsimplex(counter,1);
                num = num + 1;
                
            end

            meanf(iteration) = (mean + f_c) / (num + 1);
                        
        else
            % Again, last resort, try shrink
            
            iga = iga + 1;
            fprintf('\n*** Generation: %.1f Trying shrink ********************************************\n',iga);

            % Shrink
            x_s = simplexShrink(simplex,NM_model);          % compute new vertices for all simplex points except best
            
            if (handles.hifilocaloptimisation == 1)
            
                for count = 1:1:handles.npar+1
                    
                    createGeometry8(blade_model,dir_model,resource_model,x_s(count,:),iga+count/10,GUIhandles);
                    c_flag = checkConstraints8(endwall_model,x_s(count,:));
                        
                    [meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga+count/10,resource_model,GUIhandles);

                    if ((meshstatus == 1) || (cfdstatus == 1))
                        sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
                        set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
                        fprintf('\nManually create mesh and/or run CFD simulation\n');
                        pause;
                    end

                    [~,fsimplex(count,1)] = processModel(cfd_model,blade_model,endwall_model,dir_model,x_s(count,:),iga+count/10,resource_model.CFDcostfuncno,GUIhandles);
                    cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
                    
                    if (c_flag == 1)
                        
                        fsimplex(count,1) = fsimplex(count,1)^2;
                        
                    end
                
                end
                
            else
                
                for count = 1:1:handles.npar + 1
                    
                    c_flag = checkConstraints8(endwall_model,x_s(count,:));
                        
                    r = calcRvec(x_s(count,:)',X,theta,Ph);
                    [fsimplex(count,1),~] = predict(r,R,Y,beta,f);
                        
                    if (c_flag == 1)
                        
                        fsimplex(count,1) = fsimplex(count,1)^2;
                        
                    end
                    
                end
                
            end
          
            % Increment nfeval counter
            nfeval = nfeval + (handles.npar + 1);       
                  
            iteration = iteration + 1;
            
            fprintf('\nSHRINK ... ');
            fprintf('\nVertex costs: %.4f\n',fsimplex);
            
            simplex = x_s
            fsimplex
                         
            % Calculate minmum vertex cost
            minf(iteration) = min(min(fsimplex),min(minf));
            mean = 0; num = 0;

            for counter=1:1:(handles.npar+1) 
                
                mean = mean + fsimplex(counter,1);
                num = num + 1;
                
            end
            
            meanf(iteration) = mean / num;                        
            
        end   
    end
    
    % Sort cost vector and simplex matrix
    [fsimplex,index] = sort(fsimplex);
    simplex = simplex(index,:);
    
    % Save system log
    %filename = ['Iter_' int2str(iteration)];
    %save(filename, 'simplex', 'minf', 'meanf','nfeval','iteration','ndim','iga');
             
    % Graph progression of the algorithm
    iters = 1:1:length(minf);
    figure(100);
    plot(iters,minf,'-o');%,iters,meanf,'--');
    xlabel('Iteration'); ylabel('Cost'); grid on;
    legend('Best','Simplex mean','location','NorthEast','orientation','vertical');
    legend boxon;

    % Test for convergence and divergence
    converged = (fsimplex(handles.npar+1) - fsimplex(1) < handles.NM_tolerance);
    diverged = (nfeval > handles.localoptimisermaxit);
    
    if (converged)
        
        fprintf('Converged');
        
    elseif (diverged)
        
        fprintf('Diverged - max iterations reached');
        
    end

end

% Assign global (handles) variables
handles.localoptpar = simplex(1,:);
handles.localoptval = fsimplex(1);

% Save handles struct
guidata(hObject,handles);

%
%End - LOCAL OPTIMISER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Start - BUILD GEOMETRY - CFD
%

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Build system structs
endwall_model = struct('maxphase',handles.maxphase,'harmonicshi',handles.harmonicshi,'harmonicslo',...
                        handles.harmonicslo,'heighthi',handles.heighthi,'no_lines',handles.no_lines,...
                        'npar',handles.npar,'endwall_type',handles.endwall_type);

blade_model = struct('blade_type',handles.blade_type,'R0',handles.R0,'no_blades',handles.no_blades,...
                        'blade_max',handles.blade_height,'blade_angle',handles.blade_angle);

cfd_model = struct('operating_pressure',handles.operating_pressure,'torque_correction',handles.torque_correction,...
                    'T_ref',handles.T_ref,'P_ref',handles.P_ref,'V_inlet',handles.V_inlet,'t_model',handles.t_model,...
                    'span_avg',handles.span_avg,'wake_tolerance',handles.wake_tolerance,'RPM',handles.RPM);

dir_model = struct('work_dir',handles.work_dir,'turbine_dir',handles.turbine_dir,...
                    'reference_data_directory',handles.reference_data_directory,'base_dir',handles.base_dir);

resource_model = struct('username',handles.username,'CFDcostfuncno',handles.CFDcostfuncno,...
                        'ncores',handles.ncores);
                    
                    
GUIhandles = ancestor(hObject,'figure');

createGeometry8(blade_model,dir_model,resource_model,xopt,iga,GUIhandles);
[meshstatus,cfdstatus] = runModel(blade_model.blade_type,iga,resource_model,GUIhandles);

if ((meshstatus == 1) || (cfdstatus == 1))
    sendMail('bergh.jonathan@gmail.com','Mesh or CFD fail','Either the mesher or CFD run has failed');
    set(handles.txtInfo,'String','NB. Meshing or CFD has failed - please check workspace');
    fprintf('\nManually create mesh and/or run CFD simulation\n');
    pause;
end
       
[newX,newY] = processModel(cfd_model,blade_model,endwall_model,dir_model,xopt,iga,resource_model.CFDcostfuncno,GUIhandles);
cleanUp(dir_model.work_dir,blade_model.blade_type,iga);
        
% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%
%End - BUILD GEOMETRY / CFD

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Kriging model

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
str = get(hObject,'String');
val = get(hObject,'Value');

switch str{val};
    case 'Gaussian'
        handles.variogram_type = 'Gaussian';
        handles.Ph = 2;
        set(handles.text39,'String',1.9);     
    case 'Exponential'
        handles.variogram_type = 'Exponential';
        handles.Ph = 1;
        set(handles.text39,'String',1);    
end

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double

handles.kriging_data_dir = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = get(handles.edit31,'String');

load(filename);
[m,n] = size(X);
f = ones(n,1);

set(handles.txtInfo,'String',sprintf('Point data loaded \n    No. of data points: %g \n    No. of parameters: %g',n,m));

handles.X = X;
handles.Y = Y;
handles.npar = m;
handles.f = f;

if (exist('minY','var'))
    
    handles.minY = minY;
    
end
    
if (exist('dbmax','var'))
    
    handles.dbmax = dbmax;
    
else
    
    handles.dbmax = n;
    
end
   
% Save handles
guidata(hObject,handles);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd(handles.work_dir);

if (isfield(handles,'minY') && isfield(handles,'dbmax'))
    
    save(sprintf('XY_gen_%d',handles.iga),'-struct','handles','X','Y','minY','dbmax');
        
elseif (isfield(handles,'minY'))
    
    save(sprintf('XY_gen_%d',handles.iga),'-struct','handles','X','Y','minY');
    
else
    
    save(sprintf('XY_gen_%d',handles.iga),'-struct','handles','X','Y');
    
end

function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit45 as text
%        str2double(get(hObject,'String')) returns contents of edit45 as a double

handles.kriging_theta_dir = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = get(handles.edit45,'String');

load(filename);
[m,~] = size(theta);
set(handles.txtInfo,'String',sprintf('Theta data loaded \n    No. of parameters: %g \n    Theta = %s',m,mat2str(theta,8)));

% Set handles.theta equal to loaded thetas
handles.theta = theta;

% Crossvalidate model
[y,stdR] = crossValidate(handles.X,handles.Y,handles.theta,handles.Ph,handles.f);

% Report model fit statistics
[RMSE,max_error] = calcMSE(y(:,1),handles.Y);
A = calcXK(handles.X);
[~,condR] = calcRrevised(A,handles.theta,handles.Ph);

set(handles.text47,'String',max_error);
set(handles.text48,'String',RMSE);
set(handles.txtInfo,'String',sprintf('Fitting results ... \n    IGA: n/a \n    MLE: n/a \n    Telapsed: n/a \n    cond(R): %g (cond(R) -> inf = bad)\n\n    Theta: %s',condR,mat2str(handles.theta,8)));
fprintf('\nFitting results ... \n    IGA: n/a \n    MLE: n/a \n    Telapsed: n/a \n    cond(R): %g (cond(R) -> inf = bad)\n\n    Theta: %s',condR,mat2str(handles.theta,8));

% Plot some diagnostics
% Predicted y vs Actual Y
axes(handles.axes6);
plot(y,handles.Y,'ob',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),100),linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),100),'-k');
axis([min(min(y),min(handles.Y)) max(max(y),max(handles.Y)) min(min(y),min(handles.Y)) max(max(y),max(handles.Y))]);
xlabel('Predicted y'); ylabel('Actual Y');
grid on;

% Standardised residual
axes(handles.axes4);
plot(y,stdR,'ob',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),2),[3 3],'--b',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),2),[-3 -3],'--b');
axis([min(min(y),min(handles.Y)) max(max(y),max(handles.Y)) min(min(stdR),-3.5) max(max(stdR),3.5)]);
xlabel('Predicted y'); ylabel('Standardised Residual');
grid on;

% Q-Q plot
axes(handles.axes5);
ystdR = sort(stdR);
x = calcQPos(ystdR); x = calcNormInv(x);
plot(x,ystdR,'ob',linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),'-k');
axis([min(min(x),min(ystdR)) max(max(x),max(ystdR)) min(min(x),min(ystdR)) max(max(x),max(ystdR))]);
xlabel('Standard Normal Quantile'); ylabel('Standardised Residual');
grid on;

% Save handles data
guidata(hObject,handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd(handles.work_dir);

save(sprintf('thetas_gen_%d',handles.iga),'-struct','handles','theta');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fitting Controls

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(hObject,'String') == 'DE')
    
    set(handles.pushbutton24,'String','GA');
    handles.optimiseMLEtype = 'GA';
    
elseif (get(hObject,'String') == 'GA')
    
    set(handles.pushbutton24,'String','DE');
    handles.optimiseMLEtype = 'DE';
    
end

% Save handles data
guidata(hObject,handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dlg_title = 'Theta optimisation parameters';
prompt = {'Popsize' 'Maxit' 'Varhi' 'Varlo'};
nun_lines = 1;
def = {'48' '7500' '2' '-8'};

koptinput = inputdlg(prompt,dlg_title,nun_lines,def);

handles.kopt_popsize = str2num(koptinput{1});
handles.kopt_maxit = str2num(koptinput{2});
handles.kopt_varhi = str2num(koptinput{3});
handles.kopt_varlo = str2num(koptinput{4});

set(handles.edit33,'String',sprintf('Pop: %g It: %g Vhi: %g Vlo: %g',handles.kopt_popsize,handles.kopt_maxit,handles.kopt_varhi,handles.kopt_varlo));

guidata(hObject,handles);

function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.npar = 12;

fmodel = struct('maxit',handles.kopt_maxit,'npar',handles.npar,...
    'varhi',handles.kopt_varhi,'varlo',handles.kopt_varlo,...
    'popsize',handles.kopt_popsize,'Ph',handles.Ph,'X',handles.X,...
    'Y',handles.Y,'f',handles.f,'objfunc',@costfunclogMLE);

set(handles.text47,'String','');
set(handles.text48,'String','');

GUIhandles = ancestor(hObject,'figure');

% Fit model
if (handles.optimiseMLEtype == 'GA')
    
    [handles.theta,MLE,k_iga,telapsed] = optimiseMLEGA(fmodel,GUIhandles);
    
else
    
    [handles.theta,MLE,k_iga,telapsed] = optimiseMLEDE(fmodel,0.0001,GUIhandles);
    
end

% Crossvalidate model fit
[y,stdR] = crossValidate(handles.X,handles.Y,handles.theta,handles.Ph,handles.f);

% Display model fit statistics
[RMSE,max_error] = calcMSE(y(:,1),handles.Y);
A = calcXK(handles.X);
[~,condR] = calcRrevised(A,handles.theta,handles.Ph);

set(handles.text47,'String',max_error);
set(handles.text48,'String',RMSE);
set(handles.txtInfo,'String',sprintf('Fitting results ... \n    IGA: %g \n    MLE: %g \n    Telapsed: %.2f secs\n    cond(R): %g (cond(R) -> inf = bad)\n\n    Theta: %s'...
                             ,k_iga,MLE,telapsed,condR,mat2str(handles.theta,8)));

fprintf('\nFitting results ... \n    IGA: %g \n    MLE: %g \n    Telapsed: %.2f secs\n    cond(R): %g (cond(R) -> inf = bad)\n\n    Theta: %s'...
                             ,k_iga,MLE,telapsed,condR,mat2str(handles.theta,8));

% Plot some diagnostics
% Predicted y vs Actual Y
axes(handles.axes6);
plot(y,handles.Y,'ob',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),100),linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),100),'-k');
axis([min(min(y),min(handles.Y)) max(max(y),max(handles.Y)) min(min(y),min(handles.Y)) max(max(y),max(handles.Y))]);
xlabel('Predicted y'); ylabel('Actual Y');
grid on;

% Standardised residual
axes(handles.axes4);
plot(y,stdR,'ob',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),2),[3 3],'--b',linspace(min(min(y),min(handles.Y)),max(max(y),max(handles.Y)),2),[-3 -3],'--b');
axis([min(min(y),min(handles.Y)) max(max(y),max(handles.Y)) min(min(stdR),-3.5) max(max(stdR),3.5)]);
xlabel('Predicted y'); ylabel('Standardised Residual');
grid on;

% Q-Q plot
axes(handles.axes5);
ystdR = sort(stdR);
x = calcQPos(ystdR); x = calcNormInv(x);
plot(x,ystdR,'ob',linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),linspace(min(min(x),min(ystdR)),max(max(x),max(ystdR)),100),'-k');
axis([min(min(x),min(ystdR)) max(max(x),max(ystdR)) min(min(x),min(ystdR)) max(max(x),max(ystdR))]);
xlabel('Standard Normal Quantile'); ylabel('Standardised Residual');
grid on;

% Save handles data
guidata(hObject,handles);

% Fitting controls
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%END - Kriging model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Computer resources

function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double

handles.username = get(hObject,'String');

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit41 as text
%        str2double(get(hObject,'String')) returns contents of edit41 as a double

handles.CFDcostfuncno = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit42 as text
%        str2double(get(hObject,'String')) returns contents of edit42 as a double

handles.ncores = str2double(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%END - Resources
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START - txtInfo

function txtInfo_Callback(hObject, eventdata, handles)
% hObject    handle to txtInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtInfo as text
%        str2double(get(hObject,'String')) returns contents of txtInfo as a double


% --- Executes during object creation, after setting all properties.
function txtInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% END - txtInfo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start - Optimiser info
function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit44 as text
%        str2double(get(hObject,'String')) returns contents of edit44 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% END - Optimiser info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start - Local optimiser info
function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit50 as text
%        str2double(get(hObject,'String')) returns contents of edit50 as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% END - Local optimiser info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%START - Extra functions

%END - Extra functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
