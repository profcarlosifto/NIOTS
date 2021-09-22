function grafico_multi(model, x,y)
%Função faz os gráficos das funções multi-targets
% x -> Características da predição
% y -> Valores preditos pela função aproximadora
[l c] = size(y);
nfields = length(fieldnames(x));
figure(1);
if (nfields == 1)   %Neste caso plotar gráficos de predição apenas    
    for i = 1:c
        subplot(1,c,i)
        plot(x.x,y(:, i), 'b*');            %Valores preditos pela função aproximadora
        str_t = sprintf('Saida y_%i',i);
        title(str_t);
        xlabel('Features points')
        ylabel('Fitted points')
    end    
else
    for i = 1:c
        subplot(2,c,i)
        hold on
        plot(x.x,y(:, i), 'b*', x.x,x.y(:, i), 'ro');        %Valores preditos pela função aproximadora        
        legend('SVR - h(x)', 'Function - f(x)')
        str_t = sprintf('Saida y_%i',i);
        title(str_t);        
        xlabel('Features points')
        ylabel('Fitted points')        
    end      
    res = y-x.y;
    MSE = mean(res.^2);
    for i = 1:c
        subplot(2,c,i+c)
        plot(x.x,res(:,i), 'r*');
        str_t = sprintf('Residual y_%i',i);
        xlabel('Fitted Value');
        ylabel('Residuals')
        title(str_t);
        hold on
        %annotation('textbox', [(0.1+(i/c)-(1/c)) 0.47 0.5 0.05], 'String', {[strcat('#SV = ', num2str(model(2).card_sv(i))),'  ', strcat('MSE_{train}  = ', num2str(MSE(1,i)))]}, 'LineStyle', 'none')
    end
    annotation('textbox', [0.1 0.01 0.5 0.05], 'String', strcat('MSE_{train}  = ', num2str(MSE)), 'LineStyle', 'none')
    annotation('textbox', [0.4 0.01 0.5 0.05], 'String', {[strcat('#SV_2 = ', num2str(model(2).card_sv)), '  ', strcat('#SV_1 = ', num2str(model(1).card_sv))]}, 'LineStyle', 'none')
end
end