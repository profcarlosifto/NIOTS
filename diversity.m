function dir_ar =  diversity (Parent, div_low, div_high, dir_ar, limites)
% Função determina a direção da população baseada na diversidade da mesma.
% Parent    -> População.
% div_low   -> diversidade mínima.
% div_max   -> diversidade máxima.
% dir_ar    -> direção das partículas.
diversity_s = diversity_evaluate(Parent, limites);
    if ((dir_ar > 0)&&(diversity_s < div_low))
        dir_ar = -1;
    elseif ((dir_ar < 0)&&(diversity_s > div_high))
        dir_ar = 1;
    end
end

function s = diversity_evaluate(x, limites)
%Função que calcula a diversidade de uma população de acordo com as
%equações do slide da aula de sistemas bioinspirados.
% x ->  é a matriz da população.
% s -> variável que retorna a diversidade da população.
[S, N] = size(x);
x_b = zeros(N);
dif = sum((limites(:,1)-limites(:,2)).^2);
L = sqrt(dif);

for j = 1:N
   x_b(j) = mean(x(:,j)); 
end
s=0;
for i = 1:S
    x_aux = 0;
    for j = 1:N
        x_aux = x_aux + (x(i,j) - x_b(j))^2;
    end
    x_aux = sqrt(x_aux);
    s = x_aux + s;
end
s = (1/(S*L))*s;
end