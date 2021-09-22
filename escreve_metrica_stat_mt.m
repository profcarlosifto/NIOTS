function  escreve_metrica_stat_mt(nome, metricas, amostra, cy, k)
% A função que escreve as métricas da fronteira de pareto.
% Cada linha representa uma amostra de uma das saídas da máquina, que pode
% ser da fase 1 ou 2. No início do arquivo será impresso o número de
% saídas, o número de amostras e sabendo que são duas fases podemos separar
% os dados na função de leitura.
% metricas  -> dados das métricas spacing e cardinalidade
% amostras  -> quantidade total de amostras
% cy        -> quantidade de saídas da máquina
fileID = fopen(strcat(nome.path,'metricas_stat_',nome.nome),'a');
if(k == 1)
fprintf(fileID, 'Amostra: %i\n', amostra);
fprintf(fileID, 'Saidas: %i\n', cy);
end
metricas = metricas';
%Caso aumente uma métrica alterar a quantidade de %8.5f na função fprintf
dlmwrite(strcat(nome.path,'metricas_stat_',nome.nome),metricas, 'delimiter', ' ', '-append');
end