function [models, min_x, max_x] = pareto_models_ens (pareto, x, y)
% Função que treina as SVR conforme os parâmetros da fronteira de pareto.
% Estava função gera os modelos que serão usados na construção dos
% ensembles.
% Entradas:
% pareto   ->  estrutura que contém os parâmetros das máquinas.
% x, y     ->  dados de treinamento utilizados no modelo.

[xn, min_x, max_x] = normaliza(x);

m = length (pareto);
%models = struct([]);
for i = 1:m
    if strcmp(pareto(i).kernel,'RBF')
        models(i).model = svmtrain(y, xn,['-s 3',' -c ', num2str(exp(pareto(i).c)),' -t 2 ','-g ', num2str(exp(pareto(i).gamma)) , ' -p ', num2str(pareto(i).epsilon), ' -h 1']);
        
    elseif strcmp(pareto(i).kernel,'Poly')
        models(i).model = svmtrain(y, xn,['-s 3',' -c ', num2str(exp(pareto(i).c)),' -t 1 ','-g ', num2str(exp(pareto(i).gamma)) , ' -p ', num2str(pareto(i).epsilon), ' -h 1']);
    end
end
end