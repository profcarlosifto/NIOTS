function Parent = gera_pop_init(MODEDat)
%função que gera a população inicial da metaheurístia MODE.
%Como a função recebe uma cópia de MODEDat para produzir quantidades
%diferentes das iniciais deve-se alterar essa quantidade na cópia de
%MODEDat.

Parent = zeros(MODEDat.XPOP,MODEDat.NVAR);
m = SLHD (MODEDat.XPOP,MODEDat.NVAR);
for xpop=1:MODEDat.XPOP 
    for nvar=1:MODEDat.NVAR
        
        if (MODEDat.kernel == 3) % If que seleciona o tipo de kernel MKL e trata cada elemento da partícula de forma apropriada
            if (nvar == 2)
                Parent(xpop,nvar) = m(xpop, nvar)*MODEDat.epsilon; % Definindo o epsilon do problema
            else
                Parent(xpop,nvar) = MODEDat.Initial(nvar,1)+(MODEDat.Initial(nvar,2)- MODEDat.Initial(nvar,1))*m(xpop, nvar);
            end
            
            
        elseif (MODEDat.kernel == 1)||(MODEDat.kernel == 6) % If que seleciona o tipo de kernel RBF ou Cauchy ou Sigmoid
           if (nvar == 3)
                Parent(xpop,nvar) = m(xpop, nvar)*MODEDat.epsilon; % Definindo o epsilon do problema
            else
                Parent(xpop,nvar) = MODEDat.Initial(nvar,1)+(MODEDat.Initial(nvar,2)- MODEDat.Initial(nvar,1))*m(xpop, nvar);
            end
            
        elseif (MODEDat.kernel == 2) % If que seleciona o tipo de kernel Polinomial/Hermitiano e trata cada elemento da partícula de forma apropriada
            if (nvar == 1)
                Parent(xpop,nvar) = MODEDat.Initial(nvar,1)+(MODEDat.Initial(nvar,2)- MODEDat.Initial(nvar,1))*m(xpop, nvar);

            elseif (nvar == 2)
                Parent(xpop,nvar) = randi(MODEDat.FieldD(2,2),1,1); % Definindo valores inteiros para o grau do polinômio
                
            else 
                Parent(xpop,nvar) = m(xpop, nvar)*MODEDat.epsilon; % Definindo o epsilon do problema

            end
        elseif (MODEDat.kernel == 4) % If que seleciona o Deep Kernel e trata cada elemento da partícula de forma apropriada
            if (nvar == 1)||(nvar == 2)
                Parent(xpop,nvar) = MODEDat.Initial(nvar,1)+(MODEDat.Initial(nvar,2)- MODEDat.Initial(nvar,1))*m(xpop, nvar);

            elseif (nvar == 3)
                Parent(xpop,nvar) = randi(20,1,1); % Definindo valores inteiros para o grau do polinômio
                
            else 
                Parent(xpop,nvar) = m(xpop, nvar)*MODEDat.epsilon; % Definindo o epsilon do problema

            end 
        elseif (MODEDat.kernel == 5) % If que seleciona o tipo de kernel Polinomial/Hermitiano e trata cada elemento da partícula de forma apropriada
            if (nvar == 1)
                Parent(xpop,nvar) = MODEDat.Initial(nvar,1)+(MODEDat.Initial(nvar,2)- MODEDat.Initial(nvar,1))*m(xpop, nvar);

            elseif (nvar == 2)
                Parent(xpop,nvar) = randi(2,1,1); % Definindo valores inteiros para o grau do polinômio
                
            else 
                Parent(xpop,nvar) = m(xpop, nvar)*MODEDat.epsilon; % Definindo o epsilon do problema

            end
        elseif (MODEDat.kernel == 7) % Kernel sigmoid
            if (nvar == 4)
                Parent(xpop,nvar) = m(xpop, nvar)*MODEDat.epsilon; % Definindo o epsilon do problema
            else
                Parent(xpop,nvar) = MODEDat.Initial(nvar,1)+(Initial(nvar,2)- MODEDat.Initial(nvar,1))*m(xpop, nvar);
            end

            
        end
        
        
    end
 
 
end
