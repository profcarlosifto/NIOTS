close all
gam = 0.01; 
x0 = 0;
n = 100;
u = rand(1,n);
for i = 1:n
    r(1,i) = gam*tan(pi*(u(1,i)-0.5))+x0;
end
plot(u,r,'r*')