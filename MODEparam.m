%% MODEparam
% Generates the required parameters to run the MODE optimization algorithm.

%% Tratando as opções do sistema
% Cross-validation
MODEDat.X1 = X1;                            % Dados do espaço de entrada
MODEDat.Y1 = Y1;                            % Rótulos dos dados de entrada
%Número de amostras
MODEDat.amostra = amostra;
%Parâmetro do waitbar
MODEDat.waitbar = h;
MODEDat.amostra_atual = 1;
%Esse if identifica se a opção cross-validation ativa ou não e define variáveis de acordo com a situação
[~, b]=size(varargin);
if (b == 12)
    MODEDat.conj = cross_set (MODEDat.X1, MODEDat.Y1, k_fold);      %Função que particiona o conjunto de treinamento em k-folder
    MODEDat.kernel = varargin{8};
    MODEDat.div_low = varargin{9};
    MODEDat.div_high = varargin{10};    
    MODEDat.de_type = varargin{11};
    MODEDat.epsilon = varargin{12};
    
else
    MODEDat.X2 = normalize_prediction(varargin{8}, min_x1, max_x1); %Faz a normalização dos dados para validação.
    MODEDat.Y2 = varargin{9};
    conj = [];
    MODEDat.conj = conj;
    MODEDat.kernel = varargin{10};
    MODEDat.div_low = varargin{11};
    MODEDat.div_high = varargin{12};     
    MODEDat.de_type = varargin{13};
    MODEDat.epsilon = varargin{14};
end
% Adição de diversidade (OBL)
MODEDat.mod = mod;
% Tipo de número aleatório
MODEDat.rand_type = varargin{7};
% Limites do AR

%% Variables regarding the optimization problem
[k1, k2]=size(X1);                         % Acho que esta linha é inutil em versões posteriores retirar.
MODEDat.NOBJ = 2;                          % Number of objectives
MODEDat.NRES = 0;                          % Number of constraints
lim_inf = varargin{4};
lim_sup = varargin{5};
if (MODEDat.kernel == 1)                        % Kernel RBF
    MODEDat.NVAR   = 3;                        % Number of decision variables
    MODEDat.FieldD =[lim_inf*ones(MODEDat.NVAR-1,1)...
                    lim_sup*ones(MODEDat.NVAR-1,1); 0.1 MODEDat.epsilon]; % %Epsilon limites 30/11/2018 controlar a quantidade de SV Cascade Tanks
    %MODEDat.FieldD(3, :) = [0.0001 4];            
elseif (MODEDat.kernel == 2)                   % Kernel polinomial
    MODEDat.NVAR   = 3;                        % Number of decision variables
    MODEDat.FieldD =[lim_inf*ones(1,1) lim_sup*ones(1,1); ones(1,1) 20*ones(1,1); 0.0001 MODEDat.epsilon]; % Initialization bounds % Initialization bounds of polynomial degree
    
elseif (MODEDat.kernel == 3)                    % Kernel cos
    MODEDat.NVAR   = 2;     
    MODEDat.FieldD =[lim_inf*ones(1,1) lim_sup*ones(1,1);0.0001 MODEDat.epsilon]; % Initialization bounds

elseif (MODEDat.kernel == 4)                    % Deep kernel
    MODEDat.NVAR   = 4;     
    MODEDat.FieldD =[lim_inf*ones(2,1) lim_sup*ones(2,1);ones(1,1) 20*ones(1,1); 0.0001 MODEDat.epsilon]; % Initialization bounds
    
elseif (MODEDat.kernel == 5)                   % Kernel hermitiano
    MODEDat.NVAR   = 3;                        % Number of decision variables
    MODEDat.FieldD =[lim_inf*ones(1,1) lim_sup*ones(1,1); ones(1,1) 7*ones(1,1); 0.0001 MODEDat.epsilon]; % Initialization bounds % Initialization bounds of polynomial degree
    

end
MODEDat.mop = str2func('CostFunction');    % Cost function
MODEDat.CostProblem= 'SVM';             % Cost function instance


% MODEDat.FieldD =[lim_inf+zeros(MODEDat.NVAR,1)...
%                     lim_sup*ones(MODEDat.NVAR,1)]; % Initialization bounds
MODEDat.Initial=[lim_inf+zeros(MODEDat.NVAR,1)...
                    lim_sup*ones(MODEDat.NVAR,1)]; % Optimization bounds

                        % Partição do conjunto de dados (Cross-Validation)

