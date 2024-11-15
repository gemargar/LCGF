% This function plots the conductor for given RC and N

function cutline_smooth(RC,alpha,D)

    samples = 1000;
    alpha = alpha*pi/180;  
    theta = 0:pi/100:2*pi;
    
    x = RC*cos(theta);
    y = RC*sin(theta);
    plot(x,y,'k')
    hold on
    
    if alpha == pi/2
        xstart = RC;
        xstop = RC + D;
        xstep = (xstop - xstart)/samples;
        x = xstart:xstep:xstop;
        y = zeros(length(x),1);
        plot(x,y,'r')
    elseif alpha == 0
        ystart = -RC;
        ystop = -RC-D;
        ystep = (ystop - ystart)/samples;
        y = ystart:ystep:ystop;
        x = zeros(length(y),1);
        plot(x,y,'r')
    else
        xstart = RC*cos(alpha-pi/2);
        xstop = (RC+D)*cos(alpha-pi/2);
        xstep = (xstop - xstart)/samples;
        x = xstart:xstep:xstop;
        ystart = RC*sin(alpha-pi/2);
        ystop = (RC+D)*sin(alpha-pi/2);
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
