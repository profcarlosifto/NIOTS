function MOPSO_cross(tipo_sv, mod, amostra, ite_mopso, X1, Y1, k_fold, varargin)
% tipo_sv   -> SVM, SVR ou LS-SVM
% mod       -> modificador OBL, AR ou nenhum
% X1        -> dados de entrada
% Y1        -> rótulos dos dados de entrada
% amostra   -> quantidade de repetições de busca para estudos estatísticos
% ite_mopso -> quantidade de iterações do algoritmo de busca
% k_fold    -> quantidade de partições do conjunto de dados (Cross validation)
% varargin{1}   -> Quantidade de partículas.
% varargin{2}   -> Inércia inicial
% varargin{3}   -> Inércia final
% varargin{4}   -> Coeficiente cognitivo (c1)
% varargin{5}   -> Coeficiente social (c2)
% varargin{6}   -> Velocidade máxima da partícula
% varargin{7 e 8}   -> Limite inferior e superior
% varargin{9 e 10}  -> Diversidade mínima e máxima
% varargin{11}      -> Ponteiro para o arquivo solução do MOPSO.
% varargin{12}      -> Caminho do diretório do arquivo. 
% varargin{13}      -> Tipo de distribuição do gerador de números aleatórios.   
%
%% Normaliza os dados característica do conjunto de treinamento
[X1, min_x1, max_x1] = normaliza(X1);
%% Parâmetros dos programas
spacing_est = zeros(ite_mopso,amostra); %Linhas se refere ao número de iterações do MOPSO e colunas se refere ao número de amostras
card_est = zeros(ite_mopso,amostra); %Linhas se refere ao número de iterações do MOPSO e colunas se refere ao número de amostras
%% Estudo estatístico do MOPSO
t1 = 1:ite_mopso;
[~, b]=size(varargin);
%Esse if identifica se a opção cross-validation ativa ou não e define
%variáveis de acordo com a situação
if (b == 15)
    conj = cross_set (X1, Y1, k_fold);      %Função que particiona o conjunto de treinamento em k-folder
    kernel = varargin{14};
    %epsilon = varargin{15};
else
    conj = [];
    kernel = varargin{16};
    %epsilon = varargin{17}; 
    varargin{14} = normalize_prediction(varargin{14}, min_x1, max_x1);
end
%Definição do arquivo de saída
nome_arq = varargin{11};
nome_relat = strcat(nome_arq.path, nome_arq.nome);
%path = varargin{12}; 

%nome_relat = nome_arq;
fileID = fopen(nome_relat,'w+');
path = nome_arq.path;
%path = varargin{12}; %Esse path é o mesmo de nome_arq.path mas para mudá-lo é preciso mudar os índeces subsequentes de varargin
%% Gravando no arquivo de saída os parâmetros do algoritmo empregado
fprintf(fileID,'General Parameters\n');
fprintf(fileID,'Optimizer: MOPSO\n');
fprintf(fileID,'Iterations: \t%i\n', ite_mopso);
fprintf(fileID,'Cross-set: \t%i\n', k_fold);
fprintf(fileID,'Samples: \t%i\n', amostra);
fprintf(fileID,'Lower limit: %i\nUpper limit: %i\n', varargin{7}, varargin{8});
if (tipo_sv == 1)|| (tipo_sv == 4) %Classificadores SVM ou LS-SVM
     fprintf(fileID,'Machine: Classification');
elseif(tipo_sv == 2)|| (tipo_sv == 5) %Regressores SVR ou LS-SVR
     fprintf(fileID,'Machine: Regression');
end
fprintf(fileID, '\n\nMOPSO parameters\n\n');
fprintf(fileID,'Population:\t\t%i\nInitial inertia (w_0): %7.4f\nFinal inertia (w_f): \t%7.4f\nCognitive coef. (c_1): %7.4f\nSocial coef. (c_2): \t%7.4f\nParticle max speed: \t%7.4f\n', varargin{1}, varargin{2},varargin{3},varargin{4},varargin{5},varargin{6});
%% Escrevendo o tipo de fator de diversidade
% Neste caso poderia ter sido utilizado uma estrutura para receber a string
% e o número a partir da parte visual. Qual forma seria mais elegante?
if(mod == 1)
    fprintf(fileID,'Diversity Factor: Classic\n');
elseif (mod == 2)
    fprintf(fileID,'Diversity Factor: OBL\n');    
elseif (mod == 3)
    fprintf(fileID,'Diversity Factor: AR\n');
end
%% Escrevendo o tipo de kernel
% Neste caso poderia ter sido utilizado uma estrutura para receber a string
% e o número a partir da parte visual. Qual forma seria mais elegante?
if(kernel == 1)
    fprintf(fileID,'Kernel: RBF\n');
elseif (kernel == 2)
    fprintf(fileID,'Kernel: Polynomial\n');    
elseif (kernel == 3)
    fprintf(fileID,'Kernel: MKL\n');
end

