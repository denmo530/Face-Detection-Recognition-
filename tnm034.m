function id = tnm034(im)


%% im: Image of unknown face, RGB-image in uint8 format in the 
% range [0,255]
%% id: The identity number (integer) of the identified person,
% i.e. ‘1’, ‘2’,...,‘16’ for the persons belonging to ‘db1’ % and ‘0’ for all other faces.
%% Your program code

%Add seperate path
addpath(genpath("facefunctions"));
addpath(genpath("eigenfacefunctions"));

%Normalize input image
    normalized_image = normalizeface(im);

%Get feature vector of input
    %Load eigenfaces form database (DB1)
    S = load('SavedData/u_i.mat', "u_i","u");
    u_i = [S(:).u_i];
    meanface = [S(:).u];

    %Generate feature vector
    input_featureVector = getFeatureVector(normalized_image, u_i, meanface);


%Compare input feature vector to database
    %Load feature vectors from database
    S = load("SavedData/featurevectors.mat", "featureVectors");
    featureVectors = [S(:).featureVectors];

    %Find shortest distance (best match)
    distances = zeros(1,size(featureVectors,1));    %Pre allocate
    for j = 1:16
        distances(:,j) = norm(input_featureVector(:) - featureVectors(:,j));
    end
    shortest = min(min(distances));

%Return -1 if image is not in database
    no_match_threshold = 5.0e+06;
    
    if(shortest > no_match_threshold)
        id = -1;
    else
        id = find(distances == min(min(distances)));
    end
end