% Estudo e exemplo sobre LS-SVM

X = linspace(-1,1,50);
X=X';
Y = (15*(X.^2-1).^2.*X.^4).*exp(-X)+normrnd(0,0.1,length(X),1);
type = 'function estimation';
[gam,sig2] = tunelssvm({X,Y,type,[],[],'RBF_kernel'},'simplex','leaveoneoutlssvm',{'mse'});
[alpha,b] = trainlssvm({X,Y,type,gam,sig2,'RBF_kernel','original'});
plotlssvm({X,Y,type,gam,sig2,'RBF_kernel'},{alpha,b});