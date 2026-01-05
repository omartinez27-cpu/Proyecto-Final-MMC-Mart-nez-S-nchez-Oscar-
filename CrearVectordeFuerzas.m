function [F] = CrearVectordeFuerzas(NL)
    % Inicializa el vector global de fuerzas con ceros
    GdL_por_Nodo = 3; 
    [nNodos, ~] = size(NL);
    nGdL_Total = nNodos * GdL_por_Nodo;
    
    F = zeros(nGdL_Total, 1);
end

