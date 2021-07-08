function kernel = gram_matrix_cos(Y,X)
% Função que gera a gram matrix do kernel arc cosseno.
% Xt     -> Dados de treinamento 
% Kernel -> Gram matriz, matriz simétrica com todas a combinações do
% conjunto de treinamento.

% Artigo: Kernel Methods for Deep Learning. Eq.: 3 e 6. 
l = size(X,1);
m = size(Y,1);
kernel = zeros(m,l);
for i = 1:m
    for j = 1:l
        if sum(Y(i,:)==X(j,:)) == size(X,2)
            kernel(i,j) = Y(i,:)*X(j,:)';
        else
            dot_yx = Y(i,:)*X(j,:)';
            norm_yx = norm(Y(i,:))*norm(X(j,:));
            teta = acos(dot_yx/norm_yx);
            kernel(i,j) = 1/pi*norm_yx*(sin(teta)+(pi-teta)*(dot_yx)/norm_yx);
        end
    end
end

kernel = [(1:m)', kernel]; % Gera o formato de entrada do svmtrain (LibSVM)
end