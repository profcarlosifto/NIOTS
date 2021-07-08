function K = kernel_rbf(X1, X2, gama)
dif = X2(1,:)-X1(1,:);
norma = sum(dif.^2);
K = exp(-norma*gama); 

end
