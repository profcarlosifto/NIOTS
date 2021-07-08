function x = ler_dados_f(nome)
% A função lê o arquivo de entrada do sistema de otimização de parâmetros
% SVM/SVR.
% Variáveis de entrada
% nome  -> string com o nome do arquivo de saída
% x     -> dados do espaço de entrada
% y     -> rótulos dos dados de entrada. Essa função não lê os label
arquivo = fopen(nome, 'r');
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
[m n]=size(A);
x = A(:,1:dim_x);
end


