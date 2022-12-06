function [result] = loaddatabase(db_id)
%Load a set of images from one of the databases

folder = "Images";

should_update = true;

if should_update == false
    S = load("SavedData/normalizedfaces.mat", "faces");
    result = S.faces;
else
    if db_id == 1
        folder = folder + "/DB1/";
    
        %Pre-allocate size (needs to match normalized image)
        result = zeros(400,300,16);
    end
    for i = 1:1:16
        path = folder + "db1_" + sprintf('%02d',i) + ".jpg";
        current_image = imread(path);
        disp(i)
        current_image = normalizeface(current_image);
        result(:,:,i) = current_image(:,:);
    end
    faces = result;
    save("SavedData/normalizedfaces.mat", "faces");
end


end %end function
