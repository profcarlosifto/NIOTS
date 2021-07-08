function kernel = gram_matrix_hermite(Xt1, Xt2, n)
% Função que gera a gram matrix do kernel hermite.
% Xt     -> Dados de treinamento 
% n      -> Parâmetro do kernel, ordem do polinômio hermitiano
% Kernel -> Gram matriz, matriz simétrica com todas a combinações do
%           conjunto de treinamento.

l1 = size(Xt1,1);
l2 = size(Xt2,1);

kernel = zeros(l1,l2);
for i = 1:l1
    for j = 1:l2
        kernel(i,j) = kernel_hermite(Xt1(i,:), Xt2(j,:), n);
        %kernel(j,i) = kernel(i,j);
    end
end

kernel = [(1:l1)', kernel]; % Gera o formato de entrada do svmtrain (LibSVM)
end