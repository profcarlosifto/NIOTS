function [s, min_x, max_x]  = meta_x_ls (x, y, model, gama)
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
[m, n]=size(y);
y1 = zeros(m, n);
for i = 1:n
    y1(:,i) = simlssvm(model(i), x);
end

%Concatenando os conjuntos
aux_x = [x y1];
[aux_x, min_x, max_x] = normaliza(aux_x);
for i = 1:n
    s(i) = struct('meta_x',aux_x, 'meta_y', y(:,i));
end

end