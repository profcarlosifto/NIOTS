function m = SLHD (NP, d)
% A função gera uma matriz de números aleatórios conforme a definição de
% Symetric Latin Hypercube. 
% Esta função é baseada no pseudo código do artigo:
% "A differential evolution  algorithm with self-adaptive strategy and 
% control parameters based on symmetric Latin hypercube design for
% unconstrained optimization problems"
% Entrada: NP -> número de indivíduos da população população
%          d  -> número de variáveis do problema
% Saida:             
%          m   -> matriz SLHD  

m = zeros(NP, d);
for j = 1:d
    m(:,j) = randperm(NP);
end

flag = mod(NP,2);

if flag > 0
    for j = 1:d
        m((NP + 1)/2, j) = (NP + 1)/2;
    end    
end
k=(NP - 1)/2;
k = ceil(k);
phi = zeros(k,d);
for j = 1:d
    phi(:,j)=randperm(k);
end
for i = 1:k
    for j = 1:d
        if rand < 0.5
            m(i, j) = phi(i, j);
            m(NP+1-i, j) = NP + 1 - phi(i,j);
        else
            m(i, j) = NP + 1 -phi(i, j);
            m(NP + 1-i, j) = phi(i,j);
        end
    end
end
m = m/NP;
end
