function maquina1=ler_saida_mt(nome)
% Função que faz a leitura dos arquivos SVM_MT.
% nome      -> variável que contém o nome e endereço do arquivo com extensão txt.
fid = fopen(nome);
tline = fgets(fid);
fase = 1;
while ischar(tline)             %Loop principal que percorre o arquivo 
    tline = strsplit(tline);
    if(strcmp('Loss',tline(1)))
        maquina1(1).epsilon = tline{4};
        maquina1(2).epsilon = tline{4};
        tline = fgets(fid);
    elseif (strcmp('Modelo:',tline(1)))
        maquina1(1).modelo = tline{2};
        maquina1(2).modelo = tline{2};
        tline = fgets(fid);
    elseif(sum(strcmp('C',tline))) 
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        aux = strsplit(tline);
        i=1;
        while (~(sum(strncmp('Dados',aux,4))))            
            maquina1(fase).gama(i) = str2num(aux{3});            
            maquina1(fase).card_sv(i) = str2num(aux{4});
            maquina1(fase).rho(i) = str2num(aux{5});
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
    elseif((sum(strncmp('Min',tline,3))))
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        aux = strsplit(tline);
        i=1;
        while (~(sum(strncmp('ind.',aux,4))))            
            maquina1(fase).normaliza(i,1) = str2num(aux{2});
            maquina1(fase).normaliza(i,2) = str2num(aux{3});
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            aux = strsplit(tline);
            i = i+1;                    %Contador para auxiliar na distinção entre fase 1 e 2.
        end
        
    elseif((sum(strncmp('Y',tline,1))))
        k = str2num(tline{2});
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        aux = strsplit(tline);        
        i = 1;
        while (~((sum(strncmp('Y',aux,1)))||(strncmp('',aux{2},1))||(strncmp('Conjunto',aux{1},8))))
            maquina1(fase).ind_coef(i,2*k-1)=str2num(aux{1});
            maquina1(fase).ind_coef(i,2*k)=str2num(aux{2});
            i = i+1;
            tline = fgets(fid);
            aux = strsplit(tline);
        end
    elseif (strncmp('Conjunto',tline{1},8))
        tline = fgets(fid);         %A função fgets faz o papel de contador do while
        aux = strsplit(tline);
        [l_aux, c_aux]=size(aux);
        i=1;
        while (~(strncmp('SRV',aux{1},3)||(strncmp('2',aux{2},1))||(strncmp('',aux{2},1))))
            for j=2:(c_aux-1)
                maquina1(fase).xt(i,j-1)=str2num(aux{j});
            end
            tline = fgets(fid);         %A função fgets faz o papel de contador do while
            if ~(ischar(tline))
                break;
            end
            aux = strsplit(tline);
            i=i+1;
        end
        fase = fase +1;
    else
        tline = fgets(fid);
    end     
end

end
