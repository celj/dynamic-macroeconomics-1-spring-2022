% Trabajo final.  Macroeconomía Dinámica I
% Emanuel Payró 181775
% Carlos Lezama 181121
% Emiliano Ramírez 170309

% ITAM - Primavera 2022
% -----------------------------------------------------------------------------------------
clc; clear all; close all; 

% Parámetros del modelo

alpha = 0.33; % participación del capital en la producción
beta = 0.96; % factor de descuento
delta = 0.08; % tasa de depreciación del capital
sigma = 1.5; % coeficiente de aversión al riesgo
p = 200; % número de puntos de la malla
rho = 0.95; % persistencia del choque estocástico
sigma_e = 0.0632; % desviación estándar de las innovaciones

%% Inciso i): Método de Tauchen

% Definimos el número de puntos de la malla del choque
q = 5; 

% Llamamos al método de Tauchen
[zeta,P] = Tauchen(rho, q, sigma_e);

%% Inciso ii): Iteración de la función de valor

% Valor inicial para el capital y los precios
K = 31;
w = 2.2;
r = 0.04;
A = 0;

% Construimos una malla de puntos para el capital
amalla = linspace(0,70,p)';

% Definimos una matriz para la utilidad de todos los posibles estados para
% cada agente: para jóvenes y para viejos.

%función de utilidad para los jóvenes
U_y  = zeros(p,q,p);

for i=1:p          % activos de hoy
    for j=1:q      % choque de hoy
        for l=1:p  % activos de mañana
            c1 = max(exp(zeta(j))*w + (1+r)*amalla(i) - amalla(l),1e-200); % valor del consumo
            U_y(i,j,l) = (c1.^(1-sigma))./(1-sigma);  % valor de la utilidad
        end
    end
end

%función de utilidad para los viejos
U_o  = zeros(p,q,p);

for i=1:p          % activos de hoy
    for j=1:q      % choque de hoy
        for l=1:p  % activos de mañana
            c2 = max(exp(zeta(j))*w + (1+r)*amalla(i) - amalla(l),1e-200); % valor del consumo
            U_o(i,j,l) = (c2.^(1-sigma))./(1-sigma);  % valor de la utilidad
        end
    end
end


% Auxiliares para la iteración de la función de valor
V0 = zeros(p,q);
V1 = zeros(p,q);

termin = 0; % condición de término
iter = 1; % inicializa el número de iteraciones
maxit = 1000; % número máximo de iteraciones
crit = 1e-5; % criterio de tolerancia

% Auxiliar para las reglas de decisión óptimas
pol  = zeros(p,q);

% Algoritmo
while (termin==0 && iter<maxit)
  for i=1:p                               % activos de hoy
      for j=1:q                           % choque de hoy
          aux = zeros(p,1); % auxiliar para encontrar la utilidad máxima
          
          for l=1:p                       % activos de mañana
              aux(l) = U_y(i,j,l);
              
              for m=1:q                   % choque de mañana
                  % aquí metemos como función valor del futuro a la función de utilidad
                  % de los agentes retirados de la economía, metiéndole
                  % como argumento los activos de mañana, el choque de hoy
                  % y el choque de mañana
                  aux(l) = aux(l)+ beta*P(j,m)*U_o(l,j,m);
              end
              
          end
          
          [V1(i,j),pol(i,j)] = max(aux); % indexación lógica para obtener el máximo
      end
  end
  
  % Criterio de convergencia
  if norm(V0-V1) < crit
      termin = 1;
  end
  
  % Actualización de valores
  V0  = V1; 
  iter  = iter+1; 
end

% Calcumalos las reglas de decisión óptimas para el agente joven
K_y = zeros(p,q); % acumulación de activos
C_y = zeros(p,q); % consumo

for i=1:p                                  % activos de hoy
    for j=1:q                              % choque de hoy
        K_y(i,j) = amalla(pol(i,j));
        C_y(i,j) = exp(zeta(j))*w+(1+r)*amalla(i)-K_y(i,j);
    end
end 

figure(1)
subplot(3,1,1);
plot(amalla,V1(:,1),'b',amalla,V1(:,2),'r',amalla,V1(:,3),'g',amalla,V1(:,4),'y',amalla,V1(:,5),'m')
legend('\zeta_1 = -0.6','\zeta_2 = -0.3','\zeta_3 = 0','\zeta_4 = 0.3','\zeta_5 = 0.6');
title('Función valor para el agente joven')
xlabel('a')
ylabel('V')

