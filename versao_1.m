function varargout = versao_1(varargin)
% VERSAO_1 MATLAB code for versao_1.fig
%      VERSAO_1, by itself, creates a new VERSAO_1 or raises the existing
%      singleton*.
%
%      H = VERSAO_1 returns the handle to a new VERSAO_1 or the handle to
%      the existing singleton*.
%
%      VERSAO_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VERSAO_1.M with the given input arguments.
%
%      VERSAO_1('Property','Value',...) creates a new VERSAO_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before versao_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to versao_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help versao_1

% Last Modified by GUIDE v2.5 29-May-2018 15:10:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @versao_1_OpeningFcn, ...
                   'gui_OutputFcn',  @versao_1_OutputFcn, ...
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


% --- Executes just before versao_1 is made visible.
function versao_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to versao_1 (see VARARGIN)
% Atribuindo valores iniciais para os edit box
set(handles.S,'string','20','UserData',20);
set(handles.w0,'string','0.9','UserData',.9);
set(handles.wf,'string','0.3','UserData',0.3);
set(handles.c1,'string','2.1','UserData',2.1);
set(handles.c2,'string','2.1','UserData',2.1);
set(handles.v_max,'string','3','UserData',3);
set(handles.amostra,'string','1','UserData',1);
set(handles.ite_pso,'string','150','UserData',150);
set(handles.cv,'string','4','UserData',4); 
set(handles.lim_sup,'string','10','UserData',10);
set(handles.lim_inf,'string','-10','UserData',-10);
set(handles.pop_de,'string','20','UserData',20);
set(handles.F,'string','0.7','UserData',0.7);
set(handles.cross_over,'string','0.4','UserData',0.4);
set(handles.div_low,'string','0.15','UserData',0.15);
set(handles.div_high,'string','0.25','UserData',0.25);
set(handles.checkbox_cv,'UserData',1);
%% Inicializa os campos do panel demonstration
set(handles.edit_sample_pred,'string','1','UserData',1);
set(handles.edit_ite_pred,'string','700','UserData',700);
set(handles.edit_sample_sine,'string','1','UserData',1);
set(handles.edit_ite_sine,'string','700','UserData',700);
%set(handles.edit_sample_multi_art,'string','1','UserData',1);
%set(handles.edit_ite_multi_art,'string','250','UserData',250);
set(handles.edit_epsilon,'string','2','UserData',2);
%% Inicializa os campos do panel Grid Search
set(handles.edit_c_min,'string','-10','UserData',10);
set(handles.edit_c_max,'string','10','UserData',10);
set(handles.edit_gama_min,'string','-10','UserData',-10);
set(handles.edit_gama_max,'string','10','UserData',10);
set(handles.edit_step_c,'string','1','UserData',1);
set(handles.edit_step_gamma,'string','1','UserData',1);
%set(handles.edit_epsilon_gs,'string','0.01','UserData',0.01);
%% Controla o surgimento dos paineis com os parâmetros dos algoritmos de otimização
%Painel com os parâmetros do MODE
set(handles.panel_mode,'visible','off')
%set(handles.panel_mopso,'visible','off')
%Painel com os parâmetros do AR
set(handles.div_panel,'visible','off')
%Crossvalidation
set(handles.cv,'visible','off')
set(handles.text12,'visible','off')
%Loss Function e-insensitive
set(handles.edit_epsilon,'visible','off')
set(handles.text_epsilon,'visible','off')
%Grid Search
set(handles.panel_gridsearch,'visible','off')
%% Create tab group
handles.tgroup = uitabgroup('Parent', handles.figure1,'TabLocation', 'Top');
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Optimization');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Ensembles');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', 'Prediction');
handles.tab4 = uitab('Parent', handles.tgroup, 'Title', 'Statistics');
handles.tab5 = uitab('Parent', handles.tgroup, 'Title', 'Demo');

%Place panels into each tab
set(handles.panel_optimization,'Parent',handles.tab1)
set(handles.panel_ensembles,'Parent',handles.tab2)
set(handles.panel_prediction,'Parent',handles.tab3)
set(handles.panel_statistics,'Parent',handles.tab4)
set(handles.panel_demo,'Parent',handles.tab5)

%Reposition each panel to same location as panel 1
%[aux_pos(1,1) aux_pos(1,2) 63 16] Posição antiga
aux_pos = get(handles.panel_optimization,'position');
set(handles.panel_prediction,'position',get(handles.panel_optimization,'position'));
set(handles.panel_statistics,'position',get(handles.panel_optimization,'position'));
set(handles.panel_demo,'position',get(handles.panel_optimization,'position'));
set(handles.panel_ensembles,'position',get(handles.panel_optimization,'position'));
%%
% Choose default command line output for versao_1
handles.output = hObject;
%{
set(handles.classificador,'Value',1);
set(handles.pop_otimizacao,'Value',1);
set(handles.modificador,'Value',1);
%}
% Update handles structure
guidata(hObject, handles);


%


