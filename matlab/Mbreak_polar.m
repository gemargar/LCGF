%This function computes the maximum potential error
%for various values of M and returns the M that optimizes the potential

function [M,er] = Mbreak_polar(Vo,RC,RF,N)
    
    h = waitbar(0,'Please wait...');
    
    m = 30;
    max = zeros(m,1);
    er = 1;
    gamma = (1/N + 1/2)*180;
    
    for q = 1:m
        A = coefficients(Vo,q,RC,RF,N);
        p = polpot_surface(gamma,A,RC,RF,q,N);
        z = abs(Vo-p);
        n = length(z);
        for k = 1:n
            if max(q) < z(k)
                max(q) = z(k);
            end
        end
        if max(q) < er
            er = max(q);
            M = q;
        end
        waitbar(q/m)
    end
    close(h)
end


