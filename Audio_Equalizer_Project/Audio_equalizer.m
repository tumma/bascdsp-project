%Aranguren, Jan
%Atienza, Patrick
%Chua, Cad
%Desingco, Darill
%Rufino, Andrea

function varargout = Audio_equalizer(varargin)
% AUDIO_EQUALIZER M-file for Audio_equalizer.fig
%      AUDIO_EQUALIZER, by itself, creates a new AUDIO_EQUALIZER or raises the existing
%      singleton*.
%
%      H = AUDIO_EQUALIZER returns the handle to a new AUDIO_EQUALIZER or the handle to
%      the existing singleton*.
%
%      AUDIO_EQUALIZER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUDIO_EQUALIZER.M with the given input arguments.
%
%      AUDIO_EQUALIZER('Property','Value',...) creates a new AUDIO_EQUALIZER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Audio_equalizer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Audio_equalizer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Audio_equalizer

% Last Modified by GUIDE v2.5 10-Dec-2012 10:03:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Audio_equalizer_OpeningFcn, ...
                   'gui_OutputFcn',  @Audio_equalizer_OutputFcn, ...
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
 
% --- Executes just before Audio_equalizer is made visible.
function Audio_equalizer_OpeningFcn(hObject, eventdata, handles, varargin)
handles.playfile=[];
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes Audio_equalizer wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = Audio_equalizer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function Volume_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Volume_CreateFcn(hObject, eventdata, handles)


if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Volume.
function Volume_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
    [f g]=uigetfile('*.wav', '');
    p=get(handles.playlist,'String');
    p{length(p)+1}=f;
    set(handles.playlist,'String',p);
    handles.playfile{length(handles.playfile)+1}=[g '\' f];
    guidata(hObject,handles);
    global backwards;
    backwards=0;


% --- Executes on button press in stopwav.
function stopwav_Callback(hObject, eventdata, handles)
global pl;
stop(pl);

% --- Executes on button press in playwav.
function playwav_Callback(hObject, eventdata, handles)


selectedfile = get(handles.playlist,'Value');
thefile = handles.playfile{selectedfile};
global f;
[y f] = wavread(thefile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           get balance value                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bal = get(handles.balance,'Value');
left = y(:,1);
left(end,2) = 0;


left2 = y(:,1);
right=left2(:,1);
right(:,1)=0;
right(:,2)=left2;
if bal < 0
    y = left;
elseif bal > 0
    y = right;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%                           get volume value                              % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vol = get(handles.Volume,'Value');
dbvol = 40*vol-40;
global val;
val= 10^(dbvol/10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       get the power gain                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global pl;

eq60h = get(handles.eq60, 'Value');
eq60db = 40*eq60h-40;
eq60p = 10^(eq60db/10);

eq150h = get(handles.eq150, 'Value');
eq150db = 40*eq150h-40;
eq150p = 10^(eq150db/10);

eq400h = get(handles.eq400, 'Value');
eq400db = 40*eq400h-40;
eq400p = 10^(eq400db/10);
 
eq1kh = get(handles.eq1k, 'Value');
eq1kdb = 40*eq1kh-40;
eq1kp = 10^(eq1kdb/10);
 
eq2k4h = get(handles.eq2k4, 'Value');
eq2k4db = 40*eq2k4h-40;
eq2k4p = 10^(eq2k4db/10);
 
eq6kh = get(handles.eq6k, 'Value');
eq6kdb = 40*eq6kh-40;
eq6kp = 10^(eq6kdb/10);
 
eq15kh = get(handles.eq15k, 'Value');
eq15kdb = 40*eq15kh-40;
eq15kp = 10^(eq15kdb/10);    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         get equalizer values                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global Fs;
Fs = 44100;                                     % sampling frequency
Fs2=Fs/2;        

N    = 100;                                     % order
Fl  = 20;                                       % low cutoff
Fh  = 100;                                      % high cutoff
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);    
h60 = filter(Hd,y)*eq60p;

N    = 100;                                     % order
Fl  = 100;                                      % low cutoff
Fh  = 200;                                      % high cutoff
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);
h150 = filter(Hd,y)*eq150p;

N    = 100;                                     % order
Fl  = 200;                                      % low cutoff
Fh  = 600;                                      % high cutoff
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);
h400 = filter(Hd,y)*eq400p;

