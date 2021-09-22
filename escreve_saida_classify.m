function pareto_models = escreve_saida_classify (param_out, pareto, x, y, path, amostra, min_x, max_x, kernel)
%Escrever um arquivo que contém os dados necessários para gerar a máquina
%em outra oportunidade, tal como, nos testes estatísticos e predição. Todas
%as máquinas do conjunto de Pareto são geradas.
%Aqui a máquina é treinada novamente para obter o índices os alfas ótimos.
%A função gera apenas classificadores.
%Esta função está destinada aos arquivos do LibSVM. 
% C         -> Vetor coluna dos parâmetros de regularização
% gama      -> Vetor coluna dos gamas
% epsilon   -> Valor da função loss functio e-insensitive
% x         -> Conjunto de treinamento.
% y         -> Imagem do conjunto de treinamento            
% path      -> Caminho do diretório do arquivo.
% amostra   -> Número da amostra para identificar o arquivo.
% pareto    -> Fronteira de Pareto
C = param_out(:,1);
gama = param_out(:,2);
%epsilon = param_out(:,3);

%mi = param_out(:,3);
cl = size (param_out,1);
%epsilon1 = num2str(epsilon);
for i = 1:cl
    C1 = num2str(exp(C(i,1)));
    if kernel == 1
        gama1 = num2str(exp(gama(i,1)));    
        %epsilon1 = num2str(epsilon(i,1));
    elseif kernel == 2
        gama1 = num2str(gama(i,1)); 
    end
    nome_arquivo = strcat(path, 'SVM_',num2str(amostra),'_',num2str(i),'.txt');
    fileID = fopen(nome_arquivo,'w');
    fprintf(fileID,'Support Vectors Machine\n\n');
    fprintf(fileID,'SVM Setup\n');
    fprintf(fileID, 'Modelo: LibSVM\n');
    if (kernel == 1)
        fprintf(fileID, 'Kernel: RBF_kernel\n');
        options = ['-s 0',' -c ', C1,' -t 2 ','-g ', gama1];
        pareto_models(i).model = svmtrain(y, x, options);
%         fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nErro:    %10.6f\nSV_CV:    %10.6f\nCorrelation: %10.6f\n', ... 
%         C(i,1), gama(i,1), pareto(i,1), pareto(i,2), pareto(i,3));
        fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nErro:    %10.6f\nSV_CV:    %10.6f\n', ... 
        C(i,1), gama(i,1), pareto(i,1), pareto(i,2)); % dois objetivos

        
    elseif (kernel == 2) % Fazer o kernel polinomial funcionar direito.
        fprintf(fileID, 'Kernel: poly_kernel\n');
        options = ['-s 0',' -c ', C1,' -t 1 ','-g 1 -r 1', ' -d ', gama1];
        pareto_models(i).model = svmtrain(y, x, options);
%         fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nError:    %10.6f\nSV_CV:    %10.6f\nCorrelation: %10.6f\n', ... 
%         C(i,1), gama(i,1), pareto(i,1), pareto(i,2), pareto(i,3));
         fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nError:    %10.6f\nSV_CV:    %10.6f\n', ... 
         C(i,1), gama(i,1), pareto(i,1), pareto(i,2)); % dois objetivos

    
   elseif (kernel == 3)
       fprintf(fileID, 'Kernel: MKL\n');
       
       [matriz, ~] = gram_matrix(x, param_out(i,:));
       options = ['-s 3',' -c ', C1,' -t 4 ', ' -p '];              
       pareto_models(i).model = svmtrain([y x], matriz, options);
       fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nMi:     %10.6f\nEpsilon: %10.6f\nErro:    %10.6f\nSV_CV:    %10.6f\n', ... 
       C(i,1), gama(i,1), param_out(i,3), pareto(i,1), pareto(i,2));
       %C(i,1), gama(i,1), param_out(i,3), epsilon, pareto(i,1), pareto(i,2), pareto(i,3));
       
    end
    if (pareto_models(i).model.nr_class == 2)
        fprintf(fileID, 'Dados do modelo SVM/SRV\n');
        fprintf(fileID, 'Class number: %i\n', pareto_models(i).model.nr_class);
        fprintf(fileID, 'Total SV:  %i\nRHO:     %10.6f\n', pareto_models(i).model.totalSV, pareto_models(i).model.rho);
        fprintf(fileID, 'SV ind.        SV coef\n');
        aux_model = [pareto_models(i).model.sv_indices'; pareto_models(i).model.sv_coef'];
        fprintf(fileID, '%i       %10.6f\n', aux_model);
    elseif (pareto_models(i).model.nr_class >  2)
        fprintf(fileID, '\nDados do modelo SVM/SRV\n');
        %fprintf(fileID, 'Parameters: %10.6f\n', model.Parameters');
        fprintf(fileID, 'Class number: %i\n', pareto_models(i).model.nr_class);
        fprintf(fileID, 'Total SV:  %i\n', pareto_models(i).model.totalSV);
        fprintf(fileID, 'RHO:     %10.6f\n',pareto_models(i).model.rho');
        fprintf(fileID, 'SV_i:    %i\n', pareto_models(i).model.nSV');
        fprintf(fileID, 'SV ind.        SV coefs\n');
        aux_model = [pareto_models(i).model.sv_indices'; pareto_models(i).model.sv_coef'];
        fprintf(fileID, '%i       %11.8f\n', aux_model);
        %fprintf(fileID, '');

    end
    %Salvando dados para teste do código
%     alfa_p = model.sv_coef;
%     x_p = x(model.sv_indices,:);
%     dim_t = size(x,1);
%     grau_p = gama(:,1);
%     save('pred_param.mat', 'alfa_p', 'x_p', 'dim_t', 'grau_p');
    
    %% Normalização
    fprintf(fileID, 'Dados Normalização\nMin        Max\n');
    [~, c_x1]=size(x);
    for j=1:c_x1
        fprintf(fileID, '%10.6f             %10.6f\n', min_x(1,j), max_x(1,j));
    end
    %%
     %Parte do código que grava apenas os dados do conjunto de treinamento
     %referente aos SVs
     
%     fprintf(fileID, '\nConjunto de treinamento\n');
%     sv_point = full(model.SVs);
%     fprintf(fileID,[repmat('%10.6f', 1, size(sv_point, 2)) '\n'], sv_point');
    
     fprintf(fileID, '\nConjunto de treinamento\n');
     x_t = [x y];
     fprintf(fileID,[repmat('%10.6f', 1, size(x_t, 2)) '\n'], x_t');
     
     fclose(fileID);
end


end
