function K = kernel_rbf_m(X, gama)
%Calcula a matriz kernel sendo X o vetor característica e gama o parâmetro
%da função.
[n, m] = size(X);
K=zeros(n);
r = 0;
for i = 1:n                 %For que varia as linhas da matriz K
    for j=i:n               %For que varia as colunas da matriz K
        norma = 0;
        dif = X(i,:)-X(j,:);
        for k=1:m
            norma = norma + dif(k)^2;
        end
        %norma = sqrt(norma);
        r = exp(-gama*(norma));
        if(i==j)
            K(i,j) = r;
        else
            K(i,j) = r;
            K(j,i) = r;
        end
        
    end
    
end
end