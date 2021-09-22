function  pareto_models = escreve_saida (param_out, pareto, x, y, path, amostra, min_x, max_x, kernel)
%Escrever um arquivo que contém os dados necessários para gerar a máquina
%em outra oportunidade, tal como, nos testes estatísticos e predição. Todas
%as máquinas do conjunto de Pareto são geradas.
%Aqui a máquina é treinada novamente para obter o índices (alpha - alpha*).
%Esta função está destinada aos arquivos do LibSVM. 
% C         -> Vetor coluna dos parâmetros de regularização
% gama      -> Vetor coluna dos gamas
% epsilon   -> Valor da função loss functio e-insensitive
% x         -> Conjunto de treinamento.
% y         -> Imagem do conjunto de treinamento            
% path      -> Caminho do diretório do arquivo.
% amostra   -> Número da amostra para identificar o arquivo.
% pareto    -> Fronteira de Pareto
% C = param_out(:,1);
% gama = param_out(:,2);
% epsilon = param_out(:,3);

%mi = param_out(:,3);
cl = size (param_out,1);
%pareto_models = zeros(1,cl);
%epsilon1 = num2str(epsilon);
for i = 1:cl
    nome_arquivo = strcat(path, 'SVM_',num2str(amostra),'_',num2str(i),'.txt');
    fileID = fopen(nome_arquivo,'w');
    fprintf(fileID,'Support Vectors Machine\n\n');
    fprintf(fileID,'sv\n');
    fprintf(fileID, 'Modelo: LibSVM\n');
    if (kernel == 1)
        C1 = num2str(exp(param_out(i,1)));      %Para trabalhar com a base exponencial dos valores de C e gama a função foi alterada aqui
        gama1 = num2str(exp(param_out(i,2)));    % Nos classificadores foi alterada diretamente nas função de predição.
        epsilon1 = num2str(param_out(i,3));
        fprintf(fileID, 'Kernel: RBF_kernel\n');
        options = ['-s 3',' -c ', C1,' -t 2 ','-g ', gama1, ' -p ', epsilon1];
        pareto_models(i).model = svmtrain(y, x, options);
        %         fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV_CV:    %10.6f\n1-R^2: %10.6f\n', ...
        %         exp(param_out(i,1)), exp(param_out(i,2)), param_out(i,3), pareto(i,1), pareto(i,2), pareto(i,3)); % Alteração aqui para o C e gama exp(C)
        
        fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV_CV:    %10.6f\n', ...
            exp(param_out(i,1)), exp(param_out(i,2)), param_out(i,3), pareto(i,1), pareto(i,2));  %Usando dois objetivos
        
        
    elseif (kernel == 2) % Fazer o kernel polinomial funcionar direito.
        C1 = num2str(exp(param_out(i,1)));      %Para trabalhar com a base exponencial dos valores de C e gama a função foi alterada aqui
        grau = num2str(param_out(i,2));    % Nos classificadores foi alterada diretamente nas função de predição.
        epsilon1 = num2str(param_out(i,3));
        fprintf(fileID, 'Kernel: poly_kernel\n');
        options = ['-s 3',' -c ', C1,' -t 1 ','-g 1 -r 1', ' -d ', grau, ' -p ', epsilon1];
        pareto_models(i).model = svmtrain(y, x, options);
        %         fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV_CV:    %10.6f\n1-R^2: %10.6f\n', ...
        %         param_out(i,1), param_out(i,2), param_out(i,3), pareto(i,1), pareto(i,2), pareto(i,3));
        
        fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV_CV:    %10.6f\n', ...
            param_out(i,1), param_out(i,2), param_out(i,3), pareto(i,1), pareto(i,2)); %Usando dois objetivos
        
        
    elseif (kernel == 3)
        C1 = num2str(exp(param_out(i,1)));      %Para trabalhar com a base exponencial dos valores de C e gama a função foi alterada aqui
        epsilon1 = num2str(param_out(i,2));
        
        fprintf(fileID, 'Kernel: Arccosine\n');
        matriz = gram_matrix_cos(x);
        options = ['-s 3',' -c ', C1,' -t 4 ', ' -p ', epsilon1];
        
        pareto_models(i).model = svmtrain([y x], matriz, options);
        %        fprintf(fileID,'C:   %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV:    %10.6f\n1-R^2:    %10.6f\n', ...
        %        param_out(i,1), param_out(i,2), pareto(i,1), pareto(i,2), pareto(i,3));
        
        fprintf(fileID,'C:   %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV:    %10.6f\n', ...
            param_out(i,1), param_out(i,2), pareto(i,1), pareto(i,2));
        
        
    elseif (kernel == 4)
        C1 = num2str(exp(param_out(i,1)));
        gama1 = exp(param_out(i,2));
        grau = param_out(i,3);
        epsilon1 = num2str(param_out(i,4));
        
        fprintf(fileID, 'Kernel: Deep\n');
        matriz = gram_matrix_deep(x, gama1,grau);
        options = ['-s 3',' -c ', C1,' -t 4 ', ' -p ', epsilon1];
        
        pareto_models(i).model = svmtrain([y x], matriz, options);
        fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nDegree:    %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV_CV:    %10.6f\n1-R^2: %10.6f\n', ...
            param_out(i,1), param_out(i,2), param_out(i,3), param_out(i,4), pareto(i,1), pareto(i,2), pareto(i,3));
        
    elseif (kernel == 5)
        C1 = num2str(exp(param_out(i,1)));      %Para trabalhar com a base exponencial dos valores de C e gama a função foi alterada aqui
        epsilon1 = num2str(param_out(i,3));
        grau = num2str(param_out(i,2));
        fprintf(fileID, 'Kernel: Hermite\n');
        
        matriz = gram_matrix_hermite(x, grau);
        
        options = ['-s 3',' -c ', C1,' -t 4 ', ' -p ', epsilon1];
        
        pareto_models(i).model = svmtrain([y x], matriz, options);
        
        fprintf(fileID,'C:   %10.6f\nEpsilon: %10.6f\nMSE:    %10.6f\nSV:    %10.6f\n', ...
        param_out(i,1), param_out(i,2), pareto(i,1), pareto(i,2));
        
    end

    fprintf(fileID, 'Total SV:  %i\nRHO:     %10.6f\n', pareto_models(i).model.totalSV, pareto_models(i).model.rho);
    fprintf(fileID, 'SV ind.        SV coef\n');
    aux_model = [pareto_models(i).model.sv_indices'; pareto_models(i).model.sv_coef'];
    alfa_p = pareto_models(i).model.sv_coef;
    x_p = x(pareto_models(i).model.sv_indices,:);
    dim_t = size(x,1);
    grau_p = param_out(:,2);
    %save('pred_param.mat', 'alfa_p', 'x_p', 'dim_t', 'grau_p');
    fprintf(fileID, '%i       %10.6f\n', aux_model);
    %% Normalização
    fprintf(fileID, 'Dados Normalização\nMin        Max\n');
    [~, c_x1]=size(x);
    for j=1:c_x1
        fprintf(fileID, '%10.6f             %10.6f\n', min_x(1,j), max_x(1,j));
    end
    %%
    fprintf(fileID, '\nConjunto de treinamento');
    [lx, cx]=size(x);
    [~, cy] = size(y);
    for j = 1:lx
        fprintf(fileID,'\n');
        for k = 1:cx
            fprintf(fileID, '%10.6f ', x(j,k));
        end
        for k = 1:cy
            fprintf(fileID, '%10.6f ', y(j,k));
        end

    end     
    fclose(fileID);
end


end
