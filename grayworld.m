function [rgbImg] = grayworld(input)
%grayworld Summary of this function goes here
%   Detailed explanation goes here

[r, g, b] = imsplit(input);

r_avg = mean2(r); 
g_avg = mean2(g); 
b_avg = mean2(b); 
% TODO return if equal

alpha = g_avg/r_avg; 
beta = g_avg/b_avg; 

r_gain = alpha*r; 
g_gain = g; 
b_gain = beta*b; 

rgbImg = cat(3, r_gain, g_gain, b_gain); 

end