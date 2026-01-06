% Mecanica del medio continuo / Oscar Eduardo Martínez Sánchez 
% Entrega final: Analisis 2D de placas por elementos finitos bajo la teoria de Reissener-Mindlin

clear all;
clc;
clf;

%Tipo= 'Circular'; % Caso 1
Tipo= 'Rectangular'; % Caso 2

% Ingresar paramentros de entrada / Preproceso
% Geometria
d1=1; % Distancia horizontal m (Rectangular)/ Radio m (Circular)
d2=1; % Distancia vertical m (Rectangular)/ ( Ignorar Circular)
h = 0.1   % Espesor de la placa m

% Mallado
p=22;  % # divisiones en x /angular (minimo recomendado 30)
m=22;  % # divisiones en y / radial
Tipo_elemento = 'Triangular'; % Elementos finitos tringulares 

% Material
E = 200e9; % Modulo de Elasticidad (Pa)
nu = 0.3;  % Modulo de Poisson (adim)

% Cargas
q= -10000000; % (Presion uniforme Pa) Circular
P_carga = -100000000; % (Carga puntual Pa) Rectangular 
coord_objetivo = 265 % Nodo en el que se aplicara la carga

% Proceso
 

% Caso 1 (Placa circular sometida a presion perpendicular)

%[KG, NL, EL] = EnsamblajeKglobalPlaca('Circular', d1, p, m, E, nu, h); % Matriz K para placa redonda

% Caso 2 (Placa rectangular sometida a carga puntual al centro)

[KG, NL, EL] = EnsamblajeKglobalPlaca('Rectangular', [d1, d2], p, m, E, nu, h); % Matriz K para placa rectangular


% Crear un vector para las cargas
F = CrearVectordeFuerzas(NL);

% Caso 1 (Placa circular sometida a presion perpendicular)

%F = AgregarCargaUniforme(F, NL, EL, q); 

% Caso 2 (Placa rectangular sometida a carga puntual al centro)

F = AgregarCargaPuntual(F, NL, coord_objetivo, P_carga);

% Contorno
GdL_fijos = CondicionesdeContorno(Tipo, d1, d2, NL);

nGdL_Total = length(F);
GdL_libres = setdiff(1:nGdL_Total, GdL_fijos);
% Resolver el Sistema (Partición de Matrices)
% K_LL * U_L = F_L  =>  U_L = K_LL \ F_L
U_global = zeros(nGdL_Total, 1);

K_LL = KG(GdL_libres, GdL_libres);
F_L  = F(GdL_libres);

disp('Resolviendo sistema...');
U_L = K_LL \ F_L;

% Reconstruir vector total
U_global(GdL_libres) = U_L;


%  Graficar Resultados / Postproceso (Desplazamiento Vertical w)
% Los desplazamientos verticales están en los índices 1, 4, 7...
desplazamientos_w = U_global(1:3:end);

figure;
trisurf(EL, NL(:,1), NL(:,2), desplazamientos_w); % este comando permite graficar elementos triangulares de manera inmediata
title('Deformación Vertical de la Placa (metros)');
colorbar;
xlabel('X'); ylabel('Y'); zlabel('w (m)');
axis equal;

% Comparacion con solucion a mano de formula direccta (analitica)
D = (E * h^3) / (12 * (1 - nu^2)); % Rigidez a flexión

% Caso 1 (Placa circular sometida a presion perpendicular)

%w_manual= (abs(q)*(d1^4))/(64*D);

% Caso 2 (Placa rectangular sometida a carga puntual al centro)

w_manual= 0.01160*(abs(P_carga)*(d1*d1))/D;


w_fem = abs(min(desplazamientos_w));

error_porc = abs((w_fem - w_manual) / w_manual) * 100;

fprintf('ERROR RELATIVO: %.2f %%\n', error_porc);

[Momentos, Curvaturas] = ProcesarResultadosPlaca(U_global, NL, EL, E, nu, h, 'Resultados FEM placa');



% ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
% │  ___    ____     ____      _      ____      __  __   _____   _____    _   _      _       ___      _____   ___ │
% │ / _ \  / ___|   / ___|    / \    |  _ \    |  \/  | |_   _| |__  /   | | | |    / \     / _ \    |  ___| |_ _|│
% │| | | | \___ \  | |       / _ \   | |_) |   | |\/| |   | |     / /    | | | |   / _ \   | | | |   | |_     | | │
% │| |_| |  ___) | | |___   / ___ \  |  _ <    | |  | |   | |    / /_    | |_| |  / ___ \  | |_| |   |  _|    | | │
% │ \___/  |____/   \____| /_/   \_\ |_| \_\   |_|  |_|   |_|   /____|    \___/  /_/   \_\  \__\_\   |_|     |___|│
% └───────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
