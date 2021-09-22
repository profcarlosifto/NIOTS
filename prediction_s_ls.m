function yf = prediction_s_ls(model, x)
% Função que faz a predição dos dados, baseados no modelo LS-SVM. A LS-SVM
% possui uma forma diferente de calcular o kernel, pois na literatura há
% distinção entre gama e sigma, gama considera o parâmetro RBF já
% multiplicado por todas as constantes enquanto que o sigma depois de
% definido ainda é multiplicado por dois. Para o MOPSO isso não faz efeito
% pois o mesmo avalia a variável pelo resultado da SVM.
% model     -> variável do tipo estrutura que possui todos os dados
% necessários para geração da SVR.
% x         -> conjunto de dados a serem submetidos a SVR. Ou dados que se
% deseja estimar.
%% Organizando os dados
aux = x;
x = aux.x;
[~, c_xt] = size(model.xt);
model.kernel_type = 'RBF_kernel';% Colocar no arquivo SVM_1_1.txt
%Parâmetros de normalização 
min_x = model.normaliza(:,1)';
max_x = model.normaliza(:,2)';
x = normalize_prediction(x, min_x, max_x);
%% Primeira fase do processo
model.selector = ~isnan(model.xt);
kx = kernel_matrix(model.xt(model.selector, 1:c_xt), model.kernel_type, 0.3,x);
yf = kx'*model.ind_coef(model.selector,2)+ones(size(kx,2),1)*model.rho(:,1);

% model.selector = ~isnan(model.ytrain);
% kx = kernel_matrix(model.xtrain(model.selector, 1:model.x_dim), model.kernel_type, model.kernel_pars,X);
% Y = kx'*model.alpha(model.selector,1:model.y_dim)+ones(size(kx,2),1)*model.b(:,1:model.y_dim);


end