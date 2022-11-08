function [rgbImg] = whiteworld(input)
%Some part of each image should be ”real white” (the lightest parts of the image)
%   Detailed explanation goes here

[r, g, b] = imsplit(input);

% TODO If Gmax is too small, first scale up the green intensity

r_max = max(r); 
g_max = max(g); 
b_max = max(b); 


alpha = g_max./r_max; 
beta = g_max./b_max; 

r_gain = alpha.*r; 
g_gain = g; 
b_gain = beta.*b; 


rgbImg = cat(3, r_gain, g_gain, b_gain); 

end