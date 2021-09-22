function [Child, set_parameter] = crossover_generate_sa (Mutant, Parent, JxParent, set_parameter, criterio)
% Função que realiza o crossover separando a população em duas 
% subpopulações disjuntas. A primeira é executado o crossover binomial e no
% outro o crossover exponencial.
% Mutant            -> Matriz dos indivíduos mutantes do espaço de decisão.
% Parent            -> Matriz dos indivíduos pais do espaço de decisão.
% JxParent          -> Matriz dos objetivos dos indivíduos pais.
% parameter_cross   -> Estrutura de dados que possui nos campos os
%                   conjuntos de índives referente a cada tipo de crossover
% set_parameter.bin -> Conjunto de índices dos indivíduos do crossover binomial
% set_parameter.exp  -> Conjunto de índices dos indivíduos do crossover
%                       exponencial

PS = size(Parent,1);
%f_i = randi(size(JxParent,2),1);
f_i = criterio.fi;
%f_max = max(JxParent(:,f_i));
f_max = criterio.worst;

delta_fcros_bin = abs(JxParent(set_parameter.bin,f_i)-f_max);
delta_fcros_exp = abs(JxParent(set_parameter.exp,f_i)-f_max);
S_bin = sum(delta_fcros_bin);
S_exp = sum(delta_fcros_exp);

S_t = S_bin + S_exp;

N_bin_c = round (PS*S_bin/S_t);
%N_exp = round (PS*S_exp/S_t);
%rev = randperm(PS);
%N_exp = set_parameter.exp;

rev = 1:PS;
%Condicional que soma ou subtrai a quantidade de indivíduos que receberão o
%crossover binário ou exponencial. N_bin_p -> N_bin da iteração anterior
N_bin_p = length(set_parameter.bin);
%N_exp_p = length(set_parameter.exp);

if N_bin_c > N_bin_p
    N_bin = N_bin_p + 1;
    %N_exp = N_exp - 1; 
elseif N_bin_c < N_bin_p
    N_bin = N_bin_p - 1;
    %N_exp = N_exp + 1;
else
    N_bin = N_bin_p;
end

if N_bin <=1
    set_parameter.bin = [];
    set_parameter.exp = rev(1:PS);
elseif N_bin >= PS
    set_parameter.bin = rev(1:PS);
    set_parameter.exp = [];
else    
    set_parameter.bin = rev(1:N_bin);
    set_parameter.exp = rev(N_bin+1:end);
end
 Child_1 = crossover_binomial(Parent, Mutant, set_parameter);
 %Child_2 = crossover_binomial(Parent, Mutant, set_parameter);
 Child_2 = crossover_exp(Parent, Mutant, set_parameter);
 Child = [Child_1; Child_2];
end

function Child = crossover_binomial(Parent, Mutant, parameter_cross)
% Realiza o crossover binomial
% Mutant            -> Matriz dos indivíduos mutantes do espaço de decisão.
% Parent            -> Matriz dos indivíduos pais do espaço de decisão.
% parameter_cross   -> Conjunto de indivíduos de cada tipo de crossover, a
%                   primeira se refere ao corrosver binomial e a segunda 
%                   ao crossover exponencial a terceira a taxa de
%                   crossover.
Nvar = size(Parent,2);
set_card = size(parameter_cross.bin,2);
%set_card = size(parameter_cross.bin,2) + size(parameter_cross.exp,2);
Child = zeros(set_card, Nvar);
for i = 1:set_card
    j = randi(Nvar,1);
    for nvar=1:Nvar
        rn = rand;
        if (rn < parameter_cross.CrossOverP(parameter_cross.bin(1,i),1))||(nvar == j)
            Child(i,nvar) = Mutant(parameter_cross.bin(1,i),nvar);
        else
            Child(i,nvar) = Parent(parameter_cross.bin(1,i),nvar);
        end
    end
end
end

function Child = crossover_exp(Parent, Mutant, parameter_cross)
% Realiza o crossover binomial
% Mutant            -> Matriz dos indivíduos mutantes do espaço de decisão.
% Parent            -> Matriz dos indivíduos pais do espaço de decisão.
% set_parameter     -> Conjunto de indivíduos de cada tipo de crossover, a
%                   primeira se refere ao corrosver binomial e a segunda 
%                   ao crossover exponencial a terceira a taxa de
%                   crossover.
Nvar = size(Parent,2);
set_card = size(parameter_cross.exp,2);
Child = zeros(set_card, Nvar);

for i = 1:set_card
    k = randi(Nvar,1);
    L = randi(Nvar,1);  % Função de crossover exponencial com defeito.
    if k < L
        for j = 1:Nvar
            if (j >= k) && ( j <= L)
                Child(i,j) = Mutant(i,j);
            else
                Child(i,j) = Parent(i,j);
            end
        end
        
    elseif k > L
        for j = 1:Nvar
            if (j <= k) || ( j >= L)
                Child(i,j) = Mutant(i,j);
            else
                Child(i,j) = Parent(i,j);
            end
        end
        
    elseif k == L
        Child(i,:) = Parent(i,:);
        Child(i,k) = Mutant(i,k);
    end
end
 
end