function [erro, sv, corr] = fit_svm_lib_cuda(x1, y1, x2, y2, tipo_sv, varargin)
% Função que avalia uma máquina para determinado conjunto de parâmetros C e
% gama utilizando o metodolodiga cross validation.
%X1 -> características dos dados de treinamento
%y1 -> rótulos dos dados de treinamento
%X2 -> características dos dados de teste
%y2 -> rótulos dos dados de teste
%kpar -> gama, parâmetro da função RBF
%C - Parâmetro de generalização.
%% Concatenando as características e os rótulos para não perder a correspondência.
%X = [X1, y1];
%[k l] = size(X); % Mede o tamanho do vetor de entrada para separar adequadamente os rótulos dos vetores característica

%% Informações sobre a alteração do arquivo.

% Deve ser passar o endereço do arquivo de treinamento e validação
% separados no formato do Thunder Master - LibSVM.

% Gerar um arquivo que leia a saída do preditor pegando o número de vetores
% de suporte e o erro e a correlação.

% Fazer um teste se para SVR ver se retorna estes dados no arquivo caso
% contrário calcular.

% Para minimizar o custo computacional pode-se ler o arquivo de teste uma
% única vez para comparar com a saída dos modelos.

kernel = varargin{1};
%% Preparação para chamada da função svmtrain e svmpredict
%kpar1=num2str(kpar);
C = varargin{2}(1,1);
if C <= 0 
    %C1 = '.0001';
    C1 = num2str(exp(varargin{2}(1,1)));
else
    C1 = num2str(exp(varargin{2}(1,1)));
    %C1 = log2(C1);
end
if size(varargin{2},2)==2 %Condição necessária para colocar o epsilon. Define se é uma SVM ou SVR
    eps = 0;
else
    eps = num2str(varargin{2}(1,3));
end
% Definindo o tipo de kernel e ajustando os parâmetros
if (kernel == 1)              %Definição do kernel
    kpar1 = num2str(exp(varargin{2}(1,2)));
    t_kernel = [' -t 2 ','-g ', kpar1];
    kernel_ls = 'RBF_kernel';
    sig2 = varargin{2}(1,2);
    
elseif (kernel == 3)
    [matriz, k_norma] = gram_matrix(x1, varargin{2});
    t_kernel = ' -t 4 ';
else 
    kpar1 = '1';
    a0 = '1';
    %a0 = num2str(varargin{2}(1,3));
    d = num2str(varargin{2}(1,2));
    t_kernel = [' -t 1 ','-g ', kpar1, ' -r ', a0, ' -d ', d];
    kernel_ls = 'poly_kernel';
    sig2 = [3 varargin{2}(1,2)]; % verificar pois a modificação mudou a representação de x.
end

%Determinando o tipo de classificador
if (tipo_sv == 1)           %Classificador utilizando o LibSVM 
    options = ['-s 0',' -c ', C1, t_kernel,' -h 1'];
    
elseif (tipo_sv == 2)       %Aproximador de funções utilizando o LibSVM     
    options = ['-s 3',' -c ', C1, t_kernel, ' -p ', eps, ' -h 1'];

elseif (tipo_sv == 3)       %Aproximador de funções multi-target utilizando o LibSVM
    options = ['-s 3',' -c ', C1,t_kernel, ' -p ', eps, ' -h 1'];

elseif (tipo_sv == 4)       %Classificador utilizando o LS-SVM
    type = 'c';        

elseif (tipo_sv == 5)       %Aproximador de funções utilizando o LS-SVM 
    type = 'f';
    
   
elseif (tipo_sv == 6)       %Aproximador de funções multi-target utilizando o LS-SVM
    type = 'f';
    

