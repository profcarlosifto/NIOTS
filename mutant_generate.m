function [Mutant, set_parameter]= mutant_generate(Parent, JxParent, F, Bounds, Xpop_max, dir_ar, set_parameter, n, Ite_max, criterio)
% Função que gera os indivíduos mutantes do Differential Evolution.
% Implementar a mutação sef-adaptative dentro desta função, conforme o
% artigo: Self-adaptive differential evolution algorithm with crossover strategies
% adaptation and its application in parameter estimation
% O critério de melhor solução adotado será o que estiver mais longe de uma
% solução considerada muito ruim (igual no hipervolume) para direcionar
% qual estratégia terá mais indivíduos.
% A estratégia sempre adota os primeiros para DE/rand/1, os seguinte
% DE/rand/2 e assim por diante.
ind_best = criterio.ind_best;
if n == 1
    set_parameter = calcula_nr_mutacao (JxParent, set_parameter, n, Ite_max,criterio);
elseif mod(n,3) == 0
    set_parameter = calcula_nr_mutacao (JxParent, set_parameter, n, Ite_max, criterio);
end
%nr_mut1 = size(set_parameter.mutacao(1).tipo,2);
Mutant1 = mutant_de_rand_1(Parent, F, Bounds, dir_ar, set_parameter);

%nr_mut2 = size(set_parameter.mutacao(2).tipo,2);
Mutant2 = mutant_rand_2 (Parent, F, Bounds, dir_ar, set_parameter);

%nr_mut3 = size(set_parameter.mutacao(3).tipo,2);
 Mutant3 = mutant_tournament_1(Parent, JxParent, F, Bounds, criterio.fi, dir_ar, set_parameter);

%nr_mut3 = size(set_parameter.mutacao(3).tipo,2);
%Mutant3 = mutant_current_best_1 (Parent, F, Bounds, nr_mut3, ind_best, dir_ar, set_parameter);

%nr_mut4 = size(set_parameter.mutacao(4).tipo,2);
%ind_best = best_parent (JxParent);
Mutant4 = mutant_rand_best_1(Parent, F, Bounds, ind_best, dir_ar, set_parameter);

Mutant = [Mutant1; Mutant2; Mutant3; Mutant4];
end
function Mutant = mutant_de_rand_1(Parent, F, Bounds, dir_ar, set_parameter)
% Função que gera os indivíduos mutantes do Differential Evolution.
% A Metodologia empregada é DE/rand/1.
% Parent   -> População da iteração corrente.
% F        -> Fator de escala
% Xpop_max -> Número de indivíduos gerados na mutação
% dir_ar   -> Sinal do algoritmo de adição de diversidade Atrativo
%             Repulsivo.
if set_parameter.rand_1 == 0
    Mutant = [];
else
    Nvar = size(Parent,2);
    Mutant = zeros(set_parameter.rand_1,size(Parent,2));
    
    mut_begin = set_parameter.mutacao(1).tipo(1,1);
    mut_end = set_parameter.mutacao(1).tipo(1,end);
    j=1;
    for i = mut_begin:mut_end
        rev=randperm(size(Parent,1),3); %Cria uma lista de números inteiro entre 1 e Xpop em ordem aleatória.
        Mutant(j,:)= Parent(rev(1,1),:) + dir_ar*F(i,1)*(Parent(rev(1,2),:) - Parent(rev(1,3),:));
        Mutant(j,:) = verify_bounds_2 (Mutant(j,:), Bounds, Nvar);
        j=j+1;
    end
end
end
function Mutant = mutant_rand_2 (Parent, F, Bounds, dir_ar, set_parameter)
% Função que gera os indivíduos mutantes do Differential Evolution.
% A Metodologia empregada é DE/rand/2.
% Parent   -> População da iteração corrente.
% F        -> Fator de escala
% % dir_ar   -> Sinal do algoritmo de adição de diversidade Atrativo
%             Repulsivo.
if set_parameter.rand_2 == 0
    Mutant = [];
else
    Nvar = size(Parent,2);
    Mutant = zeros(set_parameter.rand_2,size(Parent,2));
    
    mut_begin = set_parameter.mutacao(2).tipo(1,1);
    mut_end = set_parameter.mutacao(2).tipo(1,end);
    j=1;
    for i = mut_begin:mut_end
        rev=randperm(size(Parent,1),5); %Cria uma lista de números inteiro entre 1 e Xpop em ordem aleatória.
        Mutant(j,:)= Parent(rev(1,1),:) + dir_ar*F(i,1)*(Parent(rev(1,2),:) - Parent(rev(1,3),:))+ dir_ar*F(i,1)*(Parent(rev(1,4),:) - Parent(rev(1,5),:));
        Mutant(j,:) = verify_bounds_2 (Mutant(j,:), Bounds, Nvar);
        j=j+1;
    end
