%{
sky ??                   128 128 128
building ??          128 0 0
Pole ???              192 192 128
Road Marking ?? 255 69 0
Road ??                128 64 128
Pavement ???     60 40 222
Tree ??                 128 128 0
Sign Symbol ??? 192 128 128
Fence ?? ??       64 64 128
Vehicle ??             64 0 128
Pedestrian ??       64 64 0
Bike ???	           0 128 192
%}
label = [128 128 128;
128 0 0;
192 192 128;
255 69 0;
128 64 128;
60 40 222;
128 128 0;
192 128 128;
64 64 128;
64 0 128;
64 64 0;
0 128 192;
];
%change the path to your directory
path = '/Users/marcWong/Matlab/segmenationProcess/';

%change the outputPath to your directory
outputPath = '/Users/marcWong/Matlab/segmenationProcess/';

listing = dir([path '*.jpg']);
fileSum = length(listing);
display(['image sum =  ' num2str(fileSum)]);
threshold = 50;
range = 4;
tag = double(zeros(360,480));
outputimg = uint8(zeros([360 480 3]));
%%
for imgNum=1:fileSum
    tmp_img = imread([path,listing(imgNum).name]);
    
    %imshow(tmp_img);
    cnt = 0;
    
    %multi-tagged pixel
    for i = 1:360
        for j = 1:480
            dist = double(zeros(12,1));
            for t = 1:12
                dist(t) = dis(tmp_img(i,j,1),tmp_img(i,j,2),tmp_img(i,j,3),label,t);
            end
            if length(find(dist<threshold)) == 1
                tag_mostlikely = find(dist<threshold);
            elseif isempty(find(dist<threshold, 1))
                continue;
            else
                s = find(dist<threshold);
                tag_mostlikely = s(ceil(rand()*length(s)));
            end
            tag(i,j) = tag_mostlikely; 
            if tag_mostlikely<13 && tag_mostlikely>0
                outputimg(i,j,1) = label(tag_mostlikely,1);
                outputimg(i,j,2) = label(tag_mostlikely,2);
                outputimg(i,j,3) = label(tag_mostlikely,3);
            end
        end
    end
    
    %untagged pixel, search the nearby pixels, find the most frequent label
    for i = 1:360
        for j = 1:480
             if(tag(i,j)==0)
                  t = zeros(12,1);
                  for m = -range:range
                        for n =-range:range
                        if( (i+m)>0 && (i+m)<361 && (j+n)>0 && (j+n)<481 )
                            if(tag(i+m,j+n)>0)
                                t(tag(i+m,j+n)) = t(tag(i+m,j+n)) + 1;
                            end
                        end
                        end
                 end
                 tag_near = find(max(t(:)));
                 if length(find(max(t(:)))) == 1
                       tag_near = find(max(t(:)));
                 elseif max(t(:)) == 0
                       continue;
                 else
                       s = find(max(t(:)));
                       tag_near = s(ceil(rand()*length(s)));
                 end
                 tag(i,j) = tag_near; 
                 if tag_near<13 && tag_near>0
                       outputimg(i,j,1) = label(tag_near,1);
                       outputimg(i,j,2) = label(tag_near,2);
                       outputimg(i,j,3) = label(tag_near,3);
                 end  
             end
        end
        if(tag(i,j)==0)
                    cnt = cnt +1 ;
        end
    end
    %}
    display(['unfilled points = ' num2str(cnt)]);
    %imshow(outputimg,'InitialMagnification','fit');
    imwrite(outputimg,[outputPath 'refine_' listing(imgNum).name]);
    dlmwrite([outputPath 'tag_' listing(imgNum).name '.txt'],tag,'delimiter',' ');
end