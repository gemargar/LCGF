% This function plots the conductor for given RC and N

function edge(gamma,RC,N)

    beta = pi/N;
    gamma = gamma*pi/180;
    
    %Calculation of strand radius
    RS = RC/(1 + 1/sin(beta));
    
    %Calculation of B and theta
    B = RC-RS;
    theta = 0:pi/100:2*pi;
    
    for i=0:N-1
        x = B*cos(2*i*beta-pi/2) + RS*cos(theta);
        y = B*sin(2*i*beta-pi/2) + RS*sin(theta);
        plot(x,y,'k')
        hold on
    end
    
    theta = 0:pi/100:gamma;
    x = B*cos(-pi/2) + RS*cos(theta-pi/2);
    y = B*sin(-pi/2) + RS*sin(theta-pi/2);
    plot(x,y,'r','LineWidth',2)
    
    step = RC/50;
    x = -1.5*RC:step:1.5*RC;
    y = -1.5*RC:step:1.5*RC;
    zzz = zeros(length(x),1);
    plot(x,zzz,'k-.')
    plot(zzz,y,'k-.')
    xlabel('cm')
    ylabel('cm')
    axis equal
    hold off
  
end