% UIWAIT makes versao_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = versao_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in classificador.
function classificador_Callback(hObject, eventdata, handles)
% hObject    handle to classificador (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Determine the selected data set.
%str = get(hObject, 'String');
val = get(hObject,'Value');
set(handles.classificador,'UserData', val);
% Condicional que controla a parte visual do panel mode - mopso.
if val == 1    
    set(handles.edit_epsilon,'visible','off')  
    set(handles.text_epsilon,'visible','off') 
else
    set(handles.edit_epsilon,'visible','on') 
    set(handles.text_epsilon,'visible','on')    
end

if (val == 7)
    set(handles.uipanel3,'visible','off')
    set(handles.panel_mopso,'visible','off')
    set(handles.panel_mode,'visible','off')
    set(handles.div_panel,'visible','off')
    set(handles.panel_gridsearch,'position',get(handles.uipanel3,'position'));
    %set(handles.panel_gridsearch,'position',[42 18.23 47.5 6.3]);
    set(handles.panel_gridsearch ,'visible','on')
elseif (val == 8)
    set(handles.uipanel3,'visible','off')
    set(handles.panel_mopso,'visible','off')
    set(handles.panel_mode,'visible','off')
    set(handles.div_panel,'visible','off')
    set(handles.panel_gridsearch,'position',get(handles.uipanel3,'position'));
    %set(handles.panel_gridsearch,'position',[42 18.23 47.5 6.3]);
    set(handles.panel_gridsearch ,'visible','on')
    set(handles.text79 ,'visible','off')
    set(handles.edit_epsilon_gs ,'visible','off')
else
    set(handles.uipanel3,'visible','on')
    set(handles.panel_mopso,'visible','on')
    set(handles.panel_gridsearch ,'visible','off')
end
% Hints: contents = cellstr(get(hObject,'String')) returns classificador contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classificador


% --- Executes during object creation, after setting all properties.
function classificador_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classificador (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_otimizacao.
function pop_otimizacao_Callback(hObject, eventdata, handles)
% hObject    handle to pop_otimizacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%str = get(hObject, 'String');
val = get(hObject,'Value');
set(handles.pop_otimizacao,'UserData',val);
% Condicional que controla a parte visual do panel mode - mopso.
if val == 1
    set(handles.panel_mopso,'visible','on')
    set(handles.panel_mode,'visible','off')
    %set(handles.panel_2,'visible','off')   % Colocar aqui o panel mode
elseif ((val == 2)||(val == 3))
    set(handles.panel_mode,'visible','on')
    set(handles.panel_mopso,'visible','off')   
    %set(handles.panel_2,'visible','on') % Colocar aqui o panel mode
end

% Hints: contents = cellstr(get(hObject,'String')) returns pop_otimizacao contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_otimizacao


% --- Executes during object creation, after setting all properties.
function pop_otimizacao_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_otimizacao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in modificador.
function modificador_Callback(hObject, eventdata, handles)
% hObject    handle to modificador (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.modificador,'UserData',get(hObject,'Value'));
% Hints: contents = cellstr(get(hObject,'String')) returns modificador contents as cell array
%        contents{get(hObject,'Value')} returns selected item from modificador
str = get(hObject, 'String');
val = get(hObject,'Value');
% Condicional que controla a parte visual do panel mode - mopso.
if val == 3
    set(handles.div_panel,'visible','on')
   
else
    set(handles.div_panel,'visible','off')   
    
end

% --- Executes during object creation, after setting all properties.
function modificador_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modificador (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function amostra_Callback(hObject, eventdata, handles)
% hObject    handle to amostra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amostra as text
%        str2double(get(hObject,'String')) returns contents of amostra as a double


% --- Executes during object creation, after setting all properties.
function amostra_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amostra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ite_pso_Callback(hObject, eventdata, handles)
% hObject    handle to ite_pso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ite_pso as text
%        str2double(get(hObject,'String')) returns contents of ite_pso as a double


% --- Executes during object creation, after setting all properties.
function ite_pso_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ite_pso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cv_Callback(hObject, eventdata, handles)
% hObject    handle to cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cv as text
%        str2double(get(hObject,'String')) returns contents of cv as a double


% --- Executes during object creation, after setting all properties.
function cv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function S_Callback(hObject, eventdata, handles)
% hObject    handle to S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of S as text
%        str2double(get(hObject,'String')) returns contents of S as a double


% --- Executes during object creation, after setting all properties.
function S_CreateFcn(hObject, eventdata, handles)
% hObject    handle to S (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w0_Callback(hObject, eventdata, handles)
% hObject    handle to w0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w0 as text
%        str2double(get(hObject,'String')) returns contents of w0 as a double


% --- Executes during object creation, after setting all properties.
function w0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wf_Callback(hObject, eventdata, handles)
% hObject    handle to wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wf as text
%        str2double(get(hObject,'String')) returns contents of wf as a double


% --- Executes during object creation, after setting all properties.
function wf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c1_Callback(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c1 as text
%        str2double(get(hObject,'String')) returns contents of c1 as a double


% --- Executes during object creation, after setting all properties.
function c1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c2_Callback(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c2 as text
%        str2double(get(hObject,'String')) returns contents of c2 as a double


% --- Executes during object creation, after setting all properties.
function c2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v_max_Callback(hObject, eventdata, handles)
% hObject    handle to v_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v_max as text
%        str2double(get(hObject,'String')) returns contents of v_max as a double


% --- Executes during object creation, after setting all properties.
function v_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Parâmetros comum a todos os programas
tipo_sv = get(handles.classificador,'UserData');
mod = get(handles.modificador,'UserData');
amostra = str2double(get(handles.amostra,'String'));
ite_mopso = str2double(get(handles.ite_pso,'String'));
k_fold = str2double(get(handles.cv,'String'));
dados = get(handles.ler_dados,'UserData');
kernel = get(handles.popup_kernel,'UserData');

lim_inf = str2double(get(handles.lim_inf,'String'));
lim_sup = str2double(get(handles.lim_sup,'String'));
rand_type = get(handles.popup_rand,'UserData');
div_low = str2double(get(handles.div_low,'String'));
div_high = str2double(get(handles.div_high,'String'));
epsilon = str2double(get(handles.edit_epsilon,'String'));
%%

% [file,path] = uiputfile('*.txt','Save report file');
 
 nome_arquivo = get(handles.pb_save_report,'UserData');

    
if (isempty(dados))
    disp('Selecione um arquivo de entrada válido')
    return;
% elseif (isequal(file,0))
%     disp('User selected Cancel')
%     return;
end

%set(handles.text_report,'string', strcat(nome_arquivo.path, nome_arquivo.nome));
% Foi alterado radicalmente em relação a versão 13, pois aqui LibSVM e o
% LSSVM vão tratar o problema de multi-target
if (get(handles.classificador,'UserData') == 7)||(get(handles.classificador,'UserData') == 8)
    valid = get(handles.pb_pred_load,'UserData');
    c_min = str2double(get(handles.edit_c_min,'String'));
    c_max = str2double(get(handles.edit_c_max,'String'));
    gama_min = str2double(get(handles.edit_gama_min,'String'));
    gama_max = str2double(get(handles.edit_gama_max,'String'));
    step_c = str2double(get(handles.edit_step_c,'String'));
    step_gamma = str2double(get(handles.edit_step_gamma,'String'));
    eps_gs = get(handles.edit_epsilon_gs,'String');
    gridsearch(dados.x,dados.y, valid.x, valid.y, c_min, c_max, step_c, gama_min, gama_max,  step_gamma, eps_gs, nome_arquivo, tipo_sv, kernel);
    
elseif ((get(handles.pop_otimizacao,'UserData') == 1)&&(get(handles.classificador,'UserData') == 2)) %Condicional do MOPSO
    S = str2double(get(handles.S,'String'));
    w0 = str2double(get(handles.w0,'String'));
    wf = str2double(get(handles.wf,'String'));
    c1 = str2double(get(handles.c1,'String'));
    c2 = str2double(get(handles.c2,'String'));
    v_max = str2double(get(handles.v_max,'String'));    

    if get(handles.checkbox_cv,'Value') %Valor do checkbox do cross-validation.
        MOPSO_cross(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, kernel, epsilon);
    else
        dados2 = get(handles.pb_pred_load,'UserData');
        MOPSO_cross(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, dados2.x, dados2.y, kernel, epsilon);
    end

elseif ((get(handles.pop_otimizacao,'UserData') == 2)||(get(handles.pop_otimizacao,'UserData') == 3))       % MODE 2 -> Carlos Eduardo % MODE 3 -> Gilberto Reynoso
    S = str2double(get(handles.pop_de,'String'));
    F = str2double(get(handles.F,'String'));
    cross_over = str2double(get(handles.cross_over,'String'));
    if get(handles.checkbox_cv,'Value') %Valor do checkbox do cross-validation.
        MODE_S(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, F, cross_over, lim_inf, lim_sup, nome_arquivo, rand_type, kernel, div_low, div_high, get(handles.pop_otimizacao,'UserData'), epsilon)
    else
        dados2 = get(handles.pb_pred_load,'UserData');
        MODE_S(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, F, cross_over, lim_inf, lim_sup, nome_arquivo, rand_type, dados2.x, dados2.y, kernel, div_low, div_high, get(handles.pop_otimizacao,'UserData'), epsilon)
    end
    
elseif ((get(handles.pop_otimizacao,'UserData') == 1)&&((get(handles.classificador,'UserData') == 3))) %Multi-target MOPSO
    %Ainda falta completar a análise da passagem de parâmetros.
    S = str2double(get(handles.S,'String'));
    w0 = str2double(get(handles.w0,'String'));
    wf = str2double(get(handles.wf,'String'));
    c1 = str2double(get(handles.c1,'String'));
    c2 = str2double(get(handles.c2,'String'));
    v_max = str2double(get(handles.v_max,'String'));    
   
    fit_mt(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold,  S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, kernel, epsilon)

elseif ((get(handles.pop_otimizacao,'UserData') == 1)&&(get(handles.classificador,'UserData') == 1)) %Condicional do MOPSO
    S = str2double(get(handles.S,'String'));
    w0 = str2double(get(handles.w0,'String'));
    wf = str2double(get(handles.wf,'String'));
    c1 = str2double(get(handles.c1,'String'));
    c2 = str2double(get(handles.c2,'String'));
    v_max = str2double(get(handles.v_max,'String'));    

    if get(handles.checkbox_cv,'Value') %Valor do checkbox do cross-validation.
        MOPSO_cross(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, kernel, 'epsilon'); %Trabalhar com if para não contar o epsilon na classificação o 1 preenche o espaço da variável varargin
    else
        dados2 = get(handles.pb_pred_load,'UserData');
        MOPSO_cross(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, dados2.x, dados2.y, kernel, 'epsilon');
    end      
%{
elseif ((get(handles.pop_otimizacao,'UserData') == 2)&&(((get(handles.classificador,'UserData') == 3)||(get(handles.classificador,'UserData') == 6)))) %Multi-target MODE
    S = str2double(get(handles.pop_de,'String'));
    F = str2double(get(handles.F,'String'));
    cross_over = str2double(get(handles.cross_over,'String'));
    
    if get(handles.checkbox_cv,'Value') %Valor do checkbox do cross-validation.
        MODE_MT(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, F, cross_over, lim_inf, lim_sup, nome_arquivo, rand_type, kernel, div_low, div_high, epsilon)        
    else
        dados2 = get(handles.pb_pred_load,'UserData');
        MODE_MT(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, F, cross_over, lim_inf, lim_sup, nome_arquivo, rand_type, kernel, div_low, div_high, epsilon, dados2.x, dados2.y)
    end
%}
end
  

% --- Executes on button press in ler_dados.
function ler_dados_Callback(hObject, eventdata, handles)
% hObject    handle to ler_dados (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'},'Load data train');

if isequal(dados,0)
    disp('User selected Cancel')    
else
    arquivo = strcat(direc, dados);
    set(handles.text_load_data,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    [x, y] = ler_dados(arquivo);
    dado_aux.x = x;
    dado_aux.y = y;
    set(handles.ler_dados,'UserData', dado_aux);
end

function lim_sup_Callback(hObject, eventdata, handles)
% hObject    handle to lim_sup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lim_sup as text
%        str2double(get(hObject,'String')) returns contents of lim_sup as a double


% --- Executes during object creation, after setting all properties.
function lim_sup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lim_sup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lim_inf_Callback(hObject, eventdata, handles)
% hObject    handle to lim_inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lim_inf as text
%        str2double(get(hObject,'String')) returns contents of lim_inf as a double


% --- Executes during object creation, after setting all properties.
function lim_inf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lim_inf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pop_de_Callback(hObject, eventdata, handles)
% hObject    handle to pop_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pop_de as text
%        str2double(get(hObject,'String')) returns contents of pop_de as a double


% --- Executes during object creation, after setting all properties.
function pop_de_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_de (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function F_Callback(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of F as text
%        str2double(get(hObject,'String')) returns contents of F as a double


% --- Executes during object creation, after setting all properties.
function F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cross_over_Callback(hObject, eventdata, handles)
% hObject    handle to cross_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cross_over as text
%        str2double(get(hObject,'String')) returns contents of cross_over as a double


% --- Executes during object creation, after setting all properties.
function cross_over_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cross_over (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function div_low_Callback(hObject, eventdata, handles)
% hObject    handle to div_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of div_low as text
%        str2double(get(hObject,'String')) returns contents of div_low as a double


% --- Executes during object creation, after setting all properties.
function div_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to div_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function div_high_Callback(hObject, eventdata, handles)
% hObject    handle to div_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of div_high as text
%        str2double(get(hObject,'String')) returns contents of div_high as a double


% --- Executes during object creation, after setting all properties.
function div_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to div_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_sv.
function load_sv_Callback(hObject, eventdata, handles)
% hObject    handle to load_sv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
aux = get(handles.pn_modelo_sv,'SelectedObject');
modelo_sv = get(aux,'String');
if isequal(dados,0)
    disp('User selected Cancel') 
    
elseif (strcmp(modelo_sv , 'Multi-target-SVR'))
    arquivo = strcat(direc, dados);
    set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    model_sv = ler_saida_mt(arquivo);
    set(handles.load_sv,'UserData', model_sv);    
    
elseif (strcmp(modelo_sv , 'Single-target-SVR'))
    arquivo = strcat(direc, dados);
    set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    model_sv = ler_saida_st(arquivo);
    set(handles.load_sv,'UserData', model_sv); 
    
elseif (strcmp(modelo_sv , 'Classify-SVM'))
    arquivo = strcat(direc, dados);
    set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    model_sv = ler_saida_st(arquivo);
    set(handles.load_sv,'UserData', model_sv);
end



% --- Executes on button press in radio_mt.
function radio_mt_Callback(hObject, eventdata, handles)
% hObject    handle to radio_mt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_mt


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in pb_fetatures.
function pb_fetatures_Callback(hObject, eventdata, handles)
% hObject    handle to pb_fetatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
aux = get(handles.pn_pred_test,'SelectedObject');
feat = get(aux,'String');

if isequal(dados,0)
    disp('User selected Cancel')  
    
elseif (strcmp(feat , 'Features '))
    arquivo = strcat(direc, dados);
    set(handles.text_features,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    dado_aux.x = ler_dados_f(arquivo);
    set(handles.pb_fetatures,'UserData', dado_aux);
    
elseif (strcmp(feat , 'Features & Label'))
    arquivo = strcat(direc, dados);
    set(handles.text_features,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    [x, y] = ler_dados(arquivo);
    dado_aux.x = x;
    dado_aux.y = y;
    set(handles.pb_fetatures,'UserData', dado_aux);
end

% --- Executes on button press in pb_prediction.
function pb_prediction_Callback(hObject, eventdata, handles)
% hObject    handle to pb_prediction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux = get(handles.pn_modelo_sv,'SelectedObject');
radio = get(aux,'String');
model = get(handles.load_sv,'UserData');

if (strcmp(model(1).modelo, 'LS-SVM')) % LS-SVM
    if (strcmp(radio , 'Multi-target-SVR'))        
        x =  get(handles.pb_fetatures,'UserData');
        yf = prediction_m (model, x)
        
    elseif(strcmp(radio , 'Single-target-SVR'))        
        x =  get(handles.pb_fetatures,'UserData');
        tic
        yf = prediction_s(model, x);
        time = toc;
        freq = length(yf)/time
        MSE = mean((yf-x.y).^2)
    end
else                %LibSVM
    if (strcmp(radio , 'Multi-target-SVR'))
        x =  get(handles.pb_fetatures,'UserData');
        yf = prediction_m (model, x)
        
    elseif(strcmp(radio , 'Single-target-SVR'))
        x =  get(handles.pb_fetatures,'UserData');
        clc
        yf = prediction_s(model, x);
        %Plotanto a estição do valor real
        figure(1);
        maximo = size(yf,1);
        i = 1:maximo;
        error=yf-x.y;
        subplot(2,1,1);
        plot (i, yf, i, x.y);
        %title('')
        xlabel('data')
        ylabel('Prediction')
        legend('Estimated value','Real value');
        subplot(2,1,2);
        plot (i, error, '*r');
        title('Residuals')
        xlabel('data')
        ylabel('Error')
        figure(2)
        probplot(error);
        
       % normalitytest (error');
        
        %yf = round(yf); % Caso especial do trabalho do Oscar
        
        MSE = mean((error.^2))
        %save('Oscar_dados.mat','yf','x');
        
%         [h,p] = ttest(yf,x.y)
%         disp('H0: The residuals come from normal distribution.')
%         disp('H1: The residuals do not came from normal disbribuition.')
%         if (h == 0)
%             disp('The ttest does not reject the null hypothesis')
%         else
%             disp('The ttest does reject the null hypothesis')
%         end
        
    elseif(strcmp(radio , 'Classify-SVM'))
        x =  get(handles.pb_fetatures,'UserData');
        [accuracy, yf, prob_f] = prediction_classify_lib(model, x);
        fprintf('Accuracy: %10.6f\n', accuracy(1));
        disp('The SVMs are differents from report because of cross-validation to compute probabilities!')
        [~,~,~,AUC] = perfcurve(x.y,prob_f(:,1),x.y(1))
    end
end




% --- Executes during object creation, after setting all properties.
function panel_prediction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to panel_prediction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_plot_data.
function pb_plot_data_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux_model = get(handles.pn_modelo_sv,'SelectedObject');
aux_pred = get(handles.pn_pred_test,'SelectedObject');
radio_model = get(aux_model,'String');
radio_pred = get(aux_pred,'String');

if (strcmp(radio_model , 'Multi-target-SVR'))
    model = get(handles.load_sv,'UserData');
    if(strcmp(radio_pred, 'Features '))        
        x =  get(handles.pb_fetatures,'UserData');
        yf = prediction_m (model, x)
        grafico_multi(model, x,yf);
        
    elseif(strcmp(radio_pred , 'Features & Label-SVR'))        
        x =  get(handles.pb_fetatures,'UserData');
        yf = prediction_m (model, x)
        grafico_multi(model, x,yf)

    end    
elseif(strcmp(radio_model , 'Single-target-SVR'))
    if(strcmp(radio_pred , 'Features & Label'))
        model = get(handles.load_sv,'UserData');
        x =  get(handles.pb_fetatures,'UserData');
        yf = prediction_s (model, x);
        figure(1);
        subplot(2,1,1)
        plot(x.x,x.y, 'bo', x.x,yf,'r*')
        legend('f(x)', 'SVR')
        title('Prediction')
        subplot(2,1,2)
        plot(x.x,x.y - yf,'r*')
        title('Residuals')
    end
end


% --- Executes during object creation, after setting all properties.
function pb_plot_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_plot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_load1_stat.
function pb_load1_stat_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load1_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
amostra = str2double(get(handles.amostra_est,'String'));
if isequal(dados,0)
    disp('User selected Cancel')    
else
    arquivo = strcat(direc, dados);
    set(handles.text_load_data,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    serie1 = ler_relatorio_mt(arquivo, amostra);
    set(handles.pb_load1_stat,'UserData', serie1);
end

% --- Executes on button press in pb_load2_stat.
function pb_load2_stat_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load2_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
amostra = str2double(get(handles.amostra_est2,'String'));
if isequal(dados,0)
    disp('User selected Cancel')    
else
    arquivo = strcat(direc, dados);
    set(handles.text_load_data,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    serie2 = ler_relatorio_mt(arquivo, amostra);
    set(handles.pb_load2_stat,'UserData', serie2);
end


function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function amostra_est_Callback(hObject, eventdata, handles)
% hObject    handle to amostra_est (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amostra_est as text
%        str2double(get(hObject,'String')) returns contents of amostra_est as a double


% --- Executes during object creation, after setting all properties.
function amostra_est_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amostra_est (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_run_stats.
function pb_run_stats_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run_stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
serie1 = get(handles.pb_load1_stat,'UserData');
serie2 = get(handles.pb_load2_stat,'UserData');
est_teste(serie1(1).erro(:,1), serie2(1).erro(:,1));



function amostra_est2_Callback(hObject, eventdata, handles)
% hObject    handle to amostra_est2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of amostra_est2 as text
%        str2double(get(hObject,'String')) returns contents of amostra_est2 as a double


% --- Executes during object creation, after setting all properties.
function amostra_est2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to amostra_est2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_rand.
function popup_rand_Callback(hObject, eventdata, handles)
% hObject    handle to popup_rand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_rand contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_rand
str = get(hObject, 'String');
val = get(hObject,'Value');
set(handles.popup_rand,'UserData', val);


% --- Executes during object creation, after setting all properties.
function popup_rand_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_rand (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_stats_main.
function popup_stats_main_Callback(hObject, eventdata, handles)
% hObject    handle to popup_stats_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_stats_main contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_stats_main
val = get(hObject,'Value');
set(handles.popup_stats_main,'UserData', val);


% --- Executes during object creation, after setting all properties.
function popup_stats_main_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_stats_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_data_load_st_stats.
function pb_data_load_st_stats_Callback(hObject, eventdata, handles)
% hObject    handle to pb_data_load_st_stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
aux = get(handles.popup_stats_main,'UserData');
if isequal(dados,0)
    disp('User selected Cancel') 
    
elseif (aux == 1)
    arquivo = strcat(direc, dados);
    %set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    metricas = ler_stat_opt(arquivo);
    metricas = metricas.itera;
    set(handles.pb_data_load_st_stats,'UserData', metricas);   
end
% --- Executes on button press in checkbox_mean.
function checkbox_mean_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_mean
media_log = get(hObject,'Value');
set(handles.checkbox_mean,'UserData', media_log);

% --- Executes on button press in checkbox_std_stat.
function checkbox_std_stat_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_std_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_std_stat
std_log = get(hObject,'Value');
set(handles.checkbox_std_stat,'UserData', std_log);

% --- Executes on button press in checkbox_mediana_stat.
rfunction checkbox_mediana_stat_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_mediana_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_mediana_stat
mediana_log = get(hObject,'Value');
set(handles.checkbox_mediana_stat,'UserData', mediana_log);

% --- Executes on button press in checkbox_pareto_stat.
function checkbox_pareto_stat_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pareto_stat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pareto_stat
pareto_log = get(hObject,'Value');
set(handles.checkbox_pareto_stat,'UserData', pareto_log);

if(pareto_log == 1)
    [dados, direc] = uigetfile({'*.txt'});
    aux = get(handles.popup_stats_main,'UserData');
    
    if isequal(dados,0)
        disp('User selected Cancel')
        set(hObject,'Value', 0);
    elseif (aux == 1)
        arquivo = strcat(direc, dados);
        %set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
        [metricas, tipo_maq]= ler_relatorio_st(arquivo);
        dados_relatorio.metricas = metricas;
        dados_relatorio.tipo_maq = tipo_maq;
        set(handles.checkbox_pareto_stat,'UserData', dados_relatorio);
    end
end

% --- Executes on button press in pb_run_st_stats.
function pb_run_st_stats_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run_st_stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Voltar a função para aglomerar todas as amostras no mesmo arquivo para que
%seja possível fazer a média, desvio padrão e mediana.
%vai ser preciso inicializar os checkbox
media_log = get(handles.checkbox_mean,'UserData');
std_log = get(handles.checkbox_std_stat,'UserData');
mediana_log = get(handles.checkbox_mediana_stat,'UserData');
pareto = get(handles.checkbox_pareto_stat,'UserData');

metricas = get(handles.pb_data_load_st_stats,'UserData');
%metricas = metricas.itera;

[l, c] = size(metricas);
amostra = c/3;
t=1:l;
for i = 1:c
    if (i <= amostra)
        figure(1)
        hold on
        plot(t, metricas(:,i))
        title ('Spacing Metrics')
        xlabel('Iteration')
        ylabel('Spacing')
                
    elseif ((i > amostra)&& (i<= 2*amostra))
        figure(2)
        hold on
        plot(t, metricas(:,i))
        title ('Cardinality of the Pareto Front')
        xlabel('Iteration')
        ylabel('Cardinality')
    else
        figure(3)
        hold on
        plot(t, metricas(:,i))
        title ('Hypervolume Metric')
        xlabel('Iteration')
        ylabel('Hypervolume')        
    end
end
%Calculando e plotando os gráficos da média
if (media_log == 1)    
    for i = 1:l
        media_spacing(i,1) = mean(metricas(i,1:amostra));
        media_card(i,1)= mean(metricas(i,amostra+1:2*amostra));
        media_hyper(i,1) = mean(metricas(i,2*amostra+1:end));
    end
    figure(1)
    hold on
    plot(t, media_spacing,'r');
    legend('Mean')
    
    figure(2)
    hold on
    plot(t, media_card,'r');
    legend('Mean')
    
    figure(3)
    hold on
    plot(t, media_hyper,'r');
    legend('Mean')
    
end
%Calculando e plotando os gráficos do desvio padrão
if (std_log == 1)    
    for i = 1:l
        std_spacing(i,1) = std(metricas(i,1:amostra));
        std_card(i,1)= std(metricas(i,amostra+1:2*amostra));
        std_hyper(i,1) = std(metricas(i,2*amostra+1:end));
    end
    figure(1)
    hold on
    plot(t, std_spacing,'c');
    legend('Standart Deviation')
    
    figure(2)
    hold on
    plot(t, std_card,'c');
    legend('Standart Deviation')
    
    figure(3)
    hold on
    plot(t, std_hyper,'c');
    legend('Standart Deviation')
    
end
%Calculando e plotando os gráficos da mediana
if (mediana_log == 1)    
    for i = 1:l
        median_spacing(i,1) = median(metricas(i,1:amostra));
        median_card(i,1)= median(metricas(i,amostra+1:2*amostra));
        median_hyper(i,1) = median(metricas(i,2*amostra+1:end));
    end
    figure(1)
    plot(t, median_spacing,'g');
    legend('Median')
    figure(2)
    plot(t, median_card,'g');
    legend('Median')
    figure(3)
    hold on
    plot(t, median_hyper,'g');
    legend('Median')
end
if isfield(pareto.metricas, 'sv')    
    [~,b]=size(pareto.metricas);
    for i = 1:b
       figure (i+3)
       hold on
       %scatter3(pareto.metricas(i).erro, pareto.metricas(i).sv, pareto.metricas(i).corr, 'r*')
       scatter(pareto.metricas(i).erro, pareto.metricas(i).sv, 'r*')
%        scatter3(0*pareto.metricas(i).erro, pareto.metricas(i).sv, pareto.metricas(i).corr, 'bo')
%        scatter3(pareto.metricas(i).erro, 0*pareto.metricas(i).sv, pareto.metricas(i).corr, 'go')
%        scatter3(pareto.metricas(i).erro, pareto.metricas(i).sv, 0*pareto.metricas(i).corr, 'ko')
       axis([0 inf 0 inf 0 inf]);
       title('Pareto Frontier')
       if strcmp(pareto.tipo_maq, 'Regression')
           xlabel('Mean Square Error')
           ylabel('Support Vectors')
           zlabel('1-R^2')
       else
           xlabel('Accuracy - Error')
           ylabel('Support Vectors')
           zlabel('Area Under Curve Complement: 1 - AUC')

       end
       grid  on
       hold off
    end
end


% --- Executes on button press in pb_data_load_mt_stats.
function pb_data_load_mt_stats_Callback(hObject, eventdata, handles)
% hObject    handle to pb_data_load_mt_stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
aux = get(handles.popup_stats_main,'UserData');
if isequal(dados,0)
    disp('User selected Cancel') 
    
elseif (aux == 2)
    arquivo = strcat(direc, dados);
    %set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    [metrica1, metrica2] = ler_stat_metrica_mt(arquivo);
    set(handles.pb_data_load_mt_stats,'UserData', {metrica1, metrica2});   
end

% --- Executes on button press in checkbox_mean_mt.
function checkbox_mean_mt_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_mean_mt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_mean_mt
media_log = get(hObject,'Value');
set(handles.checkbox_mean_mt,'UserData', media_log);

% --- Executes on button press in checkbox_std_stat_mt.
function checkbox_std_stat_mt_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_std_stat_mt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_std_stat_mt
std_log = get(hObject,'Value');
set(handles.checkbox_std_stat_mt,'UserData', std_log);

% --- Executes on button press in checkbox_median_stat_mt.
function checkbox_median_stat_mt_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_median_stat_mt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_median_stat_mt
median_log = get(hObject,'Value');
set(handles.checkbox_median_stat_mt,'UserData', median_log);

% --- Executes on button press in checkbox_pareto_stat_mt.
function checkbox_pareto_stat_mt_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_pareto_stat_mt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_pareto_stat_mt
pareto_log = get(hObject,'Value');
set(handles.checkbox_pareto_stat,'UserData', pareto_log);

if(pareto_log == 1)
    [dados, direc] = uigetfile({'*.txt'});
    aux = get(handles.popup_stats_main,'UserData');
    if isequal(dados,0)
        disp('User selected Cancel')
        set(hObject,'Value', 0);
    elseif (aux == 2)
        arquivo = strcat(direc, dados);
        %set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
        [serie1, serie2]=ler_relat_stat_mt(arquivo);
        set(handles.checkbox_pareto_stat_mt,'UserData', {serie1, serie2});
    end
end

% --- Executes on button press in pb_run_mt_stats.
function pb_run_mt_stats_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run_mt_stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Mudar para multi-target e adaptar
media_log = get(handles.checkbox_mean_mt,'UserData');
std_log = get(handles.checkbox_std_stat_mt,'UserData');
mediana_log = get(handles.checkbox_median_stat_mt,'UserData');
pareto = get(handles.checkbox_pareto_stat_mt,'UserData');

metricas = get(handles.pb_data_load_mt_stats,'UserData');  % Por algum motivo o Matlab não passou os dados como uma estrutura de mais de dois nível então usei cell array
metrica1 = metricas{1};             %Dados da primeira fase
metrica2 = metricas{2};             %Dados da segunda fase

[l, c] = size(metrica1(1).card);    % O primeiro parênteses em metrica1 se refere a saída. Aqui foi escolhido uma das saída apenas para pegar o número de iterações
[~, ny] = size(metrica1);
t=1:c;
%Construindo os gráficos da fase 1
for i = 1:ny      %for que varia as saidas da fase 1
    for j = 1:l   %for que varia as amostras da fase 1
        %Plotando a cardinalidade
        figure(i);
        hold on;
        plot(t,metrica1(i).card(j,:));
        ititulo = num2str(i);
        titulo = ['Cardinality of the Pareto Front - Fase 1 - y_', ititulo];
        title (titulo);
        xlabel('Iteration')
        ylabel('Cardinality')
        
        figure(i+ny);
        hold on;
        plot(t,metrica1(i).spa(j,:));
        titulo = ['Spacing of the Pareto Front - Fase 1 - y_', ititulo];
        title (titulo);
        xlabel('Iteration')
        ylabel('Spacing')
        
        figure(i+2*ny);
        hold on;
        plot(t,metrica1(i).hyper(j,:));
        titulo = ['Hypervolume of the Pareto Front - Fase 1 - y_', ititulo];
        title (titulo);
        xlabel('Iteration')
        ylabel('Hypervolume')
        
    end         %Fim do for das amostras
    % If que calcula e plota a média das saídas da primeira fase.
    if (media_log == 1)
        for k = 1:c %Calcula a média da cardinalidade, spacing e hipervolume
            media_card(k,1)= mean(metrica1(i).card(:,k));
            media_spacing(k,1) = mean(metrica1(i).spa(:,k));
            media_hyper(k,1) = mean(metrica1(i).hyper(:,k));
        end
        figure(i)
        hold on
        plot(t, media_card,'r');
        legend('Mean')
        
        figure(i+ny)
        hold on
        plot(t, media_spacing,'r');
        legend('Mean')      
        
        figure(i+2*ny)
        hold on
        plot(t, media_hyper,'r');
        legend('Mean')       
    end
    % If que calcula e plota o desvio padrão das saídas da primeira fase.
    if (std_log == 1)
        for k = 1:c %Calcula a média da cardinalidade e spacing
            std_card(k,1)= std(metrica1(i).card(:,k));
            std_spacing(k,1) = std(metrica1(i).spa(:,k));
            std_hyper(k,1) = std(metrica1(i).hyper(:,k));
        end
        figure(i)
        hold on
        plot(t, std_card,'g');
        legend('Standart Deviation')
        
        figure(i+ny)
        hold on
        plot(t, std_spacing,'g');
        legend('Standart Deviation')       
        
        figure(i+2*ny)
        hold on
        plot(t, std_hyper,'g');
        legend('Standart Deviation')       
    end    
    % If que calcula e plota a mediana das saídas da primeira fase.
    if (mediana_log == 1)
        for k = 1:c %Calcula a média da cardinalidade e spacing
            mediana_card(k,1)= median(metrica1(i).card(:,k));
            mediana_spacing(k,1) = median(metrica1(i).spa(:,k));
            mediana_hyper(k,1) = median(metrica1(i).hyper(:,k));
        end
        figure(i)
        hold on
        plot(t, mediana_card,'m');
        legend('Median')
        
        figure(i+ny)
        hold on
        plot(t, mediana_spacing,'m');
        legend('Standart Deviation')  
        
        figure(i+2*ny)
        hold on
        plot(t, mediana_hyper,'m');
        legend('Standart Deviation')   
    end    
    
end
%Plotando os dados da segunda fase

for i = 1:ny      %for que varia as saidas da fase 2
    for j = 1:l   %for que varia as amostras da fase 2
        %Plotando a cardinalidade
        figure(i+3*ny);
        hold on;
        plot(t,metrica2(i).card(j,:));
        ititulo = num2str(i);
        titulo = ['Cardinality of the Pareto Front - Fase 2 - y_', ititulo];
        title (titulo);
        xlabel('Iteration')
        ylabel('Cardinality')
        
        figure(i+4*ny);
        hold on;
        plot(t,metrica2(i).spa(j,:));
        titulo = ['Spacing of the Pareto Front - Fase 2 - y_', ititulo];
        title (titulo);
        xlabel('Iteration')
        ylabel('Spacing')
        
        figure(i+5*ny);
        hold on;
        plot(t,metrica2(i).hyper(j,:));
        titulo = ['Hypervolume of the Pareto Front - Fase 2 - y_', ititulo];
        title (titulo);
        xlabel('Iteration')
        ylabel('Hypervolume')
    end
    % If que calcula e plota a média das saídas da segunda fase.
    if (media_log == 1)
        for k = 1:c %Calcula a média da cardinalidade e spacing
            media_card(k,1)= mean(metrica2(i).card(:,k));
            media_spacing(k,1) = mean(metrica2(i).spa(:,k));
            media_hyper(k,1) = mean(metrica2(i).hyper(:,k));
        end
        figure(i+3*ny)
        hold on
        plot(t, media_card,'r');
        legend('Mean')
        
        figure(i+4*ny)
        hold on
        plot(t, media_spacing,'r');
        legend('Mean')
        
        figure(i+5*ny)
        hold on
        plot(t, media_hyper,'r');
        legend('Mean')       
    end    
    % If que calcula e plota o desvio padrão das saídas da segunda fase.
    if (std_log == 1)
        for k = 1:c %Calcula a média da cardinalidade e spacing
            std_card(k,1)= std(metrica2(i).card(:,k));
            std_spacing(k,1) = std(metrica2(i).spa(:,k));
            std_hyper(k,1) = std(metrica2(i).hyper(:,k));
        end
        figure(i+3*ny)
        hold on
        plot(t, std_card,'g');
        legend('Standart Deviation')
        
        figure(i+4*ny)
        hold on
        plot(t, std_spacing,'g');
        legend('Standart Deviation')  
        
        figure(i+5*ny)
        hold on
        plot(t, std_hyper,'g');
        legend('Standart Deviation')    
    end    
    % If que calcula e plota a mediana das saídas da segunda fase.
    if (mediana_log == 1)
        for k = 1:c %Calcula a média da cardinalidade e spacing
            mediana_card(k,1)= median(metrica2(i).card(:,k));
            mediana_spacing(k,1) = median(metrica2(i).spa(:,k));
            mediana_hyper(k,1) = median(metrica2(i).hyper(:,k));
        end
        figure(i+3*ny)
        hold on
        plot(t, mediana_card,'m');
        legend('Median')
        
        figure(i+4*ny)
        hold on
        plot(t, mediana_spacing,'m');
        legend('Median')     
        
        figure(i+5*ny)
        hold on
        plot(t, mediana_hyper,'m');
        legend('Median')       
    end        
end

%Plotando a fronteira de Pareto
if ~(isempty(pareto))
    pareto_f1 = pareto{1};      %dados da fronteira de Pareto da primeira fase
    pareto_f2 = pareto{2};      %dados da fronteira de Pareto da segunda fase
    
    [~,b]=size(pareto_f1(1).erro);
    [~, amostras] = size(pareto_f1);
    k=4*ny+1;
    if isfield(pareto_f1, 'sv')
        for j=1:amostras                %for das amostras
            for i = 1:b                 %for das saídas
                %plotando as figuras da primeira fase
                figure (k)
                subplot(1,2,1)
                scatter3(pareto_f1(j).erro(:,i), pareto_f1(j).sv(:,i), pareto_f1(j).corr(:,i), 'r*')
                titulo = ['Pareto Front y_', num2str(i), ' - Amostra - ', num2str(j)];
                title(titulo);
                xlabel('MSE - Error')
                ylabel('Support Vectors')
                zlabel('Correlation')
                
                subplot(1,2,2)
                scatter3(pareto_f2(j).erro(:,i), pareto_f2(j).sv(:,i), pareto_f2(j).corr(:,i), 'r*')
                titulo = ['Pareto Front y_', num2str(i), ' - Amostra - ', num2str(j)];
                title(titulo);
                xlabel('MSE - Error')
                ylabel('Support Vectors')
                zlabel('Correlation')
                k=k+1;
            end
        end
    end
end


function edit_number_targets_Callback(hObject, eventdata, handles)
% hObject    handle to edit_number_targets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_number_targets as text
%        str2double(get(hObject,'String')) returns contents of edit_number_targets as a double


% --- Executes during object creation, after setting all properties.
function edit_number_targets_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_number_targets (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_cv.
function checkbox_cv_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_cv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_cv
cv = get(hObject,'Value');
if (cv == 1)
    set(handles.cv,'visible','on')
    set(handles.text12,'visible','on')
    set(handles.pb_pred_load,'visible','off')
    set(handles.text_load_data_valida,'visible','off')
    set(handles.text80,'visible','off')
else
    set(handles.cv,'visible','off')
    set(handles.text12,'visible','off')
    set(handles.pb_pred_load,'visible','on')
    set(handles.text_load_data_valida,'visible','on')
    set(handles.text80,'visible','on')

end

% --- Executes on button press in pb_pred_load.
function pb_pred_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pred_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[dados, direc] = uigetfile({'*.txt'});
[dados, direc] = uigetfile({'*.txt'},'Load data validation',get(handles.text_load_data,'string'));

if isequal(dados,0)
    disp('User selected Cancel')    
else
    arquivo = strcat(direc, dados);
    set(handles.text_load_data_valida,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    [x, y] = ler_dados(arquivo);
    dado_aux.x = x;
    dado_aux.y = y;
    set(handles.pb_pred_load,'UserData', dado_aux);
end


% --- Executes on selection change in popup_kernel.
function popup_kernel_Callback(hObject, eventdata, handles)
% hObject    handle to popup_kernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%str = get(hObject, 'String');
val = get(hObject,'Value');
set(handles.popup_kernel,'UserData',val);

% Hints: contents = cellstr(get(hObject,'String')) returns popup_kernel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_kernel


% --- Executes during object creation, after setting all properties.
function popup_kernel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_kernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsilon_Callback(hObject, eventdata, handles)
% hObject    handle to epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsilon as text
%        str2double(get(hObject,'String')) returns contents of epsilon as a double


% --- Executes during object creation, after setting all properties.
function epsilon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_load_test_1.
function pb_load_test_1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load_test_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
aux = get(handles.popup_stats_main,'UserData');
if isequal(dados,0)
    disp('User selected Cancel') 
    
elseif (aux == 1)
    arquivo = strcat(direc, dados);
    %set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    metricas = ler_stat_opt(arquivo);
    metricas = metricas.otima;
    set(handles.pb_load_test_1,'UserData', metricas);   
end

% --- Executes on button press in pb_load_test_2.
function pb_load_test_2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load_test_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'});
aux = get(handles.popup_stats_main,'UserData');
if isequal(dados,0)
    disp('User selected Cancel') 
    
elseif (aux == 1)
    arquivo = strcat(direc, dados);
    %set(handles.text_model,'string',arquivo);  %Apresenta na tela o arquivo que está sendo lido
    metricas = ler_stat_opt(arquivo);
    metricas = metricas.otima;
    set(handles.pb_load_test_2,'UserData', metricas);   
end

% --- Executes on button press in pb_run_test_h.
function pb_run_test_h_Callback(hObject, eventdata, handles)
% hObject    handle to pb_run_test_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
serie1 = get(handles.pb_load_test_1,'UserData');
serie2 = get(handles.pb_load_test_2,'UserData');
for i = 1:3
    teste_hipotese(serie1(:,i), serie2(:,i));
    pause
end


% --- Executes on button press in pb_exemplo_pred.
function pb_exemplo_pred_Callback(hObject, eventdata, handles)
% hObject    handle to pb_exemplo_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Parâmetros comum a todos os programas
tipo_sv = 2;            %SVR-LIBSVM
mod = 1;                %Nenhum
amostra = str2double(get(handles.edit_sample_pred,'String'));
ite_mopso = str2double(get(handles.edit_ite_pred,'String'));
k_fold = 2;

%% Obtendo os dados do arquivo de treinamento e validação
%Dados de treinamento
    aux_arq = [pwd '/'];
    arquivo = [aux_arq 'demo/controle_preditivo/ctr_pred_treino2.txt'];
    [x, y] = ler_dados(arquivo);
    dados.x = x;
    dados.y = y;
    
%Dados de validação

    arquivo = [aux_arq 'demo/controle_preditivo/ctr_pred_validad2.txt'];
    [x, y] = ler_dados(arquivo);
    dados2.x = x;
    dados2.y = y;
%%
kernel = 1;

lim_inf = 0.00001;
lim_sup = 250;
rand_type = 1;
div_low = 0.15;
div_high = 0.25;
epsilon = 0.035;

S = 20;
w0 = 18;
wf = 0.0001;
c1 = 1.9;
c2 = 2.2;
v_max = 25;    
nome_arquivo.nome = 'relatorio_predicao.txt';
nome_arquivo.path = [aux_arq 'demo/result_pred/'];
path = nome_arquivo.path;
MOPSO_cross(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, dados2.x, dados2.y, kernel, epsilon);




function edit_sample_pred_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sample_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sample_pred as text
%        str2double(get(hObject,'String')) returns contents of edit_sample_pred as a double


% --- Executes during object creation, after setting all properties.
function edit_sample_pred_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sample_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ite_pred_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ite_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ite_pred as text
%        str2double(get(hObject,'String')) returns contents of edit_ite_pred as a double


% --- Executes during object creation, after setting all properties.
function edit_ite_pred_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ite_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_plot_pred.
function pb_plot_pred_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
caminho = [pwd '/demo/result_pred'];
addpath(caminho);
grafico_pred


% --- Executes on button press in pb_exemplo_sine.
function pb_exemplo_sine_Callback(hObject, eventdata, handles)
% hObject    handle to pb_exemplo_sine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Parâmetros comum a todos os programas
tipo_sv = 2;            %SVR-LIBSVM
mod = 1;                %Nenhum
amostra = str2double(get(handles.edit_sample_sine,'String'));
ite_mopso = str2double(get(handles.edit_ite_sine,'String'));
k_fold = 2;

%% Obtendo os dados do arquivo de treinamento e validação
%Dados de treinamento
    aux_arq = [pwd '/'];
    arquivo = [aux_arq 'demo/sine/7seno.txt'];
    [x, y] = ler_dados(arquivo);
    dados.x = x;
    dados.y = y;
    
%Dados de validação

    arquivo = [aux_arq 'demo/sine/7seno_validade.txt'];
    [x, y] = ler_dados(arquivo);
    dados2.x = x;
    dados2.y = y;
%%
kernel = 1;

lim_inf = 0.00001;
lim_sup = 250;
rand_type = 2;
div_low = 0.15;
div_high = 0.25;
epsilon = 0.01;
%Parâmetros MODE
S = 20;
F = 0.8;
cross_over = 0.3;
%Arquivo relatório    
nome_arquivo.nome = 'relatorio_sine.txt';
nome_arquivo.path = [aux_arq 'demo/result_sine/'];
path = nome_arquivo.path;
MODE_S(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold, S, F, cross_over, lim_inf, lim_sup, nome_arquivo, rand_type, dados2.x, dados2.y, kernel, div_low, div_high, epsilon)



function edit_sample_sine_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sample_sine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sample_sine as text
%        str2double(get(hObject,'String')) returns contents of edit_sample_sine as a double


% --- Executes during object creation, after setting all properties.
function edit_sample_sine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sample_sine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ite_sine_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ite_sine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ite_sine as text
%        str2double(get(hObject,'String')) returns contents of edit_ite_sine as a double


% --- Executes during object creation, after setting all properties.
function edit_ite_sine_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ite_sine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_plot_sine.
function pb_plot_sine_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot_sine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%pegar a funções para ler os arquivos da pasta result_sine


nome = [pwd '/demo/result_sine/7seno.txt']
[x_t.x y_t] = ler_dados(nome);      %Necessário colocar x como uma estrututura devido a forma da função prediction_s
nome = [pwd '/demo/result_sine/7seno_prediction.txt']
[x_p.x, y_p] = ler_dados(nome);
i=1;
arquivo  = [pwd '/demo/result_sine/SVM_1_' num2str(i) '.txt'];
while(fopen(arquivo)~= -1)
    model = ler_saida_st(arquivo);
    yf_p = prediction_s (model, x_p);
    yf_t = prediction_s (model, x_t);
    figure(i);
    subplot(2,2,1)
    plot(x_t.x,y_t, 'bo', x_t.x,yf_t,'r*')
    legend('f(x)', 'SVR')
    title('Prediction - Train Set')
    subplot(2,2,3)
    resi_t = y_t - yf_t;
    plot(x_t.x,resi_t ,'r*')
    title('Residuals')
    MSE_t = mean(resi_t.^2);
    
    subplot(2,2,2)
    plot(x_p.x,y_p, 'bo', x_p.x,yf_p,'r*')
    legend('f(x)', 'SVR')
    title('Prediction - Test Set')
    subplot(2,2,4)
    resi_p = y_p - yf_p;
    plot(x_p.x,resi_p,'r*')
    title('Residuals')
    MSE_p = mean(resi_p.^2);
    annotation('textbox', [0.1 0.5 0.5 0.05], 'String', {[strcat('#SV = ', num2str(model.card_sv)),'  ', strcat('MSE_{train}  = ', num2str(MSE_t))]}, 'LineStyle', 'none')
    annotation('textbox', [0.6 0.5 0.5 0.05], 'String', {[strcat('#SV = ', num2str(model.card_sv)),'  ', strcat('MSE_{test}  = ', num2str(MSE_p))]}, 'LineStyle', 'none')
    i=i+1;
    arquivo  = [pwd '/demo/result_sine/SVM_1_' num2str(i) '.txt'];
end

% --- Executes during object creation, after setting all properties.
function pb_plot_pred_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pb_plot_pred (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pb_multi_art.
function pb_multi_art_Callback(hObject, eventdata, handles)
% hObject    handle to pb_multi_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Parâmetros comum a todos os programas
tipo_sv = 3;            %SVR-LIBSVM
mod = 1;                %Nenhum
amostra = str2double(get(handles.edit_sample_multi_art,'String'));
ite_mopso = str2double(get(handles.edit_ite_multi_art,'String'));
k_fold = 4;

%% Obtendo os dados do arquivo de treinamento e validação
%Dados de treinamento
    aux_arq = [pwd '/'];
    arquivo = [aux_arq 'demo/multi_funcao/multi_trig_treino_2.txt'];
    [x, y] = ler_dados(arquivo);
    dados.x = x;
    dados.y = y;    
%%
kernel = 1;

lim_inf = 0.00001;
lim_sup = 250;
rand_type = 2;
div_low = 0.15;
div_high = 0.25;
epsilon = 0.035;

S = 20;
w0 = 18;
wf = 0.0001;
c1 = 1.9;
c2 = 2.2;
v_max = 25;    
nome_arquivo.nome = 'relatorio_multi_trig_treino_2.txt';
nome_arquivo.path = [aux_arq 'demo/result_multi_funcao/'];
path = nome_arquivo.path;
  
fit_mt(tipo_sv, mod, amostra, ite_mopso, dados.x, dados.y, k_fold,  S, w0, wf, c1, c2, v_max, lim_inf, lim_sup, div_low, div_high, nome_arquivo, path, rand_type, kernel, epsilon)
    


function edit_sample_multi_art_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sample_multi_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sample_multi_art as text
%        str2double(get(hObject,'String')) returns contents of edit_sample_multi_art as a double


% --- Executes during object creation, after setting all properties.
function edit_sample_multi_art_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sample_multi_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ite_multi_art_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ite_multi_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ite_multi_art as text
%        str2double(get(hObject,'String')) returns contents of edit_ite_multi_art as a double


% --- Executes during object creation, after setting all properties.
function edit_ite_multi_art_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ite_multi_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_plot_multi_art.
function pb_plot_multi_art_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot_multi_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nome = [pwd '/demo/result_multi_funcao/SVM_MT_1.txt'];
model = ler_saida_mt(nome);

arquivo = [pwd '/demo/multi_funcao/multi_trig_predit_2.txt'];
[x, y] = ler_dados(arquivo);
dado_aux.x = x;
dado_aux.y = y;
yf = prediction_m (model, dado_aux)
grafico_multi(model, dado_aux,yf)


% --- Executes during object creation, after setting all properties.
function panel_mopso_CreateFcn(hObject, eventdata, handles)
% hObject    handle to panel_mopso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_c_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c_max as text
%        str2double(get(hObject,'String')) returns contents of edit_c_max as a double


% --- Executes during object creation, after setting all properties.
function edit_c_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_gama_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gama_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gama_max as text
%        str2double(get(hObject,'String')) returns contents of edit_gama_max as a double


% --- Executes during object creation, after setting all properties.
function edit_gama_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gama_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_c_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_c_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_c_min as text
%        str2double(get(hObject,'String')) returns contents of edit_c_min as a double


% --- Executes during object creation, after setting all properties.
function edit_c_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_c_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_gama_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gama_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gama_min as text
%        str2double(get(hObject,'String')) returns contents of edit_gama_min as a double


% --- Executes during object creation, after setting all properties.
function edit_gama_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gama_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_step_c_Callback(hObject, eventdata, handles)
% hObject    handle to edit_step_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_step_c as text
%        str2double(get(hObject,'String')) returns contents of edit_step_c as a double


% --- Executes during object creation, after setting all properties.
function edit_step_c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_step_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_step_gamma_Callback(hObject, eventdata, handles)
% hObject    handle to edit_step_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_step_gamma as text
%        str2double(get(hObject,'String')) returns contents of edit_step_gamma as a double


% --- Executes during object creation, after setting all properties.
function edit_step_gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_step_gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_epsilon_gs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epsilon_gs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epsilon_gs as text
%        str2double(get(hObject,'String')) returns contents of edit_epsilon_gs as a double


% --- Executes during object creation, after setting all properties.
function edit_epsilon_gs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epsilon_gs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_correlation_plot.
function pb_correlation_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pb_correlation_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
aux_model = get(handles.pn_modelo_sv,'SelectedObject');
aux_pred = get(handles.pn_pred_test,'SelectedObject');
radio_model = get(aux_model,'String');
radio_pred = get(aux_pred,'String');

if (strcmp(radio_model , 'Multi-target-SVR'))
    disp('Option not avaliable. Try Single-target-SVR.\n')
elseif(strcmp(radio_model , 'Classify-SVM'))
    model = get(handles.load_sv,'UserData');
    x =  get(handles.pb_fetatures,'UserData');
    [~, ~,prob_yf] = prediction_classify_lib(model, x);
    %Ajustando x.y para plotroc
    classes = unique (model.yt(:, end), 'stable'); %Pq o LibSVM identifica as classes por ordem de aparição no conjunto de treinamento
    k = size(classes,1);
    ky = size(x.y,1);
    y_t = zeros(ky, k);
    for i = 1:ky
        for j =1:k
            if(x.y(i)== classes(j))
                y_t(i,j) = 1;
            end
        end
    end
    figure(1)
    plotroc(y_t',prob_yf')
    
else
    if(strcmp(radio_pred , 'Features & Label'))
        model = get(handles.load_sv,'UserData');
        x =  get(handles.pb_fetatures,'UserData');
        yf = prediction_s (model, x);
        figure(2);
        hold on
        plot(yf,x.y, 'r*');
        xr = min(x.y):0.01:max(x.y);
        plot (xr,xr, '--')
        xlabel ('Prediction data - $\hat{y}$','Interpreter','latex')
        ylabel ('Labels - y')
        %calculando o R^2
        yresid = x.y - yf;
        SSresid = sum(yresid.^2);
        SStotal = (length(x.y)-1)*var(x.y);
        rsq = 1-SSresid/SStotal;
        title ('Coeficient Correlation Plot')
        %annotation('textbox', [0.1 0.03 0.5 0.05], 'String', {strcat('R^2 = ', num2str(rsq))}, 'LineStyle', 'none')
        annotation('textbox', [0.1 0.03 0.5 0.05], 'String', {strcat('CC = ', num2str(rsq))}, 'LineStyle', 'none')
        hold off
%         subplot(2,1,1)
%         plot(x.x,x.y, 'bo', x.x,yf,'r*')
%         legend('f(x)', 'SVR')
%         title('Prediction')
%         subplot(2,1,2)
%         plot(x.x,x.y - yf,'r*')
%         title('Residuals')
    else
        disp('Option not avaliable. Try Features & Label option');
    end
end


% --- Executes during object creation, after setting all properties.
function text25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_epsilon_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epsilon as text
%        str2double(get(hObject,'String')) returns contents of edit_epsilon as a double


% --- Executes during object creation, after setting all properties.
function edit_epsilon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epsilon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_save_report.
function pb_save_report_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nome_arquivo.nome,nome_arquivo.path] = uiputfile('*.txt','Save report file');
if (isequal(nome_arquivo.nome,0))
     disp('User selected Cancel')
     return;
end
set(handles.pb_save_report,'UserData', nome_arquivo);

set(handles.text_report,'string', strcat(nome_arquivo.path, nome_arquivo.nome));


% --- Executes on button press in pb_ens_load.
function pb_ens_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ens_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'},'Load Pareto Front');

if isequal(dados,0)
    disp('User selected Cancel')    
else
    file_path = strcat(direc, dados);
    pareto = ler_pareto_set (file_path, 0, 1);
    aux_pareto = get(handles.pb_ens_load,'UserData');
    
    pareto = [aux_pareto, pareto];
    set(handles.pb_ens_load,'UserData', pareto);
    
    %Apresentando os dados na tela do programa.
    pareto_table = struct2table(pareto);
    pareto_cel = table2cell(pareto_table);
    names = fieldnames(pareto);
    table_ens = uitable(handles.panel_ensembles,'Data',pareto_cel, 'ColumnName', names, 'Position',[20 15 660 350]);
       
end

% --- Executes on button press in pb_ens_clear.
function pb_ens_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ens_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pb_ens_load,'UserData', []);
uitable(handles.panel_ensembles,'Data',{}, 'ColumnName',{}, 'Position',[20 15 660 350]);


% --- Executes on button press in pb_ens_run.
function pb_ens_run_Callback(hObject, eventdata, handles)
% hObject    handle to pb_ens_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[dados, direc] = uigetfile({'*.txt'},'Load training data');

if isequal(dados,0)
    disp('User selected Cancel')
    direc = '';
else
    file_path = strcat(direc, dados);
    [x_tr, y_tr] = ler_dados(file_path);
    
    pareto = get(handles.pb_ens_load,'UserData');
    
    [models, x_min, x_max] = pareto_models_ens (pareto, x_tr, y_tr);   
    
    
end

[dados, direc] = uigetfile({'*.txt'},'Load data to make ensembles',direc);

if isequal(dados,0)
    disp('User selected Cancel')
else
    file_path = strcat(direc, dados);
    [x_t, y_t] = ler_dados(file_path);    
    ensemble = ensemble_combination (models, x_t, y_t, x_min, x_max, pareto);
    if ~isempty(ensemble)
        t = 1:length(ensemble);
        [ensemble.diff] = split2( -1*[ensemble.diff] );
        [set_pareto, ~, rank, ~] = truncate(t', [ensemble.mse; ensemble.sv; ensemble.diff]', 100);
        ind_nd = rank == 1;
        set_pareto = set_pareto(ind_nd,:);
        ensemble_final = ensemble(set_pareto);
        escreve_ens(ensemble_final, [direc 'Ensemble_' dados] );
    end
    disp('Process Finished!')
end
