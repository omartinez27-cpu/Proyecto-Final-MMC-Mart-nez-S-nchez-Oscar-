function [F] = AgregarCargaPuntual(F, NL, nodo_id, P_val)
    % Agrega una carga puntual P_val en un nodo específico
    % P_val es magnitud (negativo si va hacia abajo)
    
    GdL_por_Nodo = 3;
    
    % Índice del GdL vertical (w) para ese nodo
    indice_w = (nodo_id - 1) * GdL_por_Nodo + 1;
    
    % Sumar carga
    F(indice_w) = F(indice_w) + P_val;
end