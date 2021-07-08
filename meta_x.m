function [s, min_x, max_x]  = meta_x (x, y, model, particula, kernel)
%Função que gera os meta dados.Conforme o artigo Multi-target regression
%via input space expansion: treating target as inputs.
% As imagens das funções h (primeiro estágio) serão agregadas aos dados de
% entrada original.
% Nesta função os dados estão normalizados entre -1 e 1 dividindo os
% valores da matriz pela sua entrada máxima.
% x -> dados do espaço de entrada original
% y -> imagens dos dados de entrada original
% g -> Matriz cuja primeira coluna representa o valores de C para o modelo
% e a segunda coluna o valores de sigma (gama)
[m, n]=size(x);
[m1, n1]=size(y);
y1 = zeros(m1, n1);
gama = particula (:,2);

if kernel == 1
    for i=1:m
        for j=1:n1
            y1(i,j) = svm_validade(model(j), gama(j,1), x, x(i,:)); %Embora a função svm_validade funcione bem ela pode ser substituída por "predictionsvm"
        end
    end
elseif kernel == 2
    
elseif kernel == 3   % o programa pode melhorar não tendo que calcular novamente o valor de k_norma. Pode-se passar esse valor para a função 
    for i=1:n1
        [~, k_norma] = gram_matrix(x, particula);
        model(i).SVs=full(model(i).SVs);
        [~, y1(:,i)] = svm_predict3(model(i), x, x, y(:,i), particula(i,:), k_norma);    %Verificar porque a versão mex não funciona    
    end
end
%Concatenando os conjuntos
aux_x = [x y1];
[aux_x, min_x, max_x] = normaliza(aux_x);
for i = 1:n1
    s(i) = struct('meta_x',aux_x, 'meta_y', y(:,i));
end

end