function pareto = ler_pareto_set (file_path, index, sample)
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
         
         elseif strcmp(tline_dados{1}, 'Sample') && (str2double(tline_dados{2})== sample) 
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
                     %pareto(i).r = str2double(tline_dados{8}); 
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
                     %pareto(i).r = str2double(tline_dados{8}); 
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
             end
         end
        tline = fgetl(file);
    end
end

end
