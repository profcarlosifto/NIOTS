function fit_mt(tipo_sv, mod, amostra, ite_mopso, x1, y1, k_fold, varargin)
% Função que avalia uma máquina para determinado conjunto de parâmetros C e
% gama utilizando o metodolodiga cross validation.
%X1 -> características dos dados de treinamento
%y1 -> rótulos dos dados de treinamento
%X2 -> características dos dados de teste
%y2 -> rótulos dos dados de teste
%kpar -> gama, parâmetro da função RBF
%C - Parâmetro de generalização.
%conj - Define quais são os índices do X que serão o subconjunto do cross-validation
kernel=varargin{14};
%% Normaliza os dados característica do conjunto de treinamento
[x1, min_x1, max_x1] = normaliza(x1);
%% Concatenando as características e os rótulos para não perder a correspondência.
[ly cy]=size(y1);
X = [x1, y1];
[k lX] = size(X); % Mede o tamanho do vetor de entrada para separar adequadamente os rótulos dos vetores característica
%% Escrevendo os parâmetros arquivo relatório
nome_arq = varargin{11};
epsilon = varargin{15};
fileID = fopen(strcat(nome_arq.path,nome_arq.nome),'w');
if (isempty(fileID))
    disp('Selecione um arquivo de entrada válido')
    return;
end
fprintf(fileID,'Parâmetros Gerais\n');
fprintf(fileID,'Iterações: \t%i\n', ite_mopso);
fprintf(fileID,'Cross-set: \t%i\n', k_fold);
fprintf(fileID,'Amostra: \t%i\n', amostra);
fprintf(fileID,'Limite inferior: %i\n Limite superior %i\n', varargin{7}, varargin{8});
fprintf(fileID, '\nParâmetros do MOPSO\n\n');
fprintf(fileID,' População:\t\t%i\n Inércia Inicial (w_0): %7.4f\n Inércia final (w_f): \t%7.4f\n Coef. Cognitivo (c_1): %7.4f\n Coef. Social (c_2): \t%7.4f\n Velocida Max (v_max): \t%7.4f\n Loss Function (e): \t%7.4f\n', varargin{1}, varargin{2},varargin{3},varargin{4},varargin{5},varargin{6}, epsilon);
if(mod == 1)
    fprintf(fileID,'Modificador: Nenhum\n');
elseif (mod == 2)
    fprintf(fileID,'Modificador: OBL\n');    
elseif (mod == 3)
    fprintf(fileID,'Modificador: AR\n');
end
%% Escrevendo o tipo de kernel
% Neste caso poderia ter sido utilizado uma estrutura para receber a string
% e o número a partir da parte visual. Qual forma seria mais elegante?
if(kernel == 1)
    fprintf(fileID,'Kernel: RBF\n');
    kernel_opt = '2';
elseif (kernel == 2)
    fprintf(fileID,'Kernel: Polynomial\n');
    kernel_opt = '1';
elseif (kernel == 3)
    fprintf(fileID,'Kernel: MKL\n');
    kernel_opt = '4';
