function [ H, Q, z, t ] = Tanque_2F_Apertura( H0, Q0, D, L, rug1, rug2, nTanque, dx, tc, tmax )
%TANQUE_2F Simulación de flujo transitorio en una tubería con un tanque
%de oscilación.
%   #TEAMCIEDES

As = (18^2)*pi/4;
%Ubicación del Tanque
x = ceil(nTanque/dx) + 1;

%%%Cálculo del factor de fricción
A = (D^2)*pi/4;
v = Q0/A;
Re = v*D/(1.004e-6);
ED1 = rug1/D;
ED2 = rug2/D;
f1 = ColeWhite(ED1,Re,1e-6);
f2 = ColeWhite(ED2,Re,1e-6);

%%%Inicialización de las Matrices
a = 1481;
%dt = dx/a;
dt = 0.05;
n = ceil(tmax/dt)+1;
m = ceil(L/dx)+1;

H = zeros(n,m);
Q = zeros(n,m);
CP = zeros(n,m);
CN = zeros (n,m);
z = zeros(n,1);
t = zeros(n,1);

%%%Condiciones de Frontera

%Embalse de Carga Estática
for i=1:n
    H(i,1) = H0;
end

%Pérdidas en la Tubería
for j=1:x-1
    H(1,j) = H0 - (16*f1*Q0^2)*(j-1)*dx/(2*9.81*D^5*pi^2);
end
for j=x:m
    H(1,j) = H0 - (16*f2*Q0^2)*(j-1)*dx/(2*9.81*D^5*pi^2);
end
z(1) = H(1,x);
t(1) = 0;

%Caudal Inicial Constante
for j=1:m
    Q(1,j) = Q0;
end
Q(1,x) = 0;

%Maniobra de Cierre
Q(1,m) = Q0;
i = 4692;
j = 4692;
while i <= tmax/dt + 1
    if i <= 5292
        Q(i,m) = Q0*(i - j)*dt/30;
    else
        Q(i,m) = Q0;
    end
    i = i + 1;
end

%%%Método de las Características
Ca = 9.81*A/a;
R1 = f1/(2*D*A);
R2 = f2/(2*D*A);

i = 2;
while i <= tmax/dt + 1
    %Cálculo de las Características
    for j=2:x-1
        CP(i,j) = Q(i-1,j-1) + Ca*H(i-1,j-1) - R1*dt*Q(i-1,j-1)*abs(Q(i-1,j-1));
    end
    for j=x:m
        CP(i,j) = Q(i-1,j-1) + Ca*H(i-1,j-1) - R2*dt*Q(i-1,j-1)*abs(Q(i-1,j-1));
    end
    
    for j=1:x-1
        CN(i,j) = Q(i-1,j+1) - Ca*H(i-1,j+1) - R1*dt*Q(i-1,j+1)*abs(Q(i-1,j+1));
    end
    for j=x:m-1
        CN(i,j) = Q(i-1,j+1) - Ca*H(i-1,j+1) - R2*dt*Q(i-1,j+1)*abs(Q(i-1,j+1));
    end
    
    %Cálculo de los Nodos
    for j=1:m
        if j == 1
            Q(i,j) = CN(i,j) + Ca*H0;
        elseif j == m
            H(i,j) = (CP(i,j)-Q(i,j))/Ca;
        elseif j == x-1 || j == x || j == x+1
            H(i,x) = (CP(i,x-1) - CN(i,x+1) + Q(i-1,x) + (2*As*z(i-1)/dt))/(Ca + Ca + (2*As/dt));
            H(i,x-1) = H(i,x);
            H(i,x+1) = H(i,x);
            Q(i,x-1) = CP(i,x-1) - Ca*H(i,x-1);
            Q(i,x+1) = CN(i,x+1) + Ca*H(i,x+1);
            Q(i,x) = Q(i,x-1) - Q(i,x+1);
        else
            H(i,j) = (CP(i,j) - CN(i,j))/(2*Ca);
            Q(i,j) = (CP(i,j) + CN(i,j))/2;
        end
    end
    z(i) = H(i,x);
    t(i) = (i-1)*dt;
    i = i + 1;
end
end