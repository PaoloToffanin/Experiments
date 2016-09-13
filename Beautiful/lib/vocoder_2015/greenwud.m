function [lower,center,upper]= greenwud(N, range, dbg)
%

% [lower,center,upper] = greenwud(N,low,high)
%
% This function returns the lower, center and upper freqs
% of the filters equally spaced according to Greenwood's equation
% Input: N - number of filters
% 	 low - (left-edge) 3dB frequency of the first filter
%	 high - (right-edge) 3dB frequency of the last filter

% Stuart Rosen -- June 1998

if length(range) == 2
    low = range(1);
    high = range(2);
    % Set up equally spaced places on the basilar membrane
    places = [0:N]*(frq2mm(high)-frq2mm(low))/N + frq2mm(low);
    % Also calculate centre frequencies according to the same mapping
    centres = (places(1:N) + places(2:N+1))/2;
    % convert these back to frequencies
    freqs = mm2frq(places);
    center = mm2frq(centres);
else
    centres = range;
    mdpt = (centres(2) - centres(1))/2;
    places = zeros(N+1,1);
    places(1) = centres(1) - mdpt;
    places(2:N+1) = centres(1:N) + mdpt;
    
    % convert these back to frequencies
    freqs = sort(x2frq(places));
    center = sort(x2frq(centres))';
    high = x2frq(range(1));
    low = x2frq(range(N));
end





if dbg==1
	 f=low:100:high;
	 plot(f, frq2mm(f));
	 grid
	 hold on 
 end

 lower=zeros(1,N); upper=zeros(1,N); 
 lower(1:N)=freqs(1:N);
 upper(1:N)=freqs(2:N+1);

  if dbg==1,  
   plot(center,ones(1,N),'ro');

 end;
