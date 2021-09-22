clear all
close all
clc
load('tempo.mat');
load('svm_renato_2.mat');
%[x, y] = ler_dados('renato_2_p.txt');
aux_teste = svm;
x_treino = tempo_treino(:, 2);
y_treino = svm(tempo_treino(:,1),5);

x_test = tempo_test(:, 2);
y_test_r = svm(tempo_test(:,1),5);
%plot(x_test,y_test_r, 'r*')

xc_treino = svm(tempo_treino(:,1),2:4);
xc_test = svm(tempo_test(:,1),2:4);

for i=1:12
    i_str = num2str(i);
    nome = strcat('SVM_1_',i_str,'.txt');
    maquina = ler_saida_st (nome); %11, 13
    yt = prediction_s (maquina, xc_test);
    yf_treino = prediction_s (maquina, xc_treino);
    
    h(i)=figure(i);
    subplot(2,2,1)
    plot(x_test, y_test_r, 'ro', x_test, yt,'b*')
    legend('Função Original', 'SVR')
    title('Test Set')    
   
    resi = yt-y_test_r;
    subplot(2,2,3)
    plot(x_test, resi, 'r*')
    err_p = mean(resi.^2);
         
    
    subplot(2,2,2)
    plot(x_treino, y_treino, 'ro', x_treino, yf_treino,'b*')
    legend('Função Original', 'SVR')
    title ('Train Set')
    
    resi = yf_treino-y_treino;
    subplot(2,2,4)
    plot(x_treino, resi, 'r*')
    annotation('textbox', [0.1 0.5 0.5 0.05], 'String', {[strcat('#SV = ', num2str(maquina.card_sv)),'  ', strcat('MSE  = ', num2str(err_p))]}, 'LineStyle', 'none')
    saveas(h(i),strcat('grafico_',i_str),'jpg');    
end
