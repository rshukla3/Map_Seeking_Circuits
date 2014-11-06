function [New_Memory_img_Coordinates_Sorted, New_Test_img_Coordinates_Sorted] = getPointsForRotation(Memory_img_Coordinates_Sorted, Test_img_Coordinates_Sorted)
%getPointsForScaling Gets the points of interest during scaling.
%   When the image is scaled the memory image and test image might have
%   different number of pixels. Thus, to take care of this issue we first
%   compare the sizes of two sorted arrays. If they are different then we
%   perform the necessary changes for scaling.

[Mm, Mn] = size(Memory_img_Coordinates_Sorted);
[Tm, Tn] = size(Test_img_Coordinates_Sorted);

if(Mm > Tm)
    % This means image has been scaled down. This means memory has more
    % number of pixels than Test_img.
    fprintf('Image has been scaled down\n');
    New_Test_img_Coordinates_Sorted = Test_img_Coordinates_Sorted;
    New_Memory_img_Coordinates_Sorted = single(zeros(Tm, Tn));
    
    for i = 1:Tm
        [row, column] = find(Memory_img_Coordinates_Sorted(:,3) == Test_img_Coordinates_Sorted(i,3));
        if(row)
            New_Memory_img_Coordinates_Sorted(i,:) = Memory_img_Coordinates_Sorted(row(1),:);
        end
    end
    
    %New_Memory_img_Coordinates_Sorted
    %New_Test_img_Coordinates_Sorted
    
elseif(Tm >= Mm)
    % This means image has been scaled up. This means memory has less
    % number of pixels than Test_img.
    fprintf('Image has been scaled up\n');
    
    
    
    index = 1;
    
    for i = 1:1:Mm
        [row, column] = find(Test_img_Coordinates_Sorted(:,3) == Memory_img_Coordinates_Sorted(i,3));
        if(row)
            New_Test_img_Coordinates_Sorted(index,1) = Test_img_Coordinates_Sorted(row(1),1);
            New_Test_img_Coordinates_Sorted(index,2) = Test_img_Coordinates_Sorted(row(1),2);
            New_Test_img_Coordinates_Sorted(index,3) = Test_img_Coordinates_Sorted(row(1),3);
            New_Memory_img_Coordinates_Sorted(index,1) = Memory_img_Coordinates_Sorted(i,1);
            New_Memory_img_Coordinates_Sorted(index,2) = Memory_img_Coordinates_Sorted(i,2);
            New_Memory_img_Coordinates_Sorted(index,3) = Memory_img_Coordinates_Sorted(i,3);
            
            index = index + 1;
        end
        
        if(index > Mm)
            break;
        end
    end
    New_Test_img_Coordinates_Sorted = sortrows(New_Test_img_Coordinates_Sorted, 3);    
    
    
else
    New_Memory_img_Coordinates_Sorted = Memory_img_Coordinates_Sorted;
    New_Test_img_Coordinates_Sorted = Test_img_Coordinates_Sorted;
end

