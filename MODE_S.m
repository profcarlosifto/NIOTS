function MODE_S(tipo_sv, mod, amostra, ite_mopso, X1, Y1, k_fold, varargin)
% tipo_sv   -> SVM, SVR ou LS-SVM
% mod       -> modificador OBL, AR ou nenhum
% X1        -> dados de entrada
% Y1        -> rótulos dos dados de entrada
% amostra   -> quantidade de repetições de busca para estudos estatísticos
% ite_mopso -> quantidade de iterações do algoritmo de busca
% k_fold    -> quantidade de partições do conjunto de dados (Cross validation)
% varargin  -> demais parâmetros do MODE.
%load('dados5.mat');
%X1 = dado5_x;
%Y1 = medida_y;
%% Normaliza os dados característica do conjunto de treinamento
[X1, min_x1, max_x1] = normaliza(X1);
%% Parâmetros dos programas
%amostra = 32;                %Quantidade de amostras para tratamento estatístico
%ite_mopso = 100;             %Quantidade de iterações do MOPSO
spacing_est = zeros(ite_mopso,amostra); %Linhas se refere ao número de iterações do MOPSO e colunas se refere ao número de amostras
card_est = zeros(ite_mopso,amostra); %Linhas se refere ao número de iterações do MOPSO e colunas se refere ao número de amostras
%% Estudo estatístico do MOPSO
t1 = 1:ite_mopso;

%Definição do arquivo de saída
nome_arq = varargin{6};
nome_relat = strcat(nome_arq.path, nome_arq.nome);
fileID = fopen(nome_relat,'w');
path = nome_arq.path; 
%% Gravando no arquivo de saída os parâmetros do algoritmo empregado
fprintf(fileID,'General Parameters\n');
fprintf(fileID,'Optimizer: MODE\n');
fprintf(fileID,'Iterations: \t%i\n', ite_mopso);
fprintf(fileID,'Cross-set: \t%i\n', k_fold);
fprintf(fileID,'Samples: \t%i\n', amostra);
if (tipo_sv == 1)|| (tipo_sv == 4) %Classificadores SVM ou LS-SVM
     fprintf(fileID,'Machine: Classification');
elseif(tipo_sv == 2)|| (tipo_sv == 5) %Regressores SVR ou LS-SVR
     fprintf(fileID,'Machine: Regression');
end
fprintf(fileID, '\nMODE parameters\n\n');
fprintf(fileID,'Population:\t\t%i\nScale factor: %7.4f\nCrossover rate: \t%7.4f\nLower limit:  \t%7.4f\nUpper limit:  \t%7.4f\n', varargin{1}, varargin{2},varargin{3},varargin{4},varargin{5});

if(mod == 1)
    fprintf(fileID,'Diversity factor: classic\n');
elseif (mod == 2)
    fprintf(fileID,'Diversity factor: OBL\n');    
elseif (mod == 3)
    fprintf(fileID,'Diversity factor: AR\n');
end

%% Criando o waitbar
h = waitbar(0,'Initializing waitbar...');
%% Limpando o arquivo relatório das métricas
nome = strcat(nome_arq.path,'metrica_stats_',nome_arq.nome);
nome_c= strcat(nome_arq.path,'plot_mutant_',nome_arq.nome);
fid = fopen(nome, 'w');
fclose(fid);
fid = fopen(nome_c, 'w');
fclose(fid);
%%
MODEparam;
%% Escrevendo o tipo de kernel
%varargin{8} => Tipo do kernel
if(MODEDat.kernel==1)
    fprintf(fileID,'Kernel: RBF\n');
elseif (MODEDat.kernel==2)
    fprintf(fileID,'Kernel: Polynomial\n');    
elseif (MODEDat.kernel==3)
    fprintf(fileID,'Kernel: Arccosine\n');
elseif (MODEDat.kernel==4)
    fprintf(fileID,'Kernel: Deep\n');
elseif (MODEDat.kernel==5)
    fprintf(fileID,'Kernel: Hermite\n');    
