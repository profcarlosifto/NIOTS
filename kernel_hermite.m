function kernel = kernel_hermite(x, y, n)
% Função que gera a gram matrix do kernel arc cosseno.
% x      -> Vetor característica  1 
% y      -> Vetor característica  2
% n      -> Ordem do polinômio hermite.
% kernel -> Resultado do produto interno no espaço das características 
%           usando kernel hermitiano.
% Implementado conforme artigo:Generalized Hermite kernel function for support vector machine classifications
% Teorema 3.1

d = size(x,2);
kernel = 1;
for j = 1:d % For do produtório
    k = 0;
    for i = 0:n % For do somatório, controla a ordem do polinômiio hermitiano.
        k = k + hermite_probabilistc(i, x(j))*hermite_probabilistc(i, y(j));
    end    
    kernel = kernel+k;
end

end