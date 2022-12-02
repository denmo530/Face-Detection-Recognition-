function [result] = normalizeface(input)
%Take image of a face and normalize the image in terms of scale, rotation
%and tone values. The image will have a set resolution which is important
%for later steps.


input = im2double(input); %Not sure if this is prefered

%Automatic White Balancing, AWB
input = grayworld(input);

%Create eye map

%Decide position of the eyes
    %TODO implement method to find eye position based on eyemaps
left_eye = [176 279];
right_eye = [283 275];

angle = atan2(right_eye(2) - left_eye(2), right_eye(1) - left_eye(1));
angle = angle * 180 / pi;

rotated = imrotate(input, angle);



imshow(input)
hold on
plot(176,279, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
plot(283,275, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
hold off
%plot(176,279, 'r+', 'MarkerSize', 15, 'LineWidth', 1);

[~, mouthCoor] = mouthmap(input);

plot(mouthCoor, 'r+', 'MarkerSize', 15, 'LineWidth', 1);

%Rotate Image
    %TODO rotate image based on eye positions.

%Scale image to another resolution
    %TODO scale might be changed when previous steps are fixed
input = imresize(input, [400 300]);

%Change color space to grayscale
input = rgb2gray(input);

result = input;

end