%MATLAB Program 10.11
%this program is written for off-line simulation 
clear all; close all
load speech.dat  % provided by the instructor
speech=speech;
desig= speech;
lg=length(desig);                               % length of speech data
enc = adpcmenc(desig);                    % ADPCM encoding
%ADPCM finished
dec = adpcmdec(enc);                       % ADPCM decoding 
snrvalue = snr(desig,dec)               % calculate signal to noise ratio due to quantization
subplot(3,1,1);plot(desig);grid;
ylabel('Speech');axis([0 lg -18000 18000]);
subplot(3,1,2);plot(dec);grid;
ylabel('Quantized speech');axis([0 lg -18000 18000]);
subplot(3,1,3);plot(desig-dec);grid
ylabel('Quantized error');xlabel('Sample number');
axis([0 lg -5000 5000]);
