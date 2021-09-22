function [metricas, param_out, pareto ]= MOPSO_lib_mkl(X1, y1, conj, ite_mopso, mod, tipo_sv,  varargin)
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
n_obj = 3;                      % Número de funções objetivo
S = varargin{1}{1};             % number of particles
maxiter = ite_mopso;            % max number of iterations
arc_size = 20;
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
epsilon = varargin{5};          % Epsilon da função loss function e-insensitive
if isempty(conj)                %Se o conjunto cross-validation for vazio significa que existe um conjunto de predição.
    x2 = varargin{1}{14};       %Vetor característica do conjunto de teste.
    y2 = varargin{1}{15};       %Vetor label do conjunto de teste.
    kernel = varargin{1}{16};
    
else
    kernel = varargin{1}{14};
end
fx_obl=1e10*ones(S,n_obj);       % Inicializa os vetor que armazena o valor das funções objetivo de cada partícula OBL   
N = 3;                          % Quantidade elementos na partícula, no futuro flexibilizar para aceitar mais elementos.
% %Condição que define a dimensão das partículas.
% if (kernel == 1)
%     N = 2;
% elseif (kernel == 2)
%     N = 4;
% elseif (kernel == 3)
%     N = 4;
% end
x_obl = zeros(S,N);             % Variável que armazena as partículas OBL.

% Range domain for fitness function
    x_max = varargin{1}{8};
    x_min = varargin{1}{7}; 
    max_v = varargin{1}{6};                  % max velocity
    ini_v = max_v/10;                        % initial velocity
%Calculando os limites do grau do polinômio.
d_min = 0;                          % Os limites do polinômio será mantido para versões futuras com combinação de RBF e Polinomial.
d_max = 1;
max_v_d = 0.1;
max_w_d= 0.2;
w_d = max_w_d;
%threshold = 1e-10;
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
v = zeros(S,N);
y = 1e10*ones(S,N);
v = ini_v*ones(S,N);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For que inicializa as partículas.
for i=1:S
    for j=1:N
        if(j<=2)
            x(i,j) = x_min + (x_max-x_min) * rand(); %vetor que armazena as partículas (i número de partículas) x(i,1)-> Sigma, x(i,2) -> C           
        else
            x(i,j) = rand( );  % Define o valor da combinação linear u1
            break;   %Necessário um break pois o for avalia depois o contador e portanto não bloequia o preenchimento da matriz x.
        end
        
    end
end

%% ITERATIVE PROCESS
while k<= maxiter    
    if(mod == 2) %Fazendo a função OBL (Opposition Based Learning)
            x_obl(:,1:2) = x_min(:,1:2)+x_max(:,1:2) - x(:,1:2);                %Fazendo oposição a todas partículas em todas as iterações.
            %x_obl(:,3) = 1-x(:,3);
            
    end
    %% Evaluates fitness and local detection
    %Colocar o parfor aqui para usar o modo paralelo.
    for i = 1:S
        if ~(isempty(conj)) %Condição que verifica de a opção cross-validation está ativa            
            [erro, sv, ~] = fit_svm_lib_cross(X1, y1, conj, epsilon, tipo_sv, kernel, x(i,:)); %x(1) -> C, x(2) -> sigma, x(3) -> u1 e x(4) -> 1 - u1
        else
            [erro, sv, corr] = fit_svm_lib(X1, y1, x2, y2, epsilon, tipo_sv, kernel, x(i,:));
        end
        %Colocar um if aqui que seleciona entre cross-validation ou não.
        %Criar outra função fit_svm.
        fx(i,:)= [erro sv corr];
        if (fx(i,:) <= f_ind(i,:))        %Colocando na lista dos não dominados? 
            y(i,:) = x(i,:);
            f_ind(i,:) = fx(i,:);           
        end
        if (mod == 2)
            if ~(isempty(conj))
                [erro_obl, sv_obl, ~] = fit_svm_lib_cross(X1, y1, conj, epsilon,tipo_sv, kernel, x_obl(i,:));       % Avaliando as partículas OBL
            else
                [erro_obl, sv_obl, ~] = fit_svm_lib(X1, y1, x2, y2, epsilon, tipo_sv, kernel, x_obl(i,:));
            end
                fx_obl(i,:)= [erro_obl sv_obl];
            if (fx_obl(i,:) <= fx(i,:))             % Verificando se as partículas OBL dominam as partículas x.
                x(i,:) = x_obl(i,:);
                fx(i,:) = fx_obl(i,:);
            end
        end
    end
    
