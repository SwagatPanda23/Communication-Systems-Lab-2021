
image_name = imread('Time Domain Plot - Channel 1.jpg');
image_binary = dec2bin(image_name);

image_size = size(image_name);
disp = reshape(image_binary',1,[])