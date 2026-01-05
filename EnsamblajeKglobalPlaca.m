function [KG, NL, EL] = EnsamblajeKglobalPlaca(Tipo_Geometria, Parametros_Geo, p, m, E, nu, h)

    % La funcion para calcular la rigidez RigidezElemento solo se programo para elementos
    % triangulares

    Tipo_Elemento = 'Triangular'; % La funcionde rigidez solo admite elementos triangulares
    
    switch Tipo_Geometria
        case 'Rectangular' %IMPORTANTE El argumento rectangular se refiere a la placa no al tipo de elemento finito
            % Desempaquetar dimensiones rectangulares
            d1 = Parametros_Geo(1); 
            d2 = Parametros_Geo(2);
            [NL, EL] = malladouniforme(d1, d2, p, m, Tipo_Elemento);
            
        case 'Circular'
            % Desempaquetar radio
            d1 = Parametros_Geo(1);
            [NL, EL] = malladocircular(p, m, d1, Tipo_Elemento);
            
        otherwise
            error('Error de geometria. Use "Rectangular" o "Circular".');
    end

    % Inicialización de la Matriz Global
    [nNodos, ~] = size(NL);
    nElementos = size(EL, 1);
    
    GdL_por_Nodo = 3; % w, theta_x, theta_y
    nGdL_Total = nNodos * GdL_por_Nodo;
    
    KG = sparse(nGdL_Total, nGdL_Total);

    % Bucle de Ensamblaje (Idéntico para cualquier geometría)
    for e = 1:nElementos
        % A. Identificar nodos (Topología)
        nodo1 = EL(e, 1);
        nodo2 = EL(e, 2);
        nodo3 = EL(e, 3);
        nodos_ele = [nodo1, nodo2, nodo3];
        
        % B. Extraer coordenadas (Geometría)
        x_ele = [NL(nodo1, 1); NL(nodo2, 1); NL(nodo3, 1)];
        y_ele = [NL(nodo1, 2); NL(nodo2, 2); NL(nodo3, 2)];
        
        % C. Matriz Local
        Ke = RigidezElemento(x_ele, y_ele, E, nu, h);
        
        % D. Índices Globales
        indices_globales = [];
        for i = 1:3
            nodo_act = nodos_ele(i);
            indice_inicial = (nodo_act - 1) * GdL_por_Nodo;
            indices_globales = [indices_globales, (indice_inicial+1), (indice_inicial+2), (indice_inicial+3)];
        end
        
        % E. Suma
        KG(indices_globales, indices_globales) = ...
            KG(indices_globales, indices_globales) + Ke;
    end
end