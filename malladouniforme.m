function [ NL,EL ] = malladouniforme(d1,d2,p,m,Tipo_elemento);


PD=2; % Dimension del problema

q=[0 0; d1 0; 0 d2; d1 d2];  % Extremos de la placa

NdN= (p+1)*(m+1); % numero de nodos

NdE= p*m; % numero de elementos

NpE= 4; % Nodos por elemento (posteriormente dividimos el cuadrado en 2 tringulos)

% NODOS %

NL = zeros (NdN,PD); 
a= d1/p; % ancho de malla x
b= d2/m; % ancho de malla y

n=1;
for i=1:m+1

    for j=1:p+1

        NL(n,1) = q(1,1)+(j-1)*a;
        NL(n,2) = q(1,2)+(i-1)*b;
        n=n+1;
    end
end

% ELEMENTOS %

EL = zeros(NdE,NpE);

for i=1:m   %Generamos elementos rectangulares para despues dividirlos 

    for j=1:p

        if j==1

            EL((i-1)*p+j,1) = (i-1)*(p+1)+j;
            EL((i-1)*p+j,2) = EL((i-1)*p+j,1)+1;
            EL((i-1)*p+j,4) = EL((i-1)*p+j,1)+(p+1);
            EL((i-1)*p+j,3) = EL((i-1)*p+j,4)+1;
        else

            EL((i-1)*p+j,1) = EL((i-1)*p+j-1,2);
            EL((i-1)*p+j,4) = EL((i-1)*p+j-1,3);
            EL((i-1)*p+j,2) = EL((i-1)*p+j,1)+1;
            EL((i-1)*p+j,3) = EL((i-1)*p+j,4)+1;
      
        end

    end
   
end

if isequal(Tipo_elemento,'Triangular') % Con este if dividimos los elementos cuadrados

    NpE_actual=3;
    EL_actual=zeros(2*NdE,NpE_actual);

    for i=1:NdE

        EL_actual(2*(i-1)+1,1) = EL(i,1);
        EL_actual(2*(i-1)+1,2) = EL(i,2);
        EL_actual(2*(i-1)+1,3) = EL(i,3);

       
        EL_actual(2*(i-1)+2,1) = EL(i,1);
        EL_actual(2*(i-1)+2,2) = EL(i,3);
        EL_actual(2*(i-1)+2,3) = EL(i,4);
        
    end

    EL = EL_actual;

end

end
