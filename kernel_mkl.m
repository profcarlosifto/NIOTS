function k = kernel_mkl(x1, x2, param, norma)
% Esta função calcula o kernel MKL, neste caso tem-se:
        % k = mi1*RBF(gama) + (1-mi2)*(liner_kernel)
% A função facilitará a utilização de outros modelos de kernel como
% possíveis combinações.
K = x1*x2';
k = param(1,3)*kernel_rbf(x1, x2, param(1,2)) + (1-param(1,3))*K;
k = norma*k;                    % Fazer a predição ser idêntica ao kernel de treinamento
end