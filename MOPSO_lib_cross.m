function [metricas, param_out, pareto, poda ]= MOPSO_lib_cross(X1, y1, conj, ite_mopso, mod, tipo_sv,  varargin)
% A função objetivo é a saída do algoritmo de treinamento da SVM - Erro
% empírico e vetores de suporte. 
%X1 => Vetores característica do conjunto de treinamento
%y1 => Rótulos do conjunto treinamento 
%X2 => Vetores característica do conjunto de testes
%y2 => Rótulos do conjunto de testes. 
%mod => Representa a variável lógica para escolha do modificador: 
%                                       0 -> nenhum
%  mod =>                               1 -> OBL
%                                       2 -> Ar
% S = Número de partículas.
% n_obj => Número de funções objetivo (por enquanto fixo em 2)
%% PSO PARAMETERS %%
n_obj = 2;                      % Número de funções objetivo
S = varargin{1}{1};             % number of particles
maxiter = ite_mopso;            % max number of iterations
arc_size = S*20;
wf = varargin{1}{3};            % final weight
w0 = varargin{1}{2};            % initial weight
w=w0;                           %Inércia recebe o valor inicial 
slope = (wf-w0)/maxiter;
c1 = varargin{1}{4};            % cognitive coefficient
c2 = varargin{1}{5};            % social coefficient
dir_ar = 1;                     % direção inicial do modificador de diversidade
d_low = varargin{1}{9};         %0.15; % limite inferior da diversidade
d_high = varargin{1}{10};       %0.25; % limite superior da diversidade    
rand_type = varargin{1}{13};    %Variável lógica que define o tipo do gerador aleatório

if isempty(conj)                %Se o conjunto cross-validation for vazio significa que existe um conjunto de predição.
    x2 = varargin{1}{14};       %Vetor característica do conjunto de teste.
    y2 = varargin{1}{15};       %Vetor label do conjunto de teste.
    kernel = varargin{1}{16};
    epsilon = varargin{1}{17};          % Epsilon da função loss function e-insensitive
    
else
    kernel = varargin{1}{14};
    epsilon = varargin{1}{15};          % Epsilon da função loss function e-insensitive
end
fx_obl=1e10*ones(S,n_obj);       % Inicializa os vetor que armazena o valor das funções objetivo de cada partícula OBL   

%Condição que define a dimensão das partículas.
if ischar(epsilon)  %Condição que determina se é um classificador ou não.
    if (kernel == 1)        % Kernel RBF
        N = 2;
    elseif (kernel == 2)    % Kernel Polynomial
        N = 2;
    elseif (kernel == 3)    % Arc cosseno
        N = 1;
    elseif (kernel == 4)    % Deep kernel
        N = 3;
    end
else
    if (kernel == 1)        % Kernel RBF
        N = 3;
    elseif (kernel == 2)    % Kernel Polynomial
        N = 3;
    elseif (kernel == 3)    % Arc cosseno
        N = 2;
    elseif (kernel == 4)    % Deep kernel
        N = 4;
    end
end
x_obl = zeros(S,N);             % Variável que armazena as partículas OBL. Posição 1-> C, 2-> gama, 3 -> epsilon

% Range domain for fitness function
    x_max = varargin{1}{8};
    x_min = varargin{1}{7}; 
    max_v = varargin{1}{6};                  % max velocity
    ini_v = max_v/10;                        % initial velocity
%Calculando os limites do grau do polinômio.
d_min = 1;
d_max = 20;
max_v_d = 3;
max_w_d= 0.7;
w_d = max_w_d;

max_ep = epsilon;
k = 1;                          % index of iteration


% Just for testing particles with the same intial position. 
% Uses the same seed for the random number generator
%rand('twister',12092014); 
x = zeros(S,N);                 % Inicializando o vetor da população com zeros.
arc_x= [];
arc_f = [];
% INITIALIZATION
%f_ind = 1e10*ones(S,1);          % initialize best local fitness 
fx=1e10*ones(S,n_obj);           % Inicializa os vetor que armazena o valor das funções objetivo de cada partícula   
f_ind = 10^10*ones(S, n_obj);    % initialize best local fitness 
%v = zeros(S,N);
%y = zeros(S,N);
%Inicializa as métricas
hyper = zeros(1,maxiter);
dist = ones(1,maxiter);
sols = ones(1, maxiter);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For que inicializa as partículas de acordo com o kernel e o tipo de variável
% Possivelmente transformar essa seção do programa em uma função no futuro.
[x, y, v, N] = initialize_particles(S, x_max, x_min, ini_v, max_ep, d_max, tipo_sv, kernel);

