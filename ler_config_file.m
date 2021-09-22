function [config, config_cod] = ler_config_file(nome)
% Função que lê o arquivo de configuração do projeto a ser realizado
% A entrada consiste no arquivo de configuração do projeto com um formato
% específico.

arquivo = fopen(nome, 'r');
tline = fgetl(arquivo);
word = strsplit(tline);
if ~(strcmp(word{1},'Machine'))|| (arquivo < 0)
    disp('Cannot read file or wrong format\n')
    return
end
tline = fgetl(arquivo);         % Incrementa a linha do arquivo
while ischar(tline)
    word = strsplit(tline);        % Divide a linha em strings
    if size(word, 2) == 1
        
    elseif strcmp(word{1}, 'Machine') || strcmp(word{1}, 'General') || strcmp(word{1}, 'Algorithms') || strcmp(word{1}, 'Files')
        
    elseif strcmp(word{1}, 'SVM') && strcmp(word{2}, 'type:')
        config.type = word{3};
        
    elseif strcmp(word{1}, 'Solver:')
        config.solver = word{2};
        
    elseif  strcmp(word{1}, 'Bio-inspired')
        config.algorithm = word{3};
        if strcmp(word{3}, 'MOPSO')
            config_cod.algorithm = 1;
            
        elseif strcmp(word{3}, 'MODE')
            config_cod.algorithm = 2;
            
        elseif strcmp(word{3}, 'spMODE')
            config_cod.algorithm = 3;
        end
        
    elseif strcmp(word{1}, 'Diversity')
        config.diversity = word{3};
        if strcmp(word{3}, 'Classic')
            config_cod.diversity = 1;
            config.AR_min = 0;          %Ignora os parâmetros do atratativo respulsivo
            config.AR_max = 0;
            
        elseif strcmp(word{3}, 'OBL')
            config_cod.diversity = 2;
            config.AR_min = 0;
            config.AR_max = 0;            
            
        elseif strcmp(word{3}, 'AR')
            config_cod.diversity = 3;
        end
        
    elseif strcmp(word{1}, 'Kernel')
        config.kernel = word{3};
        if strcmp(word{3}, 'RBF')
            config_cod.kernel = 1;
            
        elseif strcmp(word{3}, 'Polynomial')
            config_cod.kernel = 2;
            
        elseif strcmp(word{3}, 'MKL')
            config_cod.kernel = 3;
        end        
        
    elseif strcmp(word{1}, 'Samples:')
        config.samples = str2double(word{2});
        
    elseif strcmp(word{1}, 'Iterations:')
        config.iterations = str2double(word{2});
        
    elseif strcmp(word{1}, 'Cross')
        if strcmp(word{2}, 'no')
            config.cross_log = word{3};
        else
            config.cross_log = word{3};
            config.cross_folds = str2double (word{5});
        end
        
    elseif strcmp(word{1}, 'Random')
        config.random = word{3};
        if strcmp(word{3}, 'Uniform')
            config_cod.random = 1;
            
        elseif strcmp(word{3}, 'Normal')
            config_cod.random = 2;
            
        elseif strcmp(word{3}, 'Cauchy')
            config_cod.random = 3;
        end        
        
    elseif strcmp(word{1},'Search')
        config.search_max = str2double(word{4});
        config.search_min = str2double(word{6});
        
    elseif strcmp(word{1}, 'Epsilon:')
        config.epsilon = str2double(word{2});
        
    elseif strcmp(word{1}, 'Population')
        config.population = str2double(word{3});
        
    elseif (strcmp(word{1}, 'Initial')||strcmp(word{1}, 'Scale'))
        config.inertial_initial = str2double(word{3});
        config.factor = str2double(word{3});
        
    elseif (strcmp(word{1}, 'Final')||strcmp(word{1}, 'Crossover'))
        config.inertial_final = str2double(word{3});
        config.crossover = str2double(word{3});
    elseif strcmp(word{1}, 'Cognitive')
        config.coef_cognitive = str2double(word{3});
        
    elseif strcmp(word{1}, 'Social')
        config.coef_social = str2double(word{3});
        
    elseif strcmp(word{1}, 'Particle')
        config.max_speed = str2double(word{4});
        
    elseif strcmp(word{1}, 'Path:')
        config.path = word{2};
   
    elseif  size(word, 2) > 3
        if strcmp(word{3}, 'train:')
            config.train_file_name = word{4};
            [config.train_data_x, config.train_data_y] = ler_dados(word{4});
            
        elseif strcmp(word{3}, 'validation:')
            config.validation_file = word{4};
            [config.validation_x, config.validation_y] = ler_dados(word{4});
            
        end
        
    elseif strcmp(word{2}, 'report:')
        config.path_file.nome = word{3};
        config.path_file.path = config.path;
        
    end
    tline = fgetl(arquivo);         % Incrementa a linha do arquivo
    
end
% Codificando a variável type para corresponder a informação do ambiente
% gráfico do NIOTS.

if strcmp(config.solver, 'LibSVM')
    if strcmp(config.type, 'SVM')
        config_cod.type = 1;
        
    elseif strcmp(config.type, 'SVR')
        config_cod.type = 2;
        
    elseif strcmp(config.type, 'MT')
        config_cod.type = 3;
    end
    
elseif strcmp(config.solver, 'LS-SVM')
    if strcmp(config.type, 'SVM')
        config_cod.type = 4;
        
    elseif strcmp(config.type, 'SVR')
        config_cod.type = 5;
        
    elseif strcmp(config.type, 'MT')
        config_cod.type = 6;
    end
else
    config_cod.type = 7;
end


end