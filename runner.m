im1 = double(rgb2gray(imread('./eval-data/Army/frame10.png')))/255;
im2 = double(rgb2gray(imread('./eval-data/Army/frame11.png')))/255;

im1 = imresize(im1, 0.2);
im2 = imresize(im2, 0.2);

[u, v] = GetFlow(im1, im2);
imshow(VisualizeFlow(u, v));