function graf_opt_s (nome)   
metricas = dlmread(nome);
[amostras, ite] = size(metricas);
t1 = 1:ite;
j=1;
spacing_est = zeros(amostras/2,ite);
card_est = zeros(amostras/2,ite);
for i=1:2:amostras
    hold on
    h(1)= figure(1);
    plot(t1, metricas(i,:))
    title('Metrica Spacing')
    xlabel('Iteracoes', 'FontSize',12)
    ylabel('Spacing','FontSize',12)
    spacing_est(j,:) = metricas(i,:);
    
    hold on
    h(2)=figure(2);
    plot(t1,metricas(i+1,:))
    title('Cardinalidade do conjunto Non-dominate')
    xlabel('Iteracoes', 'FontSize',12)
    ylabel('Solucoes','FontSize',12)
    card_est(j,:) = metricas(i+1,:);
    j=j+1;
end
media_spacing = zeros(1,ite);
media_card = zeros(1,ite);
mediana_spacing = zeros(1,ite);
mediana_card = zeros(1,ite);
desvio_spacing = zeros(1,ite);
desvio_card = zeros(1,ite);
for i=1:ite
        media_spacing(1,i) = mean(spacing_est(:,i));
        media_card(1,i) = mean(card_est(:,i));
        mediana_spacing(1,i) = median(spacing_est(:,i));
        mediana_card(1,i) = median(card_est(:,i));
        desvio_spacing(1,i) = std(spacing_est(:,i));
        desvio_card(1,i) = std(card_est(:,i));
end
hold on
h(1)=figure(1);
plot(t1, media_spacing,'r')
title('Metrica Spacing')
xlabel('Iteracoes', 'FontSize',12)
ylabel('Spacing','FontSize',12)

hold on
h(2)=figure(2);
plot(t1,media_card,'r')
title('Cardinalidade do conjunto Non-dominate')
xlabel('Iteracoes', 'FontSize',12)
ylabel('Solucoes','FontSize',12)

h(3)=figure(4);
plot(t1,mediana_spacing,'r')
title('Mediana Spacing')
xlabel('Iteracoes', 'FontSize',12)
ylabel('Solucoes','FontSize',12)

h(4)=figure(5);
plot(t1,mediana_card,'r')
title('Mediana Conjunto Non-dominate')
xlabel('Iteracoes', 'FontSize',12)
ylabel('Solucoes','FontSize',12)

h(5)=figure(6);
plot(t1,desvio_card,'r')
title('Desvio Padrao conjunto Non-dominate')
xlabel('Iteracoes', 'FontSize',12)
ylabel('Solucoes','FontSize',12)

h(6)=figure(7);
plot(t1,desvio_spacing,'r')
title('Desvio Padrao Spacing')
xlabel('Iteracoes', 'FontSize',12)
ylabel('Solucoes','FontSize',12)

saveas(h(1),strcat(nome,'Media Metrica Spacing'),'jpg')
saveas(h(2),strcat(nome,'Media Cardinalidade do conjunto Non-dominate'),'jpg')
saveas(h(3), strcat(nome,'Mediana Metrica Spacing'),'jpg')
saveas(h(4), strcat(nome,'Mediana Cardinalidade do conjunto Non-dominate'),'jpg')
saveas(h(5), strcat(nome,'Desvio Metrica Spacing'),'jpg')
saveas(h(6), strcat(nome,'Desvio Cardinalidade do conjunto Non-dominate'),'jpg')
end

 %{
    %Plota o gráfico da fronteira de pareto
    hold on
    h(3)=figure(3);
    plot3(pareto(:,1), pareto(:,2), pareto(:,3),'r*')
    title('Relação SV e Erro')
    xlabel('Erro', 'FontSize',12)
    ylabel('Vetores de Suporte','FontSize',12)
    zlabel('Correlação','FontSize',12)
    grid on;
    saveas(h(3),strcat(varargin{12},'Conjunto Non-dominate ',int2str(i)),'jpg')
    %}