%This function calculates the potential at n points on the surface of
%an outer strand for è = 0 to è = â = ð/Í

function p = polpot_surface(gamma,A,RC,RF,M,N)
    
    n = 1001;
    %Initialization
    beta = pi/N;   %Boundary angle
    
    %Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    %Calculation of B1 and B2
    B1 = 2*(RC - RS);
    B2 = (RC - RS)^2 - RS^2;
    
    %Initialization
    p = zeros(n,1);
    % Angles
    gamma = gamma*pi/180;
    step = gamma/(n-1);
    
    for k=0:(n-1)
        %Calculation of coordinates
        % Calculation of alpha
        alpha = k*step;
        % Calculation of coordinates
        x = atan(RS*sin(alpha)/(B1/2 + RS*cos(alpha)));
        r = real((B1*cos(x) + sqrt(B1^2*cos(x)^2 - 4*B2))/2);
        %Calculation of potential
        for i = 0:M
            if (i == 0)
                p(k+1) = A(i+1)*log(r/RF)/log(RC/RF);
            else
                p(k+1) = p(k+1) + A(i+1)*((r/RC)^(-i*N))...
                    *(1 - (r/RF)^(2*i*N))/(1 - (RC/RF)^(2*i*N))...
                    *cos(i*N*x);
            end
        end
    end
    
end
