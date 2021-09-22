function metricas = ler_stat_opt(nome)
%Função que lê as metricas Spacing e Cardinalidade da fronteira de Pareto.
% Esta função será usada no botão "Data load" no panel Statistics
% nome -> nome do arquivo
% metricas -> variáveis com os dados do arquivo, spacing e cardinalidade.
fid = fopen(nome);
tline = fgets(fid);
tline1 = str2num(tline);
[i,j] = size(tline1);
spacing = zeros(i,j);

%spacing_t = zeros(1,j);
%card_t = zeros(1,j);

card = zeros(i,j);
t = 1;
s = 1;
c = 1;
h = 1;
while ischar(tline)
    if (mod(t,3) == 1)
        spacing(s,:) = tline1;
        spacing_t(1,s) = tline1(1, end-1);
        s = s+1;
    elseif(mod(t,3) == 2)
        card(c,:) = tline1;
        card_t(1,c) = tline1(1, end-1);
        c = c+1;
    else
        hyper(h,:) = tline1;
        hyper_t(1,h) = tline1(1, end-1);
        h = h+1;       
    end
    tline = fgets(fid);
    if ischar(tline)
        tline1 = str2num(tline);
    end
t = t+1;
end
metricas.itera = [spacing' card' hyper'];
metricas.otima = [spacing_t' card_t' hyper_t'];
%Falta mudar a saída para passar as variáveis card_t e spacing_t para fora
%da função e ajustar onde a função já foi usada
%metricas = str2num(metricas);
end