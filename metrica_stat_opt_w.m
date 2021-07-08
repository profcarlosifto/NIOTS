function metrica_stat_opt_w(nome, metricas)
%Função que grava as métricas do processo de otimização em um arquivo
%posteriormente utilizado para gerar gráficos e realizar a análise
%estatística do processo
% i -> o programa vai gerar um arquivo para cada amostra para dar opção do
% usuário escolher qual amostra ele vai plotar.
%nome = strcat(nome,'metrica_stats_amostra_', i,'.txt');
dlmwrite(nome, metricas','-append','delimiter',' ');    
end