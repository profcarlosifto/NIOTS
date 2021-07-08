function [kernel, norma] = gram_matrix(Xt, x)
% A função cria uma estrutura que contém todas as matrizes kernel para cada
% partícula. A matriz Kt é a matriz kernel de treinamento. 
% A função é utilizada na função svmtrain com opção "-t 4"
% Xt => é a matriz contendo as instâncias e características de treinamento.
% Xv => é a matriz contendo as instâncias e características de validação.
% x => é a matriz das partículas.
% norma => a norma é o fator multiplicativo para que o traço da matriz seja
% igual ao número de elementos conforme especificado na literatura.
% kernel(i).k = Cada nó da estrutura tem uma matriz correspondente a uma
% partícula.
l = size(Xt,1);
K = Xt*Xt';

kernel = x(1,3)*kernel_rbf_m(Xt, x(1,2)) + (1-x(1,3))*K;
norma = l/trace(kernel);
kernel = norma*kernel;

kernel = [(1:l)', kernel];

 


end
