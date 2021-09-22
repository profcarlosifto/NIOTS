function kernel = gram_matrix_cos(Xt)
% Função que gera a gram matrix do kernel arc cosseno.
% Xt     -> Dados de treinamento 
% Kernel -> Gram matriz, matriz simétrica com todas a combinações do
% conjunto de treinamento.

l = size(Xt,1);
kernel = zeros(l,l);
for i = 1:l
    for j = i:l
        if i == j
            %teta = 0;
            kernel(i,i) = Xt(i,:)*Xt(i,:)';
        else
            dot_x = Xt(i,:)*Xt(j,:)';
            norm_x = norm(Xt(i,:))*norm(Xt(j,:));
            teta = acos(dot_x/norm_x);
            kernel(i,j) = 1/pi*norm_x*(sin(teta)+(pi-teta)*(dot_x)/norm_x);
            kernel(j, i) = kernel(i, j);
        end
    end
end

kernel = [(1:l)', kernel]; % Gera o formato de entrada do svmtrain (LibSVM)
end