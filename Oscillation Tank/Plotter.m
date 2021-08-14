function [  ] = Plotter( V, T, n )
%PLOTTER Plotea con un salto temporal.

i = 1;
j = 1;
while i < length(T)
    P(j) = V(i);
    K(j) = T(i);
    j = j + 1;
    i = i + n;
end

set(0,'defaultfigureposition',[0 0 800 600])
figure;
plot(K,P)
xlabel('Tiempo (segundos)')
ylabel('Presión en el Nodo (mca)')
%ylim([205 235])

length(P)
end

