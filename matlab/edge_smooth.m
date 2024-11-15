% This function plots the conductor for given RC and N

function edge_smooth(gamma,RC)

    gamma = gamma*pi/180;
    theta = 0:pi/100:2*pi;
    
    x = RC*cos(theta);
    y = RC*sin(theta);
    plot(x,y,'k')
    hold on
    
    theta = 0:pi/100:gamma;
    x = RC*cos(theta-pi/2);
    y = RC*sin(theta-pi/2);
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