%% Evaluate non dominate set
    Arc_all = [arc_x;x];
    Arc_all_f = [arc_f; fx];
    
    [~,ia]=unique(Arc_all_f, 'rows');
    Arc_all_f = Arc_all_f (ia,:);
    Arc_all = Arc_all(ia,:);
    
                        %CD
    %[arc_x, arc_f, rank, ~] = truncate([Arc_all; x],[Arc_all_f; fx],arc_size);  % Esta versão concatena duas vezes o mesmo vetor
    [arc_x, arc_f, rank, ~] = truncate(Arc_all,Arc_all_f, arc_size);
    ind_nd = rank == 1;
    nd_sols = sum(ind_nd);
    arc_x = arc_x(ind_nd,:);
    arc_f = arc_f(ind_nd,:);
  
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
        [r_ind, ~, ~] = find(min(min(indb(i).fx(:,c_fx)))==indb(i).fx(:,c_fx));
        y(i,:) = indb(i).x(r_ind(1,1),:);         % Para mudar de randômico para mínimo tem que alterar a variável desta linha
    end
end
   
%% global detection
    ind_gbest = randi(length(arc_x));  %Escolhe aleatoriamente um valor entre os 5% melhores.
    ys = arc_x(min([ind_gbest nd_sols]),:);  %gbest
    %% Modificador Atrativo-repulsivo
    if (mod == 3)
        diversity_s = diversity(x);
        if ((dir_ar > 0)&&(diversity_s < d_low))
            dir_ar = -1;
        elseif ((dir_ar < 0)&&(diversity_s > d_high))
            dir_ar = 1;
        end
    else
        dir_ar = 1;
    end
       
    %% update particles. 
    for i=1:S          %foi trocada a ordem entre N e S!! Caso não funcionar voltar para versão anterior neste ponto   
        for j = 1:N %O último elemento é calculado em função do penúltimo. 
            if (rand_type == 1)
                r1 = rand;
                r2 = rand;
                
            elseif(rand_type == 2)
                r1 = randn;
                r2 = randn;
                
            elseif(rand_type == 3)
                r1 = 0.01*tan(pi*(rand-0.5));
                r2 = 0.01*tan(pi*(rand-0.5));                
            end
            %Modificação para tratar o parâmetro C e gamma de forma
            %independente pois os dois possuem valores absolutos muito
            %diferentes
            if (j<=2) % Movimentando C e gama
                v(i,j) = w*v(i,j) + dir_ar*(c1*r1*(y(i,j)-x(i,j)) + c2*r2*(ys(j) - x(i,j)));
                if abs(v(i,j)) > max_v
                    if v(i,j) > 0
                        v(i,j) = max_v;
                    else
                        v(i,j) = -max_v;
                    end
                end
            else % Movimentando os coeficientes da combinação linear
                v(i,j) = w_d*v(i,j) + dir_ar*(c1*r1*(y(i,j)-x(i,j)) + c2*r2*(ys(j) - x(i,j)));             
                if abs(v(i,j)) > max_v_d
                    if v(i,j) > 0
                        v(i,j) = max_v_d;
                    else
                        v(i,j) = -max_v_d;
                    end
                end                
            end
            x(i,j) = x(i,j) + v(i,j);
            if j <= 2
                if x(i,j) > x_max
                    x(i,j) = x_max;
                elseif x(i,j) < x_min
                    x(i,j) = x_min;
                end
            else
                if x(i,j) > d_max
                   x(i,j) = d_max;
                elseif x(i,j) < d_min
                   x(i,j) = d_min;
                end                
            end
        end
    end
    w_d = max_w_d/k;
    %w = w+slope;   %Este cálculo está errado pois ele aumenta w ao invés de diminuir que vai contrário a ideia básica do PSO
    w = wf - k/maxiter*(wf-w0); %Linear: Ref.: A distributed PSO-SVM hybrid system with feature selection and parameter optimization. Autor: Cheng-Lung Huang, Jian-Fan Dun
    k=k+1;
%% Obtendo os dados para convergência
aux1 = size(arc_f);
%ind_pf = randi(1000, aux1(1,1), 1);
%PFstar1 = PFstar(ind_pf,:);
%igd(k) = IGD(PFstar1, arc_f); %A métrica IGD não funciona porque não há
%fronteira de pareto para este problema.
aux_tam=size(arc_f);
[l_x1,~] = size(X1);
if (k == 2)
    mse_worst = max(arc_f(:,1));
    mse_worst = 1.5*mse_worst(1,1);
    corr_worst = max(arc_f(:,3));
    corr_worst = 1.5*corr_worst(1,1);        
end
hyper(k) = hypervolume(arc_f, [mse_worst, l_x1 corr_worst], 1000); 
%hyper(k) = hypervolume(arc_f, [0, 0, 0], 1000); 

if(aux_tam(1,1)>=2)
    dist(k) = spacing(arc_f);
   
else
    dist(k) = 0;
end
sols(k) = aux1(1,1);
porcentagem = (k-1+(varargin{4}-1)*ite_mopso)/(varargin{3}*ite_mopso);
waitbar(porcentagem,varargin{2},sprintf('%i%% along...',100*porcentagem));
end %End do laço das iterações
param_out = arc_x;
%sigma = arc_x(:,2);
%C = arc_x(:,1);
pareto = arc_f;

metricas = [dist' sols' hyper'];
metricas(1,:) =[];

end %finaliza a função MOPSO
