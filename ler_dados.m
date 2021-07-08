function [x, y] = ler_dados(nome)
% A função lê o arquivo de entrada do sistema de otimização de parâmetros
% SVM/SVR.
% Variáveis de entrada
% nome  -> string com o caminho e nome do arquivo de saída
% x     -> dados do espaço de entrada
% y     -> rótulos dos dados de entrada
%fscanf
arquivo = fopen(nome, 'r');
if (arquivo == -1)
    x =[ ];
    y =[ ];
    display(["Impossível abrir o arquivo de dados: " file_path])
    return
else
tline = fgetl(arquivo);
tline = strsplit(tline);
dim_x = str2num(tline{3});
i = 1;
tline = fgetl(arquivo);
while ischar(tline)
    A(i,:) = str2num(tline);
    tline = fgetl(arquivo);
    i = i+1;
end
%[~, n]=size(A);
x = A(:,1:dim_x);
y = A(:,dim_x+1:end);
fclose(arquivo); 
end


