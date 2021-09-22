function escreve_saida_ls(C, gama, epsilon, pareto, x, y, path, amostra, min_x, max_x, kernel)
%Escrever um arquivo que contém os dados necessários para gerar a máquina
%em outra oportunidade, tal como, nos testes estatísticos e predição. Todas
%as máquinas do conjunto de Pareto são geradas.
%Aqui a máquina é treinada novamente para obter o índices (alpha - alpha*).
% C         -> Vetor coluna dos parâmetros de regularização
% gama      -> Vetor coluna dos gamas
% epsilon   -> Valor da função loss functio e-insensitive
% x         -> Conjunto de treinamento.
% y         -> Imagem do conjunto de treinamento            
% path      -> Caminho do diretório do arquivo.
% amostra   -> Número da amostra para identificar o arquivo.
% pareto    -> Fronteira de Pareto

[cl, ~] = size (C);
%epsilon1 = num2str(epsilon);
type = 'f';
for i = 1:cl
    
    [alpha,b] = trainlssvm({x,y,type,C(i,1),gama(i,1),'RBF_kernel','preprocess'});
    [l_alpha, ~]=size(alpha);
    indices = zeros(l_alpha, 1);
    for j = 1:l_alpha
        indices(j,1) = j;
    end    
    nome_arquivo = strcat(path, 'SVM_',num2str(amostra),'_',num2str(i),'.txt');
    fileID = fopen(nome_arquivo,'w');
    fprintf(fileID,'Support Vectors Machine\n\n');
    fprintf(fileID,'Informações sobre a Máquina\n');
    fprintf(fileID, 'Modelo: LS-SVM\n');
    if (kernel == 1)
        fprintf(fileID, 'Kernel: RBF_kernel\n');
    else
        fprintf(fileID, 'Kernel: poly_kernel\n');
    end
    fprintf(fileID,'C:        %10.6f\nGama:    %10.6f\nEpsilon: %10.6f\nErro:    %10.6f\nSV_CV:    %10.6f\n', ... 
    C(i,1), gama(i,1), epsilon, pareto(i,1), pareto(i,2));
    fprintf(fileID, 'Total SV:  %i\nRHO:     %10.6f\n', l_alpha, b);
    fprintf(fileID, '  SV ind.        SV coef\n');
    %aux_model = [indices; alpha];
    [l_alpha, c_alpha] = size(alpha);
    
    for ie = 1:l_alpha
        fprintf(fileID, '%i ', ie);
        for ke = 1:c_alpha            
            fprintf(fileID, '%10.6f ', alpha(ie,ke));
        end
        fprintf(fileID, '\n');
    end
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