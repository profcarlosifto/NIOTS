%% MODE
% Multi-objective Evolutionary Algorithm (MOEA) based on Differential
% Evolution (DE).
% It implements a greedy selection based on pure dominance.
% DE algorithm has been introduced in:
%
% Storn, R., Price, K., 1997. Differential evolution: A simple and 
% efficient heuristic for global optimization over continuous spaces. 
% Journal of Global Optimization 11, 341 359.
%%

%% Overall Description
% This code implements a basic multi-objective optimization algorithm based
% on Diferential Evolution (DE) algorithm.
%
% When one objective is optimized, the standard DE runs; if two or more
% objectives are optimized, the greedy selection step in DE algorithm is 
% performed using a dominance relation.
%% Versão atualizada para tratar problema de seleção de parâmetros da SVM/SVR
% Aborda o problema como multi-objetivo e utiliza a função truncate para
% determinar as soluções não dominantes e mantê-las para a próxima geração.
%
%% 
function OUT=MODE(MODEDat)
 
%% Reading parameters from MODEDat
Generaciones  = MODEDat.MAXGEN;    % Maximum number of generations.
Xpop          = MODEDat.XPOP;      % Population size.
Nvar          = MODEDat.NVAR;      % Number of decision variables.
Nobj          = MODEDat.NOBJ;      % Number of objectives.
Bounds        = MODEDat.FieldD;    % Optimization bounds.
Initial       = MODEDat.Initial;   % Initialization bounds.
ScalingFactor = MODEDat.Esc;       % Scaling fator in DE algorithm.
F             = ScalingFactor;     % Fator de escala inicial
CrossOverP    = MODEDat.Pm;        % Crossover probability in DE algorithm.
mop           = MODEDat.mop;       % Cost function.
N_bin = round(Xpop/2);
set_parameter.bin = 1:(N_bin-1);
set_parameter.exp = N_bin:Xpop;
set_parameter.CrossOverP = CrossOverP;
%slope_cr = (CrossOverP - .2)/Generaciones;
arc_size = 2*Xpop;                 % Size of non-dominate set.
rand_type = MODEDat.rand_type;
mod_div = MODEDat.mod;
%F = ones(Xpop,1);
%% Initial PF e PS
PFront = [];
PSet = [];

%% Initial random population
Parent = zeros(Xpop,Nvar);  % Parent population.
Mutant = zeros(Xpop,Nvar);  % Mutant population.
Child  = zeros(Xpop,Nvar);  % Child population.
%FES    = 0;                 % Function Evaluation. (Era usado como critério de parada)
hyper = zeros(1, Generaciones);
%% Gera a população inicial
%Para o multi-kernel aqui precisa de um if para tratar o mi_1 diferente
m = SLHD (Xpop, Nvar); % Fazendo a população inicial de acordo com o Latin Hypercube Design

for xpop=1:Xpop 
    for nvar=1:Nvar
        
        if (MODEDat.kernel == 3) % If que seleciona o tipo de kernel MKL e trata cada elemento da partícula de forma apropriada
            if (nvar == 2)
                Parent(xpop,nvar) = m(xpop, nvar); % Definindo o epsilon do problema
            else
                Parent(xpop,nvar) = Initial(nvar,1)+(Initial(nvar,2)- Initial(nvar,1))*m(xpop, nvar);
            end
            
            
        elseif (MODEDat.kernel == 1) % If que seleciona o tipo de kernel RBF
           if (nvar == 3)
                Parent(xpop,nvar) = m(xpop, nvar); % Definindo o epsilon do problema
            else
                Parent(xpop,nvar) = Initial(nvar,1)+(Initial(nvar,2)- Initial(nvar,1))*m(xpop, nvar);
            end
            
        elseif (MODEDat.kernel == 2) % If que seleciona o tipo de kernel Polinomial/Hermitiano e trata cada elemento da partícula de forma apropriada
            if (nvar == 1)
                Parent(xpop,nvar) = Initial(nvar,1)+(Initial(nvar,2)- Initial(nvar,1))*m(xpop, nvar);

            elseif (nvar == 2)
                Parent(xpop,nvar) = randi(20,1,1); % Definindo valores inteiros para o grau do polinômio
                
            else 
                Parent(xpop,nvar) = m(xpop, nvar); % Definindo o epsilon do problema

            end
        elseif (MODEDat.kernel == 4) % If que seleciona o Deep Kernel e trata cada elemento da partícula de forma apropriada
            if (nvar == 1)||(nvar == 2)
                Parent(xpop,nvar) = Initial(nvar,1)+(Initial(nvar,2)- Initial(nvar,1))*m(xpop, nvar);

            elseif (nvar == 3)
                Parent(xpop,nvar) = randi(20,1,1); % Definindo valores inteiros para o grau do polinômio
                
            else 
                Parent(xpop,nvar) = m(xpop, nvar); % Definindo o epsilon do problema

            end 
        elseif (MODEDat.kernel == 5) % If que seleciona o tipo de kernel Polinomial/Hermitiano e trata cada elemento da partícula de forma apropriada
            if (nvar == 1)
                Parent(xpop,nvar) = Initial(nvar,1)+(Initial(nvar,2)- Initial(nvar,1))*m(xpop, nvar);

            elseif (nvar == 2)
                Parent(xpop,nvar) = randi(2,1,1); % Definindo valores inteiros para o grau do polinômio
                
            else 
                Parent(xpop,nvar) = m(xpop, nvar); % Definindo o epsilon do problema

            end
            
        end
        
        
    end
 
 
