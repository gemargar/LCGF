%This script calculates the field at n points on the surface of
%an outer strand for a = 0 to a = ð/2+â

function E = fieldalpha_bipolar(A,alpha,D,RC,H,N,M)
    
    a = sqrt(H^2 - RC^2);
    [u,ksi] = convert_bipolar_alpha(alpha,D,RC,H,N);
    
    %Initialization
    n = length(u);
    E = zeros(n,1);
    
    %Preallocation
    Eksi = zeros(n,1);
    Eu = zeros(n,1);
    
    for i=1:n
        %Calculation of electric field
        for k = 0:M
            if (k == 0)
                Eksi(i) = -A(k+1);
                Eu(i) = 0;
            else
                Eksi(i) = Eksi(i) - A(k+1)*k*cosh(k*ksi(i))*cos(k*u(i));
                Eu(i) = Eu(i) + A(k+1)*sinh(k*ksi(i))*k*sin(k*u(i));
            end
        end
        Eksi(i) = Eksi(i)*(cosh(ksi(i))-cos(u(i)))/a;
        Eu(i) = Eu(i)*(cosh(ksi(i))-cos(u(i)))/a;
        %Calculation of field's norm
        E(i) = sqrt(Eksi(i)^2 + Eu(i)^2);
    end
    
end

