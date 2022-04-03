clrfunction varargout = MultiwellAnalysis(varargin)
% MULTIWELLANALYSIS MATLAB code for MultiwellAnalysis.fig
%      MULTIWELLANALYSIS, by itself, creates a new MULTIWELLANALYSIS or raises the existing
%      singleton*.
%
%      H = MULTIWELLANALYSIS returns the handle to a new MULTIWELLANALYSIS or the handle to
%      the existing singleton*.
%
%      MULTIWELLANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIWELLANALYSIS.M with the given input arguments.
%
%      MULTIWELLANALYSIS('Property','Value',...) creates a new MULTIWELLANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MultiwellAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MultiwellAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MultiwellAnalysis

% Last Modified by GUIDE v2.5 03-Feb-2017 15:48:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MultiwellAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @MultiwellAnalysis_OutputFcn, ...
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


% --- Executes just before MultiwellAnalysis is made visible.
function MultiwellAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MultiwellAnalysis (see VARARGIN)

% Choose default command line output for MultiwellAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MultiwellAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MultiwellAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warning off;
handles.exp_folder = uigetdir(pwd,'Select the experiment folder');
if strcmp(num2str(handles.exp_folder),'0')
    errordlg('Selection failed: end of session','Error')
    return
end

cd(handles.exp_folder);
set(handles.edit1,'String',handles.exp_folder);
%set_on(handles);

set(handles.pushbutton2, 'visible','on')
set(handles.pushbutton4, 'visible','on')
set(handles.pushbutton7, 'visible','on')
guidata(hObject, handles);  

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


prompt  = {'Duration of recording (min)', 'Sampling frequency (Hz)'};
title_fig   = 'Intrinsic properties';
lines   = 1;
%def     = {'0.1', '25','0.4','20000'};
def     = {'5', '10000'};
Ianswer = inputdlg(prompt,title_fig,lines,def);
if isempty(Ianswer)
    cancelFlag = 1;
else
    handles.duration_min = str2num(Ianswer{1,1});
    handles.fs = str2num(Ianswer{2,1});
end
GeneratePT(handles.exp_folder,handles.duration_min,handles.fs)
EndOfProcessing (handles.exp_folder, 'Successfully accomplished');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt  = {'Duration of recording (min)'};
title_fig   = 'Intrinsic properties';
lines   = 1;
%def     = {'0.1', '25','0.4','20000'};
def     = {'5'};
Ianswer = inputdlg(prompt,title_fig,lines,def);
if isempty(Ianswer)
    cancelFlag = 1;
else
    handles.duration_min = str2num(Ianswer{1,1});
end
ImportParameters (handles.exp_folder,handles.duration_min)
EndOfProcessing (handles.exp_folder, 'Successfully accomplished');

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = questdlg('Ready to quit?', ...
    'Exit Dialog','Yes','No','No');
switch button
    case 'Yes',
        close;
        
    case 'No',
        quit cancel;
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt  = {'Start time (s)','End time (s)','Sampling frequency (Hz)','Number of wells','Condition'};
title_fig   = 'Intrinsic properties';
lines   = 1;
def     = {'0','600','10000','12','Control'};
Ianswer = inputdlg(prompt,title_fig,lines,def);
if isempty(Ianswer)
    cancelFlag = 1;
else
    handles.start = str2num(Ianswer{1,1});
    handles.end = str2num(Ianswer{2,1});
    handles.fs = str2num(Ianswer{3,1});
    handles.wells = str2num(Ianswer{4,1});
    handles.condition = str2num(Ianswer{5,1});
end
raster_multiwell(handles.exp_folder,handles.start,handles.end,handles.fs,handles.wells,handles.condition)
EndOfProcessing (handles.exp_folder, 'Successfully accomplished');
