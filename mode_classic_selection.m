function [Parent, JxParent, arc_Parent, arc_JxParent] = mode_classic_selection(Child, JxChild, Parent, JxParent, Xpop, MODEDat)
% Função que realiza a seleção dos indivíduos que sobreviverão na próxima
% geração.
% Baseado no modelo guloso utiliza a função truncate.

Pop = [Child; Parent];
JxPop = [JxChild; JxParent ];

[~,ia]=unique(JxPop, 'rows');                       %Elimina os elementos repetidos.
JxPop = JxPop (ia,:);
Pop = Pop(ia,:);

[arc_Parent, arc_JxParent, rank, ~] = truncate(Pop, JxPop, 2*Xpop);
row_zeros = find(all(arc_JxParent == 0,2));
arc_Parent(row_zeros,:)=[];
arc_JxParent(row_zeros,:)=[];

i = 1;
Parent = [];
JxParent = [];
if (size(ia,1) > Xpop )
    while  (size(Parent,1 )< Xpop)
        ind_nd =(rank == i);
        JxParent_aux = arc_JxParent(ind_nd,:);
        Parent_aux = arc_Parent(ind_nd,:);
        
        ind_mix = randperm(size(Parent_aux,1));
        Parent_aux = Parent_aux(ind_mix,:);
        JxParent_aux = JxParent_aux(ind_mix,:);
        
        JxParent = [JxParent; JxParent_aux];
        Parent = [Parent; Parent_aux];
        JxParent_aux = [];
        Parent_aux = [];
        i = i + 1;
    end
    ind_nd =(rank == 1);
    arc_JxParent = arc_JxParent(ind_nd,:);
    arc_Parent = arc_Parent(ind_nd,:);
    
    JxParent = JxParent(1:Xpop,:);
    Parent = Parent(1:Xpop,:);
    
else
    [l, ~] = size(Pop);
    MODEDat.XPOP = MODEDat.XPOP - l;
    aux1 = gera_pop_init(MODEDat);
    Jxaux1 = MODEDat.mop(aux1,MODEDat);
    Parent = [Pop;aux1];
    JxParent = [JxPop;Jxaux1];
    
end
end
