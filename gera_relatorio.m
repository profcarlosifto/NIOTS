function gera_relatorio(report)
% Grava em um arquivo um relatório com informações sobre os parâmetros
% utilizados no grid search.
% Registra a fronteira de Pareto para ser lida pela função ler_pareto.

% Entrada:
   % Estrutura de dados contendo todas as informações necessárias.
   
if report.kernel == 1
    kernel = 'RBF';
elseif report.kernel == 2
    kernel = 'Polynomial';
elseif report.kernel == 3
    kernel = 'Arccosine';
elseif report.kernel ==4
    kernel = 'Deep Kernel';
elseif report.kernel == 5
    kernel = 'Hermite';
else
    disp('Choose a valid kernel!')
    return;
end

if report.algoritmo == 1      %Este if possui uma divergência nas variáveis. GridSearch deveria estar nos algortimos de otimização.
    algoritmo = 'MOPSO';      % A ideia é utilizar esta função para gerar todos os relatórios, mas por causa dessa inconsistência funciona apenas para o GridSearch
elseif report.algoritmo == 2
    algoritmo = 'MODE';
elseif report.tipo_sv == 7
    algoritmo = 'Gridsearch';
elseif report.tipo_sv == 8
    algoritmo = 'Gridsearch';
else
    disp('Algorithm did not coded!');
    return
end

% Saída: Relatório impresso em um arquivo txt.
fileID = fopen(report.nome_relat,'w');
fprintf(fileID,'General Parameters\n');
fprintf(fileID,'Optimizer: %s\n', algoritmo);
fprintf(fileID,'Machine: %s\n', algoritmo);
fprintf(fileID,'Loss Function e-insensitive (e): %i\n', str2double(report.eps));
fprintf(fileID, '\nGrid Search Parameters\n\n');
fprintf(fileID, 'C min: %i\n', report.c_min);
fprintf(fileID, 'C max: %i\n', report.c_max);
fprintf(fileID, 'Step C: %i\n', report.step_c);
fprintf(fileID, 'Gamma min: %i\n',report.gama_min);
fprintf(fileID, 'Gamma max: %i\n', report.gama_max);
fprintf(fileID, 'Step gamma: %i\n',report.step_gama);
fprintf(fileID, 'Kernel: %s\n', kernel);
fprintf(fileID, '\nPareto Front\n');
if report.tipo_sv == 7
    fprintf(fileID,'%5s %10s %15s %20s %13s %10s\n', 'Index','C','Gamma', 'Epsilon', 'MSE', '#SV');
    fprintf(fileID,'%3i %15.8f %15.8f  %17.8f %15.8f %7i\n',[1:size(report.result_amostra_x,1);report.result_amostra_x'; report.result_amostra_f']);
elseif report.tipo_sv == 8
    fprintf(fileID,'%5s %10s %15s %15s %10s\n', 'Index','C','Gamma', 'MSE', '#SV');
    fprintf(fileID,'%3i %15.8f %15.8f %15.8f %5i\n',[1:size(report.result_amostra_x,1);report.result_amostra_x'; report.result_amostra_f']);
end
fclose(fileID);

end