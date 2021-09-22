function ensemble = ensemble_combination (pareto, x, y, x_min, x_max, pareto_front)
% Função que cria a o ensemble baseado em todas as combinações possíveis da
% fronteira de pareto.
% O processo de determinação do ensemble é exaustivo.
% Esta primeira versão considera:
% 1) criar o ensemble como a média das SVRs das máquinas individuais
% 2) cada ensemble composto de 3 máquinas.
% 3) como critério multi-objetivo o MSE do ensemble e #SV.
%
% Entradas
% pareto -> estrutura de modelos da fronteira de Pareto
% x -> dados de validação utilizado no processo de treinamento (características).
% y -> dados de validação utilizado no processo de treinamento (labels).
% x_min -> mínimo do conjunto de treinamento.
% x_max -> máximo do conjunto de treinamento.

%[x, y] = ler_dados('/home/carlos/Documentos/doutorado/sistema/funcao/SwingUp_28/SwingUp_28/SwingUp_28_teste.txt');
x = normalize_prediction(x, x_min, x_max);
m1 = length(pareto);
n_ens = 3; % Número de máquinas no ensemble;
saida = zeros(size(y,1),n_ens);
w = zeros(n_ens,1);
k = 1;
m = 2^m1-1;
for i = 1:m
    aux = de2bi(i,m1);
    aux2 = sum(aux);
    if (aux2 <= n_ens)&& (aux2 >= 2)
       ensemble(k).sv = 0;
       ind_ens = find(aux==1);
       for j = 1:aux2 %n_ens 
          [saida(:,j), accuracy, ~] = svmpredict(y,x, pareto(ind_ens(j)).model);
          ensemble(k).sv = ensemble(k).sv + pareto(ind_ens(j)).model.totalSV;
          ensemble(k).svm_erro(j) = pareto_front(ind_ens(j)).mse; %usando o erro da fronteira de pareto
          %ensemble(k).svm_erro(j) = accuracy(2);
          saida_num(:, j) = saida(:,j)/ensemble(k).svm_erro(j);          
       end
       
       enemble(k).ens_saida = sum(saida_num,2)./(sum(1./ensemble(k).svm_erro));
       ensemble(k).mse = mean((y - enemble(k).ens_saida).^2);
       ensemble(k).ind_ens = ind_ens;
       ensemble(k).diff = 0;
       k = k + 1;
    end
end
ensemble = quality_ens(ensemble, pareto_front);
end

function best_ens = quality_ens(ensemble, pareto_front)
% Função que serve apenas para avaliar os ensembles e compará-los as SVMs
% da fronteira de Pareto.
l=length(ensemble);
i = 1;
for k = 1:l
    min_mse_svm = min(ensemble(k).svm_erro);
    %min_mse_svm = min([pareto_front(ensemble(k).ind_ens).mse]); % A diferenção é a definição da coluna dentro de pareto_front em relação ao implementado dentro do MOPSO e MODE.
    if ensemble(k).mse < min_mse_svm
        best_ens(i) = ensemble(k);
        best_ens(i).diff = 1-ensemble(k).mse/min_mse_svm;
        i=i+1; 
    end
end
if i == 1
    best_ens = [];
    disp('Any Ensemble has better MSE than each one of his SVMs that compound them!\n')
end
end

