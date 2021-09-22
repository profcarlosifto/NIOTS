function [x,v] = upadate_pso_particles_deep(x, y,ys, c1, c2, w, v, w_d, x_max, x_min, d_min, d_max, max_ep, S, N, max_v, max_v_d, dir_ar, rand_type)
% Função que faz atualização das partículas de acordo do com o kernel deep (RBF e polinomial).
% Neste caso ele trata as duas variáveis de maneira independente. 
% A variável 

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
        if (j==3) %Parte do PSO  que trata o grau do polinômio o máximo e mínimo desta variável não foi implementada no GUI
            v(i,j) = w_d*v(i,j) + dir_ar*(c1*r1*(y(i,j)-x(i,j)) + c2*r2*(ys(j) - x(i,j)));
            v(i,j) = floor(v(i,j));
            if abs(v(i,j)) > max_v_d
                if v(i,j) > 0
                    v(i,j) = max_v_d;
                else
                    v(i,j) = -max_v_d;
                end
            end
            x(i,j) = x(i,j) + v(i,j);
            
            if x(i,j) > d_max       %Verificando os limites do espaço de busca da variável grau
                x(i,j) = d_max;
            elseif x(i,j) < d_min
                x(i,j) = d_min;
            end
            
        elseif (j <=2 ) % Parte do PSO que trata o C e o epsilon. O máximo e mínimo do épsilon não foi tratado no GUI
            v(i,j) = w*v(i,j) + dir_ar*(c1*r1*(y(i,j)-x(i,j)) + c2*r2*(ys(j) - x(i,j)));
            
            if abs(v(i,j)) > max_v
                if v(i,j) > 0
                    v(i,j) = max_v;
                else
                    v(i,j) = -max_v;
                end
            end
            
            x(i,j) = x(i,j) + v(i,j);
            if x(i,j) > x_max       %Verificando os limites dos espaço de busca da variável C.
                x(i,j) = x_max;
            elseif x(i,j) < x_min
                x(i,j) = x_min;
            end
            
        elseif (j==4)
            max_ve = .1*max_ep;
            if abs(v(i,j)) > max_ve
                if v(i,j) > 0
                    v(i,j) = max_ve;
                else
                    v(i,j) = -max_ve;
                end
            end   
            x(i,j) = x(i,j) + v(i,j);
            
            if x(i,j) > max_ep
                x(i,j) = max_ep;
            elseif x(i,j) < 0.00001     %Ajusta o valor do epsilon de maneira diferente do C e d.
                x(i,j) = 0.00001+0.3*rand;
            end                                
            
 
        end       
    end
end
end