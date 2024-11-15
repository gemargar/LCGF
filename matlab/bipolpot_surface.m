%This script calculates the potential at n points on the surface of
%the outer strand for è = 0 to è = ð

function p = bipolpot_surface(u,ksi,A,M)

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
