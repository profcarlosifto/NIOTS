function z = svm_validade2(model, xi, k)
% Função que criar a SVM ou SVR a partir dos indices dos vetores e suporte
% % xi -> Dado que será calculado pela função h
% gama -> parâmetro do kernel RBF
% model -> Estrutura retornada pela função ler_saida_mt com os dados da máquina
% treinada.
x = model.xt;
gama = model(1).gama(k);
%x1 = x(model.ind_coef(i,k),:); colocou essa informação dentro do "for"
%pois o for não vai ler os índices zero que causaria um erro.
fx2 = 0;
%x2 = xi;
for i = 1:model.card_sv(k)
    fx2 = model.ind_coef(i,2*k)*kernel_rbf(x(model.ind_coef(i,2*k-1),:), xi, gama) + fx2;
end

z = fx2 - model.rho(k);   %LIBSVM: A Library for Support Vector Machines p. 06. rho = -b, tem-se -model.rho.

end

