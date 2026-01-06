function [Momentos, Curvaturas] = ProcesarResultadosPlaca(U_global, NL, EL, E, nu, h, TituloGrafica)
     
    nElem = size(EL, 1);
    Momentos = zeros(nElem, 3);
    Curvaturas = zeros(nElem, 3);
    
    % Matriz Constitutiva de Flexión (Db)
    % Relaciona Momentos con Curvaturas: M = Db * kappa
    D_flex = (E * h^3) / (12 * (1 - nu^2));
    Db = D_flex * [1,  nu, 0;
                   nu, 1,  0;
                   0,  0,  (1 - nu) / 2];
    
    for i = 1:nElem
        % Recuperar Nodos
        n1 = EL(i, 1); n2 = EL(i, 2); n3 = EL(i, 3);
        
        % Coordenadas
        x1 = NL(n1, 1); y1 = NL(n1, 2);
        x2 = NL(n2, 1); y2 = NL(n2, 2);
        x3 = NL(n3, 1); y3 = NL(n3, 2);
        
        % Geometría (b y c son derivadas de las funciones de forma)
        b1 = y2 - y3;  c1 = x3 - x2;
        b2 = y3 - y1;  c2 = x1 - x3;
        b3 = y1 - y2;  c3 = x2 - x1;
        
        % Área (Determinante)
        M_det = [1, x1, y1; 1, x2, y2; 1, x3, y3];
        A = 0.5 * abs(det(M_det)); % Usamos abs para seguridad de area positiva
        
        % Matriz B de flexión (Curvatura-Desplazamiento)
        Bb = (1/(2*A)) * ...
             [0, -b1,   0,   0, -b2,   0,   0, -b3,   0;
              0,   0, -c1,   0,   0, -c2,   0,   0, -c3;
              0, -c1, -b1,   0, -c2, -b2,   0, -c3, -b3];
          
        % Vector de Desplazamientos del Elemento (9x1)
        % Índices en U global: (nodo-1)*3 + [1,2,3]
        Ind_elem = [ (n1-1)*3+1, (n1-1)*3+2, (n1-1)*3+3, ...
                    (n2-1)*3+1, (n2-1)*3+2, (n2-1)*3+3, ...
                    (n3-1)*3+1, (n3-1)*3+2, (n3-1)*3+3 ];
        
        u_ele = U_global(Ind_elem);
        
        % Calculo de las curvaturas y los momentos
        kappa = Bb * u_ele;      % Curvaturas 
        M_val = Db * kappa;      % Momentos
        
        Curvaturas(i, :) = kappa';
        Momentos(i, :)   = M_val';
    end
    
    % GRAFICACIÓN (VISUALIZACIÓN)
    figure('Name', ['Resultados: ', TituloGrafica], 'Color', 'w', 'Position', [100, 100, 1200, 400]);
    
    % Dummy Z para plotear en plano 2D
    Z_dummy = zeros(size(NL, 1), 1); % Esto solo es para 'aplanar' la grafica
    
    nombres = {'Curvatura \kappa_x', 'Curvatura \kappa_y', 'Curvatura \kappa_{xy}'};
    
    for k = 1:3
        subplot(1, 3, k);
        % Usamos 'FaceColor', 'flat' porque solo calculamos 1 valor por elemento
        
    
        trisurf(EL, NL(:,1), NL(:,2), Z_dummy, ...
                'CData', Curvaturas(:,k), ...
                'FaceColor', 'flat', 'EdgeColor', 'none');
            
        title(nombres{k});
        xlabel('X'); ylabel('Y');
        axis equal; view(2); grid off;
        
        % Colorbar con unidades
        hcb = colorbar;
        ylabel(hcb, 'm^{-1}');
        colormap(jet);
    end
    
    sgtitle(['Análisis de Curvaturas - ', TituloGrafica]);
    
  
end