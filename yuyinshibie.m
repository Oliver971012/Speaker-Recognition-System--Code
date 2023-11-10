function varargout = yuyinshibie(varargin)
% YUYINSHIBIE MATLAB code for yuyinshibie.fig
%      YUYINSHIBIE, by itself, creates a new YUYINSHIBIE or raises the existing
%      singleton*.
%
%      H = YUYINSHIBIE returns the handle to a new YUYINSHIBIE or the handle to
%      the existing singleton*.
%
%      YUYINSHIBIE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YUYINSHIBIE.M with the given input arguments.
%
%      YUYINSHIBIE('Property','Value',...) creates a new YUYINSHIBIE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before yuyinshibie_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to yuyinshibie_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help yuyinshibie
% Last Modified by GUIDE v2.5 10-Nov-2023 16:39:50
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                  'gui_Singleton',  gui_Singleton, ...
                  'gui_OpeningFcn', @yuyinshibie_OpeningFcn, ...
                  'gui_OutputFcn',  @yuyinshibie_OutputFcn, ...
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
% --- Executes just before yuyinshibie is made visible.
function yuyinshibie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to yuyinshibie (see VARARGIN)
% Choose default command line output for yuyinshibie
global sc
sc='';
set(handles.listbox2,'string',num2str(sc),'fontsize',10);
handles.output = hObject;
A='①Please select the speech database to be trained...';
sc=[sc,A,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes yuyinshibie wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = yuyinshibie_OutputFcn(hObject, eventdata, handles)
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
global sc filepath
filepath = uigetdir;%Read Folder Path Code
speakerData = dir(filepath);%Read audio data from a folder
speakerData(1:2) = [];
speakerNum=length(speakerData);%speakerNum:number of people；
if speakerNum==0
   B='Sorry, please place the required training audio in the folder.';
   sc=[sc,B,10];
   set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
else
     C=['The number of voices to be trained is',num2str(speakerNum),'个'];
     D='Please start training the speech database...'; 
     sc=[sc,C,10];
     sc=[sc,D,10];
     set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');  
end
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc filepath speakerData speakerGmm
   speakerData = dir(filepath);
   filename=strcat(filepath,'\');
   speakerData(1:2) = [];%Remove the first two lines without data
   speakerNum=length(speakerData);%speakerNum:number of people；
   if speakerNum==0
       E='Sorry, please put the voice that needs training in the folder.';
       sc=[sc,E,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
   else
       F='②Read voice files and extract features...';
       pause(0.5)
       sc=[sc,F,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       for i=1:speakerNum
       G=['Extracting features of the',num2str(i),'th person',speakerData(i,1).name(1:end-4),'Characteristics of'];
       sc=[sc,G,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       pause(0.5)
       [y, fs]=audioread([filename speakerData(i,1).name]);
       y=double(y);
       y=y/max(y);%Pre-emphasis
       epInSampleIndex=epdByVol(y, fs);		% Cut the beginning and end parts of the speech
       y=y(epInSampleIndex(1):epInSampleIndex(2));	% Remove the non-speaking parts
       speakerData(i).mfcc=melcepst(y,8000);%Calculate Mel-frequency cepstral coefficients
       H='Completed！！';
       sc=[sc,H,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       end
       G='③Training the Gaussian Mixture Model for each speaker...';
       gaussianNum=12;
       pause(0.5)
       sc=[sc,G,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       for i=1:speakerNum
       H=['Training for speaker',num2str(i),'Individual speaker',speakerData(i,1).name(1:end-4),'train'];
       sc=[sc,H,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
	    [speakerGmm(i).mu, speakerGmm(i).sigm,speakerGmm(i).c] = gmm_estimate(speakerData(i).mfcc(:,5:12)',gaussianNum,20);
       I='Completed！！';
       sc=[sc,I,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       end
       save speakerDate
       save speakerGmm
   end
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pathall sc testing_data fs
global testing1_data11
[filename,pathname]=uigetfile('.wav');
pathall=strcat(pathname,filename);
lsz=['Next, we will',num2str(filename),'Perform speech recognition.'];
sc=[sc,lsz,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
[y,fs]=audioread(pathall);  %Read voice file data
axes(handles.axes1);
plot(y);
testing1_data11=y;
testing_data=y;
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   global sc pathall speakerData speakerGmm testing_data
   J='④Identification in progress...';
   sc=[sc,J,10];
   set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
   pause(0.5)
%     [testing_data, fs, nbits]=wavread(pathall);
%         [testing_data, fs]=audioread(pathall);
   match= MFCC_feature_compare(testing_data,speakerGmm);
   [max_1 index]=max(match);
   K=['The speaker is',speakerData(index).name(1:end-4)];
   sc=[sc,K,10];
   set(handles.edit2,'string',num2str(K));
% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes on selection change in text2.
function text2_Callback(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns text2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text2
% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
buttonoom=questdlg('Are you sure you want to return to the system main interface？','Exit system prompt','Y','N','default');
A='Y';
B='N';
C=buttonoom;
if strcmp(A,C)
   close(yuyinshibie);
else strcmp(B,C);
end
% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
   set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc
recObj=audiorecorder
% pause(1)
% K='start recording...'
% sc=[sc,K,10];
% set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
% recordblocking(recObj,6)
% L='End recording...'
% sc=[sc,L,10];
% set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
% myRecording=getaudiodata(recObj)
% filepath=uigetdir %Set file storage path
% filename=get(handles.edit1,'String') %Set file storage name
% yuyin=strcat(filepath,'\',filename,'.wav');
% audiowrite(yuyin,myRecording,8000); %Save voice file
% M=['Save to',num2str(yuyin),'to...']
% sc=[sc,M,10];
% set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
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
% --- Executes during object creation, after setting all properties.
function pushbutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
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
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc pathall speakerData speakerGmm testing_data
[testing_data, fs]=audioread(pathall);
snr=str2num(get(handles.edit3,'string'));
[testing_data,noise] = Gnoisegen(testing_data,snr)
axes(handles.axes2);
plot(testing_data);
title('Noise Signal')
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
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
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs testing_data testing1_data11
IS=0.25;                                % Set the length of the leading silent segment
wlen=200;                               % Set the frame length to 25ms
inc=80;                                 % Set frame shift to 10ms
NIS=fix((IS*fs-wlen)/inc +1);           % Find the number of leading frames
aa=4; bb=0.001;                           % Set parameters a and B
testing_data=simplesubspec(testing_data,wlen,inc,NIS,aa,bb);% Spectral Subtraction
axes(handles.axes2);
plot(testing_data)
title('Signal after noise reduction')
testing_data=0;
testing_data=testing1_data11;
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc pathall speakerData speakerGmm
  fs1 =16000;  %The sampling rate is16000Hz
K='Start getting training voice information...'
sc=[sc,K,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
duration=4;  %Record data for 4S
n = duration*fs1;
t = (1:n)/fs1;
recObj = audiorecorder(fs1,16,1);
recordblocking(recObj, duration);
L='End of training voice information acquisition...'
sc=[sc,L,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
y = getaudiodata(recObj);  %Get recording data
% play(recObj);
myRecording = getaudiodata(recObj);% Obtain recorded data waveform
axes(handles.axes1);
plot(myRecording);%Draw recording waveform
filename ='.\trainning\s16.wav';  %Prepare to write audio data file
audiowrite(filename,y,fs1) ;   %Write y to file at FS sampling rate
M=['Save to',num2str(filename),'to...']
sc=[sc,M,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc filepath
filepath = uigetdir;%Read folder path code
speakerData = dir(filepath);%Read voice data in folder
speakerData(1:2) = [];
speakerNum=length(speakerData);%speakerNum:number of people；
if speakerNum==0
   B='Sorry, please put the voice that needs training in the folder.';
   sc=[sc,B,10];
   set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
else
     C=['The voice that needs training is',num2str(speakerNum),'个'];
     D='Please start training voice library...'; 
     sc=[sc,C,10];
     sc=[sc,D,10];
     set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');  
end
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc filepath speakerData speakerGmm
   speakerData = dir(filepath);
   filename=strcat(filepath,'\');
   speakerData(1:2) = [];%Remove the first two lines without data
   speakerNum=length(speakerData);%speakerNum:number of people；
   if speakerNum==0
       E='Sorry, please put the voice that needs training in the folder.';
       sc=[sc,E,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
   else
       F='②Read voice files and extract features...';
       pause(0.5)
       sc=[sc,F,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       for i=1:speakerNum
       G=['Extracting the',num2str(i),'person',speakerData(i,1).name(1:end-4),'the characteristics of'];
       sc=[sc,G,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       pause(0.5)
       [y, fs]=audioread([filename speakerData(i,1).name]);
       y=double(y);
       y=y/max(y);%pre-emphasis
       epInSampleIndex=epdByVol(y, fs);		% Intercepting the beginning and end of speech
       y=y(epInSampleIndex(1):epInSampleIndex(2));	% Delete the silent part
       speakerData(i).mfcc=melcepst(y,8000);%Calculate Mel frequency cepstrum coefficient
       H='Completed！！';
       sc=[sc,H,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       end
       G='③Gaussian mixture model for training each speaker...';
       gaussianNum=12;
       pause(0.5)
       sc=[sc,G,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       for i=1:speakerNum
       H=['Is the',num2str(i),'speaker',speakerData(i,1).name(1:end-4),'train'];
       sc=[sc,H,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
	    [speakerGmm(i).mu, speakerGmm(i).sigm,speakerGmm(i).c] = gmm_estimate(speakerData(i).mfcc(:,5:12)',gaussianNum,20);
       I='Completed！！';
       sc=[sc,I,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
       end
       save speakerDate
       save speakerGmm
   end
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sc pathall speakerData speakerGmm
  fs1 =16000;  %The sampling rate is 16000hz
K='Start to acquire voice information to be recognized...'
sc=[sc,K,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
duration=4;  %Record data for 4S
n = duration*fs1;
t = (1:n)/fs1;
recObj = audiorecorder(fs1,16,1);
recordblocking(recObj, duration);
L='End of acquisition of voice information to be recognized...'
sc=[sc,L,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
y = getaudiodata(recObj);  %Get recording data
% play(recObj);
myRecording = getaudiodata(recObj);% Obtain recorded data waveform
axes(handles.axes1);
plot(myRecording);%Draw recording waveform
filename ='luy.wav';  %Prepare to write audio data file
audiowrite(filename,y,fs1) ;   %Write y to file at FS sampling rate
M=['save to',num2str(filename),'to...']
sc=[sc,M,10];
set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
   J='Identification in progress...';
   sc=[sc,J,10];
   set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
   pause(0.5)
   [testing_data, fs]=audioread(filename);
   match= MFCC_feature_compare(testing_data,speakerGmm);
   [max_1 index]=max(match);
    J1='End of identification';
   sc=[sc,J1,10];
       set(handles.listbox2,'string',num2str(sc),'fontsize',10,'fontname','KaiTi');
   K=['The speaker is',speakerData(index).name(1:end-4)];
   sc=[sc,K,10];
   set(handles.edit2,'string',num2str(K));
