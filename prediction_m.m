function yf = prediction_m(model, x)
%Realiza a predição dos dados dado um conjunto de valores x desconhecidos e
%os modelos do estágio 1 e 2 respectivamente.
%Essa função foi alterada para se adaptar ao Sistema versão_5. Organizando
%dados 
% model     -> variável do tipo estrutura que possui todos os dados
% necessários para geração da SVR.
% x         -> conjunto de dados a serem submetidos a SVR. Ou dados que se
% deseja estimar.
%% Organizando os dados
aux = x;
x = aux.x;
min_x = model(1).normaliza(:,1)';
max_x = model(1).normaliza(:,2)';
x = normalize_prediction(x, min_x, max_x); %Definir o mínimo e o máximo da série de treinamento, estes dados são do conjunto de treinamento
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

s =[x y1];
min_x = model(2).normaliza(:,1)';
max_x = model(2).normaliza(:,2)';
s = normalize_prediction(s, min_x, max_x);


for i = 1:m
    for j = 1:mg
        yf(i, j) = svm_validade2(model(2), s(i,:),j);
    end
end
end