% This function calculates the field at n points for a given á angle

function p = polpot_alpha(A,alpha,D,RC,RF,M,N)
    
    n = 1001;
    % Initialization
    beta = pi/N;   %Boundary angle
    
    % Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    % Calculation of B1
    B1 = 2*(RC - RS);
    
    % Preallocation
    p = zeros(n,1);
    
    % acritical
    acritical = pi/3 + beta;
    if(alpha>acritical)
        disp('Error');
        return
    end
    
    % Boundary 1cm from surface
    step = D/(n-1);
    
    % Polar coordinates
    
    for k=0:n-1
        % Calculation of distance
        d = RS + k*step;
        % Calculation of coordinates
        x = atan(d*sin(alpha)/(B1/2 + d*cos(alpha)));
        r = sqrt((d*sin(alpha))^2 + (B1/2 + d*cos(alpha))^2);
        % Calculation of electric field
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

