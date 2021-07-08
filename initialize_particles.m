function [particles, y, v, N] = initialize_particles(S, x_max, x_min, ini_v, max_ep, d_max, tipo_sv, kernel)
% Função que inicializa as partículas do MOPSO e MODE.
% A quantidade de variáveis será definido utilizando o tipo da SVM e o
% kernel.
% S         ->  Número de partículas ou tamanho da população.
% x_max     ->  Limite superior das partículas.
% x_min     ->  Limite inferior das partículas.
% tipo_sv   ->  Define se é um classificador ou regressor.
% kernel    ->  Define o tipo do kernel.

if tipo_sv == 1 % Classificador
    if (kernel == 1)||(kernel == 6) || (kernel == 7)% RBF
        N = 2;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N            
            for i = 1:S
                x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                y(i,j) = 1e10;
                v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
            end
        end
    elseif kernel == 2 % Polynomial
        N = 2;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N
            if j == 1
                for i = 1:S
                    x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
                end
            elseif j == 2
                for i = 1:S
                    x(i,j) = randi(d_max,1,1);  %Este elseif faz com que o grau do polinômio seja tratado de maneira diferente dos demais parâmetros da SVM.
                    y(i,j) = 1e10;
                    v(i,j) = ini_v;
                end
            end
        end
        
    elseif kernel == 3 % Arc cos
        N = 1;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N            
            for i = 1:S
                x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                y(i,j) = 1e10;
                v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
            end
        end

    elseif kernel == 4 % Deep kernel Carlos
        N = 3;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N
            if j <= 2
                for i = 1:S
                    x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
                end
            elseif j == 3
                for i = 1:S
                    x(i,j) = randi(d_max,1,1);  %Este else faz com que o grau do polinômio seja tratado de maneira diferente dos demais parâmetros da SVM.
                    y(i,j) = 1e10;
                    v(i,j) = ini_v;
                end
            end
        end
    end
elseif tipo_sv == 2 % Regressor
    if (kernel == 1)  || (kernel == 6) || (kernel == 7)% RBF
        N = 3;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N
            if j <= 2
                for i = 1:S
                    x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
                end
            elseif j == 3
                for i = 1:S
                    x(i,j) = max_ep*m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = rand*(max_ep/2); % Velocidade inicial dos epsilons
                end
            end
        end
    elseif kernel == 2 % Polynomial
        N = 3;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N
            if j == 1
                for i = 1:S
                    x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
                end
            elseif j == 2
                for i = 1:S
                    x(i,j) = randi(d_max,1,1);  %Este elseif faz com que o grau do polinômio seja tratado de maneira diferente dos demais parâmetros da SVM.
                    y(i,j) = 1e10;
                    v(i,j) = ini_v;
                end
            elseif j == 3
               for i = 1:S
                    x(i,j) = max_ep*m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = rand*(max_ep/2); % Velocidade inicial dos epsilons
                end
            end
        end
    elseif kernel == 3 % Arc cos
        N = 2;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N
            if j == 1
            for i = 1:S
                x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                y(i,j) = 1e10;
                v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
            end
            elseif j == 2
                for i = 1:S
                    x(i,j) = max_ep*m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = rand*(max_ep/2); % Velocidade inicial dos epsilons
                end
            end
        end

    elseif kernel == 4 % Deep kernel Carlos
        N = 4;
        m = SLHD (S, N);    %Função que gera a população inicial melhor distribuído. Utilizando a técnica Symmetric Latin Hypercube Distribution.
        x = zeros(S,N);
        for j = 1:N
            if j <= 2
                for i = 1:S
                    x(i,j) = x_min + (x_max-x_min) * m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = ini_v*rand; %Rand altera a velocidade inicial das partículas.
                end
            elseif j == 3
                for i = 1:S
                    x(i,j) = randi(d_max,1,1);  %Este else faz com que o grau do polinômio seja tratado de maneira diferente dos demais parâmetros da SVM.
                    y(i,j) = 1e10;
                    v(i,j) = ini_v;
                end
            elseif j == 4
                for i = 1:S
                    x(i,j) = max_ep*m(i, j); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C
                    y(i,j) = 1e10;
                    v(i,j) = rand*(max_ep/2); % Velocidade inicial dos epsilons
                end
            end
        end
    end
end
particles = x;

end