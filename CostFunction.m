function J=CostFunction(X,Dat)
%% CostFunction.m 
% J  [OUT] : The objective Vector. J is a matrix with as many rows as
%            trial vectors in X and as many columns as objectives.
% X   [IN] : Decision Variable Vector. X is a matrix with as many rows as
%            trial vector and as many columns as decision variables.
% Dat [IN] : Parameters defined in NNCparam.m
% 

Xpop = size(X,1);
%epsilon = Dat.epsilon; % arrumar isso depois, parei aqui 25/11/2016
%J = zeros(Xpop, Dat.NOBJ);
J1 = zeros(Xpop, 1);
J2 = zeros(Xpop, 1);
J3 = zeros(Xpop, 1);
%J3 = zeros(Xpop, 1);
%X_epsilon=X(:,3);           %Necessário para o parfor
for i = 1:Xpop           %Coloca o parfor aqui para paralelizar o MODE.
    if ~(isempty(Dat.conj)) 
            m = size(Dat.conj,1);
            yc=size(Dat.Y1, 2);
            Xd = [Dat.X1, Dat.Y1];
            l = size(Xd, 2);
            Dat.conj = cross_set (Xd, yc, m);
            for i1=1:m
                conj_aux = Dat.conj;
                X2 = Xd(Dat.conj(i1,:),1:(l-yc));
                conj_aux(i1,:)=[];
                X1 = Xd(conj_aux,1:(l-yc));
                Y2 = Xd(Dat.conj(i1,:),l);
                Y1 = Xd(conj_aux,l);
                [erro1, sv1, corr1] = fit_svm_lib(X1, Y1, X2, Y2, Dat.tipo_sv, Dat.kernel, X(i,:));
                J1(i,1) = J1(i,1) + erro1;
                J2(i,1) = J2(i,1) + sv1;
                J3(i,1) = J3(i,1) + corr1;
                %[erro, sv, corr] = fit_svm_lib_cross(X1, y1, conj, tipo_sv, kernel, x(i,:)); %x(1) -> C e x(2) -> sigma
            end
            J1(i,1) = J1(i,1)/m;
            J2(i,1) = J2(i,1)/m;
            J3(i,1) = J3(i,1)/m;
        
        %[J1(i,1), J2(i,1), J3(i,1)] = fit_svm_lib_cross(Dat.X1, Dat.Y1, Dat.conj, X_epsilon(i,:), Dat.tipo_sv, Dat.kernel, X(i,:));
        
    else
        [J1(i,1), J2(i,1), J3(i,1)] = fit_svm_lib(Dat.X1, Dat.Y1,Dat.X2, Dat.Y2, Dat.tipo_sv, Dat.kernel, X(i,:));        
    end
end
%J = [J1 J2 J3]; % Foi colocado um zero para forçar a utilizar somente duas funções objetivos.
J = [J1 J2];

