function criterio = best_parent_lx (JxParent)
% Função que determina o melhor indivíduo da população, escolhendo como
% critério uma função objetivo aleatoriamente.
% A função retorna apenas índice baseado na matriz JxParent.
% JxParent -> valor das funções objetivos dos indivíduos.
% criterio -> estrutura que possui o valor do melhor e pior elemento da
% função objetivo eleita a ser otimizada e seus respectivos indices.
% Vantagem da função: todos os operadores que necessitem destes critérios
% irão usar os mesmos índices e valores na mesma iteração, o que é mais
% coerente com a teoria auto-adaptativa.



%% Técnica de definição do melhor indivíduo: Lexicografic ordering
aux = randi(2);
ind_best1 = find(min(JxParent(:,aux))== JxParent(:, aux));
criterio.ind_best = ind_best1(1,1);
ind_worst1 = find(max(JxParent(:,aux))== JxParent(:, aux));
criterio.ind_worst = ind_worst1(1,1);
criterio.fi = aux;
criterio.best = min(JxParent(:,aux));
criterio.worst = max(JxParent(:,aux));
end
