Fs = 100000;            % Sampling frequency                    
Ts=1/Fs;           % Sampling period       
L = 49149;             % Length of signal
t = (0:L-1)*Ts;        % Time vector
S = 0.5*sin(2*pi*50*t);

plot(t,S);
N=length(S);
F = fft(S);

P2 = abs(F/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')