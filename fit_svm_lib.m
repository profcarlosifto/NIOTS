function [erro, sv, corr] = fit_svm_lib(x1, y1, x2, y2, tipo_sv, varargin)
% Função que avalia uma máquina para determinado conjunto de parâmetros C e
% gama utilizando o metodolodiga cross validation.
%X1 -> características dos dados de treinamento
%y1 -> rótulos dos dados de treinamento
%X2 -> características dos dados de teste
%y2 -> rótulos dos dados de teste
%kpar -> gama, parâmetro da função RBF
%C - Parâmetro de generalização.

kernel = varargin{1};
%% Preparação para chamada da função svmtrain e svmpredict

C = varargin{2}(1,1);
C1 = num2str(exp(varargin{2}(1,1)));

% Definindo o tipo de kernel e ajustando os parâmetros
if (kernel == 1)              %Definição do kernel RBF
    kpar1 = num2str(exp(varargin{2}(1,2)));
    t_kernel = [' -t 2 ','-g ', kpar1];
    kernel_ls = 'RBF_kernel';
    sig2 = varargin{2}(1,2);

elseif (kernel == 2) % Kernel polinomial
    kpar1 = '1';
    a0 = '0'; %mudar também na função kernel_polynomial e escreve_saida
    d = num2str(varargin{2}(1,2));
    t_kernel = [' -t 1 ','-g ', kpar1, ' -r ', a0, ' -d ', d];
    kernel_ls = 'poly_kernel';
    sig2 = [3 varargin{2}(1,2)]; 
    
elseif (kernel == 3) % Kernel arccos 
    matriz = gram_matrix_cos(x1,x1);
    t_kernel = ' -t 4 ';
    
elseif (kernel == 4) % Kernel deep
    gamma = varargin{2}(1,2);
    d = varargin{2}(1,3);
    matriz = gram_matrix_deep(x1, gamma, d);
    t_kernel = ' -t 4 ';
    
elseif (kernel == 5) % Kernel hermite
    hp = varargin{2}(1,2);
    matriz = gram_matrix_hermite(x1, x1, hp);
    t_kernel = ' -t 4 ';
elseif (kernel == 6) % Kernel cauchy
    gamma = exp(varargin{2}(1,2));
    matriz = gram_matrix_cauchy(x1, x1, gamma);
    t_kernel = ' -t 4 ';
    
elseif (kernel == 7) % Kernel tanh
    kpar1 = num2str(exp(varargin{2}(1,2)));
    a0 = num2str(-exp(varargin{2}(1,3)));
    d = num2str(varargin{2}(1,2));
    t_kernel = [' -t 3 ','-g ', kpar1, ' -r ', a0];

end

%Determinando o tipo de classificador
if (tipo_sv == 1)           %Classificador utilizando o LibSVM 
    options = ['-s 0',' -c ', C1, t_kernel,' -h 1'];
    
elseif (tipo_sv == 2)       %Aproximador de funções utilizando o LibSVM 
    eps = num2str(varargin{2}(1,end)); 
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
    if(kernel >= 3)&& ~(kernel == 7)% if para selecionar a opção de kernel pre-calculado
        model = svmtrain([y1 x1], matriz, options);        
    else
        model = svmtrain(y1, x1, options);
        disp(options)
    end
    sv = model.totalSV;             % O número de vetores de suporte

    %Implementação das métricas de avaliação baseada no artigo: A two
    %dimensional accuracy-based measure for classification performance
    %(2016)  Eq.: 14 e 13
    if(tipo_sv == 1) %Classificador
        if (kernel == 1)||(kernel == 2)||(kernel == 7)
            [yf, accuracy, ~] = svmpredict(y2,x2, model);
                        
         elseif (kernel == 3)
            matriz = gram_matrix_cos(x2, x1);
            [yf, accuracy, ~] = svmpredict(y2, matriz, model);      

        elseif (kernel == 5)
            matriz = gram_matrix_hermite(x2, x1, hp);
            [yf, accuracy, ~] = svmpredict(y2, matriz, model);            
            
        elseif (kernel == 6)
            matriz = gram_matrix_cauchy(x2, x1, gamma);
            [yf, accuracy, ~] = svmpredict(y2, matriz, model);            
            
        end
          accuracy(1) = accuracy(1)/100;
          erro  = (1 - accuracy(1));
          corr = 0;

       
    elseif (tipo_sv == 2) % SVR Single target
        if (kernel == 1)||(kernel == 2)||(kernel == 7)
            [yf, accuracy, ~] = svmpredict(y2, x2, model);
            corr =  1 - accuracy(3);
            erro = mean((yf - y2).^2);
        elseif (kernel == 3)
            matriz = gram_matrix_cos(x2, x1);
            [yf, accuracy, ~] = svmpredict(y2, matriz, model);
            corr = 1 - accuracy(3);
            erro = accuracy(2,1);
            
        elseif (kernel == 4) 
            model.SVs=full(model.SVs);
            [accuracy(2), yf]= svm_predict_deep(model,gamma, d, x1, x2, y2);
            corr = 1 - abs(correlation(yf, y2));
            erro = accuracy(2,1);
            
        elseif (kernel == 5)
            model.SVs=full(model.SVs);
            [accuracy(2), yf] = svm_predict_hermite(model, x1, x2, y2, hp);
            corr = 1 - abs(correlation(yf, y2));
            erro = accuracy(2,1);
            
        elseif (kernel == 6)
            matriz = gram_matrix_cauchy(x2, x1, gamma);
            [~, accuracy, ~] = svmpredict(y2, matriz, model);
            erro  = accuracy(2);
            corr = accuracy(3);
        end
        
        if ~(isfinite(erro) && isfinite(corr))||(sv == 0) %Trata as exceções como o pior caso possível.
            erro = 1000000;
            corr = 1;
            sv = size(x1,1);
            yf = [];
        end
        
    elseif (tipo_sv == 3)           %SVR Multi-target
        erro  =  accuracy(2);
    end
end
end
