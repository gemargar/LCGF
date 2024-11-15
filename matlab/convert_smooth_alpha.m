% This function calculates u and ksi (bipolar coordinates)
% at n points on the surface of the outer strand for è = 0 to è = ð

function varargout = convert_smooth_alpha(alpha,D,RC,H)
    
    % Initialization
    samples = 1000;% Cut line samples
    step = D/samples;
    
    % Preallocation
    r = zeros(samples,1);
    theta = zeros(samples,1);
    ksi = zeros(samples,1);
    u = zeros(samples,1);
    
    % Polar Coordinates
    for k=1:samples
        %Calculation of distance
        d = RC + (k-1)*step;
        %Calculation of polar coordinates
        theta(k) = alpha;
        r(k) = d;
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
