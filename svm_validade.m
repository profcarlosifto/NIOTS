function z = svm_validade(model, gama, x, xi)
% Função que criar a SVM ou SVR a partir dos indices dos vetores e suporte
% x -> Serve para obter os vetores de suporte
% xi -> Dado que será calculado pela função h
% gama -> parâmetro do kernel RBF
% model -> Estrutura retornada por svmtrain com os dados da máquina
% treinada.
x1 = x(model.sv_indices,:);
fx2 = 0;
x2 = xi;
for i = 1:model.totalSV
    fx2 = model.sv_coef(i,:)*kernel_rbf(x1(i,:), x2, gama) + fx2;
end

z = fx2 - model.rho;   %LIBSVM: A Library for Support Vector Machines p. 06. rho = -b, tem-se -model.rho.

end

