function niots (arquivo)
%Arquivo que chama a versão do NIOTS
% Fazer uma função que seja necessário entrar apenas com o arquivo de
% configuração da do experimento o qual contém todas as informações
% necessárias para que o mesmo seja executado.

[config, config_cod] = ler_config_file(arquivo);

if (config_cod.algorithm == 1)
    MOPSO_cross(config_cod.type, config_cod.diversity, config.samples, config.iterations, config.train_data_x, config.train_data_y, config.cross_folds, config.population, config.inertial_initial, config.inertial_final, config.coef_cognitive, config.coef_social, config.max_speed, config.search_min, config.search_max, config.AR_min, config.AR_max, config.path_file, config.path, config_cod.random, config.validation_x, config.validation_y, config_cod.kernel, config.epsilon);
else
    MODE_S(config_cod.type, config_cod.diversity, config.samples, config.iterations, config.train_data_x, config.train_data_y, config.cross_folds, config.population, config.factor, config.crossover, config.search_min, config.search_max, config.path_file, config_cod.random, config.validation_x, config.validation_y, config_cod.kernel, config.AR_min, config.AR_max, config_cod.algorithm, config.epsilon)
end
end