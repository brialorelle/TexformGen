
% check my templates;
clc;
disp('comparing imaage names for your INPUT/TEMPLATE folders');
[images,numim,imname] = readImages('SHINE_INPUT','jpg');
[images2,numim2,imname2] = readImages('SHINE_TEMPLATE','jpg');
imname
imname2
for i=1:length(imname)
    if ~(strcmp(imname{i},imname2{i}))
        imname{i},imname2{i}
        keyboard;
    end
end
disp('yay...their file names match');