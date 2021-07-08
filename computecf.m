function cf_out = computecf(Fit)
%CROWDING Computes crowding factor values of solutions
% ver p. 185 de DEBet al.: A FAST AND ELITIST MULTIOBJECTIVE GA: NSGA-II

% ARGUMENTOS
% Fit: fun��o objetivo dos membros de uma FRONTEIRA
% cf: valor da dist�ncia de multid�o

[n, f] = size(Fit);
Fit_input = Fit; % guarda para comparar no final
fit = zeros(n,f); % inicializa fitness normalizado
cf = zeros(n,1); % initialize crowding distance values


for i=1:f % normaliza os objetivos
    fit(:,i) = norm01(Fit(:,i)); 
end

% ---- M�todo do NSGA-II - Crowding Distance Factor
for i=1:f
    % Ordena as solu��es conforme o fitness
    [~, idx] = sort(fit(:,i),1,'ascend');
    fit = fit(idx,:);
    cf = cf(idx,1);
    Fit = Fit(idx,:);
    
    % - C�lculo do coeficiente CD
    % garante que valores extremos de cada fobj tenham valor m�ximo
    cf(1,1) = Inf; cf(n,1) = Inf;     
    % calcula o CD para o resto
    for k=2:n-1
        cf(k,1) = cf(k,1) + (fit(k+1,i)-fit(k-1,i))/(fit(n,i)-fit(1,i));
    end
    % - Fim do C�lculo do coeficiente CD
end

% reordena as dist�ncias para ordem de entrada
cf_out = cf;
for i=1:n
    k = ismember(Fit_input,Fit(i,:),'rows');
    cf_out(k) = cf(i);
end


    % fun��o auxiliar para normalizar entre [0,1]
    function Y = norm01(y)
        min_y = min(y);
        max_y = max(y);
        
        Y = (y - min_y) / ( max_y - min_y );
        
    end

end