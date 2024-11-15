%This function calculates the coefficients of equation 3.107

function A = coefficients(Vo,M,RC,RF,N)
    
    %Initialization
    beta = pi/N;   %Boundary angle
    step = beta/1000;
    
    %Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    %Calculation of B1 and B2
    B1 = 2*(RC - RS);
    B2 = (RC - RS)^2 - RS^2;
    
    % function r(x)
    r = @(x) real((B1*cos(x) + sqrt(B1^2*cos(x).^2 - 4*B2))/2);
    
    % %Memory allocation
    W = zeros(M+1,1);
    V = zeros(M+1,M+1);
    A = zeros(M+1,1);
    
    x = 0:step:beta;
    
    %Initialization
    U0 = log(r(x)/RF)/log(RC/RF);
    Um = @(m) ((r(x)/RC).^(-m*N))...
        .*(1 - (r(x)/RF).^(2*m*N))./(1 - (RC/RF)^(2*m*N))...
        .*cos(m*N*x);
    
    %Calculation of Wi
    for i = 0:M
        if (i == 0)
            W(1) = Vo*trapz(U0,x);
        else
            Ui = Um(i);
            W(i+1) = Vo*trapz(Ui,x);
        end
    end
    
    %Calculation of Vij
    for i = 0:M
        if (i == 0)
            for j = 0:M
                if (j == 0)
                    U00 = U0.*U0;
                    V(1,1) = trapz(U00,x);
                else
                    Uj = Um(j);
                    U0j = U0.*Uj;
                    V(1,j+1) = trapz(U0j,x);
                end
            end
        else
            for j = 0:M
                if (j == 0)
                    Ui = Um(i);
                    Ui0 = Ui.*U0;
                    V(i+1,1) = trapz(Ui0,x);
                else
                    Ui = Um(i);
                    Uj = Um(j);
                    Uij = Ui.*Uj;
                    V(i+1,j+1) = trapz(Uij,x);
                end
            end
        end
    end
    
    %Calculation of A
    % A = V\W;
    
    %Calculation of A using Gauss Elimination
    [L,U] = lu(V);
    A = U\(L\W);
    
    %Calculation of A using Gauss Elimination with row permutations
    % [L,U,P] = lu(V);
    % A = U\(L\P*W);
    
    %Calculation of A using Gauss Elimination with Complete Pivoting
    % [P,L,U,Q] = GaElCoPi(V);
    % A = Q*(U\(L\P*W));
    
end
