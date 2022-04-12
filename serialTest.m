%% ELEC 4907 Matlab Real Time Emulation Modelling
% Plotting the recieved quantized data through CALLBACKS 
% Spencer Simbul 
function serialTest(src, ~) %% PASS in serial object 

%READ data from 
data = readline(src);

%String printed from serial port is converted to double to be plotted 
%Stores in data array in serial port object
src.UserData.Data(end+1) = str2double(data);

src.UserData.Count = src.UserData.Count + 1;

%Plot data every 1000 points collected
if src.UserData.Count > 1001
    configureCallback(src, "off");
    plot(src.UserData.Data(2:end));
    title('Call Back Real Time Quantized Data from Serial Object')
    xlabel('Sample')
    ylabel("Amplitude")
end
end