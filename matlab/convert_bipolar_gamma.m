% This function calculates u and ksi (bipolar coordinates)
% at n points on the surface of the outer strand for è = 0 to è = ð

function varargout = convert_bipolar_gamma(gamma,RC,H,N)
    
    % Initialization
    beta = pi/N;   % Boundary angle
    samples = 1000;% Samples for each strand
    gamma = gamma*pi/180;
    step = gamma/samples;
    
    % Preallocation
    r = zeros(samples+1,1);
    theta = zeros(samples+1,1);
    ksi = zeros(samples+1,1);
    u = zeros(samples+1,1);
    
    % Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    % Calculation of B1 and B2
    B1 = 2*(RC - RS);
    B2 = (RC - RS)^2 - RS^2;
    
    alpha = 0:step:gamma;
    
    % Build the polar vectors
    for i=1:(samples+1)
        theta(i) = atan(RS*sin(alpha(i))/(B1/2 + RS*cos(alpha(i))));
        r(i) = real((B1*cos(theta(i)) + sqrt(B1^2*cos(theta(i)).^2 - 4*B2))/2);
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
