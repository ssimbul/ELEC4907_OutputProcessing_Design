classdef ELEC4907_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        ELEC4907FPGABasedSpectrumAnalyzerUIFigure  matlab.ui.Figure
        TabGroup                      matlab.ui.container.TabGroup
        SampledQuantizedDataTab       matlab.ui.container.Tab
        NoDCOffsetSwitch              matlab.ui.control.Switch
        NoDCOffsetSwitchLabel         matlab.ui.control.Label
        FilteredDataSwitch            matlab.ui.control.Switch
        FilteredDataSwitchLabel       matlab.ui.control.Label
        RawDataSwitch                 matlab.ui.control.Switch
        RawDataSwitchLabel            matlab.ui.control.Label
        UIAxes                        matlab.ui.control.UIAxes
        SpectrumAnalyzerTab           matlab.ui.container.Tab
        PowerSpectrumSwitch           matlab.ui.control.Switch
        PowerSpectrumSwitchLabel      matlab.ui.control.Label
        MagnitudeSpectrumSwitch       matlab.ui.control.Switch
        MagnitudeSpectrumSwitchLabel  matlab.ui.control.Label
        UIAxes2                       matlab.ui.control.UIAxes
        Image                         matlab.ui.control.Image
        ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel  matlab.ui.control.Label
        ClearDataButton               matlab.ui.control.Button
        LoadDataLabel                 matlab.ui.control.Label
        Button                        matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: Button
        function ButtonPushed2(app, event)
            
           [file,path] = uigetfile('*.csv');
           filename=[path,file];
           data = load(filename);
           if (~isempty(data))
                  app.RawDataSwitch.Enable = 'on';
                  app.RawDataSwitchLabel.Enable='on';
                  app.NoDCOffsetSwitch.Enable = 'on';
                  app.NoDCOffsetSwitchLabel.Enable='on'
                  app.FilteredDataSwitch.Enable ='on';
                  app.FilteredDataSwitchLabel.Enable ='on';
                  app.MagnitudeSpectrumSwitch.Enable='on';
                  app.MagnitudeSpectrumSwitchLabel.Enable='on';
                  app.PowerSpectrumSwitch.Enable = 'on';
                  app.PowerSpectrumSwitchLabel.Enable='on';
                  app.ClearDataButton.Enable = 'on';
           end
            Fs = 100000;                                        % Sampling frequency
            T = 1/Fs;                                           % Sampling period
            L = 49149;                                          % Length of signal
            t = (0:L-1)*T;                                      % Time vector
            Fn = Fs/2;                                          % Nyquist Frequency
            Fv = linspace(0, 1, fix(L/2)+1)*Fn;                 % Frequency Vector
            Iv = 1:length(Fv);                                  % Index Vector

            FXdcoc = fft(data-mean(data))/L;                    % Fourier Transform (D-C Offset Corrected)
            [max_Freq,max_IV] = max(abs(FXdcoc(Iv))*2);          % Get Maximum Amplitude, & Frequency Index Vector
            Wp = 2*Fv(max_IV)/Fn;                               % Passband Frequency (Normalised)
            Ws = Wp*2;                                          % Stopband Frequency (Normalised)
            Rp = 10;                                            % Passband Ripple (dB)
            Rs = 30;                                            % Stopband Ripple (dB)
            [n,Wn] = buttord(Wp,Ws,Rp,Rs);                      % Butterworth Filter Order
            [b,a] = butter(n,Wn);                               % Butterworth Transfer Function Coefficients
            [SOS,G] = tf2sos(b,a);                              % Convert to Second-Order-Section For Stability
