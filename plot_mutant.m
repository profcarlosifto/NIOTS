% Script que faz os gráficos do comportamento das mutações ao longo das iterações no MODE.
function plot_mutant(nome)

fid = fopen(nome);
tline = fgets(fid);
tline1 = str2num(tline);
[i,j] = size(tline1);
mutant1 = zeros(i,j);

mutant1 = zeros(1,j);
mutant2 = zeros(1,j);
mutant3 = zeros(1,j);
mutant4 = zeros(1,j);


card = zeros(i,j);
t = 1;
s = 1;
c = 1;
h = 1;
i = 1;
while ischar(tline)
    if (mod(t,4) == 1)
        mutant1(s,:) = tline1;
        s = s+1;
    elseif(mod(t,4) == 2)
        mutant2(c,:) = tline1;
        c = c+1;
    elseif(mod(t,4) == 3)
        mutant3(i,:) = tline1;
        i = i+1;
    else
        mutant4(h,:) = tline1;
        h = h+1;       
    end
    tline = fgets(fid);
    if ischar(tline)
        tline1 = str2num(tline);
    end
t = t+1;
end
individuals = mutant1(1,1)+mutant2(1,1)+mutant3(1,1)+mutant4(1,1);

subplot(4,1,1)
hold on

for i = 1:size(mutant1,1)
    plot(mutant1(i,:))
end
title('Mutant - DE/rand/1')
ylabel('Individuals')
%xlabel('Iterations')
axis([0 j 0 individuals])
grid on

subplot(4,1,2)
hold on
for i = 1:size(mutant2,1)
    plot(mutant2(i,:))
end
title('Mutant - DE/rand/2')
ylabel('Individuals')
%xlabel('Iterations')
axis([0 j 0 individuals])
grid on

subplot(4,1,3)
hold on
for i = 1:size(mutant3,1)
    plot(mutant3(i,:))
end
title('Mutant - Tournament')
ylabel('Individuals')
xlabel('Iterations')
%axis([0 j 0 individuals])
grid on

subplot(4,1,4)
hold on
for i = 1:size(mutant4,1)
    plot(mutant4(i,:))
end
title('Mutant - DE/rand-to-best/1')
ylabel('Individuals')
xlabel('Iterations')
%axis([0 j 0 individuals])
grid on
end