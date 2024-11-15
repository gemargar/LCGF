% This function calculates the field at n points on the surface of
% an outer strand for a = 0 to a = ð/2+â

function E = fieldsurface_polar(gamma,A,RC,RF,M,N)

    n = 1001;
    % Initialization
    beta = pi/N;   %Boundary angle
    
    % Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    % Calculation of B1 and B2
    B1 = 2*(RC - RS);
    B2 = (RC - RS)^2 - RS^2;
    
    % Preallocation
    Er = zeros(n,1);
    Et = zeros(n,1);
    E = zeros(n,1);
    
    % Angles
    gamma = gamma*pi/180;
    step = gamma/(n-1);
    
    % Polar coordinates
    
    for k=0:(n-1)
        % Calculation of alpha
        alpha = k*step;
        % Calculation of coordinates
        x = atan(RS*sin(alpha)/(B1/2 + RS*cos(alpha)));
        r = real((B1*cos(x) + sqrt(B1^2*cos(x)^2 - 4*B2))/2);
        % Calculation of electric field
        for i = 0:M
            if (i == 0)
                Er(k+1) = -A(i+1)*1/log(RC/RF)/r;
                Et(k+1) = 0;
            else
                Er(k+1) = Er(k+1) + A(i+1)*((r/RC)^(-i*N))...
                    *(1 + (r/RF)^(2*i*N))/(1 - (RC/RF)^(2*i*N))...
                    *cos(i*N*x)*(i*N)/r;
                Et(k+1) = Et(k+1) + A(i+1)*((r/RC)^(-i*N))...
                    *(1 - (r/RF)^(2*i*N))/(1 - (RC/RF)^(2*i*N))...
                    *sin(i*N*x)*(i*N)/r;
            end
        end
        % Calculation of field's norm
        E(k+1) = sqrt(Er(k+1)^2 + Et(k+1)^2);
    end

end
