function [serie1, tipo_maq] =ler_relatorio_st(nome)
% Função que lê os arquivos relatórios (fronteira de pareto) das funções single-target, retorna os dados para a função que realiza os testes estatísticos.
% Entradas: 
%   nome       -> variável que contém o nome e endereço do arquivo com extensão txt.
% Saídas:
    % serie1   -> fronteira de pareto do arquivo relatório
    % tipo_maq -> caracteriza qual tipo de máquina está sendo avaliada (Regression - Classify).
% Obs.: Acrescentar a escrita do tipo do kernel no relatório, depois
% considerar a leitura do kernel polinomial.
% Caso desejar mudar a função para a leitura de uma amostra específica
% basta inserir a variável amostra nos parâmestre e retirar o contador
% amostra.
fid = fopen(nome,'r');
tline = fgets(fid);
amostra = 1;
while ischar(tline)             %Loop principal que percorre o arquivo
    tline_dado = strsplit(tline);
    if strcmp(tline_dado{1}, 'Machine:')
        tipo_maq = tline_dado{2};
    elseif strcmp(tline_dado{1}, 'Kernel:')
        kernel = tline_dado{2};
    end
    
    if(strcmp(tline_dado{1},'Sample')&&(str2num(tline_dado{2})== amostra))
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        tline = fgets(fid);         %Serve para pular o cabeçário do início da sequência de dados.
        aux = strsplit(tline);
        i=1;
        while (length(aux)~= 2 )
            if strcmp (tipo_maq, 'Regression')
                if strcmp(kernel, 'RBF')||strcmp(kernel, 'Polynomial')
                    serie1(amostra).erro(i,1) = str2num(aux{6});
                    serie1(amostra).sv(i,1) = str2num(aux{7});
                    %serie1(amostra).corr(i,1) = str2num(aux{8});
                elseif strcmp(kernel, 'Arccosine')
                    serie1(amostra).erro(i,1) = str2num(aux{5});
                    serie1(amostra).sv(i,1) = str2num(aux{6});
                    %serie1(amostra).corr(i,1) = str2num(aux{7});

                end
            elseif strcmp (tipo_maq, 'Classification')
                serie1(amostra).erro(i,1) = str2num(aux{5});
                serie1(amostra).sv(i,1) = str2num(aux{6});
                serie1(amostra).corr(i,1) = str2num(aux{7});
             else
                 disp('Error: Cannot identify machine!' )        
                 
            end
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
        amostra = amostra + 1;
    end
    tline = fgets(fid);         %A função fgets faz o papel de contador do while
end

end