N    = 100;                                     % order
Fl  = 600;                                      % low cutoff
Fh  = 1400;                                     % high cutoff
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);
h1k = filter(Hd,y)*eq1kp;

N    = 100;                                     % order
Fl  = 1400;                                     % low cutoff
Fh  = 3400;                                     % high cutoff
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);
h2k4 = filter(Hd,y)*eq2k4p;

N    = 100;                                     % order
Fl  = 3400;                                     % low cutoff
Fh  = 8600;                                     % high cutoff
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);
h6k = filter(Hd,y)*eq6kp 

N    = 100;                                     % order
Fl  = 8600;                                     % low cutoff
Fh  = 21400;                                    % Second Cutoff Frequency
F  = fir1(N, [Fl Fh]/Fs2, 'bandpass');
Hd = dfilt.dffir(F);
h15k = filter(Hd,y)*eq15kp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          to play music file                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    z = h60+h150+h400+h1k+h2k4+h6k+h15k;
    
    
    global tempoval;
    Fst=f;
    if tempoval<0 
    Fst=(f)/(2^abs(tempoval));
    end
    if tempoval>0
    Fst=(f)*(2^tempoval);    
    end
    if tempoval==0
    Fst=(f);    
    end
    global echovalue;
    global ztemp;

    
    
    if echovalue==true
    ztemp = z;
    N = 4000;
    for n=N+1:length(ztemp)
        z(n) = ztemp(n) + ztemp(n-N);
    end
    end
    
    
    
    global backwards;
    if backwards==1
        z=flipud(z);
        
    end
    
    zz = z*val;
    
    pl = audioplayer(zz, Fst);
    plot(zz);
    play(pl);
    

% --- Executes on slider movement.
function eq60_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function eq60_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq60 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function eq150_Callback(hObject, eventdata, handles)
% hObject    handle to eq150 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function eq150_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq150 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function eq400_Callback(hObject, eventdata, handles)
% hObject    handle to eq400 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function eq400_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq400 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function eq2k4_Callback(hObject, eventdata, handles)
% hObject    handle to eq2k4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function eq2k4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq2k4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function eq6k_Callback(hObject, eventdata, handles)
% hObject    handle to eq6k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function eq6k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq6k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)

% --- Executes on slider movement.
function eq15k_Callback(hObject, eventdata, handles)
% hObject    handle to eq15k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function eq15k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq15k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function balance_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function balance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to balance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[1 1 1]);
end
    
% --- Executes on selection change in playlist.
function playlist_Callback(hObject, eventdata, handles)
% hObject    handle to playlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns playlist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from playlist


% --- Executes during object creation, after setting all properties.
function playlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to playlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function eq1k_Callback(hObject, eventdata, handles)
% hObject    handle to eq1k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function eq1k_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq1k (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pauseplay.
function pauseplay_Callback(hObject, eventdata, handles)
global pl;
if isplaying(pl)==true     
   pause(pl);
else isplaying(pl)==false
   resume(pl);
end


% --- Executes on button press in backwards.
function backwards_Callback(hObject, eventdata, handles)
global backwards;
global pl;
value = get(handles.backwards, 'Value');
if value==true
backwards=1;
else
    backwards=0;
end
stop(pl);
plot(0);

% --- Executes on slider movement.
function tempo_Callback(hObject, eventdata, handles)
global tempoval;
tempoval = get(handles.tempo, 'Value');
    


% --- Executes during object creation, after setting all properties.
function tempo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tempo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in echo.
function echo_Callback(hObject, eventdata, handles)
global echovalue;
echovalue = get(handles.echo, 'Value');
plot(0);
global pl;
stop(pl);