%             figure(3)
%             freqz(SOS, 4096, Fs);                               % Filter Bode Plot
%             title('Lowpass Filter Bode Plot')
            S = filtfilt(SOS,G,data);                              % Filter dXa To Recover tSa

            plot(app.UIAxes,t,data);                                          % Plot aXp
            hold(app.UIAxes,'on')
            plot(app.UIAxes,t, S, '-r', 'LineWidth',1.5)                   % Plot aSp
            hold(app.UIAxes,'on')
            S_No_DC = S - mean(S);
            plot(app.UIAxes,t, S_No_DC, '-g', 'LineWidth',1.5)
            hold(app.UIAxes,'off')
            
            legend(app.UIAxes,'Raw Data', 'Filtered Data','Filtered Data No DC Offset' ,'Location','NE')
            

            %SPECTRUM ANALYZER
        
            N=2048; %FFT size
            Y = 1/N*fftshift(fft(S_No_DC,N));%N-point complex DFT
            df=Fs/N; %frequency resolution
            sampleIndex = -N/2:N/2-1; %ordered index for FFT plot
            f=sampleIndex*df; %x-axis index converted to ordered frequencies
            mag = abs(Y);
            hold(app.UIAxes2,'on')
            stem(app.UIAxes2,f,mag); %magnitudes vs frequencies
            stem(app.UIAxes2,f,10*log10(mag.^2),"Visible",'off');
            hold(app.UIAxes2,'off')
            
        end

        % Button pushed function: ClearDataButton
        function ClearDataButtonPushed(app, event)
            cla(app.UIAxes) 
            cla(app.UIAxes2) 
        end

        % Value changed function: RawDataSwitch
        function RawDataSwitchValueChanged(app, event)
            value = app.RawDataSwitch.Value;
            disp(value)
            if(value == "Off") 
                set( findobj(app.UIAxes.Children(3)), 'Visible', 'off')
            elseif value == "On"
                set( findobj(app.UIAxes.Children(3)), 'Visible', 'on')
            end
        end

        % Value changed function: FilteredDataSwitch
        function FilteredDataSwitchValueChanged(app, event)
            value = app.FilteredDataSwitch.Value;
             disp(value)
            if(value == "Off") 
                set( findobj(app.UIAxes.Children(2)), 'Visible', 'off')
            elseif value == "On"
                set( findobj(app.UIAxes.Children(2)), 'Visible', 'on')
            end
        end

        % Value changed function: NoDCOffsetSwitch
        function NoDCOffsetSwitchValueChanged(app, event)
            value = app.NoDCOffsetSwitch.Value;
             disp(value)
            if(value == "Off") 
                set( findobj(app.UIAxes.Children(1)), 'Visible', 'off')
            elseif value == "On"
                set( findobj(app.UIAxes.Children(1)), 'Visible', 'on')
            end
        end

        % Value changed function: MagnitudeSpectrumSwitch
        function MagnitudeSpectrumSwitchValueChanged(app, event)
            value = app.MagnitudeSpectrumSwitch.Value;
             if(value == "Off") 
                set( findobj(app.UIAxes2.Children(2)), 'Visible', 'off')
            elseif value == "On"
                set( findobj(app.UIAxes2.Children(2)), 'Visible', 'on')
            end
        end

        % Value changed function: PowerSpectrumSwitch
        function PowerSpectrumSwitchValueChanged(app, event)
            value = app.PowerSpectrumSwitch.Value;
             if(value == "Off") 
                set( findobj(app.UIAxes2.Children(1)), 'Visible', 'off')
            elseif value == "On"
                set( findobj(app.UIAxes2.Children(1)), 'Visible', 'on')
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create ELEC4907FPGABasedSpectrumAnalyzerUIFigure and hide until all components are created
            app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure = uifigure('Visible', 'off');
            app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure.Color = [0.8 0.8 0.8];
            app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure.Position = [100 100 1523 850];
            app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure.Name = 'ELEC 4907: FPGA Based Spectrum Analyzer';
            app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure.Icon = 'carleton.png';

            % Create Button
            app.Button = uibutton(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed2, true);
            app.Button.Icon = 'importcsv.png';
            app.Button.BackgroundColor = [0.9412 0.9412 0.9412];
            app.Button.Position = [1393 633 106 46];
            app.Button.Text = '';

            % Create LoadDataLabel
            app.LoadDataLabel = uilabel(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure);
            app.LoadDataLabel.HorizontalAlignment = 'center';
            app.LoadDataLabel.FontSize = 14;
            app.LoadDataLabel.FontWeight = 'bold';
            app.LoadDataLabel.Position = [1393 678 111 35];
            app.LoadDataLabel.Text = 'Load Data ';

            % Create ClearDataButton
            app.ClearDataButton = uibutton(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure, 'push');
            app.ClearDataButton.ButtonPushedFcn = createCallbackFcn(app, @ClearDataButtonPushed, true);
            app.ClearDataButton.Enable = 'off';
            app.ClearDataButton.Position = [1393 578 106 40];
            app.ClearDataButton.Text = 'Clear Data ';

            % Create ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel
            app.ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel = uilabel(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure);
            app.ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel.FontSize = 24;
            app.ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel.FontWeight = 'bold';
            app.ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel.Position = [429 784 677 30];
            app.ELEC4907FPGABasedSpectrumAnalyzerApplicationLabel.Text = 'ELEC 4907: FPGA Based Spectrum Analyzer Application  ';

            % Create Image
            app.Image = uiimage(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure);
            app.Image.Position = [30 760 214 79];
            app.Image.ImageSource = 'doe.png';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure);
            app.TabGroup.Position = [26 24 1346 724];

            % Create SampledQuantizedDataTab
            app.SampledQuantizedDataTab = uitab(app.TabGroup);
            app.SampledQuantizedDataTab.Title = 'Sampled Quantized Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.SampledQuantizedDataTab);
            title(app.UIAxes, 'Sampled Quantized Data')
            xlabel(app.UIAxes, 'Time (s)')
            ylabel(app.UIAxes, 'Amplitude (Quantized)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.XMinorGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.YMinorGrid = 'on';
            app.UIAxes.Position = [19 91 1300 598];

            % Create RawDataSwitchLabel
            app.RawDataSwitchLabel = uilabel(app.SampledQuantizedDataTab);
            app.RawDataSwitchLabel.HorizontalAlignment = 'center';
            app.RawDataSwitchLabel.Enable = 'off';
            app.RawDataSwitchLabel.Position = [36 22 58 22];
            app.RawDataSwitchLabel.Text = 'Raw Data';

            % Create RawDataSwitch
            app.RawDataSwitch = uiswitch(app.SampledQuantizedDataTab, 'slider');
            app.RawDataSwitch.ValueChangedFcn = createCallbackFcn(app, @RawDataSwitchValueChanged, true);
            app.RawDataSwitch.Enable = 'off';
            app.RawDataSwitch.Position = [41 59 45 20];
            app.RawDataSwitch.Value = 'On';

            % Create FilteredDataSwitchLabel
            app.FilteredDataSwitchLabel = uilabel(app.SampledQuantizedDataTab);
            app.FilteredDataSwitchLabel.HorizontalAlignment = 'center';
            app.FilteredDataSwitchLabel.Enable = 'off';
            app.FilteredDataSwitchLabel.Position = [137 22 74 22];
            app.FilteredDataSwitchLabel.Text = 'Filtered Data';

            % Create FilteredDataSwitch
            app.FilteredDataSwitch = uiswitch(app.SampledQuantizedDataTab, 'slider');
            app.FilteredDataSwitch.ValueChangedFcn = createCallbackFcn(app, @FilteredDataSwitchValueChanged, true);
            app.FilteredDataSwitch.Enable = 'off';
            app.FilteredDataSwitch.Position = [151 59 45 20];
            app.FilteredDataSwitch.Value = 'On';

            % Create NoDCOffsetSwitchLabel
            app.NoDCOffsetSwitchLabel = uilabel(app.SampledQuantizedDataTab);
            app.NoDCOffsetSwitchLabel.HorizontalAlignment = 'center';
            app.NoDCOffsetSwitchLabel.Enable = 'off';
            app.NoDCOffsetSwitchLabel.Position = [244 22 77 22];
            app.NoDCOffsetSwitchLabel.Text = 'No DC Offset';

            % Create NoDCOffsetSwitch
            app.NoDCOffsetSwitch = uiswitch(app.SampledQuantizedDataTab, 'slider');
            app.NoDCOffsetSwitch.ValueChangedFcn = createCallbackFcn(app, @NoDCOffsetSwitchValueChanged, true);
            app.NoDCOffsetSwitch.Enable = 'off';
            app.NoDCOffsetSwitch.Position = [259 59 45 20];
            app.NoDCOffsetSwitch.Value = 'On';

            % Create SpectrumAnalyzerTab
            app.SpectrumAnalyzerTab = uitab(app.TabGroup);
            app.SpectrumAnalyzerTab.Title = 'Spectrum Analyzer';

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.SpectrumAnalyzerTab);
            title(app.UIAxes2, 'Spectrum Analyzer Output')
            xlabel(app.UIAxes2, 'Frequency (kHz)')
            ylabel(app.UIAxes2, 'Magnitude(Quantized Voltage)/Power(dB)')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.XGrid = 'on';
            app.UIAxes2.XMinorGrid = 'on';
            app.UIAxes2.YGrid = 'on';
            app.UIAxes2.YMinorGrid = 'on';
            app.UIAxes2.Position = [14 91 1305 598];

            % Create MagnitudeSpectrumSwitchLabel
            app.MagnitudeSpectrumSwitchLabel = uilabel(app.SpectrumAnalyzerTab);
            app.MagnitudeSpectrumSwitchLabel.HorizontalAlignment = 'center';
            app.MagnitudeSpectrumSwitchLabel.Enable = 'off';
            app.MagnitudeSpectrumSwitchLabel.Position = [14 22 116 22];
            app.MagnitudeSpectrumSwitchLabel.Text = 'Magnitude Spectrum';

            % Create MagnitudeSpectrumSwitch
            app.MagnitudeSpectrumSwitch = uiswitch(app.SpectrumAnalyzerTab, 'slider');
            app.MagnitudeSpectrumSwitch.ValueChangedFcn = createCallbackFcn(app, @MagnitudeSpectrumSwitchValueChanged, true);
            app.MagnitudeSpectrumSwitch.Enable = 'off';
            app.MagnitudeSpectrumSwitch.Position = [48 59 45 20];
            app.MagnitudeSpectrumSwitch.Value = 'On';

            % Create PowerSpectrumSwitchLabel
            app.PowerSpectrumSwitchLabel = uilabel(app.SpectrumAnalyzerTab);
            app.PowerSpectrumSwitchLabel.HorizontalAlignment = 'center';
            app.PowerSpectrumSwitchLabel.Enable = 'off';
            app.PowerSpectrumSwitchLabel.Position = [166 22 94 22];
            app.PowerSpectrumSwitchLabel.Text = 'Power Spectrum';

            % Create PowerSpectrumSwitch
            app.PowerSpectrumSwitch = uiswitch(app.SpectrumAnalyzerTab, 'slider');
            app.PowerSpectrumSwitch.ValueChangedFcn = createCallbackFcn(app, @PowerSpectrumSwitchValueChanged, true);
            app.PowerSpectrumSwitch.Enable = 'off';
            app.PowerSpectrumSwitch.Position = [189 59 45 20];

            % Show the figure after all components are created
            app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ELEC4907_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.ELEC4907FPGABasedSpectrumAnalyzerUIFigure)
        end
    end
end