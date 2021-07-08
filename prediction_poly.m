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

[~, c_xi]=size(xi);
x = model.xt(:, 1:c_xi);
gama = model(1).gama(k);

fx2 = 0;

for i = 1:model.card_sv(k)
    fx2 = model.ind_coef(i,2*k)*kernel_polynomial(x(model.ind_coef(i,2*k-1),:), xi, gama) + fx2;
end
z = fx2 - model.rho(k);   

end
