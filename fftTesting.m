samples = csvread("adcQuantData.csv");                              % Data in cds
Fs=100000;                                                % Sampling Frequency
Ts=1/Fs;                                                % Sampling Interval
Fn = Fs/2;                                              % Nyquist Frequency
L = length(samples);                                          % Length Of Arrayt
t = linspace(0, 1, L);                                  % Time Vector
FTd = fft(samples)/L;                                         % Complex Fourier Transform Of sda
Fv = linspace(0, 1, fix(L/2)+1)*Fn;                     % Frequency Vector
Iv = 1:length(Fv);                                      % Matching Index Vector (For ‘FTd’ Addressing)
figure(1)
plot(Fv, abs(FTd(Iv))*2)
xlabel('frequency')
ylabel('magnitude of P1')