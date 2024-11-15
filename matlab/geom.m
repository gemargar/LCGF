function geom(next_flag,axis_flag,config_flag,ctype_flag,pm_value,RF,RC,N,Vo,er,M,A,p)
    
    % --- LAYOUT --------------------------------------------------

    % Create a figure and then hide the UI as it is constructed.
    f = figure('Resize','off','Color',0.95*[1 1 1],'Visible','off','Position',[100 100 810 545]);
    
    % Initialize the UI
    Polar = imread('pictures/Polar.png');
    Bipolar = imread('pictures/Bipolar.png');
    Smooth_coaxial = imread('pictures/smooth_coaxial.png');
    Smooth_plane = imread('pictures/smooth_plane.png');
    
    % AXES
    ha = axes('Parent',f,'Color',[1 1 1],'Units','pixels','Position',[390 125 380 380]);
        
    % CONFIGURATION
    
    % Button Group
    config = uibuttongroup(f,'Title','Configuration',...
        'Units','pixels','Position',[30 455 290 60]);
    % Radio Buttons
    coaxial = uicontrol(config,'Style','radiobutton',...
        'String','Coaxial','Position',[20 15 70 20]);
    plane = uicontrol(config,'Style','radiobutton',...
        'String','Conductor-Plane','Position',[110 15 100 20]);
    
    % CONDUCTOR TYPE
    
    % Button Group
    ctype = uibuttongroup(f,'Title','Conductor Type','Units','Pixels',...
        'Position',[30 360 290 85]);
    % Radio Buttons
    smooth = uicontrol(ctype,'Style','radiobutton',...
        'String','Smooth','Position',[20 40 70 20]);
    stranded = uicontrol(ctype,'Style','radiobutton',...
        'String','Stranded','Position',[20 15 70 20]);
    % Static Text
    pm_text = uicontrol(ctype,'Style','text',...
        'String','Select a "bird"','Enable','off',...
        'HorizontalAlignment','Left','Position',[110 25 70 20]);
    % Pop-up Menu
    pm = uicontrol(ctype,'Style','popupmenu',...
        'String',{'','falcon','catbird','linnet','thrush'},...
        'Value',pm_value,'Position',[190 30 70 20],'BackgroundColor','w',...
        'Enable','off','Callback',{@popup_menu_Callback});
    
    % INPUT Set the values of the conductor's voltage, the radiuses
    % of the outer cylinder and the conductor, as well as the number
    % of strands in case the conductor is stranded.
    % Panel
    input = uipanel(f,'Units','pixels','Title','Input Data',...
        'Position',[30 140 290 210]); 
    % Static texts
    uicontrol(input,'Style','text','String',...
        'Conductor Voltage, Vo (V):','HorizontalAlignment','Left',...
        'Position',[20 160 170 15]);
    RFtxt = uicontrol(input,'Style','text','String',...
        'Outer Cylinder Radius, RF (cm):','HorizontalAlignment','Left',...
        'Position',[20 120 170 15]);    
    Htxt = uicontrol(input,'Style','text','String',...
        'Height above plane, H (cm):','HorizontalAlignment','Left',...
        'Position',[20 120 170 15]); 
    uicontrol(input,'Style','text','String',...
        'Conductor Radius, R (cm):','HorizontalAlignment','Left',...
        'Position',[20 80 170 15]);
    Ntxt = uicontrol(input,'Style','text','String',...
        'Number of strands, N:','HorizontalAlignment','Left',...
        'Position',[20 40 170 15]);
    if ctype_flag == 1
        set(Ntxt,'Enable','off')
    end    
        
    % Edit texts
    hVo = uicontrol(input,'Style','edit','String',num2str(Vo),...
        'Position',[180 155 70 20],'BackgroundColor','w',...
        'Callback',{@Vo_Callback});
    hRF = uicontrol(input,'Style','edit','String',num2str(RF),...
        'Position',[180 115 70 20],'BackgroundColor','w',...
        'Callback',{@RF_Callback});
    hRC = uicontrol(input,'Style','edit','String',num2str(RC),...
        'Position',[180 75 70 20],'BackgroundColor','w',...
        'Callback',{@RC_Callback});
    hN = uicontrol(input,'Style','edit','String',num2str(N),...
        'Position',[180 35 70 20],'BackgroundColor','w',...
        'Callback',{@N_Callback});
    if ctype_flag == 1
        set(hN,'Enable','off')
    end
    
    % MESSAGE BOARD
    % Panel
    sms = uipanel(f,'Units','pixels','Title','Message Board',...
        'Position',[470 30 300 45]);
    % Static texts
    Verror = uicontrol(sms,'Style','text','String',...
        'V must be a positive number.','Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 270 15]);
    RFerror = uicontrol(sms,'Style','text','String',...
        'RF must be greater than R.','Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 270 15]);
    Herror = uicontrol(sms,'Style','text','String',...
        'H must be greater than R.','Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 270 15]);  
    RCRFerror = uicontrol(sms,'Style','text','String',...
        'R must be positive and smaller than RF.','Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 270 15]);
    RCHerror = uicontrol(sms,'Style','text','String',...
        'R must be positive and smaller than H.','Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 270 15]);
    Nerror = uicontrol(sms,'Style','text','String',...
        'N must be an interger greater than 3.','Visible','off',...
        'ForegroundColor','r','HorizontalAlignment','Left',...
        'Position',[15 10 270 15]);
    
    % PUSH BUTTONS
    next = uicontrol(f,'Style','pushbutton',...
        'String','Next','Position',[130 30 90 40],...
        'Enable','off','Callback',{@calcbutton_Callback});
    uicontrol(f,'Style','pushbutton','String','Reset',...
        'Position',[30 30 90 40],'Callback',{@resetbutton_Callback});
    if next_flag == 1
        set(next,'Enable','on')
    end
    
    
    
    % --- CALLBACKS -------------------------------------------------------
    
    % Initialize Axes
    if config_flag == 1
        if ctype_flag == 1
            image(Smooth_coaxial)
            axis equal
            axis off
        else
            conductor(RC,N);
        end
    else
        if ctype_flag == 1
            image(Smooth_plane)
            axis equal
            axis off
        else
            conductor(RC,N);
        end
    end
    
    % --- Configuration --------
    % Initialize some button group properties.
    if config_flag == 1
        set(config,'SelectedObject',coaxial);
        set(RFtxt,'Visible','on')
        set(Htxt,'Visible','off')
    elseif config_flag == 2
        set(config,'SelectedObject',plane);
        set(RFtxt,'Visible','off')
        set(Htxt,'Visible','on')
    end
    set(config,'SelectionChangeFcn',@config_selcbk);
    
    % Executes when selection changes
    function config_selcbk(source,eventdata)
        str = get(eventdata.NewValue,'String');
        switch str
            case 'Coaxial'
                config_flag = 1;
                if axis_flag == 0
                    if ctype_flag == 1
                        image(Smooth_coaxial)
                        axis equal
                        axis off                            
                    elseif ctype_flag == 2
                        image(Polar)
                        axis equal
                        axis off
                    end
                else
                    if ctype_flag == 1
                        image(Smooth_coaxial)
                        axis equal
                        axis off                            
                    elseif ctype_flag == 2
                        conductor(RC,N);
                    end
                end
                set(RFtxt,'Visible','on');
                set(Htxt,'Visible','off');
            case 'Conductor-Plane'
                config_flag = 2;
                if axis_flag == 0
                    if ctype_flag == 1
                        image(Smooth_plane)
                        axis equal
                        axis off
                    elseif ctype_flag == 2
                        image(Bipolar)
                        axis equal
                        axis off
                    end
                else
                    if ctype_flag == 1
                        image(Smooth_plane)
                        axis equal
                        axis off                            
                    elseif ctype_flag == 2
                        conductor(RC,N);
                    end
                end
                set(RFtxt,'Visible','off');
                set(Htxt,'Visible','on');
        end
    end
    
    % --- Conductor Type ---------------- 
    % Initialize some button group properties.
    if ctype_flag == 1
        set(ctype,'SelectedObject',smooth);
    elseif ctype_flag == 2
        set(ctype,'SelectedObject',stranded);
        set(pm_text,'Enable','on');
        set(pm,'Enable','on');
    else
        set(ctype,'SelectedObject',smooth);  % No selection
    end
    set(ctype,'SelectionChangeFcn',@conductor_selcbk);
    
    % Executes when selection changes
    function conductor_selcbk(source,eventdata)
        str = get(eventdata.NewValue,'String');
        switch str
            case 'Smooth'
                % Show an image
                ctype_flag = 1;
                if config_flag == 1
                    image(Smooth_coaxial)
                    axis equal
                    axis off
                elseif config_flag == 2
                    image(Smooth_plane)
                    axis equal
                    axis off
                end
                set(hN,'Enable','off');
                set(Nerror,'Visible','off');
                set(Ntxt,'Enable','off');
                set(pm_text,'Enable','off');
                set(pm,'Enable','off');
                % Enable calc
                set(next,'Enable','on');
            case 'Stranded'
                ctype_flag = 2;
                if axis_flag == 0
                    if config_flag == 1
                        image(Polar)
                        axis equal
                        axis off
                    elseif config_flag == 2
                        image(Bipolar)
                        axis equal
                        axis off
                    end
                else
                    conductor(RC,N);
                end
                set(hN,'Enable','on');
                set(Ntxt,'Enable','on');
                if ~(N > 3)
                    if ~(RF == 0 && RC == 0)
                        set(Nerror,'Visible','on');
                    end
                end
                set(pm_text,'Enable','on');
                set(pm,'Enable','on');
                % If input data is saficient, enable calculation button
                if (RF>RC && RC>0 && N>=3 && Vo>0)
                    set(next,'Enable','on');
                else
                    set(next,'Enable','off');
                end    
        end
    end
    
    % Pop-up menu Callback
    function popup_menu_Callback(source,eventdata)
        % Determine the selected data set.
        str = get(source,'String');
        val = get(source,'Value');
        % Set current data to the selected data set.
        switch str{val};
            case ''
                pm_value = 1;
                % Set conductor specs
                set(hRF,'String','0');
                set(hRC,'String','0');
                set(hN,'String','0');
                Vo = 1;
                RF = 0;
                RC = 0;
                N = 0;
                % Set flag to zero
                axis_flag = 0;
                configObj = get(config,'SelectedObject');
                config_str = get(configObj,'String');
                switch config_str
                    case 'Coaxial'
                        imshow(Polar,'Parent',ha)
                    case 'Conductor-Plane'
                        imshow(Bipolar,'Parent',ha)
                end
                axis equal
                axis off
            case 'falcon'
                pm_value = 2;
                % Set conductor specs
                set(hRF,'String','10');
                set(hRC,'String','1.963');
                set(hN,'String','25');
                set(hVo,'String','1');
                Vo = 1;
                RF = 10;
                RC = 1.963;
                N = 25;
                % Set flag to 1
                axis_flag = 1;
                % Draw the conductor
                conductor(RC,N);
                % Hide error messages
                set(RFerror,'Visible','off');
                set(Herror,'Visible','off');
                set(RCRFerror,'Visible','off');
                set(RCHerror,'Visible','off');
                set(Nerror,'Visible','off');
                set(Verror,'Visible','off');
                % Enable the calc button/Disable the plot button
                set(next,'Enable','on')
            case 'catbird'
                pm_value = 3;
                % Set conductor specs
                set(hRF,'String','10');
                set(hRC,'String','1.4478');
                set(hN,'String','18');
                set(hVo,'String','1');
                Vo = 1;
                RF = 10;
                RC = 1.4478;
                N = 18;
                % Set flag to 1
                axis_flag = 1;
                % Draw the conductor
                conductor(RC,N);
                % Hide error messages
                set(RFerror,'Visible','off');
                set(Herror,'Visible','off');
                set(RCRFerror,'Visible','off');
                set(RCHerror,'Visible','off');
                set(Nerror,'Visible','off');
                set(Verror,'Visible','off');
                % Enable the calc button/Disable the plot button
                set(next,'Enable','on')
            case 'linnet'
                pm_value = 4;
                % Set conductor specs
                set(hRF,'String','10');
                set(hRC,'String','0.9144');
                set(hN,'String','16');
                set(hVo,'String','1');
                Vo = 1;
                RF = 10;
                RC = 0.9144;
                N = 16;
                % Set flag to 1
                axis_flag = 1;
                % Draw the conductor
                conductor(RC,N);
                % Hide error messages
                set(RFerror,'Visible','off');
                set(Herror,'Visible','off');
                set(RCRFerror,'Visible','off');
                set(RCHerror,'Visible','off');
                set(Nerror,'Visible','off');
                set(Verror,'Visible','off');
                % Enable the calc button/Disable the plot button
                set(next,'Enable','on')
            case 'thrush'
                pm_value = 5;
                % Set conductor specs
                set(hRF,'String','10');
                set(hRC,'String','0.28321');
                set(hN,'String','6');
                set(hVo,'String','1');
                Vo = 1;
                RF = 10;
                RC = 0.28321;
                N = 6;
                % Set flag to 1
                axis_flag = 1;
                % Draw the conductor
                conductor(RC,N);
                % Hide error messages
                set(RFerror,'Visible','off');
                set(Herror,'Visible','off');
                set(RCRFerror,'Visible','off');
                set(RCHerror,'Visible','off');
                set(Nerror,'Visible','off');
                set(Verror,'Visible','off');
                % Enable the calc button/Disable the plot button
                set(next,'Enable','on')
        end
    end
    
    % --- Input -------------------------------
    % Edit text callbacks.
    % Read the edit text String property to determine which is
    % the value of the respected variable. Reset the plot automatically.
    
    function Vo_Callback(source,eventdata)
        % Validate that the text in the field converts to a real number
        str = get(source,'String');
        Vo = str2double(str);
        if Vo > 0
            if N > 3 && RF > RC && RC > 0
                % Enable the calc button/Disable the plot button
                set(next,'Enable','on')
            end
            % Hide error text
            set(Verror,'Visible','off')
        else
            % Disable the Calculate button
            set(next,'Enable','off')
            % Show error text
            set(Verror,'Visible','on')
            uicontrol(source)
        end
    end
    
    function RF_Callback(source,eventdata)
        % Validate the text in the field
        str = get(source,'String');
        RF = str2double(str);
        if RF > RC && RF > 0
            ctypeObj = get(ctype,'SelectedObject');
            ctype_str = get(ctypeObj,'String');
            switch ctype_str
                case 'Smooth'
                    if RC > 0 && Vo > 0
                        % Enable the 'next' button
                        set(next,'Enable','on')
                    end
                case 'Stranded'
                    if RC > 0 && N > 2 && Vo > 0
                        % Enable the 'next' button
                        set(next,'Enable','on')
                    end
            end
            % Hide error text
            set(RCRFerror,'Visible','off')
            set(RCHerror,'Visible','off')
            set(RFerror,'Visible','off')
        else
            % Disable the 'next' button
            set(next,'Enable','off')
            % Show error text
            set(RFerror,'Visible','on')
            uicontrol(source)
        end
    end
    
    function RC_Callback(source,eventdata)
        % Validate the text in the field
        RC = str2double(get(source,'String'));
        if RC > 0
            ctypeObj = get(ctype,'SelectedObject');
            ctype_str = get(ctypeObj,'String');
            switch ctype_str
                case 'Smooth'
                    if RF > RC && Vo > 0
                        % Enable the 'next' button
                        set(next,'Enable','on')
                    end
                case 'Stranded'
                    if N > 2
                        if (RC == 1.963 && N == 25)
                            pm_value = 2;
                        elseif (RC == 1.4478 && N == 18)
                            pm_value = 3;
                        elseif (RC == 0.9144 && N == 16)
                            pm_value = 4;
                        elseif (RC == 0.28321 && N == 6)
                            pm_value = 5;
                        else
                            pm_value = 1;
                        end
                        set(pm,'Value',pm_value)
                        % Draw the conductor and set axis_flag to 1
                        axis_flag = 1;
                        conductor(RC,N);
                        if RF > RC && Vo > 0
                            % Set flag to 1
                            axis_flag = 1;
                            % Enable the 'next' button
                            set(next,'Enable','on')
                        end
                    end
            end
            % Hide error text
            set(RCRFerror,'Visible','off')
            set(RCHerror,'Visible','off')
            set(RFerror,'Visible','off')
        else
            % Disable the 'next' button
            set(next,'Enable','off')
            % Show error text
            configObj = get(config,'SelectedObject');
            config_str = get(configObj,'String');
            switch config_str
                case 'Coaxial'
                    set(RCRFerror,'Visible','on')
                    set(RCHerror,'Visible','off')
                case 'Conductor-Plane'
                    set(RCRFerror,'Visible','off')
                    set(RCHerror,'Visible','on')
            end
            uicontrol(source)
        end
        if RF <= RC
            % Disable the 'next' button
            set(next,'Enable','off')
            % Show error text
            configObj = get(config,'SelectedObject');
            config_str = get(configObj,'String');
            switch config_str
                case 'Coaxial'
                    set(RCRFerror,'Visible','on')
                    set(RCHerror,'Visible','off')
                case 'Conductor-Plane'
                    set(RCRFerror,'Visible','off')
                    set(RCHerror,'Visible','on')
            end
            uicontrol(source)
        end
    end
    
    function N_Callback(source,eventdata)
        % Validate that the text in the field converts to a real number
        N = str2double(get(source,'String'));
        if N > 2
            if RC > 0
                if (RC == 1.963 && N == 25)
                    pm_value = 2;
                    set(pm,'Value',pm_value)
                elseif (RC == 1.4478 && N == 18)
                    pm_value = 3;
                    set(pm,'Value',pm_value)
                elseif (RC == 0.9144 && N == 16)
                    pm_value = 4;
                    set(pm,'Value',pm_value)
                elseif (RC == 0.28321 && N == 6)
                    pm_value = 5;
                    set(pm,'Value',pm_value)
                else
                    pm_value = 1;
                    set(pm,'Value',pm_value)
                end
                % Draw the conductor and set axis_flag to 1
                axis_flag = 1;
                conductor(RC,N);
                if RF > RC && Vo > 0
                    % Set flag to 1
                    axis_flag = 1;
                    % Enable the 'next' button
                    set(next,'Enable','on')
                end
            end
            % Hide error text
            set(Nerror,'Visible','off')
        else
            % Disable the 'next' button
            set(next,'Enable','off')
            % Show error text
            set(Nerror,'Visible','on')
            uicontrol(source)
        end
    end
    
    % --- Push Button ---------------------
    % Calculation button callback
    function calcbutton_Callback(source,eventdata)
        if ctype_flag == 2
            configObj = get(config,'SelectedObject');
            config_str = get(configObj,'String');
            ctypeObj = get(ctype,'SelectedObject');
            ctype_str = get(ctypeObj,'String');
            switch config_str
                case 'Coaxial'
                    switch ctype_str
                        case 'Smooth' % Do nothing
                        case 'Stranded'
                            % Calculates the optimal number of terms for polar
                            % coordinates using the function 'Mbreak_polar'
                            [M,er] = Mbreak_polar(Vo,RC,RF,N);
                            A = coefficients(Vo,M,RC,RF,N);
                    end
                case 'Conductor-Plane'
                    switch ctype_str
                        case 'Smooth' % Do nothing
                        case 'Stranded' % Do nothing
                            % Calculates the optimal number of terms for bipolar
                            % coordinates using the function 'Mbreak_bipolar'
                            [A,M,p,er] = Mbreak_bipolar(Vo,RC,RF,N);
                            p = (p-Vo)/Vo*100;
                    end
            end
        end
        % Old 'Plot' button callback
        configObj = get(config,'SelectedObject');
        config_str = get(configObj,'String');
        ctypeObj = get(ctype,'SelectedObject');
        ctype_str = get(ctypeObj,'String');
        switch config_str
            case 'Coaxial'
                switch ctype_str
                    case 'Smooth'
                        smooth_coaxial(axis_flag,config_flag,ctype_flag,pm_value,Vo,RC,RF,N)
                        close(f)
                    case 'Stranded'
                        stranded_coaxial(axis_flag,config_flag,ctype_flag,pm_value,A,Vo,M,RC,RF,N,er);
                        close(f)
                end
            case 'Conductor-Plane'
                switch ctype_str
                    case 'Smooth'
                        smooth_plane(axis_flag,config_flag,ctype_flag,pm_value,Vo,RC,RF,N)
                        close(f)
                    case 'Stranded'
                        stranded_plane(axis_flag,config_flag,ctype_flag,pm_value,A,Vo,M,RC,RF,N,p,er)
                        close(f)
                end
        end
    end

    % Reset button callback
    function resetbutton_Callback(source,eventdata)
        % Re-initialize the configuration panel to coaxial
        config_flag = 1;
        set(config,'SelectedObject',coaxial);  % No selection
        % Re-initialize the conductor type panel to smooth
        ctype_flag = 1;
        set(pm_text,'Enable','off');
        set(pm,'Value',1);
        set(pm,'Enable','off');
        set(ctype,'SelectedObject',smooth);  % No selection
        % Re-initialize the input panel
        set(hRC,'String','0');
        set(hN,'String','0');
        set(hRF,'String','0');
        set(hVo,'String','1'); 
        RF = 0;
        RC = 0;
        N = 0;
        Vo = 1;
        % Hide H static and disable N static & edit text
        set(RFtxt,'Visible','on');
        set(Htxt,'Visible','off');
        set(hN,'Enable','off');
        set(Ntxt,'Enable','off');
        set(pm_text,'Enable','off');
        set(pm,'Enable','off');
        % Clear all error texts
        set(RFerror,'Visible','off');
        set(Herror,'Visible','off');
        set(RCRFerror,'Visible','off');
        set(RCHerror,'Visible','off');
        set(Nerror,'Visible','off');
        set(Verror,'Visible','off'); 
        % Re-initialize the output panel
        er = 0;
        % Disable push buttons
        set(next,'Enable','off');
        % Reset axes picture
        axis_flag = 0;
        image(Smooth_coaxial)
        axis equal
        axis off
    end
    
    % General
    
    % Assign a name to appear in the window title.
    set(f,'Name','Geometry');
    set(f,'NumberTitle','off');
    set(f,'Toolbar','none');
    set(f,'MenuBar','none');
    
    % Move the window to the center of the screen.
    movegui(f,'center')
    
    % Make the UI visible
    set(f,'Visible','on');
    
    % --- End of General ---------------------------------------------
    
end
