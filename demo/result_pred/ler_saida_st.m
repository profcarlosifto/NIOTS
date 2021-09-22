function maquina = ler_saida_st (nome)
% Função que le o arquivo de saída das SVR de uma única saída (single target)
% A saída da função é um modelo que pode ser lido pela função predição para
% testes, estes arquivos permite que a máquina seja implementada.
fid = fopen(nome,'r');
tline = fgets(fid);

while ischar(tline)
    disp(tline)
    aux = strsplit(tline);
    if (strcmp (aux{1},'Gama:'))
        maquina.gama = str2num(aux{2});
        
    elseif (strcmp (aux{1},'Epsilon:'))
        maquina.epsilon = str2num(aux{2});
        
    elseif (strcmp (aux{1},'Total'))
        maquina.card_sv = str2num(aux{3});
        
    elseif (strcmp (aux{1},'RHO:'))
        maquina.rho = str2num(aux{2});
        
    elseif (strcmp (aux{2},'SV'))
        tline = fgets(fid);
        aux = strsplit(tline);
        for i = 1:maquina.card_sv
            maquina.ind_coef(i, 1) = str2num(aux{1});
            maquina.ind_coef(i, 2) = str2num(aux{2});
            tline = fgets(fid);
            aux = strsplit(tline);
        end
        
    elseif(strcmp (aux{1},'Conjunto'))
        tline = fgets(fid);
        aux = strsplit(tline);
        [xl xc]=size(aux);
        i=1;
        while ischar(tline)
            aux = strsplit(tline);
            for j = 2:(xc-1)
                maquina.xt(i,j-1) = str2num(aux{j}); 
            end
            tline = fgets(fid);
            i=i+1;
        end
    end
    tline = fgets(fid);
end
end