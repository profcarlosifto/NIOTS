function gridsearch(x,y, x_v, y_v, ci, cf, step_c, gi, gf,  step_gama, eps, nome_arq, tipo_sv, kernel)
% A função grid search faz uma busca de força bruta, combinando todas as
% possibilidades do vetor C com todas as possibilidades do vetor gama.
% A função nesta versão trabalha apenas com a função RBF e aproximadores de
% função de uma única saída, assim como o incremento em C e gama são fixos
% Inputs:
% x, y estruturas com dados de treinamento e validação
% ci, cf valores inicial e final do parâmetro de regularização C
% gi, gf valores inicial e final para o parâmetro gama.

report.step_gama = step_gama;
report.step_c = step_c;
report.c_min = ci;
report.c_max = cf;
report.gama_min = gi;
report.gama_max = gf;
report.eps = eps;
report.kernel = kernel;
report.algoritmo = tipo_sv;
report.tipo_sv = tipo_sv;
[x, min_x, max_x] = normaliza(x);
[x_v, min_x_v, max_x_v] = normaliza(x_v);
C = ci:step_c:cf;
gama = gi:step_gama:gf;

%% Definindo o tipo de kernel e SVM na strring options
if tipo_sv == 7
    C_aux = exp(C);
    if kernel == 1
        options = ['-s 3 -t 2 -p ', eps, ' -h 0 ', '-g '];
        gama_aux = exp(gama);
    elseif kernel == 2
        options = ['-s 3 -t 1 -p ', eps, ' -h 0 ', '-g 1 -r 1 -d '];        
        gama_aux = gama;
    else
        disp('Kernel não implmentado!')
    end
        
elseif tipo_sv == 8
    C_aux = exp(C);
    if kernel == 1
        options = ['-s 0 -t 2 -h 0 ', '-g '];
        gama_aux = exp(gama);
    elseif kernel == 2
        options = ['-s 0 -t 1 -h 0 ', '-g 1 -r 1 -d '];        
        gama_aux = gama;
    else
        disp('Kernel não implmentado!')
    end
end

m = length (C);
n = length (gama);
%eps = num2str(0.01);
k = 1;
sol = zeros(m*n, 4);
for i = 1:m
    for j = 1:n
        C1 = num2str(C_aux(i));
        kpar1 = num2str(gama_aux(j));
        options_aux = [options, kpar1, ' -c ', C1];
        model = svmtrain(y, x, options_aux);
        if tipo_sv == 7
            [~, accuracy, ~] = svmpredict(y_v,x_v, model);            
        else
            [~, accuracy, ~] = svmpredict(y_v,x_v, model);            
        end
        sol(k,:) = [C(i) gama(j) accuracy(2) model.totalSV];
        k = k+1;
        graf.matriz_accuracy(i, j) =  accuracy(2);
        graf.matriz_sv(i, j) =  model.totalSV;
        options_aux = [];
    end
end
graf.C = C;
graf.gamma = gama;

[arc_x, arc_f, rank, ~] = truncate(sol(:,1:2),sol(:,3:4), 20);
ind_nd = rank == 1;
arc_x = arc_x(ind_nd,:);
arc_f = arc_f(ind_nd,:);
if (tipo_sv == 7)
    li = size(arc_x, 1);
    aux_eps = str2num(eps)*ones(li,1);
    report.result_amostra_x = [arc_x aux_eps];
    report.result_amostra_f = arc_f;
else
    report.result_amostra_x = arc_x;
    report.result_amostra_f = arc_f;
end
%% Gravando no arquivo de saída os parâmetros do algoritmo empregado
report.nome_relat = strcat(nome_arq.path, nome_arq.nome);

gera_relatorio(report)


save(strcat(nome_arq.path,'graficos'),'graf');
h1=figure(1);
mesh(graf.gamma, graf.C, graf.matriz_sv)
hold on
plot3(report.result_amostra_x(:,2),report.result_amostra_x(:,1),report.result_amostra_f(:,2), '*r')
ylabel('Regularization Parameter - (exp(C))')
xlabel('Kernel Parameter')
zlabel('Support Vectors')
h2 = figure(2);
mesh(graf.gamma, graf.C, graf.matriz_accuracy)
hold on
plot3(report.result_amostra_x(:,2),report.result_amostra_x(:,1),report.result_amostra_f(:,1), '*r')
ylabel('Regularization Parameter - (exp(C))')
xlabel('Kernel Parameter')
zlabel('Mean Squared Error')
saveas(h1,strcat(nome_arq.path,'support_vectors'),'epsc')
saveas(h2,strcat(nome_arq.path,'MSE'),'epsc')
if (tipo_sv == 7)
    escreve_saida(report.result_amostra_x, report.result_amostra_f, x, y, nome_arq.path, 1, min_x, max_x, kernel)
elseif (tipo_sv == 8)
    escreve_saida_classify (report.result_amostra_x, report.result_amostra_f, x, y, nome_arq.path, 1, min_x, max_x, kernel)
end
end

