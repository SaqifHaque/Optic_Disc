clc;
clear all;
close all;

[fname, path] = uigetfile('*.PNG','Enter an Image');
fname=strcat(path,fname);
im=imread(fname);
subplot(2,2,1)
imshow(im)
title('Retina Image')
%%Color Chanel Separation
imR=im;
imR(:,:,2:3)=0;
subplot(2,2,2);
imshow(imR);
title('Red Image')

imB=im;
imB(:,:,1:2:3)=0;
subplot(2,2,3);
imshow(imB);
title('Green Image')

imG=im;
imG(:,:,1:2)=0;
subplot(2,2,4);
imshow(imG);
title('Blue Image')
%{
%%take Red Channel and Process it
imR=imR(:,:,1);

figure;
imshow(imR);
title('Candidate for Disc Extraction');
%imR=imerode(imR,strel('disk',15));
%imR=imdilate(imR,strel('disk',17));
se = strel('disk',25);
imR=imclose(imR,se);
figure;

imshow(imR);
title('Removing the Veins');


%imR=imR>170;
imD = reshape(imR,[],1);
imD=double(imD);

[IDX, nn obj] =fcm(imD,6);
save nn.mat
save IDX.mat
save obj.mat

load nn.mat
load IDX.mat
load obj.mat

c1=nn(1,:);
c2=nn(2,:);
c3=nn(3,:);
c4=nn(4,:);
c5=nn(5,:);
c6=nn(6,:);


imIDX1 = reshape(c1,size(imR));
imIDX2 = reshape(c2,size(imR));
imIDX3 = reshape(c3,size(imR));
imIDX4 = reshape(c4,size(imR));
imIDX5 = reshape(c5,size(imR));
imIDX6 = reshape(c6,size(imR));


imIDX1=imerode(imIDX1,strel('disk',40));
imIDX1=imdilate(imIDX1,strel('disk',30));

imIDX2=imerode(imIDX2,strel('disk',40));
imIDX2=imdilate(imIDX2,strel('disk',30));

imIDX3=imerode(imIDX3,strel('disk',40));
imIDX3=imdilate(imIDX3,strel('disk',30));

imIDX4=imerode(imIDX4,strel('disk',40));
imIDX4=imdilate(imIDX4,strel('disk',30));

imIDX5=imerode(imIDX5,strel('disk',40));
imIDX5=imdilate(imIDX5,strel('disk',30));

imIDX6=imerode(imIDX6,strel('disk',40));
imIDX6=imdilate(imIDX6,strel('disk',30));


figure;

subplot(2,3,1),imshow(imIDX1),title('cluster 1');
subplot(2,3,2),imshow(imIDX2),title('cluster 2');
subplot(2,3,3),imshow(imIDX3),title('cluster 3');
subplot(2,3,4),imshow(imIDX4),title('cluster 4');
subplot(2,3,5),imshow(imIDX5),title('cluster 5');
subplot(2,3,6),imshow(imIDX6),title('cluster 6');

%segmentation
imM=double(im);
im1=double(imIDX1);
for(i=1:3)
    imD1(:,:,i)=im1.*imM(:,:,i);
end
imS1=uint8(imD1);

im2=double(imIDX2);
for(i=1:3)
    imD2(:,:,i)=im2.*imM(:,:,i);
end
imS2=uint8(imD2);

im3=double(imIDX3);
for(i=1:3)
    imD3(:,:,i)=im3.*imM(:,:,i);
end
imS3=uint8(imD3);

im4=double(imIDX4);
for(i=1:3)
    imD4(:,:,i)=im4.*imM(:,:,i);
end
imS4=uint8(imD4);

im5=double(imIDX5);
for(i=1:3)
    imD5(:,:,i)=im5.*imM(:,:,i);
end
imS5=uint8(imD5);

im6=double(imIDX6);
for(i=1:3)
    imD6(:,:,i)=im6.*imM(:,:,i);
end
imS6=uint8(imD6);

figure;


subplot(2,3,1),imshow(imS1),title('cluster 1');
subplot(2,3,2),imshow(imS2),title('cluster 2');
subplot(2,3,3),imshow(imS3),title('cluster 3');
subplot(2,3,4),imshow(imS4),title('cluster 4');
subplot(2,3,5),imshow(imS5),title('cluster 5');
subplot(2,3,6),imshow(imS6),title('cluster 6');


%}

