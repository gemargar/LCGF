%This function computes the maximum and average potential error
%for various values of M and breaks when error is less than 1e-8.

function [A,M,p,er] = Mbreak_bipolar(Vo,RC,H,N)
    
    M = 70;
    max = 0;
    
    [u,ksi] = convert_bipolar(RC,H,N);
    A = coefficients_bipolar(RC,H,N,Vo,M);
    p = bipolpot_surface(u,ksi,A,M);
    n = length(p);
    z = abs(Vo-p);
    for i = 1:n
        if max < z(i)
            max = z(i);
        end
    end
    er = max;

end


