function [NL, EL] = malladocircular(p, m, R, ~)
 
    
    NdN = 1 + (m * p);
    NL = zeros(NdN, 2);
    
    % Nodo Central en el origen (Índice 1)
    NL(1, :) = [0, 0];
    
    % Nodos de los Anillos
    d_rad = R / m;          % Paso radial
    d_ang = 2 * pi / p;     % Paso angular (círculo completo)
    
    indice = 2; % Llenar desde el nodo 2
    for i = 1:m             % genracion radial (anillos)
        rad = i * d_rad;
        for j = 1:p         % generacion angular (divisiones)
            ang = (j - 1) * d_ang;
            NL(indice, 1) = rad * cos(ang);
            NL(indice, 2) = rad * sin(ang);
            indice = indice + 1;
        end
    end

    % Generamos triangulos directamente
    % Usando 3 columnas para la conectividad [Nodo1, Nodo2, Nodo3]
    
 
    % Centro: p triángulos
    % Anillos: (m-1) * p * 2 triángulos
    Num_Elem = p + (m - 1) * p * 2;
    EL = zeros(Num_Elem, 3);
    elem_indice = 1;
    
    % Núcleo (Triángulos conectados al nodo central)
    % El primer anillo de nodos va del índice 2 al (p+1)
    
    inicio_actual = 2; % Inicio del anillo 1
    
    for j = 1:p
        n1 = 1; % Nodo Central
        n2 = inicio_actual + (j - 1);       % Nodo actual del anillo 1
        
        % Lógica de cierre (Wrap-around): Si es el último, conecta con el primero
        if j == p
            n3 = inicio_actual;             % Conecta con el inicio del anillo
        else
            n3 = inicio_actual + j;         % Conecta con el siguiente
        end
        
        EL(elem_indice, :) = [n1, n2, n3];
        elem_indice = elem_indice + 1;
    end
    
    % Los Anillos Exteriores (Cuadriláteros divididos en 2 Triángulos)
    % Conectamos el anillo 'i' con el anillo 'i+1'
    
    for i = 1:(m - 1)
        % Índices de inicio de los anillos actual y siguiente
        indice_anillo_actual = 2 + (i - 1) * p;
        indice_anillo_sig = 2 + i * p;
        
        for j = 1:p
            % Identificar los 4 nodos del "cuadrilátero"
            % primer anillo
            c1 = indice_anillo_actual + (j - 1);
            if j == p
                c2 = indice_anillo_actual;      % Cierre
            else
                c2 = c1 + 1;
            end
            
            % Siguiente anillo
            n1 = indice_anillo_sig + (j - 1);
            if j == p
                n2 = indice_anillo_sig;      % Cierre
            else
                n2 = n1 + 1;
            end
            
            % Dividir el cuadrilátero (c1, c2, n2, n1) en 2 triángulos
            % Triángulo 1
            EL(elem_indice, :) = [c1, c2, n2];
            elem_indice = elem_indice + 1;
            
            % Triángulo 2
            EL(elem_indice, :) = [c1, n2, n1];
            elem_indice = elem_indice + 1;
        end
    end
end