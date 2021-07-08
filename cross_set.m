function conj = cross_set (x, ~, k)
% Função que separa os conjuntos para realização do cross validation.
% conj => a variável ao invés de armazenar os subconjuntos (k-folder) ela
% armazena os índices dos elementos no conjunto de dados.
% mapa => Contém todos os índices do conjunto x e será usado como
% referência para não gerar índices repetidos nos subconjuntos.
% k => quantidade de subconjuntos.

[m, n] = size(x);

for i = 1:m
    mapa(i) = i;
end
s = floor(m/k);
ref = m;
for i=1:k
    aux = randsample(ref,s);
   conj(i,:)= mapa(1,aux);
   mapa(aux)=[];
   ref = ref - s;
end

end