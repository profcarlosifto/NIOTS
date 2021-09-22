function MODE_MT(tipo_sv, mod, amostra, ite_mopso, X1, Y1, k_fold, varargin)
% tipo_sv   -> SVM, SVR ou LS-SVM
% mod       -> modificador OBL, AR ou nenhum
% X1        -> dados de entrada
% Y1        -> rótulos dos dados de entrada
% amostra   -> quantidade de repetições de busca para estudos estatísticos
% ite_mopso -> quantidade de iterações do algoritmo de busca
% k_fold    -> quantidade de partições do conjunto de dados (Cross validation)
% varargin  -> demais parâmetros do MODE.
%% Normaliza os dados característica do conjunto de treinamento
[X1, min_x1, max_x1] = normaliza(X1);
%% Concatenando as características e os rótulos para não perder a correspondência.
[~, cy]=size(Y1);
%X = [X1, Y1];
%[k, lX] = size(X); % Mede o tamanho do vetor de entrada para separar adequadamente os rótulos dos vetores característica
%% Escrevendo os parâmetros arquivo relatório
nome_arq = varargin{6};
epsilon = varargin{11};
fileID = fopen(strcat(nome_arq.path,nome_arq.nome),'w');
fprintf(fileID,'Parâmetros Gerais\n');
fprintf(fileID,'Iterações: \t%i\n', ite_mopso);
fprintf(fileID,'Cross-set: \t%i\n', k_fold);
fprintf(fileID,'Amostra: \t%i\n', amostra);
fprintf(fileID,'Limite inferior: %i\n Limite superior: %i\n', varargin{4}, varargin{5});
if ~(tipo_sv == 1)
    fprintf(fileID,'Loss Function e-insensitive (e): %i\n', epsilon);
end
fprintf(fileID, '\nParâmetros do MOPSO\n\n');
fprintf(fileID,' Population:\t\t%i\n Scaling Factor: %7.4f\n Crossover: \t%7.4f\n Loss function (e): \t%7.4f\n', varargin{1}, varargin{2},varargin{3}, epsilon);
if(mod == 1)
    fprintf(fileID,'Modificador: Nenhum\n');
elseif (mod == 2)
    fprintf(fileID,'Modificador: OBL\n');    
elseif (mod == 3)
    fprintf(fileID,'Modificador: AR\n');
end
%%
h = waitbar(0,'Initializing waitbar...');
j=1;    %controle do cabeçário da função 
fileID1 = fopen(strcat(nome_arq.path,'metricas_stat_',nome_arq.nome),'w');
fclose(fileID1);
MODEparam;
for k=1:amostra
    for i = 1:cy        
        r=MODE(MODEDat);  
        sol = [r.PSet, r.PFront];
        l =find(sol(:,3)==min(sol(:,3)));
        l=l(1,1);
        C = sol(l,1);
        sigma = sol(l,2);        
        if (tipo_sv <= 3)            
            kpar1=num2str(sigma);
            C1 = num2str(C);
            epsilon1 = num2str(epsilon);
            options = ['-s 3',' -c ', C1,' -t 2 ','-g ', kpar1, ' -p ', epsilon1];
            model(i) = svmtrain(Y1(:,i), X1, options);
            
        else             
            model(i) = trainlssvm({X1,Y1(:,i),'f',C, sigma,'RBF_kernel','preprocess'}); %por enquanto funciona apenas para aproximadores de funçẽos SRV e kernel RBF
            
        end
        param(i,:) = [C sigma]; %armazena os parâmetros utilizados nas máquinas que representa cada uma das saídas.
        %Gravando as metricas da fronteira de pareto no arquivo estatística
        escreve_metrica_stat_mt(nome_arq, r.metricas, amostra, cy, j);
      
        %Escolhendo o tipo de kernel
        if (MODEDat.kernel == 1)
            %Gravando os dados da fronteira de pareto no arquivo relatório
            fprintf(fileID,'\n Amostra %i Y %i - Fase 1\n',k,i);
            fprintf(fileID,'%7s %7s %10s %7s %10s\n','C','Gama', 'Erro', 'SV', 'Correlacao');
            fprintf(fileID,'%7.4f %10.8f %7.4f %7.4f %7.4f\n',sol');
        elseif (MODEDat.kernel == 2)
            fprintf(fileID,'%7s %7s %10s %7s %10s %10s %10s\n','C','Gama', 'A0', 'Grau', 'Erro', 'SV', 'Correlacao');
            fprintf(fileID,'%7.4f %10.8f  %7.4f %7.4f %7.4f %7.4f %7.4f\n',sol');
        end
        j=j+1;        
    end
    
    if (tipo_sv <=3) %Com arquivos model diferentes é necessário diferenciar no meta_x
        [s, min_x2, max_x2]  = meta_x (X1, Y1, model, param(:,2)); 
    else
        [s, min_x2, max_x2]  = meta_x_ls (X1, Y1, model, param(:,2));
    end
    
    for i = 1:cy 
        r2=MODE(MODEDat);         
        sol = [r2.PSet, r2.PFront];
        l =find(sol(:,3)==min(sol(:,3)));
        l=l(1,1);
        C = sol(l,1);
        sigma = sol(l,2);
        if (tipo_sv <= 3)
            kpar1=num2str(sigma);
            C1 = num2str(C);
            epsilon1 = num2str(epsilon);
            options = ['-s 3',' -c ', C1,' -t 2 ','-g ', kpar1, ' -p ', epsilon1];
            model2(i) = svmtrain(s(i).meta_y, s(i).meta_x, options);
            
        else
            model2(i) = trainlssvm({s(i).meta_x, s(i).meta_y,'f',C, sigma,'RBF_kernel','preprocess'}); %por enquanto funciona apenas para aproximadores de funçẽos SRV e kernel RBF            
        end

        param2(i,:) = [C sigma];
        
        %Gravando as metricas da fronteira de pareto no arquivo estatística
        escreve_metrica_stat_mt(nome_arq, r2.metricas, amostra, cy, j);
        
        %Escolhendo o tipo de kernel
        if (MODEDat.kernel == 1)
            %Gravando os dados da fronteira de pareto no arquivo relatório
            fprintf(fileID,'\n Amostra %i Y %i - Fase 2\n',k,i);
            fprintf(fileID,'%7s %7s %10s %7s %10s\n','C','Gama', 'Erro', 'SV', 'Correlacao');
            fprintf(fileID,'%7.4f %10.8f %7.4f %7.4f %7.4f\n',sol');
        elseif (MODEDat.kernel == 2)
            fprintf(fileID,'%7s %7s %10s %7s %10s %10s %10s\n','C','Gama', 'A0', 'Grau', 'Erro', 'SV', 'Correlacao');
            fprintf(fileID,'%7.4f %10.8f  %7.4f %7.4f %7.4f %7.4f %7.4f\n',sol');
        end
    end
    %Fazer essa função repetir um modelo para cada amostra (pelo menos)
    
    if tipo_sv <= 3
        escreve_saida_mt(model, model2, param, param2, X1, Y1, s, varargin{6}.path, k, min_x1, max_x1, min_x2, max_x2, MODEDat.kernel, epsilon);
    else
        escreve_saida_mt_ls(model, model2, param, param2, X1, Y1, s, varargin{6}.path, k, min_x1, max_x1, min_x2, max_x2, MODEDat.kernel);
    end
end
close(MODEDat.waitbar);
fclose(fileID);
end