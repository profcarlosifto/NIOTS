function z = svm_predict_cos2(model, x, xi)
% Função que faz a predição dos dados a partir do modelo lido nos arquivos SVM_X_Y.txt.
% mse => erro médio quadrático do conjunto xi em relação ao label yi
% model => é o modelo de saído do "svmtrain" da biblioteca LibSVM
% x => conjunto de treinamento
% xi => matriz de n intâncias e m características a serem validados
% yi => Rótulo das instâncias.
% param => parâmetros da SVM e Kernel - partícula
% Os parâmetros do kernel serão utilizados para produzir o kernel para os
% dados de valiação.
x = x(model.ind_coef(:,1), :);
c_xi = size(xi,1);              %Medindo as colunas de xi
z = zeros(c_xi,1);

for k =1:c_xi
fx2 = 0;
for i = 1:model.card_sv
    fx2 =  model.ind_coef(i,2)*kernel_cos(x(i,:),xi(k,:))+ fx2;
end
z(k) = fx2 - model.rho;   %LIBSVM: A Library for Support Vector Machines p. 06. rho = -b, tem-se -model.rho.
end
end
