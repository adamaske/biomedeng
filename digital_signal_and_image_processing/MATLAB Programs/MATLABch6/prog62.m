% MATLAB Program 6.2 for Example 6.12
% Plot the magnitude frequency response and phase response
% Case a
  figure (1)
  [h w] = freqz([1],[1 -0.5],1024);    % calculate frequency response
  phi=180*unwrap(angle(h))/pi;      
  subplot(2,1,1), plot(w,abs(h)),grid; xlabel('Frequency (radians)'), ylabel('Magnitude')
  subplot(2,1,2), plot(w,phi),grid; xlabel('Frequency (radians)'), ylabel('Phase (degrees)')
% Case b
  figure (2)
  [h w] = freqz([1 -0.5],[1],1024);  %calculate frequency response
  phi=180*unwrap(angle(h))/pi;
  subplot(2,1,1), plot(w,abs(h)),grid;xlabel('Frequency (radians)'), ylabel('Magnitude')
  subplot(2,1,2), plot(w,phi),grid; xlabel('Frequency (radians)'), ylabel('Phase (degrees)')
% Case c
  figure (3)
  [h w] = freqz([0.5 0 -0.32],[1 -0.5 0.25],1024); % calculate frequency response
  phi=180*unwrap(angle(h))/pi;
  subplot(2,1,1), plot(w,abs(h)),grid; xlabel('Frequency (radians)'), ylabel('Magnitude')
  subplot(2,1,2), plot(w,phi),grid; xlabel('Frequency (radians)'), ylabel('Phase (degrees)')
% Case d
  figure (4)
  [h w] = freqz([1 -0.9 0.81], [1 -0.6 0.36],1024); %calculate frequency response
  phi=180*unwrap(angle(h))/pi;
  subplot(2,1,1), plot(w,abs(h)),grid; xlabel('Frequency (radians)'), ylabel('Magnitude')
  subplot(2,1,2), plot(w,phi),grid; xlabel('Frequency (radians)'), ylabel('Phase (degrees)')
%
