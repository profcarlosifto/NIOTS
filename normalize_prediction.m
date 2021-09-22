function xn = normalize_prediction(x, min_x, max_x)
% Função que normazliza os dados para o intervalo [0,1].
% Esta função é destina a normalizar apenas os dados de validação e
% predição com os mesmos valores máximos e mínimos utilizados no treinamento
% Esta função atua apenas na série de dados que possui um dado fora do
% intervalo [0,1]

% x -> dados a serem normalizados, pode ser uma matriz de qualquer ordem.
% min_x -> valor mínimo de x passado pela função normaliza 
% max_x -> valor máximo de x passado pela função normaliza 
% xn -> dados normalizados no intervalo [0 1]


[lm cm]=size(x);

xn = x; 
for i = 1:cm
    if((max_x(1,i)>1)||(min_x(1,i)<-1))
        for j=1:lm
            xn(j,i) = 2*(x(j,i)-min_x(1,i))/(max_x(1,i) - min_x(1,i))-1;            
        end        
    else 
        max_x(1,i) = 0;
        min_x(1,i) = 0;        
    end
end
end
