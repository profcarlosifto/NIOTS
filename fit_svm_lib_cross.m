function [erro, sv, corr] = fit_svm_lib_cross(X1, y1, conj, tipo_sv, varargin)

%X1, y1, conj, epsilon,tipo_sv, kernel, x_obl(i,:)
% Função que realiza o crossover
kernel = varargin{1};
x = varargin{2};
[~, yc]=size(y1);
X = [X1, y1];
[~, l] = size(X);
erro = 0;
sv = 0;
corr = 0;
m = size(conj,1);
for i1=1:m
    conj_aux = conj;
    x2cv = X(conj(i1,:),1:(l-yc));
    conj_aux(i1,:)=[];
    x1 = X(conj_aux,1:(l-yc));
    y2cv = X(conj(i1,:),l);
    y_c = X(conj_aux,l);
    [erro1, sv1, corr1] = fit_svm_lib(x1, y_c, x2cv, y2cv, tipo_sv, kernel, x(1,:));
    erro = erro + erro1;
    sv = sv + sv1;
    corr = corr + corr1;
    %[erro, sv, corr] = fit_svm_lib_cross(X1, y1, conj, tipo_sv, kernel, x(i,:)); %x(1) -> C e x(2) -> sigma
end
erro = erro/m;
sv = sv/m;
corr = corr/m;


end