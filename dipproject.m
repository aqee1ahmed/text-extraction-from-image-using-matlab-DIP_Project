% Read the input image
img = imread('example2.png');

% Convert the image to grayscale
gray_img = rgb2gray(img);

% Enhance the contrast of the grayscale image
enhanced_img = imadjust(gray_img);

% Apply median filtering to remove noise
filtered_img = medfilt2(enhanced_img);

% Convert the image to double type
double_img = im2double(filtered_img);

% Threshold the image to obtain a binary image
threshold = graythresh(double_img);
binary_img = imbinarize(double_img, threshold);

% Invert the binary image to obtain black text on white background
inverted_img = imcomplement(binary_img);

% Extract MSER features from the image
mser_regions = detectMSERFeatures(inverted_img);

% Refine the MSER regions using geometric properties
mser_regions_refined = detectMSERFeatures(inverted_img, 'RegionAreaRange',[60,100000], 'ThresholdDelta',1.5);

% Extract the text from the refined MSER regions using OCR
mser_boxes = mser_regions_refined.PixelList;
mser_boxes = cell2mat(mser_boxes); % Convert to matrix
x = min(mser_boxes(:,1));
y = min(mser_boxes(:,2));
width = max(mser_boxes(:,1)) - x;
height = max(mser_boxes(:,2)) - y;
bbox = [x y width height];

ocr_results = ocr(inverted_img, bbox, 'TextLayout', 'Block', 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');

% Display the images in a subplot window
figure;
subplot(2, 4, 1); imshow(img); title('Original Image');
subplot(2, 4, 2); imshow(gray_img); title('Grayscale Image');
subplot(2, 4, 3); imshow(enhanced_img); title('Contrast Enhanced Image');
subplot(2, 4, 4); imshow(filtered_img); title('Median Filtered Image');
subplot(2, 4, 5); imshow(binary_img); title('Binary Image');
subplot(2, 4, 6); imshow(inverted_img); title('Inverted Binary Image');

% Check if the OCR results are not empty
if ~isempty(ocr_results.Text)
   % Display the extracted text
   disp(ocr_results.Text);
else
   % Handle the case when the text is not found
   disp('Text not found in the image');
end