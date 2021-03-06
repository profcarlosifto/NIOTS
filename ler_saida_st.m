function maquina = ler_saida_st (nome)
% Função que le o arquivo de saída das SVR de uma única saída (single target)
% A saída da função é um modelo que pode ser lido pela função predição para
% testes, estes arquivos permite que a máquina seja implementada.
fid = fopen(nome);
tline = fgets(fid);

while ischar(tline)
    %disp(tline)
    aux = strsplit(tline);
    if (strcmp (aux{1},'C:'))
        maquina.C = str2num(aux{2});
    
    elseif (strcmp (aux{1},'Kernel:'))
        maquina.kernel = aux{2};
        
    elseif (strcmp (aux{1},'Modelo:'))
        maquina.modelo = aux{2};
        
    elseif (strcmp (aux{1},'Gama:'))
        maquina.gama = str2num(aux{2});
        
    elseif (strcmp(aux{1}, 'Class'))
        maquina.class = str2num(aux{3});
        
    elseif (strcmp (aux{1},'Mi:'))
        maquina.mi = str2num(aux{2});
        
    elseif (strcmp (aux{1},'Epsilon:'))
        maquina.epsilon = str2num(aux{2});
        
    elseif (strcmp (aux{1},'Total'))
        maquina.card_sv = str2num(aux{3});
        
    elseif (strcmp (aux{1},'RHO:'))
        maquina.rho = str2num(aux{2});
        
    elseif (strcmp (aux{1},'SV'))
        tline = fgets(fid);
        aux = strsplit(tline);
        for i = 1:maquina.card_sv
            maquina.ind_coef(i, 1) = str2num(aux{1});
            maquina.ind_coef(i, 2) = str2num(aux{2});
            tline = fgets(fid);
            aux = strsplit(tline);
        end        
    elseif((sum(strncmp('Min',tline,3))))
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        tline = strtrim(tline);
        aux = strsplit(tline);
        i=1;
        while (~(sum(strncmp('',aux,1))))
            maquina.normaliza(i,1) = str2num(aux{1});
            maquina.normaliza(i,2) = str2num(aux{2});
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            tline = strtrim(tline);
            aux = strsplit(tline);            
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
    elseif(strcmp (aux{1},'Conjunto'))
        tline = fgets(fid);
        tline = strtrim(tline); % Esta função corta as strings que contém somente espaços em branco do começo e do final do vetor.
        aux = strsplit(tline);
        [~, xc]=size(aux);
        i=1;
        while ischar(tline)
            tline = strtrim(tline);
            aux = strsplit(tline);
            for j = 1:xc-1                  %Por que sempre a última coluna será yt                
                maquina.xt(i,j) = str2num(aux{j}); 
            end
            maquina.yt(i,1) = str2num(aux{j+1}); 
            tline = fgets(fid);
            i=i+1;
        end
    end
    tline = fgets(fid);
end
end