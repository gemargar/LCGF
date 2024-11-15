function stranded_plane(axis_flag,config_flag,ctype_flag,pm_value,A,Vo,M,RC,H,N,p_all,er)
    
    % --- Initialization --------------------------------------------------

    % Create a figure and then hide the UI as it is constructed.
    plotfigure = figure('Resize','off','Color',0.95*[1 1 1],'Visible','off','Position',[100 100 950 700]);
    % Initialize the UI
    set(plotfigure,'Name','Plots');
    set(plotfigure,'NumberTitle','off');
    set(plotfigure,'Toolbar','none');
    set(plotfigure,'MenuBar','none');
    
    beta = pi/N;
    RS = RC/(1 + 1/sin(beta));
    B = RC - RS;
    gamma0 = (1/N + 1/2)*180;
    gamma = gamma0;
    alpha = 0;
    a_critical = (pi/3 + beta)*180/pi;
    dis = 1;
    dis_critical = H - B - RS;
    E = zeros(1000);
    line_str = [];
    
    % --- LAYOUT ---------------------------------------------------------
    
    % AXES
    axes('Parent',plotfigure,'Units','pixels','Position',[370 165 530 480]);
    conductor(RC,N);
    
    % INPUT Display the values of the conductor's voltage, the geometrical
    % characteristics and the potential error
    
    % Panel
    input = uipanel(plotfigure,'Units','pixels','Title','Input',...
        'Visible','on','Position',[30 500 270 175]);
    
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
    
    if pm_value == 1
        cname_str = 'Conductor Name: N/A (custom design)';
    elseif pm_value == 2
        cname_str = 'Conductor Name: Falcon';
    elseif pm_value == 3
        cname_str = 'Conductor Name: Catbird';
    elseif pm_value == 4
        cname_str = 'Conductor Name: Linnet';
    elseif pm_value == 5
        cname_str = 'Conductor Name: Thrush';
    end
    
    H_str = ['Height above plane, H = ',num2str(H),' cm'];
    RC_str = ['Conductor Radius, R = ',num2str(RC),' cm'];
    N_str = ['Number of strands, N = ',num2str(N),' strands'];
    V_str = ['Conductor Voltage, Vo = ',num2str(Vo),' V'];
        
    % Static texts
    uicontrol(input,'Style','text','String',...
        cname_str,'HorizontalAlignment','Left',...
        'Position',[20 135 210 15]);
    uicontrol(input,'Style','text','String',...
        config_str,'HorizontalAlignment','Left',...
        'Position',[20 115 170 15]);
    uicontrol(input,'Style','text','String',...
        ctype_str,'HorizontalAlignment','Left',...
        'Position',[20 95 170 15]);
    uicontrol(input,'Style','text','String',...
        H_str,'HorizontalAlignment','Left',...
        'Position',[20 75 170 15]);
    uicontrol(input,'Style','text','String',...
        RC_str ,'HorizontalAlignment','Left',...
        'Position',[20 55 170 15]);
    uicontrol(input,'Style','text','String',...
        N_str,'HorizontalAlignment','Left',...
        'Position',[20 35 170 15]);
    uicontrol(input,'Style','text','String',...
        V_str,'HorizontalAlignment','Left',...
        'Position',[20 15 170 15])
    
    % OUTPUT
    % Panel
    output = uipanel(plotfigure,'Title','Output',...
        'Units','pixels','Position',[30 420 270 75]);
    %Calculation of maximum electric field at conductor surface
    a = sqrt(H^2 - RC^2);
    ksi0 = acosh(H/RC);
    u0 = pi;
    for k = 0:M
        if (k == 0)
            Eksi = -A(k+1);
        else
            Eksi = Eksi - A(k+1)*k*cosh(k*ksi0)*cos(k*u0);
        end
    end
    Eksi = Eksi*(cosh(ksi0)-cos(u0))/a;
    %Calculation of field's norm
    Emax = -Eksi;
    % Strings
    er_str = ['Potential Error : ',num2str(er/Vo*100),' %'];    
    Emax_str = ['Emax at conductor surface = ',num2str(Emax),' V/cm'];
    % Static texts
    uicontrol(output,'Style','text','String',...
        er_str,'HorizontalAlignment','Left',...
        'Position',[20 35 230 15])
    uicontrol(output,'Style','text','String',...
        Emax_str,'HorizontalAlignment','Left',...
        'Position',[20 15 230 15])
    
    % EXPRESSION Select which quantity you want to plot (potential or field) 
    % Button Group
    expr = uibuttongroup(plotfigure,'Title','Expression',...
        'Units','pixels','Position',[30 360 270 55]);
    % Radio Buttons
    pot = uicontrol(expr,'Style','radiobutton',...
        'String','Potential','Position',[15 15 70 15]);
    uicontrol(expr,'Style','radiobutton',...
        'String','Field','Position',[100 15 50 15]);
    
    % LINE Select the surface on which the selected quantity is calculated
    % Button Group
    line = uibuttongroup(plotfigure,'Title','Line',...
        'Units','pixels','Position',[30 90 270 265]);
    % Radio Button 'All strands'
    uicontrol(line,'Style','radiobutton',...
        'String','Strand''s surface - All strands',...
        'Position',[15 220 170 20]);
    % Radio Button 'Lower Strand'
    uicontrol(line,'Style','radiobutton',...
        'String','Strand''s surface - Lower strand',...
        'Position',[15 190 180 20]);
    % Static text
    uicontrol(line,'Style','text','String','Arc:',...
        'HorizontalAlignment','Left','Position',[35 160 30 17]);
    % Edit text
    hgamma = uicontrol(line,'Style','edit','String',num2str(gamma),...
        'Position',[70 160 70 20],'BackgroundColor','w',...
        'Callback',{@gamma_Callback});
    % Static texts
    uicontrol(line,'Style','text','String',['/ ', num2str(gamma0),...
        ' degrees'],'HorizontalAlignment','Left',...
        'Position',[150 160 100 17]);
    % Radio Button 'Interlectrode Space'
    uicontrol(line,'Style','radiobutton',...
        'String','Interelectrode space',...
        'Position',[15 120 120 20]);
    % Static text
    uicontrol(line,'Style','text','String','Angle (degrees):',...
        'HorizontalAlignment','Left','Position',[35 95 100 17]);
    % Edit text
    halpha = uicontrol(line,'Style','edit','String','0',...
        'Position',[160 95 70 20],'BackgroundColor','w',...
        'Callback',{@alpha_Callback});
        % Static text
    uicontrol(line,'Style','text','String',...
        'Up to distance from conductor''s surface (cm):',...
        'HorizontalAlignment','Left','Position',[35 40 120 40]);
    % Edit text
    hdis = uicontrol(line,'Style','edit','String','1',...
        'Position',[160 50 70 20],'BackgroundColor','w',...
        'Callback',{@dis_Callback});
    
    % Initialize some button group properties.
    set(line,'SelectionChangeFcn',@selcbk);
    set(line,'SelectedObject',[]);  % No selection
    set(hgamma,'Enable','off');
    set(halpha,'Enable','off');
    set(hdis,'Enable','off');
    
    % MESSAGE BOARD
    % Panel
    sms = uipanel(plotfigure,'Units','pixels','Title','Message Board',...
        'Position',[470 30 430 50]);
    % Static texts
    alpha_error = uicontrol(sms,'Style','text','String',...
        ['Angle must be between 0 and ',num2str(a_critical),' degrees'],...
        'Visible','off','ForegroundColor','r',...
        'HorizontalAlignment','Left','Position',[15 10 400 15]);
    gamma_error = uicontrol(sms,'Style','text','String',...
        ['Arc must be between 0 and ',num2str(gamma0),' degrees'],...
        'Visible','off','ForegroundColor','r',...
        'HorizontalAlignment','Left','Position',[15 10 400 15]);
    dis_error = uicontrol(sms,'Style','text','String',...
        ['For this given angle, distance must be between 0 and ',...
        num2str(dis_critical),' cm'],'Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 400 15]);
    warning = uicontrol(sms,'Style','text','String',...
        ['The electirc field strength at the interfaces between strands ',...
        'is incorrectly intensified due to numerical errors.'],'Visible','off',...
        'ForegroundColor','r','Max',2,...
        'HorizontalAlignment','Left','Position',[10 5 400 30]);
    
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
    
    % LINE
    % Executes when selection changes
    function selcbk(source,eventdata)
        str = get(eventdata.NewValue,'String');
        switch str
            case 'Strand''s surface - All strands'
                set(hgamma,'Enable','off');
                set(halpha,'Enable','off');
                set(hdis,'Enable','off');
                set(hplot,'Enable','on');
                edge_bipolar(RC,N);
            case 'Strand''s surface - Lower strand'
                set(hgamma,'Enable','on');
                set(halpha,'Enable','off');
                set(hdis,'Enable','off');
                if gamma > gamma0
                    conductor(RC,N);
                    set(hplot,'Enable','off');
                else
                    edge(gamma,RC,N);
                    set(hplot,'Enable','on');
                end
            case 'Interelectrode space'
                set(hgamma,'Enable','off');
                set(halpha,'Enable','on');
                set(hdis,'Enable','on');
                alpha = str2double(get(halpha,'String'));
                dis = str2double(get(hdis,'String'));
                if alpha <= a_critical
                    if dis_critical >= dis && dis > 0
                        cutline(RC,N,alpha,dis);
                        set(hplot,'Enable','on');
                    end
                else
                    conductor(RC,N);
                    set(hplot,'Enable','off');
                end
        end
        set(warning,'Visible','off')
    end
    
    function gamma_Callback(source,eventdata)
        gamma = str2double(get(source,'String'));
        if ~(gamma <= gamma0)
            set(gamma_error,'Visible','on');
            conductor(RC,N);
            set(hplot,'Enable','off');
            uicontrol(source)
        else
            set(gamma_error,'Visible','off');
            edge(gamma,RC,N);
            set(hplot,'Enable','on');
        end
        set(warning,'Visible','off')
    end
    
    function alpha_Callback(source,eventdata)
        alpha = str2double(get(source,'String'));
        if alpha <= a_critical
            % Refresh critical distance
            dis_critical = (H - B)/cos(alpha*pi/180) - RS;
            if dis_critical >= dis && dis > 0
                set(dis_error,'Visible','off');
                cutline(RC,N,alpha,dis);
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
            conductor(RC,N);
            set(hplot,'Enable','off');
            uicontrol(source)
        end
        set(warning,'Visible','off')
    end
    
    function dis_Callback(source,eventdata)
        dis = str2double(get(source,'String'));
        if dis_critical >= dis && dis > 0
            alpha = str2double(get(halpha,'String'));
            if alpha <= a_critical
                cutline(RC,N,alpha,dis);
                set(hplot,'Enable','on');
            end
            set(dis_error,'Visible','off');
        else
            alpha = str2double(get(halpha,'String'));
            set(dis_error,'String',...
                ['For this given angle, distance must be between 0 and ',...
                num2str(dis_critical),' cm']);
            set(dis_error,'Visible','on');
            conductor(RC,N);
            set(hplot,'Enable','off');
            uicontrol(source)
        end
        set(warning,'Visible','off')
    end
    
    % PUSH BUTTONS
    % --- 'Plot' button callback ----------------
    function plotbutton_Callback(source,eventdata)
        exprObj = get(expr,'SelectedObject');
        expr_str = get(exprObj,'String');
        lineObj = get(line,'SelectedObject');
        line_str = get(lineObj,'String');
        switch expr_str
            case 'Field'
                switch line_str
                    case 'Strand''s surface - All strands'
                        [u,ksi] = convert_bipolar(RC,H,N);
                        E = fieldsurface_bipolar(u,ksi,A,RC,H,N,M);
                        n = length(E);
                        deg = 1:n;
                        factor = 180/(n-1);
                        plot(factor*(deg-1),E(deg));
                        xlabel('è (degrees)')
                        ylabel('Eletric field (norm) (V/cm)')
                        title('Electric field (norm) at the conductor surface')
                        grid on
                        set(warning,'Visible','on')
                    case 'Strand''s surface - Lower strand'
                        [u,ksi] = convert_bipolar_gamma(gamma,RC,H,N);
                        E = fieldsurface_bipolar(u,ksi,A,RC,H,N,M);
                        n = length(E);
                        deg = 1:n;
                        factor = gamma/(n-1);
                        plot(factor*(deg-1),E(deg));
                        xlabel('á (degrees)')
                        ylabel('Electric field (norm) (V/cm)')
                        title('Electric field at the strand surface')
                        grid on
                        set(warning,'Visible','on')
                    case 'Interelectrode space'
                        alpha = alpha*pi/180;
                        E = fieldalpha_bipolar(A,alpha,dis,RC,H,N,M);
                        n = length(E);
                        deg = 1:n;
                        factor = dis/(n-1);
                        plot(factor*(deg-1),E(deg));
                        xlabel('Distance from stand surface (cm)')
                        ylabel('Electric field (norm) (V/cm)')
                        title('Electric field (norm) in the interelectrode space')
                        grid on
                end
            case 'Potential'
                switch line_str
                    case 'Strand''s surface - All strands'
                        n = length(p_all);
                        zzz = zeros(n,1);
                        deg = 1:n;
                        factor = 180/(n-1);
                        plot(factor*(deg-1),p_all(deg),'b',factor*(deg-1),zzz,'r');
                        xlabel('è (degrees)')
                        ylabel('Potential Error (%)')
                        title('Potential error (%) at the conductor surface')
                        grid on
                    case 'Strand''s surface - Lower strand'
                        [u,ksi] = convert_bipolar_gamma(gamma,RC,H,N);
                        p = bipolpot_surface(u,ksi,A,M);
                        p = (p-Vo)/Vo*100;
                        n = length(p);
                        zzz = zeros(n,1);
                        deg = 1:n;
                        factor = gamma/(n-1);
                        plot(factor*(deg-1),p(deg),'b',factor*(deg-1),zzz,'r');
                        xlabel('á (degrees)')
                        ylabel('Potential Error (%)')
                        title('Potential error (%) at the strand surface')
                        grid on
                    case 'Interelectrode space'
                        alpha = alpha*pi/180;
                        p = bipolpot_alpha(A,alpha,dis,RC,H,M,N);
                        n = length(p);
                        deg = 1:n;
                        factor = dis/(n-1);
                        plot(factor*(deg-1),p(deg));
                        xlabel('Distance from stand surface (cm)')
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
        dis_critical = H - B -RS;
        conductor(RC,N);
        set(warning,'Visible','off')
    end
    
    % Back button callback
    function backtbutton_Callback(source,eventdata)
        next_flag = 1;
        geom(next_flag,axis_flag,config_flag,ctype_flag,pm_value,H,RC,N,Vo,er,M,A,p_all);
        close(plotfigure)
    end    
    
    % Move the window to the center of the screen.
    movegui(plotfigure,'center')
    % Make the UI visible
    set(plotfigure,'Visible','on');
    
end


