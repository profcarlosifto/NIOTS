function yf = prediction_s(model, x)
%Realiza a predição dos dados dado um conjunto de valores x desconhecidos e
%os modelos do estágio 1 e 2 respectivamente.

% model     -> variável do tipo estrutura que possui todos os dados
% necessários para geração da SVR.
% x         -> conjunto de dados a serem submetidos a SVR. Ou dados que se
% deseja estimar.
if (strcmp(model.modelo, 'LibSVM'))
    %% Organizando os dados
    aux = x;
    x = aux.x;
    %Parâmetros de normalização
    min_x = model.normaliza(:,1)';
    max_x = model.normaliza(:,2)';
    x = normalize_prediction(x, min_x, max_x);
    %% Primeira fase do processo
    if strcmp(model.kernel,'Arccosine')        
        yf = svm_predict_cos2(model, model.xt, x);
    
    else
        [m, ~]=size(x);
        [mg, ~] = size(model(1).gama'); 
        y1 = zeros (m , mg);
        for i = 1:m
            for j = 1:mg
                y1(i, j) = svm_validade2(model(1), x(i,:),j);                
            end
        end
        yf=y1;
    end
else
    yf = simlssvm({model.xt,model.yt,'f',model.C,model.gama, model.kernel}, x.x);
end
end
