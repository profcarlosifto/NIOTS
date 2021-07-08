function [y, ys, indb] = best_detection_pso (S, x, fx, arc_x, arc_f, indb,k)
% Função que faz a identificaçãod o melhor individual e melhor globla da
% população utilizando a técnica de Ordering Lexografic
% Entrada:
% S         -> tamanho da população
% x         -> população atual
% fx        -> matriz dos objetivos da população atual
% arc_x     -> conjunto das partículas não dominantes
% arc_f     -> objetivos das partículas não dominantes
% indb      -> estrutura que armazena o individual best.
% k         -> iteração atual do pso

% Saída

% y         -> matriz dos melhores individuais
% ys        -> melhor global
% indb      -> estrutura dos melhores individuais para posterior
%              atualização

n_obj = size(arc_f, 2);
c_fx = randi(n_obj);            % Variável que define qual função objetivo será avalida como best da iteração corrente
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
                                           % Escolhe um dos objetivos para o mínimo.
        [r_ind, ~, ~] = find(min(min(indb(i).fx(:,c_fx)))==indb(i).fx(:,c_fx));
        y(i,:) = indb(i).x(r_ind(1,1),:);         % Para mudar de randômico para mínimo tem que alterar a variável desta linha
    end
end

%% global detection
    ind_gbest = find(arc_f(:,c_fx)== min(arc_f(:, c_fx)));
    ys = arc_x(ind_gbest, :);  %gbest
    
    
