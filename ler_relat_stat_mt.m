function [serie1, serie2]=ler_relat_stat_mt(nome)
% Função que lê os arquivos relatórios das funções multi-target, retorna os
% dados da fronteira de pareto de todas as amostras que seja plotado os
% gráficos no ambiente Statistics.
% nome      -> variável que contém o nome e endereço do arquivo com extensão txt.
% serie1    -> contém os dados da fronteira de pareto serparado para
% plotagem do gráfico. A quantidade de estruct são o número de amostras e o
% número de colunas dentro dos campos das structs são o número de saídas,
% enquanto que as linhas é a cardinalidade da fronteira de Pareto.
fid = fopen(nome);
tline = fgets(fid);
fase= 1;
j=1;
k =1;
while ischar(tline)             %Loop principal que percorre todo o arquivo
    tline = strsplit(tline);
    if(strcmp(tline(2),'Amostra')&&(str2num(tline{8})== fase)&&(str2num(tline{5})==j))
        amostra = str2num(tline{3});
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        tline = fgets(fid);         %Serve para pular o cabeçário do início da sequência de dados.
        aux = strsplit(tline);
        i=1;
        while (length(aux)~= 2 )
            serie1(amostra).erro(i,j) = str2num(aux{3}); %os indices estão causando erro pois foi retirado o epsilon do relatorio
            serie1(amostra).sv(i,j) = str2num(aux{4});%os indices estão causando erro pois foi retirado o epsilon do relatorio
            serie1(amostra).corr(i,j) = str2num(aux{5});%os indices estão causando erro pois foi retirado o epsilon do relatorio
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
        j = j+1;                %Contador de saída da primeira fase.
        k=1;                    %Reinicia o contador de saídas da segunda fase
    elseif (strcmp(tline(2),'Amostra')&&(str2num(tline{8})== 2)&&(str2num(tline{5})==k))
        amostra = str2num(tline{3});        
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        tline = fgets(fid);         %Serve para pular o cabeçário do início da sequência de dados.
        aux = strsplit(tline);
        i=1;
        while (length(aux)~= 2 )
            serie2(amostra).erro(i,k) = str2num(aux{3});
            serie2(amostra).sv(i,k) = str2num(aux{4});
            serie2(amostra).corr(i,k) = str2num(aux{5});
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            if ~(ischar(tline))
                return
            end
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
        k = k+1;                        %Contador de saída da segunda fase.
        j=1;                            %Reinicia o contador de saídas da primeira fase
    else
        tline = fgets(fid);        
    end
end

end
