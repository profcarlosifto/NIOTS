function [erro, corr] = metric_classification_d2 (y2, yf, accuracy)
% Função calcula a qualidade do modelo para direcionar os algoritmos de
% otimização.
    %Implementação das métricas de avaliação baseada no artigo: A two
    %dimensional accuracy-based measure for classification performance
    %(2016)  Eq.: 14 e 13
%   
% Entrada:
%       y2          -> rótulos do conjunto de validação
%       yf          -> estimação realizada pelo modelo.
%       accuracy    -> vetor de saída da função svmpredict.
%Saídas
%       erro -> métrica definida do artigo mencionados
%       corr -> para evitar problemas no restante do programa, proveniente
%               de trabalhar com 3 objetivos, desativo na versão atual.
%

[conf_m,~] = confusionmat(y2,yf);
Nq = sum(conf_m,2);             %Para acelerar o processo em problemas grande este parâmetro deve ser passado para a função
d = size(Nq,1);
D_2 = 0;
N = sum(Nq);
eps_1 = 1/10^10;
for i = 1:d
    D_2 = (conf_m(i,i)/(Nq(i)+eps_1) - accuracy(1)/100)^2*(Nq(i)/N)+D_2; %eps foi inserido para evitar divisão por zero.
end
erro = sqrt(D_2);
corr = 0;
end