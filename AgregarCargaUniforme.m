function [F] = AgregarCargaUniforme(F, NL, EL, q)
    % Agrega una presión uniforme 'q' (Fuerza/Area) a toda la malla
    % Se asume que la carga va en dirección Z (vertical)
    
    nElementos = size(EL, 1);
    GdL_por_Nodo = 3; 
    
    for i = 1:nElementos
        % Extraer nodos del elemento
        n1 = EL(i, 1);
        n2 = EL(i, 2);
        n3 = EL(i, 3);
        
        % Coordenadas
        x1 = NL(n1, 1); y1 = NL(n1, 2);
        x2 = NL(n2, 1); y2 = NL(n2, 2);
        x3 = NL(n3, 1); y3 = NL(n3, 2);
        
        % Calcular Área del elemento (determinante)
        M_det = [1, x1, y1;
                 1, x2, y2;
                 1, x3, y3];
        Area = 0.5 * abs(det(M_det));        
        % Carga Total en el elemento
        F_total = q * Area;
        
        % Distribución (Consistent Nodal Loads para T3)
        % Se reparte 1/3 de la carga total a cada nodo en el GdL vertical
        f_nodo = F_total / 3;
        
        % Índices globales para el grado de libertad w (vertical)
        % El GdL w es el primero de los 3 (1, 4, 7...)
        indice1 = (n1 - 1) * GdL_por_Nodo + 1;
        indice2 = (n2 - 1) * GdL_por_Nodo + 1;
        indice3 = (n3 - 1) * GdL_por_Nodo + 1;
        
        % Sumar al vector global
        F(indice1) = F(indice1) + f_nodo;
        F(indice2) = F(indice2) + f_nodo;
        F(indice3) = F(indice3) + f_nodo;
    end
end