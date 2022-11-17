function [result] = loaddatabase(db_id)
%Load a set of images from one of the databases

folder = "Images";

if db_id == 1
    folder = folder + "/DB1/";

    %Pre-allocate size (needs to match normalized image)
    result = zeros(400,300,16);

    for i = 1:1:16
        path = folder + "db1_" + sprintf('%02d',i) + ".jpg";
        current_image = imread(path);
        current_image = normalizeface(current_image);
        result(:,:,i) = current_image(:,:);
    end
end


end %end function
