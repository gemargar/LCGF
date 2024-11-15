% This function calculates the field at n points for a given á angle

function E = fieldalpha_polar(A,alpha,D,RC,RF,M,N)
    
    n = 1001;
    
    % Initialization
    beta = pi/N;   %Boundary angle
    
    % Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    % Calculation of B1
    B1 = 2*(RC - RS);
    
    % Preallocation
    Er = zeros(n,1);
    Et = zeros(n,1);
    E = zeros(n,1);
    
    % Boundary conditions RF
    % D = sqrt(RF^2-(B1/2*sin(alpha))^2) - B1/2*cos(alpha);
    % step = (D-RS)/(n-1);
    
    step = D/(n-1);
    
    % Polar coordinates
    
    for k=0:n-1
        % Calculation of distance
        d = RS + k*step;
        % Calculation of coordinates
        x = atan(d*sin(alpha)/(B1/2 + d*cos(alpha)));
        r = sqrt((d*sin(alpha))^2 + (B1/2 + d*cos(alpha))^2);
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

