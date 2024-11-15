% This function plots the conductor for given RC and N

function cutline(RC,N,alpha,D)

    samples = 1000;
    beta = pi/N;
    alpha = alpha*pi/180;
    
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
    
    if alpha == pi/2
        xstart = RS;
        xstop = RS + D;
        xstep = (xstop - xstart)/samples;
        x = xstart:xstep:xstop;
        y = -B*ones(length(x),1);
        plot(x,y,'r')
    elseif alpha == 0
        ystart = -RC;
        ystop = -RC-D;
        ystep = (ystop - ystart)/samples;
        y = ystart:ystep:ystop;
        x = zeros(length(y),1);
        plot(x,y,'r')
    else
        xstart = RS*cos(alpha-pi/2);
        xstop = (RS+D)*cos(alpha-pi/2);
        xstep = (xstop - xstart)/samples;
        x = xstart:xstep:xstop;
        ystart = -B + RS*sin(alpha-pi/2);
        ystop = -B + (RS+D)*sin(alpha-pi/2);
        ystep = (ystop - ystart)/samples;
        y = ystart:ystep:ystop;
        plot(x,y,'r')
    end

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