end
end
function Mutant = mutant_current_best_1 (Parent, F, Bounds, ind_best, dir_ar, set_parameter)
% Função que gera os indivíduos mutantes do Differential Evolution.
% A Metodologia empregada é DE/current-to-best/1. Esta metodologia foi
% alterada para considerar o menor valor objetivo de uma das 3 funções
% objetivos,escolhido aleatoriamente, a cada iteração.
% A melhor partícula deve ser passada para a função.
% Parent   -> População da iteração corrente.
% F        -> Fator de escala
% dir_ar   -> Sinal do algoritmo de adição de diversidade Atrativo
%             Repulsivo.
% ind_best -> Índice da melhor partícula da população.
if set_parameter.current_best_1 == 0
    Mutant = [];
else
    
    Nvar = size(Parent,2);
    Mutant = zeros(set_parameter.current_best_1,size(Parent,2));
    mut_begin = set_parameter.mutacao(3).tipo(1,1);
    mut_end = set_parameter.mutacao(3).tipo(1,end);
    j=1;
    for i = mut_begin:mut_end
        rev=randperm(size(Parent,1),2); %Cria uma lista de números inteiro entre 1 e Xpop em ordem aleatória.
        Mutant(j,:)= Parent(i,:) + dir_ar*F(i,1)*(Parent(rev(1,1),:) - Parent(rev(1,2),:)) + dir_ar*F(i,1)*(Parent(ind_best,:) - Parent(i,:));
        Mutant(j,:) = verify_bounds_2 (Mutant(j,:), Bounds, Nvar);
        j=j+1;
    end
end
end
function Mutant = mutant_rand_best_1(Parent, F, Bounds, ind_best, dir_ar, set_parameter)
% Função que gera os indivíduos mutantes do Differential Evolution.
% A Metodologia empregada é DE/rand-to-best/1. Esta metodologia foi
% alterada para considerar o menor valor objetivo de uma das 3 funções
% objetivos,escolhido aleatoriamente, a cada iteração.
% A melhor partícula deve ser passada para a função.
% Parent   -> População da iteração corrente.
% F        -> Fator de escala
% Xpop_max -> Número de indivíduos gerados na mutação
% dir_ar   -> Sinal do algoritmo de adição de diversidade Atrativo
%             Repulsivo.
% ind_best -> Índice da melhor partícula da população.
if set_parameter.rand_best_1 == 0
    Mutant = [];
else
    Nvar = size(Parent,2);
    Mutant = zeros(set_parameter.rand_best_1,size(Parent,2));
    mut_begin = set_parameter.mutacao(4).tipo(1,1);
    mut_end = set_parameter.mutacao(4).tipo(1,end);
    
    j=1;
    for i = mut_begin:mut_end
        rev=randperm(size(Parent,1),3); %Cria uma lista de números inteiro entre 1 e Xpop em ordem aleatória.
        Mutant(j,:)= Parent(rev(1,1),:) + dir_ar*F(i,1)*(Parent(rev(1,2),:) - Parent(rev(1,3),:)) + dir_ar*F(i,1)*(Parent(ind_best,:) - Parent(i,:));
        Mutant(j,:) = verify_bounds_2 (Mutant(j,:), Bounds, Nvar);
        j = j + 1;
    end
end
end
function Mutant = mutant_tournament_1(Parent, JxParent, F, Bounds, ind_fi, dir_ar, set_parameter)
%Função que realiza a mutação utilizando o método do torneio.
%Este método é uma variação do método descrito no artigo: A Novel Tournament Selection Based Differential Evolution Variant for Continuous Optimization Problems
% Xpop_max  ->    Número de indivíduos gerados na mutação.
% ind_best  ->    Indice da função objetivo que está sendo avaliada.
% Parent    ->    População da iteração atual.
% JxParent  ->    Matriz das funções objetivos.
% dir_ar    ->    Direção do método de adição de diversidade.

if set_parameter.current_best_1 == 0
    Mutant = [];
