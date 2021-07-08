function [F, Cr] = sa_parameters (JxParent, F, Cr, n, Generaciones, criterio)
% Função que calcula os parâmetros F e Cr auto-adaptativo.
% F -> Vetor coluna dos fatores de escala de cada indivíduo.
% Cr -> Vetor coluna das taxas de crossover de cada indivíduo.
% sgima -> desvio padrão calculado dentro laço da geração.
% criterio -> função objetivo que está sendo avaliada nesta iteração

sigma = 0.1+0.4*(1-(n/Generaciones)^2);
sigma_Cr = sigma;
w = peso_w (JxParent, criterio);
Fw = sum(F.*w);
Crw = sum(Cr.*w);
PS = size(JxParent,1);
for i = 1:PS
    F(i,1) = normrnd(Fw,sigma);
    Cr(i,1) = normrnd(Crw,sigma_Cr);
end
F = min(1, F); %truncation [0 1]
pos = find(F <= 0);
while ~ isempty(pos)
    F(pos(1)) = normrnd(Fw,sigma);    
    F = min(1, F);                      % truncation
    
    pos = find(F <= 0);
end
%Cr = min(1, max(0, Cr));                % truncated to [0 1]
Cr = abs(Cr);
Cr = min (0.85, Cr);
end

function w = peso_w (JxParent, criterio)
% Cálculo de todos os pesos de F e Cr.
% w -> pesos de ajuste dos parentes

PS = size(JxParent,1);
f_i = criterio.fi;
f_max = criterio.worst;

w = zeros(PS,1);
soma_dif = sum(abs(JxParent(:,f_i)-f_max));
for i = 1:PS
    w(i,1) = abs(JxParent(i,f_i) - f_max)/soma_dif;
end
end
