function [result] = test_coords(input)

[~, mouthCoor] = mouthmap(input);
%Calls function for eyecoordinates
%eyeCoords=geteyecoord2(input);
[leftEye,rightEye, ~] =geteyecoord3(input, mouthCoor);

%leftEye = eyeCoords(1, :);
%rightEye = eyeCoords(2, :);


figure(1)
%input = imresize(input, [400 300]);

hold on
plot(mouthCoor, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
plot(leftEye, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
plot(rightEye, 'r+', 'MarkerSize', 15, 'LineWidth', 1);
hold off

%input = imresize(input, [400 300]);
%input = rgb2gray(input);
result = input;
imshow(result);

end
