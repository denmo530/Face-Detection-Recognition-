function [] = normalizeface(input)
%Take image of a face and normalize the image in terms of scale, rotation
%and tone values. The image will have a set resolution which is important
%for later steps.


%input = im2double(input); %Not sure if this is prefered

%Automatic White Balancing, AWB
input = grayworld(input);


%Calls function for eyecoordinates
eyeCoords=geteyecoord2(input);

leftEye = eyeCoords(1, :);
rightEye = eyeCoords(2, :);

figure(1)
imshow(input);
hold on
plot(leftEye,rightEye, 'rx','MarkerSize', 15, 'LineWidth', 1);
hold off

%angle = atan2(right_eye(2) - left_eye(2), right_eye(1) - left_eye(1));
%angle = angle * 180 / pi;

%rotated = imrotate(input, angle);

%[~, mouthCoor] = mouthmap(input);

%imshow(input)
%hold on
%plot(mouthCoor, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
%plot(left_eye, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
%plot(right_eye, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
%hold off
%plot(176,279, 'r+', 'MarkerSize', 15, 'LineWidth', 1);



%Rotate Image
    %TODO rotate image based on eye positions.

%Scale image to another resolution
    %TODO scale might be changed when previous steps are fixed
%input = imresize(input, [400 300]);

%Change color space to grayscale
%input = rgb2gray(input);

%result = input;

end