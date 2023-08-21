%MATLAB Program 8.12 for Example 8.15
% plot the magnitude responses |H(s)| and |H(z)|
% for the Laplace transfer function H(s)
  f=0:0.1:5;T=0.1;                        % frequency range and sampling interval
  w=2*pi*f;                                 %  frequency range in radias/sec
  hs=freqs([2], [1 2],w);              % analog magnitude frequency response
  phis=180*angle(hs)/pi;
% for the z-transfer function H(z)
  hz=freqz([0.2],[1 -0.8187],length(w));   % digital magnitude frequency resoonse 
  hz_scale=freqz([0.1813],[1 -0.8187],length(w)); % scaled digital mag. response
phiz=180*angle(hz)/pi;
%plot magnitude and phase responses.
  subplot(3,1,1), plot(f,abs(hs),'kx',f, abs(hz),'k-'),grid; axis([0 5 0 1.2]);
  xlabel('Frequency (Hz)'); ylabel('Mag. Responses')
  subplot(3,1,2), plot(f,abs(hs),'kx',f, abs(hz_scale),'k-'),grid; axis([0 5 0 1.2]);
  xlabel('Frequency (Hz)'); ylabel('Scaled Mag. Responses')
  subplot(3,1,3), plot(f,phis,'kx',f, phiz,'k-'); grid;
  xlabel('Frequency (Hz)');  ylabel('Phases (deg.)');
