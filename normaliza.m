function [xn, min_x, max_x] = normaliza(x)
% Função que normaliza os dados para o intervalo [0,1].
% Esta função é destina a normalizar apenas os dados de treinamento
% Esta função atua apenas na série de dados que possui um dado fora do
% intervalo [0,1]
% Se a função retornar zero nos parâmetros min_x e max_x para uma variável
% significa que esta não foi normalizada.
% x -> dados a serem normalizados, pode ser uma matriz de qualquer ordem.
% min_x -> valor mínimo de x para ser utilizado na normalização do dado de predição
% max_x -> valor máximo de x para ser utilizado na normalização do dado de predição
% xn -> dados normalizados no intervalo [-1 1]


[lm, cm]=size(x);
fator = 0.2;       %120% do maximo

%max_x = max(x);
%min_x = min(x);
if (lm == 1)		
	max_x = x + fator*x;
	min_x = x - fator*x;
else
	max_x = max(x) + fator*abs(max(x));
	min_x = min(x) - fator*abs(min(x));
end
xn = x; 
for i = 1:cm
    if (max_x(1,i) == min_x(1,i))
        if max_x(1,i) > 1
            xn(:, i) = 1;
        elseif (min_x (1,i) < -1)
            xn(:,i) = -1;
        else
            xn(:,i) = x(:,i);
        end
    elseif((max_x(1,i)>=(1))||(min_x(1,i)<=(-1)))
        for j=1:lm
            xn(j,i) = 2*(x(j,i)-min_x(1,i))/(max_x(1,i) - min_x(1,i))-1;            
        end        
    else 
        max_x(1,i) = 0;
        min_x(1,i) = 0;        
    end
end
end
