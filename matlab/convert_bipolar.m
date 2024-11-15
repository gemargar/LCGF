% This function calculates u and ksi (bipolar coordinates)
% at n points on the surface of the outer strand for è = 0 to è = ð

function varargout = convert_bipolar(RC,H,N)
    
    % Initialization
    beta = pi/N;   % Boundary angle
    samples = 1000;% Samples for each strand
    step = beta/samples;
    
    % Preallocation
    r = zeros((N-2)*samples+1,1);
    theta = zeros((N-2)*samples+1,1);
    ksi = zeros((N-2)*samples+1,1);
    u = zeros((N-2)*samples+1,1);
    
    % Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    % Calculation of B1 and B2
    B1 = 2*(RC - RS);
    B2 = (RC - RS)^2 - RS^2;
    
    x = 0:step:beta;
    
    % Build the polar vectors
    for i=0:2:(N-2)
        % Down
        for j=1:(samples+1)
            r(i*samples + j) = real((B1*cos(x(j)) + ...
                sqrt(B1^2*cos(x(j)).^2 - 4*B2))/2);
            theta(i*samples + j) = i*beta + x(j);
        end
        % Up
        for j=1:(samples+1)
            r((i+1)*samples + j) = real((B1*cos(beta - x(j)) + ...
                sqrt(B1^2*cos(beta - x(j)).^2 - 4*B2))/2);
            theta((i+1)*samples + j) = (i+1)*beta + x(j);
        end
    end
       
    % Check for odd number of strands
    if i ~= (N-2)
        i = (N-1);
        % build the remaining polar vectors -> Down
        for j=1:(samples+1)
            r(i*samples + j) = real((B1*cos(x(j)) + ...
                sqrt(B1^2*cos(x(j)).^2 - 4*B2))/2);
            theta(i*samples + j) = i*beta + x(j);
        end
    end
  
    % Coefficients
    a = sqrt(H^2 - RC^2);
    b = H - a;
    c = H + a;
    
    % Distances from poles
    d1 = sqrt(r.^2 + c^2 - 2*c*r.*cos(theta));
    d2 = sqrt(r.^2 + b^2 - 2*b*r.*cos(theta));
    
    % Bipolar coordinates
    ksi = log(d1./d2);
    num = d1.^2 + d2.^2 - (2*a)^2;
    den = 2*d1.*d2;
    u = real(acos(num./den));
    
    nOutputs = nargout;
    varargout = cell(1,nOutputs);
    
    switch nOutputs
        case 1
            varargout{1} = u;
        case 2
            varargout{1} = u;
            varargout{2} = ksi;
    end
    
end
