% Fs = 100000;                    % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 49149;                     % Length of signal
% 
% y = csvread('test.csv');
% 
% 
% NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(y,NFFT)/L;
% f = Fs/2*linspace(0,1,NFFT/2+1);
% 
% % Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (kHz)')
% ylabel('|Y(f)|')


Fs=100000;
Ts=1/Fs;

y = load('adcQuantData.csv');
N=length(y);
F=fft(y);
% 10*log10(mag.^2)
mag = abs(F);
fr=(-N/2:N/2-1)*Fs/(N);
figure, plot(fr,mag)
xlabel(' frequency Hz')


% Fs=100000;
% Ts=1/Fs;
% 
% y = load('adcQuantData.csv');
% N=length(y);
% F=fft(y);
% 
% mag = abs(F);
% fr=(-N/2:N/2-1)*Fs/(N);
% figure, plot(fr,mag)
% xlabel(' frequency Hz')