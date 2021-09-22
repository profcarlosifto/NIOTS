function m = metrica_kernel (arc_f, range_y, length_x, NP)
% Métrica que calcula a distância (ou semelhança) entre o ponto NADIR e os
% pontos da fronteira de pareto.
l = size(arc_f,1);
x = zeros(1,l);
arc_fn(:,1) = arc_f(:,1)/range_y;
arc_fn(:,2) = arc_f(:,2)/range_y;
for i = 1: l
    x(i) = kernel_rbf(arc_fn(i,:), [1 1], 1); % calcula complemento do kernel que possui valor máximo 1, neste um valor de m maior signfica melhor convergência.    
end
m = sum(x)/l;
% Comparar a métrica com o IGD com um Benchmark. 
end