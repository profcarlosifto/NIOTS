function m = nadir_ideal (arc_f, range_y, length_x)
% Função que calcula a métrica que o calcula somatório a distância entre o 
% ponto ideal e os pontos candidatos a Fronteira de Pareto.
% Para funcionar a fronteira deve ter o ponto de referência (NADIR = [1 1])
% e o ideal (0, 0). A fronteira deve ser normalizada para o intervalo [0 1]

% PFront    => Candidata a fronteira de pareto.
% range_y   => Quadrado da faixa da saída dos dados de treinamento.
% length_x  => Número de vetores de suporte. 
% m         <= valor da métrica calculada.
% 
% Problema da métrica é a diferença entre as grandezas do erro e dos
% vetores de suporte, mesmo quando normalizado.
l = size(arc_f,1);
x = zeros(1,l);


arc_fn(:,1) = arc_f(:,1)/range_y;
arc_fn(:,2) = arc_f(:,2)/length_x;

for i = 1:l
    x(i) = min(arc_fn(i,:));
end
m = sum(x);
end