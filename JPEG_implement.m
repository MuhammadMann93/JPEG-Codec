clear all
clc  

I = imread('peppers.png');

% convert the image from RGB into ycbcr

% quantization matrix to be later used to quantize DCT coefficients 

Q = [16 11 10 16 24 40 51 61 ;
     12 12 14 19 26 28 60 55 ;
     14 13 16 24 40 57 69 56 ;
     14 17 22 29 51 87 80 62 ;
     18 22 37 56 68 109 103 77 ;
     24 35 55 64 81 104 113 92 ;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];

%nested for-loops to divide the image matrix Y into bloacks and apply DCT &
%Quantization on them

d1 = rem(size(I,1),8);
d2 = rem(size(I,2),8);

if (d1) ~=0
   d11=8-d1;
   for i=1:d11
   white_row = 255*ones(1,size(I,2),size(I,3));
    I = [I; uint8(white_row)];

   end
end
    

if (d2) ~=0
   d22=8-d2;
   for i=1:d22
   white_col = 255*ones(size(I,1),1,size(I,3));
   I = [I uint8(white_col)];
    
   end
end

 

Y= rgb2ycbcr(I);
Y_d = Y(:,:,:);
Y_d(:,:,2) = 2*round(Y_d(:,:,2)/2);
Y_d(:,:,3) = 2*round(Y_d(:,:,3)/2);
    
 A = zeros(size(Y_d));
 B = A;

 [img_rows img_col img_dim] = size(Y_d);
 
 DC_coeff = [];
  size_ACC =[];
amplitude_ACC = [];
runLength_ACC = []; 
 
for dim = 1:3
   
    for i=1:8:size(Y_d,1)
    
        for j = 1:8:size(Y_d,2)
            
      block = Y_d(i:i+7,j:j+7,dim);
      block = double(block);
      block = dct2(block);
      block = Q.*round(block./Q);
      DC_coeff = [DC_coeff,block(1,1)];
%       AC_encoded_coeff= dctRL(block);
%       AC_encodedRes = [AC_encodedRes, AC_encoded_coeff];
      
      A(i:i+7,j:j+7,dim) =  block;     
%       block2 = idct2(block);
%       B(i:i+7,j:j+7,dim) = block2;
      
      [size_AC,amplitude_AC,runLength_AC,y] = blockAC_Encoder(block);
       size_ACC =[size_ACC,uint8(size_AC)];
      runLength_ACC = [runLength_ACC,uint8(runLength_AC)]; 
     amplitude_ACC = [amplitude_ACC,amplitude_AC];
      
        end
    end
end


DC_diff = [];
DC_diff(1) = DC_coeff(1);

for k=2:length(DC_coeff)
    
    DC_diff(k) = DC_coeff(k) - DC_coeff(k-1); 
    
end


[size_DC,amplitude_DC] = blockDC_Encoder(DC_diff);

%compressed image size

original_size = img_col*img_rows*img_dim*8;
compressed_size = 64*3 + size(size_ACC,2)*8*2 + size(size_DC,2)*8 + size(amplitude_ACC,2) + size(amplitude_DC,2);
comression_ratio = (compressed_size)/(img_col*img_rows*img_dim*8);

[DCcoeff_decoded,DCdiff_decoded,ACcoeff_decoded,decoded_img] = block_decoder(img_rows,img_col,img_dim,size_ACC,runLength_ACC, amplitude_ACC, size_DC,amplitude_DC);

 decoded_img = uint8(decoded_img);
 decoded_img = ycbcr2rgb(decoded_img);
 imshow(decoded_img);