%% Variables regarding the optimization algorithm
% For guidelines for the parameter tuning see:
%
% Storn, R., Price, K., 1997. Differential evolution: A simple and 
% efficient heuristic for global optimization over continuous spaces. 
% Journal of Global Optimization 11, 341 � 359.
%
% Das, S., Suganthan, P. N., 2010. Differential evolution: A survey of the 
% state-of-the-art. IEEE Transactions on Evolutionary Computation. Vol 15,
% 4 - 31.
%
MODEDat.XPOP = varargin{1};             % Population size
MODEDat.SubXpop= varargin{1};                % SubPopulation size
MODEDat.Esc = varargin{2};              % Scaling factor
MODEDat.Pm= varargin{3};                % Croosover Probability
%MODEDat.Recombination='binomial';     % binomial or lineal                                           
MODEDat.tipo_sv = tipo_sv;              % Determina o tipo da SVM. 1 => Classificador, 2 => Regressão.           
%
if (MODEDat.de_type == 3)
    %% Variables regarding convergence improving (elitism)
    
    MODEDat.CarElite = [];             % Solutions from the Approximated
    % Pareto front in a generation
    % to be merged with the population
    % in the evolution process. If empty,
    % a default value is used.
    %%
    %% Variables regarding spreading (spherical pruning)
    
    MODEDat.Strategy='SphP';           % 'Push' for a basic Dominance-based
    % selection; 'SphP' for the spherical
    % pruning;
    
    MODEDat.Alphas=...                 % Number of Arcs (Strategy='SphP').
        10*MODEDat.NOBJ;               % Number of Arcs (Strategy='SphP').
    
    MODEDat.Norm='physical';           % Norm to be used in Strategy='SphP';
    % It could be 'euclidean','manhattan',
    % 'infinite', 'physical' or 'custom'.
    % When using "custom" the user needs
    % to define his/her own custom
    % function to calculate the norm with
    % the format:
    % IndexesOUT=...
    %   CustomNorm(Front,Set,spMODEDat)
    
    MODEDat.PFrontSize=...             % Maximum Pareto optimal solutions
        10*MODEDat.NOBJ;               % required
    %
    %% Variables regarding pertinency (Global Physical Programming)
    % The following values for each design objective (decision objective +
    % non-decision objective) and constraint shall be defined:
    %
    % Physical Matrix Definition.
    % HD Highly Desirable
    % D  Desirable
    % T  Tolerable
    % U  Untolerable
    % HU Highly Untolerable
    %                          HD  -  D -  T  -  U  -  HU
%     MODEDat.PhyMatrix{1} = [0.0  .01    0.1  1      1.5   2;
%                             0.0   20    30   50     70   100;
%                             0.0   .05   .1   .2     .3    .5];
%     
    
    % The above is based on _Global Physical Programming_ and _Physical
    % Programming_; both are used to state preferences when dealing with
    % several objectives. For more see the following:
    
    % J. Sanchis, M. Mart�nez, X. Blasco, G. Reynoso. Modelling preferences in
    % multi-objective engineering design. Engineering Applications of
    % Artificial Intelligence. Vol. 23, num. 8, pp. 1255 - 1264, 2010.
    %
    % and
    %
    % A. Messac. Physical programming: effective optimization for computational
    % design. AIAA Journal 34 (1), 149 � 158, 1996
    
    MODEDat.PhyIndexMax=...            % Tolerable vector is used as default.
        PhyIndex(MODEDat.PhyMatrix{1}(:,4)',MODEDat);
    % When using the tolerable vector as default, the algorithm will look to
    % approximate a Pareto front approximation with only Tolerable values.
    
    %%
    %% Regarding Constraint Handling (different for objectives bound)
    %
    % Constraints could be defined as additional objectives. For an example
    % please refer to:
    %
    % G. Reynoso-Meza, X. Blasco, J. Sanchis, M. Mart�nez. Multiobjective
    % optimization algorithm for solving constrained single objective problems.
    % Evolutionary Computation (CEC), 2010 IEEE Congress on. 18-23 July 2010
    %
    % In such case, we encourage to define a Pertinency vector (above) or the
    % PhyMatrix cell (also above) accordingly.
    %
    %% Others variables of spMODEII
    MODEDat.PobInitial=[];            % Initial population (if any)
    
    MODEDat.SaveResults='no';         % Write 'yes' if you want to
    % save your results after the
    % optimization process;
    % otherwise, write 'no';
    
    MODEDat.Plotter='no';            % 'yes' if you want to see some
    % a graph at each generation.
    
    MODEDat.SeeProgress='no';        % 'yes' if you want to see some
    % information at each generation.
end
%% Other variables
%
MODEDat.InitialPop=[];                     % Initial population (if any)
MODEDat.MAXGEN =ite_mopso;                 % Generation bound
MODEDat.MAXFUNEVALS = 150*MODEDat.NVAR...  % Function evaluations bound
    *MODEDat.NOBJ;                         
%% Initialization (don't modify)
MODEDat.CounterGEN=0;
MODEDat.CounterFES=0;

