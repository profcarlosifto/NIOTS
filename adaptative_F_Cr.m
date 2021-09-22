function [Fm, F, Cr] = adaptative_F_Cr(F, Fm, Cr, NP)
% Seção 4.2, artigo: Adaptative differential evolutuion with novel motation
% strategies in multiple sub-populations
% Artigo que explica melhor o comportamento do JADE.
% Differential Evolution with Adaptive Mutation and Parameter Control
% Using Levy Probability Distribution

% Atualizando o F e o Cr de acordo com a distribuição de Cauchy
% A função adaptative deve gerar um F diferente para cada indivíduo
% utilizando a distribuição de Cauchy para o F e a distribuição normal para
% o crossover.
% Deve haver um vetor onde guarda o índice dos F que foram aceitos para
% gerar o novo Fm para a próxima geração.
ml = Lehmer_mean(F);
wf = 0.8+0.2*rand;

Fm = (1-wf)*Fm + wf*ml;
F = wf*F + (1-wf)*ml;
% No artigo em algum momento o conjunto Fi pode ser vazio e então ocorre
% uma outra condição para o cálculo do F, entretanto esta condição não foi
% identificada ler com mais cuidado no futuro

%% Cálculo do Cr
for i = 1:NP
    Crt(i) = Cr + .1*randn(1);
    if Crt(i) > 1
        Crt(i) = 1;
    elseif Crt(i) < 0
        Crt(i) = 0;
    end
    
end
wc = 0.5*rand;
Cr = (1-wc)*Cr+wc*Lehmer_mean(Crt);

end