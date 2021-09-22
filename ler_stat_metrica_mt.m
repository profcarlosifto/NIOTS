function [metricas1, metricas2] = ler_stat_metrica_mt(nome)
%Função que lê as metricas Spacing e Cardinalidade da fronteira de Pareto.
% Esta função será usada no botão "Data load" no panel Statistics
% nome -> nome do arquivo
% metricas1 -> variáveis com os dados do arquivo, spacing e cardinalidade da primeira fase.
% metricas2 -> variáveis com os dados do arquivo, spacing e cardinalidade da segunda fase.
%% Lê cabeçário do arquivo.
fid = fopen(nome);
tline = fgets(fid);
tline = strsplit(tline);
amostra = tline{2};
amostra = str2num(amostra);
tline = fgets(fid);
tline = strsplit(tline);
y = tline{2};
y = str2num(y);
%% Começa a leitura dos dados
%tline = fgets(fid); %Lê a primeira linha de dados
%tline = str2num(tline); %Transforma o vetor de string em números.

% [i,j] = size(tline);
% spacing = zeros(i,j);
% card = zeros(i,j);
for k = 1:amostra
    for i = 1:y
        tline = fgets(fid); 
        tline = str2num(tline);             
        metricas1(i).spa(k,:) = tline;

        tline = fgets(fid); 
        tline = str2num(tline); 
        metricas1(i).card(k,:) = tline;
        
        tline = fgets(fid); 
        tline = str2num(tline); 
        metricas1(i).hyper(k,:) = tline;
    end
    for j = 1:y
        tline = fgets(fid); 
        tline = str2num(tline);             
        metricas2(j).spa(k,:) = tline;

        tline = fgets(fid); 
        tline = str2num(tline); 
        metricas2(j).card(k,:) = tline;
        
        tline = fgets(fid); 
        tline = str2num(tline); 
        metricas2(j).hyper(k,:) = tline;
    end
end  

end