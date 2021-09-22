function [Parent, JxParent, arc_Parent, arc_JxParent] = mode_classic_selection(Child, JxChild, Parent, JxParent, Xpop)
% Função que realiza a seleção dos indivíduos que sobreviverão na próxima
% geração.
% Baseado no modelo guloso utiliza a função truncate.

Pop = [Child; Parent];
JxPop = [JxChild; JxParent ];

[~,ia]=unique(JxPop, 'rows');                       %Elimina os elementos repetidos.
JxPop = JxPop (ia,:);
Pop = Pop(ia,:);

[arc_Parent, arc_JxParent, rank, ~] = truncate(Pop, JxPop, Xpop);
ind_nd = (rank == 1);                               %Analisar a possibilidade de pertimitir elementos do rank 2
tam_Pop = size(Pop,1);
if (tam_Pop < Xpop)                                 %Tira a inconsistência entre os tamanhos de Pop e Parent causado pela perda de diversidade e a função unique
    JxParent(1:tam_Pop,:) = arc_JxParent(1:tam_Pop,:);
    Parent(1:tam_Pop,:) = arc_Parent(1:tam_Pop,:);
    arc_JxParent = arc_JxParent(ind_nd(1:tam_Pop),:);
    arc_Parent = Parent(ind_nd(1:tam_Pop),:);
    
else
    JxParent = arc_JxParent(1:Xpop,:);
    Parent = arc_Parent(1:Xpop,:);
    arc_JxParent = arc_JxParent(ind_nd(1:Xpop),:);
    arc_Parent = Parent(ind_nd(1:Xpop),:);
end
end
