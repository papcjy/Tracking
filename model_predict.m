function [x,y] = model_predict(x_last,y_last,width,height,row,column,cell_size,image,interval,parameter,model)


axes = [];F = [];testdata = [];
% keep rectangle windows in screen
if x_last-parameter<1
    x_last = 1+parameter;
end
if x_last+width+parameter>column
    x_last = column-width-parameter;
end
if y_last-parameter<1
    y_last = 1+parameter;
end
if y_last+height+parameter>row
    y_last = row-height-parameter;
end

for ii = x_last-parameter:interval:x_last+parameter
    for jj = y_last-parameter:interval:y_last+parameter
        test = imcrop(image,[ii,jj,width,height]);
        feature_type = reshape(double(fhog(single(test)/255,cell_size,9)),1,[]);
        testdata = [testdata;feature_type];
        f = [ii jj];
        axes = [axes;f];
    end
end
count = size(axes,1);
test_label = ones(count,1);
[predictlabel,accuracy,values] = svmpredict(test_label,testdata,model);
[mm,nn] = find(values == max(values(:)));
x = axes(mm,1);
y = axes(mm,2);


end