end
%Limita o espaço de busca aqui 1 x 1.
if size(MODEDat.InitialPop,1)>=1
    Parent(1:size(MODEDat.InitialPop,1),:)=MODEDat.InitialPop;
end
%Caculando o fitness da população inicial.
JxParent = mop(Parent,MODEDat); %A variável mop chama a função custo para avaliar Parent e MODEDat é o nome da função a ser otimizada
%FES = FES+Xpop;   
dir_ar = 1;
%% Definindo a quantidade de mutantes
aux_m = round(Xpop/4);
set_parameter.rand_1 = 1:aux_m;
set_parameter.rand_2 = aux_m+1:2*aux_m;
set_parameter.current_best_1 = (2*aux_m+1): 3*aux_m;
set_parameter.rand_best_1 = (3*aux_m+1):Xpop;
% Inicializando as variáveis de plotar os gráficos da mutação
mutant_1 = zeros(1,Generaciones);
mutant_2 = zeros(1,Generaciones);
mutant_3 = zeros(1,Generaciones);
mutant_4 = zeros(1,Generaciones);


%% Evolution process

for n=1:Generaciones
   
    if (mod_div == 3)
        dir_ar =  diversity (Parent, MODEDat.div_low, MODEDat.div_high, dir_ar, Bounds);
    else
        dir_ar = 1;
    end
    
    criterio = best_parent (JxParent, n);
    
    if n <= 1
        [F, set_parameter.CrossOverP] = sa_parameters(JxParent, F, set_parameter.CrossOverP, n, Generaciones, criterio);
    elseif mod(n,5) == 0
        [F, set_parameter.CrossOverP] = sa_parameters(JxParent, F, set_parameter.CrossOverP, n, Generaciones, criterio);
    end
%% Seção utilizada para avaliar o comportamento do F e Cr ao longo das iterações.
    %F_t(:,n)= F;    
    %Cr_t(:,n) = set_parameter.CrossOverP;
%%  
    [Mutant, set_parameter] = mutant_generate(Parent, JxParent, F, Bounds, Xpop, dir_ar, set_parameter, n, Generaciones, criterio);
    if (MODEDat.kernel == 2)||(MODEDat.kernel == 5) %Polinomial
        Mutant(:,2) = abs(round(Mutant(:,2))); % Achei melhor colocar abs para garantir que no kernel polinomial não haverá expoentes negativos
        if sum(Mutant(:,2) == 0)
            [x,~]=find(Mutant(:,2)==0); %2 é a posição do grau do polinômio.
            Mutant(x,2) = randi(20,1);            
        end        
    end
    %Child = crossover_generate (Parent, Mutant, CrossOverP, Xpop, rand_type);
    [Child, set_parameter] = crossover_generate_sa (Mutant, Parent, JxParent, set_parameter, criterio);
    % Implementando o OBL. Gera as partículas opositoras a partir de Child
    % e as avaliam em relação as partículas originais.
    if(mod_div == 2)
        Child_obl(:,1) = (Bounds(1,2)+Bounds(1,1))-Child(:,1);
        Child_obl(:,2) = (Bounds(2,2)+Bounds(2,1))-Child(:,2);
        Child_obl(:,3) = (Bounds(3,2)+Bounds(3,1))-Child(:,3);
        if (MODEDat.kernel == 3)
            Child_obl(:,3) = 1-Child(:,3);      % Valor fixo igual a 1 devido a restrição do modelo
        end
        
        JxChild_obl = mop(Child_obl,MODEDat);
        JxChild = mop(Child,MODEDat);
        for i = 1:MODEDat.XPOP
            if (sum(JxChild_obl(i,:)< JxChild(i,:)) >=3 ) % Se dois ou mais valores de JxChild_obl forem menores que JxChild na mesma posição
                Child(i,:) = Child_obl(i,:);
                JxChild(i,:) = JxChild_obl(i,:);
            end
        end
        %FES=FES+Xpop;
    else
        JxChild = mop(Child,MODEDat);
        %FES=FES+Xpop;
    end
    
    %% Selection
    % Seleção está diretamente relacionada à população, portando arc_size
    % será substituído por Xpop
    
    %% Observações em relação as modificação do Self Adaptative
    [Parent, JxParent, arc_Parent, arc_JxParent] = mode_classic_selection(Child, JxChild, Parent, JxParent, Xpop);
    %Fim da seleção
    %
    % Esta sequência com o truncate atualiza o conjunto de Pareto e
    % fronteira de Pareto. Pois quando coloca os melhores da pulação deve
    % ser verificado se eles dominam ou não as soluções que já estão no
    % conjunto
    PFront=[arc_JxParent; PFront];
    PSet= [arc_Parent; PSet];
    
    [~,ia]=unique(PFront, 'rows');       %Tira os elementos repetidos, ia está na ordem crescente em relação ao MSE
    PFront = PFront (ia,:);               %Tira os elementos repetidos
    PSet = PSet(ia,:);
    
    [PSet, PFront, rank, ~] = truncate(PSet, PFront, arc_size);
    ind_nd = rank == 1;
    PFront = PFront(ind_nd(1:arc_size),:);
    PSet = PSet(ind_nd(1:arc_size),:);
    % Essa é uma forma distinta de seleção verificar posteriormente a
    % viabilidade de ser utilizada. Ela possui erro para quantidades pares
    % de elementos na população.
