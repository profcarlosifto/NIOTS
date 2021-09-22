function z = prediction_poly (model, xi, k)
%Esta função utiliza a função aproximadora para calcular os xj valores
%(conjunto de predição ou teste) usando o kernel polinomial.
% Para isso usa os dados do modelo: alfas, dados de treinamento, e demais
% parâmetros.
% % xi -> Dados do conjunto de testes
% gama -> grau do polinômio
% model -> Estrutura retornada pela função ler_saida_mt com os dados da máquina
% treinada.
% k -> Quantidade de saídas, serve de controle para máquinas multi-label
% Com a insersão das saídas no arquivo do modelo da SVM (por conta do
% LS-SVM) precisamos distinguir as saídas das entradas, para isso, vamos
% usar como referência a variável xi.
[~, c_xi]=size(xi);
x = model.xt(:, 1:c_xi);
gama = model(1).gama(k);
%x1 = x(model.ind_coef(i,k),:); colocou essa informação dentro do "for"
%pois o for não vai ler os índices zero que causaria um erro.
fx2 = 0;
%x2 = xi;
for i = 1:model.card_sv(k)
    fx2 = model.ind_coef(i,2*k)*kernel_polynomial(x(model.ind_coef(i,2*k-1),:), xi, gama) + fx2;
end
z = fx2 - model.rho(k);   %LIBSVM: A Library for Support Vector Machines p. 06. rho = -b, tem-se -model.rho.

end