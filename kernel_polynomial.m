function y = kernel_polynomial(x, xi, d)
% O kernel é uma função cujo domínio são dois vetores n dimensionais
% (escalares no caso trivial) que retorna um escalar que representa a
% afinidade entre os vetores.
% A função kernel polinomial é dada por P(xi) = (x*xi + 1)^d
% Obs.: Aqui * é um produto escalar
% Parâmetros de entrada:
% x  => vetor linha de entrada n-dimensional
% xi => vetor linha de entrada n-dimensional
% y  =>  escalar saída da função

y = (x*xi' + 0)^d;
end