%% Variáveis da poda
rx_p = 0.3; %0.2
w_xt1 = zeros(size(X1,1),1);
wt = zeros(size(X1,1),S);
poda.tam = 0;
log_poda = 0;
%% ITERATIVE PROCESS
tic
%mpiprofile on
while k<= maxiter 
%% Estudo do comportamento das partículas
%  figure(3)
%  plot(x(:,1),x(:,2),'.','markersize',10,'markerfacecolor','r');
%  drawnow;
%%
if(mod == 2)
    if kernel == 1
        for j = 1:3
            if (j <= 2 )      %Fazendo a função OBL (Opposition Based Learning)
                x_obl(:,j) = x_min + (x_max - x(:,j));                %Criar uma regra para acontecer o OBL segundo uma dada probabilidade
            else
                x_obl(:,j) = (max_ep - x(:,j));  %o valor mínimo foi excluído 0 < eps < max_ep      %Fazer esse valor de acordo com alguma métrica do conjunto de treinamento.
            end
        end
    elseif kernel == 2          %Trata no OBL os kernel polinomial e RBF de forma diferente.
        x_obl(:,1) = x_min + (x_max - x(:,1));
        x_obl(:,2) = d_min + (d_max - x(:,2));
        x_obl(:,3) = 0 + (max_ep - x(:,3));
    end
end
    %% Evaluates fitness and local detection
    cross = isempty(conj); 
    %Colocar o parfor aqui para usar o modo paralelo.
    %Para que o parfor funcione este condicional deve ser ativdado.   
    if ~ cross
        x2 = zeros(3);
        y2 = zeros(3,1);
    end
    for i = 1:S
        if ~cross
            [erro, sv, ~] = fit_svm_lib_cross(X1, y1, conj,tipo_sv, kernel, x(i,:));  
        else
            if k == log_poda %Condição para cortar parte do conjunto de treinamento
                [erro, sv, ~, w_xt] = fit_svm_lib_poda(X1, y1, x2, y2, tipo_sv, kernel, x(i,:), w_xt1);
                wt(:,i) = w_xt;
            else
                [erro, sv, ~] = fit_svm_lib(X1, y1, x2, y2, tipo_sv, kernel, x(i,:));
            end
        end
        %Colocar um if aqui que seleciona entre cross-validation ou não.
        %Criar outra função fit_svm.
        fx(i,:)= [erro sv];
        if (fx(i,:) <= f_ind(i,:))        %Colocando na lista dos não dominados? 
            y(i,:) = x(i,:);
            f_ind(i,:) = fx(i,:);           
        end
        if (mod == 2)
            if ~(isempty(conj))
                [erro_obl, sv_obl, ~] = fit_svm_lib_cross(X1, y1, conj, epsilon,tipo_sv, kernel, x_obl(i,:));       % Avaliando as partículas OBL
            else
                [erro_obl, sv_obl, ~] = fit_svm_lib(X1, y1, x2, y2, tipo_sv, kernel, x_obl(i,:));
            end
                fx_obl(i,:)= [erro_obl sv_obl ~];
            if (fx_obl(i,:) <= fx(i,:))             % Verificando se as partículas OBL dominam as partículas x.
                x(i,:) = x_obl(i,:);
                fx(i,:) = fx_obl(i,:);
            end
        end
    end    
    %% Finalizando a poda do conjunto de treinamento
    if k == log_poda
        [wtn, ~, ~] = normaliza(wt);    % Deve-se normalizar para colocar na mesma grandeza a importância de cada elemento do conjunto de treinamento para cada modelo.
        wt = mean(wtn,2);               % Depois faz a média da importância de cada dado de treinamento para cada hiperpâmetro
        ind_p = find(wt <= rx_p);       % Verifica os dados que possui importância menor que rx_p.
        X1(ind_p,:) = [];
        y1(ind_p,:) = [];
        poda.tam = size(ind_p, 1);
        poda.ind = ind_p;
    end
%% Evaluate non dominate set
    Arc_all = [arc_x;x];
    Arc_all_f = [arc_f; fx];
    
    [~,ia]=unique(Arc_all_f, 'rows');
    Arc_all_f = Arc_all_f (ia,:);
    Arc_all = Arc_all(ia,:);
    
                        %CD
    [arc_x, arc_f, rank, ~] = truncate(Arc_all,Arc_all_f, arc_size);
    ind_nd = rank == 1;
    nd_sols = sum(ind_nd);
    arc_x = arc_x(ind_nd,:);
    arc_f = arc_f(ind_nd,:);
%% Estudo do comportamento das partículas
% figure(1)
% plot(arc_f(:,1),arc_f(:,2),'.','markersize',10,'markerfacecolor','r');
% drawnow;
%%
  
%% Individual detection

