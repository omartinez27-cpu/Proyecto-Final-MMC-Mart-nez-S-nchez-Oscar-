function [GdL_Fijos] = CondicionesdeContorno(Tipo_Geometria, d1, d2, NL)

    
    GdL_Fijos = [];
    tol = 1e-4; % Tolerancia de proximiddad entre nodos
    
    switch Tipo_Geometria
        case 'Circular'
            R = d1; % Asignamos d1 al Radio y d2 se ignora
            
            % Distancia al centro
            radios = sqrt(NL(:,1).^2 + NL(:,2).^2);
            
            % Buscar nodos del borde
            nodos_borde = find(abs(radios - R) < tol);
            
            % Restringir todo (w, tx, ty)
            for k = 1:length(nodos_borde)
                nodo = nodos_borde(k);
                base = (nodo - 1) * 3;
                GdL_Fijos = [GdL_Fijos, base+1, base+2, base+3]; 
            end
            
            fprintf('Condición: Circular Empotrada (R=%g). Nodos fijos: %d\n', R, length(nodos_borde));

        case 'Rectangular'
            L = d1; % Asignamos d1 al Largo
            W = d2; % Asignamos d2 al Ancho
            
            % Encontrar nodos en los bordes
            nodos_izq   = find(abs(NL(:,1) - 0) < tol);      
            nodos_der   = find(abs(NL(:,1) - L) < tol);      
            nodos_abajo = find(abs(NL(:,2) - 0) < tol);      
            nodos_arriba= find(abs(NL(:,2) - W) < tol);      
            
            % --- Bordes Verticales ---
            nodos_verticales = unique([nodos_izq; nodos_der]);
            for k = 1:length(nodos_verticales)
                nodo = nodos_verticales(k);
                base = (nodo - 1) * 3;
                GdL_Fijos = [GdL_Fijos, base+1, base+2]; % w=0, tx=0
            end
            
            % --- Bordes Horizontales ---
            nodos_horizontales = unique([nodos_abajo; nodos_arriba]);
            for k = 1:length(nodos_horizontales)
                nodo = nodos_horizontales(k);
                base = (nodo - 1) * 3;
                GdL_Fijos = [GdL_Fijos, base+1, base+3]; % w=0, ty=0
            end
            
            fprintf('Condición: Rectangular Simplemente Apoyada (L=%g, W=%g).\n', L, W);
            
        otherwise
            error('Tipo de geometría no reconocido.');
    end
    
    GdL_Fijos = unique(GdL_Fijos);
end