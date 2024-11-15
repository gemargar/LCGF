function polplots(Vo,M,RC,RF,N)
    
    % Create a figure and then hide the UI as it is constructed.
    plotfigure = figure('Visible','off','Position',[360 360 900 540]);
    % Initialize the UI
    set(plotfigure,'Name','Gooey');
    set(plotfigure,'NumberTitle','off');
    set(plotfigure,'Toolbar','none');
    set(plotfigure,'MenuBar','none');
    
    RS = RC/(1 + 1/sin(pi/N));
    
    % Axes
    plotaxes = axes('Parent',plotfigure,'Units','pixels',...
        'Position',[70 70 450 400]);
    conductor(RC,N);
    
    
    % ----- Input ----------------------------------------------------
    % INPUT Display the values of the conductor's voltage, the radiuses
    % of the outer cylinder and the conductor, as well as the number
    % of strands in case the conductor is stranded.
    
    % Panel
    input = uipanel(plotfigure,'Units','pixels','Title','Input Data',...
        'Visible','on','Position',[600 320 200 150]);
    
    % Strings
    RF_str = ['Outer Cylinder Radius, RF = ',num2str(RF),' cm'];
    RC_str = ['Conductor Radius, R = ',num2str(RC),' cm'];
    N_str = ['Number of strands, N = ',num2str(N),' strands'];
    V_str = ['Conductor Voltage, Vo = ',num2str(Vo),' Volt'];
    
    % Static texts
    RFtxt = uicontrol(input,'Style','text','String',...
        RF_str,'HorizontalAlignment','Left',...
        'Position',[20 110 170 15]);
    RCtxt = uicontrol(input,'Style','text','String',...
        RC_str ,'HorizontalAlignment','Left',...
        'Position',[20 80 170 15]);
    Ntxt = uicontrol(input,'Style','text','String',...
        N_str,'HorizontalAlignment','Left',...
        'Position',[20 50 170 15]);
    Vtxt = uicontrol(input,'Style','text','String',...
        V_str,'HorizontalAlignment','Left',...
        'Position',[20 20 170 15]);
    
    % ----- End of Input ------------------------------------------------
    
    
    
    % ---- Expression --------------------------------------------
    
    % Button Group
    expr = uibuttongroup(plotfigure,'Title','Expression',...
        'Units','pixels','Position',[600 220 160 85]);
    % Radio Buttons
    rb1 = uicontrol(expr,'Style','radiobutton',...
        'String','Potential','Position',[15 45 70 20]);
    rb2 = uicontrol(expr,'Style','radiobutton',...
        'String','Field','Position',[15 15 100 20]);
    
    % Initialize some button group properties.
    set(expr,'SelectedObject',[]);  % No selection
    set(expr,'Visible','on');
    
    % ----- End of Expression -------------------------------------
    
    
    
    % ---- Line ----------------------------------------
    
    % Button Group
    line = uibuttongroup(plotfigure,'Title','Area',...
        'Units','pixels','Position',[600 100 160 120]);
    % Radio Buttons
    hr1 = uicontrol(line,'Style','radiobutton',...
        'String','Strand''s surface',...
        'Position',[15 80 100 20]);
    hr2 = uicontrol(line,'Style','radiobutton',...
        'String','Interelectrode space',...
        'Position',[15 50 120 20]);
    % Static text
    htext0 = uicontrol(line,'Style','text',...
        'String','Angle:',...
        'Position',[15 15 50 20]);
    % Edit text
    halpha = uicontrol(line,'Style','edit',...
        'String','0',...
        'Position',[70 15 70 20],...
        'Callback',{@alpha_Callback});
    
    % Initialize some button group properties.
    set(line,'SelectionChangeFcn',@selcbk);
    set(line,'SelectedObject',[]);  % No selection
    % Executes when selection changes
    function selcbk(source,eventdata)
        str = get(eventdata.NewValue,'String');
        switch str
            case 'Strand''s surface'
                set(halpha,'Enable','off');
                edge(RC,N);
            case 'Interelectrode space'
                set(halpha,'Enable','on');
                alpha = str2double(get(halpha,'String'));
                cutline(RC,N,alpha);
        end
    end
    
    function alpha_Callback(source,eventdata)
        alpha = str2double(get(source,'String'));
        cutline(RC,N,alpha);
    end
    
    % --- End of Line ---------------------------------------
    
    
    
    % --- Push Buttons ---------------------------------------------
    
    hsplot = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Plot','Position',[600 70 70 25],...
        'Callback',{@plotbutton_Callback});
    
    hreset = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Reset','Position',[700 70 70 25],...
        'Callback',{@resetbutton_Callback});
    
    hexport = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Export','Position',[800 70 70 25],...
        'Callback',{@exportbutton_Callback});
    
    % --- 'Plot' button callback ----------------
    function plotbutton_Callback(source,eventdata)
        exprObj = get(expr,'SelectedObject');
        expr_str = get(exprObj,'String');
        areaObj = get(line,'SelectedObject');
        area_str = get(areaObj,'String');
        switch expr_str
            case 'Field'
                switch area_str
                    case 'Strand''s surface'
                        E = fieldsurface(Vo,M,RC,RF,N);
                        deg = 1:101;
                        gamma = pi/N + pi/2;
                        i2d = gamma*1.8/pi;
                        plot(i2d*(deg-1),E);
                        axis([0 i2d*100 -Inf Inf])
                        xlabel('á (degrees)')
                        ylabel('Field norm (V/cm)')
                        title('Electric field on the strand''s surface')
                    case 'Interelectrode space'
                        alpha = str2double(get(halpha,'String'));
                        alpha = alpha*pi/180;
                        E = fieldalpha(alpha,Vo,M,RC,RF,N);
                        deg = 1:101;
                        D = 1 + RS;
                        i2cm = (D-RS)/100;
                        plot(i2cm*(deg-1),E);
                        xlabel('Distance from stand''s surface (cm)')
                        ylabel('Field norm (V/cm)')
                        title('Electric field in the interelectrode space')
                end
            case 'Potential'
                switch area_str
                    case 'Strand''s surface'
                        n = 1001;
                        p = polpot_surface(Vo,M,RC,RF,N,n);
                        p = (p-Vo)/Vo;
                        n = length(p);
                        deg = 1:n;
                        gamma = pi/N + pi/2;
                        factor = gamma*180/pi/(n-1);
                        plot(factor*(deg-1),p,'b',factor*(deg-1),0,'r');
                        xlabel('á (degrees)')
                        ylabel('Potential error (%)')
                        title('Potential error on the strand''s surface')
                    case 'Interelectrode space'
                        alpha = str2double(get(halpha,'String'));
                        alpha = alpha*pi/180;
                        p = polpot_alpha(alpha,Vo,M,RC,RF,N);
                        deg = 1:101;
                        D = 1 + RS;
                        i2cm = (D-RS)/100;
                        plot(i2cm*(deg-1),p);
                        xlabel('Distance from stand''s surface (cm)')
                        ylabel('Potential (V)')
                        title('Electric potential in the interelectrode space')
                end
        end
    end
    
    % 'Export' button callback
    function exportbutton_Callback(source,eventdata)
        hObj = get(h,'SelectedObject');
        str = get(hObj,'String');
        switch str
            case 'Strand''s surface'
                E = fieldsurface(Vo,M,RC,RF,N);
                assignin('base', 'E', E);
            case 'Interelectrode space'
                alpha = str2double(get(halpha,'String'));
                alpha = alpha*pi/180;
                E = field_alpha(alpha,Vo,M,RC,RF,N);
                assignin('base', 'E', E);
        end
    end
    
    function resetbutton_Callback(source,eventdata)
        set(expr,'SelectedObject',[]);  % No selection
        set(line,'SelectedObject',[]);  % No selection
        set(halpha,'Value',0);
        conductor(RC,N);
    end
    
    % Move the window to the center of the screen.
    movegui(plotfigure,'center')
    % Make the UI visible
    set(plotfigure,'Visible','on');
    
end


