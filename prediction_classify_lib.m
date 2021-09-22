function [accuracy, yf, prob_y]=prediction_classify_lib(model, x)
%Função que faz a predição de classificadores sejam eles de binários ou
%multi-classes. O LibSVM faz a distinção do modelo.
%Esta função não interpreta os dados do modelo, mas re/treina com os
%hiperparâmetros usando svmtrain e faz a predição com a função svmpredict.
%model -> dados para construção da SVM.
%x-> dados de entrada a serem preditos.
% Definindo o tipo de kernel e ajustando os parâmetros

%% Organizando os dados
aux = x;
x = aux.x;
%Parâmetros de normalização
min_x = model.normaliza(:,1)';
max_x = model.normaliza(:,2)';
x = normalize_prediction(x, min_x, max_x);

C = num2str(exp(model.C));          %Função alterada para trabalhar com exponencial
if strcmp(model.kernel, 'RBF_kernel')              %Definição do kernel
    gama = num2str(exp(model.gama));%Função alterada para trabalhar com exponencial
    t_kernel = [' -t 2 ','-g ', gama];
    %kernel_ls = 'RBF_kernel';
    %sig2 = varargin{2}(1,2);
    
elseif strcmp(model.kernel, 'poly_kernel') 
    gama = '1';
    a0 = '1';
    d = num2str(model.gama);
    t_kernel = [' -t 1 ','-g ', gama, ' -r ', a0, ' -d ', d];
    %kernel_ls = 'poly_kernel';
    %sig2 = [3 varargin{2}(1,2)]; % verificar pois a modificação mudou a representação de x.
end
%Nesta função não foi desenvolvida para ser utilizada como regressor,
%portanto s, pode ser fixo.
options = ['-s 0 -c ', C, t_kernel, ' -b 1'];
%options = ['-s 0 -c ', C, t_kernel];
%Determinando o tipo de classificador

model_svm = svmtrain(model.yt(:,end), model.xt, options); %saída está com o vetor de features.

[yf, accuracy, prob_y] = svmpredict(aux.y, x, model_svm, '-b 1');
%[yf, accuracy, prob_y] = svmpredict(aux.y, x, model_svm);

end