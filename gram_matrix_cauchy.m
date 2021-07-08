function kernel = gram_matrix_cauchy(X,Y, n)
% Função que gera a gram matrix do kernel hermite.
% Xt     -> Dados de treinamento 
% n      -> Parâmetro do kernel, gamma Cauchy kernel
% Kernel -> Gram matriz, matriz simétrica com todas a combinações do
%           conjunto de treinamento.
%% Versão do site
cauchyKernel = @(X,Y) (1./(1+(pdist2(X,Y,'euclidean').^2)/n));

kernel =  [ (1:size(X,1))' , cauchyKernel(X,Y) ];
end
