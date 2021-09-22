function [Parent, JxParent] = selecao_mode(PSet, PFront, Xpop)
% Função que seleciona a população da próxima iteração quando a candidata a
% fronteira de pareto é maior que a população.
% População é composta por um terço melhores de cada função objetivo.
% A função não possui com quantidades ímpares (duas funções - SVM) ou quantidades
% qua não são multiplas de 3 (três funções - SVR)
Parent = [];
JxParent = [];
tam = Xpop/2;
tam = floor(tam);
for i = 1:2
    [~,ord]= sort(PFront(:,i));
    PFront = PFront(ord,:);
    PSet = PSet(ord,:);
    temp_jx = PFront(1:tam,:);
    temp_parent= PSet(1:tam, :);
    Parent = [Parent; temp_parent];
    JxParent = [JxParent; temp_jx];
    PFront(1:tam, :) = [];
    PSet(1:tam, :) = [];
end

end