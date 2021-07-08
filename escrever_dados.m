function  escrever_dados(nome, x, y)
% A função cria o arquivo de entrada do sistema de otimização de parâmetros
% da SVM/SVR a partir das variáveis x e y que possuem os dados no espaço de entrada.
% Variáveis de entrada
% nome  -> string com o nome do arquivo de saída
% x     -> dados do espaço de entrada
% y     -> rótulos dos dados de entrada
[l c]=size(x);
X = [x y];
[m n]=size(X);
arquivo = fopen(nome, 'wt');
fprintf(arquivo, 'Dim (X): %i\n', c);
for i = 1:m
    for j = 1:n
        fprintf(arquivo,'%20.15f ', X(i,j));
    end
    fprintf(arquivo,'\n');
end
fclose(arquivo);
end