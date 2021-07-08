function h = hermite_probabilistc(n,x)
% Função que calcula o valor de x do polinômio hermetiano de ordem n.
% n         -> the hermite polynomial order
% x         -> the scalar number to be evaluated.  
% h         -> He_n(x).

% Reference: Generalized Hermite kernel function for support vector machine classifications
% Eq: (7)

%% Polinômio Hermitiano para uma lista pré-definida de polinômios
if n == 0
    h = 1;
elseif n == 1
    h = x;
elseif n == 2
    h = x^2 -1;
elseif n == 3
    h = x^3 - 3*x;
elseif n == 4    
    h = x^4 - 6*x^2 + 3;
elseif n == 5
    h = x^5 - 10*x^3+15*x;
elseif n == 6
    h = x^6 -15*x + 45*x^2 -15; 
elseif n == 7    
    h = x^7 - 21*x + 105*x^3 - 105*x;
end
end