%     if (size(PFront,1) > Xpop)
%         [Parent, JxParent] = selecao_mode(PSet, PFront, Xpop);
%     end
    
    %% Plotando os gráficos de análise de convergência
    aux1 = size(PFront);
    [l_x1,~] = size(MODEDat.X1);
    
    %     if (n == 1)
    %         mse_worst = max(arc_JxParent(:,1));
    %         mse_worst = 1.5*mse_worst(1,1);
    %         corr_worst = 1.5*max(arc_JxParent(:,3));
    %         %corr_worst = max(arc_f(:,3));
    %         %corr_worst = 1.5*corr_worst(1,1);
    %     end
    for i_norm = 1:MODEDat.NOBJ
        if (n == 1)
            a(i_norm) = min(PFront(:,i_norm));
            b(i_norm) = max(PFront(:,i_norm));
        end
        
        %PFront_norm(:,i_norm) = (PFront(:,i_norm) - a(i_norm)) / ( b(i_norm) - a(i_norm));
    end
    %%Calculando o hipervolume a cada iteração
    if (n == 1)
        length_x = length(MODEDat.X1);
        range_y = (max(MODEDat.Y1) -  min(MODEDat.Y1)).^2;
        mse_worst = max(JxParent(:,1));
    end
    %hyper(n) = hyper_norm (PFront, range_y, length_x);
    %metrica(n) = metrica_kernel (PFront, range_y, length_x, MODEDat.XPOP);
    %metrica(n) = nadir_ideal (PFront, max(MODEDat.Y1), length_x);
    %hyper(n) = Hypervolume_MEX(PFront, [0, 0, 0]);
    %PFront_norm = [];
    hyper(n) = 1; %desativado
    
    
    if(aux1(1,1)>=2)
        dist(n) = spacing(PFront);
    else
        dist(n) = 2;
    end
    sols(n) = aux1(1,1);
    mse_c(n) = min(PFront(:, 1));
    sv_c(n) = min(PFront(:, 2));
    %r_c(n) = min(PFront(:, 3));
    
    %Plot para debug
    
%    teste = figure(1);
%     if n == 1
%         plot (PFront(:,1), PFront(:,2), 'r*');
%     else
%         
%         plot (PF_aux(:,1), PF_aux(:,2), 'bo');
%         hold on
%         plot (PFront(:,1), PFront(:,2), 'r*');
%     end
%     close (teste)
%     
%      PF_aux = PFront;
%     if n == 1
%         diff(n) = 0;
%     else
%          diff(n) = hyper(n)-hyper(n-1); %+ diff(n-1);
%     end
    %pause
    
    
    %Variáveis usadas plotar os gráficos do comportamento dos mutantes.
    mutant_1(n) = set_parameter.rand_1;
    mutant_2(n) = set_parameter.rand_2;
    mutant_3(n) = set_parameter.current_best_1;
    mutant_4(n) = set_parameter.rand_best_1;
    
    porcentagem = (n+(MODEDat.amostra_atual-1)*Generaciones)/(MODEDat.amostra*Generaciones);
    waitbar(porcentagem,MODEDat.waitbar,sprintf('%2.1f%% along...',100*porcentagem));
    
end

OUT.PSet            = PSet;     % Pareto Set
OUT.PFront          = PFront;   % Pareto Front
%OUT.Param          = MODEDat;  % MODE Parameters
OUT.metricas = [dist' sols' hyper'];
%OUT.metricas_c = [mse_c' sv_c' r_c'];
OUT.plot_mutant = [mutant_1' mutant_2' mutant_3' mutant_4'];
%save('F_t.mat','F_t','Cr_t' );
end
