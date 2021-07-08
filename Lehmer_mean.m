function ml = Lehmer_mean(F)
% Calcula a média de Lehmer conforme artigo: Adaptative differential evolutuion with novel motation
% strategies in multiple sub-populations, seção 4.2.
ml  = sum(F.^2)/sum(F);
end
