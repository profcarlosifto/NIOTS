function Child = crossover_generate (Parent, Mutant, CrossOverP, Xpop_max, rand_type)
% Realiza o crossover binomial.
% Parent      -> População da geração corrente.
% Mutant      -> Individuos mutantes
% Xpop_max    -> número de indivíduos na população
% rand_type   -> tipo de distribuição aleatória
Nvar = size(Parent,2);
Child = zeros(size(Parent));
for i = 1:Xpop_max
    for nvar=1:Nvar
        %Selecionando o tipo de número aleatório.
        if rand_type == 1
            rn = rand;
        elseif rand_type == 2
            rn = .5 + .2*randn(1);
        elseif rand_type == 3
            rn = 0.01*tan(pi*(rand-0.5));
        end
        if rn < CrossOverP
            Child(i,nvar) = Mutant(i,nvar);
        else
            Child(i,nvar) = Parent(i,nvar);
        end
    end
end
end