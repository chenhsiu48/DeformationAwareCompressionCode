function [ img_num ] = choose_image(files) 
img_num = 0;
disp('Chose an image from the list below:');
while (~isnumeric(img_num) || img_num<1 || img_num>length(files)-2)
  for i = 3:length(files)
     disp([num2str(i-2) ' - ' files(i).name(1:end-4)]);  
  end
  img_num = input(sprintf('chose an image (%d-%d): ', 1, length(files)-2), 's');
  img_num = sscanf(img_num, '%d');
end
img_num = img_num+2;

end

