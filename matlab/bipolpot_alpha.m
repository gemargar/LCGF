%This script calculates the field at n points on the surface of
%an outer strand for a = 0 to a = ð/2+â

function p = bipolpot_alpha(A,alpha,D,RC,H,M,N)
    
    [u,ksi] = convert_bipolar_alpha(alpha,D,RC,H,N);
    %Initialization
    n = length(u);
    p = zeros(n,1);
    
    for i=1:n
        %Calculation of potential
        for k = 0:M
            if (k == 0)
                p(i) = A(k+1)*ksi(i);
            else
                p(i) = p(i) + A(k+1)*sinh(k*ksi(i))*cos(k*u(i));
            end
        end
    end

end

