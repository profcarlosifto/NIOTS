function hyper = hyper_norm (arc_f) 
%Função que calcula o hypervolume com um valor fixo inicial para cada tipo
%de problema seja ele, classificação ou regressão.

total_mse = sum(arc_f(:,1));
total_sv = sum(arc_f(:,2));

arc_f(:, 1) = arc_f(:,1)/total_mse;
arc_f(:, 2) = arc_f(:,2)/total_sv;

hyper = hypervolume(arc_f, [1 1], 1000);  % Reference Point Specification in Hypervolume Calculation for Fair
                                                       % Comparison and  Efficient Search
end
