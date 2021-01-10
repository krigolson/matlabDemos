clear all;
close all;
clc;

% a demo by Olav Krigolson to help explain the output of the FFT transform
% in MATLAB

% big respect to Michael X Cohen who taught me all of this

% fourier transform outputs N frequencies where N is the length of the data
% that is put into the FFT
% why N? the Fourier transform reflects the dot product between the data and
% a series of complex sine waves (cos + isin)(although in practice the
% complex sine waves are expressed using Eulers number (exp(-1i2*pi*ft)). N
% comes from a loop when you use a number of sine waves equivalent to the
% number of points in the data (thats how its done)
% in terms of represented frequenies, you get N/2 + 1 because the lowest frequency is 0 Hz whcih represents the DC offset for EEG signals for example.
% The represented fourier coefficents include both positive and negative
% frequencies so only the first half of the output makes sense for real signals and the negative aspect will just be a mirror image if the first.
% The other reason it is n/2 is because you need two points to represent a
% sine wave thus the fastest frequency is N/2

% we will define our sine wave in terms of a sampling rate
samplingRate = 1000;

% time step, or period of the signal
timeInterval = 1/samplingRate;

% the length of our sine wave
timeLength = 1;

% create a time vector to make the sine wave
time = (timeInterval:timeInterval:timeLength);

% compute the number of data points, we will use this later
N = length(time);

% give an amplitude to the sine wave
amplitude = 5;

% give the  sine wave a frequency
sineWaveFrequency = 15;

% create a sine wave
sineWave = amplitude.*sin(2*pi*sineWaveFrequency.*time);

% plot the sine wave
figure;
subplot(2,2,1);
plot(time,sineWave);

% run the fourier transform and get the fourier coefficients
fourierCoefficients = fft(sineWave);

% plot the output of the fft
subplot(2,2,3);
plot([1:1:length(fourierCoefficients)],fourierCoefficients);

% the length of the output of an fft is equivalent to the number of data
% points, to prove this, lets look at a second waveform

timeLength2 = 5;
time2 = (timeInterval:timeInterval:timeLength2);
sineWave2 = amplitude.*sin(2*pi*sineWaveFrequency.*time2);

fourierCoefficients2 = fft(sineWave2);

% lets plot and compare the difference

subplot(2,2,2);
plot(time2, sineWave2);

subplot(2,2,4);
plot([1:1:length(fourierCoefficients2)],fourierCoefficients2);

% we need to scale the output by the number of data points because of the
% way the fourier transform is done. The dot product between complex sine
% waves and the data is summed and gets bigger the more data you put in

fourierCoefficientsScaled = fourierCoefficients/length(fourierCoefficients);

% plot scaled coefficients

figure;
plot([1:1:length(fourierCoefficients)],fourierCoefficientsScaled);

% take the magnitude of the output as this is all we need, we do not care
% about the imaginary aspect just the magnitude

fourierCoefficientsScaled = abs(fourierCoefficientsScaled);

% remove the negative frequencies

positiveFourierCoefficients = fourierCoefficientsScaled(1:(length(fourierCoefficientsScaled)/2)+1);

% determine the frequency resolution - remember, this is related to the
% amount of data you put in

frequencyResolution = samplingRate/N;
frequencies = [0:frequencyResolution:N/2];

% lets plot what we have

figure;
subplot(2,1,1);
plot(frequencies,positiveFourierCoefficients);

% double the amplitude to correct for the amplitude that was shared with
% the negative frequencies

correctFourierCoefficients = 2*positiveFourierCoefficients;

subplot(2,1,2);
plot(frequencies,correctFourierCoefficients);

% to compute power square the amplitude

power = correctFourierCoefficients^2;

% now, if you are interested in phase, that is simply the angle between the
% real and imaginary components of the fourier coefficients

phase = angle(fourierCoefficientsScaled);

% the other logic we used is true for phase so you want to only keep the
% positive frequencies

phase = phase(1:length(phase)/2+1);

% and you will want to double this as you have lost something with the
% negative frequencies

phase = 2*phase;