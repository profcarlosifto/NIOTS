function yf = prediction_s_ls(model, x)
% model     -> variável do tipo estrutura que possui todos os dados
% necessários para geração da SVR.
% x         -> conjunto de dados a serem submetidos a SVR. Ou dados que se
% deseja estimar.
%% Organizando os dados
aux = x;
x = aux.x;
[~, c_xt] = size(model.xt);
model.kernel_type = 'RBF_kernel';
%Parâmetros de normalização 
min_x = model.normaliza(:,1)';
max_x = model.normaliza(:,2)';
x = normalize_prediction(x, min_x, max_x);
%% Primeira fase do processo
model.selector = ~isnan(model.xt);
kx = kernel_matrix(model.xt(model.selector, 1:c_xt), model.kernel_type, 0.3,x);
yf = kx'*model.ind_coef(model.selector,2)+ones(size(kx,2),1)*model.rho(:,1);



end
