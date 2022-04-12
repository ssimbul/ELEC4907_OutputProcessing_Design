filename = 'adcQuantData.csv';
sampled_data = load(filename);
Fs = 100000;                                        % Sampling Rate: 100000 Hz
T = 1/Fs;                                           % Sampling period 
L = 49149;                                          % Signal Sample Lenght 
t = (0:L-1)*T;                                      % Convert to Time Vector
Fn = Fs/2;                                          % Nyquist Frequency Crit
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                 % Vector of Frequencies
Iv = 1:length(Fv);                                  % Vector to index frequencies (For filter parameters) 
%% FILTER SAMPLED DATA
FXdcoc = fft(sampled_data-mean(sampled_data))/L;                          % Fourier Transform (D-C Offset Corrected)
Test = abs(FXdcoc(Iv))*2
[FXn_max,Iv_max] = max(abs(FXdcoc(Iv))*2);          % Get Maximum Amplitude, & Frequency Index Vector
Wp = 2*Fv(Iv_max)/Fn;                               % Passband Frequency (Normalised)
Ws = Wp*2;                                          % Stopband Frequency (Normalised)
Rp = 10;                                            % Passband Ripple (dB)
Rs = 30;                                            % Stopband Ripple (dB)
[n,Wn] = buttord(Wp,Ws,Rp,Rs);                      % Butterworth Filter Order
[b,a] = butter(n,Wn);                               % Butterworth Transfer Function Coefficients
[SOS,G] = tf2sos(b,a);                              % Convert to Second-Order-Section For Stability
figure(3)
freqz(SOS, 4096, Fs);                               % Filter Bode Plot
title('Lowpass BUTTERWORTH Filter Bode Plot')
S = filtfilt(SOS,G,sampled_data);                              % Filter ‘X’ To Recover ‘S’
figure(4)
plot(t, sampled_data)                                          % Plot ‘X’
hold on
plot(t, S, '-r', 'LineWidth',1.5)                   % Plot ‘S’
hold on 
S_No_DC = S - mean(S);
plot(t, S_No_DC, '-g', 'LineWidth',1.5)
hold off
grid
legend('Raw Data', 'Filtered Data','Filtered Data No DC Offset' ,'Location','N')
title('Original Signal ‘X’ & Uncorrupted Signal ‘S’')
xlabel('Time (sec)')
ylabel('Amplitude')


% subplot(3,1,1)
% plot(t, sampled_data)
% title('Raw Sampled Data')
% xlabel('Time (sec)')
% ylabel('Amplitude')
% grid on;
% subplot(3,1,2)
% plot(t, S, '-r', 'LineWidth',1.5)
% title('Filtered Sampled Data')
% xlabel('Time (sec)')
% ylabel('Amplitude')
% grid on;
% subplot(3,1,3)
% S_No_DC = S - mean(S);
% plot(t, S_No_DC, '-g', 'LineWidth',1.5)
% title('Filter Data w/o DC Offset')
% xlabel('Time (sec)')
% ylabel('Amplitude')
% grid on;



N=4096; %FFT size, controls frequency Resolution
Y = 1/N*fftshift(fft(S_No_DC,N)); % N-pooint 
fr=Fs/N; %frequency resolution
sampleIndexing = -N/2:N/2-1; %ordered index for FFT plot
f=sampleIndexing*fr; %x-axis index converted to ordered frequencies
mag = abs(Y);
% For power in dB 10*log10(mag.^2)
stem(f,mag); % Magnitude plot