%% Criando o waitbar
h = waitbar(0,'Initializing waitbar...');
%% Limpando o arquivo relatório das métricas
nome = strcat(nome_arq.path,'metrica_stats_',nome_arq.nome);
fid = fopen(nome, 'w');
fclose(fid);
%%
for i=1:amostra
    %param_out -> conjunto de pareto
    %if (kernel < 3)
        [metricas, param_out, pareto, poda]= MOPSO_lib_cross(X1, Y1, conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, i); % A variável mod permite a função definir se usa OBL, AR ou nenhum
    %else
    %    [metricas, param_out, pareto]= MOPSO_lib_mkl        (X1, Y1, conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, i, epsilon); % A variável mod permite a função definir se usa OBL, AR ou nenhum        
    %end
    %convergencia = metricas.conv;
    %dlmwrite('convergencia.txt', convergencia','-append','delimiter',' '); 
    metricas = metricas.classico;
    metrica_stat_opt_w(nome, metricas);
    fprintf(fileID, '\nPrunning: %i\nTime: %f', poda.tam, poda.elapsedTime);
    fprintf(fileID,'\nSample %i\n',i);
    
    if(poda.tam ~= 0)       %Corrige o conjunto de treinamento conforme a poda realizada.
        X1(poda.ind,:) = [];
        Y1(poda.ind,:) = [];
    end
    
    if (kernel == 1) % Kernel RBF
        if (tipo_sv == 1) % Classificador
            result_amostra = [1:size(param_out', 2);param_out(:,1:2)'; pareto']; %Excluindo o epsilon do classificador e incluindo os índices
            fprintf(fileID,'%5s %8s %17s %15s %14s\n','Index' ,'C','Gamma', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f %15.8f %15.8f\n',result_amostra);
            pareto_models = escreve_saida_classify(param_out, pareto, X1, Y1, path, i, min_x1, max_x1, kernel);
        elseif (tipo_sv == 2) %Regressor SVR
            result_amostra = [1:size(param_out', 2); param_out'; pareto'];
            fprintf(fileID,'%5s %8s %15s %20s %15s %15s\n','Index','C','Gamma', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f\n',result_amostra);
            pareto_models = escreve_saida(param_out, pareto, X1, Y1, path, i, min_x1, max_x1, kernel) ;              %Escreve o modelo da máquina SVR
            
        elseif (tipo_sv == 3)
            % Colocar aqui SVR multi-target LibSVM
        elseif (tipo_sv == 4)
            % Colocar aqui o classificador LS-SVM
        elseif (tipo_sv == 5)
            % Colocar aqui o regressor LS-SVM
            escreve_saida_ls(param_out, epsilon, pareto, X1, Y1, path, i, min_x1, max_x1, kernel)
        elseif (tipo_sv == 6)accuracy(2,1)
            % Colocar aqui o SVR multi-target LS-SVM
        end
        
    elseif (kernel == 2)
        if (tipo_sv == 1)
            result_amostra = [1:size(param_out', 2);param_out(:,1:2)'; pareto'];
            fprintf(fileID,'%5s %8s %15s %15s %15s\n', 'Index','C','Degree', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f\n',result_amostra);
            escreve_saida_classify(param_out, pareto, X1, Y1, path, i, min_x1, max_x1, kernel)
            
        elseif(tipo_sv == 2)
            result_amostra = [1:size(param_out', 2);param_out(:,1:3)'; pareto'];
            fprintf(fileID,'%5s %8s %15s %20s %15s %15s\n','Index', 'C','Degree', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f\n',result_amostra);
            escreve_saida(param_out, pareto, X1, Y1, path, i, min_x1, max_x1, kernel)               %Escreve o modelo da máquina SVR
            
        elseif (tipo_sv == 3)
            % Colocar aqui SVR multi-target LibSVM
        elseif (tipo_sv == 4)
            % Colocar aqui o classificador LS-SVM
        elseif (tipo_sv == 5)
            % Colocar aqui o regressor LS-SVM
            escreve_saida_ls(param_out, pareto, X1, Y1, path, i, min_x1, max_x1, kernel)
        elseif (tipo_sv == 6)
            % Colocar aqui o SVR multi-target LS-SVM
        end   
        
    elseif (kernel == 3)  % Kernel Arc_seno
        result_amostra = [1:size(param_out', 2);param_out(:,1:2)'; pareto'];
        fprintf(fileID,'%8s %10s %20s %15s %15s\n', 'Index', 'C','Epsilon', 'MSE', 'SV');
        fprintf(fileID,'%3i %20.8f  %15.4f %15.4f %15.4f\n',result_amostra);
%         if tipo_sv <= 3
%             escreve_saida(param_out, epsilon, pareto, X1, Y1, path, i, min_x1, max_x1, kernel)               %Escreve o modelo da máquina SVR
%         else
%             escreve_saida_ls(param_out, epsilon, pareto, X1, Y1, path, i, min_x1, max_x1, kernel)
%         end
    end
end
% answer = questdlg('Would you like NIOTS create an ensemble with Pareto Set?','Ensemble', 'Yes','No', 'Yes');
% % Handle response
% switch answer
%     case 'Yes'
%         ensemble = ensemble_combination (pareto_models, varargin{14}, varargin{15}, min_x1, max_x1, pareto); %O máximo e o mínimo aqui diz respetio ao conjunto de treinamento
%         
%         escreve_ens(ensemble, [nome_arq.path 'Ensemble_' nome_arq.nome] );
%         
%     case 'No'
% 
%  
% end

fprintf(fileID,'\n');
fclose(fileID);
close(h);
disp('Process finished!')

end