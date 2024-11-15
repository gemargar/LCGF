function smooth_plane(axis_flag,config_flag,ctype_flag,pm_value,Vo,RC,H,N)
    
    % --- LAYOUT ------------------------------------------------------
    
    % Create a figure and then hide the UI as it is constructed.
    plotfigure = figure('Resize','off','Color',0.95*[1 1 1],'Visible','off','Position',[100 100 950 650]);
    % Initialize the UI
    set(plotfigure,'Name','Plots');
    set(plotfigure,'NumberTitle','off');
    set(plotfigure,'Toolbar','none');
    set(plotfigure,'MenuBar','none');
    
    a = sqrt(H^2 - RC^2);
    ksi2 = acosh(H/RC);
    gamma0 = 180;
    gamma = gamma0;
    alpha = 0;
    a_critical = 90;
    dis = 1;
    dis_critical = H - RC;
    E = zeros(1000);
    line_str = [];

    % AXES
    axes('Parent',plotfigure,'Units','pixels','Position',[370 120 530 480]);
    smooth(RC);
    
    % INPUT Display the values of the conductor's voltage, the radiuses
    % of the outer cylinder and the conductor, as well as the number
    % of strands in case the conductor is stranded.
    
    % Panel
    input = uipanel(plotfigure,'Units','pixels','Title','Input',...
        'Visible','on','Position',[30 465 270 165]);
    
    % Strings
    if config_flag == 1
        config_str = 'Configuration: Coaxial';
    elseif config_flag == 2
        config_str = 'Configuration: Conductor-Plane';
    end
    
    if ctype_flag == 1
        ctype_str = 'Conductor Type: Smooth';
    elseif ctype_flag == 2
        ctype_str = 'Conductor Type: Stranded';
    end
    
    H_str = ['Height above plane, H = ',num2str(H),' cm'];
    RC_str = ['Conductor Radius, R = ',num2str(RC),' cm'];
    V_str = ['Conductor Voltage, Vo = ',num2str(Vo),' V'];
    
    % Static texts
    uicontrol(input,'Style','text','String',...
        config_str,'HorizontalAlignment','Left',...
        'Position',[20 120 170 15]);
    uicontrol(input,'Style','text','String',...
        ctype_str,'HorizontalAlignment','Left',...
        'Position',[20 95 170 15]);
    uicontrol(input,'Style','text','String',...
        H_str,'HorizontalAlignment','Left',...
        'Position',[20 70 170 15]);
    uicontrol(input,'Style','text','String',...
        RC_str ,'HorizontalAlignment','Left',...
        'Position',[20 45 170 15]);
    uicontrol(input,'Style','text','String',...
        V_str,'HorizontalAlignment','Left',...
        'Position',[20 20 170 15]);

    % OUTPUT
    Eo = Vo/a*(cosh(ksi2)-cos(pi))/ksi2;
    E_str = ['Emax at conductor surface = ',num2str(Eo),' Volt/cm'];
    % Panel
    output = uipanel(plotfigure,'Title','Output',...
        'Units','pixels','Position',[30 400 270 55]);
    uicontrol(output,'Style','text','String',E_str,'HorizontalAlignment','Left',...
        'Position',[15 15 250 15]);
    
    % EXPRESSION
    % Button Group
    expr = uibuttongroup(plotfigure,'Title','Expression',...
        'Units','pixels','Position',[30 335 270 55]);
    % Radio Buttons
    pot = uicontrol(expr,'Style','radiobutton',...
        'String','Potential','Position',[15 15 70 15]);
    uicontrol(expr,'Style','radiobutton',...
        'String','Field','Position',[100 15 50 15]);
    % Initialization
    set(expr,'SelectionChangeFcn',@expr_selcbk);
    
    % LINE
    % Button Group
    line = uibuttongroup(plotfigure,'Title','Line',...
        'Units','pixels','Position',[30 90 270 235]);
    
    % Radio Button 'Conductor's surface'
    surface = uicontrol(line,'Style','radiobutton',...
        'String','Conductor''s surface','Enable','off',...
        'Position',[15 190 180 20]);
    % Static text
    uicontrol(line,'Style','text','String','Arc:',...
        'HorizontalAlignment','Left','Position',[35 155 30 17]);
    % Edit text
    hgamma = uicontrol(line,'Style','edit','String',num2str(gamma),...
        'Position',[70 155 70 20],'BackgroundColor','w',...
        'Callback',{@gamma_Callback});
    % Static texts
    uicontrol(line,'Style','text','String',['/ ', num2str(gamma0),...
        ' degrees'],'HorizontalAlignment','Left',...
        'Position',[150 155 100 17]);
    
    % Radio Button 'Interlectrode Space'
    uicontrol(line,'Style','radiobutton',...
        'String','Interelectrode space',...
        'Position',[15 120 120 20]);
    % Static text
    uicontrol(line,'Style','text','String','Angle (degrees):',...
        'HorizontalAlignment','Left','Position',[35 90 100 17]);
    % Edit text
    halpha = uicontrol(line,'Style','edit','String','0',...
        'Position',[160 90 70 20],'BackgroundColor','w',...
        'Callback',{@alpha_Callback});
        % Static text
    uicontrol(line,'Style','text','String',...
        'Up to distance from conductor''s surface (cm):',...
        'HorizontalAlignment','Left','Position',[35 35 120 40]);
    % Edit text
    hdis = uicontrol(line,'Style','edit','String','1',...
        'Position',[160 45 70 20],'BackgroundColor','w',...
        'Callback',{@dis_Callback});
        
    % Initialize some button group properties.
    set(line,'SelectionChangeFcn',@line_selcbk);
    set(line,'SelectedObject',[]);  % No selection
    set(hgamma,'Enable','off');
    set(halpha,'Enable','off');
    set(hdis,'Enable','off');
    
    % MESSAGE BOARD
    % Panel
    sms = uipanel(plotfigure,'Units','pixels','Title','Message Board',...
        'Position',[470 30 430 45]);
    % Static texts
    gamma_error = uicontrol(sms,'Style','text','String',...
        ['Arc must be between 0 and ',num2str(gamma0),' degrees.'],...
        'Visible','off','ForegroundColor','r',...
        'HorizontalAlignment','Left','Position',[15 10 400 15]);
    alpha_error = uicontrol(sms,'Style','text','String',...
        ['Angle must be between 0 and ',num2str(a_critical),' degrees.'],...
        'Visible','off','ForegroundColor','r',...
        'HorizontalAlignment','Left','Position',[15 10 400 15]);
    dis_error = uicontrol(sms,'Style','text','String',...
        ['For this given angle, distance must be between 0 and ',...
        num2str(dis_critical),' cm.'],'Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 400 15]);
    
    % PUSH BUTTONS
    hplot = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Plot','Position',[330 30 90 40],...
        'Enable','off','Callback',{@plotbutton_Callback});
    uicontrol(plotfigure,'Style','pushbutton',...
        'String','Reset','Position',[130 30 90 40],...
        'Callback',{@resetbutton_Callback});
    hexport = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Export','Position',[230 30 90 40],...
        'Enable','off','Callback',{@exportbutton_Callback});
    uicontrol(plotfigure,'Style','pushbutton',...
        'String','Back','Position',[30 30 90 40],...
        'Callback',{@backtbutton_Callback});
    
    
    
    % --- CALLBACKS --------------------------------------------------
    
    % EXPRESSION
    % Executes when selection changes
    function expr_selcbk(source,eventdata)
        str = get(eventdata.NewValue,'String');
        switch str
            case 'Potential'
                set(surface,'Enable','off');
            case 'Field'
                set(surface,'Enable','on');
        end
    end

    % LINE
    % Executes when selection changes
    function line_selcbk(source,eventdata)
        str = get(eventdata.NewValue,'String');
        switch str
            case 'Conductor''s surface'
                set(hgamma,'Enable','on');
                set(halpha,'Enable','off');
                set(hdis,'Enable','off');
                if gamma > gamma0
                    smooth(RC);
                    set(hplot,'Enable','off');
                    set(gamma_error,'Visible','on')
                else
                    edge_smooth(gamma,RC);
                    set(hplot,'Enable','on');
                    set(gamma_error,'Visible','off')
                end
            case 'Interelectrode space'
                set(hgamma,'Enable','off');
                set(halpha,'Enable','on');
                set(hdis,'Enable','on');
                alpha = str2double(get(halpha,'String'));
                dis = str2double(get(hdis,'String'));
                if alpha <= a_critical
                    if dis_critical >= dis && dis > 0
                        cutline_smooth(RC,alpha,dis);
                        set(hplot,'Enable','on');
                    end
                else
                    smooth(RC);
                    set(hplot,'Enable','off');
                end
        end
    end
    
    function gamma_Callback(source,eventdata)
        gamma = str2double(get(source,'String'));
        if gamma > gamma0
            set(gamma_error,'Visible','on');
            smooth(RC);
            set(hplot,'Enable','off');
            uicontrol(source)
        else
            set(gamma_error,'Visible','off');
            edge_smooth(gamma,RC);
            set(hplot,'Enable','on');
        end
    end
    
    function alpha_Callback(source,eventdata)
        alpha = str2double(get(source,'String'));
        if alpha <= a_critical
            % Refresh critical distance
            dis_critical = H/cos(alpha*pi/180) - RC;
            if dis_critical >= dis && dis > 0
                set(dis_error,'Visible','off');
                cutline_smooth(RC,alpha,dis);
                set(hplot,'Enable','on');
            else
                set(dis_error,'String',...
                    ['For this given angle, distance must be between 0 and ',...
                    num2str(dis_critical),' cm']);
                set(dis_error,'Visible','on');
            end
            set(alpha_error,'Visible','off');
        else
            set(alpha_error,'Visible','on');
            smooth(RC);
            set(hplot,'Enable','off');
            uicontrol(source)
        end
    end
    
    function dis_Callback(source,eventdata)
        dis = str2double(get(source,'String'));
        if dis_critical >= dis && dis > 0
            alpha = str2double(get(halpha,'String'));
            if alpha <= a_critical
                cutline_smooth(RC,alpha,dis);
                set(hplot,'Enable','on');
            end
            set(dis_error,'Visible','off');
        else
            alpha = str2double(get(halpha,'String'));
            set(dis_error,'String',...
                ['For this given angle, distance must be between 0 and ',...
                num2str(dis_critical),' cm']);
            set(dis_error,'Visible','on');
            smooth(RC);
            set(hplot,'Enable','off');
            uicontrol(source)
        end
    end

    % PUSH BUTTONS
    % 'Plot' button callback
    function plotbutton_Callback(source,eventdata)
        exprObj = get(expr,'SelectedObject');
        expr_str = get(exprObj,'String');
        lineObj = get(line,'SelectedObject');
        line_str = get(lineObj,'String');
        switch line_str
            case 'Conductor''s surface'
                u = convert_bipolar_smooth(RC,H);
                n = length(u);
                deg = 1:n;
                factor = 180/(n-1);
                switch expr_str
                    case 'Field'
                        E = zeros(n,1);
                        for i=1:n
                            E(i) = Vo/a*(cosh(ksi2)-cos(u(i)))/ksi2;
                        end
                        plot(factor*(deg-1),E(deg));
                        xlabel('è (degrees)')
                        ylabel('Electric field (norm) (V/cm)')
                        title('Electric field (norm) at the conductor surface')
                        grid on
                    case 'Potential' % Do nothing
                end
            case 'Interelectrode space'
                alpha = alpha*pi/180;
                [u,ksi] = convert_smooth_alpha(alpha,dis,RC,H);
                n = length(u);
                deg = 1:n;
                factor = dis/(n-1);
                switch expr_str
                    case 'Field'
                        E = zeros(n,1);
                        for i=1:n
                            E(i) = Vo/a*(cosh(ksi(i))-cos(u(i)))/ksi2;
                        end
                        plot(factor*(deg-1),E(deg));
                        xlabel('Distance from conductor surface (cm)')
                        ylabel('Electric field (norm) (V/cm)')
                        title('Electric field (norm) in the interelectrode space')
                        grid on
                    case 'Potential'
                        p = zeros(n,1);
                        for i=1:n
                            p(i) = Vo*ksi(i)/ksi2;
                        end
                        plot(factor*(deg-1),p(deg));
                        xlabel('Distance from conductor surface (cm)')
                        ylabel('Potential (V)')
                        title('Potential in the interelectrode space')
                        grid on
                end
        end
        set(hexport,'Enable','on');
    end
    
    % 'Export' button callback
    function exportbutton_Callback(source,eventdata)
        [File,Folder] = uiputfile('*.csv','Save as');
        hObj = get(expr,'SelectedObject');
        str = get(hObj,'String');
        switch str
            case 'Potential'
                csvwrite(fullfile(Folder,File),p);
            case 'Field'
                csvwrite(fullfile(Folder,File),E);
        end
    end
    
    function resetbutton_Callback(source,eventdata)
        % Re-initialize button group properties.
        set(expr,'SelectedObject',pot);
        set(surface,'Enable','off');
        set(line,'SelectedObject',[]);  % No selection
        % Hide error texts
        set(gamma_error,'Visible','off');
        set(alpha_error,'Visible','off');
        set(dis_error,'Visible','off');
        % Disable push buttons
        set(hplot,'Enable','off');
        set(hexport,'Enable','off');
        % Disable edit texts
        set(hgamma,'Enable','off');
        set(halpha,'Enable','off');
        set(hdis,'Enable','off');
        % Re-initialize edit texts and variables
        set(hgamma,'String',num2str(gamma0));
        gamma = gamma0;
        set(halpha,'String','0');
        alpha = 0;
        set(hdis,'String',1);
        dis = 1;
        dis_critical = H - RC;
        smooth(RC);
    end
    
    % Back button callback
    function backtbutton_Callback(source,eventdata)
        % Initialize unused variables
        next_flag = 1;
        er = 0;
        M = 0;
        A = zeros(10);
        geom(next_flag,axis_flag,config_flag,ctype_flag,pm_value,H,RC,N,Vo,er,M,A);
        close(plotfigure)
    end

    % Move the window to the center of the screen.
    movegui(plotfigure,'center')
    % Make the UI visible
    set(plotfigure,'Visible','on');
    
end