end
accuracy= 1000*[1; 1; 0];
if (tipo_sv <= 3)   %Escolhendo entre LibSVM (opções <= 3) e LSSVM
    if(kernel == 3) % if para selecionar a opção de kernel pre-calculado
        model = svmtrain([y1 x1], matriz, options);
        model.SVs=full(model.SVs);
        %[accuracy(2,1), yf] = svm_predict3_mex(model, x1, x2, y2, varargin{2}, k_norma); 
        [accuracy(2,1), yf]= svm_predict3(model, x1, x2, y2, varargin{2}, k_norma);
        corr = 1 - abs(correlation(yf, y2));
        %sprintf('Mean Squared Error = %f', accuracy(2,1))
        %[~, accuracy, ~] = svmpredict(y2, matriz.kv, model);        
    else
        model = svmtrain(y1, x1, options);
    end
    sv = model.totalSV;             % O número de vetores de suporte é igual para todos os casos.
    if sv == 0
        sv = size(x1,2);
    end
    %Implementação das métricas de avaliação baseada no artigo: A two
    %dimensional accuracy-based measure for classification performance (2016)
    if(tipo_sv == 1) %Classificador
        [yf, accuracy, ~] = svmpredict(y2,x2, model);
        accuracy(1) = accuracy(1)/100;
        erro  = (1 - accuracy(1));        
        [conf_m,~] = confusionmat(y2,yf);
        Nq = sum(conf_m,2);             %Para acelerar o processo em problemas grande este parâmetro deve ser passado para a função
        D_2 = 0;
        N = sum(Nq);
        for i = 1:model.nr_class
            D_2 = (conf_m(i,i)/Nq(i) - accuracy(1))^2*(Nq(i)/N)+D_2;            
        end
        corr = sqrt(D_2);
        %erro = trace(conf_m)/(size(yf,1));
        %tam_conf = size(conf_m,1);
        
%         if(tam_conf<model.nr_class)% Quando a máquina não classifica muito errado e não aparece nenhuma elemento de outra classe.
%             matriz_aux = zeros(model.nr_class); %Padroniza o tamanho da matriz de confusão.
%             matriz_aux(1:tam_conf,1:tam_conf) = conf_m;
%             conf_m = matriz_aux;
%         end
%         
%         for i = 1:model.nr_class
%             total_dt = sum(conf_m(i,:));            
%             if (total_dt ~= 0)
%                 conf_m(i,:) = conf_m(i,:)/total_dt; 
%             end
%             
%         end
%        corr = model.nr_class - trace(conf_m);
        
    elseif (tipo_sv == 2) % SVR Single target
        [saida, accuracy, ~] = svmpredict(y2,x2, model);
        if (isnan(accuracy(2))||(isinf(accuracy(2))))
            accuracy(2)=100;
        end

        %f_range = max(y2)-min(y2);
        %erro  = accuracy(2)/f_range;
        erro  = accuracy(2);
        corr =  1 - accuracy(3);  %Versão modificada para considerar ao invés de correlação considerar alpha == C.
        %corr = length(find(abs(abs(model.sv_coef)-C)<0.0001));
        %corr = corr/sv;
    elseif (tipo_sv == 3)           %SVR Multi-target
        erro  =  accuracy(2);
        %corr =  1-accuracy(3); %Versão modificada para considerar ao invés de correlação considerar alpha == C.
        %corr = length(find(abs(abs(model.sv_coef)-C)<0.0001));
        %corr = corr/sv;
    end
else
    % Usar model = trainlssvm()
    % Usar yp = predictlssvm()
    % Criar uma função ou trecho que calcule o mse usando yp e ytt
    % Colocar o valor dos parametros nas opçoes e quando elas chegarem ja
    % ser os valores corretos.
    model = trainlssvm({x1,y1, type, C, sig2, kernel_ls, 'preprocess'});
    yp = simlssvm(model, x2);
    [ly, cy] = size(yp);
    [sv, ~] = size(model.alpha);
    
    %erro = sum((yp - y2).^2)./ly; % equação original
    % Adaptar com uma forma semelhante fit_svm_lib_cross.m
    mse = sum((yp - y2).^2);
    avg_y = mean(yp);
    for i = 1:ly
        dif_y(i,:) = (y2(i,:)-avg_y);
    end
    desv_y = sum(dif_y.^2);
    
    erro = (1/cy)*sum((mse./desv_y).^(.5));  %Artigo: A survey on multi-output regression
    
    %corr = 0.5;         %Ainda não tenho certeza se a correlação continuará fazendo parte do cálculo.
end
%corr = 0; %Retirando esse objetivo mas não alterando a saída da função e alterando minimamente seu conteúdo.
end