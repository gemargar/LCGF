% This function calculates u and ksi (bipolar coordinates)
% at n points on the surface of the outer strand for è = 0 to è = ð

function varargout = convert_bipolar_alpha(alpha,D,RC,H,N)
    
    % Initialization
    beta = pi/N;   % Boundary angle
    samples = 1000;% Cut line samples
    step = D/samples;
    
    % Preallocation
    r = zeros(samples,1);
    theta = zeros(samples,1);
    ksi = zeros(samples,1);
    u = zeros(samples,1);
    
    % Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    % Calculation of B1 and B2
    B = RC - RS;
    
    % Polar Coordinates
    for k=1:samples
        %Calculation of distance
        d = RS + (k-1)*step;
        %Calculation of polar coordinates
        theta(k) = atan(d*sin(alpha)/(B + d*cos(alpha)));
        r(k) = sqrt((d*sin(alpha))^2 + (B + d*cos(alpha))^2);
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
