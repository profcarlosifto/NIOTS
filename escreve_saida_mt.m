function escreve_saida_mt( model, model2, param, param2, x1, y1, s, path, amostra, min_x1, max_x1, min_x2, max_x2, kernel, epsilon)
%Escreve o arquivo de saida do processo de escolha ótima dos parâmetros C,
%gama e epsilon.
%Aqui a máquina é treinada novamente.
%Gera o modelo da máquina ótima.
%Na fronteira de pareto foi adotado como critério para escolha da solução
%aquela que possui o menor erro. Esta implementação escolhe apenas o menor
%erro nas duas fases (pensar em uma versão que considera todas as possibilidades)
% param         -> possuim os C, gama e epsilon nas colunas e as linhas são
% os y's.
% A função também imprime as saída para adaptar ao LS-SVM
% x         -> Conjunto de treinamento.
% y         -> Imagem do conjunto de treinamento
% path      -> Caminho do diretório do arquivo.
% amostra   -> Número da amostra para identificar o arquivo.
% pareto1    -> Fronteira de Pareto fase I
% pareto2    -> Fronteira de Pareto fase II
% s          -> Matriz dos metadados.
[l, ~]= size(param); % l representa a quantidade de saídas da função (targets)
str_amostra = num2str(amostra);
fileID = fopen(strcat(path,'SVM_MT_', str_amostra,'.txt'), 'w');
fprintf(fileID, 'Support Vectors Machines\n');
fprintf(fileID, 'Modelo: LibSVM\n');
fprintf(fileID, 'Loss function (e): %10.6f\n', epsilon);
if (kernel == 1)
    fprintf(fileID, 'Kernel: RBF_kernel\n');
else
    fprintf(fileID, 'Kernel: poly_kernel\n');
end
fprintf(fileID, '\nFase 1 - Parâmetros da SVR\n');
fprintf(fileID, 'C      Gama        #SV         RHO\n');
%As linhas representam as saídas e as colunas C, gama, epsilon, #SV e RHO, 
%respectivamente
for i = 1:l
    fprintf(fileID, ' %10.6f     %10.6f      %i        %10.6f\n', param(i,1), param(i,2), model(i).totalSV, model(i).rho);
end
fprintf(fileID, 'Dados Normalização\nMin        Max\n');
[~, c_x1]=size(x1);
for i = 1:c_x1
    fprintf(fileID, '%10.6f             %10.6f\n', min_x1(1,i), max_x1(1,i));
end
fprintf(fileID, '  SV ind.        SV coef\n');
for i=1:l
    fprintf(fileID, '\nY %i\n', i);
    aux_model = [model(i).sv_indices'; model(i).sv_coef'];
    fprintf(fileID, '%i       %10.6f\n', aux_model);
end
fprintf(fileID, 'Conjunto de treinamento - Fase 1\n');
[l, m]=size(x1);
[~, cy] = size(y1);
for i = 1:l
    for j= 1:m        
        fprintf(fileID, '%10.6f  ', x1(i,j));
    end
    for j = 1:cy
        fprintf(fileID, '%10.6f ', y1(i,j));
    end
    fprintf(fileID, '\n');
end

%% Escrita da segunda fase MT

[l, ~]= size(param2);
fprintf(fileID, '\nFase 2 - Parâmetros da SVR\n');
fprintf(fileID, 'C      Gama        #SV         RHO\n');
%As linhas representam as saídas e as colunas C, gama, epsilon, #SV e RHO, 
%respectivamente
for i = 1:l
    fprintf(fileID, ' %10.6f     %10.6f      %i      %10.6f\n', param2(i,1), param2(i,2), model2(i).totalSV, model2(i).rho);
end
fprintf(fileID, 'Dados Normalização\nMin        Max\n');
[~, c_s]=size(s(1).meta_x);
for i = 1:c_s
    fprintf(fileID, '%10.6f             %10.6f\n', min_x2(1,i), max_x2(1,i));
end
fprintf(fileID, '  SV ind.        SV coef\n');
for i=1:l
    fprintf(fileID, '\nY %i\n', i);
    aux_model = [model2(i).sv_indices'; model2(i).sv_coef'];
    fprintf(fileID, '%i       %10.6f\n', aux_model);
end
fprintf(fileID, 'Conjunto de treinamento - Fase 2\n');
[l, m]=size(s(1).meta_x);

for i = 1:l
    for j= 1:m        
        fprintf(fileID, '%10.6f  ', s(1).meta_x(i,j));
    end
    for j = 1:cy
        fprintf(fileID, '%10.6f ', y1(i,j));
    end
    fprintf(fileID, '\n');
end
fclose(fileID);
end