else
    [Xpop, Nvar]= size(Parent);
    x_tour = round(0.2*Xpop);
    Mutant = zeros(set_parameter.current_best_1,size(Parent,2));
    mut_begin =  set_parameter.mutacao(3).tipo(1,1);
    mut_end = set_parameter.mutacao(3).tipo(1,end);
    j = 1;
    for i = mut_begin:mut_end
        ind_t = randperm(Xpop, x_tour);
        ind_w = min(JxParent(ind_t,ind_fi))== JxParent(ind_t, ind_fi);
        if sum(ind_w)>1
            aux = find(ind_w);
            ind_w = ind_t(aux(1,1));
        else
            ind_w = ind_t(ind_w);
        end
        
        Mutant(j, :) = Parent(randi(Xpop, 1,1),:)+F(i,1)*(Parent(ind_w,:) - Parent(i,:));
        
        Mutant(j,:) = verify_bounds_2 (Mutant(j,:), Bounds, Nvar);
        j=j+1;
    end
end
end

function Mutant = verify_bounds_1(Mutant, Bounds, Nvar)
% Verifica os limites dos indivíduos mutantes.
% Quando uma posição da variável extrapola os limites a função atribui o
% limite para aquela variável.
for nvar=1:Nvar
    if Mutant(1,nvar)<=Bounds(nvar,1)
        Mutant(1,nvar) = Bounds(nvar,1);
    elseif Mutant(1,nvar)>=Bounds(nvar,2)
        Mutant(1,nvar)=Bounds(nvar,2);
    end
end
end

function Mutant = verify_bounds_2(Mutant, Bounds, Nvar) 
% Verifica os limites dos indivíduos mutantes.
% Quando a uma posição da variável extrapola os limites a função atribui
% menos ou mais a quantidade extrapolada ao vetor mutante.
for nvar=1:Nvar
    if Mutant(1,nvar)<Bounds(nvar,1) % Testa o limite inferior
        dif = Bounds(nvar,1)-Mutant(1,nvar);
        Mutant(1,nvar) = Bounds(nvar,1)+dif;
        
    elseif Mutant(1,nvar)>Bounds(nvar,2)    % Testa o limite superior
        dif = Mutant(1,nvar)-Bounds(nvar,2);        
        Mutant(1,nvar)= Bounds(nvar,2)-dif;
    end
end
Mutant = verify_bounds_1(Mutant, Bounds, Nvar);
end
function set_parameter = calcula_nr_mutacao (JxParent, set_parameter, n, Ite_max, criterio)
% Função que calcula o número de indivíduos de cada estratégia de mutação

PS = size(JxParent,1);

if n == 1%0.25*Ite_max % Definindo a quantidade de mutantes
    aux_m = ceil(PS/4);
    j = 1;
    for i = 1:3
        set_parameter.mutacao(i).tipo = j:i*aux_m;
        j = j + aux_m;
    end
    set_parameter.mutacao(4).tipo = j:PS;
else    
    f_i = criterio.fi;
    f_max = criterio.worst;
    S = zeros(1,4);
    N = zeros(1,4);
    i = 0;
    for i = 1:4
        if isnumeric(set_parameter.mutacao(i).tipo)
            delta_m(i).tipo = abs(JxParent(set_parameter.mutacao(i).tipo,f_i)-f_max);
            S(i) = sum(delta_m(i).tipo);
        end
    end
    St = sum(S);
    
    if (St ~= 0)
        for i = 1:4
            N(i) = round(PS*S(i)/St);            
        end
        
        if sum(N)<PS
            ind_ajuste = find(N==min(N));
            if (size(ind_ajuste,2) > 1)
                ind_ajuste = randi(size(ind_ajuste > 1));
            end
            N(1,ind_ajuste) = N(1,ind_ajuste)+PS-sum(N);
        elseif sum(N)>PS
            ind_ajuste = find(N==max(N));
            if (size(ind_ajuste,2) > 1)
                ind_ajuste = randi(size(ind_ajuste > 1));
            end
            N(1,ind_ajuste) = N(1,ind_ajuste)+PS-sum(N);
        end
        
        j = 0;
        for i = 1:4
%            if ~isempty(set_parameter.mutacao(i).tipo)
             if ~isempty(N(i))||(N(i)==0)
                set_parameter.mutacao(i).tipo = j+1:(N(i)+j); % Descobrir pq gera NaN neste ponto.
                j = j + N(i);
            end
        end
    else
        set_parameter.mutacao(randi(4,1)).tipo = (1:PS); %Por alguma motivo em alguns casos todas as mutações recebem zero. Verificar se alguma mutação está recebendo NaN.
    end %Colocar restrição para NaN neste ponto, pois a if (St ~=0) testa apenas se todos são iguais a zero.
 
end
set_parameter.rand_1 = size(set_parameter.mutacao(1).tipo,2);
set_parameter.rand_2 = size(set_parameter.mutacao(2).tipo,2);
set_parameter.current_best_1 = size(set_parameter.mutacao(3).tipo,2); %torneio
set_parameter.rand_best_1 = size (set_parameter.mutacao(4).tipo, 2);
end