end
for i=1:amostra
%for i=19:32
    MODEDat.amostra_atual = i;    
    if (MODEDat.de_type == 2)
        %profile on;
        r(i)=MODE(MODEDat);    
    elseif(MODEDat.de_type == 3)
        r=spMODEII(MODEDat);
    end
    metrica_stat_opt_w(nome, r(i).metricas);
    metrica_stat_opt_w(nome_c, r(i).plot_mutant);
       
    fprintf(fileID,'\nSample %i\n',i);
    if (MODEDat.kernel == 1) % Kernel RBF
        if (tipo_sv == 1) % Classificador
            result_amostra = [1:size(r(i).PSet', 2); r(i).PSet(:,1:2)'; r(i).PFront']; %Excluindo o epsilon do classificador
%             fprintf(fileID,'%5s %10s %15s %15s %15s %15s\n', 'Index','C','Gamma', 'MSE', 'SV', '1-R^2');
%             fprintf(fileID,'%3i %15.8f %15.8f %15.8f %15.8f %15.8f\n',result_amostra);
            fprintf(fileID,'%5s %10s %15s %15s %15s\n', 'Index','C','Gamma', 'AC', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f %15.8f %15.8f\n',result_amostra);
            escreve_saida_classify(r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel);
            
        elseif (tipo_sv == 2) % Regressor
            result_amostra = [1:size(r(i).PSet', 2); r(i).PSet'; r(i).PFront'];
%             fprintf(fileID,'%5s %10s %15s %20s %15s %15s %15s \n','Index', 'C','Gamma', 'Epsilon', 'MSE', 'SV', '1-R^2');
%             fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f %15.8f \n',result_amostra);
            
            fprintf(fileID,'%5s %10s %15s %20s %15s %15s \n','Index', 'C','Gamma', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f \n',result_amostra);

            pareto_models = escreve_saida(r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel);               %Escreve o modelo da máquina SVR

        elseif (tipo_sv == 3)
            % Colocar aqui SVR multi-target LibSVM
        elseif (tipo_sv == 4)
            % Colocar aqui o classificador LS-SVM
        elseif (tipo_sv == 5)
            % Colocar aqui o regressor LS-SVM
            escreve_saida_ls(r.PSet, MODEDat.epsilon, r.PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel)               %Escreve o modelo da máquina SVR

        elseif (tipo_sv == 6)
            % Colocar aqui o SVR multi-target LS-SVM
        end
        
    elseif (MODEDat.kernel == 2) % Kernel Polinomial
        if (tipo_sv == 1) % Classificador
            result_amostra = [1:size(r(i).PSet', 2); r(i).PSet(:,1:2)'; r(i).PFront']; %Excluindo o epsilon do classificador
            fprintf(fileID,'%5s %10s %15s %15s %15s\n','Index', 'C','Degree', 'Accuracy', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f %15.8f %15.8f\n',result_amostra);
            escreve_saida_classify(r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel);
            
        elseif (tipo_sv == 2) % Regressor
            result_amostra = [1:size(r(i).PSet', 2);r(i).PSet'; r(i).PFront'];
%             fprintf(fileID,'%5s %10s %15s %20s %13s %12s %15s\n','Index','C','Degree', 'Epsilon', 'MSE', 'SV', '1-R^2');
%             fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f %15.8f\n',result_amostra);
            
            fprintf(fileID,'%5s %10s %15s %20s %13s %12s\n','Index','C','Degree', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f\n',result_amostra);            
            
            escreve_saida(r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel)               %Escreve o modelo da máquina SVR

        elseif (tipo_sv == 3)
            % Colocar aqui SVR multi-target LibSVM
        elseif (tipo_sv == 4)
            % Colocar aqui o classificador LS-SVM
        elseif (tipo_sv == 5)
            % Colocar aqui o regressor LS-SVM
            escreve_saida_ls(r(i).PSet, MODEDat.epsilon, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel)               %Escreve o modelo da máquina SVR

        elseif (tipo_sv == 6)
            % Colocar aqui o SVR multi-target LS-SVM
        end
        
    elseif (MODEDat.kernel == 3) % Kernel Arc cosseno
        if tipo_sv == 1  % Classificadores
            disp('Não implementado ainda! Em construção')
        elseif tipo_sv == 2  % Regressores
            result_amostra = [1:size(r(i).PSet', 2);r(i).PSet'; r(i).PFront'];
            fprintf(fileID,'%5s %10s %20s %13s %12s\n','Index','C', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f  %15.8f %15.8f %15.8f\n',result_amostra);
            pareto_models = escreve_saida (r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel);%Escreve o modelo da máquina SVR
        else
            escreve_saida_ls(r(i).PSet, MODEDat.epsilon, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel)
        end
    elseif(MODEDat.kernel == 4)
        if tipo_sv == 1
            disp('Não implementado ainda! Em construção.')
        elseif tipo_sv == 2
            result_amostra = [1:size(r(i).PSet', 2);r(i).PSet'; r(i).PFront'];
            fprintf(fileID,'%5s %10s %15s %15s %20s %15s %15s\n','Index', 'C','Gamma', 'Degree', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f %15.8f  %15.8f %15.8f %15.8f\n',result_amostra);
            pareto_models=escreve_saida (r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel);%Escreve o modelo da máquina SVR
        end
        
    elseif (MODEDat.kernel == 5) % Kernel Hermitiano
        if (tipo_sv == 1) % Classificador
            disp('Não implementado ainda! Em construção.')    
            
        elseif (tipo_sv == 2) % Regressor
            result_amostra = [1:size(r(i).PSet', 2);r(i).PSet'; r(i).PFront'];           
            fprintf(fileID,'%5s %10s %15s %20s %13s %12s\n','Index','C','Order', 'Epsilon', 'MSE', 'SV');
            fprintf(fileID,'%3i %15.8f %15.8f  %15.8f %15.8f %15.8f\n',result_amostra);            
            
            escreve_saida(r(i).PSet, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel)               %Escreve o modelo da máquina SVR

        elseif (tipo_sv == 3)
            % Colocar aqui SVR multi-target LibSVM
        elseif (tipo_sv == 4)
            % Colocar aqui o classificador LS-SVM
        elseif (tipo_sv == 5)
            % Colocar aqui o regressor LS-SVM
            escreve_saida_ls(r(i).PSet, MODEDat.epsilon, r(i).PFront, X1, Y1, nome_arq.path, i, min_x1, max_x1, MODEDat.kernel)               %Escreve o modelo da máquina SVR

        elseif (tipo_sv == 6)
            % Colocar aqui o SVR multi-target LS-SVM
        end
                
        
    end
end
fprintf(fileID,'\n');
fclose(fileID);
close(h);
disp('Process finished!')

end