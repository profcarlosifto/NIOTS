function [mse, z]= svm_predict3(model, x, xi, yi, param, k_norma)
% Função que faz a predição dos dados.
% mse => erro médio quadrático do conjunto xi em relação ao label yi
% model => é o modelo de saído do "svmtrain" da biblioteca LibSVM
% x => conjunto de treinamento
% xi => matriz de n intâncias e m características a serem validados
% yi => Rótulo das instâncias.
% param => parâmetros da SVM e Kernel - partícula
% Os parâmetros do kernel serão utilizados para produzir o kernel para os
% dados de valiação.
x = x(model.sv_indices, :);
c_xi = size(xi,1);              %Medindo as colunas de xi
z = zeros(c_xi,1);

for k =1:c_xi
fx2 = 0;
for i = 1:model.totalSV
    fx2 =  model.sv_coef(i,1)*kernel_mkl(x(i),xi(k), param, k_norma)+ fx2;
end
z(k) = fx2 - model.rho;   %LIBSVM: A Library for Support Vector Machines p. 06. rho = -b, tem-se -model.rho.
end
mse = (1/c_xi)*sum((yi - z).^2);
end
