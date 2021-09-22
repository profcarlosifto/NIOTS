function yf = prediction_m_old (model1, model2, x, x_t1, x_t2, gama)
%Realiza a predição dos dados dado um conjunto de valores x desconhecidos e
%os modelos do estágio 1 e 2 respectivamente.
%model1 -> modelo do primeiro estágio da técnica empilhamento
%model2 -> modelo do segundo estágio da técnica empilhamento
%x      ->  Dados a serem preditos, aqui cada dado é representado por uma
%linha.
%x_t    -> conjunto de treinamento.
%gama   -> gama da função RBF, para cada máquina gerada de cada modelo.
%yf     -> imagem dos dados x (preditado)

[m n]=size(x);
[mg ng] = size(gama);
y1 = zeros (m , mg);
yf = zeros (m , mg);
for i = 1:m
    for j = 1:mg
        y1(i, j) = svm_validade(model1(j), gama(j,1), x_t1, x(i,:));
    end
end

s = meta_x (x, y1, model1, gama);

for i = 1:m
    for j = 1:mg
        yf(i, j) = svm_validade(model2(j), gama(j,2), x_t2, s(1).meta_x(i,:));
    end
end
end