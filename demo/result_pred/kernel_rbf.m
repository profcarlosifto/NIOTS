function K = kernel_rbf(X1, X2, gama)
%Calcula K(X1, X2) dado um gama. Verificar a função do SMO_C1! 
m = length(X1);
norma = 0;
dif = X2(1,:)-X1(1,:);
for k=1:m
    norma = norma + dif(k)^2;
end

K = exp(-norma*gama); 
% exp(-gamma*|u-v|^2)   
end