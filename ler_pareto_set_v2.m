function pareto = ler_pareto_set_v2 (file_path)
% Função que faz a leitura do arquivo relatório que possui o conjunto e a
% fronteira de pareto.
% A saída é uma struct que possui todos os dados da fronteira de
% Pareto assim como os demais dados relevantes.
% Entradas:
% file_path -> nome e caminho do arquivo fronteira de pareto.
% index     -> indice da fronteira de pareto, para auxliar no processo de
%              concatenar dados



file = fopen (file_path, 'r');
index = 0;

if (file == -1)
    pareto = [];
    display(["Impossível abrir o arquivo: " file_path])
    return
else
    tline = fgetl(file);
    i = 1;
    while ischar(tline)
        tline_dados = strsplit(tline);
        if strcmp(tline_dados{1}, 'Machine:')
            tipo_svm = tline_dados{2};
            
        elseif strcmp(tline_dados{1}, 'Kernel:')
            kernel = tline_dados{2};
            
        elseif strcmp(tline_dados{1}, 'Sample') 
            tline = fgetl(file);
            tline = fgetl(file);               
            tline_dados = strsplit(tline);
            
            if strcmp(kernel, 'RBF') && strcmp(tipo_svm, 'Regression')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'RBF';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).epsilon = str2double(tline_dados{5});
                    pareto(i).mse = str2double(tline_dados{6});
                    pareto(i).sv = str2double(tline_dados{7});
                    
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
            elseif strcmp(kernel, 'Arcosine') && strcmp(tipo_svm, 'Regression')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Arcosine';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = 0;
                    pareto(i).epsilon = str2double(tline_dados{4});
                    pareto(i).mse = str2double(tline_dados{5});
                    pareto(i).sv = str2double(tline_dados{6});
                    
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
            elseif strcmp(kernel, 'Cauchy') && strcmp(tipo_svm, 'Regression')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Cauchy';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).epsilon = str2double(tline_dados{5});
                    pareto(i).mse = str2double(tline_dados{6});
                    pareto(i).sv = str2double(tline_dados{7});
                    
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end

            elseif strcmp(kernel, 'Polynomial') && strcmp(tipo_svm, 'Regression')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Poly';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).epsilon = str2double(tline_dados{5});
                    pareto(i).mse = str2double(tline_dados{6});
                    pareto(i).sv = str2double(tline_dados{7});
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
            elseif strcmp(kernel, 'Hermite') && strcmp(tipo_svm, 'Regression')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Hermite';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).epsilon = str2double(tline_dados{5});
                    pareto(i).mse = str2double(tline_dados{6});
                    pareto(i).sv = str2double(tline_dados{7});
                    pareto(i).r = 1;
                    
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end            
            elseif strcmp(kernel, 'RBF') && strcmp(tipo_svm, 'Classification')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'RBF';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).mse = str2double(tline_dados{5});
                    pareto(i).sv = str2double(tline_dados{6});
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
                
            elseif strcmp(kernel, 'Polynomial') && strcmp(tipo_svm, 'Classification')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Poly';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).mse = str2double(tline_dados{5});
                    pareto(i).sv = str2double(tline_dados{6});
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
                
            elseif strcmp(kernel, 'Cauchy') && strcmp(tipo_svm, 'Classification')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Cauchy';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).mse = str2double(tline_dados{5});
                    pareto(i).sv = str2double(tline_dados{6});
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
            elseif strcmp(kernel, 'Arcosine') && strcmp(tipo_svm, 'Classification')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Arcosine';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = 1;
                    pareto(i).mse = str2double(tline_dados{4});
                    pareto(i).sv = str2double(tline_dados{5});
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
            elseif strcmp(tipo_svm, 'Classification')
                while (length(tline_dados)>1)&& ischar(tline) 
                    pareto(i).index = index + str2double(tline_dados{2});
                    pareto(i).kernel = 'Grid';
                    pareto(i).c = str2double(tline_dados{3});
                    pareto(i).gamma = str2double(tline_dados{4});
                    pareto(i).mse = str2double(tline_dados{5});
                    pareto(i).sv = str2double(tline_dados{6});                    
                    pareto(i).r = 1;
                    i=i+1;
                    tline = fgetl(file);
                    if isnumeric(tline)
                        break;
                    end
                    tline_dados = strsplit(tline);
                end
            end
        end
        tline = fgetl(file);
    end
end
fclose(file);
end