end
%%
h = waitbar(0,'Initializing waitbar...');
j=1;    %controle do cabeçário da função 
fileID1 = fopen(strcat(nome_arq.path,'metricas_stat_',nome_arq.nome),'w');
fclose(fileID1);
conj = cross_set (x1, y1, k_fold);      %Esta função pode ser colocada dentro do loop amostra para avaliar o resultado de diferentes partições.
for k=1:amostra
    for i = 1:cy        
        %A função MOPSO_lib_cross é chamada por fit_mt e MOPSO_cross com
        %número de argumentos diferentes aí as referências a varargin
        %mudam. Este é o erro a corrigir.
        %[metricas, param_out, pareto1] = MOPSO_lib_cross(x1, y1(:,i), conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, k, epsilon);
        if (kernel < 3)
            [metricas, param_out, pareto1]= MOPSO_lib_cross(x1, y1(:,i), conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, k, epsilon); % A variável mod permite a função definir se usa OBL, AR ou nenhum
        else
            [metricas, param_out, pareto1]= MOPSO_lib_mkl(x1, y1(:,i), conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, k, epsilon); % A variável mod permite a função definir se usa OBL, AR ou nenhum
        end
        sol = [param_out, pareto1];
        
        %{
        l=size(sol, 1);
        l = randi(l);
        %}
        
        l =find(sol(:,3)==min(sol(:,3)));
        l=l(1,1);
       
        C = sol(l,1);
        sigma = sol(l,2);
        kpar1=num2str(sigma);
        C1 = num2str(C);
        epsilon1 = num2str(epsilon);
        if (tipo_sv <= 3)            
 
            if (kernel < 3) 
                options = ['-s 3',' -c ', C1,' -t ', kernel_opt,' -g ', kpar1, ' -p ', epsilon1];
                model(i) = svmtrain(y1(:,i), x1, options);
                
            else                
                options = ['-s 3',' -c ', C1,' -t ', kernel_opt,' -p ', epsilon1];
                [matriz, k_norma] = gram_matrix(x1, sol(l,:));
                model(i) = svmtrain([y1(:,i) x1], matriz, options);
                
            end
        else             
            model(i) = trainlssvm({x1,y1(:,i),'f',C, sigma,'RBF_kernel','preprocess'}); %por enquanto funciona apenas para aproximadores de funçẽos SRV e kernel RBF
            
        end        
        param(i,:) = param_out(l,:); %armazena os parâmetros utilizados nas máquinas que representa cada uma das saídas.
       
        %Gravando as metricas da fronteira de pareto no arquivo estatística
        escreve_metrica_stat_mt(nome_arq, metricas, amostra, cy, j);
        %Gravando os dados da fronteira de pareto no arquivo relatório
        fprintf(fileID,'\n Amostra %i Y %i - Fase 1\n',k,i);
        if (kernel == 1)
            fprintf(fileID,'%7s %7s %10s %7s','C','Gama', 'Erro', 'SV');
            fprintf(fileID,'\n'); %Não sei porque o \n não funcionou na mesma linha.
            fprintf(fileID,'%7.4f %10.8f %10.8f %7.4f\n',sol');
            
        elseif (kernel == 2)
            fprintf(fileID,'%7s %7s %10s %7s','C','Grau', 'Erro', 'SV');
            fprintf(fileID,'\n'); %Não sei porque o \n não funcionou na mesma linha.
            fprintf(fileID,'%7.4f %10.8f %10.8f %7.4f\n',sol');
            
            
        elseif (kernel == 3)
            fprintf(fileID,'%7s %7s %7s %10s %7s','C','Gama', 'Mi 1', 'Erro', 'SV');
            fprintf(fileID,'\n'); %Não sei porque o \n não funcionou na mesma linha.
            fprintf(fileID,'%7.4f %10.8f %10.8f %7.4f %7.4f\n',sol');
        end
        j=j+1;
    end
    
    if (tipo_sv <=3) %Com arquivos model diferentes é necessário diferenciar no meta_x
        [s, min_x2, max_x2]  = meta_x (x1, y1, model, param, kernel); 
    else
        [s, min_x2, max_x2]  = meta_x_ls (x1, y1, model, param(:,2));
    end
    
    for i = 1:cy
        %conj = cross_set (x1, y1(:,i), k_fold);      %Função que particiona o conjunto de treinamento em k-folder
        %[metricas, param_out2, pareto2 ] = MOPSO_lib_cross(s(i).meta_x, s(i).meta_y, conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, k,epsilon);
        if (kernel < 3)
            [metricas, param_out2, pareto2]= MOPSO_lib_cross(s(i).meta_x, s(i).meta_y, conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, k,epsilon); % A variável mod permite a função definir se usa OBL, AR ou nenhum
        else
            [metricas, param_out2, pareto2]= MOPSO_lib_mkl(s(i).meta_x, s(i).meta_y, conj, ite_mopso, mod, tipo_sv, varargin, h, amostra, k,epsilon); % A variável mod permite a função definir se usa OBL, AR ou nenhum
        end
        sol = [param_out2, pareto2];
        %{
        l =find(sol(:,4)==min(sol(:,4)));
        l=l(1,1);
        %}
        l=size(sol, 1);
        l = randi(l);
        C = sol(l,1);
        sigma = sol(l,2);
        kpar1=num2str(sigma);
        C1 = num2str(C);
        epsilon1 = num2str(epsilon);
     
        if (tipo_sv <= 3)

            %options = ['-s 3',' -c ', C1,' -t ', kernel_opt,'-g ', kpar1, ' -p ', epsilon1];
            %model2(i) = svmtrain(s(i).meta_y, s(i).meta_x, options);
            if (kernel < 3)
                
                options = ['-s 3',' -c ', C1,' -t ', kernel_opt,' -g ', kpar1, ' -p ', epsilon1];
                model2(i) = svmtrain(s(i).meta_y, s(i).meta_x, options);
            else

                options = ['-s 3',' -c ', C1,' -t ', kernel_opt,' -p ', epsilon1];
                [matriz, k_norma] = gram_matrix(x1, sol(l,:));
                model2(i) = svmtrain([s(i).meta_y s(i).meta_x], matriz, options);
            end            
            
        else
            model2(i) = trainlssvm({s(i).meta_x, s(i).meta_y,'f',C, sigma,'RBF_kernel','preprocess'}); %por enquanto funciona apenas para aproximadores de funçẽos SRV e kernel RBF            
        end
        param2(i,:) = [C sigma];
        
        %Gravando as metricas da fronteira de pareto no arquivo estatística
        escreve_metrica_stat_mt(nome_arq, metricas, amostra, cy, j);
        
        %Gravando os dados da fronteira de pareto no arquivo relatório
        fprintf(fileID,'\n Amostra %i Y %i - Fase 2\n',k,i);
        if (kernel == 1)
            fprintf(fileID,'%7s %7s %10s %7s','C','Gama', 'Erro', 'SV');
            fprintf(fileID,'\n'); %Não sei porque o \n não funcionou na mesma linha.
            fprintf(fileID,'%7.4f %10.8f %10.8f %7.4f\n',sol');
            
        elseif (kernel == 2)
            fprintf(fileID,'%7s %7s %10s %7s','C','Grau', 'Erro', 'SV');
            fprintf(fileID,'\n'); %Não sei porque o \n não funcionou na mesma linha.
            fprintf(fileID,'%7.4f %10.8f %10.8f %7.4f\n',sol');
            
            
        elseif (kernel == 3)
            fprintf(fileID,'%7s %7s %7s %10s %7s','C','Gama', 'Mi 1', 'Erro', 'SV');
            fprintf(fileID,'\n'); %Não sei porque o \n não funcionou na mesma linha.
            fprintf(fileID,'%7.4f %10.8f %10.8f %7.4f %7.4f\n',sol');
        end   
    end
    %Fazer essa função repetir um modelo para cada amostra (pelo menos)
    if tipo_sv <= 3
        escreve_saida_mt(model, model2, param, param2, x1, y1, s, varargin{11}.path, k, min_x1, max_x1, min_x2, max_x2, kernel, epsilon);
    else
        escreve_saida_mt_ls(model, model2, param, param2, x1, y1, s, varargin{11}.path, k, min_x1, max_x1, min_x2, max_x2, kernel);
    end
    
end
close(h);
fclose(fileID);
end