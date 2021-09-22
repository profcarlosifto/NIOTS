function [x, v] = upadate_pso_particles_rbf(x, y,ys, c1, c2, w, v, x_max, x_min, S, N, max_v, dir_ar, rand_type, xe_max)
% Função que faz atualização das partículas de acordo do com o kernel RBF.
% Neste cado ele trata as duas variáveis da mesma maneira, ou seja, elas
% têm o mesmo espaço de busca e a atualização é realizada de maneira
% homgênea.
% A variável de retorno x são as partículas nas linhas e a dimensão nas
% colunas. Nesta função são C e gama respectivamente.
max_ve = 0.1*xe_max;
%xe_max = 4;
xe_min = 0.05; %xe_min = 0.000001;
for i=1:S          %foi trocada a ordem entre N e S!! Caso não funcionar voltar para versão anterior neste ponto
    for j = 1:N
        
        if (rand_type == 1)
            r1 = rand;
            r2 = rand;
            
        elseif(rand_type == 2)
            r1 = .5 + .2*randn(1);
            r2 = .5 + .2*randn(1);
            
        elseif(rand_type == 3)
            r1 = 0.01*tan(pi*(rand-0.5));
            r2 = 0.01*tan(pi*(rand-0.5));
        end
        if (j <= 2)
            v(i,j) = w*v(i,j) + dir_ar*(c1*r1*(y(i,j)-x(i,j)) + c2*r2*(ys(j) - x(i,j)));
            if abs(v(i,j)) > max_v
                if v(i,j) > 0
                    v(i,j) = max_v;
                else
                    v(i,j) = -max_v;
                end
            end
            x(i,j) = x(i,j) + v(i,j);
            if x(i,j) > x_max
                x(i,j) = x_max;
            elseif x(i,j) < x_min
                x(i,j) = x_min;
            end
        else 
            v(i,j) = w*v(i,j) + dir_ar*(c1*r1*(y(i,j)-x(i,j)) + c2*r2*(ys(j) - x(i,j)));
            if abs(v(i,j)) > max_ve
                if v(i,j) > 0
                    v(i,j) = max_ve;
                else
                    v(i,j) = -max_ve;
                end
            end
            x(i,j) = x(i,j) + v(i,j);
            if x(i,j) > xe_max
                x(i,j) = xe_max;
            elseif x(i,j) < xe_min
                x(i,j) = xe_min;
            end
        end
    end
end
end