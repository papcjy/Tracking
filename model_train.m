function [model] = model_train(x,y,width,height,cell_size,Image,parameter)

feature_type = [];
pos = imcrop(Image,[x,y,width,height]);
feat_pos = reshape(double(fhog(single(pos)/255,cell_size,9)),1,[]);
feature_type = [feature_type;feat_pos];
Labels(1,1) = 1;
negative_samples = [...
            x-parameter,y-parameter,width,height;
            x,y-parameter,width,height;
            x+parameter,y-parameter,width,height;
            x+parameter,y,width,height;
            x+parameter,y+parameter,width,height;
            x,y+parameter,width,height;
            x-parameter,y+parameter,width,height;
            x-parameter,y,width,height];
for i = 1:8
    neg = imcrop(Image,negative_samples(i,:));
    feat_neg = reshape(double(fhog(single(neg)/255,cell_size,9)),1,[]);
    feature_type = [feature_type;feat_neg];
    Labels(i+1,1) = -1;
end
% subplot(3,3,1);
% imshow(imcrop(Image,negative_samples(1,:)));
% subplot(3,3,2);
% imshow(imcrop(Image,negative_samples(2,:)));
% subplot(3,3,3);
% imshow(imcrop(Image,negative_samples(3,:)));
% subplot(3,3,6);
% imshow(imcrop(Image,negative_samples(4,:)));
% subplot(3,3,9);
% imshow(imcrop(Image,negative_samples(5,:)));
% subplot(3,3,8);
% imshow(imcrop(Image,negative_samples(6,:)));
% subplot(3,3,7);
% imshow(imcrop(Image,negative_samples(7,:)));
% subplot(3,3,4);
% imshow(imcrop(Image,negative_samples(8,:)));
% subplot(3,3,5);
% imshow(pos);


model = svmtrain(Labels,feature_type,'-w1 1 -w-1 0.125 -t 2');  


end