subplot(3,1,2);
plot(amalla,C_y(:,1),'b',amalla,C_y(:,2),'r',amalla,C_y(:,3),'g',amalla,C_y(:,4),'y',amalla,C_y(:,5),'m')
legend('\zeta_1 = -0.6','\zeta_2 = -0.3','\zeta_3 = 0','\zeta_4 = 0.3','\zeta_5 = 0.6');
title('Consumo del agente joven')
xlabel('a')
ylabel('C')

subplot(3,1,3);
plot(amalla,K_y(:,1),'b',amalla,K_y(:,2),'r',amalla,K_y(:,3),'g',amalla,K_y(:,4),'y',amalla,K_y(:,5),'m')
title('Activos del agente joven')
legend('\zeta_1 = -0.6','\zeta_2 = -0.3','\zeta_3 = 0','\zeta_4 = 0.3','\zeta_5 = 0.6');
xlabel('a')
ylabel('a''')

% Calcumalos las reglas de decisión óptimas para el agente retirado
C_o = zeros(p,q); % consumo del agente retirado. Este ya no acumula activos
V_o = zeros(p,q); % función valor del agente retirado

for i=1:p                                  % activos de hoy
    for j=1:q                              % choque de hoy
        C_o(i,j) = (1+r)*amalla(pol(i,j));
        V_o(i,j) = (C_o(i,j).^(1-sigma))./(1-sigma);
    end
end 

figure(2)
subplot(2,1,1);
plot(amalla,V_o(:,1),'b',amalla,V_o(:,2),'r',amalla,V_o(:,3),'g',amalla,V_o(:,4),'y',amalla,V_o(:,5),'m')
legend('\zeta_1 = -0.6','\zeta_2 = -0.3','\zeta_3 = 0','\zeta_4 = 0.3','\zeta_5 = 0.6');
title('Función valor agente retirado')
xlabel('a')
ylabel('V')

subplot(2,1,2);
plot(amalla,C_o(:,1),'b',amalla,C_o(:,2),'r',amalla,C_o(:,3),'g',amalla,C_o(:,4),'y',amalla,C_o(:,5),'m')
legend('\zeta_1 = -0.6','\zeta_2 = -0.3','\zeta_3 = 0','\zeta_4 = 0.3','\zeta_5 = 0.6');
title('Consumo del agente retirado')
xlabel('a')
ylabel('C')


%% Incisos iii): Simulación de la economía
% Número de períodos a simular
T = 10000; 

% Inicialozamos los vectores
zt  = zeros(T,1);   % indicadora de los choques    
at  = zeros(T+1,1); % valores de los choques
ai = zeros(T+1,1); % indicadora de los activos
ct  = zeros(T,1);
shock = zeros(T+1,1); % valores de los choques

% Le damos valores iniciales a las variables de estado
at(1) = 0;
ai(1) = 1;
zt(1) = 3;

% Vamos a simular los choques
pi_acum = cumsum(P',1)';
for t=1:T-1
    zt(t+1)=min(find(random('unif',0,1) <= pi_acum(zt(t),:)));
end

% Calculamos los valores de las variables del modelo
for t = 1:T
        ai(t+1) = pol(ai(t),zt(t));
        at(t+1) = amalla(ai(t+1));
        ct(t)   = C_y(ai(t),zt(t));
        shock(t)= zeta(zt(t));
end
    
% Obtenemos la distribución invariante

% Inicializamos la matriz que almacena la distribución
F = zeros(p,q);

% Auxiliar que indica el estado de la economía
state = zeros(p,q); 

for i=1:p % número de puntos en la malla de activos
    for j=1:q % número de puntos en la malla del choque
        for t=1001:10000 % no considera las primeras 1000 observaciones
            if ai(t)==i && zt(t)==j
                state(i,j) = state(i,j)+1; % aumenta la frecuencia de esa entrada
            end
        end
        F(i,j) = state(i,j)/9000; % divide los estados entre número de observaciones para obtener la distribución
    end
end

% Graficamos la distribución acumulativa para cada valor del choque
F = cumsum(F)./sum(F);

figure(3)
subplot(3,2,1);
plot(amalla,F(:,1))
title('\zeta_1 = -0.6')
xlabel('a');

subplot(3,2,2);
plot(amalla,F(:,2))
title('\zeta_2 = -0.3')
xlabel('a');

subplot(3,2,3);
plot(amalla,F(:,3))
title('\zeta_3 = 0')
xlabel('a');

subplot(3,2,4);
plot(amalla,F(:,4))
title('\zeta_4 = 0.3')
xlabel('a');

subplot(3,2,5);
plot(amalla,F(:,5))
title('\zeta_5 = 0.6')
xlabel('a');