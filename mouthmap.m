function [result, mouthCenter] = mouthmap(input)
%Generates mouthmap from image.

%Convert Image
img_ycbcr = (rgb2ycbcr(input));

Y = mat2gray(img_ycbcr(:,:,1)) +1;
Cb = mat2gray(img_ycbcr(:,:,2)) +1;
Cr = mat2gray(img_ycbcr(:,:,3)) +1;

%eta = η
%n = numel(input);

eta = 0.95 * (mean(Cr(:).^2))/(mean(Cr(:)./Cb(:)));


%TODO Mouthmap doesnt seem to work atm
%MouthMap:
result = (Cr.^2).*((Cr.^2) - eta*(Cr./Cb)).^2;
result = (result- min(result(:)))/(max(result(:)) - min(result(:)));

%MouthMask
se1 = strel('disk', 8);
result = result > 0.3;
result = bwareaopen(result, 200);
result = imdilate(result, se1);

L = bwlabel(result);
%Get the area and center point of all mouth candidates
stats = regionprops(L, "Area", "Centroid");
area = zeros(size(stats));
center = zeros(length(stats),2);
%save intermidate variables
for i = 1:length(stats)
    area(i) = stats(i).Area;
    center(i,:) = stats(i).Centroid;
end
%The mouth candidate with largest area is chosen
largestMouth = find(max(area));
%Create a new mask with only the largest mouth
newMouthMask = zeros(size(result));
if largestMouth ==1
    newMouthMask(L == largestMouth) = 1;
end
output_image = newMouthMask;
result = output_image;
mouthCenter = center(largestMouth, :);

end