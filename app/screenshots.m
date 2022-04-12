filename = 'adcQuantData.csv';
sampled_data = load(filename);
Fs = 100000;                                        % Sampling Rate: 100000 Hz
T = 1/Fs;                                           % Sampling period 
L = 49149;                                          % Signal Sample Lenght 
t = (0:L-1)*T;                                      % Convert to Time Vector
Fn = Fs/2;                                          % Nyquist Frequency Crit
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                 % Vector of Frequencies
Iv = 1:length(Fv);                                  % Vector to index frequencies (For filter parameters) 





N=41949; %FFT size, controls frequency Resolution
fft_result = 1/N*fftshift(fft(S_No_DC,N)); % N-pooint 
fr=Fs/N; %frequency resolution
sampleIndexing = -N/2:N/2-1; %ordered index for FFT plot
f=sampleIndexing*fr; %Order frequency based on resolution
mag = abs(fft_result);
% For power in dB 10*log10(mag.^2)
stem(f,mag); % Magnitude plot



[max_Freq,max_IV] = max(abs(FXdcoc(Iv))*2);          % Get Maximum Amplitude, & Frequency Index Vector
Wp = 2*Fv(max_IV)/Fn;                               % Normalized PASS BAND FREQ
Ws = Wp*2;                                          % Normalized STOP BAND FREQ
Rp = 10;                                            % Passband RIPPLE
Rs = 30;                                            % Stopband Ripple
[n,Wn] = buttord(Wp,Ws,Rp,Rs);                      % Obtain minimum order and cut-off freq of butterworth filter
[b,a] = butter(n,Wn);                               % Obtain IIR transfer function coefficients
[SOS,G] = tf2sos(b,a);                              % Use to stabilize filter characterisitics 
%           freqz(SOS, 4096, Fs);                               % Filter Bode Plot for mag and phase
%           title('Lowpass Filter Bode Plot')
S = filtfilt(SOS,G,data);                          % Filter filter Raw Data and get signal S