 % Audio read on .wav file 
 % x stores wave, s stores sampling rate 
 
[x, fs]=audioread('ABSOLUTE_PATH_TO\wavefile.wav'); 
 
% Perform FFT on original signal to determine frequency of noise 

L=length(x); 
NFFT=2^nextpow2(L);
X=fft(x,NFFT)/fs; 
 
 % Show user sampling rate
fs 
 

% Plot single-sided amplitude spectrum (to find source of noise)
f=fs/2*linspace(0,1,NFFT/2+1); 
plot(f,2*abs(X(1:NFFT/2+1))); 

% can now find the frequency we need to remove (noise is pure sine wave)
% set fkill (normalized to frequency of fs/2) 

fkill= SETVALUE; 
 
% Determine coefficients of the FIR filter that will remove noise frequency.  
% Note: the following filter only works with EVEN numbers. 
 
coeff=firgr(SETVALUE,[0,fkill-0.1, fkill, fkill+0.1, 1], [1,1,0,1,1],{'n','n','s','n','n'}); 
 
% Plot the filter, and frequency response of designed filter to ensure it satifies requirements
freqz(coeff,1); 
coeff*32768 
fid=fopen('ABSOLUTE_PATH_TO\Your_Text_File_Name','w'); 
 
for i=1:length(coeff) 
fprintf(fid,'coeff[%3.0f]=%10.0f;\n',i-1,32768*coeff(i)); 
end 
 
fclose(fid); 
 
% Filter the input signal x(t) using the designed FIR filter to get y(t)
y=filtfilt(coeff,1,x);  
 
% Perform FFT on the filtered signal to observe the absence of frequency of noise
Y=fft(y,NFFT)/L; 
 
% play unfiltered sound (3 times louder, seems to be required in order for human hearing) 
sound(3*x,fs); 
 
% Play the filtered sound, check if filter is designed properly
sound(3*y,fs); 

subplot(2,1,1); 
 
% FFT of original signal
plot(f,2*abs(X(1:NFFT/2+1))); xlabel('frequency (Hz)'); ylabel('|X(f)|'); 
 
% FFT of filtered signal
subplot(2,1,2); plot(f, 2*abs(Y(1:NFFT/2+1))); xlabel('frequency(Hz)'); 
 
% filtered .wav file 
audiowrite('ABSOLUTE_PATH_TO\filteredwavefile.wav',y,fs); 
