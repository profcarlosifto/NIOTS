function cc = correlation(yf, y)
% Função que calcula a correlação dos dados preditos conforme artigo: Comparing Metrics to Evaluate Performance of Regression Methods for Decoding of Neural Signals
% yf => imagem dos dados preditos do conjunto de validação
% y  => imagem dos dados reais do conjunto de validação
media_yf = mean(yf);
media_y = mean(y);
dif_yf = yf - media_yf;
dif_y = y - media_y;
prod1 = dif_yf.*dif_y;
soma_num = sum(prod1);
dif_yf = dif_yf.^2;
dif_y = dif_y.^2;
soma_yf = sum(dif_yf);
soma_y = sum(dif_y);

cc= soma_num/sqrt(soma_yf*soma_y);
end