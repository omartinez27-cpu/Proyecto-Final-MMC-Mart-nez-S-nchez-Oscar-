function Ke = RigidezElemento(x, y, E, nu, h)
    % RigidezElemento: Calcula la matriz de rigidez (Reissner-Mindlin)
    % Hipótesis: Reissner-Mindlin (con corrección de cortante k=5/6)
    
    % Extracción de coordenadas nodos
    x1 = x(1); y1 = y(1);
    x2 = x(2); y2 = y(2);
    x3 = x(3); y3 = y(3);
    
    
    % Coeficientes geometricos para cada nodo (i,j,k) ver formulacion
    b1 = y2 - y3;  c1 = x3 - x2;
    b2 = y3 - y1;  c2 = x1 - x3;
    b3 = y1 - y2;  c3 = x2 - x1;
    
    % Área (Determinante)
    M_det = [1, x1, y1;
             1, x2, y2;
             1, x3, y3];
    A = 0.5 * det(M_det);
    
    % Validación de área positiva para los elementos
    if A < 0
        A = abs(A);
        % Nota: Si el área era negativa, b y c cambian de signo, 
        % pero al elevarse al cuadrado o multiplicarse en B*B esto se compensara.
    end
    
    % 2. Material (Matrices D)
    % Flexión (Db)
    D_flex = (E * h^3) / (12 * (1 - nu^2));
    Db = D_flex * [1,  nu, 0;
                   nu, 1,  0;
                   0,  0,  (1 - nu) / 2]; 
    
    % Cortante (Ds)
    G = E / (2 * (1 + nu)); % Modulo de cortante
    k = 5/6;                % Factor de corrección de cortante
    Ds = k * G * h * [1, 0; 
                      0, 1];
                      
    %  Matriz de Flexión (Kb) - Integración Exacta
    % Matriz Bb (Constante)
    Bb = [0, -b1/(2*A),         0,   0, -b2/(2*A),         0,   0, -b3/(2*A),         0;
          0,         0, -c1/(2*A),   0,         0, -c2/(2*A),   0,         0, -c3/(2*A);
          0, -c1/(2*A), -b1/(2*A),   0, -c2/(2*A), -b2/(2*A),   0, -c3/(2*A), -b3/(2*A)];
          
    Kb = Bb' * Db * Bb * A;

    % Matriz de Cortante (Ks)
    % Usamos 3 puntos de integración (puntos medios de los lados) para 
    % eliminar los modos espurios (hourglass) que causan la matriz "trabada".
    
    Ks = zeros(9,9); % Generar matriz del tamaño requerido 3 nodos*3 GdL
    
    % Coordenadas de área (L1, L2, L3) para los 3 puntos medios
    % P1(0.5, 0.5, 0), P2(0, 0.5, 0.5), P3(0.5, 0, 0.5) 
    puntos_gauss = [0.5, 0.5, 0; 
                    0,   0.5, 0.5; 
                    0.5, 0,   0.5]; % Estas son las coordenadas baricentricas de los puntos de integracion que van a la mitad de 0 a 1
                    
    % Peso para 3 puntos = 1/3 del Área total cada uno
    W = 1/3; 
    
    for k = 1:3
        % Extraer coordenadas de área del punto actual
        L1 = puntos_gauss(k,1); 
        L2 = puntos_gauss(k,2); 
        L3 = puntos_gauss(k,3);
        
        % Evaluar funciones de forma N en este punto (Para T3, N_i = L_i)
        N1 = L1; 
        N2 = L2; 
        N3 = L3;
        
        % Construir Matriz Bs en este punto k
        % Fila 1: Gamma xz, Fila 2: Gamma yz
        Bsk = [ ...
          b1/(2*A), -N1,   0,    b2/(2*A), -N2,   0,    b3/(2*A), -N3,   0; 
          c1/(2*A),   0, -N1,    c2/(2*A),   0, -N2,    c3/(2*A),   0, -N3];
        
        % Acumular contribución a la integral
        % Ks = Suma( Bs' * Ds * Bs * Area * Peso )
        Ks = Ks + (Bsk' * Ds * Bsk * A * W);
    end

    % Total
    Ke = Kb + Ks; % Rigidez del elemento = suma rigidez de cortante + rigidez por flexión
end