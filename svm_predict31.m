function z = svm_predict31(model, xi)
% Função que faz a predição dos dados.
% mse => erro médio quadrático do conjunto xi em relação ao label yi
% model => é o modelo de saído do "svmtrain" da biblioteca LibSVM
% x => conjunto de treinamento
% xi => matriz de n intâncias e m características a serem validados
% yi => Rótulo das instâncias.
% param => parâmetros da SVM e Kernel - partícula
% Os parâmetros do kernel serão utilizados para produzir o kernel para os
% dados de valiação.
%Obs.: Esta função se difere da svm_predict3 por não usar o model gerado
%pela LibSVM, utiliza o modelo gerado pelo arquivos SVM_1_1.txt, esta
%função também não gera o MSE. 
% Caso seja necessário o MSE outras funções deverão ser alteradas.
x = model.xt(model.ind_coef(:,1), :);
c_xi = size(xi,1);              %Medindo as colunas de xi
z = zeros(c_xi,1);
param = [model.C model.gama model.mi];
[~, k_norma] = gram_matrix(model.xt, param);
for k =1:c_xi
fx2 = 0;
for i = 1:model.card_sv
    fx2 =  model.ind_coef(i,2)*kernel_mkl(x(i),xi(k), param, k_norma)+ fx2;
end
z(k) = fx2 - model.rho;   %LIBSVM: A Library for Support Vector Machines p. 06. rho = -b, tem-se -model.rho.
end
%mse = (1/c_xi)*sum((yi - z).^2);
end
