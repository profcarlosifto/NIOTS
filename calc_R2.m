function R2 = calc_R2(real,est)
% calcula o R2

SSE = sum((real - est).^2); 

avg_real = mean(real);

sum2 = sum((real - avg_real).^2);

R2 = 1 - SSE / sum2;

end
