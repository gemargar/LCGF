%This function calculates the coefficients of equation 3.107

function A = coefficients_bipolar(RC,H,N,Vo,M)
    
    h = waitbar(0,'Please wait...');
    
    % %Memory allocation
    W = zeros(M+1,1);
    V = zeros(M+1,M+1);
    A = zeros(M+1,1);
    
    [u,ksi] = convert_bipolar(RC,H,N);
    
    %Initialization
    U0 = ksi;
    Uk = @(k) sinh(k*ksi).*cos(k*u);
    
    %Calculation of Wi
    for i = 0:M
        if (i == 0)
            W(1) = Vo*trapz(u,U0);
        else
            Ui = Uk(i);
            W(i+1) = Vo*trapz(u,Ui);
        end
    end
    
    %Calculation of Vij
    for i = 0:M
        if (i == 0)
            for j = 0:M
                if (j == 0)
                    U00 = U0.*U0;
                    V(1,1) = trapz(u,U00);
                else
                    Uj = Uk(j);
                    U0j = U0.*Uj;
                    V(1,j+1) = trapz(u,U0j);
                end
            end
        else
            for j = 0:M
                if (j == 0)
                    Ui = Uk(i);
                    Ui0 = Ui.*U0;
                    V(i+1,1) = trapz(u,Ui0);
                else
                    Ui = Uk(i);
                    Uj = Uk(j);
                    Uij = Ui.*Uj;
                    V(i+1,j+1) = trapz(u,Uij);
                end
            end
        end
        waitbar(i/M)
    end
 
    %Calculation of A using Gauss Elimination
    [L,U] = lu(V);
    A = U\(L\W);
    
    close(h)
    
end

