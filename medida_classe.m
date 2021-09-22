%Transforma a medida do cordão em classes. 
%A largura ideal do cordão é 5mm, entretanto será considerado uma margem de
%erro ou seja um intervalo entre 4.5 mm e 5.5 mm.

load ('medida.mat');
tam= length(medida);
medida_y = zeros(tam,1);
for i=1:tam
    if (medida(i)<5.5 && medida(i)>4.5 )
        medida_y(i)=1;
    else
        medida_y(i)=-1;
    end
end

%Usar cross validation para o dados.
% Aqui o conjunto de treinamento será inicialmente separado em duas partes
% uma para o treinamento e outra para o teste, sendo 3/4 para o treinamento
% e 1/4 para o teste.
% 

