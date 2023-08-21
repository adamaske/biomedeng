function snr = calcsnr(speech, qspeech)
% function snr = calcsnr(speech, qspeech)
% this routine is created for calculation of SNR
% 
%  speech: original speech waveform.
%  qspeech: quantized speech.
%  snr: output SNR in dB.
%  
%  Note: midrise method is used in this quantizer.
%
  qerr = speech-qspeech;
  snr = 10*log10(sum(speech.*speech)/sum(qerr.*qerr))
