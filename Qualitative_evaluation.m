clc
clear all
close all

base_path = './data/Benchmark/';
video = choose_video(base_path);
video_path = [base_path video '/'];
addpath([video_path 'img']);
img_dir = dir([video_path 'img' '/'  '*.jpg']);

tld = load('./results/football_TLD.mat');
struck = load('results/football_Struck.mat');
mil = load('results/football_MIL.mat');
ct = load('results/football_CT.mat');
proposed = load('my results/football.mat');
kcf = load('kcf results/football.mat');


for frame = 1:320
    the_image = imread(img_dir(frame).name); %read the current frame image
   % the_image = rgb2gray(the_image);
%     imagesc(the_image);%show the rgb image
%     set(gca,'position',[0 0 1 1]);
    imshow(the_image);
    rect_tld = tld.results{1,1}.res(frame,:);
    rect_struck = struck.results{1,9}.res(frame,:);
    rect_mil = mil.results{1,6}.res(frame,:);
    rect_ct = ct.results{1,6}.res(frame,:);
    rect_proposed = proposed.positions(frame,:);
    rect_kcf = kcf.a(frame,:);
    
    rectangle('Position',rect_tld,'EdgeColor','b','LineWidth',2);
    rectangle('Position',rect_struck,'EdgeColor','r','LineWidth',2);
    rectangle('Position',rect_mil,'EdgeColor','m','LineWidth',2);
    rectangle('Position',rect_ct,'EdgeColor','y','LineWidth',2);
    rectangle('Position',rect_proposed,'EdgeColor','c','Linestyle','--','LineWidth',3);
    rectangle('Position',rect_kcf,'EdgeColor','g','LineWidth',2);
    drawnow;
end
figure;
plot(1:10,'c--','LineWidth',3);
hold on
plot(1:10,'g','LineWidth',2);
plot(1:10,'b','LineWidth',2);
plot(1:10,'r','LineWidth',2);
plot(1:10,'m','LineWidth',2);
plot(1:10,'y','LineWidth',2);
legend('Proposed','KCF','TLD','Struck','MIL','CT');
