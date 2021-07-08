function kernel = gram_matrix_rbf(Xt, gamma)
% Função que gera a gram matrix do kernel RBF.
% Xt     -> Dados de treinamento 
% gamma  -> Parâmetro do kernel
% Kernel -> Gram matriz, matriz simétrica com todas a combinações do
% conjunto de treinamento.

l = size(Xt,1);
kernel = zeros(l,l);
for i = 1:l
    for j = i:l
        if i == j
            %teta = 0;
            kernel(i,i) = 1;
        else
            kernel(i,j) = kernel_rbf(Xt(i,:), Xt(j,:), gamma);
            kernel(j,i) = kernel(i,j);
        end
    end
end

kernel = [(1:l)', kernel]; % Gera o formato de entrada do svmtrain (LibSVM)
end