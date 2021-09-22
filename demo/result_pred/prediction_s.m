function yf = prediction_s(model, x)
%Realiza a predição dos dados dado um conjunto de valores x desconhecidos e
%os modelos do estágio 1 e 2 respectivamente.
%Essa função foi alterada para se adaptar ao Sistema versão_5. Organizando
%dados 
% model     -> variável do tipo estrutura que possui todos os dados
% necessários para geração da SVR.
% x         -> conjunto de dados a serem submetidos a SVR. Ou dados que se
% deseja estimar.
%% Organizando os dados
%aux = x;
%x = aux.x;
%% Primeira fase do processo
[m n]=size(x);
[mg ng] = size(model(1).gama'); %transforma o vetor gama em um vetor coluna, questão de facilidade
y1 = zeros (m , mg);
yf = zeros (m , mg);
for i = 1:m
    for j = 1:mg
        y1(i, j) = svm_validade2(model(1), x(i,:),j);
    end
end

yf=y1;

end