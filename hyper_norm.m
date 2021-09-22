function hyper = hyper_norm (arc_f, range_y, length_x) 
%Função que calcula o hypervolume com um valor fixo inicial para cada tipo
%de problema seja ele, classificação ou regressão.
%Nesta função os objetivos são normalizados para não ter problema tendência
%para um determinado critério.
% hyper -> saída hipervolume
% k     -> iteração corrente
% arc_f -> candidata a fronteira de Pareto
arc_fn = ones(size(arc_f));
arc_fn(:,1) = arc_f(:,1)/range_y;
arc_fn(:,2) = arc_f(:,2)/length_x;
%arc_fn = arc_fn*100;
%arc_fn(:,3) = arc_f(:,3);
%hyper = compute_hypervolume_contributions_3D(arc_fn, [1 1 1]); %Esta
%função pode ser útil quando o hipervolume for direcionar a busca.
hyper = hypervolume(arc_fn, [1.053 1.053], 1000);  % Reference Point Specification in Hypervolume Calculation for Fair
                                                       % Comparison and  Efficient Search
end