%%Morphological Processing
%imD=imerode(imIDX1,strel('disk',13));
%imD=imdilate(imD,strel('disk',13));

%figure;
%imshow(imD);
%title('Morphological processed disc binary image');


%%take Green Channel and Process it

imG=im(:, :, 2);
if isinteger(imG)
    z = intmax(class(imG))-imG;
elseif isfloat(imG)        
    z = 1 - y;
elseif islogical(imG)
    z = ~imG;
else
    error('Strange image you''ve got there...');
end
figure;
imshow(z);
%%clahe Image
J = adapthisteq(z);
figure;
imshow(J);
se = strel('ball',20,20); 
gopen = imopen(J,se);
J = J - gopen;
imshow(J);
figure;

medfilt = medfilt2(J); 
imshow(medfilt);
figure;                                                                     %2D Median Filter
background = imopen(medfilt,strel('disk',100));                                                                 %imopen function
I2 = medfilt - background;
imshow(I2); 
figure;                                                    %Remove Background
GC = imadjust(I2);
imshow(GC);
imV = reshape(GC,[],1);
imV=double(imV);

[IDX, nn obj] =fcm(imV,4);
save nn.mat
save IDX.mat
save obj.mat

load nn.mat
load IDX.mat
load obj.mat

c1=nn(1,:);
c2=nn(2,:);

c3=nn(3,:);
c4=nn(4,:);
%{
c5=nn(5,:);
c6=nn(6,:);
%}
imIDX1 = reshape(c1,size(GC));
imIDX2 = reshape(c2,size(GC));

imIDX3 = reshape(c3,size(GC));
imIDX4 = reshape(c4,size(GC));
%{
background=imopen(imIDX1,strel('disk',45));
imIDX1=imIDX1-background;
imIDX1=bwareaopen(imIDX1,30);

background=imopen(imIDX2,strel('disk',45));
imIDX2=imIDX2-background;
imIDX2=bwareaopen(imIDX2,30);

background=imopen(imIDX3,strel('disk',45));
imIDX3=imIDX3-background;
imIDX3=bwareaopen(imIDX3,30);

background=imopen(imIDX4,strel('disk',45));
imIDX4=imIDX4-background;
imIDX4=bwareaopen(imIDX4,30);
%}
%{
imIDX5 = reshape(c5,size(GC));
imIDX6 = reshape(c6,size(GC));


imIDX1=imerode(imIDX1,strel('disk',10));
imIDX1=imdilate(imIDX1,strel('disk',10));

imIDX2=imerode(imIDX2,strel('disk',10));
imIDX2=imdilate(imIDX2,strel('disk',10));

imIDX3=imerode(imIDX3,strel('disk',10));
imIDX3=imdilate(imIDX3,strel('disk',10));

imIDX4=imerode(imIDX4,strel('disk',0));
imIDX4=imdilate(imIDX4,strel('disk',30));

imIDX5=imerode(imIDX5,strel('disk',40));
imIDX5=imdilate(imIDX5,strel('disk',30));

imIDX6=imerode(imIDX6,strel('disk',40));
imIDX6=imdilate(imIDX6,strel('disk',30));

%}
figure;

subplot(2,3,1),imshow(imIDX1),title('cluster 1');
subplot(2,3,2),imshow(imIDX2),title('cluster 2');

subplot(2,3,3),imshow(imIDX3),title('cluster 3');
subplot(2,3,4),imshow(imIDX4),title('cluster 4');
%{
subplot(2,3,5),imshow(imIDX5),title('cluster 5');
subplot(2,3,6),imshow(imIDX6),title('cluster 6');
%}














