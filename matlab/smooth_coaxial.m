function smooth_coaxial(axis_flag,config_flag,ctype_flag,pm_value,Vo,RC,RF,N)
    
    % --- LAYOUT ----------------------------------------------------

    % Create a figure and then hide the UI as it is constructed.
    plotfigure = figure('Resize','off','Color',0.95*[1 1 1],'Visible','off','Position',[100 100 950 650]);
    % Initialize the UI
    set(plotfigure,'Name','Plots');
    set(plotfigure,'NumberTitle','off');
    set(plotfigure,'Toolbar','none');
    set(plotfigure,'MenuBar','none');
    
    dis = 1;
    dis_critical = RF - RC;
    samples = 1000;
    E = zeros(samples+10);
    p = zeros(samples+10);

    % AXES
    axes('Parent',plotfigure,'Units','pixels','Position',[370 120 530 480]);
    smooth(RC);
    
    % INPUT Display the values of the conductor's voltage, the radiuses
    % of the outer cylinder and the conductor, as well as the number
    % of strands in case the conductor is stranded.
    
    % Panel
    input = uipanel(plotfigure,'Units','pixels','Title','Input',...
        'Visible','on','Position',[30 440 270 160]);
    
    RF_str = ['Outer Cylinder Radius, RF = ',num2str(RF),' cm'];
    RC_str = ['Conductor Radius, R = ',num2str(RC),' cm'];
    V_str = ['Conductor Voltage, Vo = ',num2str(Vo),' V'];
    
    % Static texts
    uicontrol(input,'Style','text','String',...
        'Configuration: Coaxial','HorizontalAlignment','Left',...
        'Position',[20 120 170 15]);
    uicontrol(input,'Style','text','String',...
        'Conductor Type: Smooth','HorizontalAlignment','Left',...
        'Position',[20 95 170 15]);
    uicontrol(input,'Style','text','String',...
        RF_str,'HorizontalAlignment','Left',...
        'Position',[20 70 170 15]);
    uicontrol(input,'Style','text','String',...
        RC_str ,'HorizontalAlignment','Left',...
        'Position',[20 45 170 15]);
    uicontrol(input,'Style','text','String',...
        V_str,'HorizontalAlignment','Left',...
        'Position',[20 20 170 15]);
    
    % OUTPUT
    Eo = Vo/(RC*log(RF/RC));
    E_str = ['Emax at conductor surface = ',num2str(Eo),' Volt/cm'];
    
    % Panel
    output = uipanel(plotfigure,'Title','Output',...
        'Units','pixels','Position',[30 370 270 55]);
    uicontrol(output,'Style','text','String',E_str,'HorizontalAlignment','Left',...
        'Position',[15 15 250 15]);

    % EXPRESSION
    % Button Group
    expr = uibuttongroup(plotfigure,'Title','Expression',...
        'Units','pixels','Position',[30 300 270 55]);
    % Radio Buttons
    pot = uicontrol(expr,'Style','radiobutton',...
        'String','Potential','Position',[15 15 70 15]);
    uicontrol(expr,'Style','radiobutton',...
        'String','Field','Position',[100 15 50 15]);
    
    % LINE
    % Panel
    line = uipanel(plotfigure,'Title','Interelectrode space',...
        'Units','pixels','Position',[30 210 270 75]);
    % Static text
    uicontrol(line,'Style','text','String',...
        'Up to distance from conductor''s surface (cm)',...
        'HorizontalAlignment','Left','Position',[20 20 140 30]);
    % Edit text
    hdis = uicontrol(line,'Style','edit','String','1',...
        'Position',[160 25 70 20],'BackgroundColor','w',...
        'Callback',{@dis_Callback});
    
    % MESSAGE BOARD
    % Panel
    sms = uipanel(plotfigure,'Units','pixels','Title','Message Board',...
        'Position',[470 30 430 45]);
    % Static texts
    dis_error = uicontrol(sms,'Style','text','String',...
        ['Distance must be between 0 and ',num2str(dis_critical),' cm.'],...
        'Visible','off','ForegroundColor','r',...
        'HorizontalAlignment','Left','Position',[15 10 400 15]);
    
    % PUSH BUTTONS
    uicontrol(plotfigure,'Style','pushbutton',...
        'String','Back','Position',[30 30 90 40],...
        'Callback',{@backtbutton_Callback});
        uicontrol(plotfigure,'Style','pushbutton',...
        'String','Reset','Position',[130 30 90 40],...
        'Callback',{@resetbutton_Callback});
    hexport = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Export','Position',[230 30 90 40],...
        'Enable','off','Callback',{@exportbutton_Callback});
    hplot = uicontrol(plotfigure,'Style','pushbutton',...
        'String','Plot','Position',[330 30 90 40],...
        'Enable','off','Callback',{@plotbutton_Callback}); 

    
    
    % --- CALLBACKS ----------------------------------------------------
    
    % LINE
    set(hdis,'Enable','on');
    dis = str2double(get(hdis,'String'));
    if dis_critical >= dis && dis > 0
        cutline_smooth(RC,0,dis);
        set(hplot,'Enable','on');
    else
        smooth(RC);
        set(hplot,'Enable','off');
    end
    
    function dis_Callback(source,eventdata)
        dis = str2double(get(source,'String'));
        if dis_critical >= dis && dis > 0
            cutline_smooth(RC,0,dis);
            set(hplot,'Enable','on');
            set(dis_error,'Visible','off');
        else
            set(dis_error,'String',...
                ['Distance must be between 0 and ',...
                num2str(dis_critical),' cm']);
            set(dis_error,'Visible','on');
            smooth(RC);
            set(hplot,'Enable','off');
            uicontrol(source)
        end
    end
    
    % PUSHBUTTONS
    % --- 'Plot' button callback ----------------
    function plotbutton_Callback(source,eventdata)
        exprObj = get(expr,'SelectedObject');
        expr_str = get(exprObj,'String');
        switch expr_str
            case 'Field'
                r = RC:(dis/samples):(dis+RC);
                E = Vo./(r.*log(RF/RC));
                deg = 1:(samples+1);
                factor = dis/samples;
                plot(factor*(deg-1),E(deg));
                xlabel('Distance from conductor surface (cm)')
                ylabel('Electric field (norm) (V/cm)')
                title('Electric field (norm) in the interelectrode space')
                grid on
            case 'Potential'
                r = RC:(dis/samples):(dis+RC);
                p = Vo.*log(RF./r)./(log(RF/RC));
                deg = 1:(samples+1);
                factor = dis/samples;
                plot(factor*(deg-1),p(deg));
                xlabel('Distance from conductor surface (cm)')
                ylabel('Potential (V)')
                title('Potential in the interelectrode space')
                grid on
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
        set(expr,'SelectedObject',pot);  % No selection
        % Hide error texts
        set(dis_error,'Visible','off');
        % Re-initialize edit texts and variables
        set(hdis,'String',1);
        dis = 1;
        dis_critical = RF - RC;
        cutline_smooth(RC,0,dis);
        set(hplot,'Enable','on');
        % Disable export button
        set(hexport,'Enable','off');
    end
    
    % Back button callback
    function backtbutton_Callback(source,eventdata)
        % Initialize unused variables
        next_flag = 1;
        er = 0;
        M = 0;
        A = zeros(10);
        geom(next_flag,axis_flag,config_flag,ctype_flag,pm_value,RF,RC,N,Vo,er,M,A);
        close(plotfigure)
    end
    
    % Move the window to the center of the screen.
    movegui(plotfigure,'center')
    % Make the UI visible
    set(plotfigure,'Visible','on');
    
end


