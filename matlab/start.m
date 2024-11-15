function start
    
    % Initialization of geom.fig features. Each feature has a flag, which
    % "remembers" its state when plot functions are called. The
    % reason for the existence of these flags is that the user should have the ability
    % to return back to geom. Therefore these flags cannot be initialized in geom,
    % because they would be re-initialized its time geom function is called.
    axis_flag = 0;
    % axis_flag indicates what geom.axes shows for stranded conductor type.
    % In case of sufficient input, a conductor is plotted and axis_flag is set to 1.
    % If conductor type is changed to smooth and then back to stranded, axis_flag = 1
    % "remembers" if the input is sufficient, therfore a conductor is plotted again. 
    % If the input is not sufficient (axis_flag = 0), an image is shown instead.
    config_flag = 1;
    ctype_flag = 1;
    RF = 0;
    RC = 0;
    N = 0;
    Vo = 1;
    er = 0;
    pm_value = 1;
    M = 0;
    A = zeros(10);
    p = zeros(1000);
    next_flag = 0;
    
    % Figure & Picture of Mitsaras
    f = figure('Resize','off','Color',0.95*[1 1 1],'Position',[400 200 550 380]);
    set(f,'MenuBar','none');
    mitsaras = imread('pictures/AUTH_logo.png',...
        'BackgroundColor',0.95*[1 1 1]);
    ax = axes('Units','pixels','Position',[20 175 200 200]);
    imshow(mitsaras,'Parent',ax)
    
    %Start Button
    start = uicontrol(f,'Style','pushbutton','String','Start',...
        'Position',[450 30 70 30],'Callback',{@start_callback});
    uicontrol(start)
    
    % High Voltage Lab Info
    uicontrol(f,'Style','text','String','Aristotle University of Thessaloniki',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 320 200 20]);
    uicontrol(f,'Style','text','String','Faculty of Engineering',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 300 200 20]);
    uicontrol(f,'Style','text','String','School of Electrical and Computer Engineering',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 280 300 20]);
    uicontrol(f,'Style','text','String','High Voltage Laboratory',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 260 200 20]);
    uicontrol(f,'Style','text','String','Building D, Egnatia Str., Thessaloniki 54124, Greece',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 240 300 20]);
    uicontrol(f,'Style','text','String','Tel/Fax: +30 2310 995860, e-mail: hvl@eng.auth.gr',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 220 300 20]);
    uicontrol(f,'Style','text','String','URL: http://www.eng.auth.gr/hvl/',...
        'HorizontalAlignment','Left','Units','pixels','Position',[220 200 300 20]);
    
    % My info
    uicontrol(f,'Style','text','String','Margaritis Georgios',...
        'HorizontalAlignment','Left','Units','pixels','Position',[30 70 200 20]);
    uicontrol(f,'Style','text','String','Diploma Thesis',...
        'HorizontalAlignment','Left','Units','pixels','Position',[30 50 200 20]);
    uicontrol(f,'Style','text','String','Thessaloniki 2017',...
        'HorizontalAlignment','Left','Units','pixels','Position',[30 30 300 20]);
    
    % Application Name
    uicontrol(f,'Style','text','String','LINE CONDUCTOR GEOMETRICAL FIELD',...
        'HorizontalAlignment','Center','Units','pixels',...
        'FontSize',16,'Position',[50 100 450 50]);
        
    function start_callback(source,eventdata)
        geom(next_flag,axis_flag,config_flag,ctype_flag,pm_value,RF,RC,N,Vo,er,M,A,p);
        close(f)
    end

    % Initialize the UI
    set(f,'Name','Start');
    set(f,'NumberTitle','off');
    set(f,'Toolbar','none');
    set(f,'MenuBar','none');
    % Move the window to the center of the screen.
    movegui(f,'center')
    % Make the UI visible
    set(f,'Visible','on');
    
end