for i=1:S
    if (k == 1)
        indb(i).x(k,:) = x(i,:);
        indb(i).fx(k,:) = fx(i,:);
        y(i,:) = indb(i).x(k,:);
    else
        indb(i).x = [indb(i).x; x(i,:)];
        indb(i).fx = [indb(i).fx; fx(i,:)];
        
        [~,ia]=unique(indb(i).fx, 'rows');
        indb(i).fx = indb(i).fx(ia,:);
        indb(i).x = indb(i).x(ia,:);
        
        [indb(i).x, indb(i).fx, rank, ~] = truncate(indb(i).x, indb(i).fx, 5);
        ind_nd_p = rank == 1;               %Serve para cortar para as soluções que possuem apenas rank == 1;
        indb(i).x = indb(i).x(ind_nd_p,:);
        indb(i).fx = indb(i).fx(ind_nd_p,:);
        %ind_rp = randi(sum(ind_nd_p));             % Random index in particle non-dominate set.
        c_fx = randi(n_obj);                            % Escolhe um dos objetivos para o mínimo.
        %c_fx = 1;
        [r_ind, ~, ~] = find(min(min(indb(i).fx(:,c_fx)))==indb(i).fx(:,c_fx));
        y(i,:) = indb(i).x(r_ind(1,1),:);         % Para mudar de randômico para mínimo tem que alterar a variável desta linha
    end
end
   
%% global detection
    ind_gbest = randi(length(arc_x));  
    %ind_gbest = 3;    %Escolhe o erro como referência
    ys = arc_x(min([ind_gbest nd_sols]),:);  %gbest
    %% Modificador Atrativo-repulsivo
    if (mod == 3)
        dir_ar =  diversity (x, div_low, div_high, dir_ar, limites);
        %diversity_s = diversity(x, x_max);
        %teste_diver(k) = diversity_s; % Entender a variação da diversidade
        
        if ((dir_ar > 0)&&(diversity_s < d_low))
            dir_ar = -1;
        elseif ((dir_ar < 0)&&(diversity_s > d_high))
            dir_ar = 1;
        end
    else
        dir_ar = 1;
    end
       
    %% update particles.
    if (kernel == 1) % Kernel RBF
        [x,v] = upadate_pso_particles_rbf(x, y,ys, c1, c2, w, v, x_max, x_min, S, N, max_v, dir_ar, rand_type, max_ep);
        
    elseif (kernel == 2) % Kernel polinomial
        [x, v] = upadate_pso_particles_poly(x, y,ys, c1, c2, w, v, w_d, x_max, x_min, d_min, d_max, max_ep, S, N, max_v, max_v_d, dir_ar, rand_type);
        
    elseif (kernel == 3) % Kernel arc cosseno
        [x,v] = upadate_pso_particles_arc(x, y,ys, c1, c2, w, v, x_max, x_min, S, N, max_v, dir_ar, rand_type, max_ep);
        
    elseif (kernel == 4) % Deep kernel
        [x,v] = upadate_pso_particles_deep(x, y,ys, c1, c2, w, v, w_d, x_max, x_min, d_min, d_max, max_ep, S, N, max_v, max_v_d, dir_ar, rand_type);
    end

    w_d = max_w_d/k;
    w = w+slope;
    %w = ((wf-w0)/maxiter^2)*k^2+w0;
    %w = wf - k/maxiter*(wf-w0); %Linear: Ref.: A distributed PSO-SVM hybrid system with feature selection and parameter optimization. Autor: Cheng-Lung Huang, Jian-Fan Dun    k=k+1;
    
%% Obtendo os dados para avaliação da convergência
aux1 = size(arc_f);
aux_tam=size(arc_f);
[l_x1,~] = size(X1);
%%Calculando o hipervolume a cada iteração
if (k == 1)  
    length_x = length(X1);
    range_y = max(y1) -  min(y1);
end

hyper(k) = hyper_norm (arc_f, range_y, length_x);
%hyper(k) = Hypervolume_MEX(arc_f, [mse_worst, sv_worst, 1], 1000); 
%hyper(k) = hypervolume(arc_f, [0, 0, 0], 1000); 
%avaliação da convergencia dos minimos e erro, sv, correlação
erro_c(k) = min(arc_f(:,1));
sv_c(k) = min(arc_f(:,2));
%corr_c(k) = min(arc_f(:,3));


if(aux_tam(1,1)>=2)
    dist(k) = spacing(arc_f);
   
else
    dist(k) = 0;
end
sols(k) = aux1(1,1);
porcentagem = (k+(varargin{4}-1)*ite_mopso)/(varargin{3}*ite_mopso);
waitbar(porcentagem,varargin{2},sprintf('%i%% along...',100*porcentagem));
k=k+1;
end %End do laço das iterações
%mpiprofile viewer
poda.elapsedTime=toc;
param_out = arc_x;
%sigma = arc_x(:,2);
%C = arc_x(:,1);
pareto = arc_f;
metricas.classico = [dist' sols' hyper'];
metricas.classico(1,:) =[];
metricas.conv = [erro_c' sv_c'];
metricas.conv(1,:) =[];
% Construindo o gráfico da diversidade para análise de seu comportamento.
%figure(4)
%plot (1:k-1, teste_diver);
end %finaliza a função MOPSO
