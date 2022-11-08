function [rgbImg] = eyemapC(input)

img_ycbcr = rgb2ycbcr(input);

[Cr, ~, Cb] = imsplit(img_ycbcr);

% TODO If Gmax is too small, first scale up the green intensity

%Empirical cumulative distribution function? (Motsvarar tilde CR)
%empCr = ecdf(Cr);

rgbImg = (1/3)*((Cb.^2)+(Cr.^2)+(Cb./Cr)); 

end