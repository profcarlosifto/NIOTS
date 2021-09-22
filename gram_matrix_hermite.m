function kernel = gram_matrix_hermite(Xt, n)
% Função que gera a gram matrix do kernel hermite.
% Xt     -> Dados de treinamento 
% n      -> Parâmetro do kernel, ordem do polinômio hermitiano
% Kernel -> Gram matriz, matriz simétrica com todas a combinações do
%           conjunto de treinamento.

l = size(Xt,1);
kernel = zeros(l,l);
for i = 1:l
    for j = i:l
        kernel(i,j) = kernel_hermite(Xt(i,:), Xt(j,:), n);
        kernel(j,i) = kernel(i,j);
    end
end

kernel = [(1:l)', kernel]; % Gera o formato de entrada do svmtrain (LibSVM)
end