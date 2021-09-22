function [x1, y1, x2, y2] = cria_teste (x , y)
% Aqui o conjunto de treinamento será inicialmente separado em duas partes
% uma para o treinamento e outra para o teste, sendo 3/4 para o treinamento
% e 1/4 para o teste.
x = [x,y];
[n, m] = size(x);
k = (n/4)*3;
x1 = zeros(42,4);
j=n;
for i=1:k
    aux = randsample(j,1);
    x1(i,:) = x(aux,:);
    x(aux,:)=[];
    j=j-1;
    
end
y1 = x1(:,4);
x1(:,4) = [];
y2 = x(:,4);
x(:,4) = [];
x2 = x;
% Teste git
end
