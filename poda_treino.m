function [X, Y] = poda_treino(x1, y1, x2, y2, tipo_sv, kernel, w_xt1)
%[erro, sv, corr, w_xt] = fit_svm_lib_poda(X1, y1, x2, y2, tipo_sv, kernel, S(i,:), w_xt1);
%Criar a função que o conjunto de treinamento e entrega aos algoritmos MODE
%e PSO antes de entrar no laçõ de repetição.

[erro, sv, corr, w_xt] = fit_svm_lib_poda(X1, y1, x2, y2, tipo_sv, kernel, x(i,:), w_xt1);
wt(:,i) = w_xt;

end