function kernel = kernel_cos(x, y)
% Função que gera a gram matrix do kernel arc cosseno.
% x      -> Vetor característica  1 
% y      -> Vetor característica  2
% kernel -> Resultado do produto interno no espaço das características 
%           usando o kernel arc cosseno.

dot_x = x*y';
norm_x = norm(x)*norm(y);
teta = acos(dot_x/norm_x);
kernel = 1/pi*norm_x*(sin(teta)+(pi-teta)*(dot_x)/norm_x);
end