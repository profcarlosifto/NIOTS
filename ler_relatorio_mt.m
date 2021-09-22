function serie1=ler_relatorio_mt(nome, amostra)
% Função que lê os arquivos relatórios das funções multi-target, retorna os dados para a função que realiza os testes estatísticos.
% nome      -> variável que contém o nome e endereço do arquivo com extensão txt.
% amostra   -> qual amostra deseja-se fazer os testes.

fid = fopen(nome);
tline = fgets(fid);
fase= 1;
j=1;
k =1;
while ischar(tline)             %Loop principal que percorre o arquivo
    tline = strsplit(tline);
    if(strcmp(tline(2),'Amostra')&&(str2num(tline{3})== amostra)&&(str2num(tline{8})== fase)&&(str2num(tline{5})==j))
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        tline = fgets(fid);         %Serve para pular o cabeçário do início da sequência de dados.
        aux = strsplit(tline);
        i=1;
        while (length(aux)~= 2 )
            serie1(fase).erro(i,j) = str2num(aux{4});
            serie1(fase).sv(i,j) = str2num(aux{5});
            serie1(fase).corr(i,j) = str2num(aux{6});
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
        j = j+1;
    elseif (strcmp(tline(2),'Amostra')&&(str2num(tline{3})== amostra)&&(str2num(tline{8})== 2)&&(str2num(tline{5})==k))        
        fase = 2;
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        tline = fgets(fid);         %Serve para pular o cabeçário do início da sequência de dados.
        aux = strsplit(tline);
        i=1;
        while (length(aux)~= 2 )
            serie1(fase).erro(i,k) = str2num(aux{4});
            serie1(fase).sv(i,k) = str2num(aux{5});
            serie1(fase).corr(i,k) = str2num(aux{6});
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            if ~(ischar(tline))
                return
            end
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
        k = k+1;
    else
        tline = fgets(fid);        
    end
end

end
