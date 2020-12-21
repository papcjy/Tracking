clc
clear all
close all

%% initialization

base_path = './data/Benchmark/';
video = choose_video(base_path);
video_path = [base_path video '/'];
addpath([video_path 'img']);
img_dir = dir([video_path 'img' '/'  '*.jpg']);
Img = imread([video_path 'img' '/' '0001.jpg']);
groundtruth = importdata([video_path 'groundtruth_rect.txt']);
kcf = load([video_path video '.mat']);
tld = load('./results/football_TLD.mat');
struck = load('results/football_Struck.mat');
mil = load('results/football_MIL.mat');
ct = load('results/football_CT.mat');

[row,column,z] = size(Img);
rect = groundtruth(1,:); %read initial position
width = rect(1,3);
height = rect(1,4);

train_windows_size = 15;
cell_size = 8;
search_step_len = 4;
search_windows_size = 4;
positions = [];

T=1;
Y_x=zeros(2,numel(img_dir));
Y0_x=[rect(1,1);0];
Y_x(:,1)=Y0_x;

Y_y=zeros(2,numel(img_dir));
Y0_y=[rect(1,2);0];
Y_y(:,1)=Y0_y;

A=[1 T; 0 1];   %%×´Ì¬×ªÒÆ¾ØÕó       
B=[-1;2]; %%ÔëÉù¾ØÕó[-1;2] [0.5;1]
H=[1 0];  %%¹Û²â¾ØÕó
C0_x=[0 0;0 1];
C_x=[C0_x zeros(2,2*(numel(img_dir)-1))];
C0_y=[0 0;0 1];
C_y=[C0_y zeros(2,2*(numel(img_dir)-1))];
Q=1; 
R=1; 
xxx=[];



%% train samples

%Img = rgb2gray(Img);
[model] = model_train(rect(1,1),rect(1,2),rect(1,3),rect(1,4),...
cell_size,Img,train_windows_size); %use svm train

%% read video

time = 0;
for frame = 1:numel(img_dir)
    the_image = imread(img_dir(frame).name); %read the current frame image
   % the_image = rgb2gray(the_image);
    imagesc(the_image);%show the rgb image
    set(gca,'position',[0 0 1 1]);
    positions = [positions;rect];
    tic(); 
    [K_x,C_x,Y_x] = kalman_filter(frame,rect(1,1),H,A,B,C_x,Q,R,Y_x);
    [K_y,C_y,Y_y] = kalman_filter(frame,rect(1,2),H,A,B,C_y,Q,R,Y_y);
    if frame>1
        x1 = Y_x(1,frame)+Y_x(2,frame)+0.5*(Y_x(2,frame)-Y_x(2,frame-1));
        y1 = Y_y(1,frame)+Y_y(2,frame)+0.5*(Y_y(2,frame)-Y_y(2,frame-1));
    else 
        x1 = Y_x(1,frame+1);
        y1 = Y_y(1,frame+1);
    end
    [x,y] = model_predict(x1,y1,width,height,...
    row,column,cell_size,the_image,search_step_len,search_windows_size,model);
    rect = [x,y,width,height]; 
    rectangle('Position',rect,'EdgeColor','y','LineWidth',2);
    time = time+toc();  
    xxx = [xxx;x1];
    drawnow;
end
precision_plot(positions,groundtruth,video,1,kcf.precisions,tld.results{1,6}.res...
,struck.results{1,10}.res,mil.results{1,6}.res,ct.results{1,6}.res); %print plot
FPS = numel(img_dir)/time %calculate fps